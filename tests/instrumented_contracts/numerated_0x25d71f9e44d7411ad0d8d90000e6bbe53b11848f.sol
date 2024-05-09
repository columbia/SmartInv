1 pragma solidity ^0.4.16;
2 contract Token { 
3     function issue(address _recipient, uint256 _value) returns (bool success) {} 
4     function totalSupply() constant returns (uint256 supply) {}
5     function unlock() returns (bool success) {}
6 }
7 
8 contract STARCrowdsale {
9 
10     address public creator; 
11     
12     uint256 public maxSupply = 104400000 * 10**8; 
13     uint256 public minAcceptedAmount = 1 ether; // 1 ether
14 
15     uint256 public rateAngel = 189;
16     uint256 public rateA = 93;
17     uint256 public rateB = 46;
18     uint256 public rateC = 22;
19     
20     
21     bool public close = false;
22 
23     
24     address public address1 = 0x08294159dE662f0Bd810FeaB94237cf3A7bB2A3D;
25     address public address2 = 0xAed27d4ecCD7C0a0bd548383DEC89031b7bBcf3E;
26     address public address3 = 0x41ba7eED9be2450961eBFD7C9Fb715cae077f1dC;
27     address public address4 = 0xb9cdb4CDC8f9A931063cA30BcDE8b210D3BA80a3;
28     address public address5 = 0x5aBF2CA9e7F5F1895c6FBEcF5668f164797eDc5D;
29     
30 
31     enum Stages {
32         InProgress,
33         Ended,
34         Withdrawn
35     }
36 
37     Stages public stage = Stages.InProgress;
38     
39     uint256 public raised;
40 
41 
42     Token public starToken;
43 
44 
45     mapping (address => uint256) balances;
46 
47     modifier atStage(Stages _stage) {
48         if (stage != _stage) {
49             throw;
50         }
51         _;
52     }
53     
54     modifier onlyOwner() {
55         if (creator != msg.sender) {
56             throw;
57         }
58         _;
59     }
60   
61 
62     function balanceOf(address _investor) constant returns (uint256 balance) {
63         return balances[_investor];
64     }
65 
66     function STARCrowdsale() {
67         
68         
69         starToken = Token(0x2bbf4f7b8ab300db01d45662769821da6e400ef4);
70         
71         creator = 0x6ADAfB7632859EF19d28276037581af00064d68F;
72         
73     }
74     function toSTAR(uint256 _wei) returns (uint256 amount) {
75         uint256 rate = 0;
76         if (stage != Stages.Ended) {
77             
78             
79             uint256 supply = starToken.totalSupply();
80             
81             if (supply <= 3000000 * 10**8) {
82 
83                 rate = rateAngel;
84             }
85             
86             else if (supply > 3000000 * 10**8) {
87 
88                 rate = rateA;
89             }
90             
91             else if (supply > 9000000 * 10**8) {
92 
93                 rate = rateB;
94             }
95             
96             else if (supply > 23400000 * 10**8) {
97 
98                 rate = rateC;
99             }
100 			
101            
102         }
103 
104         return _wei * rate * 10**8 / 1 ether; // 10**8 for 8 decimals
105     }
106  
107     function endCrowdsale() onlyOwner atStage(Stages.InProgress) {
108 
109     
110         stage = Stages.Ended;
111     }
112     
113     function setOwner(address _newowner) onlyOwner {
114 
115         creator = _newowner;
116     }
117 
118 
119     function withdraw() onlyOwner atStage(Stages.Ended) {
120 
121         creator.transfer(this.balance);
122 
123         stage = Stages.Withdrawn;
124     }
125     
126     function close() onlyOwner{
127 
128        close = true;
129     }
130 
131     function () payable atStage(Stages.InProgress) {
132 
133             
134         if (msg.value < minAcceptedAmount) {
135             throw;
136         }
137         
138         if(close == true){
139             throw;
140         }
141  
142         uint256 received = msg.value;
143         uint256 valueInSCL = toSTAR(msg.value);
144 
145 
146         if (valueInSCL == 0) {
147             throw;
148         }
149 
150         if (!starToken.issue(msg.sender, valueInSCL)) {
151             throw;
152         }
153 
154         address1.transfer(received/5);
155         address2.transfer(received/5);
156         address3.transfer(received/5);
157         address4.transfer(received/5);
158         address5.transfer(received/5);
159 
160         raised += received;
161 
162         if (starToken.totalSupply() >= maxSupply) {
163             stage = Stages.Ended;
164         }
165     }
166 }