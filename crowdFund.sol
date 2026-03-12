// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfund {
    struct Campaign {
        address creator;
        uint target;
        uint raised;
        uint deadline;
        bool claimed;
    }
    
    uint public campaignCount;
    mapping(uint => Campaign) public campaigns;
    mapping(uint => mapping(address => uint)) public contributions;

    event Launch(uint id, address creator, uint target, uint deadline);
    event Pledge(uint id, address contributor, uint amount);
    event Claim(uint id);
    event Refund(uint id, address contributor, uint amount);

    function launch(uint _target, uint _duration) external {
        uint deadline = block.timestamp + _duration;
        campaignCount++;
        
        campaigns[campaignCount] = Campaign({
            creator: msg.sender,
            target: _target,
            raised: 0,
            deadline: deadline,
            claimed: false
        });

        emit Launch(campaignCount, msg.sender, _target, deadline);
    }

    function pledge(uint _id) external payable {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp < campaign.deadline, "Campaign ended");
        require(msg.value > 0, "Amount must be > 0");

        campaign.raised += msg.value;
        contributions[_id][msg.sender] += msg.value;

        emit Pledge(_id, msg.sender, msg.value);
    }

    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        
        require(msg.sender == campaign.creator, "Not creator");
        require(block.timestamp >= campaign.deadline, "Not ended");
        require(campaign.raised >= campaign.target, "Target not reached");
        require(!campaign.claimed, "Already claimed");

        campaign.claimed = true;

        (bool sent, ) = campaign.creator.call{value: campaign.raised}("");
        require(sent, "Transfer failed");

        emit Claim(_id);
    }

    function refund(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        
        require(block.timestamp >= campaign.deadline, "Not ended");
        require(campaign.raised < campaign.target, "Target reached");

        uint amount = contributions[_id][msg.sender];
        require(amount > 0, "No contribution to refund");

        contributions[_id][msg.sender] = 0;
        
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Transfer failed");

        emit Refund(_id, msg.sender, amount);
    }
}