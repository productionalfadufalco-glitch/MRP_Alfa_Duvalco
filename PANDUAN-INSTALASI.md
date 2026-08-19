# PANDUAN INSTALASI
## ALFA VALVES MRP System v3.0
### PT. ALFA VALVES INDONESIA

---

## LANGKAH 1 — Pilih Komputer Server

Pilih **satu** komputer yang akan menyimpan database. Biasanya PC di ruang PPIC
atau Produksi yang menyala saat jam kerja.

> **Penting:** Komputer ini harus menyala selama aplikasi dipakai perangkat lain,
> karena semua data tersimpan di sini.

---

## LANGKAH 2 — Install Node.js (sekali saja)

### Punya hak Administrator?
1. Buka https://nodejs.org
2. Download versi **LTS** (tombol hijau), jalankan installer, klik Next sampai selesai
3. Restart komputer

### TIDAK punya hak Administrator? Tetap bisa — pakai versi ZIP

Node.js menyediakan versi **portable (ZIP)** yang tidak perlu diinstall
dan tidak meminta hak Administrator sama sekali.

1. Buka https://nodejs.org/en/download/prebuilt-binaries
2. Pilih: **Windows**, arsitektur **x64**, format **ZIP**
   (nama file mirip `node-v22.x.x-win-x64.zip`)
3. Ekstrak isinya ke dalam folder aplikasi, sehingga strukturnya menjadi:

```
C:\ALFA-MRP\
├── nodejs\
│   ├── node.exe        <-- file ini harus ada
│   └── npm.cmd
├── server\
├── public\
└── START-WINDOWS.bat
```

> Perhatikan: isi ZIP biasanya terbungkus satu folder bernama
> `node-v22.x.x-win-x64`. Pindahkan **isi** folder itu ke `nodejs\`,
> bukan foldernya. Pastikan `nodejs\node.exe` benar-benar ada.

4. Selesai. `START-WINDOWS.bat` otomatis mendeteksi folder `nodejs\`
   dan memakainya tanpa perlu mengubah PATH atau minta izin IT.

Cek berhasil: buka Command Prompt di folder aplikasi, ketik `nodejs\node -v`.
Jika muncul misal `v22.11.0`, berarti sukses.

---

## LANGKAH 3 — Ekstrak & Jalankan

1. Ekstrak `alfa-mrp-v3.zip` ke lokasi permanen, contoh `C:\ALFA-MRP`

   > Jangan taruh di Desktop atau folder Download — nanti mudah terhapus.
   > Di dalamnya ada database perusahaan Anda.

2. **Windows:** klik dua kali **`START-WINDOWS.bat`**
   **Linux/Mac:** jalankan `bash START-LINUX-MAC.sh`

3. Saat pertama kali, akan muncul `[SETUP] Memasang dependensi...`
   Tunggu 1–3 menit (butuh internet **hanya saat ini**). Setelah itu selamanya offline.

4. Browser terbuka otomatis ke `http://localhost:3000`

Jendela hitam (Command Prompt) **jangan ditutup** selama aplikasi dipakai.

---

## LANGKAH 4 — Akses dari HP / Komputer Lain

Di layar Command Prompt, cari baris `IPv4 Address`, contoh:

```
IPv4 Address. . . . . . . . . . . : 192.168.1.10
```

Di HP (pastikan tersambung **WiFi kantor yang sama**), buka browser:

```
http://192.168.1.10:3000
```

Ganti angka sesuai yang muncul di layar Anda.

### Pasang sebagai aplikasi di HP
- **Android/Chrome:** menu ⋮ → *Add to Home screen*
- **iPhone/Safari:** tombol Share → *Add to Home Screen*

Ikon ALFA muncul di layar HP, terbuka layar penuh seperti aplikasi biasa.

---

## LANGKAH 5 — Verifikasi Live Sync

1. Buka aplikasi di PC **dan** di HP bersamaan
2. Perhatikan badge kanan atas: harus tertulis **LIVE · 2**
3. Di PC, tambah satu data di menu *Detail Project*
4. Data muncul di HP dalam ~2 detik **tanpa refresh**

Jika berhasil, sistem sudah berjalan penuh.

---

## MENJALANKAN OTOMATIS SAAT KOMPUTER MENYALA (opsional)

1. Tekan `Win + R`, ketik `shell:startup`, Enter
2. Klik kanan `START-WINDOWS.bat` → **Create shortcut**
3. Pindahkan shortcut tersebut ke folder Startup yang tadi terbuka

Server akan hidup otomatis setiap komputer dinyalakan.

---

## BACKUP — WAJIB DIBACA

Seluruh data perusahaan ada di **satu file**:

```
alfa-mrp/data/alfa_mrp.db
```

Sistem sudah otomatis membuat backup tiap 6 jam ke `data/backups/`
(30 versi terakhir disimpan).

**Tetap lakukan backup eksternal:** salin folder `data/` ke flashdisk atau
Google Drive **seminggu sekali**. Backup otomatis tidak melindungi dari
hardisk rusak atau komputer hilang.

Cara backup manual kapan saja:
- Klik badge **LIVE** di aplikasi → tombol **↓ Backup Sekarang**
- Atau tombol **↓ Export JSON** untuk arsip yang bisa dibuka di Excel/editor teks

---

## PERINTAH PERAWATAN

Buka Command Prompt di folder aplikasi:

| Perintah | Fungsi |
|---|---|
| `npm run stats` | Lihat jumlah baris & ukuran database |
| `npm run backup` | Backup manual |
| `npm run integrity` | Cek kesehatan database (harus muncul `ok`) |
| `npm run vacuum` | Kompres file setelah banyak penghapusan data |

Disarankan menjalankan `npm run integrity` sebulan sekali.

---

## MENGAKTIFKAN LOGIN (opsional)

Default tanpa login, cocok untuk jaringan internal pabrik.

Untuk mengaktifkan, jalankan lewat Command Prompt:

```
set ALFA_AUTH=1
set ALFA_ADMIN_PW=passwordRahasiaAnda
npm start
```

User `admin` dibuat otomatis dengan password tersebut.

---

## MENGATASI MASALAH

**Badge tertulis OFFLINE (merah)**
Server mati atau HP beda jaringan. Pastikan jendela Command Prompt di PC server
masih terbuka, dan HP memakai WiFi kantor (bukan data seluler).

**HP tidak bisa membuka alamat**
Firewall Windows memblokir. Buka *Windows Defender Firewall* → *Allow an app* →
centang **Node.js** untuk jaringan Private.

**Port 3000 sudah dipakai**
Jalankan dengan port lain: `set PORT=4000` lalu `npm start`, akses via `:4000`.

**Data terlihat berbeda antar perangkat**
Klik badge LIVE → **↻ Muat Ulang** untuk menarik ulang data dari server.

**Ingin mulai dari data kosong**
Hentikan server, hapus file di folder `data/`, jalankan lagi. Data contoh akan dibuat ulang.

---

## DUA MESIN DATABASE (otomatis)

Aplikasi punya dua mesin penyimpanan dan memilih sendiri saat dijalankan:

| Mesin | Kapan dipakai | Kecepatan |
|---|---|---|
| **SQLite** (native) | Jika modul `better-sqlite3` berhasil terpasang | 50.000 baris / 1 detik |
| **JavaScript murni** | Otomatis dipakai jika SQLite gagal dipasang | 20.000 baris / 0,36 detik |

Mesin JavaScript murni dipakai otomatis pada PC tanpa hak Administrator,
tanpa compiler C++, atau bila jaringan kantor memblokir unduhan file biner.
**Tidak ada fitur yang hilang** — live sync, audit log, backup, dan Excel
tetap berjalan penuh. Data tetap tahan mati listrik (sudah diuji dengan
mematikan proses paksa; seluruh data pulih utuh).

Saat start, layar menampilkan mesin yang dipakai, contoh:
`Size : 0 B | rev 0 | engine=pure-js`

Ingin memaksa mesin JavaScript murni? Jalankan: `npm run start:json`

---

## CATATAN TEKNIS

- Database: SQLite mode WAL — teruji **50.000 baris tersimpan dalam 1 detik**, batas file 281 TB
- Setiap perubahan tercatat di audit log (siapa, kapan, data sebelum & sesudah)
- Aplikasi tetap bisa dipakai saat WiFi putus; perubahan otomatis terkirim saat tersambung kembali
- Grafik & Excel bekerja tanpa internet (library tersimpan lokal)
