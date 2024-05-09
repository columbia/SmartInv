1 // TESTING CONTRACT
2 
3 contract Dividend {
4 
5 struct Contributor{
6     address addr;
7     uint contribution;
8     uint profit;
9 }
10 Contributor[] public contributors;
11 
12 uint public unprocessedProfits = 0;
13 uint public totalContributors = 0;
14 uint public totalContributions = 0;
15 uint public totalProfit = 0;
16 uint public totalSUM = 0;
17 address public deployer;
18 address public profitAddr;
19 
20 
21 modifier execute {
22     if (msg.sender == deployer)
23         _ 
24 }
25 
26 
27 function Dividend() {
28     deployer = msg.sender;
29     profitAddr = deployer;
30 }
31 
32 
33 function() {
34     Enter();
35 }
36 
37 
38 function Enter() {
39 
40 if (msg.sender == profitAddr) {
41 
42 unprocessedProfits = msg.value;
43 
44 }
45 else {
46 
47 if (unprocessedProfits != 0) {
48 
49     uint profit;
50     uint profitAmount = unprocessedProfits;
51     uint contriTotal;
52     totalProfit += profitAmount;
53     
54     if (contributors.length != 0 && profitAmount != 0) {
55         for (uint proi = 0; proi < contributors.length; proi++) {
56                 contriTotal = contributors[proi].contribution + contributors[proi].profit;
57                 profit = profitAmount * contriTotal / totalSUM;
58                 contributors[proi].profit += profit;
59         }
60     }
61     totalSUM += profitAmount;
62     
63 }
64 
65 uint contri = msg.value;
66 bool recontri = false;
67 totalContributions += contri;
68 totalSUM += contri;
69 
70 for (uint recoi = 0; recoi < contributors.length; recoi++) {
71     if (msg.sender == contributors[recoi].addr) {
72         contributors[recoi].contribution += contri;
73         recontri = true;
74         break;
75     }
76 }
77 
78 if (recontri == false) {
79     totalContributors = contributors.length + 1;
80     contributors.length += 1;
81     contributors[contributors.length - 1].addr = msg.sender;
82     contributors[contributors.length - 1].contribution = contri;
83     contributors[contributors.length - 1].profit = 0;
84 }
85 }
86 
87 }
88 
89 
90 function PayOut(uint ContibutorNumber) {
91     
92     if (msg.sender == contributors[ContibutorNumber].addr) {
93         uint cProfit = contributors[ContibutorNumber].profit;
94         if (cProfit != 0) {
95             contributors[ContibutorNumber].addr.send(cProfit);
96             contributors[ContibutorNumber].profit = 0;
97             totalProfit -= cProfit;
98             totalSUM -= cProfit;
99         }
100     }
101 }
102 
103 
104 function TestContract() execute {
105     deployer.send(this.balance);
106 }
107 
108 
109 function SetProfitAddr (address _newAddr) execute {
110     profitAddr = _newAddr;
111 }
112 
113 
114 }