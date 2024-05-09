1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 contract Owned {
27   address public owner;
28   event TransferOwnership(address oldaddr, address newaddr);
29   modifier onlyOwner() {
30         require(msg.sender == owner);
31     _;}
32   function Owned() public {
33     owner = msg.sender;
34   }
35   function transferOwnership(address _new) onlyOwner public {
36     address oldaddr = owner;
37     owner = _new;
38     TransferOwnership(oldaddr, owner);
39   }
40 }
41 
42 contract MontexToken is Owned{
43   string public name;
44   string public symbol;
45   uint256 public decimals;
46   uint256 public totalSupply;
47   mapping (address => uint256) public balanceOf;
48 
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 
51   function MontexToken() public{
52     name = "Montex Token";
53     symbol = "MON";
54     decimals = 8;
55     totalSupply = 2e9 * 10**uint256(decimals);
56     balanceOf[msg.sender] = totalSupply;
57   }
58 
59   function transfer(address _to, uint256 _value) public{
60     if (balanceOf[msg.sender] < _value) revert();
61     if (balanceOf[_to] + _value < balanceOf[_to]) revert();
62       balanceOf[msg.sender] -= _value;
63       balanceOf[_to] += _value;
64       Transfer(msg.sender, _to, _value);
65   }
66 }
67 
68 contract Crowdsale is Owned {
69   using SafeMath for uint256;
70   uint256 public fundingGoal;
71   uint256 public price;
72   uint256 public transferableToken;
73   uint256 public soldToken;
74   uint256 public deadline;
75   uint256 public token_price;
76   MontexToken public tokenReward;
77   bool public fundingGoalReached = false;
78   bool public isOpened;
79   mapping (address => Property) public fundersProperty;
80 
81   struct Property {
82     uint256 paymentEther;
83     uint256 reservedToken;
84   }
85 
86   event CrowdsaleStart(uint fundingGoal, uint deadline, uint transferableToken, address beneficiary);
87   event ReservedToken(address backer, uint amount, uint token, uint soldToken);
88   event WithdrawalToken(address addr, uint amount, bool result);
89   event WithdrawalEther(address addr, uint amount, bool result);
90   event FinishCrowdSale(address beneficiary, uint fundingGoal, uint amountRaised, bool reached, uint raisedToken);
91 
92   modifier afterDeadline() { if (now >= deadline) _; }
93 
94   function Crowdsale (
95     uint _fundingGoalInEthers,
96     uint _transferableToken,
97     uint _amountOfTokenPerEther,
98     MontexToken _addressOfTokenUsedAsReward
99   ) public {
100     fundingGoal = _fundingGoalInEthers * 1 ether;
101     price = 1 ether / _amountOfTokenPerEther;
102     tokenReward = MontexToken(_addressOfTokenUsedAsReward);
103     transferableToken = _transferableToken * 10 ** uint256(8);
104   }
105 
106   function () payable external{
107     if (!isOpened || now >= deadline) revert();
108 
109     uint amount = msg.value;
110 
111     uint amont_conv = amount * 1000;
112     uint token = (amont_conv / price * token_price / 1000) * 10 ** uint256(8);
113 
114     if (token == 0 || soldToken + token > transferableToken) revert();
115     fundersProperty[msg.sender].paymentEther += amount / 10 ** uint256(8);
116     fundersProperty[msg.sender].reservedToken += token;
117     soldToken += token;
118 
119     tokenReward.transfer(msg.sender, token);
120 
121     ReservedToken(msg.sender, amount, token,soldToken);
122   }
123 
124   function start(uint startTime,uint _deadline,uint _token_price) onlyOwner public{
125     deadline = _deadline;
126     token_price = _token_price;
127     if (fundingGoal == 0 || transferableToken == 0 ||
128         tokenReward == address(0) ||  startTime >= now)
129     {
130       revert();
131     }
132     if (tokenReward.balanceOf(this) >= transferableToken) {
133       if(startTime <= now && now <= deadline){
134         isOpened = true;
135         CrowdsaleStart(fundingGoal, deadline, transferableToken, owner);
136       }
137     }
138   }
139 
140   function getBalance(address _addres) public
141   constant returns(uint nowpaymentEther,uint nowbuyToken)
142   {
143     nowpaymentEther = fundersProperty[_addres].paymentEther * (1 ether) / 10 ** uint256(8);
144     nowbuyToken = fundersProperty[_addres].reservedToken;
145 
146   }  
147   function valNowRate(uint _amount) public
148     view returns(uint get_rate,uint get_token)
149     {
150     get_rate = token_price;
151     get_token = _amount * get_rate;
152   }
153 
154 
155   function getRemainingTimeEthToken() public
156     constant returns(
157         uint now_time,
158         uint now_deadline,
159         uint remain_days,
160         uint remain_hours,
161         uint remain_minutes,
162         uint remainEth,
163         uint remainToken,
164         uint remain_seconds,
165         uint getEth,
166         uint tokenReward_balance,
167         uint transferable_token)
168   {
169     if(now < deadline) {
170       remain_days = (deadline - now) / (1 days);
171       remain_hours = (deadline - now) / (1 hours);
172       remain_minutes = (deadline - now) / (1 minutes);
173       remain_seconds = (deadline - now) / (1 seconds);
174       now_time = now;
175       now_deadline = deadline;
176       
177     }
178     remainEth = (fundingGoal - this.balance) / (1 ether);
179     remainToken = transferableToken - soldToken;
180     getEth = this.balance / (1 ether);
181     tokenReward_balance = tokenReward.balanceOf(this);
182     transferable_token = transferableToken;
183   }
184 
185   function finishCrowdSale() onlyOwner public {
186     if (this.balance >= fundingGoal) {
187       fundingGoalReached = true;
188     }
189     if(isOpened==true){
190       isOpened = false;
191 
192       uint val = transferableToken - soldToken;
193       if (val > 0) {
194         tokenReward.transfer(msg.sender, transferableToken - soldToken);
195         WithdrawalToken(msg.sender, val, true);
196       }
197     }
198       FinishCrowdSale(owner, fundingGoal, this.balance, fundingGoalReached, soldToken);
199   }
200 
201   function withdrawalOwner() onlyOwner public{
202       uint amount = this.balance;
203       if (amount > 0) {
204         bool ok = msg.sender.call.value(amount)();
205         WithdrawalEther(msg.sender, amount, ok);
206       }    
207   }
208 }