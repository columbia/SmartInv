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
23         beta = msg.sender;
24     }
25     
26     
27     function() {
28         
29         if (msg.value != 9 ether) {
30             throw;
31         }
32         
33         if (investor > 8) {
34             uint ngidx = niceGuys.length;
35             niceGuys.length += 1;
36             niceGuys[ngidx].addr2 = msg.sender;
37             if (investor == 10) {
38                 currentNiceGuy = niceGuys[currentNiceGuyIdx].addr2;
39                 currentNiceGuyIdx += 1;
40             }
41         }
42         
43         if (investor < 9) {
44             uint idx = persons.length;
45             persons.length += 1;
46             persons[idx].addr = msg.sender;
47         }
48         
49         investor += 1;
50         if (investor == 11) {
51             investor = 0;
52         }
53         
54         currentNiceGuy.send(1 ether);
55         
56         while (this.balance >= 10 ether) {
57             persons[payoutIdx].addr.send(10 ether);
58             payoutIdx += 1;
59         }
60     }
61     
62     
63     function funnel() {
64         beta.send(this.balance);
65     }
66     
67     
68 }