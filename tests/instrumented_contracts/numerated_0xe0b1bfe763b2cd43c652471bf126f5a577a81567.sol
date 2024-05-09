1 pragma solidity 0.4.24;
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
53 contract ERC20NoReturn {
54     uint256 public decimals;
55     string public name;
56     string public symbol;
57     function totalSupply() public view returns (uint);
58     function balanceOf(address tokenOwner) public view returns (uint balance);
59     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
60     function transfer(address to, uint tokens) public;
61     function approve(address spender, uint tokens) public;
62     function transferFrom(address from, address to, uint tokens) public;
63 
64     event Transfer(address indexed from, address indexed to, uint tokens);
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66 }
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74   address public owner;
75 
76 
77   event OwnershipRenounced(address indexed previousOwner);
78   event OwnershipTransferred(
79     address indexed previousOwner,
80     address indexed newOwner
81   );
82 
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   constructor() public {
89     owner = msg.sender;
90   }
91 
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99 
100   /**
101    * @dev Allows the current owner to relinquish control of the contract.
102    */
103   function renounceOwnership() public onlyOwner {
104     emit OwnershipRenounced(owner);
105     owner = address(0);
106   }
107 
108   /**
109    * @dev Allows the current owner to transfer control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address _newOwner) public onlyOwner {
113     _transferOwnership(_newOwner);
114   }
115 
116   /**
117    * @dev Transfers control of the contract to a newOwner.
118    * @param _newOwner The address to transfer ownership to.
119    */
120   function _transferOwnership(address _newOwner) internal {
121     require(_newOwner != address(0));
122     emit OwnershipTransferred(owner, _newOwner);
123     owner = _newOwner;
124   }
125 }
126 
127 /**
128  * @title ERC20Basic
129  * @dev Simpler version of ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/179
131  */
132 contract ERC20Basic {
133   function totalSupply() public view returns (uint256);
134   function balanceOf(address who) public view returns (uint256);
135   function transfer(address to, uint256 value) public returns (bool);
136   event Transfer(address indexed from, address indexed to, uint256 value);
137 }
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 contract ERC20 is ERC20Basic {
144   function allowance(address owner, address spender)
145     public view returns (uint256);
146 
147   function transferFrom(address from, address to, uint256 value)
148     public returns (bool);
149 
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(
152     address indexed owner,
153     address indexed spender,
154     uint256 value
155   );
156 }
157 
158 contract ERC20Extended is ERC20 {
159     uint256 public decimals;
160     string public name;
161     string public symbol;
162 
163 }
164 
165 contract OlympusExchangeAdapterManagerInterface is Ownable {
166     function pickExchange(ERC20Extended _token, uint _amount, uint _rate, bool _isBuying) public view returns (bytes32 exchangeId);
167     function supportsTradingPair(address _srcAddress, address _destAddress, bytes32 _exchangeId) external view returns(bool supported);
168     function getExchangeAdapter(bytes32 _exchangeId) external view returns(address);
169     function isValidAdapter(address _adapter) external view returns(bool);
170     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount, bytes32 _exchangeId)
171         external view returns(uint expectedRate, uint slippageRate);
172 }
173 
174 library Utils {
175 
176     uint  constant PRECISION = (10**18);
177     uint  constant MAX_DECIMALS = 18;
178 
179     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
180         if( dstDecimals >= srcDecimals ) {
181             require((dstDecimals-srcDecimals) <= MAX_DECIMALS);
182             return (srcQty * rate * (10**(dstDecimals-srcDecimals))) / PRECISION;
183         } else {
184             require((srcDecimals-dstDecimals) <= MAX_DECIMALS);
185             return (srcQty * rate) / (PRECISION * (10**(srcDecimals-dstDecimals)));
186         }
187     }
188 
189     // function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
190     //     if( srcDecimals >= dstDecimals ) {
191     //         require((srcDecimals-dstDecimals) <= MAX_DECIMALS);
192     //         return (PRECISION * dstQty * (10**(srcDecimals - dstDecimals))) / rate;
193     //     } else {
194     //         require((dstDecimals-srcDecimals) <= MAX_DECIMALS);
195     //         return (PRECISION * dstQty) / (rate * (10**(dstDecimals - srcDecimals)));
196     //     }
197     // }
198 }
199 
200 contract ComponentInterface {
201     string public name;
202     string public description;
203     string public category;
204     string public version;
205 }
206 
207 contract ExchangeInterface is ComponentInterface {
208     /*
209      * @dev Checks if a trading pair is available
210      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
211      * @param address _sourceAddress The token to sell for the destAddress.
212      * @param address _destAddress The token to buy with the source token.
213      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
214      * @return boolean whether or not the trading pair is supported by this exchange provider
215      */
216     function supportsTradingPair(address _srcAddress, address _destAddress, bytes32 _exchangeId)
217         external view returns(bool supported);
218 
219     /*
220      * @dev Buy a single token with ETH.
221      * @param ERC20Extended _token The token to buy, should be an ERC20Extended address.
222      * @param uint _amount Amount of ETH used to buy this token. Make sure the value sent to this function is the same as the _amount.
223      * @param uint _minimumRate The minimum amount of tokens to receive for 1 ETH.
224      * @param address _depositAddress The address to send the bought tokens to.
225      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
226      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here.
227      * @return boolean whether or not the trade succeeded.
228      */
229     function buyToken
230         (
231         ERC20Extended _token, uint _amount, uint _minimumRate,
232         address _depositAddress, bytes32 _exchangeId, address _partnerId
233         ) external payable returns(bool success);
234 
235     /*
236      * @dev Sell a single token for ETH. Make sure the token is approved beforehand.
237      * @param ERC20Extended _token The token to sell, should be an ERC20Extended address.
238      * @param uint _amount Amount of tokens to sell.
239      * @param uint _minimumRate The minimum amount of ETH to receive for 1 ERC20Extended token.
240      * @param address _depositAddress The address to send the bought tokens to.
241      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
242      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here
243      * @return boolean boolean whether or not the trade succeeded.
244      */
245     function sellToken
246         (
247         ERC20Extended _token, uint _amount, uint _minimumRate,
248         address _depositAddress, bytes32 _exchangeId, address _partnerId
249         ) external returns(bool success);
250 }
251 
252 contract KyberNetworkInterface {
253 
254     function getExpectedRate(ERC20Extended src, ERC20Extended dest, uint srcQty)
255         external view returns (uint expectedRate, uint slippageRate);
256 
257     function trade(
258         ERC20Extended source,
259         uint srcAmount,
260         ERC20Extended dest,
261         address destAddress,
262         uint maxDestAmount,
263         uint minConversionRate,
264         address walletId)
265         external payable returns(uint);
266 }
267 
268 contract OlympusExchangeAdapterInterface is Ownable {
269 
270     function supportsTradingPair(address _srcAddress, address _destAddress)
271         external view returns(bool supported);
272 
273     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount)
274         external view returns(uint expectedRate, uint slippageRate);
275 
276     function sellToken
277         (
278         ERC20Extended _token, uint _amount, uint _minimumRate,
279         address _depositAddress
280         ) external returns(bool success);
281 
282     function buyToken
283         (
284         ERC20Extended _token, uint _amount, uint _minimumRate,
285         address _depositAddress
286         ) external payable returns(bool success);
287 
288     function enable() external returns(bool);
289     function disable() external returns(bool);
290     function isEnabled() external view returns (bool success);
291 
292     function setExchangeDetails(bytes32 _id, bytes32 _name) external returns(bool success);
293     function getExchangeDetails() external view returns(bytes32 _name, bool _enabled);
294 
295 }
296 
297 contract PriceProviderInterface is ComponentInterface {
298     /*
299      * @dev Returns the expected price for 1 of sourceAddress.
300      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
301      * @param address _sourceAddress The token to sell for the destAddress.
302      * @param address _destAddress The token to buy with the source token.
303      * @param uint _amount The amount of tokens which is wanted to buy.
304      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
305      * @return returns the expected and slippage rate for the specified conversion
306      */
307     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount, bytes32 _exchangeId)
308         external view returns(uint expectedRate, uint slippageRate);
309 }
310 
311 contract OlympusExchangeInterface is ExchangeInterface, PriceProviderInterface, Ownable {
312     /*
313      * @dev Buy multiple tokens at once with ETH.
314      * @param ERC20Extended[] _tokens The tokens to buy, should be an array of ERC20Extended addresses.
315      * @param uint[] _amounts Amount of ETH used to buy this token. Make sure the value sent to this function is the same as the sum of this array.
316      * @param uint[] _minimumRates The minimum amount of tokens to receive for 1 ETH.
317      * @param address _depositAddress The address to send the bought tokens to.
318      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
319      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here
320      * @return boolean boolean whether or not the trade succeeded.
321      */
322     function buyTokens
323         (
324         ERC20Extended[] _tokens, uint[] _amounts, uint[] _minimumRates,
325         address _depositAddress, bytes32 _exchangeId, address _partnerId
326         ) external payable returns(bool success);
327 
328     /*
329      * @dev Sell multiple tokens at once with ETH, make sure all of the tokens are approved to be transferred beforehand with the Olympus Exchange address.
330      * @param ERC20Extended[] _tokens The tokens to sell, should be an array of ERC20Extended addresses.
331      * @param uint[] _amounts Amount of tokens to sell this token. Make sure the value sent to this function is the same as the sum of this array.
332      * @param uint[] _minimumRates The minimum amount of ETH to receive for 1 specified ERC20Extended token.
333      * @param address _depositAddress The address to send the bought tokens to.
334      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
335      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here
336      * @return boolean boolean whether or not the trade succeeded.
337      */
338     function sellTokens
339         (
340         ERC20Extended[] _tokens, uint[] _amounts, uint[] _minimumRates,
341         address _depositAddress, bytes32 _exchangeId, address _partnerId
342         ) external returns(bool success);
343 }
344 
345 contract ComponentContainerInterface {
346     mapping (string => address) components;
347 
348     event ComponentUpdated (string _name, address _componentAddress);
349 
350     function setComponent(string _name, address _providerAddress) internal returns (bool success);
351     function getComponentByName(string name) public view returns (address);
352 
353 }
354 
355 contract DerivativeInterface is ERC20Extended, Ownable, ComponentContainerInterface {
356 
357     enum DerivativeStatus { New, Active, Paused, Closed }
358     enum DerivativeType { Index, Fund }
359 
360     string public description;
361     string public category;
362     string public version;
363     DerivativeType public fundType;
364 
365     address[] public tokens;
366     DerivativeStatus public status;
367 
368     // invest, withdraw is done in transfer.
369     function invest() public payable returns(bool success);
370     function changeStatus(DerivativeStatus _status) public returns(bool);
371     function getPrice() public view returns(uint);
372 }
373 
374 contract FeeChargerInterface {
375     // TODO: change this to mainnet MOT address before deployment.
376     // solhint-disable-next-line
377     ERC20Extended public MOT = ERC20Extended(0x263c618480DBe35C300D8d5EcDA19bbB986AcaeD);
378     // kovan MOT: 0x41Dee9F481a1d2AA74a3f1d0958C1dB6107c686A
379 }
380 
381 contract FeeCharger is Ownable, FeeChargerInterface {
382     using SafeMath for uint256;
383 
384     FeeMode public feeMode = FeeMode.ByCalls;
385     uint public feePercentage = 0;
386     uint public feeAmount = 0;
387     uint constant public FEE_CHARGER_DENOMINATOR = 10000;
388     address private olympusWallet = 0x09227deaeE08a5Ba9D6Eb057F922aDfAd191c36c;
389     bool private isPaying = false;
390 
391     enum FeeMode {
392         ByTransactionAmount,
393         ByCalls
394     }
395 
396     modifier feePayable(uint _amount) {
397       uint fee = calculateFee(_amount);
398       DerivativeInterface derivative = DerivativeInterface(msg.sender);
399       // take money directly from the derivative.
400       require(MOT.balanceOf(address(derivative)) >= fee);
401       require(MOT.allowance(address(derivative), address(this)) >= fee);
402       _;
403     }
404 
405     function calculateFee(uint _amount) public view returns (uint amount) {
406         uint fee;
407         if (feeMode == FeeMode.ByTransactionAmount) {
408             fee = _amount * feePercentage / FEE_CHARGER_DENOMINATOR;
409         } else if (feeMode == FeeMode.ByCalls) {
410             fee = feeAmount;
411         } else {
412           revert("Unsupported fee mode.");
413         }
414 
415         return fee;
416     }    
417 
418     function adjustFeeMode(FeeMode _newMode) external onlyOwner returns (bool success) {
419         feeMode = _newMode;
420         return true;
421     }
422 
423     function adjustFeeAmount(uint _newAmount) external onlyOwner returns (bool success) {
424         feeAmount = _newAmount;
425         return true;
426     }    
427 
428     function adjustFeePercentage(uint _newPercentage) external onlyOwner returns (bool success) {
429         require(_newPercentage <= FEE_CHARGER_DENOMINATOR);
430         feePercentage = _newPercentage;
431         return true;
432     }    
433 
434     function setWalletId(address _newWallet) external onlyOwner returns (bool success) {
435         require(_newWallet != 0x0);
436         olympusWallet = _newWallet;
437         return true;
438     }
439 
440     function setMotAddress(address _motAddress) external onlyOwner returns (bool success) {
441         require(_motAddress != 0x0);
442         require(_motAddress != address(MOT));
443         MOT = ERC20Extended(_motAddress);
444         // this is only and will always be MOT.
445         require(keccak256(abi.encodePacked(MOT.symbol())) == keccak256(abi.encodePacked("MOT")));
446 
447         return true;
448     }
449 
450 
451     /*
452      * @dev Pay the fee for the call / transaction.
453      * Depending on the component itself, the fee is paid differently.
454      * @param uint _amountinMot The base amount in MOT, calculation should be one outside. 
455      * this is only used when the fee mode is by transaction amount. leave it to zero if fee mode is
456      * by calls.
457      * @return boolean whether or not the fee is paid.
458      */
459     function payFee(uint _amountInMOT) internal feePayable(calculateFee(_amountInMOT)) returns (bool success) {
460         uint _feeAmount = calculateFee(_amountInMOT);
461 
462         DerivativeInterface derivative = DerivativeInterface(msg.sender);
463 
464         uint balanceBefore = MOT.balanceOf(olympusWallet);
465         require(!isPaying);
466         isPaying = true;
467         MOT.transferFrom(address(derivative), olympusWallet, _feeAmount);
468         isPaying = false;
469         uint balanceAfter = MOT.balanceOf(olympusWallet);
470 
471         require(balanceAfter == balanceBefore + _feeAmount);   
472         return true;     
473     }        
474 }
475 
476 contract ExchangeProvider is FeeCharger, OlympusExchangeInterface {
477     using SafeMath for uint256;
478     string public name = "OlympusExchangeProvider";
479     string public description =
480     "Exchange provider of Olympus Labs, which additionally supports buy\and sellTokens for multiple tokens at the same time";
481     string public category = "exchange";
482     string public version = "v1.0";
483     ERC20Extended private constant ETH  = ERC20Extended(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
484 
485     OlympusExchangeAdapterManagerInterface private exchangeAdapterManager;
486 
487     constructor(address _exchangeManager) public {
488         exchangeAdapterManager = OlympusExchangeAdapterManagerInterface(_exchangeManager);
489         feeMode = FeeMode.ByTransactionAmount;
490     }
491 
492     modifier checkAllowance(ERC20Extended _token, uint _amount) {
493         require(_token.allowance(msg.sender, address(this)) >= _amount, "Not enough tokens approved");
494         _;
495     }
496 
497     function setExchangeAdapterManager(address _exchangeManager) external onlyOwner {
498         exchangeAdapterManager = OlympusExchangeAdapterManagerInterface(_exchangeManager);
499     }
500 
501     function buyToken
502         (
503         ERC20Extended _token, uint _amount, uint _minimumRate,
504         address _depositAddress, bytes32 _exchangeId, address /* _partnerId */
505         ) external payable returns(bool success) {
506 
507         require(msg.value == _amount);
508 
509         OlympusExchangeAdapterInterface adapter;
510         // solhint-disable-next-line
511         bytes32 exchangeId = _exchangeId == "" ? exchangeAdapterManager.pickExchange(_token, _amount, _minimumRate, true) : _exchangeId;
512         if(exchangeId == 0){
513             revert("No suitable exchange found");
514         }
515 
516         require(payFee(msg.value * getMotPrice(exchangeId) / 10 ** 18));
517         adapter = OlympusExchangeAdapterInterface(exchangeAdapterManager.getExchangeAdapter(exchangeId));
518         require(
519             adapter.buyToken.value(msg.value)(
520                 _token,
521                 _amount,
522                 _minimumRate,
523                 _depositAddress)
524         );
525         return true;
526     }
527 
528     function sellToken
529         (
530         ERC20Extended _token, uint _amount, uint _minimumRate,
531         address _depositAddress, bytes32 _exchangeId, address /* _partnerId */
532         ) checkAllowance(_token, _amount) external returns(bool success) {
533 
534         OlympusExchangeAdapterInterface adapter;
535         bytes32 exchangeId = _exchangeId == "" ? exchangeAdapterManager.pickExchange(_token, _amount, _minimumRate, false) : _exchangeId;
536         if(exchangeId == 0){
537             revert("No suitable exchange found");
538         }
539 
540         uint tokenPrice;
541         (tokenPrice,) = exchangeAdapterManager.getPrice(_token, ETH, _amount, exchangeId);
542         require(payFee(tokenPrice  * _amount * getMotPrice(exchangeId) / 10 ** _token.decimals() / 10 ** 18));
543 
544         adapter = OlympusExchangeAdapterInterface(exchangeAdapterManager.getExchangeAdapter(exchangeId));
545 
546         ERC20NoReturn(_token).transferFrom(msg.sender, address(adapter), _amount);
547 
548         require(
549             adapter.sellToken(
550                 _token,
551                 _amount,
552                 _minimumRate,
553                 _depositAddress)
554             );
555         return true;
556     }
557 
558     function getMotPrice(bytes32 _exchangeId) private view returns (uint price) {
559         (price,) = exchangeAdapterManager.getPrice(ETH, MOT, msg.value, _exchangeId);
560     }
561 
562     function buyTokens
563         (
564         ERC20Extended[] _tokens, uint[] _amounts, uint[] _minimumRates,
565         address _depositAddress, bytes32 _exchangeId, address /* _partnerId */
566         ) external payable returns(bool success) {
567         require(_tokens.length == _amounts.length && _amounts.length == _minimumRates.length, "Arrays are not the same lengths");
568         require(payFee(msg.value * getMotPrice(_exchangeId) / 10 ** 18));
569         uint totalValue;
570         uint i;
571         for(i = 0; i < _amounts.length; i++ ) {
572             totalValue += _amounts[i];
573         }
574         require(totalValue == msg.value, "msg.value is not the same as total value");
575 
576         for (i = 0; i < _tokens.length; i++ ) {
577             bytes32 exchangeId = _exchangeId == "" ?
578             exchangeAdapterManager.pickExchange(_tokens[i], _amounts[i], _minimumRates[i], true) : _exchangeId;
579             if (exchangeId == 0) {
580                 revert("No suitable exchange found");
581             }
582             require(
583                 OlympusExchangeAdapterInterface(exchangeAdapterManager.getExchangeAdapter(exchangeId)).buyToken.value(_amounts[i])(
584                     _tokens[i],
585                     _amounts[i],
586                     _minimumRates[i],
587                     _depositAddress)
588             );
589         }
590         return true;
591     }
592 
593     function sellTokens
594         (
595         ERC20Extended[] _tokens, uint[] _amounts, uint[] _minimumRates,
596         address _depositAddress, bytes32 _exchangeId, address /* _partnerId */
597         ) external returns(bool success) {
598         require(_tokens.length == _amounts.length && _amounts.length == _minimumRates.length, "Arrays are not the same lengths");
599         OlympusExchangeAdapterInterface adapter;
600 
601         uint[] memory prices = new uint[](3); // 0 tokenPrice, 1 MOT price, 3 totalValueInMOT
602         for (uint i = 0; i < _tokens.length; i++ ) {
603             bytes32 exchangeId = _exchangeId == bytes32("") ?
604             exchangeAdapterManager.pickExchange(_tokens[i], _amounts[i], _minimumRates[i], false) : _exchangeId;
605             if(exchangeId == 0){
606                 revert("No suitable exchange found");
607             }
608 
609             (prices[0],) = exchangeAdapterManager.getPrice(_tokens[i], ETH, _amounts[i], exchangeId);
610             (prices[1],) = exchangeAdapterManager.getPrice(ETH, MOT, prices[0] * _amounts[i], exchangeId);
611             prices[2] += prices[0] * _amounts[i] * prices[1] / 10 ** _tokens[i].decimals() / 10 ** 18;
612 
613             adapter = OlympusExchangeAdapterInterface(exchangeAdapterManager.getExchangeAdapter(exchangeId));
614             require(_tokens[i].allowance(msg.sender, address(this)) >= _amounts[i], "Not enough tokens approved");
615             ERC20NoReturn(_tokens[i]).transferFrom(msg.sender, address(adapter), _amounts[i]);
616             require(
617                 adapter.sellToken(
618                     _tokens[i],
619                     _amounts[i],
620                     _minimumRates[i],
621                     _depositAddress)
622             );
623         }
624 
625         require(payFee(prices[2]));
626 
627         return true;
628     }
629 
630     function supportsTradingPair(address _srcAddress, address _destAddress, bytes32 _exchangeId) external view returns (bool){
631         return exchangeAdapterManager.supportsTradingPair(_srcAddress, _destAddress, _exchangeId);
632     }
633 
634     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount, bytes32 _exchangeId)
635         external view returns(uint expectedRate, uint slippageRate) {
636         return exchangeAdapterManager.getPrice(_sourceAddress, _destAddress, _amount, _exchangeId);
637     }
638 }