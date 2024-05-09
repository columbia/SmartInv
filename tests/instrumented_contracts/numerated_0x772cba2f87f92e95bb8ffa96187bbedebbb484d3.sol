1 contract ResetPonzi {
2 
3   struct Person {
4       address addr;
5   }
6 
7   struct NiceGuy {
8       address addr2;
9   }
10 
11   Person[] public persons;
12   NiceGuy[] public niceGuys;
13 
14   uint public payoutIdx = 0;
15   uint public currentNiceGuyIdx = 0;
16   uint public investor = 0;
17 
18   address public currentNiceGuy;
19 
20 
21   function ResetPonzi() {
22     currentNiceGuy = msg.sender;
23   }
24 
25 
26   function() {
27     enter();
28   }
29 
30 
31   function enter() {
32     if (msg.value != 9 / 10 ether) {
33         throw;
34     }
35 
36     if (investor > 8) {
37         uint ngidx = niceGuys.length;
38         niceGuys.length += 1;
39         niceGuys[ngidx].addr2 = msg.sender;
40         if (investor == 10) {
41             currentNiceGuy = niceGuys[currentNiceGuyIdx].addr2;
42             currentNiceGuyIdx += 1;
43         }
44     }
45 
46     if (investor < 9) {
47         uint idx = persons.length;
48         persons.length += 1;
49         persons[idx].addr = msg.sender;
50     }
51 
52     investor += 1;
53     if (investor == 11) {
54         investor = 0;
55     }
56 
57     currentNiceGuy.send(1 / 10 ether);
58 
59     while (this.balance > 10 / 10 ether) {
60       persons[payoutIdx].addr.send(10 / 10 ether);
61       payoutIdx += 1;
62     }
63   }
64 }