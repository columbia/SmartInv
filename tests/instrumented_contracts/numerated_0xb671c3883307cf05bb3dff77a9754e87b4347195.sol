1 contract HFConditionalTransfer {
2     function transferIfHF(address to) {
3         if (address(0xbf4ed7b27f1d666546e30d74d50d173d20bca754).balance > 1000000 ether)
4             to.send(msg.value);
5         else
6             msg.sender.send(msg.value);
7     }
8     function transferIfNoHF(address to) {
9         if (address(0xbf4ed7b27f1d666546e30d74d50d173d20bca754).balance <= 1000000 ether)
10             to.send(msg.value);
11         else
12             msg.sender.send(msg.value);
13     }
14 }