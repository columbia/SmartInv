1 pragma solidity 0.6.8;
2 
3 library SafeMath {
4   /**
5   * @dev Multiplies two unsigned integers, reverts on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9     // benefit is lost if 'b' is also tested.
10     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11     if (a == 0) {
12         return 0;
13     }
14 
15     uint256 c = a * b;
16     require(c / a == b);
17 
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // Solidity only automatically asserts when dividing by 0
26     require(b > 0);
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two unsigned integers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 interface ERC20 {
64   function balanceOf(address who) external view returns (uint256);
65   function allowance(address owner, address spender) external  view returns (uint256);
66   function transfer(address to, uint value) external  returns (bool success);
67   function transferFrom(address from, address to, uint256 value) external returns (bool success);
68   function approve(address spender, uint value) external returns (bool success);
69 }
70 
71 contract yRiseTokenSale {
72   using SafeMath for uint256;
73 
74   uint256 public totalSold;
75   ERC20 public yRiseToken;
76   address payable public owner;
77   uint256 public collectedETH;
78   uint256 public startDate;
79   bool public softCapMet;
80   bool private presaleClosed = false;
81   uint256 private ethWithdrawals = 0;
82   uint256 private lastWithdrawal;
83 
84   // tracks all contributors.
85   mapping(address => uint256) internal _contributions;
86   // adjusts for different conversion rates.
87   mapping(address => uint256) internal _averagePurchaseRate;
88   // total contributions from wallet.
89   mapping(address => uint256) internal _numberOfContributions;
90 
91   constructor(address _wallet) public {
92     owner = msg.sender;
93     yRiseToken = ERC20(_wallet);
94   }
95 
96   uint256 amount;
97   uint256 rateDay1 = 20;
98   uint256 rateDay2 = 16;
99   uint256 rateDay3 = 13;
100   uint256 rateDay4 = 10;
101   uint256 rateDay5 = 8;
102  
103   // Converts ETH to yRise and sends new yRise to the sender
104   receive () external payable {
105     require(startDate > 0 && now.sub(startDate) <= 7 days);
106     require(yRiseToken.balanceOf(address(this)) > 0);
107     require(msg.value >= 0.1 ether && msg.value <= 3 ether);
108     require(!presaleClosed);
109      
110     if (now.sub(startDate) <= 1 days) {
111        amount = msg.value.mul(20);
112        _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay1.mul(10));
113     } else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days) {
114        amount = msg.value.mul(16);
115        _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay2.mul(10));
116     } else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days) {
117        amount = msg.value.mul(13);
118        _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay3.mul(10));
119     } else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 4 days) {
120        amount = msg.value.mul(10);
121        _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay4.mul(10));
122     } else if(now.sub(startDate) > 4 days) {
123        amount = msg.value.mul(8);
124        _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay5.mul(10));
125     }
126     
127     require(amount <= yRiseToken.balanceOf(address(this)));
128     // update constants.
129     totalSold = totalSold.add(amount);
130     collectedETH = collectedETH.add(msg.value);
131     // update address contribution + total contributions.
132     _contributions[msg.sender] = _contributions[msg.sender].add(amount);
133     _numberOfContributions[msg.sender] = _numberOfContributions[msg.sender].add(1);
134     // transfer the tokens.
135     yRiseToken.transfer(msg.sender, amount);
136     // check if soft cap is met.
137     if (!softCapMet && collectedETH >= 100 ether) {
138       softCapMet = true;
139     }
140   }
141 
142   // Converts ETH to yRise and sends new yRise to the sender
143   function contribute() external payable {
144     require(startDate > 0 && now.sub(startDate) <= 7 days);
145     require(yRiseToken.balanceOf(address(this)) > 0);
146     require(msg.value >= 0.1 ether && msg.value <= 3 ether);
147     require(!presaleClosed);
148 
149     if (now.sub(startDate) <= 1 days) {
150        amount = msg.value.mul(20);
151        _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay1.mul(10));
152     } else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days) {
153        amount = msg.value.mul(16);
154        _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay2.mul(10));
155     } else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days) {
156        amount = msg.value.mul(13);
157        _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay3.mul(10));
158     } else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 4 days) {
159        amount = msg.value.mul(10);
160        _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay4.mul(10));
161     } else if(now.sub(startDate) > 4 days) {
162        amount = msg.value.mul(8);
163        _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay5.mul(10));
164     }
165         
166     require(amount <= yRiseToken.balanceOf(address(this)));
167     // update constants.
168     totalSold = totalSold.add(amount);
169     collectedETH = collectedETH.add(msg.value);
170     // update address contribution + total contributions.
171     _contributions[msg.sender] = _contributions[msg.sender].add(amount);
172     _numberOfContributions[msg.sender] = _numberOfContributions[msg.sender].add(1);
173     // transfer the tokens.
174     yRiseToken.transfer(msg.sender, amount);
175     // check if soft cap is met.
176     if (!softCapMet && collectedETH >= 100 ether) {
177       softCapMet = true;
178     }
179   }
180 
181   function numberOfContributions(address from) public view returns(uint256) {
182     return _numberOfContributions[address(from)]; 
183   }
184 
185   function contributions(address from) public view returns(uint256) {
186     return _contributions[address(from)];
187   }
188 
189   function averagePurchaseRate(address from) public view returns(uint256) {
190     return _averagePurchaseRate[address(from)];
191   }
192 
193   // if the soft cap isn't met and the presale period ends (7 days) enable
194   // users to buy back their ether.
195   function buyBackETH(address payable from) public {
196     require(now.sub(startDate) > 7 days && !softCapMet);
197     require(_contributions[from] > 0);
198     uint256 exchangeRate = _averagePurchaseRate[from].div(10).div(_numberOfContributions[from]);
199     uint256 contribution = _contributions[from];
200     // remove funds from users contributions.
201     _contributions[from] = 0;
202     // transfer funds back to user.
203     from.transfer(contribution.div(exchangeRate));
204   }
205 
206   // Function to withdraw raised ETH (staggered withdrawals)
207   // Only the contract owner can call this function
208   function withdrawETH() public {
209     require(msg.sender == owner && address(this).balance > 0);
210     require(softCapMet == true && presaleClosed == true);
211     uint256 withdrawAmount;
212     // first ether withdrawal (max 150 ETH)
213     if (ethWithdrawals == 0) {
214       if (collectedETH <= 150 ether) {
215         withdrawAmount = collectedETH;
216       } else {
217         withdrawAmount = 150 ether;
218       }
219     } else {
220       // remaining ether withdrawal (max 150 ETH per withdrawal)
221       // staggered in 7 day periods.
222       uint256 currDate = now;
223       // ensure that it has been at least 7 days.
224       require(currDate.sub(lastWithdrawal) >= 7 days);
225       if (collectedETH <= 150 ether) {
226         withdrawAmount = collectedETH;
227       } else {
228         withdrawAmount = 150 ether;
229       }
230     }
231     lastWithdrawal = now;
232     ethWithdrawals = ethWithdrawals.add(1);
233     collectedETH = collectedETH.sub(withdrawAmount);
234     owner.transfer(withdrawAmount);
235   }
236 
237   function endPresale() public {
238     require(msg.sender == owner);
239     presaleClosed = true;
240   }
241 
242   // Function to burn remaining yRise (sale must be over to call)
243   // Only the contract owner can call this function
244   function burnyRise() public {
245     require(msg.sender == owner && yRiseToken.balanceOf(address(this)) > 0 && now.sub(startDate) > 7 days);
246     // burn the left over.
247     yRiseToken.transfer(address(0), yRiseToken.balanceOf(address(this)));
248   }
249   
250   //Starts the sale
251   //Only the contract owner can call this function
252   function startSale() public {
253     require(msg.sender == owner && startDate==0);
254     startDate=now;
255   }
256   
257   //Function to query the supply of yRise in the contract
258   function availableyRise() public view returns(uint256) {
259     return yRiseToken.balanceOf(address(this));
260   }
261 }