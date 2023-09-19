clear
rm syncnode.py
curl -o syncnode.py -LJO https://github.com/jacklevin74/xenminer/raw/main/syncnode.py
echo
echo "Start sync"
while sleep 60; do python3 syncnode.py YOUR_ETH_ADRESS; done
