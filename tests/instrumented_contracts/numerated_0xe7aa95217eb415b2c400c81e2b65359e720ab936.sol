1 contract Switch {
2     address constant theWithdraw = 0xbf4ed7b27f1d666546e30d74d50d173d20bca754;
3     function Switch() {
4         forked = theWithdraw.balance > 10000 ether;
5     }
6     
7     function transferringETC(address to) {
8         if (forked)
9             throw;
10         if (!to.send(msg.value))
11             throw;
12     }
13 
14     function transferringETH(address to) {
15         if (!forked)
16             throw;
17         if (!to.send(msg.value))
18             throw;
19     }
20     
21     bool public forked;
22 }