#  Decentralized Crowdfunding

Platform penggalangan dana terdesentralisasi yang dibangun di atas **Ethereum Network**. Proyek ini mendemonstrasikan kekuatan Smart Contract dalam menggantikan perantara pihak ketiga dengan logika yang transparan dan *trustless*.

##  Fitur Utama
- **Transparency:** Semua transaksi tercatat secara on-chain dan dapat diverifikasi siapa saja.
- **Automated Refund:** Jika target dana tidak tercapai hingga deadline, contributor dapat menarik kembali (refund) dana mereka secara otomatis.
- **Security:** Menggunakan pola *Checks-Effects-Interactions* untuk mencegah serangan reentrancy.
- **Access Control:** Hanya pembuat campaign (creator) yang bisa mengklaim dana jika target terpenuhi.

##  Konsep Web3 yang Diuji
* **Struct & Mapping:** Mengelola data campaign dan kontribusi user secara efisien.
* **Payable Functions:** Menangani pengiriman dan penerimaan Ether (ETH).
* **Time-based Logic:** Menggunakan `block.timestamp` untuk menentukan status campaign.
* **Events:** Memberikan log aktivitas untuk transparansi penuh.

##  Cara Menjalankan (Testing di Remix IDE)

### 1. Persiapan
- Buka [Remix IDE](https://remix.ethereum.org/).
- Buat file baru bernama `Crowdfund.sol` dan paste kodenya.
- Compile menggunakan versi Solidity `^0.8.20`.

### 2. Deployment
- Di tab **Deploy & Run Transactions**, pilih Environment **Remix VM** (untuk test cepat) atau **Injected Provider - MetaMask** (untuk Sepolia Testnet).
- Klik **Deploy**.

### 3. Alur Testing (Success Scenario)
1.  **Launch:** Masukkan `_target` (dalam Wei, misal: `1000000000000000000` untuk 1 ETH) dan `_duration` (dalam detik, misal: `300`).
2.  **Pledge:** Ganti akun/wallet, masukkan jumlah ETH di kolom **Value**, masukkan `_id` campaign, lalu klik `pledge`.
3.  **Wait for Deadline:** Tunggu hingga durasi berakhir. (Di Remix VM, gunakan fitur *Add Time*).
4.  **Claim:** Kembali ke akun Creator, panggil fungsi `claim`. Dana akan masuk ke wallet Creator.

### 4. Alur Testing (Failure/Refund Scenario)
1.  Ulangi langkah **Launch** dengan target yang besar.
2.  Lakukan **Pledge** namun jangan sampai memenuhi target.
3.  Tunggu hingga **Deadline** terlewati.
4.  **Refund:** Gunakan akun Contributor untuk memanggil fungsi `refund`. Saldo akan kembali ke wallet masing-masing.
