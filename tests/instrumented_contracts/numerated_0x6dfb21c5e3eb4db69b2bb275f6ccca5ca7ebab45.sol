1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (a == 0) {
83       return 0;
84     }
85 
86     c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     // assert(b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98     return a / b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105     assert(b <= a);
106     return a - b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
113     c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 // File: contracts/interfaces/IRegistry.sol
120 
121 // limited ContractRegistry definition
122 interface IRegistry {
123   function owner()
124     external
125     returns(address);
126 
127   function updateContractAddress(
128     string _name,
129     address _address
130   )
131     external
132     returns (address);
133 
134   function getContractAddress(
135     string _name
136   )
137     external
138     view
139     returns (address);
140 }
141 
142 // File: contracts/interfaces/IExchangeRateProvider.sol
143 
144 interface IExchangeRateProvider {
145   function sendQuery(
146     string _queryString,
147     uint256 _callInterval,
148     uint256 _callbackGasLimit,
149     string _queryType
150   )
151     external
152     payable
153     returns (bool);
154 
155   function setCallbackGasPrice(uint256 _gasPrice)
156     external
157     returns (bool);
158 
159   function selfDestruct(address _address)
160     external;
161 }
162 
163 // File: contracts/ExchangeRates.sol
164 
165 /*
166 Q/A
167 Q: Why are there two contracts for ExchangeRates?
168 A: Testing Oraclize seems to be a bit difficult especially considering the
169 bridge requires node v6... With that in mind, it was decided that the best way
170 to move forward was to isolate the oraclize functionality and replace with
171 a stub in order to facilitate effective tests.
172 
173 Q: Why are rates private?
174 A: So that they can be returned through custom getters getRate and
175 getRateReadable. This is so that we can revert when a rate has not been
176 initialized or an error happened when fetching. Oraclize returns '' when
177 erroring which we parse as a uint256 which turns to 0.
178 */
179 
180 // main contract
181 contract ExchangeRates is Ownable {
182   using SafeMath for uint256;
183 
184   uint8 public constant version = 1;
185   uint256 public constant permilleDenominator = 1000;
186   // instance of Registry to be used for getting other contract addresses
187   IRegistry private registry;
188   // flag used to tell recursive rate fetching to stop
189   bool public ratesActive = true;
190 
191   struct Settings {
192     string queryString;
193     uint256 callInterval;
194     uint256 callbackGasLimit;
195     // Rate penalty that is applied on fetched fiat rates. The penalty
196     // is specified at permille-accuracy. Example: 18 => 18/1000 = 1.8% penalty.
197     uint256 ratePenalty;
198   }
199 
200   // the actual exchange rate for each currency
201   // private so that when rate is 0 (error or unset) we can revert through
202   // getter functions getRate and getRateReadable
203   mapping (bytes32 => uint256) private rates;
204   // points to currencySettings from callback
205   // is used to validate queryIds from ExchangeRateProvider
206   mapping (bytes32 => string) public queryTypes;
207   // storage for query settings... modifiable for each currency
208   // accessed and used by ExchangeRateProvider
209   mapping (string => Settings) private currencySettings;
210 
211   event RateUpdated(string currency, uint256 rate);
212   event NotEnoughBalance();
213   event QuerySent(string currency);
214   event SettingsUpdated(string currency);
215 
216   // used to only allow specific contract to call specific functions
217   modifier onlyContract(string _contractName)
218   {
219     require(
220       msg.sender == registry.getContractAddress(_contractName)
221     );
222     _;
223   }
224 
225   // sets registry for talking to ExchangeRateProvider
226   constructor(
227     address _registryAddress
228   )
229     public
230     payable
231   {
232     require(_registryAddress != address(0));
233     registry = IRegistry(_registryAddress);
234     owner = msg.sender;
235   }
236 
237   // start rate fetching for a specific currency. Kicks off the first of
238   // possibly many recursive query calls on ExchangeRateProvider to get rates.
239   function fetchRate(string _queryType)
240     external
241     onlyOwner
242     payable
243     returns (bool)
244   {
245     // get the ExchangeRateProvider from registry
246     IExchangeRateProvider provider = IExchangeRateProvider(
247       registry.getContractAddress("ExchangeRateProvider")
248     );
249 
250     // get settings to use in query on ExchangeRateProvider
251     uint256 _callInterval;
252     uint256 _callbackGasLimit;
253     string memory _queryString;
254     uint256 _ratePenalty;
255     (
256       _callInterval,
257       _callbackGasLimit,
258       _queryString,
259       _ratePenalty // not used in this function
260     ) = getCurrencySettings(_queryType);
261 
262     // check that queryString isn't empty before making the query
263     require(bytes(_queryString).length > 0);
264 
265     // make query on ExchangeRateProvider
266     // forward any ether value sent on to ExchangeRateProvider
267     // setQuery is called from ExchangeRateProvider to trigger an event
268     // whether there is enough balance or not
269     provider.sendQuery.value(msg.value)(
270       _queryString,
271       _callInterval,
272       _callbackGasLimit,
273       _queryType
274     );
275     return true;
276   }
277 
278   //
279   // start exchange rate provider only functions
280   //
281 
282   // set a pending queryId callable only by ExchangeRateProvider
283   // set from sendQuery on ExchangeRateProvider
284   // used to check that correct query is being matched to correct values
285   function setQueryId(
286     bytes32 _queryId,
287     string _queryType
288   )
289     external
290     onlyContract("ExchangeRateProvider")
291     returns (bool)
292   {
293     if (_queryId[0] != 0x0 && bytes(_queryType)[0] != 0x0) {
294       emit QuerySent(_queryType);
295       queryTypes[_queryId] = _queryType;
296     } else {
297       emit NotEnoughBalance();
298     }
299     return true;
300   }
301 
302   // called only by ExchangeRateProvider
303   // sets the rate for a given currency when query __callback occurs.
304   // checks that the queryId returned is correct.
305   function setRate(
306     bytes32 _queryId,
307     uint256 _rateInCents
308   )
309     external
310     onlyContract("ExchangeRateProvider")
311     returns (bool)
312   {
313     // get the query type (usd, eur, etc)
314     string memory _currencyName = queryTypes[_queryId];
315     // check that first byte of _queryType is not 0 (something wrong or empty)
316     // if the queryType is 0 then the queryId is incorrect
317     require(bytes(_currencyName).length > 0);
318     // get and apply penalty on fiat rate to compensate for fees
319     uint256 _penaltyInPermille = currencySettings[toUpperCase(_currencyName)].ratePenalty;
320     uint256 _penalizedRate = _rateInCents
321       .mul(permilleDenominator.sub(_penaltyInPermille))
322       .div(permilleDenominator);
323     // set _queryId to empty (uninitialized, to prevent from being called again)
324     delete queryTypes[_queryId];
325     // set currency rate depending on _queryType (USD, EUR, etc.)
326     rates[keccak256(abi.encodePacked(_currencyName))] = _penalizedRate;
327     // event for particular rate that was updated
328     emit RateUpdated(
329       _currencyName,
330       _penalizedRate
331     );
332 
333     return true;
334   }
335 
336   //
337   // end exchange rate provider only settings
338   //
339 
340   /*
341   set setting for a given currency:
342   currencyName: used as identifier to store settings (stored as bytes8)
343   queryString: the http endpoint to hit to get data along with format
344     example: "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD"
345   callInterval: used to specifiy how often (if at all) the rate should refresh
346   callbackGasLimit: used to specify how much gas to give the oraclize callback
347   */
348   function setCurrencySettings(
349     string _currencyName,
350     string _queryString,
351     uint256 _callInterval,
352     uint256 _callbackGasLimit,
353     uint256 _ratePenalty
354   )
355     external
356     onlyOwner
357     returns (bool)
358   {
359     // check that the permille value doesn't exceed 999.
360     require(_ratePenalty < 1000);
361     // store settings by bytes8 of string, convert queryString to bytes array
362     currencySettings[toUpperCase(_currencyName)] = Settings(
363       _queryString,
364       _callInterval,
365       _callbackGasLimit,
366       _ratePenalty
367     );
368     emit SettingsUpdated(_currencyName);
369     return true;
370   }
371 
372   // set only query string in settings for a given currency
373   function setCurrencySettingQueryString(
374     string _currencyName,
375     string _queryString
376   )
377     external
378     onlyOwner
379     returns (bool)
380   {
381     Settings storage _settings = currencySettings[toUpperCase(_currencyName)];
382     _settings.queryString = _queryString;
383     emit SettingsUpdated(_currencyName);
384     return true;
385   }
386 
387   // set only callInterval in settings for a given currency
388   function setCurrencySettingCallInterval(
389     string _currencyName,
390     uint256 _callInterval
391   )
392     external
393     onlyOwner
394     returns (bool)
395   {
396     Settings storage _settings = currencySettings[toUpperCase(_currencyName)];
397     _settings.callInterval = _callInterval;
398     emit SettingsUpdated(_currencyName);
399     return true;
400   }
401 
402   // set only callbackGasLimit in settings for a given currency
403   function setCurrencySettingCallbackGasLimit(
404     string _currencyName,
405     uint256 _callbackGasLimit
406   )
407     external
408     onlyOwner
409     returns (bool)
410   {
411     Settings storage _settings = currencySettings[toUpperCase(_currencyName)];
412     _settings.callbackGasLimit = _callbackGasLimit;
413     emit SettingsUpdated(_currencyName);
414     return true;
415   }
416 
417   // set only ratePenalty in settings for a given currency
418   function setCurrencySettingRatePenalty(
419     string _currencyName,
420     uint256 _ratePenalty
421   )
422     external
423     onlyOwner
424     returns (bool)
425   {
426     // check that the permille value doesn't exceed 999.
427     require(_ratePenalty < 1000);
428 
429     Settings storage _settings = currencySettings[toUpperCase(_currencyName)];
430     _settings.ratePenalty = _ratePenalty;
431     emit SettingsUpdated(_currencyName);
432     return true;
433   }
434 
435   // set callback gasPrice for all currencies
436   function setCallbackGasPrice(uint256 _gasPrice)
437     external
438     onlyOwner
439     returns (bool)
440   {
441     // get the ExchangeRateProvider from registry
442     IExchangeRateProvider provider = IExchangeRateProvider(
443       registry.getContractAddress("ExchangeRateProvider")
444     );
445     provider.setCallbackGasPrice(_gasPrice);
446     emit SettingsUpdated("ALL");
447     return true;
448   }
449 
450   // set to active or inactive in order to stop recursive rate fetching
451   // rate needs to be fetched once in order for it to stop.
452   function toggleRatesActive()
453     external
454     onlyOwner
455     returns (bool)
456   {
457     ratesActive = !ratesActive;
458     emit SettingsUpdated("ALL");
459     return true;
460   }
461 
462   //
463   // end setter functions
464   //
465 
466   //
467   // start getter functions
468   //
469 
470   // retrieve settings for a given currency (queryType)
471   function getCurrencySettings(string _queryTypeString)
472     public
473     view
474     returns (uint256, uint256, string, uint256)
475   {
476     Settings memory _settings = currencySettings[_queryTypeString];
477     return (
478       _settings.callInterval,
479       _settings.callbackGasLimit,
480       _settings.queryString,
481       _settings.ratePenalty
482     );
483   }
484 
485   // get rate with string for easy use by regular accounts
486   function getRate(string _queryTypeString)
487     external
488     view
489     returns (uint256)
490   {
491     uint256 _rate = rates[keccak256(abi.encodePacked(toUpperCase(_queryTypeString)))];
492     require(_rate > 0);
493     return _rate;
494   }
495 
496   // get rate with bytes32 for easier assembly calls
497   // uppercase protection not provided...
498   function getRate32(bytes32 _queryType32)
499     external
500     view
501     returns (uint256)
502   {
503     uint256 _rate = rates[_queryType32];
504     require(_rate > 0);
505     return _rate;
506   }
507 
508   //
509   // end getter functions
510   //
511 
512   //
513   // start utility functions
514   //
515 
516   // convert string to uppercase to ensure that there are not multiple
517   // instances of same currencies
518   function toUpperCase(string _base)
519     public
520     pure
521     returns (string)
522   {
523     bytes memory _stringBytes = bytes(_base);
524     for (
525       uint _byteCounter = 0;
526       _byteCounter < _stringBytes.length;
527       _byteCounter++
528     ) {
529       if (
530         _stringBytes[_byteCounter] >= 0x61 &&
531         _stringBytes[_byteCounter] <= 0x7A
532       ) {
533         _stringBytes[_byteCounter] = bytes1(
534           uint8(_stringBytes[_byteCounter]) - 32
535         );
536       }
537     }
538     return string(_stringBytes);
539   }
540 
541   //
542   // end utility functions
543   //
544 
545   // used for selfdestructing the provider in order to get back any unused ether
546   // useful for upgrades where we want to get money back from contract
547   function killProvider(address _address)
548     public
549     onlyOwner
550   {
551     // get the ExchangeRateProvider from registry
552     IExchangeRateProvider provider = IExchangeRateProvider(
553       registry.getContractAddress("ExchangeRateProvider")
554     );
555     provider.selfDestruct(_address);
556   }
557 }