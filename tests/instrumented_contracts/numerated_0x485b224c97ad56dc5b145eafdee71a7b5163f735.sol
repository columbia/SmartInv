1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint a, uint b) pure internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a,uint b) pure internal returns (uint) {
11     uint c = a / b;
12     return c;
13   }
14 
15   function sub(uint a, uint b) pure internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint a, uint b) pure internal returns (uint) {
21     uint c = a + b;
22     assert(c>=a && c>=b);
23     return c;
24   }
25 }
26 
27 contract EthPyramid {
28   function buyPrice() public constant returns (uint) {}   
29 }
30 
31 contract PonziBet {
32     
33   using SafeMath for uint;
34 
35   EthPyramid public pyramid;
36 
37   address public admin;
38   address public contractAddress;
39 
40   uint public minBet;
41   uint public roundTime;
42   uint public startPrice;  
43   uint public endPrice;
44   
45   uint[] public upBetRecords; 
46   uint[] public downBetRecords;
47   
48   mapping (address => uint) lastBet;
49   mapping (address => bool) userBet;
50   mapping (bool => uint) totalBalance;
51   mapping (address => uint) feeBalance;
52   mapping (address => mapping (bool => uint)) userBalances;
53   
54   function PonziBet() public {
55     admin = msg.sender;      
56   }       
57   
58   modifier onlyAdmin() {
59     require(msg.sender == admin);
60     _;
61   }  
62 
63   function changeContractAddress(address _contract) 
64      external
65      onlyAdmin
66   {
67      contractAddress = _contract;
68      pyramid = EthPyramid(contractAddress);
69   }
70 
71   function changeMinBet(uint _minBet)
72      external
73      onlyAdmin
74   {
75      minBet = _minBet;
76   }
77 
78   function withdrawFromFeeBalance() 
79      external
80      onlyAdmin
81   {
82     if(!msg.sender.send(feeBalance[msg.sender])) revert();  
83   } 
84 
85   function recordBet(bool _bet,uint _userAmount)
86     private
87   {
88     userBalances[msg.sender][_bet] = _userAmount;
89     totalBalance[_bet] = totalBalance[_bet].add(_userAmount);
90     userBet[msg.sender] = _bet;
91     _bet ? upBetRecords.push(_userAmount) : downBetRecords.push(_userAmount);      
92   }
93 
94   function enterRound(bool _bet) 
95      external 
96      payable 
97   {
98     require(msg.value >= 10000000000000000);
99     if(roundTime == uint(0) || roundTime + 30 minutes <= now) {
100       endPrice = uint(0);
101       upBetRecords.length = uint(0);
102       downBetRecords.length = uint(0);
103       startPrice = pyramid.buyPrice();
104       roundTime = now;    
105     }
106     if(roundTime + 15 minutes > now) {
107       uint fee = msg.value.div(20);
108       uint userAmount = msg.value.sub(fee);
109       feeBalance[admin] =  feeBalance[admin].add(fee);
110       if(_bet == true) {
111         recordBet(true,userAmount);
112       }
113       else if(_bet == false) {
114         recordBet(false,userAmount);
115       }   
116       lastBet[msg.sender] = now;
117     }
118     else {
119       revert();
120     }
121   }    
122   
123   function settleBet(bool _bet)
124     private
125   {
126       uint reward = (userBalances[msg.sender][_bet].mul(totalBalance[!_bet])).div(totalBalance[_bet]);
127       uint totalWithdrawal = reward.add(userBalances[msg.sender][_bet]);
128       totalBalance[!_bet] = totalBalance[!_bet].sub(reward);
129       totalBalance[_bet] = totalBalance[_bet].sub(userBalances[msg.sender][_bet]);
130       msg.sender.transfer(totalWithdrawal);
131   }
132   
133   function placeBet() 
134      external
135   {
136     require(lastBet[msg.sender] < roundTime + 15 minutes && roundTime + 15 minutes < now && roundTime + 30 minutes > now);
137     if(endPrice == uint(0)) {
138       endPrice = pyramid.buyPrice();    
139     }
140     if(startPrice >= endPrice && userBet[msg.sender] == true ) {
141       settleBet(true);
142     }
143     else if(startPrice < endPrice && userBet[msg.sender] == false ) {
144       settleBet(false);
145     }
146     else {
147       revert();
148     }
149   }
150   
151   function totalBalanceUp() view external returns(uint) {
152       return totalBalance[true];
153   }
154   
155   function totalBalanceDown() view external returns(uint) {
156       return totalBalance[false];
157   }
158   
159   function getUserBet() view external returns(bool) {
160     return userBet[msg.sender];
161   }
162 
163   function getUserBalances() view external returns(uint) {
164     return userBalances[msg.sender][userBet[msg.sender]];
165   }
166   
167   function getUserBalancesLastBet() view external returns(uint) {
168     return lastBet[msg.sender];
169   }
170 
171 }