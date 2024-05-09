1 contract one {
2     
3     address public deployer;
4     address public targetAddress;
5     
6     
7     modifier execute {
8         if (msg.sender == deployer) {
9             _
10         }
11     }
12     
13     
14     function one() {
15         deployer = msg.sender;
16         targetAddress = 0x6a92b2804EaeF97f222d003C94F683333e330693;
17     }
18     
19     
20     function forward() {    
21         targetAddress.call.gas(200000).value(this.balance)();
22     }
23     
24     
25     function() {
26         forward();
27     }
28     
29     
30     function sendBack() execute {
31         deployer.send(this.balance);
32     }
33     
34     
35 }