# MovieMania

MovieMania adalah aplikasi Flutter yang memungkinkan pengguna untuk menjelajahi film-film populer, mencari film, dan mengelola daftar tontonan serta daftar film yang telah ditonton. Aplikasi ini menggunakan API dari The Movie Database (TMDb).

Proyek ini dikerjakan oleh kelompok 2 yang beranggotakan: Sayyid Faruk Romdoni, Mahesa Al Zidane Putra Fedy, Adie Subarkah

## Fitur

- **Beranda**: Menampilkan daftar film populer.
- **Pencarian**: Cari film berdasarkan judul.
- **Daftar Tontonan**: Tambahkan film ke daftar tontonan.
- **Film yang Sudah Ditonton**: Tandai film yang sudah ditonton.
- **Penyimpanan Lokal**: Daftar tontonan dan film yang sudah ditonton disimpan di penyimpanan lokal.
- **Switch View**: Beralih antara tampilan daftar dan grid untuk daftar film.
- **Ikon Khusus**: Ikon yang berbeda untuk menandai film yang ada di daftar tontonan dan film yang sudah ditonton.

## Screenshot Aplikasi

## Instalasi

1. Clone repositori ini:

   ```bash
   git clone https://github.com/username/moviemania.git
   cd moviemania
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Buat file `.env` di root direktori proyek dan tambahkan API key Anda dari TMDb:

   ```env
   TMDB_API_KEY=YOUR_API_KEY_HERE
   ```

4. Jalankan aplikasi:

   ```bash
   flutter run
   ```

## Dependensi

- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- [http](https://pub.dev/packages/http)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
