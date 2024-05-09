1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 /**
113  * @title Helps contracts guard agains reentrancy attacks.
114  * @author Remco Bloemen <remco@2π.com>
115  * @notice If you mark a function `nonReentrant`, you should also
116  * mark it `external`.
117  */
118 contract ReentrancyGuard {
119 
120   /**
121    * @dev We use a single lock for the whole contract.
122    */
123   bool private reentrancyLock = false;
124 
125   /**
126    * @dev Prevents a contract from calling itself, directly or indirectly.
127    * @notice If you mark a function `nonReentrant`, you should also
128    * mark it `external`. Calling one nonReentrant function from
129    * another is not supported. Instead, you can implement a
130    * `private` function doing the actual work, and a `external`
131    * wrapper marked as `nonReentrant`.
132    */
133   modifier nonReentrant() {
134     require(!reentrancyLock);
135     reentrancyLock = true;
136     _;
137     reentrancyLock = false;
138   }
139 
140 }
141 
142 /**
143  * @title ERC20Basic
144  * @dev Simpler version of ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/179
146  */
147 contract ERC20Basic {
148   function totalSupply() public view returns (uint256);
149   function balanceOf(address who) public view returns (uint256);
150   function transfer(address to, uint256 value) public returns (bool);
151   event Transfer(address indexed from, address indexed to, uint256 value);
152 }
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 contract ERC20 is ERC20Basic {
159   function allowance(address owner, address spender)
160     public view returns (uint256);
161 
162   function transferFrom(address from, address to, uint256 value)
163     public returns (bool);
164 
165   function approve(address spender, uint256 value) public returns (bool);
166   event Approval(
167     address indexed owner,
168     address indexed spender,
169     uint256 value
170   );
171 }
172 
173 contract BablosTokenInterface is ERC20 {
174   bool public frozen;
175   function burn(uint256 _value) public;
176   function setSale(address _sale) public;
177   function thaw() external;
178 }
179 
180 contract PriceUpdaterInterface {
181   enum Currency { ETH, BTC, WME, WMZ, WMR, WMX }
182 
183   uint public decimalPrecision = 3;
184 
185   mapping(uint => uint) public price;
186 }
187 
188 contract BablosCrowdsaleWalletInterface {
189   enum State {
190     // gathering funds
191     GATHERING,
192     // returning funds to investors
193     REFUNDING,
194     // funds can be pulled by owners
195     SUCCEEDED
196   }
197 
198   event StateChanged(State state);
199   event Invested(address indexed investor, PriceUpdaterInterface.Currency currency, uint amount, uint tokensReceived);
200   event EtherWithdrawan(address indexed to, uint value);
201   event RefundSent(address indexed to, uint value);
202   event ControllerRetired(address was);
203 
204   /// @dev price updater interface
205   PriceUpdaterInterface public priceUpdater;
206 
207   /// @notice total amount of investments in currencies
208   mapping(uint => uint) public totalInvested;
209 
210   /// @notice state of the registry
211   State public state = State.GATHERING;
212 
213   /// @dev balances of investors in wei
214   mapping(address => uint) public weiBalances;
215 
216   /// @dev balances of tokens sold to investors
217   mapping(address => uint) public tokenBalances;
218 
219   /// @dev list of unique investors
220   address[] public investors;
221 
222   /// @dev token accepted for refunds
223   BablosTokenInterface public token;
224 
225   /// @dev operations will be controlled by this address
226   address public controller;
227 
228   /// @dev the team's tokens percent
229   uint public teamPercent;
230 
231   /// @dev tokens sent to initial PR - they will be substracted, when tokens will be burn
232   uint public prTokens;
233   
234   /// @dev performs only allowed state transitions
235   function changeState(State _newState) external;
236 
237   /// @dev records an investment
238   /// @param _investor who invested
239   /// @param _tokenAmount the amount of token bought, calculation is handled by ICO
240   /// @param _currency the currency in which investor invested
241   /// @param _amount the invested amount
242   function invested(address _investor, uint _tokenAmount, PriceUpdaterInterface.Currency _currency, uint _amount) external payable;
243 
244   /// @dev get total invested in ETH
245   function getTotalInvestedEther() external view returns (uint);
246 
247   /// @dev get total invested in EUR
248   function getTotalInvestedEur() external view returns (uint);
249 
250   /// @notice withdraw `_value` of ether to his address, can be called if crowdsale succeeded
251   /// @param _value amount of wei to withdraw
252   function withdrawEther(uint _value) external;
253 
254   /// @notice owner: send `_value` of tokens to his address, can be called if
255   /// crowdsale failed and some of the investors refunded the ether
256   /// @param _value amount of token-wei to send
257   function withdrawTokens(uint _value) external;
258 
259   /// @notice withdraw accumulated balance, called by payee in case crowdsale failed
260   /// @dev caller should approve tokens bought during ICO to this contract
261   function withdrawPayments() external;
262 
263   /// @dev returns investors count
264   function getInvestorsCount() external view returns (uint);
265 
266   /// @dev ability for controller to step down
267   function detachController() external;
268 
269   /// @dev unhold holded team's tokens
270   function unholdTeamTokens() external;
271 }
272 
273 contract BablosCrowdsaleWallet is BablosCrowdsaleWalletInterface, Ownable, ReentrancyGuard {
274   using SafeMath for uint;
275 
276   modifier requiresState(State _state) {
277     require(state == _state);
278     _;
279   }
280 
281   modifier onlyController() {
282     require(msg.sender == controller);
283     _;
284   }
285   
286   constructor(
287     BablosTokenInterface _token, 
288     address _controller, 
289     PriceUpdaterInterface _priceUpdater, 
290     uint _teamPercent, 
291     uint _prTokens) 
292       public 
293   {
294     token = _token;
295     controller = _controller;
296     priceUpdater = _priceUpdater;
297     teamPercent = _teamPercent;
298     prTokens = _prTokens;
299   }
300 
301   function getTotalInvestedEther() external view returns (uint) {
302     uint etherPrice = priceUpdater.price(uint(PriceUpdaterInterface.Currency.ETH));
303     uint totalInvestedEth = totalInvested[uint(PriceUpdaterInterface.Currency.ETH)];
304     uint totalAmount = _totalInvestedNonEther();
305     return totalAmount.mul(1 ether).div(etherPrice).add(totalInvestedEth);
306   }
307 
308   function getTotalInvestedEur() external view returns (uint) {
309     uint totalAmount = _totalInvestedNonEther();
310     uint etherAmount = totalInvested[uint(PriceUpdaterInterface.Currency.ETH)]
311       .mul(priceUpdater.price(uint(PriceUpdaterInterface.Currency.ETH)))
312       .div(1 ether);
313     return totalAmount.add(etherAmount);
314   }
315 
316   /// @dev total invested in EUR within ETH amount
317   function _totalInvestedNonEther() internal view returns (uint) {
318     uint totalAmount;
319     uint precision = priceUpdater.decimalPrecision();
320     // BTC
321     uint btcAmount = totalInvested[uint(PriceUpdaterInterface.Currency.BTC)]
322       .mul(10 ** precision)
323       .div(priceUpdater.price(uint(PriceUpdaterInterface.Currency.BTC)));
324     totalAmount = totalAmount.add(btcAmount);
325     // WME
326     uint wmeAmount = totalInvested[uint(PriceUpdaterInterface.Currency.WME)]
327       .mul(10 ** precision)
328       .div(priceUpdater.price(uint(PriceUpdaterInterface.Currency.WME)));
329     totalAmount = totalAmount.add(wmeAmount);
330     // WMZ
331     uint wmzAmount = totalInvested[uint(PriceUpdaterInterface.Currency.WMZ)]
332       .mul(10 ** precision)
333       .div(priceUpdater.price(uint(PriceUpdaterInterface.Currency.WMZ)));
334     totalAmount = totalAmount.add(wmzAmount);
335     // WMR
336     uint wmrAmount = totalInvested[uint(PriceUpdaterInterface.Currency.WMR)]
337       .mul(10 ** precision)
338       .div(priceUpdater.price(uint(PriceUpdaterInterface.Currency.WMR)));
339     totalAmount = totalAmount.add(wmrAmount);
340     // WMX
341     uint wmxAmount = totalInvested[uint(PriceUpdaterInterface.Currency.WMX)]
342       .mul(10 ** precision)
343       .div(priceUpdater.price(uint(PriceUpdaterInterface.Currency.WMX)));
344     totalAmount = totalAmount.add(wmxAmount);
345     return totalAmount;
346   }
347 
348   function changeState(State _newState) external onlyController {
349     assert(state != _newState);
350 
351     if (State.GATHERING == state) {
352       assert(_newState == State.REFUNDING || _newState == State.SUCCEEDED);
353     } else {
354       assert(false);
355     }
356 
357     state = _newState;
358     emit StateChanged(state);
359   }
360 
361   function invested(
362     address _investor,
363     uint _tokenAmount,
364     PriceUpdaterInterface.Currency _currency,
365     uint _amount) 
366       external 
367       payable
368       onlyController
369   {
370     require(state == State.GATHERING || state == State.SUCCEEDED);
371     uint amount;
372     if (_currency == PriceUpdaterInterface.Currency.ETH) {
373       amount = msg.value;
374       weiBalances[_investor] = weiBalances[_investor].add(amount);
375     } else {
376       amount = _amount;
377     }
378     require(amount != 0);
379     require(_tokenAmount != 0);
380     assert(_investor != controller);
381 
382     // register investor
383     if (tokenBalances[_investor] == 0) {
384       investors.push(_investor);
385     }
386 
387     // register payment
388     totalInvested[uint(_currency)] = totalInvested[uint(_currency)].add(amount);
389     tokenBalances[_investor] = tokenBalances[_investor].add(_tokenAmount);
390 
391     emit Invested(_investor, _currency, amount, _tokenAmount);
392   }
393 
394   function withdrawEther(uint _value)
395     external
396     onlyOwner
397     requiresState(State.SUCCEEDED) 
398   {
399     require(_value > 0 && address(this).balance >= _value);
400     owner.transfer(_value);
401     emit EtherWithdrawan(owner, _value);
402   }
403 
404   function withdrawTokens(uint _value)
405     external
406     onlyOwner
407     requiresState(State.REFUNDING)
408   {
409     require(_value > 0 && token.balanceOf(address(this)) >= _value);
410     token.transfer(owner, _value);
411   }
412 
413   function withdrawPayments()
414     external
415     nonReentrant
416     requiresState(State.REFUNDING)
417   {
418     address payee = msg.sender;
419     uint payment = weiBalances[payee];
420     uint tokens = tokenBalances[payee];
421 
422     // check that there is some ether to withdraw
423     require(payment != 0);
424     // check that the contract holds enough ether
425     require(address(this).balance >= payment);
426     // check that the investor (payee) gives back all tokens bought during ICO
427     require(token.allowance(payee, address(this)) >= tokenBalances[payee]);
428 
429     totalInvested[uint(PriceUpdaterInterface.Currency.ETH)] = totalInvested[uint(PriceUpdaterInterface.Currency.ETH)].sub(payment);
430     weiBalances[payee] = 0;
431     tokenBalances[payee] = 0;
432 
433     token.transferFrom(payee, address(this), tokens);
434 
435     payee.transfer(payment);
436     emit RefundSent(payee, payment);
437   }
438 
439   function getInvestorsCount() external view returns (uint) { return investors.length; }
440 
441   function detachController() external onlyController {
442     address was = controller;
443     controller = address(0);
444     emit ControllerRetired(was);
445   }
446 
447   function unholdTeamTokens() external onlyController {
448     uint tokens = token.balanceOf(address(this));
449     if (state == State.SUCCEEDED) {
450       uint soldTokens = token.totalSupply().sub(token.balanceOf(address(this))).sub(prTokens);
451       uint soldPecent = 100 - teamPercent;
452       uint teamShares = soldTokens.mul(teamPercent).div(soldPecent).sub(prTokens);
453       token.transfer(owner, teamShares);
454       token.burn(token.balanceOf(address(this)));
455     } else {
456       token.approve(owner, tokens);
457     }
458   }
459 }