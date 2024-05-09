1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 contract ERC20 {
39   function balanceOf(address _owner) constant returns (uint256 balance) {}
40   function transfer(address _to, uint256 _value) returns (bool success) {}
41 }
42 
43 contract PresalePool {
44 
45   // SafeMath is a library to ensure that math operations do not have overflow errors
46   // https://zeppelin-solidity.readthedocs.io/en/latest/safemath.html
47   using SafeMath for uint;
48   
49   // The contract has 3 stages:
50   // 1 - The initial state. Any addresses can deposit or withdraw eth to the contract.
51   // 2 - The owner has closed the contract for further deposits. Contributors can still withdraw their eth from the contract.
52   // 3 - The eth is sent from the contract to the receiver. Unused eth can be claimed by contributors immediately. Once tokens are sent to the contract,
53   //     the owner enables withdrawals and contributors can withdraw their tokens.
54   uint8 public contractStage = 1;
55   
56   // These variables are set at the time of contract creation
57   // the address that creates the contract
58   address public owner;
59   // the minimum eth amount (in wei) that can be sent by a contributing address
60   uint public contributionMin;
61   // the maximum eth amount (in wei) that to be held by the contract
62   uint public contractMax;
63   // the % of tokens kept by the contract owner
64   uint public feePct;
65   // the address that the pool will be paid out to
66   address public receiverAddress;
67   
68   // These variables are all initially set to 0 and will be set at some point during the contract
69   // the amount of eth (in wei) sent to the receiving address (set in stage 3)
70   uint public submittedAmount;
71   // the % of contributed eth to be refunded to contributing addresses (set in stage 3)
72   uint public refundPct;
73   // the number of contributors to the pool
74   uint public contributorCount;
75   // the default token contract to be used for withdrawing tokens in stage 3
76   address public activeToken;
77   
78   // a data structure for holding the contribution amount, cap, eth refund status, and token withdrawal status for each contributing address
79   struct Contributor {
80     bool refundedEth;
81     uint balance;
82     mapping (address => uint) tokensClaimed;
83   }
84   // a mapping that holds the contributor struct for each contributing address
85   mapping (address => Contributor) contributors;
86   
87   // a data structure for holding information related to token withdrawals.
88   struct TokenAllocation {
89     ERC20 token;
90     uint pct;
91     uint claimRound;
92     uint claimCount;
93   }
94   // a mapping that holds the token allocation struct for each token address
95   mapping (address => TokenAllocation) distribution;
96   
97   
98   // this modifier is used for functions that can only be accessed by the contract creator
99   modifier onlyOwner () {
100     require (msg.sender == owner);
101     _;
102   }
103   
104   // this modifier is used to prevent re-entrancy exploits during contract > contract interaction
105   bool locked;
106   modifier noReentrancy() {
107     require(!locked);
108     locked = true;
109     _;
110     locked = false;
111   }
112   
113   event ContributorBalanceChanged (address contributor, uint totalBalance);
114   event TokensWithdrawn (address receiver, uint amount);
115   event EthRefunded (address receiver, uint amount);
116   event ReceiverAddressChanged ( address _addr);
117   event WithdrawalsOpen (address tokenAddr);
118   event ERC223Received (address token, uint value);
119    
120   // These are internal functions used for calculating fees, eth and token allocations as %
121   // returns a value as a % accurate to 20 decimal points
122   function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {
123     return numerator.mul(10 ** 20) / denominator;
124   }
125   
126   // returns % of any number, where % given was generated with toPct
127   function _applyPct (uint numerator, uint pct) internal pure returns (uint) {
128     return numerator.mul(pct) / (10 ** 20);
129   }
130   
131   // This function is called at the time of contract creation and sets the initial variables.
132   function PresalePool(address receiver, uint individualMin, uint poolMax, uint fee) public {
133     require (fee < 100);
134     require (100000000000000000 <= individualMin);
135     require (individualMin <= poolMax);
136     require (receiver != 0x00);
137     owner = msg.sender;
138     receiverAddress = receiver;
139     contributionMin = individualMin;
140     contractMax = poolMax;
141     feePct = _toPct(fee,100);
142   }
143   
144   // This function is called whenever eth is sent into the contract.
145   // The amount sent is added to the balance in the Contributor struct associated with the sending address.
146   function () payable public {
147     require (contractStage == 1);
148     require (this.balance <= contractMax);
149     var c = contributors[msg.sender];
150     uint newBalance = c.balance.add(msg.value);
151     require (newBalance >= contributionMin);
152     if (contributors[msg.sender].balance == 0) {
153       contributorCount = contributorCount.add(1);
154     }
155     contributors[msg.sender].balance = newBalance;
156     ContributorBalanceChanged(msg.sender, newBalance);
157   }
158     
159   // This function is called to withdraw eth or tokens from the contract.
160   // It can only be called by addresses that have a balance greater than 0.
161   // If called during contract stages one or two, the full eth balance deposited into the contract will be returned and the contributor's balance will be reset to 0.
162   // If called during stage three, the contributor's unused eth will be returned, as well as any available tokens.
163   // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).
164   function withdraw (address tokenAddr) public {
165     var c = contributors[msg.sender];
166     require (c.balance > 0);
167     if (contractStage < 3) {
168       uint amountToTransfer = c.balance;
169       c.balance = 0;
170       msg.sender.transfer(amountToTransfer);
171       contributorCount = contributorCount.sub(1);
172       ContributorBalanceChanged(msg.sender, 0);
173     } else {
174       _withdraw(msg.sender,tokenAddr);
175     }  
176   }
177   
178   // This function allows the contract owner to force a withdrawal to any contributor.
179   // It is useful if a new round of tokens can be distributed but some contributors have
180   // not yet withdrawn their previous allocation.
181   function withdrawFor (address contributor, address tokenAddr) public onlyOwner {
182     require (contractStage == 3);
183     require (contributors[contributor].balance > 0);
184     _withdraw(contributor,tokenAddr);
185   }
186   
187   // This internal function handles withdrawals during stage three.
188   // The associated events will fire to notify when a refund or token allocation is claimed.
189   function _withdraw (address receiver, address tokenAddr) internal {
190     assert (contractStage == 3);
191     var c = contributors[receiver];
192     if (tokenAddr == 0x00) {
193       tokenAddr = activeToken;
194     }
195     var d = distribution[tokenAddr];
196     require ( (refundPct > 0 && !c.refundedEth) || d.claimRound > c.tokensClaimed[tokenAddr] );
197     if (refundPct > 0 && !c.refundedEth) {
198       uint ethAmount = _applyPct(c.balance,refundPct);
199       c.refundedEth = true;
200       if (ethAmount == 0) return;
201       if (ethAmount+10 > c.balance) {
202         ethAmount = c.balance-10;
203       }
204       c.balance = c.balance.sub(ethAmount+10);
205       receiver.transfer(ethAmount);
206       EthRefunded(receiver,ethAmount);
207     }
208     if (d.claimRound > c.tokensClaimed[tokenAddr]) {
209       uint amount = _applyPct(c.balance,d.pct);
210       c.tokensClaimed[tokenAddr] = d.claimRound;
211       d.claimCount = d.claimCount.add(1);
212       if (amount > 0) {
213         require (d.token.transfer(receiver,amount));
214       }
215       TokensWithdrawn(receiver,amount);
216     }
217   }
218   
219   // This function can be called during stages one or two to modify the maximum balance of the contract.
220   // It can only be called by the owner. The amount cannot be set to lower than the current balance of the contract.
221   function modifyMaxContractBalance (uint amount) public onlyOwner {
222     require (contractStage < 3);
223     require (amount >= contributionMin);
224     require (amount >= this.balance);
225     contractMax = amount;
226   }
227   
228   // This callable function returns the total pool cap, current balance and remaining balance to be filled.
229   function checkPoolBalance () view public returns (uint poolCap, uint balance, uint remaining) {
230     return (contractMax,this.balance,contractMax.sub(this.balance));
231   }
232   
233   // This callable function returns the balance, contribution cap, and remaining available balance of any contributor.
234   function checkContributorBalance (address addr) view public returns (uint balance) {
235     return contributors[addr].balance;
236   }
237   
238   // This callable function returns the token balance that a contributor can currently claim.
239   function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint amount) {
240     var c = contributors[addr];
241     var d = distribution[tokenAddr];
242     if (d.claimRound == c.tokensClaimed[tokenAddr]) return 0;
243     return _applyPct(c.balance,d.pct);
244   }
245   
246   // This function closes further contributions to the contract, advancing it to stage two.
247   // It can only be called by the owner.  After this call has been made, contributing addresses
248   // can still remove their eth from the contract but cannot deposit any more.
249   function closeContributions () public onlyOwner {
250     require (contractStage == 1);
251     contractStage = 2;
252   }
253   
254   // This function reopens the contract to further deposits, returning it to stage one.
255   // It can only be called by the owner during stage two.
256   function reopenContributions () public onlyOwner {
257     require (contractStage == 2);
258     contractStage = 1;
259   }
260   
261   // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,
262   // and advances the contract to stage three. It can only be called by the contract owner during stages one or two.
263   // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,
264   // it is VERY IMPORTANT not to get the amount wrong.
265   function submitPool (uint amountInWei) public onlyOwner noReentrancy {
266     require (contractStage < 3);
267     require (contributionMin <= amountInWei && amountInWei <= this.balance);
268     uint b = this.balance;
269     require (receiverAddress.call.value(amountInWei).gas(msg.gas.sub(5000))());
270     submittedAmount = b.sub(this.balance);
271     refundPct = _toPct(this.balance,b);
272     contractStage = 3;
273   }
274   
275   // This function opens the contract up for token withdrawals.
276   // It can only be called by the owner during stage 3.  The owner specifies the address of an ERC20 token
277   // contract that this contract has a balance in, and optionally a bool to prevent this token from being
278   // the default withdrawal (in the event of an airdrop, for example).
279   // The function can only be called if there is not currently a token distribution 
280   function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyOwner noReentrancy {
281     require (contractStage == 3);
282     if (notDefault) {
283       require (activeToken != 0x00);
284     } else {
285       activeToken = tokenAddr;
286     }
287     var d = distribution[tokenAddr];
288     require (d.claimRound == 0 || d.claimCount == contributorCount);
289     d.token = ERC20(tokenAddr);
290     uint amount = d.token.balanceOf(this);
291     require (amount > 0);
292     if (feePct > 0) {
293       require (d.token.transfer(owner,_applyPct(amount,feePct)));
294     }
295     d.pct = _toPct(d.token.balanceOf(this),submittedAmount);
296     d.claimCount = 0;
297     d.claimRound = d.claimRound.add(1);
298   }
299   
300   // This is a standard function required for ERC223 compatibility.
301   function tokenFallback (address from, uint value, bytes data) public {
302     ERC223Received (from, value);
303   }
304   
305 }