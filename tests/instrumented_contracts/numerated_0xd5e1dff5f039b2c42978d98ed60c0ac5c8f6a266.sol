1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Module
5  * @dev Interface for a module. 
6  * A module MUST implement the addModule() method to ensure that a wallet with at least one module
7  * can never end up in a "frozen" state.
8  * @author Julien Niset - <julien@argent.xyz>
9  */
10 interface Module {
11 
12     /**
13      * @dev Inits a module for a wallet by e.g. setting some wallet specific parameters in storage.
14      * @param _wallet The wallet.
15      */
16     function init(BaseWallet _wallet) external;
17 
18     /**
19      * @dev Adds a module to a wallet.
20      * @param _wallet The target wallet.
21      * @param _module The modules to authorise.
22      */
23     function addModule(BaseWallet _wallet, Module _module) external;
24 
25     /**
26     * @dev Utility method to recover any ERC20 token that was sent to the
27     * module by mistake. 
28     * @param _token The token to recover.
29     */
30     function recoverToken(address _token) external;
31 }
32 
33 /**
34  * @title BaseModule
35  * @dev Basic module that contains some methods common to all modules.
36  * @author Julien Niset - <julien@argent.xyz>
37  */
38 contract BaseModule is Module {
39 
40     // The adddress of the module registry.
41     ModuleRegistry internal registry;
42 
43     event ModuleCreated(bytes32 name);
44     event ModuleInitialised(address wallet);
45 
46     constructor(ModuleRegistry _registry, bytes32 _name) public {
47         registry = _registry;
48         emit ModuleCreated(_name);
49     }
50 
51     /**
52      * @dev Throws if the sender is not the target wallet of the call.
53      */
54     modifier onlyWallet(BaseWallet _wallet) {
55         require(msg.sender == address(_wallet), "BM: caller must be wallet");
56         _;
57     }
58 
59     /**
60      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
61      */
62     modifier onlyOwner(BaseWallet _wallet) {
63         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
64         _;
65     }
66 
67     /**
68      * @dev Throws if the sender is not the owner of the target wallet.
69      */
70     modifier strictOnlyOwner(BaseWallet _wallet) {
71         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
72         _;
73     }
74 
75     /**
76      * @dev Inits the module for a wallet by logging an event.
77      * The method can only be called by the wallet itself.
78      * @param _wallet The wallet.
79      */
80     function init(BaseWallet _wallet) external onlyWallet(_wallet) {
81         emit ModuleInitialised(_wallet);
82     }
83 
84     /**
85      * @dev Adds a module to a wallet. First checks that the module is registered.
86      * @param _wallet The target wallet.
87      * @param _module The modules to authorise.
88      */
89     function addModule(BaseWallet _wallet, Module _module) external strictOnlyOwner(_wallet) {
90         require(registry.isRegisteredModule(_module), "BM: module is not registered");
91         _wallet.authoriseModule(_module, true);
92     }
93 
94     /**
95     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
96     * module by mistake and transfer them to the Module Registry. 
97     * @param _token The token to recover.
98     */
99     function recoverToken(address _token) external {
100         uint total = ERC20(_token).balanceOf(address(this));
101         ERC20(_token).transfer(address(registry), total);
102     }
103 
104     /**
105      * @dev Helper method to check if an address is the owner of a target wallet.
106      * @param _wallet The target wallet.
107      * @param _addr The address.
108      */
109     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
110         return _wallet.owner() == _addr;
111     }
112 }
113 
114 /**
115  * @title RelayerModule
116  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer. 
117  * @author Julien Niset - <julien@argent.xyz>
118  */
119 contract RelayerModule is Module {
120 
121     uint256 constant internal BLOCKBOUND = 10000;
122 
123     mapping (address => RelayerConfig) public relayer; 
124 
125     struct RelayerConfig {
126         uint256 nonce;
127         mapping (bytes32 => bool) executedTx;
128     }
129 
130     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
131 
132     /**
133      * @dev Throws if the call did not go through the execute() method.
134      */
135     modifier onlyExecute {
136         require(msg.sender == address(this), "RM: must be called via execute()");
137         _;
138     }
139 
140     /* ***************** Abstract method ************************* */
141 
142     /**
143     * @dev Gets the number of valid signatures that must be provided to execute a
144     * specific relayed transaction.
145     * @param _wallet The target wallet.
146     * @param _data The data of the relayed transaction.
147     * @return The number of required signatures.
148     */
149     function getRequiredSignatures(BaseWallet _wallet, bytes _data) internal view returns (uint256);
150 
151     /**
152     * @dev Validates the signatures provided with a relayed transaction.
153     * The method MUST throw if one or more signatures are not valid.
154     * @param _wallet The target wallet.
155     * @param _data The data of the relayed transaction.
156     * @param _signHash The signed hash representing the relayed transaction.
157     * @param _signatures The signatures as a concatenated byte array.
158     */
159     function validateSignatures(BaseWallet _wallet, bytes _data, bytes32 _signHash, bytes _signatures) internal view returns (bool);
160 
161     /* ************************************************************ */
162 
163     /**
164     * @dev Executes a relayed transaction.
165     * @param _wallet The target wallet.
166     * @param _data The data for the relayed transaction
167     * @param _nonce The nonce used to prevent replay attacks.
168     * @param _signatures The signatures as a concatenated byte array.
169     * @param _gasPrice The gas price to use for the gas refund.
170     * @param _gasLimit The gas limit to use for the gas refund.
171     */
172     function execute(
173         BaseWallet _wallet,
174         bytes _data, 
175         uint256 _nonce, 
176         bytes _signatures, 
177         uint256 _gasPrice,
178         uint256 _gasLimit
179     )
180         external
181         returns (bool success)
182     {
183         uint startGas = gasleft();
184         bytes32 signHash = getSignHash(address(this), _wallet, 0, _data, _nonce, _gasPrice, _gasLimit);
185         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
186         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
187         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
188         if((requiredSignatures * 65) == _signatures.length) {
189             if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
190                 if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
191                     // solium-disable-next-line security/no-call-value
192                     success = address(this).call(_data);
193                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
194                 }
195             }
196         }
197         emit TransactionExecuted(_wallet, success, signHash); 
198     }
199 
200     /**
201     * @dev Gets the current nonce for a wallet.
202     * @param _wallet The target wallet.
203     */
204     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
205         return relayer[_wallet].nonce;
206     }
207 
208     /**
209     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
210     * @param _from The starting address for the relayed transaction (should be the module)
211     * @param _to The destination address for the relayed transaction (should be the wallet)
212     * @param _value The value for the relayed transaction
213     * @param _data The data for the relayed transaction
214     * @param _nonce The nonce used to prevent replay attacks.
215     * @param _gasPrice The gas price to use for the gas refund.
216     * @param _gasLimit The gas limit to use for the gas refund.
217     */
218     function getSignHash(
219         address _from,
220         address _to, 
221         uint256 _value, 
222         bytes _data, 
223         uint256 _nonce,
224         uint256 _gasPrice,
225         uint256 _gasLimit
226     ) 
227         internal 
228         pure
229         returns (bytes32) 
230     {
231         return keccak256(
232             abi.encodePacked(
233                 "\x19Ethereum Signed Message:\n32",
234                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
235         ));
236     }
237 
238     /**
239     * @dev Checks if the relayed transaction is unique.
240     * @param _wallet The target wallet.
241     * @param _nonce The nonce
242     * @param _signHash The signed hash of the transaction
243     */
244     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
245         if(relayer[_wallet].executedTx[_signHash] == true) {
246             return false;
247         }
248         relayer[_wallet].executedTx[_signHash] = true;
249         return true;
250     }
251 
252     /**
253     * @dev Checks that a nonce has the correct format and is valid. 
254     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
255     * @param _wallet The target wallet.
256     * @param _nonce The nonce
257     */
258     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
259         if(_nonce <= relayer[_wallet].nonce) {
260             return false;
261         }   
262         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
263         if(nonceBlock > block.number + BLOCKBOUND) {
264             return false;
265         }
266         relayer[_wallet].nonce = _nonce;
267         return true;    
268     }
269 
270     /**
271     * @dev Recovers the signer at a given position from a list of concatenated signatures.
272     * @param _signedHash The signed hash
273     * @param _signatures The concatenated signatures.
274     * @param _index The index of the signature to recover.
275     */
276     function recoverSigner(bytes32 _signedHash, bytes _signatures, uint _index) internal pure returns (address) {
277         uint8 v;
278         bytes32 r;
279         bytes32 s;
280         // we jump 32 (0x20) as the first slot of bytes contains the length
281         // we jump 65 (0x41) per signature
282         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
283         // solium-disable-next-line security/no-inline-assembly
284         assembly {
285             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
286             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
287             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
288         }
289         require(v == 27 || v == 28); 
290         return ecrecover(_signedHash, v, r, s);
291     }
292 
293     /**
294     * @dev Refunds the gas used to the Relayer. 
295     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
296     * @param _wallet The target wallet.
297     * @param _gasUsed The gas used.
298     * @param _gasPrice The gas price for the refund.
299     * @param _gasLimit The gas limit for the refund.
300     * @param _signatures The number of signatures used in the call.
301     * @param _relayer The address of the Relayer.
302     */
303     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
304         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
305         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
306         if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
307             if(_gasPrice > tx.gasprice) {
308                 amount = amount * tx.gasprice;
309             }
310             else {
311                 amount = amount * _gasPrice;
312             }
313             _wallet.invoke(_relayer, amount, "");
314         }
315     }
316 
317     /**
318     * @dev Returns false if the refund is expected to fail.
319     * @param _wallet The target wallet.
320     * @param _gasUsed The expected gas used.
321     * @param _gasPrice The expected gas price for the refund.
322     */
323     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
324         if(_gasPrice > 0 
325             && _signatures > 1 
326             && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(this) == false)) {
327             return false;
328         }
329         return true;
330     }
331 
332     /**
333     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
334     * as the wallet passed as the input of the execute() method. 
335     @return false if the addresses are different.
336     */
337     function verifyData(address _wallet, bytes _data) private pure returns (bool) {
338         require(_data.length >= 36, "RM: Invalid dataWallet");
339         address dataWallet;
340         // solium-disable-next-line security/no-inline-assembly
341         assembly {
342             //_data = {length:32}{sig:4}{_wallet:32}{...}
343             dataWallet := mload(add(_data, 0x24))
344         }
345         return dataWallet == _wallet;
346     }
347 
348     /**
349     * @dev Parses the data to extract the method signature. 
350     */
351     function functionPrefix(bytes _data) internal pure returns (bytes4 prefix) {
352         require(_data.length >= 4, "RM: Invalid functionPrefix");
353         // solium-disable-next-line security/no-inline-assembly
354         assembly {
355             prefix := mload(add(_data, 0x20))
356         }
357     }
358 }
359 
360 /**
361  * @title LimitManager
362  * @dev Module to transfer tokens (ETH or ERC20) based on a security context (daily limit, whitelist, etc).
363  * @author Julien Niset - <julien@argent.xyz>
364  */
365 contract LimitManager is BaseModule {
366 
367     // large limit when the limit can be considered disabled
368     uint128 constant internal LIMIT_DISABLED = uint128(-1); // 3.40282366920938463463374607431768211455e+38
369 
370     using SafeMath for uint256;
371 
372     struct LimitManagerConfig {
373         // The global limit
374         Limit limit;
375         // whitelist
376         DailySpent dailySpent;
377     } 
378 
379     struct Limit {
380         // the current limit
381         uint128 current;
382         // the pending limit if any
383         uint128 pending;
384         // when the pending limit becomes the current limit
385         uint64 changeAfter;
386     }
387 
388     struct DailySpent {
389         // The amount already spent during the current period
390         uint128 alreadySpent;
391         // The end of the current period
392         uint64 periodEnd;
393     }
394 
395     // wallet specific storage
396     mapping (address => LimitManagerConfig) internal limits;
397     // The default limit
398     uint256 public defaultLimit;
399 
400     // *************** Events *************************** //
401 
402     event LimitChanged(address indexed wallet, uint indexed newLimit, uint64 indexed startAfter);
403 
404     // *************** Constructor ********************** //
405 
406     constructor(uint256 _defaultLimit) public {
407         defaultLimit = _defaultLimit;
408     }
409 
410     // *************** External/Public Functions ********************* //
411 
412     /**
413      * @dev Inits the module for a wallet by setting the limit to the default value.
414      * @param _wallet The target wallet.
415      */
416     function init(BaseWallet _wallet) external onlyWallet(_wallet) {
417         Limit storage limit = limits[_wallet].limit;
418         if(limit.current == 0 && limit.changeAfter == 0) {
419             limit.current = uint128(defaultLimit);
420         }
421     }
422 
423     /**
424      * @dev Changes the global limit. 
425      * The limit is expressed in ETH and the change is pending for the security period.
426      * @param _wallet The target wallet.
427      * @param _newLimit The new limit.
428      * @param _securityPeriod The security period.
429      */
430     function changeLimit(BaseWallet _wallet, uint256 _newLimit, uint256 _securityPeriod) internal {
431         Limit storage limit = limits[_wallet].limit;
432         // solium-disable-next-line security/no-block-members
433         uint128 currentLimit = (limit.changeAfter > 0 && limit.changeAfter < now) ? limit.pending : limit.current;
434         limit.current = currentLimit;
435         limit.pending = uint128(_newLimit);
436         // solium-disable-next-line security/no-block-members
437         limit.changeAfter = uint64(now.add(_securityPeriod));
438         // solium-disable-next-line security/no-block-members
439         emit LimitChanged(_wallet, _newLimit, uint64(now.add(_securityPeriod)));
440     }
441 
442     // *************** Internal Functions ********************* //
443 
444     /**
445     * @dev Gets the current global limit for a wallet.
446     * @param _wallet The target wallet.
447     * @return the current limit expressed in ETH.
448     */
449     function getCurrentLimit(BaseWallet _wallet) public view returns (uint256 _currentLimit) {
450         Limit storage limit = limits[_wallet].limit;
451         _currentLimit = uint256(currentLimit(limit.current, limit.pending, limit.changeAfter));
452     }
453 
454     /**
455     * @dev Gets a pending limit for a wallet if any.
456     * @param _wallet The target wallet.
457     * @return the pending limit (in ETH) and the time at chich it will become effective.
458     */
459     function getPendingLimit(BaseWallet _wallet) external view returns (uint256 _pendingLimit, uint64 _changeAfter) {
460         Limit storage limit = limits[_wallet].limit;
461         // solium-disable-next-line security/no-block-members
462         return ((now < limit.changeAfter)? (uint256(limit.pending), limit.changeAfter) : (0,0));
463     }
464 
465     /**
466     * @dev Gets the amount of tokens that has not yet been spent during the current period.
467     * @param _wallet The target wallet.
468     * @return the amount of tokens (in ETH) that has not been spent yet and the end of the period.
469     */
470     function getDailyUnspent(BaseWallet _wallet) external view returns (uint256 _unspent, uint64 _periodEnd) {
471         uint256 globalLimit = getCurrentLimit(_wallet);
472         DailySpent storage expense = limits[_wallet].dailySpent;
473         // solium-disable-next-line security/no-block-members
474         if(now > expense.periodEnd) {
475             _unspent = globalLimit;
476             _periodEnd = uint64(now + 24 hours);
477         }
478         else {
479             _unspent = globalLimit - expense.alreadySpent;
480             _periodEnd = expense.periodEnd;
481         }
482     }
483 
484     /**
485     * @dev Helper method to check if a transfer is within the limit.
486     * If yes the daily unspent for the current period is updated.
487     * @param _wallet The target wallet.
488     * @param _amount The amount for the transfer
489     */
490     function checkAndUpdateDailySpent(BaseWallet _wallet, uint _amount) internal returns (bool) {
491         Limit storage limit = limits[_wallet].limit;
492         uint128 current = currentLimit(limit.current, limit.pending, limit.changeAfter);
493         if(isWithinDailyLimit(_wallet, current, _amount)) {
494             updateDailySpent(_wallet, current, _amount);
495             return true;
496         }
497         return false;
498     }
499 
500     /**
501     * @dev Helper method to update the daily spent for the current period.
502     * @param _wallet The target wallet.
503     * @param _limit The current limit for the wallet.
504     * @param _amount The amount to add to the daily spent.
505     */
506     function updateDailySpent(BaseWallet _wallet, uint128 _limit, uint _amount) internal {
507         if(_limit != LIMIT_DISABLED) {
508             DailySpent storage expense = limits[_wallet].dailySpent;
509             if (expense.periodEnd < now) {
510                 expense.periodEnd = uint64(now + 24 hours);
511                 expense.alreadySpent = uint128(_amount);
512             }
513             else {
514                 expense.alreadySpent += uint128(_amount);
515             }
516         }
517     }
518 
519     /**
520     * @dev Checks if a transfer amount is withing the daily limit for a wallet.
521     * @param _wallet The target wallet.
522     * @param _limit The current limit for the wallet.
523     * @param _amount The transfer amount.
524     * @return true if the transfer amount is withing the daily limit.
525     */
526     function isWithinDailyLimit(BaseWallet _wallet, uint _limit, uint _amount) internal view returns (bool)  {
527         DailySpent storage expense = limits[_wallet].dailySpent;
528         if(_limit == LIMIT_DISABLED) {
529             return true;
530         }
531         else if (expense.periodEnd < now) {
532             return (_amount <= _limit);
533         } else {
534             return (expense.alreadySpent + _amount <= _limit && expense.alreadySpent + _amount >= expense.alreadySpent);
535         }
536     }
537 
538     /**
539     * @dev Helper method to get the current limit from a Limit struct.
540     * @param _current The value of the current parameter
541     * @param _pending The value of the pending parameter
542     * @param _changeAfter The value of the changeAfter parameter
543     */
544     function currentLimit(uint128 _current, uint128 _pending, uint64 _changeAfter) internal view returns (uint128) {
545         if(_changeAfter > 0 && _changeAfter < now) {
546             return _pending;
547         }
548         return _current;
549     }
550 }
551 
552 contract TokenPriceProvider {
553 
554     using SafeMath for uint256;
555 
556     // Mock token address for ETH
557     address constant internal ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
558     // Address of Kyber's trading contract
559     address constant internal KYBER_NETWORK_ADDRESS = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
560 
561     mapping(address => uint256) public cachedPrices;
562 
563     function syncPrice(ERC20 token) public {
564         uint256 expectedRate;
565         (expectedRate,) = kyberNetwork().getExpectedRate(token, ERC20(ETH_TOKEN_ADDRESS), 10000);
566         cachedPrices[token] = expectedRate;
567     }
568 
569     //
570     // Convenience functions
571     //
572 
573     function syncPriceForTokenList(ERC20[] tokens) public {
574         for(uint16 i = 0; i < tokens.length; i++) {
575             syncPrice(tokens[i]);
576         }
577     }
578 
579     /**
580      * @dev Converts the value of _amount tokens in ether.
581      * @param _amount the amount of tokens to convert (in 'token wei' twei)
582      * @param _token the ERC20 token contract
583      * @return the ether value (in wei) of _amount tokens with contract _token
584      */
585     function getEtherValue(uint256 _amount, address _token) public view returns (uint256) {
586         uint256 decimals = ERC20(_token).decimals();
587         uint256 price = cachedPrices[_token];
588         return price.mul(_amount).div(10**decimals);
589     }
590 
591     //
592     // Internal
593     //
594 
595     function kyberNetwork() internal view returns (KyberNetwork) {
596         return KyberNetwork(KYBER_NETWORK_ADDRESS);
597     }
598 }
599 
600 contract KyberNetwork {
601 
602     function getExpectedRate(
603         ERC20 src,
604         ERC20 dest,
605         uint srcQty
606     )
607         public
608         view
609         returns (uint expectedRate, uint slippageRate);
610 
611     function trade(
612         ERC20 src,
613         uint srcAmount,
614         ERC20 dest,
615         address destAddress,
616         uint maxDestAmount,
617         uint minConversionRate,
618         address walletId
619     )
620         public
621         payable
622         returns(uint);
623 }
624 
625 /* The MIT License (MIT)
626 
627 Copyright (c) 2016 Smart Contract Solutions, Inc.
628 
629 Permission is hereby granted, free of charge, to any person obtaining
630 a copy of this software and associated documentation files (the
631 "Software"), to deal in the Software without restriction, including
632 without limitation the rights to use, copy, modify, merge, publish,
633 distribute, sublicense, and/or sell copies of the Software, and to
634 permit persons to whom the Software is furnished to do so, subject to
635 the following conditions:
636 
637 The above copyright notice and this permission notice shall be included
638 in all copies or substantial portions of the Software.
639 
640 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
641 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
642 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
643 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
644 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
645 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
646 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
647 /**
648  * @title SafeMath
649  * @dev Math operations with safety checks that throw on error
650  */
651 library SafeMath {
652 
653     /**
654     * @dev Multiplies two numbers, reverts on overflow.
655     */
656     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
657         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
658         // benefit is lost if 'b' is also tested.
659         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
660         if (a == 0) {
661             return 0;
662         }
663 
664         uint256 c = a * b;
665         require(c / a == b);
666 
667         return c;
668     }
669 
670     /**
671     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
672     */
673     function div(uint256 a, uint256 b) internal pure returns (uint256) {
674         require(b > 0); // Solidity only automatically asserts when dividing by 0
675         uint256 c = a / b;
676         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
677 
678         return c;
679     }
680 
681     /**
682     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
683     */
684     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
685         require(b <= a);
686         uint256 c = a - b;
687 
688         return c;
689     }
690 
691     /**
692     * @dev Adds two numbers, reverts on overflow.
693     */
694     function add(uint256 a, uint256 b) internal pure returns (uint256) {
695         uint256 c = a + b;
696         require(c >= a);
697 
698         return c;
699     }
700 
701     /**
702     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
703     * reverts when dividing by zero.
704     */
705     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
706         require(b != 0);
707         return a % b;
708     }
709 
710     /**
711     * @dev Returns ceil(a / b).
712     */
713     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
714         uint256 c = a / b;
715         if(a % b == 0) {
716             return c;
717         }
718         else {
719             return c + 1;
720         }
721     }
722 }
723 
724 /**
725  * ERC20 contract interface.
726  */
727 contract ERC20 {
728     function totalSupply() public view returns (uint);
729     function decimals() public view returns (uint);
730     function balanceOf(address tokenOwner) public view returns (uint balance);
731     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
732     function transfer(address to, uint tokens) public returns (bool success);
733     function approve(address spender, uint tokens) public returns (bool success);
734     function transferFrom(address from, address to, uint tokens) public returns (bool success);
735 }
736 
737 /**
738  * @title Owned
739  * @dev Basic contract to define an owner.
740  * @author Julien Niset - <julien@argent.xyz>
741  */
742 contract Owned {
743 
744     // The owner
745     address public owner;
746 
747     event OwnerChanged(address indexed _newOwner);
748 
749     /**
750      * @dev Throws if the sender is not the owner.
751      */
752     modifier onlyOwner {
753         require(msg.sender == owner, "Must be owner");
754         _;
755     }
756 
757     constructor() public {
758         owner = msg.sender;
759     }
760 
761     /**
762      * @dev Lets the owner transfer ownership of the contract to a new owner.
763      * @param _newOwner The new owner.
764      */
765     function changeOwner(address _newOwner) external onlyOwner {
766         require(_newOwner != address(0), "Address must not be null");
767         owner = _newOwner;
768         emit OwnerChanged(_newOwner);
769     }
770 }
771 
772 /**
773  * @title ModuleRegistry
774  * @dev Registry of authorised modules. 
775  * Modules must be registered before they can be authorised on a wallet.
776  * @author Julien Niset - <julien@argent.xyz>
777  */
778 contract ModuleRegistry is Owned {
779 
780     mapping (address => Info) internal modules;
781     mapping (address => Info) internal upgraders;
782 
783     event ModuleRegistered(address indexed module, bytes32 name);
784     event ModuleDeRegistered(address module);
785     event UpgraderRegistered(address indexed upgrader, bytes32 name);
786     event UpgraderDeRegistered(address upgrader);
787 
788     struct Info {
789         bool exists;
790         bytes32 name;
791     }
792 
793     /**
794      * @dev Registers a module.
795      * @param _module The module.
796      * @param _name The unique name of the module.
797      */
798     function registerModule(address _module, bytes32 _name) external onlyOwner {
799         require(!modules[_module].exists, "MR: module already exists");
800         modules[_module] = Info({exists: true, name: _name});
801         emit ModuleRegistered(_module, _name);
802     }
803 
804     /**
805      * @dev Deregisters a module.
806      * @param _module The module.
807      */
808     function deregisterModule(address _module) external onlyOwner {
809         require(modules[_module].exists, "MR: module does not exists");
810         delete modules[_module];
811         emit ModuleDeRegistered(_module);
812     }
813 
814         /**
815      * @dev Registers an upgrader.
816      * @param _upgrader The upgrader.
817      * @param _name The unique name of the upgrader.
818      */
819     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
820         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
821         upgraders[_upgrader] = Info({exists: true, name: _name});
822         emit UpgraderRegistered(_upgrader, _name);
823     }
824 
825     /**
826      * @dev Deregisters an upgrader.
827      * @param _upgrader The _upgrader.
828      */
829     function deregisterUpgrader(address _upgrader) external onlyOwner {
830         require(upgraders[_upgrader].exists, "MR: upgrader does not exists");
831         delete upgraders[_upgrader];
832         emit UpgraderDeRegistered(_upgrader);
833     }
834 
835     /**
836     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
837     * registry.
838     * @param _token The token to recover.
839     */
840     function recoverToken(address _token) external onlyOwner {
841         uint total = ERC20(_token).balanceOf(address(this));
842         ERC20(_token).transfer(msg.sender, total);
843     } 
844 
845     /**
846      * @dev Gets the name of a module from its address.
847      * @param _module The module address.
848      * @return the name.
849      */
850     function moduleInfo(address _module) external view returns (bytes32) {
851         return modules[_module].name;
852     }
853 
854     /**
855      * @dev Gets the name of an upgrader from its address.
856      * @param _upgrader The upgrader address.
857      * @return the name.
858      */
859     function upgraderInfo(address _upgrader) external view returns (bytes32) {
860         return upgraders[_upgrader].name;
861     }
862 
863     /**
864      * @dev Checks if a module is registered.
865      * @param _module The module address.
866      * @return true if the module is registered.
867      */
868     function isRegisteredModule(address _module) external view returns (bool) {
869         return modules[_module].exists;
870     }
871 
872     /**
873      * @dev Checks if a list of modules are registered.
874      * @param _modules The list of modules address.
875      * @return true if all the modules are registered.
876      */
877     function isRegisteredModule(address[] _modules) external view returns (bool) {
878         for(uint i = 0; i < _modules.length; i++) {
879             if (!modules[_modules[i]].exists) {
880                 return false;
881             }
882         }
883         return true;
884     }  
885 
886     /**
887      * @dev Checks if an upgrader is registered.
888      * @param _upgrader The upgrader address.
889      * @return true if the upgrader is registered.
890      */
891     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
892         return upgraders[_upgrader].exists;
893     } 
894 }
895 
896 /**
897  * @title DappRegistry
898  * @dev Registry of dapp contracts and methods that have been authorised by Argent. 
899  * Registered methods can be authorised immediately for a dapp key and a wallet while 
900  * the authoirsation of unregistered methods is delayed for 24 hours. 
901  * @author Julien Niset - <julien@argent.xyz>
902  */
903 contract DappRegistry is Owned {
904 
905     // [contract][signature][bool]
906     mapping (address => mapping (bytes4 => bool)) internal authorised;
907 
908     event Registered(address indexed _contract, bytes4[] _methods);
909     event Deregistered(address indexed _contract, bytes4[] _methods);
910 
911     /**
912      * @dev Registers a list of methods for a dapp contract.
913      * @param _contract The dapp contract.
914      * @param _methods The dapp methods.
915      */
916     function register(address _contract, bytes4[] _methods) external onlyOwner {
917         for(uint i = 0; i < _methods.length; i++) {
918             authorised[_contract][_methods[i]] = true;
919         }
920         emit Registered(_contract, _methods);
921     }
922 
923     /**
924      * @dev Deregisters a list of methods for a dapp contract.
925      * @param _contract The dapp contract.
926      * @param _methods The dapp methods.
927      */
928     function deregister(address _contract, bytes4[] _methods) external onlyOwner {
929         for(uint i = 0; i < _methods.length; i++) {
930             authorised[_contract][_methods[i]] = false;
931         }
932         emit Deregistered(_contract, _methods);
933     }
934 
935     /**
936      * @dev Checks if a list of methods are registered for a dapp contract.
937      * @param _contract The dapp contract.
938      * @param _method The dapp methods.
939      * @return true if all the methods are registered.
940      */
941     function isRegistered(address _contract, bytes4 _method) external view returns (bool) {
942         return authorised[_contract][_method];
943     }  
944 
945     /**
946      * @dev Checks if a list of methods are registered for a dapp contract.
947      * @param _contract The dapp contract.
948      * @param _methods The dapp methods.
949      * @return true if all the methods are registered.
950      */
951     function isRegistered(address _contract, bytes4[] _methods) external view returns (bool) {
952         for(uint i = 0; i < _methods.length; i++) {
953             if (!authorised[_contract][_methods[i]]) {
954                 return false;
955             }
956         }
957         return true;
958     }  
959 }
960 
961 /**
962  * @title Storage
963  * @dev Base contract for the storage of a wallet.
964  * @author Julien Niset - <julien@argent.xyz>
965  */
966 contract Storage {
967 
968     /**
969      * @dev Throws if the caller is not an authorised module.
970      */
971     modifier onlyModule(BaseWallet _wallet) {
972         require(_wallet.authorised(msg.sender), "TS: must be an authorized module to call this method");
973         _;
974     }
975 }
976 
977 /**
978  * @title GuardianStorage
979  * @dev Contract storing the state of wallets related to guardians and lock.
980  * The contract only defines basic setters and getters with no logic. Only modules authorised
981  * for a wallet can modify its state.
982  * @author Julien Niset - <julien@argent.xyz>
983  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
984  */
985 contract GuardianStorage is Storage {
986 
987     struct GuardianStorageConfig {
988         // the list of guardians
989         address[] guardians;
990         // the info about guardians
991         mapping (address => GuardianInfo) info;
992         // the lock's release timestamp
993         uint256 lock; 
994         // the module that set the last lock
995         address locker;
996     }
997 
998     struct GuardianInfo {
999         bool exists;
1000         uint128 index;
1001     }
1002 
1003     // wallet specific storage
1004     mapping (address => GuardianStorageConfig) internal configs;
1005 
1006     // *************** External Functions ********************* //
1007 
1008     /**
1009      * @dev Lets an authorised module add a guardian to a wallet.
1010      * @param _wallet The target wallet.
1011      * @param _guardian The guardian to add.
1012      */
1013     function addGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
1014         GuardianStorageConfig storage config = configs[_wallet];
1015         config.info[_guardian].exists = true;
1016         config.info[_guardian].index = uint128(config.guardians.push(_guardian) - 1);
1017     }
1018 
1019     /**
1020      * @dev Lets an authorised module revoke a guardian from a wallet.
1021      * @param _wallet The target wallet.
1022      * @param _guardian The guardian to revoke.
1023      */
1024     function revokeGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
1025         GuardianStorageConfig storage config = configs[_wallet];
1026         address lastGuardian = config.guardians[config.guardians.length - 1];
1027         if (_guardian != lastGuardian) {
1028             uint128 targetIndex = config.info[_guardian].index;
1029             config.guardians[targetIndex] = lastGuardian;
1030             config.info[lastGuardian].index = targetIndex;
1031         }
1032         config.guardians.length--;
1033         delete config.info[_guardian];
1034     }
1035 
1036     /**
1037      * @dev Returns the number of guardians for a wallet.
1038      * @param _wallet The target wallet.
1039      * @return the number of guardians.
1040      */
1041     function guardianCount(BaseWallet _wallet) external view returns (uint256) {
1042         return configs[_wallet].guardians.length;
1043     }
1044     
1045     /**
1046      * @dev Gets the list of guaridans for a wallet.
1047      * @param _wallet The target wallet.
1048      * @return the list of guardians.
1049      */
1050     function getGuardians(BaseWallet _wallet) external view returns (address[]) {
1051         GuardianStorageConfig storage config = configs[_wallet];
1052         address[] memory guardians = new address[](config.guardians.length);
1053         for (uint256 i = 0; i < config.guardians.length; i++) {
1054             guardians[i] = config.guardians[i];
1055         }
1056         return guardians;
1057     }
1058 
1059     /**
1060      * @dev Checks if an account is a guardian for a wallet.
1061      * @param _wallet The target wallet.
1062      * @param _guardian The account.
1063      * @return true if the account is a guardian for a wallet.
1064      */
1065     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool) {
1066         return configs[_wallet].info[_guardian].exists;
1067     }
1068 
1069     /**
1070      * @dev Lets an authorised module set the lock for a wallet.
1071      * @param _wallet The target wallet.
1072      * @param _releaseAfter The epoch time at which the lock should automatically release.
1073      */
1074     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external onlyModule(_wallet) {
1075         configs[_wallet].lock = _releaseAfter;
1076         if(_releaseAfter != 0 && msg.sender != configs[_wallet].locker) {
1077             configs[_wallet].locker = msg.sender;
1078         }
1079     }
1080 
1081     /**
1082      * @dev Checks if the lock is set for a wallet.
1083      * @param _wallet The target wallet.
1084      * @return true if the lock is set for the wallet.
1085      */
1086     function isLocked(BaseWallet _wallet) external view returns (bool) {
1087         return configs[_wallet].lock > now;
1088     }
1089 
1090     /**
1091      * @dev Gets the time at which the lock of a wallet will release.
1092      * @param _wallet The target wallet.
1093      * @return the time at which the lock of a wallet will release, or zero if there is no lock set.
1094      */
1095     function getLock(BaseWallet _wallet) external view returns (uint256) {
1096         return configs[_wallet].lock;
1097     }
1098 
1099     /**
1100      * @dev Gets the address of the last module that modified the lock for a wallet.
1101      * @param _wallet The target wallet.
1102      * @return the address of the last module that modified the lock for a wallet.
1103      */
1104     function getLocker(BaseWallet _wallet) external view returns (address) {
1105         return configs[_wallet].locker;
1106     }
1107 }
1108 
1109 /**
1110  * @title DappStorage
1111  * @dev Contract storing the state of wallets related to authorised dapps.
1112  * The contract only defines basic setters and getters with no logic. Only modules authorised
1113  * for a wallet can modify its state.
1114  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
1115  */
1116 contract DappStorage is Storage {
1117 
1118     // [wallet][dappkey][contract][signature][bool]
1119     mapping (address => mapping (address => mapping (address => mapping (bytes4 => bool)))) internal whitelistedMethods;
1120     
1121     // *************** External Functions ********************* //
1122 
1123     /**
1124      * @dev (De)authorizes an external contract's methods to be called by a dapp key of the wallet.
1125      * @param _wallet The wallet.
1126      * @param _dapp The address of the signing key.
1127      * @param _contract The contract address.
1128      * @param _signatures The methods' signatures.
1129      * @param _authorized true to whitelist, false to blacklist.
1130      */
1131     function setMethodAuthorization(
1132         BaseWallet _wallet, 
1133         address _dapp, 
1134         address _contract, 
1135         bytes4[] _signatures, 
1136         bool _authorized
1137     ) 
1138         external 
1139         onlyModule(_wallet) 
1140     {
1141         for(uint i = 0; i < _signatures.length; i++) {
1142             whitelistedMethods[_wallet][_dapp][_contract][_signatures[i]] = _authorized;
1143         }
1144     }
1145 
1146     /**
1147      * @dev Gets the authorization status for an external contract's method.
1148      * @param _wallet The wallet.
1149      * @param _dapp The address of the signing key.
1150      * @param _contract The contract address.
1151      * @param _signature The call signature.
1152      * @return true if the method is whitelisted, false otherwise
1153      */
1154     function getMethodAuthorization(BaseWallet _wallet, address _dapp, address _contract, bytes4 _signature) external view returns (bool) {
1155         return whitelistedMethods[_wallet][_dapp][_contract][_signature];
1156     }
1157 }
1158 
1159 /**
1160  * @title BaseWallet
1161  * @dev Simple modular wallet that authorises modules to call its invoke() method.
1162  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
1163  * @author Julien Niset - <julien@argent.xyz>
1164  */
1165 contract BaseWallet {
1166 
1167     // The implementation of the proxy
1168     address public implementation;
1169     // The owner 
1170     address public owner;
1171     // The authorised modules
1172     mapping (address => bool) public authorised;
1173     // The enabled static calls
1174     mapping (bytes4 => address) public enabled;
1175     // The number of modules
1176     uint public modules;
1177     
1178     event AuthorisedModule(address indexed module, bool value);
1179     event EnabledStaticCall(address indexed module, bytes4 indexed method);
1180     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
1181     event Received(uint indexed value, address indexed sender, bytes data);
1182     event OwnerChanged(address owner);
1183     
1184     /**
1185      * @dev Throws if the sender is not an authorised module.
1186      */
1187     modifier moduleOnly {
1188         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
1189         _;
1190     }
1191 
1192     /**
1193      * @dev Inits the wallet by setting the owner and authorising a list of modules.
1194      * @param _owner The owner.
1195      * @param _modules The modules to authorise.
1196      */
1197     function init(address _owner, address[] _modules) external {
1198         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
1199         require(_modules.length > 0, "BW: construction requires at least 1 module");
1200         owner = _owner;
1201         modules = _modules.length;
1202         for(uint256 i = 0; i < _modules.length; i++) {
1203             require(authorised[_modules[i]] == false, "BW: module is already added");
1204             authorised[_modules[i]] = true;
1205             Module(_modules[i]).init(this);
1206             emit AuthorisedModule(_modules[i], true);
1207         }
1208     }
1209     
1210     /**
1211      * @dev Enables/Disables a module.
1212      * @param _module The target module.
1213      * @param _value Set to true to authorise the module.
1214      */
1215     function authoriseModule(address _module, bool _value) external moduleOnly {
1216         if (authorised[_module] != _value) {
1217             if(_value == true) {
1218                 modules += 1;
1219                 authorised[_module] = true;
1220                 Module(_module).init(this);
1221             }
1222             else {
1223                 modules -= 1;
1224                 require(modules > 0, "BW: wallet must have at least one module");
1225                 delete authorised[_module];
1226             }
1227             emit AuthorisedModule(_module, _value);
1228         }
1229     }
1230 
1231     /**
1232     * @dev Enables a static method by specifying the target module to which the call
1233     * must be delegated.
1234     * @param _module The target module.
1235     * @param _method The static method signature.
1236     */
1237     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
1238         require(authorised[_module], "BW: must be an authorised module for static call");
1239         enabled[_method] = _module;
1240         emit EnabledStaticCall(_module, _method);
1241     }
1242 
1243     /**
1244      * @dev Sets a new owner for the wallet.
1245      * @param _newOwner The new owner.
1246      */
1247     function setOwner(address _newOwner) external moduleOnly {
1248         require(_newOwner != address(0), "BW: address cannot be null");
1249         owner = _newOwner;
1250         emit OwnerChanged(_newOwner);
1251     }
1252     
1253     /**
1254      * @dev Performs a generic transaction.
1255      * @param _target The address for the transaction.
1256      * @param _value The value of the transaction.
1257      * @param _data The data of the transaction.
1258      */
1259     function invoke(address _target, uint _value, bytes _data) external moduleOnly {
1260         // solium-disable-next-line security/no-call-value
1261         require(_target.call.value(_value)(_data), "BW: call to target failed");
1262         emit Invoked(msg.sender, _target, _value, _data);
1263     }
1264 
1265     /**
1266      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
1267      * implement specific static methods. It delegates the static call to a target contract if the data corresponds 
1268      * to an enabled method, or logs the call otherwise.
1269      */
1270     function() public payable {
1271         if(msg.data.length > 0) { 
1272             address module = enabled[msg.sig];
1273             if(module == address(0)) {
1274                 emit Received(msg.value, msg.sender, msg.data);
1275             } 
1276             else {
1277                 require(authorised[module], "BW: must be an authorised module for static call");
1278                 // solium-disable-next-line security/no-inline-assembly
1279                 assembly {
1280                     calldatacopy(0, 0, calldatasize())
1281                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
1282                     returndatacopy(0, 0, returndatasize())
1283                     switch result 
1284                     case 0 {revert(0, returndatasize())} 
1285                     default {return (0, returndatasize())}
1286                 }
1287             }
1288         }
1289     }
1290 }
1291 
1292 /**
1293  * @title DappManager
1294  * @dev Module to enable authorised dapps to transfer tokens (ETH or ERC20) on behalf of a wallet.
1295  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
1296  */
1297 contract DappManager is BaseModule, RelayerModule, LimitManager {
1298 
1299     bytes32 constant NAME = "DappManager";
1300 
1301     bytes4 constant internal CONFIRM_AUTHORISATION_PREFIX = bytes4(keccak256("confirmAuthorizeCall(address,address,address,bytes4[])"));
1302     bytes4 constant internal CALL_CONTRACT_PREFIX = bytes4(keccak256("callContract(address,address,address,uint256,bytes)"));
1303 
1304     // Mock token address for ETH
1305     address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1306 
1307     using SafeMath for uint256;
1308 
1309     // // The Guardian storage 
1310     GuardianStorage public guardianStorage;
1311     // The Dapp limit storage
1312     DappStorage public dappStorage;
1313     // The authorised dapp registry
1314     DappRegistry public dappRegistry;
1315     // The security period
1316     uint256 public securityPeriod;
1317     // the security window
1318     uint256 public securityWindow;
1319 
1320     struct DappManagerConfig {
1321         // the time at which a dapp authorisation can be confirmed
1322         mapping (bytes32 => uint256) pending;
1323     }
1324 
1325     // the wallet specific storage
1326     mapping (address => DappManagerConfig) internal configs;
1327 
1328     // *************** Events *************************** //
1329   
1330     event Transfer(address indexed wallet, address indexed token, uint256 indexed amount, address to, bytes data);    
1331     event ContractCallAuthorizationRequested(address indexed _wallet, address indexed _dapp, address indexed _contract, bytes4[] _signatures);
1332     event ContractCallAuthorizationCanceled(address indexed _wallet, address indexed _dapp, address indexed _contract, bytes4[] _signatures);
1333     event ContractCallAuthorized(address indexed _wallet, address indexed _dapp, address indexed _contract, bytes4[] _signatures);
1334     event ContractCallDeauthorized(address indexed _wallet, address indexed _dapp, address indexed _contract, bytes4[] _signatures);
1335 
1336     // *************** Modifiers *************************** //
1337 
1338     /**
1339      * @dev Throws unless called by this contract or by _dapp.
1340      */
1341     modifier onlyExecuteOrDapp(address _dapp) {
1342         require(msg.sender == address(this) || msg.sender == _dapp, "DM: must be called by dapp or via execute()");
1343         _;
1344     }
1345 
1346     /**
1347      * @dev Throws if the wallet is locked.
1348      */
1349     modifier onlyWhenUnlocked(BaseWallet _wallet) {
1350         // solium-disable-next-line security/no-block-members
1351         require(!guardianStorage.isLocked(_wallet), "DM: wallet must be unlocked");
1352         _;
1353     }
1354 
1355     // *************** Constructor ********************** //
1356 
1357     constructor(
1358         ModuleRegistry _registry,
1359         DappRegistry _dappRegistry,
1360         DappStorage _dappStorage, 
1361         GuardianStorage _guardianStorage,
1362         uint256 _securityPeriod,
1363         uint256 _securityWindow,
1364         uint256 _defaultLimit
1365     ) 
1366         BaseModule(_registry, NAME)
1367         LimitManager(_defaultLimit)
1368         public 
1369     {
1370         dappStorage = _dappStorage;
1371         guardianStorage = _guardianStorage;
1372         dappRegistry = _dappRegistry;
1373         securityPeriod = _securityPeriod;
1374         securityWindow = _securityWindow;
1375     }
1376 
1377     // *************** External/Public Functions ********************* //
1378 
1379     /**
1380     * @dev lets a dapp call an arbitrary contract from a wallet.
1381     * @param _wallet The target wallet.
1382     * @param _dapp The authorised dapp.
1383     * @param _to The destination address
1384     * @param _amount The amoun6 of ether to transfer
1385     * @param _data The data for the transaction
1386     */
1387     function callContract(
1388         BaseWallet _wallet,
1389         address _dapp,
1390         address _to, 
1391         uint256 _amount, 
1392         bytes _data
1393     ) 
1394         external 
1395         onlyExecuteOrDapp(_dapp)
1396         onlyWhenUnlocked(_wallet)
1397     {
1398         require(isAuthorizedCall(_wallet, _dapp, _to, _data), "DM: Contract call not authorized");
1399         require(checkAndUpdateDailySpent(_wallet, _amount), "DM: Dapp limit exceeded");
1400         doCall(_wallet, _to, _amount, _data);
1401     }
1402 
1403     /**
1404      * @dev Authorizes an external contract's methods to be called by a dapp key of the wallet.
1405      * @param _wallet The wallet.
1406      * @param _dapp The address of the signing key.
1407      * @param _contract The target contract address.
1408      * @param _signatures The method signatures.
1409      */
1410     function authorizeCall(
1411         BaseWallet _wallet, 
1412         address _dapp,
1413         address _contract,
1414         bytes4[] _signatures
1415     ) 
1416         external 
1417         onlyOwner(_wallet) 
1418         onlyWhenUnlocked(_wallet)
1419     {
1420         require(_contract != address(0), "DM: Contract address cannot be null");
1421         if(dappRegistry.isRegistered(_contract, _signatures)) {
1422             // authorise immediately
1423             dappStorage.setMethodAuthorization(_wallet, _dapp, _contract, _signatures, true);
1424             emit ContractCallAuthorized(_wallet, _dapp, _contract, _signatures);
1425         }
1426         else {
1427             bytes32 id = keccak256(abi.encodePacked(address(_wallet), _dapp, _contract, _signatures, true));
1428             configs[_wallet].pending[id] = now + securityPeriod;
1429             emit ContractCallAuthorizationRequested(_wallet, _dapp, _contract, _signatures);
1430         }
1431     }
1432 
1433     /**
1434      * @dev Deauthorizes an external contract's methods to be called by a dapp key of the wallet.
1435      * @param _wallet The wallet.
1436      * @param _dapp The address of the signing key.
1437      * @param _contract The target contract address.
1438      * @param _signatures The method signatures.
1439      */
1440     function deauthorizeCall(
1441         BaseWallet _wallet, 
1442         address _dapp,
1443         address _contract,
1444         bytes4[] _signatures
1445     ) 
1446         external 
1447         onlyOwner(_wallet) 
1448         onlyWhenUnlocked(_wallet)
1449     {
1450         dappStorage.setMethodAuthorization(_wallet, _dapp, _contract, _signatures, false);
1451         emit ContractCallDeauthorized(_wallet, _dapp, _contract, _signatures);
1452     }
1453 
1454     /**
1455      * @dev Confirms the authorisation of an external contract's methods to be called by a dapp key of the wallet.
1456      * @param _wallet The wallet.
1457      * @param _dapp The address of the signing key.
1458      * @param _contract The target contract address.
1459      * @param _signatures The method signatures.
1460      */
1461     function confirmAuthorizeCall(
1462         BaseWallet _wallet, 
1463         address _dapp,
1464         address _contract,
1465         bytes4[] _signatures
1466     ) 
1467         external 
1468         onlyWhenUnlocked(_wallet)
1469     {
1470         bytes32 id = keccak256(abi.encodePacked(address(_wallet), _dapp, _contract, _signatures, true));
1471         DappManagerConfig storage config = configs[_wallet];
1472         require(config.pending[id] > 0, "DM: No pending authorisation for the target dapp");
1473         require(config.pending[id] < now, "DM: Too early to confirm pending authorisation");
1474         require(now < config.pending[id] + securityWindow, "GM: Too late to confirm pending authorisation");
1475         dappStorage.setMethodAuthorization(_wallet, _dapp, _contract, _signatures, true);
1476         delete config.pending[id];
1477         emit ContractCallAuthorized(_wallet, _dapp, _contract, _signatures);
1478     }
1479 
1480     /**
1481      * @dev Cancels an authorisation request for an external contract's methods to be called by a dapp key of the wallet.
1482      * @param _wallet The wallet.
1483      * @param _dapp The address of the signing key.
1484      * @param _contract The target contract address.
1485      * @param _signatures The method signatures.
1486      */
1487     function cancelAuthorizeCall(
1488         BaseWallet _wallet, 
1489         address _dapp,
1490         address _contract,
1491         bytes4[] _signatures
1492     )
1493         public 
1494         onlyOwner(_wallet) 
1495         onlyWhenUnlocked(_wallet) 
1496     {
1497         bytes32 id = keccak256(abi.encodePacked(address(_wallet), _dapp, _contract, _signatures, true));
1498         DappManagerConfig storage config = configs[_wallet];
1499         require(config.pending[id] > 0, "DM: No pending authorisation for the target dapp");
1500         delete config.pending[id];
1501         emit ContractCallAuthorizationCanceled(_wallet, _dapp, _contract, _signatures);
1502     }
1503 
1504     /**
1505     * @dev Checks if a contract call is authorized for a given signing key.
1506     * @param _wallet The target wallet.
1507     * @param _dapp The address of the signing key.
1508     * @param _to The address of the contract to call
1509     * @param _data The call data
1510     * @return true if the contract call is authorised for the wallet.
1511     */
1512     function isAuthorizedCall(BaseWallet _wallet, address _dapp, address _to, bytes _data) public view returns (bool _isAuthorized) {
1513         if(_data.length >= 4) {
1514             return dappStorage.getMethodAuthorization(_wallet, _dapp, _to, functionPrefix(_data));
1515         }
1516         // the fallback method must be authorized
1517         return dappStorage.getMethodAuthorization(_wallet, _dapp, _to, "");
1518     }
1519 
1520     /**
1521      * @dev Lets the owner of a wallet change its dapp limit. 
1522      * The limit is expressed in ETH. Changes to the limit take 24 hours.
1523      * @param _wallet The target wallet.
1524      * @param _newLimit The new limit.
1525      */
1526     function changeLimit(BaseWallet _wallet, uint256 _newLimit) public onlyOwner(_wallet) onlyWhenUnlocked(_wallet) {
1527         changeLimit(_wallet, _newLimit, securityPeriod);
1528     }
1529 
1530     /**
1531      * @dev Convenience method to disable the limit
1532      * The limit is disabled by setting it to an arbitrary large value.
1533      * @param _wallet The target wallet.
1534      */
1535     function disableLimit(BaseWallet _wallet) external onlyOwner(_wallet) onlyWhenUnlocked(_wallet) {
1536         changeLimit(_wallet, LIMIT_DISABLED, securityPeriod);
1537     }
1538 
1539     /**
1540     * @dev Internal method to instruct a wallet to call an extrenal contract.
1541     * @param _wallet The target wallet.
1542     * @param _to The external contract.
1543     * @param _value The amount of ETH for the call
1544     * @param _data The data of the call.
1545     */
1546 
1547     function doCall(BaseWallet _wallet, address _to, uint256 _value, bytes _data) internal {
1548         _wallet.invoke(_to, _value, _data);
1549         emit Transfer(_wallet, ETH_TOKEN, _value, _to, _data);
1550     }
1551 
1552     // *************** Implementation of RelayerModule methods ********************* //
1553 
1554     // Overrides refund to add the refund in the daily limit.
1555     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
1556         // 21000 (transaction) + 7620 (execution of refund) + 7324 (execution of updateDailySpent) + 672 to log the event + _gasUsed
1557         uint256 amount = 36616 + _gasUsed; 
1558         if(_gasPrice > 0 && _signatures > 0 && amount <= _gasLimit) {
1559             if(_gasPrice > tx.gasprice) {
1560                 amount = amount * tx.gasprice;
1561             }
1562             else {
1563                 amount = amount * _gasPrice;
1564             }
1565             updateDailySpent(_wallet, uint128(getCurrentLimit(_wallet)), amount);
1566             _wallet.invoke(_relayer, amount, "");
1567         }
1568     }
1569 
1570     // Overrides verifyRefund to add the refund in the daily limit.
1571     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
1572         if(_gasPrice > 0 && _signatures > 0 && (
1573                 address(_wallet).balance < _gasUsed * _gasPrice 
1574                 || isWithinDailyLimit(_wallet, getCurrentLimit(_wallet), _gasUsed * _gasPrice) == false
1575                 || _wallet.authorised(this) == false
1576         ))
1577         {
1578             return false;
1579         }
1580         return true;
1581     }
1582 
1583     // Overrides to use the incremental nonce and save some gas
1584     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
1585         return checkAndUpdateNonce(_wallet, _nonce);
1586     }
1587 
1588     function validateSignatures(BaseWallet _wallet, bytes _data, bytes32 _signHash, bytes _signatures) internal view returns (bool) {
1589         address signer = recoverSigner(_signHash, _signatures, 0);
1590         if(functionPrefix(_data) == CALL_CONTRACT_PREFIX) {
1591             // "RM: Invalid dapp in data"
1592             if(_data.length < 68) {
1593                 return false;
1594             }
1595             address dapp;
1596             // solium-disable-next-line security/no-inline-assembly
1597             assembly {
1598                 //_data = {length:32}{sig:4}{_wallet:32}{_dapp:32}{...}
1599                 dapp := mload(add(_data, 0x44))
1600             }
1601             return dapp == signer; // "DM: dapp and signer must be the same"
1602         } else {
1603             return isOwner(_wallet, signer); // "DM: signer must be owner"
1604         }
1605     }
1606 
1607     function getRequiredSignatures(BaseWallet _wallet, bytes _data) internal view returns (uint256) {
1608         bytes4 methodId = functionPrefix(_data);
1609         if (methodId == CONFIRM_AUTHORISATION_PREFIX) {
1610             return 0;
1611         }
1612         return 1;
1613     }
1614 }