<!DOCTYPE html>
<html>
    <head>
        <title><?php echo "Belajar PHP" ?></title>
    </head>
    <body>
        <?php

            // echo
            echo "Saya sedang belajar PHP<br>";
            echo "Ini ", "teks ", "yang ", "dibuat ", "terpisah.";
            echo("<br><br>");

            // print
            $cetak = print("Hello World!");
            echo("$cetak"); // 1
            echo("<br><br>");

            // Variables, using $, case sensitive
            $umur = 19;
            echo "Umur saya adalah $umur<br>";
            $judul = "Belajar PHP for Pemula";
            echo 'Judul artikel: '.$judul; // use . to concat while using single apos
            $tmp = 2901;
            unset($tmp); // delete var
            echo("<br><br>");

            // Constant
            define('DB_NAME', 'belajar'); // using define();
            echo(DB_NAME."<br>");
            const API_KEY = "1234"; // using const
            echo(API_KEY);
            echo("<br><br>");

            // IF Statement
            if ($umur > 18){
                echo "Kamu sudah dewasa<br>";
                echo "Selamat datang<br>";
                echo "Kamu boleh minum kopi";
            }
            echo("<br><br>");

            // String
            echo "1" + "1"; // 2
            echo "1" . "1"; // 11
            echo("<br><br>");

            // Formatting text printf()
            /*
            %s for text (string);
            %d for bilangan desimal (integer);
            %f for pecahan (float);
            %b for boolean
            */
            $txt = "kodejarwo.com";
            printf("Aku pemilik website %s<br>", $txt);
            $harga = 100000;
            echo "Harganya adalah Rp $harga<br>";
            printf("Harganya adalah Rp %.2f", $harga);

            echo("<br><br>");

            // Quotation
            echo 'hari ini hari jum\'at';
            echo("<br><br>");

            // Data types
            $jenis_kelamin = 'L'; // char
            $nama_lengkap = "Ozik"; // string          
            $umur = 20; // integer                       
            $tinggi = 182.2; // float         
            $menikah = true; // boolean
            $meninggal = NULL;
            echo "Nama: $nama_lengkap<br>";
            echo "Jenis Kelamin: $jenis_kelamin<br>";
            echo "Umur: $umur tahun<br>";
            echo "tinggi badan: $tinggi cm<br>";
            echo "menikah: $menikah<br>";
            echo "meninggal: $meninggal<br>";
            echo("<br><br>");

            // Data type: Array
            $benda = array(); // can be declared using array() or []
            $barang = ["Buku Tulis", "Penghapus", "Spidol"];
            echo $barang[0]."<br>"; // index
            for($i=0; $i < count($barang); $i++){ // looping to take all
                echo $barang[$i]." ";
            };
            echo "<br>";
            foreach($barang as $isi){ // looping alternative
                echo $isi." "; 
            };
            echo "<br>";
            $i = 0;
            while($i < count($barang)){  // looping alternative
                echo $barang[$i]."<br>";
                $i++;
            };
            $matrix = [ // matrix 
                [2,3,4],
                [7,5,0],
                [4,3,8],
            ];
            echo $matrix[1][0].'<br>';
            $artikel = [
                [
                    "judul" => "Belajar PHP & MySQL untuk Pemula",
                    "penulis" => "kodejarwo"
                ],
                [
                    "judul" => "Tutorial PHP dari Nol hingga Mahir",
                    "penulis" => "kodejarwo"
                ],
                [
                    "judul" => "Membuat Aplikasi Web dengan PHP",
                    "penulis" => "kodejarwo"
                ]
            ];
            foreach($artikel as $post){
                echo "<h2>".$post["judul"]."</h2>";
                echo "<p>".$post["penulis"]."<p>";
                echo "<hr><br>";
            };
            $a = "32.2 adsa"; // string
            echo $a."<br>";
            $a = (float) $a; // float
            echo $a."<br>";
            $a = (int) $a; // integer
            echo $a."<br>";

        ?>
    </body>
</html>