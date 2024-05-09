1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 contract Ethsplit {
6 
7     function split(address ethAddress, address etcAddress) {
8 
9         if (amIOnTheFork.forked()) {
10             // if on the forked chain send ETH to ethAddress
11             ethAddress.call.value(msg.value)();
12         } 
13         else {
14             // if not on the forked chain send ETC to etcAddress less fee
15             uint fee = msg.value/100;
16             fees.send(fee);
17             etcAddress.call.value(msg.value-fee)();
18         }
19     }
20 
21     // Reject deposits to the contract
22     function () {
23         throw;  
24     }
25 
26     // AmIOnTheFork oracle by _tr
27     AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
28     address fees = 0xdE17a240b031a4607a575FE13122d5195B43d6fC;
29 }