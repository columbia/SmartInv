1 pragma solidity ^0.4.19;
2 
3 // Wolf Crypto pooling contract for NOUS
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
57   // the addresses that the pool may be paid out to
58   address[] public receiverAddresses = [0x3133b33e203f7066e3e0449450603e7ff6c4717f,  // 1000+
59                                         0x43d7c5807dC0480B1b3884Cc891A91cBa87FEf14,  // 750-1000
60                                         0xb977da9af8aa28fcc8493eb32c54a08197680d70]; // 500-750
61   // the address the pool was paid to
62   address public paidAddress;
63   
64   
65   // These variables are all initially blank and are set at some point during the contract
66   // the amount of eth (in wei) present in the contract when it was submitted
67   uint public finalBalance;
68   // an array containing eth amounts to be refunded in stage 3
69   uint[] public ethRefundAmount;
70   // the default token contract to be used for withdrawing tokens in stage 3
71   address public activeToken;
72   
73   // a data structure for holding the contribution amount, eth refund status, and token withdrawal status for each address
74   struct Contributor {
75     uint ethRefund;
76     uint balance;
77     mapping (address => uint) tokensClaimed;
78   }
79   // a mapping that holds the contributor struct for each address
80   mapping (address => Contributor) contributorMap;
81   
82   // a data structure for holding information related to token withdrawals.
83   struct TokenAllocation {
84     ERC20 token;
85     uint[] pct;
86     uint balanceRemaining;
87   }
88   // a mapping that holds the token allocation struct for each token address
89   mapping (address => TokenAllocation) distributionMap;
90   
91   
92   // this modifier is used for functions that can only be accessed by the contract creator
93   modifier onlyOwner () {
94     require (msg.sender == owner);
95     _;
96   }
97   
98   // this modifier is used to prevent re-entrancy exploits during contract > contract interaction
99   bool locked;
100   modifier noReentrancy() {
101     require (!locked);
102     locked = true;
103     _;
104     locked = false;
105   }
106   
107   // Events triggered throughout contract execution
108   // These can be watched via geth filters to keep up-to-date with the contract
109   event ContributorBalanceChanged (address contributor, uint totalBalance);
110   event PoolSubmitted (address receiver, uint amount);
111   event WithdrawalsOpen (address tokenAddr);
112   event TokensWithdrawn (address receiver, uint amount);
113   event EthRefundReceived (address sender, uint amount);
114   event EthRefunded (address receiver, uint amount);
115   event ERC223Received (address token, uint value);
116    
117   // These are internal functions used for calculating fees, eth and token allocations as %
118   // returns a value as a % accurate to 20 decimal points
119   function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {
120     return numerator.mul(10 ** 20) / denominator;
121   }
122   
123   // returns % of any number, where % given was generated with toPct
124   function _applyPct (uint numerator, uint pct) internal pure returns (uint) {
125     return numerator.mul(pct) / (10 ** 20);
126   }
127   
128   // This function is called at the time of contract creation,
129   // it sets the initial variables and the contract owner.
130   function PresalePool(uint contractMaxInWei, uint fee) public {
131     require (fee < 100);
132     owner = msg.sender;
133     maxContractBalance = contractMaxInWei;
134     feePct = _toPct(fee,100);
135   }
136   
137   // This function is called whenever eth is sent into the contract.
138   // The amount sent is added to the balance in the Contributor struct associated with the sending address.
139   function () payable public {
140     if (contractStage == 1) {
141       _ethDeposit();
142     } else if (contractStage == 3) {
143       _ethRefund();
144     } else revert();
145   }
146   
147   // Internal function for handling eth deposits during contract stage one.
148   function _ethDeposit () internal {
149     assert (contractStage == 1);  
150     uint size;
151     address addr = msg.sender;
152     assembly { size := extcodesize(addr) }
153     require (size == 0);
154     require (this.balance <= maxContractBalance);
155     var c = contributorMap[msg.sender];
156     uint newBalance = c.balance.add(msg.value);
157     require (newBalance >= contributionMin);
158     c.balance = newBalance;
159     ContributorBalanceChanged(msg.sender, newBalance);
160   }
161   
162   // Internal function for handling eth refunds during stage three.
163   function _ethRefund () internal {
164     assert (contractStage == 3);
165     require (msg.sender == owner || msg.sender == paidAddress);
166     require (msg.value >= contributionMin);
167     ethRefundAmount.push(msg.value);
168     EthRefundReceived(msg.sender, msg.value);
169   }
170   
171   // This function is called to withdraw eth or tokens from the contract. It can only be called by addresses that show a balance greater than 0.
172   // If called during stages one or two, the full eth balance deposited into the contract is returned and the contributor's balance reset to 0.
173   // If called during stage three, the contributor's unused eth will be returned, as well as any available tokens.
174   // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).
175   function withdraw (address tokenAddr) public {
176     var c = contributorMap[msg.sender];
177     require (c.balance > 0);
178     if (contractStage < 3) {
179       uint amountToTransfer = c.balance;
180       c.balance = 0;
181       msg.sender.transfer(amountToTransfer);
182       ContributorBalanceChanged(msg.sender, 0);
183     } else {
184       _withdraw(msg.sender, tokenAddr);
185     }  
186   }
187   
188   // This function allows the contract owner to force a withdrawal to any contributor.
189   function withdrawFor (address contributor, address tokenAddr) public onlyOwner {
190     require (contractStage == 3);
191     require (contributorMap[contributor].balance > 0);
192     _withdraw(contributor, tokenAddr);
193   }
194   
195   // This internal function handles withdrawals during stage three.
196   // The associated events will fire to notify when a refund or token allocation is claimed.
197   function _withdraw (address receiver, address tokenAddr) internal {
198     assert (contractStage == 3);
199     var c = contributorMap[receiver];
200     if (tokenAddr == 0x00) {
201       tokenAddr = activeToken;
202     }
203     var d = distributionMap[tokenAddr];
204     require ( ethRefundAmount.length > c.ethRefund || d.pct.length > c.tokensClaimed[tokenAddr] );
205     if (ethRefundAmount.length > c.ethRefund) {
206       uint pct = _toPct(c.balance, finalBalance);
207       uint ethAmount = 0;
208       for (uint i = c.ethRefund; i < ethRefundAmount.length; i++) {
209         ethAmount = ethAmount.add(_applyPct(ethRefundAmount[i], pct));
210       }
211       c.ethRefund = ethRefundAmount.length;
212       if (ethAmount > 0) {
213         receiver.transfer(ethAmount);
214         EthRefunded(receiver, ethAmount);
215       }
216     }
217     if (d.pct.length > c.tokensClaimed[tokenAddr]) {
218       uint tokenAmount = 0;
219       for (i = c.tokensClaimed[tokenAddr]; i < d.pct.length; i++) {
220         tokenAmount = tokenAmount.add(_applyPct(c.balance, d.pct[i]));
221       }
222       c.tokensClaimed[tokenAddr] = d.pct.length;
223       if (tokenAmount > 0) {
224         require (d.token.transfer(receiver, tokenAmount));
225         d.balanceRemaining = d.balanceRemaining.sub(tokenAmount);
226         TokensWithdrawn(receiver, tokenAmount);
227       }  
228     }
229     
230   }
231   
232   // This function can be called during stages one or two to modify the maximum balance of the contract.
233   // It can only be called by the owner. The amount cannot be set to lower than the current balance of the contract.
234   function modifyMaxContractBalance (uint amount) public onlyOwner {
235     require (contractStage < 3);
236     require (amount >= contributionMin);
237     require (amount >= this.balance);
238     maxContractBalance = amount;
239   }
240   
241   // This callable function returns the total pool cap, current balance and remaining balance to be filled.
242   function checkPoolBalance () view public returns (uint poolCap, uint balance, uint remaining) {
243     if (contractStage == 1) {
244       remaining = maxContractBalance.sub(this.balance);
245     } else {
246       remaining = 0;
247     }
248     return (maxContractBalance,this.balance,remaining);
249   }
250   
251   // This callable function returns the balance, contribution cap, and remaining available balance of any contributor.
252   function checkContributorBalance (address addr) view public returns (uint balance, uint cap, uint remaining) {
253     var c = contributorMap[addr];
254     if (contractStage == 1) {
255       remaining = maxContractBalance.sub(this.balance);
256     } else {
257       remaining = 0;
258     }
259     return (c.balance, maxContractBalance, remaining);
260   }
261   
262   // This callable function returns the token balance that a contributor can currently claim.
263   function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint tokenAmount) {
264     var c = contributorMap[addr];
265     var d = distributionMap[tokenAddr];
266     for (uint i = c.tokensClaimed[tokenAddr]; i < d.pct.length; i++) {
267       tokenAmount = tokenAmount.add(_applyPct(c.balance, d.pct[i]));
268     }
269     return tokenAmount;
270   }
271   
272   // This function closes further contributions to the contract, advancing it to stage two.
273   // It can only be called by the owner.  After this call has been made, contributing addresses
274   // can still remove their eth from the contract but cannot contribute any more.
275   function closeContributions () public onlyOwner {
276     require (contractStage == 1);
277     contractStage = 2;
278   }
279   
280   // This function reopens the contract to contributions, returning it to stage one.
281   // It can only be called by the owner during stage two.
282   function reopenContributions () public onlyOwner {
283     require (contractStage == 2);
284     contractStage = 1;
285   }
286 
287   // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,
288   // and advances the contract to stage three. It can only be called by the contract owner during stages one or two.
289   // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,
290   // it is VERY IMPORTANT not to get the amount wrong.
291   function submitPool (uint amountInWei) public onlyOwner noReentrancy {
292     require (contractStage < 3);
293     require (contributionMin <= amountInWei && amountInWei <= this.balance);
294     finalBalance = this.balance;
295     if (amountInWei >= 1000 ether) paidAddress = receiverAddresses[0];
296     else if (amountInWei >= 750 ether) paidAddress = receiverAddresses[1];
297     else paidAddress = receiverAddresses[2];
298     require (paidAddress.call.value(amountInWei).gas(msg.gas.sub(5000))());
299     ethRefundAmount.push(this.balance);
300     contractStage = 3;
301     PoolSubmitted(paidAddress, amountInWei);
302   }
303   
304   // This function opens the contract up for token withdrawals.
305   // It can only be called by the owner during stage 3.  The owner specifies the address of an ERC20 token
306   // contract that this contract has a balance in, and optionally a bool to prevent this token from being
307   // the default withdrawal (in the event of an airdrop, for example).
308   function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyOwner noReentrancy {
309     require (contractStage == 3);
310     if (notDefault) {
311       require (activeToken != 0x00);
312     } else {
313       activeToken = tokenAddr;
314     }
315     var d = distributionMap[tokenAddr];    
316     if (d.pct.length == 0) d.token = ERC20(tokenAddr);
317     uint amount = d.token.balanceOf(this).sub(d.balanceRemaining);
318     require (amount > 0);
319     if (feePct > 0) {
320       require (d.token.transfer(owner,_applyPct(amount, feePct)));
321     }
322     amount = d.token.balanceOf(this).sub(d.balanceRemaining);
323     d.balanceRemaining = d.token.balanceOf(this);
324     d.pct.push(_toPct(amount, finalBalance));
325     WithdrawalsOpen(tokenAddr);
326   }
327   
328   // This is a standard function required for ERC223 compatibility.
329   function tokenFallback (address from, uint value, bytes data) public {
330     ERC223Received(from, value);
331   }
332   
333 }