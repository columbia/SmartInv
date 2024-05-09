1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks
6  */
7 contract SafeMath {
8     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b > 0);
16         uint256 c = a / b;
17         assert(a == b * c + a % b);
18         return c;
19     }
20 
21     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a && c >= b);
29         return c;
30     }
31 }
32 
33 
34 /**
35  * @title ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/20
37  */
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     uint8 public decimals;
41     function balanceOf(address _owner) public constant returns (uint256 _balance);
42     function transfer(address _to, uint256 _value) public returns (bool _succes);
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44 }
45 
46 
47 
48 /**
49  * @title Crowdsale
50  * @dev Crowdsale contract 
51  */
52 contract Crowdsale is SafeMath {
53 
54     // token address
55     address public tokenAddress = 0xa5FD4f631Ddf9C37d7B8A2c429a58bDC78abC843;
56     
57     // The token being sold
58     ERC20Basic public ipc = ERC20Basic(tokenAddress);
59     
60     // address where funds are collected
61     address public crowdsaleAgent = 0x783fE4521c2164eB6a7972122E7E33a1D1A72799;
62     
63     address public owner = 0xa52858fB590CFe15d03ee1F3803F2D3fCa367166;
64 
65     // amount of raised money in wei
66     uint256 public weiRaised;
67 
68     // minimum amount of ether to participate in ICO
69     uint256 public minimumEtherAmount = 0.2 ether;
70 
71     // start and end timestamps where investments are allowed (both inclusive)
72     // + deadlines within bonus program
73     uint256 public startTime = 1520082000;     //(GMT): Saturday, 3. March 2018 13:00:00
74     uint256 public deadlineOne = 1520168400;   //(GMT): Sunday, 4. March 2018 13:00:00
75     uint256 public deadlineTwo = 1520427600;   //(GMT): Wednesday, 7. March 2018 13:00:00
76     uint256 public deadlineThree = 1520773200; //(GMT): Sunday, 11. March 2018 13:00:00
77     uint256 public endTime = 1522674000;       //(GMT): Monday, 2. April 2018 13:00:00 
78     
79     // token amount for one ether during crowdsale
80     uint public firstRate = 6000; 
81     uint public secondRate = 5500;
82     uint public thirdRate = 5000;
83     uint public finalRate = 4400;
84 
85     // token distribution during Crowdsale
86     mapping(address => uint256) public distribution;
87     
88     /**
89      * event for token purchase logging
90      * @param purchaser who paid for the tokens
91      * @param beneficiary who got the tokens
92      * @param value weis paid for purchase
93      * @param amount amount of tokens purchased
94      */
95     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
96 
97     modifier onlyCrowdsaleAgent {
98         require(msg.sender == crowdsaleAgent);
99         _;
100     }
101     
102     // fallback function can be used to buy tokens
103     function () public payable {
104         buyTokens(msg.sender);
105     }
106 
107     // token purchase function
108     function buyTokens(address beneficiary) public payable {
109         require(beneficiary != address(0));
110         require(beneficiary != address(this));
111         require(beneficiary != tokenAddress);
112         require(validPurchase());
113         uint256 weiAmount = msg.value;
114         // calculate token amount to be transferred to beneficiary
115         uint256 tokens = calcTokenAmount(weiAmount);
116         // update state
117         weiRaised = safeAdd(weiRaised, weiAmount);
118         distribution[beneficiary] = safeAdd(distribution[beneficiary], tokens);
119         ipc.transfer(beneficiary, tokens);
120         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
121         forwardFunds();
122     }
123 
124     // return true if crowdsale event has ended
125     function hasEnded() public view returns (bool) {
126         return now > endTime;
127     }
128     
129     // set crowdsale wallet where funds are collected
130     function setCrowdsaleAgent(address _crowdsaleAgent) public returns (bool) {
131         require(msg.sender == owner || msg.sender == crowdsaleAgent);
132         crowdsaleAgent = _crowdsaleAgent;
133         return true;
134     }
135     
136     // set ico times
137     function setTimes(  uint256 _startTime, bool changeStartTime,
138                         uint256 firstDeadline, bool changeFirstDeadline,
139                         uint256 secondDeadline, bool changeSecondDeadline,
140                         uint256 thirdDeadline, bool changeThirdDeadline,
141                         uint256 _endTime, bool changeEndTime) onlyCrowdsaleAgent public returns (bool) {
142         if(changeStartTime) startTime = _startTime;
143         if(changeFirstDeadline) deadlineOne = firstDeadline;
144         if(changeSecondDeadline) deadlineTwo = secondDeadline;
145         if(changeThirdDeadline) deadlineThree = thirdDeadline;
146         if(changeEndTime) endTime = _endTime;
147         return true;
148                             
149     }
150     
151     // set token rates
152     function setNewIPCRates(uint _firstRate, bool changeFirstRate,
153                             uint _secondRate, bool changeSecondRate,
154                             uint _thirdRate, bool changeThirdRate,
155                             uint _finaleRate, bool changeFinalRate) onlyCrowdsaleAgent public returns (bool) {
156         if(changeFirstRate) firstRate = _firstRate;
157         if(changeSecondRate) secondRate = _secondRate;
158         if(changeThirdRate) thirdRate = _thirdRate;
159         if(changeFinalRate) finalRate = _finaleRate;
160         return true;
161     }
162     
163     // set new minumum amount of Wei to participate in ICO
164     function setMinimumEtherAmount(uint256 _minimumEtherAmountInWei) onlyCrowdsaleAgent public returns (bool) {
165         minimumEtherAmount = _minimumEtherAmountInWei;
166         return true;
167     }
168     
169     // withdraw remaining IPC token amount after crowdsale has ended
170     function withdrawRemainingIPCToken() onlyCrowdsaleAgent public returns (bool) {
171         uint256 remainingToken = ipc.balanceOf(this);
172         require(hasEnded() && remainingToken > 0);
173         ipc.transfer(crowdsaleAgent, remainingToken);
174         return true;
175     }
176     
177     // send erc20 token from this contract
178     function withdrawERC20Token(address beneficiary, address _token) onlyCrowdsaleAgent public {
179         ERC20Basic erc20Token = ERC20Basic(_token);
180         uint256 amount = erc20Token.balanceOf(this);
181         require(amount>0);
182         erc20Token.transfer(beneficiary, amount);
183     }
184     
185     // transfer 'weiAmount' wei to 'beneficiary'
186     function sendEther(address beneficiary, uint256 weiAmount) onlyCrowdsaleAgent public {
187         beneficiary.transfer(weiAmount);
188     }
189 
190     // Calculate the token amount from the donated ETH onsidering the bonus system.
191     function calcTokenAmount(uint256 weiAmount) internal view returns (uint256) {
192         uint256 price;
193         if (now >= startTime && now < deadlineOne) {
194             price = firstRate; 
195         } else if (now >= deadlineOne && now < deadlineTwo) {
196             price = secondRate;
197         } else if (now >= deadlineTwo && now < deadlineThree) {
198             price = thirdRate;
199         } else if (now >= deadlineThree && now <= endTime) {
200         	price = finalRate;
201         }
202         uint256 tokens = safeMul(price, weiAmount);
203         uint8 decimalCut = 18 > ipc.decimals() ? 18-ipc.decimals() : 0;
204         return safeDiv(tokens, 10**uint256(decimalCut));
205     }
206 
207     // forward ether to the fund collection wallet
208     function forwardFunds() internal {
209         crowdsaleAgent.transfer(msg.value);
210     }
211 
212     // return true if valid purchase
213     function validPurchase() internal view returns (bool) {
214         bool withinPeriod = now >= startTime && now <= endTime;
215         bool isMinimumAmount = msg.value >= minimumEtherAmount;
216         bool hasTokenBalance = ipc.balanceOf(this) > 0;
217         return withinPeriod && isMinimumAmount && hasTokenBalance;
218     }
219      
220     // selfdestruct crowdsale contract only after crowdsale has ended
221     function killContract() onlyCrowdsaleAgent public {
222         require(hasEnded() && ipc.balanceOf(this) == 0);
223      selfdestruct(crowdsaleAgent);
224     }
225 }