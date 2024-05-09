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
53 library Utils {
54 
55     uint  constant PRECISION = (10**18);
56     uint  constant MAX_DECIMALS = 18;
57 
58     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
59         if( dstDecimals >= srcDecimals ) {
60             require((dstDecimals-srcDecimals) <= MAX_DECIMALS);
61             return (srcQty * rate * (10**(dstDecimals-srcDecimals))) / PRECISION;
62         } else {
63             require((srcDecimals-dstDecimals) <= MAX_DECIMALS);
64             return (srcQty * rate) / (PRECISION * (10**(srcDecimals-dstDecimals)));
65         }
66     }
67 
68     // function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
69     //     if( srcDecimals >= dstDecimals ) {
70     //         require((srcDecimals-dstDecimals) <= MAX_DECIMALS);
71     //         return (PRECISION * dstQty * (10**(srcDecimals - dstDecimals))) / rate;
72     //     } else {
73     //         require((dstDecimals-srcDecimals) <= MAX_DECIMALS);
74     //         return (PRECISION * dstQty) / (rate * (10**(dstDecimals - srcDecimals)));
75     //     }
76     // }
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85   function totalSupply() public view returns (uint256);
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender)
97     public view returns (uint256);
98 
99   function transferFrom(address from, address to, uint256 value)
100     public returns (bool);
101 
102   function approve(address spender, uint256 value) public returns (bool);
103   event Approval(
104     address indexed owner,
105     address indexed spender,
106     uint256 value
107   );
108 }
109 
110 contract ERC20Extended is ERC20 {
111     uint256 public decimals;
112     string public name;
113     string public symbol;
114 
115 }
116 
117 contract ComponentInterface {
118     string public name;
119     string public description;
120     string public category;
121     string public version;
122 }
123 
124 contract ExchangeInterface is ComponentInterface {
125     /*
126      * @dev Checks if a trading pair is available
127      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
128      * @param address _sourceAddress The token to sell for the destAddress.
129      * @param address _destAddress The token to buy with the source token.
130      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
131      * @return boolean whether or not the trading pair is supported by this exchange provider
132      */
133     function supportsTradingPair(address _srcAddress, address _destAddress, bytes32 _exchangeId)
134         external view returns(bool supported);
135 
136     /*
137      * @dev Buy a single token with ETH.
138      * @param ERC20Extended _token The token to buy, should be an ERC20Extended address.
139      * @param uint _amount Amount of ETH used to buy this token. Make sure the value sent to this function is the same as the _amount.
140      * @param uint _minimumRate The minimum amount of tokens to receive for 1 ETH.
141      * @param address _depositAddress The address to send the bought tokens to.
142      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
143      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here.
144      * @return boolean whether or not the trade succeeded.
145      */
146     function buyToken
147         (
148         ERC20Extended _token, uint _amount, uint _minimumRate,
149         address _depositAddress, bytes32 _exchangeId, address _partnerId
150         ) external payable returns(bool success);
151 
152     /*
153      * @dev Sell a single token for ETH. Make sure the token is approved beforehand.
154      * @param ERC20Extended _token The token to sell, should be an ERC20Extended address.
155      * @param uint _amount Amount of tokens to sell.
156      * @param uint _minimumRate The minimum amount of ETH to receive for 1 ERC20Extended token.
157      * @param address _depositAddress The address to send the bought tokens to.
158      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
159      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here
160      * @return boolean boolean whether or not the trade succeeded.
161      */
162     function sellToken
163         (
164         ERC20Extended _token, uint _amount, uint _minimumRate,
165         address _depositAddress, bytes32 _exchangeId, address _partnerId
166         ) external returns(bool success);
167 }
168 
169 contract KyberNetworkInterface {
170 
171     function getExpectedRate(ERC20Extended src, ERC20Extended dest, uint srcQty)
172         external view returns (uint expectedRate, uint slippageRate);
173 
174     function trade(
175         ERC20Extended source,
176         uint srcAmount,
177         ERC20Extended dest,
178         address destAddress,
179         uint maxDestAmount,
180         uint minConversionRate,
181         address walletId)
182         external payable returns(uint);
183 }
184 
185 /**
186  * @title Ownable
187  * @dev The Ownable contract has an owner address, and provides basic authorization control
188  * functions, this simplifies the implementation of "user permissions".
189  */
190 contract Ownable {
191   address public owner;
192 
193 
194   event OwnershipRenounced(address indexed previousOwner);
195   event OwnershipTransferred(
196     address indexed previousOwner,
197     address indexed newOwner
198   );
199 
200 
201   /**
202    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
203    * account.
204    */
205   constructor() public {
206     owner = msg.sender;
207   }
208 
209   /**
210    * @dev Throws if called by any account other than the owner.
211    */
212   modifier onlyOwner() {
213     require(msg.sender == owner);
214     _;
215   }
216 
217   /**
218    * @dev Allows the current owner to relinquish control of the contract.
219    */
220   function renounceOwnership() public onlyOwner {
221     emit OwnershipRenounced(owner);
222     owner = address(0);
223   }
224 
225   /**
226    * @dev Allows the current owner to transfer control of the contract to a newOwner.
227    * @param _newOwner The address to transfer ownership to.
228    */
229   function transferOwnership(address _newOwner) public onlyOwner {
230     _transferOwnership(_newOwner);
231   }
232 
233   /**
234    * @dev Transfers control of the contract to a newOwner.
235    * @param _newOwner The address to transfer ownership to.
236    */
237   function _transferOwnership(address _newOwner) internal {
238     require(_newOwner != address(0));
239     emit OwnershipTransferred(owner, _newOwner);
240     owner = _newOwner;
241   }
242 }
243 
244 contract OlympusExchangeAdapterInterface is Ownable {
245 
246     function supportsTradingPair(address _srcAddress, address _destAddress)
247         external view returns(bool supported);
248 
249     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount)
250         external view returns(uint expectedRate, uint slippageRate);
251 
252     function sellToken
253         (
254         ERC20Extended _token, uint _amount, uint _minimumRate,
255         address _depositAddress
256         ) external returns(bool success);
257 
258     function buyToken
259         (
260         ERC20Extended _token, uint _amount, uint _minimumRate,
261         address _depositAddress
262         ) external payable returns(bool success);
263 
264     function enable() external returns(bool);
265     function disable() external returns(bool);
266     function isEnabled() external view returns (bool success);
267 
268     function setExchangeDetails(bytes32 _id, bytes32 _name) external returns(bool success);
269     function getExchangeDetails() external view returns(bytes32 _name, bool _enabled);
270 
271 }
272 
273 contract BancorConverterInterface {
274     string public converterType;
275     ERC20Extended[] public quickBuyPath;
276     /**
277         @dev returns the length of the quick buy path array
278         @return quick buy path length
279     */
280     function getQuickBuyPathLength() public view returns (uint256);
281     /**
282         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
283 
284         @param _fromToken  ERC20 token to convert from
285         @param _toToken    ERC20 token to convert to
286         @param _amount     amount to convert, in fromToken
287 
288         @return expected conversion return amount
289     */
290     function getReturn(ERC20Extended _fromToken, ERC20Extended _toToken, uint256 _amount) public view returns (uint256);
291     /**
292         @dev converts the token to any other token in the bancor network by following a predefined conversion path
293         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
294 
295         @param _path        conversion path, see conversion path format in the BancorNetwork contract
296         @param _amount      amount to convert from (in the initial source token)
297         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
298 
299         @return tokens issued in return
300     */
301     function quickConvert(ERC20Extended[] _path, uint256 _amount, uint256 _minReturn)
302         public
303         payable
304         returns (uint256);
305 
306 }
307 
308 contract ERC20NoReturn {
309     uint256 public decimals;
310     string public name;
311     string public symbol;
312     function totalSupply() public view returns (uint);
313     function balanceOf(address tokenOwner) public view returns (uint balance);
314     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
315     function transfer(address to, uint tokens) public;
316     function approve(address spender, uint tokens) public;
317     function transferFrom(address from, address to, uint tokens) public;
318 
319     event Transfer(address indexed from, address indexed to, uint tokens);
320     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
321 }
322 
323 contract BancorNetworkAdapter is OlympusExchangeAdapterInterface {
324     using SafeMath for uint256;
325 
326     address public exchangeAdapterManager;
327     bytes32 public exchangeId;
328     bytes32 public name;
329     ERC20Extended public constant ETH_TOKEN_ADDRESS = ERC20Extended(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
330     ERC20Extended public constant bancorToken = ERC20Extended(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);
331     ERC20Extended public constant bancorETHToken = ERC20Extended(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);
332     mapping(address => BancorConverterInterface) public tokenToConverter;
333     mapping(address => address) public tokenToRelay;
334 
335     bool public adapterEnabled;
336 
337     modifier checkArrayLengths(address[] tokenAddresses, BancorConverterInterface[] converterAddresses, address[] relayAddresses) {
338         require(tokenAddresses.length == converterAddresses.length && relayAddresses.length == converterAddresses.length);
339         _;
340     }
341 
342     modifier checkTokenSupported(address _token) {
343         BancorConverterInterface bancorConverter = tokenToConverter[_token];
344         require(address(bancorConverter) != 0x0, "Token not supported");
345         _;
346     }
347 
348     constructor (address _exchangeAdapterManager, address[] _tokenAddresses,
349     BancorConverterInterface[] _converterAddresses, address[] _relayAddresses)
350     checkArrayLengths(_tokenAddresses, _converterAddresses, _relayAddresses) public {
351         updateSupportedTokenList(_tokenAddresses, _converterAddresses, _relayAddresses);
352         exchangeAdapterManager = _exchangeAdapterManager;
353         adapterEnabled = true;
354     }
355 
356     modifier onlyExchangeAdapterManager() {
357         require(msg.sender == address(exchangeAdapterManager));
358         _;
359     }
360 
361     function updateSupportedTokenList(address[] _tokenAddresses, BancorConverterInterface[] _converterAddresses, address[] _relayAddresses)
362     checkArrayLengths(_tokenAddresses, _converterAddresses, _relayAddresses)
363     public onlyOwner returns (bool success) {
364         for(uint i = 0; i < _tokenAddresses.length; i++){
365             tokenToConverter[_tokenAddresses[i]] = _converterAddresses[i];
366             tokenToRelay[_tokenAddresses[i]] = _relayAddresses[i];
367         }
368         return true;
369     }
370 
371     function supportsTradingPair(address _srcAddress, address _destAddress) external view returns(bool supported){
372         address _tokenAddress = ETH_TOKEN_ADDRESS == _srcAddress ? _destAddress : _srcAddress;
373         BancorConverterInterface bancorConverter = tokenToConverter[_tokenAddress];
374         return address(bancorConverter) != 0x0;
375     }
376 
377     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount)
378     external view returns(uint expectedRate, uint slippageRate) {
379         require(_amount > 0);
380         bool isBuying = _sourceAddress == ETH_TOKEN_ADDRESS;
381         ERC20Extended targetToken = isBuying ? _destAddress : _sourceAddress;
382         BancorConverterInterface BNTConverter = tokenToConverter[address(bancorToken)];
383 
384         uint rate;
385         BancorConverterInterface targetTokenConverter = tokenToConverter[address(targetToken)];
386 
387         uint ETHToBNTRate = BNTConverter.getReturn(bancorETHToken, bancorToken, _amount);
388 
389 
390         // Bancor is a special case, it's their token
391         if (targetToken == bancorToken){
392             if(isBuying) {
393                 rate = ((ETHToBNTRate * 10**18) / _amount);
394             } else {
395                 rate = BNTConverter.getReturn(bancorToken, bancorETHToken, _amount);
396                 rate = ((rate * 10**_sourceAddress.decimals()) / _amount);
397             }
398         } else {
399             if(isBuying){
400                 // Get amount of tokens for the amount of BNT for amount ETH
401                 rate = targetTokenConverter.getReturn(bancorToken, targetToken, ETHToBNTRate);
402                 // Convert rate to 1ETH to token or token to 1 ETH
403                 rate = ((rate * 10**18) / _amount);
404             } else {
405                 uint targetTokenToBNTRate = targetTokenConverter.getReturn(targetToken, bancorToken, 10**targetToken.decimals());
406                 rate = BNTConverter.getReturn(bancorToken, bancorETHToken, targetTokenToBNTRate);
407                 // Convert rate to 1ETH to token or token to 1 ETH
408                 rate = ((rate * 10**_sourceAddress.decimals()) / _amount);
409             }
410         }
411 
412         // TODO slippage?
413         return (rate,0);
414     }
415 
416     // https://support.bancor.network/hc/en-us/articles/360000878832-How-to-use-the-quickConvert-function
417     function getPath(ERC20Extended _token, bool isBuying) public view returns(ERC20Extended[] tokenPath, uint resultPathLength) {
418         BancorConverterInterface bancorConverter = tokenToConverter[_token];
419         uint pathLength;
420         ERC20Extended[] memory path;
421 
422         // When buying, we can get the path from Bancor easily, by getting the quickBuyPath from the converter address
423         if(isBuying){
424             pathLength = bancorConverter.getQuickBuyPathLength();
425             require(pathLength > 0, "Error with pathLength");
426             path = new ERC20Extended[](pathLength);
427 
428             for (uint i = 0; i < pathLength; i++) {
429                 path[i] = bancorConverter.quickBuyPath(i);
430             }
431             return (path, pathLength);
432         }
433 
434         // When selling, we need to make the path ourselves
435 
436         address relayAddress = tokenToRelay[_token];
437 
438         if(relayAddress == 0x0){
439             // Bancor is a special case, it's their token
440             if(_token == bancorToken){
441                 path = new ERC20Extended[](3);
442                 path[0] = _token;
443                 path[1] = _token;
444                 path[2] = bancorETHToken;
445                 return (path, 3);
446             }
447             // It's a Bancor smart token, handle it accordingly
448             path = new ERC20Extended[](5);
449             path[0] = _token;
450             path[1] = _token;
451             path[2] = bancorToken;
452             path[3] = bancorToken;
453             path[4] = bancorETHToken;
454             return (path, 5);
455         }
456 
457         // It's a relay token, handle it accordingly
458         path = new ERC20Extended[](5);
459         path[0] = _token;                              // ERC20 Token to sell
460         path[1] = ERC20Extended(relayAddress);         // Relay address (automatically converted to converter address)
461         path[2] = bancorToken;                         // BNT Smart token address, as converter
462         path[3] = bancorToken;                         // BNT Smart token address, as "to" and "from" token
463         path[4] = bancorETHToken;                      // The Bancor ETH token, this will signal we want our return in ETH
464 
465         return (path, 5);
466     }
467 
468     // In contrast to Kyber, Bancor uses a minimum return for the complete trade, instead of a minimum rate for 1 ETH (for buying) or token (when selling)
469     function convertMinimumRateToMinimumReturn(ERC20Extended _token, uint _minimumRate, uint _amount, bool isBuying)
470     private view returns(uint minimumReturn) {
471         if(_minimumRate == 0){
472             return 1;
473         }
474 
475         if(isBuying){
476             return (_amount * 10**18) / _minimumRate;
477         }
478 
479         return (_amount * 10**_token.decimals()) / _minimumRate;
480     }
481 
482     function sellToken
483     (
484         ERC20Extended _token, uint _amount, uint _minimumRate,
485         address _depositAddress
486     ) checkTokenSupported(_token) external returns(bool success) {
487         require(_token.balanceOf(address(this)) >= _amount, "Balance of token is not sufficient in adapter");
488         ERC20Extended[] memory internalPath;
489         ERC20Extended[] memory path;
490         uint pathLength;
491         (internalPath,pathLength) = getPath(_token, false);
492 
493         path = new ERC20Extended[](pathLength);
494         for(uint i = 0; i < pathLength; i++) {
495             path[i] = internalPath[i];
496         }
497 
498         BancorConverterInterface bancorConverter = tokenToConverter[_token];
499 
500         ERC20NoReturn(_token).approve(address(bancorConverter), 0);
501         ERC20NoReturn(_token).approve(address(bancorConverter), _amount);
502         uint minimumReturn = convertMinimumRateToMinimumReturn(_token,_amount,_minimumRate, false);
503         uint returnedAmountOfETH = bancorConverter.quickConvert(path,_amount,minimumReturn);
504         require(returnedAmountOfETH > 0, "BancorConverter did not return any ETH");
505         _depositAddress.transfer(returnedAmountOfETH);
506         return true;
507     }
508 
509     function buyToken (
510         ERC20Extended _token, uint _amount, uint _minimumRate,
511         address _depositAddress
512     ) checkTokenSupported(_token) external payable returns(bool success){
513         require(msg.value == _amount, "Amount of Ether sent is not the same as the amount parameter");
514         ERC20Extended[] memory internalPath;
515         ERC20Extended[] memory path;
516         uint pathLength;
517         (internalPath,pathLength) = getPath(_token, true);
518         path = new ERC20Extended[](pathLength);
519         for(uint i = 0; i < pathLength; i++) {
520             path[i] = internalPath[i];
521         }
522 
523         uint minimumReturn = convertMinimumRateToMinimumReturn(_token,_amount,_minimumRate, true);
524         uint returnedAmountOfTokens = tokenToConverter[address(bancorToken)].quickConvert.value(_amount)(path,_amount,minimumReturn);
525         require(returnedAmountOfTokens > 0, "BancorConverter did not return any tokens");
526         ERC20NoReturn(_token).transfer(_depositAddress, returnedAmountOfTokens);
527         return true;
528     }
529 
530     function enable() external onlyOwner returns(bool){
531         adapterEnabled = true;
532         return true;
533     }
534 
535     function disable() external onlyOwner returns(bool){
536         adapterEnabled = false;
537         return true;
538     }
539 
540     function isEnabled() external view returns (bool success) {
541         return adapterEnabled;
542     }
543 
544     function setExchangeAdapterManager(address _exchangeAdapterManager) external onlyOwner {
545         exchangeAdapterManager = _exchangeAdapterManager;
546     }
547 
548     function setExchangeDetails(bytes32 _id, bytes32 _name)
549     external onlyExchangeAdapterManager returns(bool)
550     {
551         exchangeId = _id;
552         name = _name;
553         return true;
554     }
555 
556     function getExchangeDetails()
557     external view returns(bytes32 _name, bool _enabled)
558     {
559         return (name, adapterEnabled);
560     }
561 }