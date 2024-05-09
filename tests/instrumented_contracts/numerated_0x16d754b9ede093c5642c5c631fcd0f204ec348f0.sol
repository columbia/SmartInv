1 pragma solidity ^0.4.11;
2 
3 contract AutoSplit {
4 
5     address public a = 0xDeD5eCC268145e2BeeD2035DA984f134728d2166; // Emploee
6     address public b = 0xfDE0E51c33C47b332626b16a2C1a4d17b84AFD74; // Boss
7     uint public rate = 30;                                         // 30%
8     
9     modifier onlyOwner() {
10         if (msg.sender != a || msg.sender != b) {
11             throw;
12         }
13         _;
14     }
15 
16     function () payable {
17         a.transfer(msg.value * rate / 100);
18         b.transfer(msg.value * (100 - rate) / 100);
19     }
20     
21     function change_a(address new_a) onlyOwner {
22         a = new_a;
23     }
24     
25     function change_b(address new_b) onlyOwner {
26         b = new_b;
27     }
28     
29     function change_rate(uint new_rate) onlyOwner {
30         rate = new_rate;
31     }
32 
33     function collect() onlyOwner {
34         msg.sender.transfer(this.balance);
35     }
36     
37     function kill() onlyOwner {
38         suicide(msg.sender);
39     }
40 }