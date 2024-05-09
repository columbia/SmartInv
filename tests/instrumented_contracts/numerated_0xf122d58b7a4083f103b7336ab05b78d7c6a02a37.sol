1 pragma solidity ^0.4.19;
2 
3 // Wolf Crypto pooling contract for Quant Network Overledger
4 // written by @iamdefinitelyahuman
5 
6 
7 library SafeMath {
8     
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ERC20 {
31   function balanceOf(address _owner) constant returns (uint256 balance) {}
32   function transfer(address _to, uint256 _value) returns (bool success) {}
33 }
34 
35 contract PresalePool {
36 
37   // SafeMath is a library to ensure that math operations do not have overflow errors
38   // https://zeppelin-solidity.readthedocs.io/en/latest/safemath.html
39   using SafeMath for uint;
40   
41   // The contract has 3 stages:
42   // 1 - The initial state. Contributors can deposit or withdraw eth to the contract.
43   // 2 - The owner has closed the contract for further deposits. Contributing addresses can still withdraw eth from the contract.
44   // 3 - The eth is sent from the contract to the receiver. Unused eth can be claimed by contributors immediately.
45   //     Once tokens are sent to the contract, the owner enables withdrawals and contributors can withdraw their tokens.
46   uint8 public contractStage = 1;
47   
48   // These variables are set at the time of contract creation
49   // the address that creates the contract
50   address public owner;
51   // the minimum eth amount (in wei) that can be sent by a contributing address
52   uint constant public contributionMin = 100000000000000000;
53   // the maximum eth amount (in wei) that can be held by the contract
54   uint public maxContractBalance;
55   // the % of tokens kept by the contract owner
56   uint public feePct;
57   // the address that the pool will be paid out to
58   address public receiverAddress;
59   
60   // These variables are all initially blank and are set at some point during the contract
61   // the amount of eth (in wei) present in the contract when it was submitted
62   uint public finalBalance;
63   // an array containing eth amounts to be refunded in stage 3
64   uint[] public ethRefundAmount;
65   // the default token contract to be used for withdrawing tokens in stage 3
66   address public activeToken;
67   
68   // a data structure for holding the contribution amount, eth refund status, and token withdrawal status for each address
69   struct Contributor {
70     uint ethRefund;
71     uint balance;
72     mapping (address => uint) tokensClaimed;
73   }
74   // a mapping that holds the contributor struct for each address
75   mapping (address => Contributor) contributorMap;
76   
77   // a data structure for holding information related to token withdrawals.
78   struct TokenAllocation {
79     ERC20 token;
80     uint[] pct;
81     uint balanceRemaining;
82   }
83   // a mapping that holds the token allocation struct for each token address
84   mapping (address => TokenAllocation) distributionMap;
85   
86   
87   // this modifier is used for functions that can only be accessed by the contract creator
88   modifier onlyOwner () {
89     require (msg.sender == owner);
90     _;
91   }
92   
93   // this modifier is used to prevent re-entrancy exploits during contract > contract interaction
94   bool locked;
95   modifier noReentrancy() {
96     require (!locked);
97     locked = true;
98     _;
99     locked = false;
100   }
101   
102   // Events triggered throughout contract execution
103   // These can be watched via geth filters to keep up-to-date with the contract
104   event ContributorBalanceChanged (address contributor, uint totalBalance);
105   event PoolSubmitted (address receiver, uint amount);
106   event WithdrawalsOpen (address tokenAddr);
107   event TokensWithdrawn (address receiver, uint amount);
108   event EthRefundReceived (address sender, uint amount);
109   event EthRefunded (address receiver, uint amount);
110   event ERC223Received (address token, uint value);
111    
112   // These are internal functions used for calculating fees, eth and token allocations as %
113   // returns a value as a % accurate to 20 decimal points
114   function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {
115     return numerator.mul(10 ** 20) / denominator;
116   }
117   
118   // returns % of any number, where % given was generated with toPct
119   function _applyPct (uint numerator, uint pct) internal pure returns (uint) {
120     return numerator.mul(pct) / (10 ** 20);
121   }
122   
123   // This function is called at the time of contract creation,
124   // it sets the initial variables and the contract owner.
125   function PresalePool(address receiverAddr, uint contractMaxInWei, uint fee) public {
126     require (fee < 100);
127     require (receiverAddr != 0x00);
128     owner = msg.sender;
129     receiverAddress = receiverAddr;
130     maxContractBalance = contractMaxInWei;
131     feePct = _toPct(fee,100);
132   }
133   
134   // This function is called whenever eth is sent into the contract.
135   // The amount sent is added to the balance in the Contributor struct associated with the sending address.
136   function () payable public {
137     if (contractStage == 1) {
138       _ethDeposit();
139     } else if (contractStage == 3) {
140       _ethRefund();
141     } else revert();
142   }
143   
144   // Internal function for handling eth deposits during contract stage one.
145   function _ethDeposit () internal {
146     assert (contractStage == 1);  
147     uint size;
148     address addr = msg.sender;
149     assembly { size := extcodesize(addr) }
150     require (size == 0);
151     require (this.balance <= maxContractBalance);
152     var c = contributorMap[msg.sender];
153     uint newBalance = c.balance.add(msg.value);
154     require (newBalance >= contributionMin);
155     c.balance = newBalance;
156     ContributorBalanceChanged(msg.sender, newBalance);
157   }
158   
159   // Internal function for handling eth refunds during stage three.
160   function _ethRefund () internal {
161     assert (contractStage == 3);
162     require (msg.sender == owner || msg.sender == receiverAddress);
163     require (msg.value >= contributionMin);
164     ethRefundAmount.push(msg.value);
165     EthRefundReceived(msg.sender, msg.value);
166   }
167   
168   // This function is called to withdraw eth or tokens from the contract. It can only be called by addresses that show a balance greater than 0.
169   // If called during stages one or two, the full eth balance deposited into the contract is returned and the contributor's balance reset to 0.
170   // If called during stage three, the contributor's unused eth will be returned, as well as any available tokens.
171   // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).
172   function withdraw (address tokenAddr) public {
173     var c = contributorMap[msg.sender];
174     require (c.balance > 0);
175     if (contractStage < 3) {
176       uint amountToTransfer = c.balance;
177       c.balance = 0;
178       msg.sender.transfer(amountToTransfer);
179       ContributorBalanceChanged(msg.sender, 0);
180     } else {
181       _withdraw(msg.sender, tokenAddr);
182     }  
183   }
184   
185   // This function allows the contract owner to force a withdrawal to any contributor.
186   function withdrawFor (address contributor, address tokenAddr) public onlyOwner {
187     require (contractStage == 3);
188     require (contributorMap[contributor].balance > 0);
189     _withdraw(contributor, tokenAddr);
190   }
191   
192   // This internal function handles withdrawals during stage three.
193   // The associated events will fire to notify when a refund or token allocation is claimed.
194   function _withdraw (address receiver, address tokenAddr) internal {
195     assert (contractStage == 3);
196     var c = contributorMap[receiver];
197     if (tokenAddr == 0x00) {
198       tokenAddr = activeToken;
199     }
200     var d = distributionMap[tokenAddr];
201     require ( ethRefundAmount.length > c.ethRefund || d.pct.length > c.tokensClaimed[tokenAddr] );
202     if (ethRefundAmount.length > c.ethRefund) {
203       uint pct = _toPct(c.balance, finalBalance);
204       uint ethAmount = 0;
205       for (uint i = c.ethRefund; i < ethRefundAmount.length; i++) {
206         ethAmount = ethAmount.add(_applyPct(ethRefundAmount[i], pct));
207       }
208       c.ethRefund = ethRefundAmount.length;
209       if (ethAmount > 0) {
210         receiver.transfer(ethAmount);
211         EthRefunded(receiver, ethAmount);
212       }
213     }
214     if (d.pct.length > c.tokensClaimed[tokenAddr]) {
215       uint tokenAmount = 0;
216       for (i = c.tokensClaimed[tokenAddr]; i < d.pct.length; i++) {
217         tokenAmount = tokenAmount.add(_applyPct(c.balance, d.pct[i]));
218       }
219       c.tokensClaimed[tokenAddr] = d.pct.length;
220       if (tokenAmount > 0) {
221         require (d.token.transfer(receiver, tokenAmount));
222         d.balanceRemaining = d.balanceRemaining.sub(tokenAmount);
223         TokensWithdrawn(receiver, tokenAmount);
224       }  
225     }
226     
227   }
228   
229   // This function can be called during stages one or two to modify the maximum balance of the contract.
230   // It can only be called by the owner. The amount cannot be set to lower than the current balance of the contract.
231   function modifyMaxContractBalance (uint amount) public onlyOwner {
232     require (contractStage < 3);
233     require (amount >= contributionMin);
234     require (amount >= this.balance);
235     maxContractBalance = amount;
236   }
237   
238   // This callable function returns the total pool cap, current balance and remaining balance to be filled.
239   function checkPoolBalance () view public returns (uint poolCap, uint balance, uint remaining) {
240     if (contractStage == 1) {
241       remaining = maxContractBalance.sub(this.balance);
242     } else {
243       remaining = 0;
244     }
245     return (maxContractBalance,this.balance,remaining);
246   }
247   
248   // This callable function returns the balance, contribution cap, and remaining available balance of any contributor.
249   function checkContributorBalance (address addr) view public returns (uint balance, uint cap, uint remaining) {
250     var c = contributorMap[addr];
251     if (contractStage == 1) {
252       remaining = maxContractBalance.sub(this.balance);
253     } else {
254       remaining = 0;
255     }
256     return (c.balance, maxContractBalance, remaining);
257   }
258   
259   // This callable function returns the token balance that a contributor can currently claim.
260   function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint tokenAmount) {
261     var c = contributorMap[addr];
262     var d = distributionMap[tokenAddr];
263     for (uint i = c.tokensClaimed[tokenAddr]; i < d.pct.length; i++) {
264       tokenAmount = tokenAmount.add(_applyPct(c.balance, d.pct[i]));
265     }
266     return tokenAmount;
267   }
268   
269   // This function closes further contributions to the contract, advancing it to stage two.
270   // It can only be called by the owner.  After this call has been made, contributing addresses
271   // can still remove their eth from the contract but cannot contribute any more.
272   function closeContributions () public onlyOwner {
273     require (contractStage == 1);
274     contractStage = 2;
275   }
276   
277   // This function reopens the contract to contributions, returning it to stage one.
278   // It can only be called by the owner during stage two.
279   function reopenContributions () public onlyOwner {
280     require (contractStage == 2);
281     contractStage = 1;
282   }
283 
284   // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,
285   // and advances the contract to stage three. It can only be called by the contract owner during stages one or two.
286   // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,
287   // it is VERY IMPORTANT not to get the amount wrong.
288   function submitPool (uint amountInWei) public onlyOwner noReentrancy {
289     require (contractStage < 3);
290     require (contributionMin <= amountInWei && amountInWei <= this.balance);
291     finalBalance = this.balance;
292     require (receiverAddress.call.value(amountInWei).gas(msg.gas.sub(5000))());
293     if (this.balance > 0) ethRefundAmount.push(this.balance);
294     contractStage = 3;
295     PoolSubmitted(receiverAddress, amountInWei);
296   }
297   
298   // This function opens the contract up for token withdrawals.
299   // It can only be called by the owner during stage 3.  The owner specifies the address of an ERC20 token
300   // contract that this contract has a balance in, and optionally a bool to prevent this token from being
301   // the default withdrawal (in the event of an airdrop, for example).
302   function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyOwner noReentrancy {
303     require (contractStage == 3);
304     if (notDefault) {
305       require (activeToken != 0x00);
306     } else {
307       activeToken = tokenAddr;
308     }
309     var d = distributionMap[tokenAddr];    
310     if (d.pct.length == 0) d.token = ERC20(tokenAddr);
311     uint amount = d.token.balanceOf(this).sub(d.balanceRemaining);
312     require (amount > 0);
313     if (feePct > 0) {
314       require (d.token.transfer(owner,_applyPct(amount, feePct)));
315     }
316     amount = d.token.balanceOf(this).sub(d.balanceRemaining);
317     d.balanceRemaining = d.token.balanceOf(this);
318     d.pct.push(_toPct(amount, finalBalance));
319     WithdrawalsOpen(tokenAddr);
320   }
321   
322   // This is a standard function required for ERC223 compatibility.
323   function tokenFallback (address from, uint value, bytes data) public {
324     ERC223Received(from, value);
325   }
326   
327 }