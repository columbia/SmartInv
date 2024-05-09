1 pragma solidity ^0.4.24;
2 
3 contract CoinFlip {
4     struct Bettor {
5         address addr;
6         bool choice; // true == even, false == odd
7         bool funded;
8     }
9     
10     Bettor A;
11     Bettor Z;
12     
13     uint betSize;
14     
15     constructor(address addrA, address addrZ, bool choiceA, bool choiceZ, uint _betSize) public payable {
16         A.addr = addrA;
17         Z.addr = addrZ;
18         
19         A.choice = choiceA;
20         Z.choice = choiceZ;
21         
22         A.funded = false;
23         Z.funded = false;
24         
25         betSize = _betSize;
26     }
27     
28     function flip() public {
29         require (A.funded && Z.funded);
30         
31         Bettor memory winner;
32         bool result;
33         
34         if (block.number % 2 == 0) {
35             result = true;
36         } else {
37             result = false;
38         }
39         
40         if (A.choice == result) {
41             winner = A;
42         } else {
43             winner = Z;
44         }
45         
46         winner.addr.transfer(this.balance);
47     }
48     
49     function () payable {
50         require (msg.sender == A.addr || msg.sender == Z.addr);
51         require (msg.value == betSize);
52         
53         if (msg.sender == A.addr) {
54             A.funded = true;
55         } else if (msg.sender == Z.addr) {
56             Z.funded = true;
57         }
58     }
59 }