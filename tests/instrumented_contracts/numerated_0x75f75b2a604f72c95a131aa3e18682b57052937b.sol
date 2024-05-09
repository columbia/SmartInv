1 /* ==================================================================== */
2 /* Copyright (c) 2018 The ether.online Project.  All rights reserved.
3 /* 
4 /* https://ether.online  The first RPG game of blockchain 
5 /*  
6 /* authors rickhunter.shen@gmail.com   
7 /*         sesunding@gmail.com            
8 /* ==================================================================== */
9 
10 pragma solidity ^0.4.20;
11 
12 contract AccessAdmin {
13     bool public isPaused = false;
14     address public addrAdmin;  
15 
16     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
17 
18     function AccessAdmin() public {
19         addrAdmin = msg.sender;
20     }  
21 
22 
23     modifier onlyAdmin() {
24         require(msg.sender == addrAdmin);
25         _;
26     }
27 
28     modifier whenNotPaused() {
29         require(!isPaused);
30         _;
31     }
32 
33     modifier whenPaused {
34         require(isPaused);
35         _;
36     }
37 
38     function setAdmin(address _newAdmin) external onlyAdmin {
39         require(_newAdmin != address(0));
40         AdminTransferred(addrAdmin, _newAdmin);
41         addrAdmin = _newAdmin;
42     }
43 
44     function doPause() external onlyAdmin whenNotPaused {
45         isPaused = true;
46     }
47 
48     function doUnpause() external onlyAdmin whenPaused {
49         isPaused = false;
50     }
51 }
52 
53 contract AccessService is AccessAdmin {
54     address public addrService;
55     address public addrFinance;
56 
57     modifier onlyService() {
58         require(msg.sender == addrService);
59         _;
60     }
61 
62     modifier onlyFinance() {
63         require(msg.sender == addrFinance);
64         _;
65     }
66 
67     function setService(address _newService) external {
68         require(msg.sender == addrService || msg.sender == addrAdmin);
69         require(_newService != address(0));
70         addrService = _newService;
71     }
72 
73     function setFinance(address _newFinance) external {
74         require(msg.sender == addrFinance || msg.sender == addrAdmin);
75         require(_newFinance != address(0));
76         addrFinance = _newFinance;
77     }
78 
79     function withdraw(address _target, uint256 _amount) 
80         external 
81     {
82         require(msg.sender == addrFinance || msg.sender == addrAdmin);
83         require(_amount > 0);
84         address receiver = _target == address(0) ? addrFinance : _target;
85         uint256 balance = this.balance;
86         if (_amount < balance) {
87             receiver.transfer(_amount);
88         } else {
89             receiver.transfer(this.balance);
90         }      
91     }
92 }
93 
94 /**
95  * @title SafeMath
96  * @dev Math operations with safety checks that throw on error
97  */
98 library SafeMath {
99     /**
100     * @dev Multiplies two numbers, throws on overflow.
101     */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         if (a == 0) {
104             return 0;
105         }
106         uint256 c = a * b;
107         assert(c / a == b);
108         return c;
109     }
110 
111     /**
112     * @dev Integer division of two numbers, truncating the quotient.
113     */
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         // assert(b > 0); // Solidity automatically throws when dividing by 0
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118         return c;
119     }
120 
121     /**
122     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123     */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         assert(b <= a);
126         return a - b;
127     }
128 
129     /**
130     * @dev Adds two numbers, throws on overflow.
131     */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         assert(c >= a);
135         return c;
136     }
137 }
138 
139 contract PrizePool is AccessService {
140     using SafeMath for uint256;
141 
142     event SendPrizeSuccesss(uint64 flag, uint256 oldBalance, uint256 sendVal);
143     event PrizeTimeClear(uint256 newVal);
144     uint64 public nextPrizeTime;
145     uint256 maxPrizeOneDay = 30;
146 
147     
148     function PrizePool() public {
149         addrAdmin = msg.sender;
150         addrService = msg.sender;
151         addrFinance = msg.sender;
152     }
153 
154     function() external payable {
155 
156     }
157 
158     function getBalance() external view returns(uint256) {
159         return this.balance;
160     }
161 
162     function clearNextPrizeTime() external onlyService {
163         nextPrizeTime = 0;
164         PrizeTimeClear(0);
165     }
166 
167     function setMaxPrizeOneDay(uint256 val) external onlyAdmin {
168         require(val > 0 && val < 100);
169         require(val != maxPrizeOneDay);
170         maxPrizeOneDay = val;
171     }
172 
173     // gas 130000 per 10 address
174     function sendPrize(address[] winners, uint256[] amounts, uint64 _flag) 
175         external 
176         onlyService 
177         whenNotPaused
178     {
179         uint64 tmNow = uint64(block.timestamp);
180         uint256 length = winners.length;
181         require(length == amounts.length);
182         require(length <= 64);
183 
184         uint256 sum = 0;
185         for (uint32 i = 0; i < length; ++i) {
186             sum = sum.add(amounts[i]);
187         }
188         uint256 balance = this.balance;
189         require((sum.mul(100).div(balance)) <= maxPrizeOneDay);
190 
191         address addrZero = address(0);
192         for (uint32 j = 0; j < length; ++j) {
193             if (winners[j] != addrZero) {
194                 winners[j].transfer(amounts[j]);
195             }
196         }
197         nextPrizeTime = tmNow + 72000;
198         SendPrizeSuccesss(_flag, balance, sum);
199     }
200 }