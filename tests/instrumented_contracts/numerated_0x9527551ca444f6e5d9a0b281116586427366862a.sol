1 pragma solidity 0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // 'Digitize Coin Presale' contract: https://digitizecoin.com 
5 //
6 // Digitize Coin - DTZ: 0x664e6db4044f23c95de63ec299aaa9b39c59328d
7 // SoftCap: 600 ether
8 // HardCap: 4000 ether - 26668000 tokens
9 // Tokens per 1 ether: 6667
10 // KYC: PICOPS https://picops.parity.io
11 //
12 // (c) Radek Ostrowski / http://startonchain.com - The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23   event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   function Ownable() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     require(_newOwner != address(0));
47     owner = _newOwner;
48     emit OwnershipTransferred(owner, _newOwner);
49   }
50 }
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57 
58   /**
59   * @dev Multiplies two numbers, throws on overflow.
60   */
61   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62     if (a == 0) {
63       return 0;
64     }
65     uint256 c = a * b;
66     require(c / a == b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b > 0);
75     uint256 c = a / b;
76     return c;
77   }
78 
79   /**
80   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83     require(b <= a);
84     return a - b;
85   }
86 
87   /**
88   * @dev Adds two numbers, throws on overflow.
89   */
90   function add(uint256 a, uint256 b) internal pure returns (uint256) {
91     uint256 c = a + b;
92     require(c >= a);
93     return c;
94   }
95 }
96 
97 // ----------------------------------------------------------------------------
98 // RefundVault for 'Digitize Coin' project imported from:
99 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/distribution/utils/RefundVault.sol
100 //
101 // Radek Ostrowski / http://startonchain.com / https://digitizecoin.com 
102 // ----------------------------------------------------------------------------
103 
104 /**
105  * @title RefundVault
106  * @dev This contract is used for storing funds while a crowdsale
107  * is in progress. Supports refunding the money if crowdsale fails,
108  * and forwarding it to destination wallet if crowdsale is successful.
109  */
110 contract RefundVault is Ownable {
111   using SafeMath for uint256;
112 
113   enum State { Active, Refunding, Closed }
114 
115   mapping (address => uint256) public deposited;
116   address public wallet;
117   State public state;
118 
119   event Closed();
120   event RefundsEnabled();
121   event Refunded(address indexed _beneficiary, uint256 _weiAmount);
122 
123   /**
124    * @param _wallet Final vault address
125    */
126   function RefundVault(address _wallet) public {
127     require(_wallet != address(0));
128     wallet = _wallet;
129     state = State.Active;
130   }
131 
132   /**
133    * @param _contributor Contributor address
134    */
135   function deposit(address _contributor) onlyOwner public payable {
136     require(state == State.Active);
137     deposited[_contributor] = deposited[_contributor].add(msg.value); 
138   }
139 
140   function close() onlyOwner public {
141     require(state == State.Active);
142     state = State.Closed;
143     emit Closed();
144     wallet.transfer(address(this).balance);
145   }
146 
147   function enableRefunds() onlyOwner public {
148     require(state == State.Active);
149     state = State.Refunding;
150     emit RefundsEnabled();
151   }
152 
153   /**
154    * @param _contributor Contributor address
155    */
156   function refund(address _contributor) public {
157     require(state == State.Refunding);
158     uint256 depositedValue = deposited[_contributor];
159     require(depositedValue > 0);
160     deposited[_contributor] = 0;
161     _contributor.transfer(depositedValue);
162     emit Refunded(_contributor, depositedValue);
163   }
164 }
165 
166 /**
167  * @title CutdownToken
168  * @dev Some ERC20 interface methods used in this contract
169  */
170 contract CutdownToken {
171     function balanceOf(address _who) public view returns (uint256);
172     function transfer(address _to, uint256 _value) public returns (bool);
173     function allowance(address _owner, address _spender) public view returns (uint256);
174 }
175 
176 /**
177  * @title Parity PICOPS Whitelist
178  */
179 contract PICOPSCertifier {
180     function certified(address) public constant returns (bool);
181 }
182 
183 /**
184  * @title DigitizeCoinPresale
185  * @dev Desired amount of DigitizeCoin tokens for this sale must be allocated 
186  * to this contract address prior to the sale start
187  */
188 contract DigitizeCoinPresale is Ownable {
189   using SafeMath for uint256;
190 
191   // token being sold
192   CutdownToken public token;
193   // KYC
194   PICOPSCertifier public picopsCertifier;
195   // refund vault used to hold funds while crowdsale is running
196   RefundVault public vault;
197 
198   // start and end timestamps where contributions are allowed (both inclusive)
199   uint256 public startTime;
200   uint256 public endTime;
201   uint256 public softCap;
202   bool public hardCapReached;
203 
204   mapping(address => bool) public whitelist;
205 
206   // how many token units a buyer gets per wei
207   uint256 public constant rate = 6667;
208 
209   // amount of raised money in wei
210   uint256 public weiRaised;
211 
212   // amount of total contribution for each address
213   mapping(address => uint256) public contributed;
214 
215   // minimum amount of ether allowed, inclusive
216   uint256 public constant minContribution = 0.1 ether;
217 
218   // maximum contribution without KYC, exclusive
219   uint256 public constant maxAnonymousContribution = 5 ether;
220 
221   /**
222    * Custom events
223    */
224   event TokenPurchase(address indexed _purchaser, uint256 _value, uint256 _tokens);
225   event PicopsCertifierUpdated(address indexed _oldCertifier, address indexed _newCertifier);
226   event AddedToWhitelist(address indexed _who);
227   event RemovedFromWhitelist(address indexed _who);
228   event WithdrawnERC20Tokens(address indexed _tokenContract, address indexed _owner, uint256 _balance);
229   event WithdrawnEther(address indexed _owner, uint256 _balance);
230 
231   // constructor
232   function DigitizeCoinPresale(uint256 _startTime, uint256 _durationInDays, 
233     uint256 _softCap, address _wallet, CutdownToken _token, address _picops) public {
234     bool validTimes = _startTime >= now && _durationInDays > 0;
235     bool validAddresses = _wallet != address(0) && _token != address(0) && _picops != address(0);
236     require(validTimes && validAddresses);
237 
238     owner = msg.sender;
239     startTime = _startTime;
240     endTime = _startTime + (_durationInDays * 1 days);
241     softCap = _softCap;
242     token = _token;
243     vault = new RefundVault(_wallet);
244     picopsCertifier = PICOPSCertifier(_picops);
245   }
246 
247   // fallback function used to buy tokens
248   function () external payable {
249     require(validPurchase());
250 
251     address purchaser = msg.sender;
252     uint256 weiAmount = msg.value;
253     uint256 chargedWeiAmount = weiAmount;
254     uint256 tokensAmount = weiAmount.mul(rate);
255     uint256 tokensDue = tokensAmount;
256     uint256 tokensLeft = token.balanceOf(address(this));
257 
258     // if sending more then available, allocate all tokens and refund the rest of ether
259     if(tokensAmount > tokensLeft) {
260       chargedWeiAmount = tokensLeft.div(rate);
261       tokensDue = tokensLeft;
262       hardCapReached = true;
263     } else if(tokensAmount == tokensLeft) {
264       hardCapReached = true;
265     }
266 
267     weiRaised = weiRaised.add(chargedWeiAmount);
268     contributed[purchaser] = contributed[purchaser].add(chargedWeiAmount);
269     token.transfer(purchaser, tokensDue);
270 
271     // refund if appropriate
272     if(chargedWeiAmount < weiAmount) {
273       purchaser.transfer(weiAmount - chargedWeiAmount);
274     }
275     emit TokenPurchase(purchaser, chargedWeiAmount, tokensDue);
276 
277     // forward funds to vault
278     vault.deposit.value(chargedWeiAmount)(purchaser);
279   }
280 
281   /**
282    * @dev Checks whether funding soft cap was reached. 
283    * @return Whether funding soft cap was reached
284    */
285   function softCapReached() public view returns (bool) {
286     return weiRaised >= softCap;
287   }
288 
289   // @return true if crowdsale event has ended
290   function hasEnded() public view returns (bool) {
291     return now > endTime || hardCapReached;
292   }
293 
294   function hasStarted() public view returns (bool) {
295     return now >= startTime;
296   }
297 
298   /**
299    * @dev Contributors can claim refunds here if crowdsale is unsuccessful
300    */
301   function claimRefund() public {
302     require(hasEnded() && !softCapReached());
303 
304     vault.refund(msg.sender);
305   }
306 
307   /**
308    * @dev vault finalization task, called when owner calls finalize()
309    */
310   function finalize() public onlyOwner {
311     require(hasEnded());
312 
313     if (softCapReached()) {
314       vault.close();
315     } else {
316       vault.enableRefunds();
317     }
318   }
319 
320   // @return true if the transaction can buy tokens
321   function validPurchase() internal view returns (bool) {
322     bool withinPeriod = hasStarted() && !hasEnded();
323     bool validContribution = msg.value >= minContribution;
324     bool passKyc = picopsCertifier.certified(msg.sender);
325     //check if contributor can possibly go over anonymous contibution limit
326     bool anonymousAllowed = contributed[msg.sender].add(msg.value) < maxAnonymousContribution;
327     bool allowedKyc = passKyc || anonymousAllowed;
328     return withinPeriod && validContribution && allowedKyc;
329   }
330 
331   // ability to set new certifier even after the sale started
332   function setPicopsCertifier(address _picopsCertifier) onlyOwner public  {
333     require(_picopsCertifier != address(picopsCertifier));
334     emit PicopsCertifierUpdated(address(picopsCertifier), _picopsCertifier);
335     picopsCertifier = PICOPSCertifier(_picopsCertifier);
336   }
337 
338   function passedKYC(address _wallet) view public returns (bool) {
339     return picopsCertifier.certified(_wallet);
340   }
341 
342   // ability to add to whitelist even after the sale started
343   function addToWhitelist(address[] _wallets) public onlyOwner {
344     for (uint i = 0; i < _wallets.length; i++) {
345       whitelist[_wallets[i]] = true;
346       emit AddedToWhitelist(_wallets[i]);
347     }
348   }
349 
350   // ability to remove from whitelist even after the sale started
351   function removeFromWhitelist(address[] _wallets) public onlyOwner {
352     for (uint i = 0; i < _wallets.length; i++) {
353       whitelist[_wallets[i]] = false;
354       emit RemovedFromWhitelist(_wallets[i]);
355     }
356   }
357 
358   /**
359    * @dev Allows to transfer out the ether balance that was forced into this contract, e.g with `selfdestruct`
360    */
361   function withdrawEther() onlyOwner public {
362     require(hasEnded());
363     uint256 totalBalance = address(this).balance;
364     require(totalBalance > 0);
365     owner.transfer(totalBalance);
366     emit WithdrawnEther(owner, totalBalance);
367   }
368   
369   /**
370    * @dev Allows to transfer out the balance of arbitrary ERC20 tokens from the contract.
371    * @param _token The contract address of the ERC20 token.
372    */
373   function withdrawERC20Tokens(CutdownToken _token) onlyOwner public {
374     require(hasEnded());
375     uint256 totalBalance = _token.balanceOf(address(this));
376     require(totalBalance > 0);
377     _token.transfer(owner, totalBalance);
378     emit WithdrawnERC20Tokens(address(_token), owner, totalBalance);
379   }
380 }