1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (_a == 0) {
20       return 0;
21     }
22 
23     c = _a * _b;
24     assert(c / _a == _b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
32     // assert(_b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = _a / _b;
34     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
35     return _a / _b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     assert(_b <= _a);
43     return _a - _b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     c = _a + _b;
51     assert(c >= _a);
52     return c;
53   }
54 }
55 
56 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
57 
58 pragma solidity ^0.4.24;
59 
60 
61 /**
62  * @title ERC20Basic
63  * @dev Simpler version of ERC20 interface
64  * See https://github.com/ethereum/EIPs/issues/179
65  */
66 contract ERC20Basic {
67   function totalSupply() public view returns (uint256);
68   function balanceOf(address _who) public view returns (uint256);
69   function transfer(address _to, uint256 _value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
74 
75 pragma solidity ^0.4.24;
76 
77 
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84   function allowance(address _owner, address _spender)
85     public view returns (uint256);
86 
87   function transferFrom(address _from, address _to, uint256 _value)
88     public returns (bool);
89 
90   function approve(address _spender, uint256 _value) public returns (bool);
91   event Approval(
92     address indexed owner,
93     address indexed spender,
94     uint256 value
95   );
96 }
97 
98 // File: contracts/Ownable.sol
99 
100 pragma solidity ^0.4.24;
101 
102 
103 /**
104  * @title Ownable
105  * @dev The Ownable contract has an owner address, and provides basic authorization control
106  * functions, this simplifies the implementation of "user permissions".
107  */
108 contract Ownable {
109   address public owner;
110 
111 
112   event OwnershipRenounced(address indexed previousOwner);
113   event OwnershipTransferred(
114     address indexed previousOwner,
115     address indexed newOwner
116   );
117 
118 
119   /**
120    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
121    * account.
122    */
123   constructor() public {
124     owner = msg.sender;
125   }
126 
127   /**
128    * @dev Throws if called by any account other than the owner.
129    */
130   modifier onlyOwner() {
131     require(msg.sender == owner, "msg.sender not owner");
132     _;
133   }
134 
135   /**
136    * @dev Allows the current owner to relinquish control of the contract.
137    * @notice Renouncing to ownership will leave the contract without an owner.
138    * It will not be possible to call the functions with the `onlyOwner`
139    * modifier anymore.
140    */
141   function renounceOwnership() public onlyOwner {
142     emit OwnershipRenounced(owner);
143     owner = address(0);
144   }
145 
146   /**
147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
148    * @param _newOwner The address to transfer ownership to.
149    */
150   function transferOwnership(address _newOwner) public onlyOwner {
151     _transferOwnership(_newOwner);
152   }
153 
154   /**
155    * @dev Transfers control of the contract to a newOwner.
156    * @param _newOwner The address to transfer ownership to.
157    */
158   function _transferOwnership(address _newOwner) internal {
159     require(_newOwner != address(0), "_newOwner == 0");
160     emit OwnershipTransferred(owner, _newOwner);
161     owner = _newOwner;
162   }
163 }
164 
165 // File: contracts/Pausable.sol
166 
167 pragma solidity ^0.4.24;
168 
169 
170 
171 /**
172  * @title Pausable
173  * @dev Base contract which allows children to implement an emergency stop mechanism.
174  */
175 contract Pausable is Ownable {
176   event Pause();
177   event Unpause();
178 
179   bool public paused = false;
180 
181 
182   /**
183    * @dev Modifier to make a function callable only when the contract is not paused.
184    */
185   modifier whenNotPaused() {
186     require(!paused, "The contract is paused");
187     _;
188   }
189 
190   /**
191    * @dev Modifier to make a function callable only when the contract is paused.
192    */
193   modifier whenPaused() {
194     require(paused, "The contract is not paused");
195     _;
196   }
197 
198   /**
199    * @dev called by the owner to pause, triggers stopped state
200    */
201   function pause() public onlyOwner whenNotPaused {
202     paused = true;
203     emit Pause();
204   }
205 
206   /**
207    * @dev called by the owner to unpause, returns to normal state
208    */
209   function unpause() public onlyOwner whenPaused {
210     paused = false;
211     emit Unpause();
212   }
213 }
214 
215 // File: contracts/Destructible.sol
216 
217 pragma solidity ^0.4.24;
218 
219 
220 
221 /**
222  * @title Destructible
223  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
224  */
225 contract Destructible is Ownable {
226   /**
227    * @dev Transfers the current balance to the owner and terminates the contract.
228    */
229   function destroy() public onlyOwner {
230     selfdestruct(owner);
231   }
232 
233   function destroyAndSend(address _recipient) public onlyOwner {
234     selfdestruct(_recipient);
235   }
236 }
237 
238 // File: contracts/ERC20Supplier.sol
239 
240 pragma solidity ^0.4.24;
241 
242 
243 
244 
245 
246 interface TradingWallet {
247   function depositERC20Token (address _token, uint256 _amount)
248     external returns(bool);
249 }
250 
251 interface TradingWalletMapping {
252   function retrieveWallet(address userAccount)
253     external returns(address walletAddress);
254 }
255 
256 /**
257  * @title ERC20Supplier.
258  * @author Eidoo SAGL.
259  * @dev Distribute a fixed amount of ERC20 based on a rate from a ERC20 reserve to a _receiver for ETH.
260  * Received ETH are redirected to a wallet.
261  */
262 contract ERC20Supplier is
263   Pausable,
264   Destructible
265 {
266   using SafeMath for uint;
267 
268   ERC20 public token;
269   TradingWalletMapping public tradingWalletMapping;
270 
271   address public wallet;
272   address public reserve;
273 
274   uint public rate;
275   uint public rateDecimals;
276   uint public numberOfZeroesFromLastDigit;
277 
278   event LogWithdrawAirdrop(
279     address indexed _from,
280     address indexed _token,
281     uint amount
282   );
283   event LogReleaseTokensTo(
284     address indexed _from,
285     address indexed _to,
286     uint _amount
287   );
288   event LogSetWallet(address indexed _wallet);
289   event LogSetReserve(address indexed _reserve);
290   event LogSetToken(address indexed _token);
291   event LogSetRate(uint _rate);
292   event LogSetRateDecimals(uint _rateDecimals);
293   event LogSetNumberOfZeroesFromLastDigit(
294     uint _numberOfZeroesFromLastDigit
295   );
296 
297   event LogSetTradingWalletMapping(address _tradingWalletMapping);
298   event LogBuyForTradingWallet(
299     address indexed _tradingWallet,
300     address indexed _token,
301     uint _amount
302   );
303 
304   /**
305    * @dev Contract constructor.
306    * @param _wallet Where the received ETH are transfered.
307    * @param _reserve From where the ERC20 token are sent to the purchaser.
308    * @param _token Deployed ERC20 token address.
309    * @param _rate Purchase rate, how many ERC20 for the given ETH.
310    * @param _tradingWalletMappingAddress Trading wallet adress.
311    * @param _rateDecimals Define the decimals precision for the given ERC20.
312    * @param _numberOfZeroesFromLastDigit Define the number of last characters to transform in zero.
313    */
314   constructor(
315     address _wallet,
316     address _reserve,
317     address _token,
318     uint _rate,
319     address _tradingWalletMappingAddress,
320     uint _rateDecimals,
321     uint _numberOfZeroesFromLastDigit
322   )
323     public
324   {
325     require(_wallet != address(0), "_wallet == address(0)");
326     require(_reserve != address(0), "_reserve == address(0)");
327     require(_token != address(0), "_token == address(0)");
328     require(
329       _tradingWalletMappingAddress != 0,
330       "_tradingWalletMappingAddress == 0"
331     );
332     wallet = _wallet;
333     reserve = _reserve;
334     token = ERC20(_token);
335     rate = _rate;
336     tradingWalletMapping = TradingWalletMapping(_tradingWalletMappingAddress);
337     rateDecimals = _rateDecimals;
338     numberOfZeroesFromLastDigit = _numberOfZeroesFromLastDigit;
339   }
340 
341   function() public payable {
342     releaseTokensTo(msg.sender);
343   }
344 
345   /**
346    * @dev Set wallet.
347    * @param _wallet Where the ETH are redirected.
348    */
349   function setWallet(address _wallet)
350     public
351     onlyOwner
352     returns (bool)
353   {
354     require(_wallet != address(0), "_wallet == 0");
355     require(_wallet != wallet, "_wallet == wallet");
356     wallet = _wallet;
357     emit LogSetWallet(wallet);
358     return true;
359   }
360 
361   /**
362    * @dev Set ERC20 reserve.
363    * @param _reserve Where ERC20 are stored.
364    */
365   function setReserve(address _reserve)
366     public
367     onlyOwner
368     returns (bool)
369   {
370     require(_reserve != address(0), "_reserve == 0");
371     require(_reserve != reserve, "_reserve == reserve");
372     reserve = _reserve;
373     emit LogSetReserve(reserve);
374     return true;
375   }
376 
377   /**
378    * @dev Set ERC20 token.
379    * @param _token ERC20 token address.
380    */
381   function setToken(address _token)
382     public
383     onlyOwner
384     returns (bool)
385   {
386     require(_token != address(0), "_token == 0");
387     require(_token != address(token), "_token == token");
388     token = ERC20(_token);
389     emit LogSetToken(token);
390     return true;
391   }
392 
393   /**
394    * @dev Set rate.
395    * @param _rate Multiplier, how many ERC20 for the given ETH.
396    */
397   function setRate(uint _rate)
398     public
399     onlyOwner
400     returns (bool)
401   {
402     require(_rate != rate, "_rate == rate");
403     require(_rate != 0, "_rate == 0");
404     rate = _rate;
405     emit LogSetRate(rate);
406     return true;
407   }
408 
409    /**
410    * @dev Set rate precision.
411    * @param _rateDecimals The precision to represent the quantity of ERC20.
412    */
413   function setRateDecimals(uint _rateDecimals)
414     public
415     onlyOwner
416     returns (bool)
417   {
418     rateDecimals = _rateDecimals;
419     emit LogSetRateDecimals(rateDecimals);
420     return true;
421   }
422 
423   /**
424    * @dev Set truncate from position.
425    * @param _numberOfZeroesFromLastDigit The position target (eg. 1254321000000000000 => 1254000000000000000 it's position tokenDecimal - 3).
426    */
427   function setNumberOfZeroesFromLastDigit(uint _numberOfZeroesFromLastDigit)
428     public
429     onlyOwner
430     returns (bool)
431   {
432     numberOfZeroesFromLastDigit = _numberOfZeroesFromLastDigit;
433     emit LogSetNumberOfZeroesFromLastDigit(numberOfZeroesFromLastDigit);
434     return true;
435   }
436 
437   /**
438    * @dev Eventually withdraw airdropped token.
439    * @param _token ERC20 address to be withdrawed.
440    */
441   function withdrawAirdrop(ERC20 _token)
442     public
443     onlyOwner
444     returns(bool)
445   {
446     require(address(_token) != 0, "_token address == 0");
447     require(
448       _token.balanceOf(this) > 0,
449       "dropped token balance == 0"
450     );
451     uint256 airdroppedTokenAmount = _token.balanceOf(this);
452     _token.transfer(msg.sender, airdroppedTokenAmount);
453     emit LogWithdrawAirdrop(msg.sender, _token, airdroppedTokenAmount);
454     return true;
455   }
456 
457   /**
458    * @dev Set TradingWalletMapping contract instance address.
459    * @param _tradingWalletMappingAddress It's actually the Eidoo Exchange SC address.
460    */
461   function setTradingWalletMappingAddress(
462     address _tradingWalletMappingAddress
463   )
464     public
465     onlyOwner
466     returns(bool)
467   {
468     require(
469       _tradingWalletMappingAddress != address(0),
470       "_tradingWalletMappingAddress == 0");
471     require(
472       _tradingWalletMappingAddress != address(tradingWalletMapping),
473       "_tradingWalletMappingAddress == tradingWalletMapping"
474     );
475     tradingWalletMapping = TradingWalletMapping(_tradingWalletMappingAddress);
476     emit LogSetTradingWalletMapping(tradingWalletMapping);
477     return true;
478   }
479 
480   /**
481    * @dev Function to deposit buyed tokens directly to an Eidoo trading wallet SC.
482    */
483   function buyForTradingWallet()
484     public
485     payable
486     whenNotPaused
487     returns(bool)
488   {
489     uint amount = getAmount(msg.value);
490     require(
491       amount > 0,
492       "amount must be greater than 0"
493     );
494     address _tradingWallet = tradingWalletMapping.retrieveWallet(msg.sender);
495     require(
496       _tradingWallet != address(0),
497       "no tradingWallet associated"
498     );
499     require(
500       token.transferFrom(reserve, address(this), amount),
501       "transferFrom reserve to ERC20Supplier failed"
502     );
503     if (token.allowance(address(this), _tradingWallet) != 0){
504       require(
505         token.approve(_tradingWallet, 0),
506         "approve tradingWallet to zero failed"
507       );
508     }
509     require(
510       token.approve(_tradingWallet, amount),
511       "approve tradingWallet failed"
512     );
513     emit LogBuyForTradingWallet(_tradingWallet, token, amount);
514     wallet.transfer(msg.value);
515     require(
516       TradingWallet(_tradingWallet).depositERC20Token(token, amount),
517       "depositERC20Token failed"
518     );
519     return true;
520   }
521 
522   /**
523    * @dev Function to truncate.
524    * @param _amount The amount of ERC20 to truncate.
525    * @param _numberOfZeroesFromLastDigit The position target (eg. 1254321000000000000 => 1254000000000000000 it's position tokenDecimal - 3).
526    */
527   function truncate(
528     uint _amount,
529     uint _numberOfZeroesFromLastDigit
530   )
531     public
532     pure
533     returns (uint)
534   {
535     return (_amount
536       .div(10 ** _numberOfZeroesFromLastDigit))
537       .mul(10 ** _numberOfZeroesFromLastDigit
538     );
539   }
540 
541   /**
542    * @dev Function to calculate the number of tokens to receive.
543    * @param _value The number of WEI to convert in ERC20.
544    */
545   function getAmount(uint _value)
546     public
547     view
548     returns(uint)
549   {
550     uint amount = (_value.mul(rate).div(10 ** rateDecimals));
551     uint result = truncate(amount, numberOfZeroesFromLastDigit);
552     return result;
553   }
554 
555   /**
556    * @dev Release purchased ERC20 to the buyer.
557    * @param _receiver Where the ERC20 are transfered.
558    */
559   function releaseTokensTo(address _receiver)
560     internal
561     whenNotPaused
562     returns (bool)
563   {
564     uint amount = getAmount(msg.value);
565     wallet.transfer(msg.value);
566     require(
567       token.transferFrom(reserve, _receiver, amount),
568       "transferFrom reserve to _receiver failed"
569     );
570     return true;
571   }
572 }