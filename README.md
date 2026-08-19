# ALFA VALVES MRP System v3.0
**PT. ALFA VALVES INDONESIA** — Production Database & Dashboard (PC + Mobile)

Aplikasi web full-stack: dashboard produksi + database terpusat dengan **live sync** antar perangkat.

---

## 1. Cara Menjalankan

```bash
cd alfa-mrp
npm install          # sekali saja
npm start            # jalankan server
```

**Tanpa hak Administrator?** Bisa. Pakai Node.js versi ZIP (portable),
ekstrak ke folder `nodejs/` di dalam folder aplikasi. Lihat PANDUAN-INSTALASI.md.
Jika `better-sqlite3` gagal dipasang, aplikasi otomatis memakai mesin
JavaScript murni tanpa kehilangan fitur apa pun.

Buka `http://localhost:3000`

### Akses dari HP / komputer lain (satu jaringan WiFi kantor)
1. Cek IP komputer server: `ipconfig` (Windows) atau `ip a` (Linux)
2. Di HP buka: `http://192.168.1.xx:3000` (ganti dengan IP server)
3. Chrome/Safari → menu → **"Add to Home Screen"** → aplikasi jadi seperti app native (PWA)

Semua perangkat yang membuka alamat itu otomatis **tersinkron real-time**.

---

## 2. Struktur

```
alfa-mrp/
├── server/
│   ├── index.js        REST API + WebSocket server
│   ├── storage.js      Pemilih mesin otomatis
│   ├── db.js           Mesin SQLite (WAL) - cepat, butuh modul native
│   └── storage-json.js Mesin JavaScript murni - tanpa modul native
├── public/
│   ├── index.html      Shell aplikasi (viewport mobile, PWA)
│   ├── css/app.css     Desain asli dari file Anda
│   ├── css/mobile.css  Perbaikan responsif PC/tablet/HP
│   ├── js/app-core.js  10 modul MRP (logika asli Anda)
│   ├── js/alfa-sync.js Layer live-sync + offline queue
│   ├── vendor/         ECharts + SheetJS (lokal, tanpa internet)
│   ├── sw.js           Service worker (offline)
│   └── manifest.webmanifest
└── data/
    ├── alfa_mrp.db     ← DATABASE UTAMA (backup file ini!)
    └── backups/        Auto-backup tiap 6 jam (30 versi terakhir)
```

---

## 3. Perintah Perawatan

```bash
npm run backup      # backup manual sekarang
npm run stats       # lihat jumlah baris & ukuran DB
npm run integrity   # cek kesehatan database (harus "ok")
npm run vacuum      # kompres file DB setelah banyak penghapusan
```

---

## 4. Keamanan (opsional)

Default: **tanpa login** (mode LAN, cocok untuk jaringan internal pabrik).

Untuk mengaktifkan login:

```bash
ALFA_AUTH=1 ALFA_ADMIN_PW=passwordAnda npm start
```

User `admin` otomatis dibuat pada boot pertama. Role: `admin` / `operator`.

---

## 5. API

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/api/state` | Ambil seluruh data |
| POST | `/api/sync` | Sinkron banyak tabel (diff-based) |
| POST | `/api/sync/:collection` | Sinkron satu tabel |
| PUT | `/api/record/:collection` | Tambah/ubah 1 baris |
| DELETE | `/api/record/:collection/:id` | Hapus 1 baris (soft delete) |
| GET | `/api/changes?since=N` | Delta sejak revisi N |
| GET | `/api/health` | Status server + ukuran DB |
| GET | `/api/audit?limit=100` | Riwayat perubahan (siapa/kapan) |
| POST | `/api/backup` | Buat backup |
| GET | `/api/export/json` | Export seluruh database ke JSON |
| WS | `/ws` | Channel live sync |

---

## 6. Kapasitas (hasil uji nyata)

| Uji | Hasil |
|---|---|
| Insert 50.000 baris (payload 11 MB) | **1.044 ms** |
| Re-sync data identik | 444 ms, **0 tulisan** (diff bekerja) |
| Update 100 dari 50.000 baris | 496 ms, hanya 100 baris ditulis |
| Baca seluruh state | 451 ms |
| Ukuran DB @50.000 baris | 35,7 MB |
| Backup 35 MB | 79 ms |
| Restart server | data utuh, integrity `ok` |
| **Mesin JS murni** — 20.000 baris | **357 ms** |
| **Mesin JS murni** — kill -9 (mati listrik) | data pulih utuh, integrity `ok` |

Batas teoritis SQLite: **281 TB** per file. Untuk skala PT. Alfa Valves, praktis tanpa batas.

---

## 7. Migrasi ke PostgreSQL (jika suatu saat perlu)

Struktur `server/db.js` sengaja diisolasi. Jika nanti butuh multi-lokasi via internet,
cukup ganti isi `db.js` ke PostgreSQL — API dan frontend tidak perlu diubah.
Export data lewat `GET /api/export/json` sebagai jalur migrasi.
