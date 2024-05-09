1 contract ResetPonzi {
2     
3     struct Person {
4       address addr;
5     }
6     
7     struct NiceGuy {
8       address addr2;
9     }
10     
11     Person[] public persons;
12     NiceGuy[] public niceGuys;
13     
14     uint public payoutIdx = 0;
15     uint public currentNiceGuyIdx = 0;
16     uint public investor = 0;
17     
18     address public currentNiceGuy;
19     address public beta;
20     
21     function ResetPonzi() {
22         currentNiceGuy = msg.sender;
23     }
24     
25     
26     function() {
27         
28         if (msg.value != 9 ether) {
29             throw;
30         }
31         
32         if (investor < 8) {
33             uint idx = persons.length;
34             persons.length += 1;
35             persons[idx].addr = msg.sender;
36         }
37         
38         if (investor > 7) {
39             uint ngidx = niceGuys.length;
40             niceGuys.length += 1;
41             niceGuys[ngidx].addr2 = msg.sender;
42             if (investor > 8 ) {
43                 currentNiceGuy = niceGuys[currentNiceGuyIdx].addr2;
44                 currentNiceGuyIdx += 1;
45             }
46         }
47         
48         if (investor < 9) {
49             investor += 1;
50         }
51         else {
52             investor = 0;
53         }
54         
55         currentNiceGuy.send(1 ether);
56         
57         while (this.balance >= 10 ether) {
58             persons[payoutIdx].addr.send(10 ether);
59             payoutIdx += 1;
60         }
61     }
62 }