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
552 /**
553  * ERC20 contract interface.
554  */
555 contract ERC20 {
556     function totalSupply() public view returns (uint);
557     function decimals() public view returns (uint);
558     function balanceOf(address tokenOwner) public view returns (uint balance);
559     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
560     function transfer(address to, uint tokens) public returns (bool success);
561     function approve(address spender, uint tokens) public returns (bool success);
562     function transferFrom(address from, address to, uint tokens) public returns (bool success);
563 }
564 
565 /* The MIT License (MIT)
566 
567 Copyright (c) 2016 Smart Contract Solutions, Inc.
568 
569 Permission is hereby granted, free of charge, to any person obtaining
570 a copy of this software and associated documentation files (the
571 "Software"), to deal in the Software without restriction, including
572 without limitation the rights to use, copy, modify, merge, publish,
573 distribute, sublicense, and/or sell copies of the Software, and to
574 permit persons to whom the Software is furnished to do so, subject to
575 the following conditions:
576 
577 The above copyright notice and this permission notice shall be included
578 in all copies or substantial portions of the Software.
579 
580 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
581 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
582 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
583 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
584 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
585 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
586 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
587 /**
588  * @title SafeMath
589  * @dev Math operations with safety checks that throw on error
590  */
591 library SafeMath {
592 
593     /**
594     * @dev Multiplies two numbers, reverts on overflow.
595     */
596     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
597         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
598         // benefit is lost if 'b' is also tested.
599         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
600         if (a == 0) {
601             return 0;
602         }
603 
604         uint256 c = a * b;
605         require(c / a == b);
606 
607         return c;
608     }
609 
610     /**
611     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
612     */
613     function div(uint256 a, uint256 b) internal pure returns (uint256) {
614         require(b > 0); // Solidity only automatically asserts when dividing by 0
615         uint256 c = a / b;
616         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
617 
618         return c;
619     }
620 
621     /**
622     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
623     */
624     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
625         require(b <= a);
626         uint256 c = a - b;
627 
628         return c;
629     }
630 
631     /**
632     * @dev Adds two numbers, reverts on overflow.
633     */
634     function add(uint256 a, uint256 b) internal pure returns (uint256) {
635         uint256 c = a + b;
636         require(c >= a);
637 
638         return c;
639     }
640 
641     /**
642     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
643     * reverts when dividing by zero.
644     */
645     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
646         require(b != 0);
647         return a % b;
648     }
649 
650     /**
651     * @dev Returns ceil(a / b).
652     */
653     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
654         uint256 c = a / b;
655         if(a % b == 0) {
656             return c;
657         }
658         else {
659             return c + 1;
660         }
661     }
662 }
663 
664 /**
665  * @title Owned
666  * @dev Basic contract to define an owner.
667  * @author Julien Niset - <julien@argent.xyz>
668  */
669 contract Owned {
670 
671     // The owner
672     address public owner;
673 
674     event OwnerChanged(address indexed _newOwner);
675 
676     /**
677      * @dev Throws if the sender is not the owner.
678      */
679     modifier onlyOwner {
680         require(msg.sender == owner, "Must be owner");
681         _;
682     }
683 
684     constructor() public {
685         owner = msg.sender;
686     }
687 
688     /**
689      * @dev Lets the owner transfer ownership of the contract to a new owner.
690      * @param _newOwner The new owner.
691      */
692     function changeOwner(address _newOwner) external onlyOwner {
693         require(_newOwner != address(0), "Address must not be null");
694         owner = _newOwner;
695         emit OwnerChanged(_newOwner);
696     }
697 }
698 
699 /**
700  * @title ModuleRegistry
701  * @dev Registry of authorised modules. 
702  * Modules must be registered before they can be authorised on a wallet.
703  * @author Julien Niset - <julien@argent.xyz>
704  */
705 contract ModuleRegistry is Owned {
706 
707     mapping (address => Info) internal modules;
708     mapping (address => Info) internal upgraders;
709 
710     event ModuleRegistered(address indexed module, bytes32 name);
711     event ModuleDeRegistered(address module);
712     event UpgraderRegistered(address indexed upgrader, bytes32 name);
713     event UpgraderDeRegistered(address upgrader);
714 
715     struct Info {
716         bool exists;
717         bytes32 name;
718     }
719 
720     /**
721      * @dev Registers a module.
722      * @param _module The module.
723      * @param _name The unique name of the module.
724      */
725     function registerModule(address _module, bytes32 _name) external onlyOwner {
726         require(!modules[_module].exists, "MR: module already exists");
727         modules[_module] = Info({exists: true, name: _name});
728         emit ModuleRegistered(_module, _name);
729     }
730 
731     /**
732      * @dev Deregisters a module.
733      * @param _module The module.
734      */
735     function deregisterModule(address _module) external onlyOwner {
736         require(modules[_module].exists, "MR: module does not exists");
737         delete modules[_module];
738         emit ModuleDeRegistered(_module);
739     }
740 
741         /**
742      * @dev Registers an upgrader.
743      * @param _upgrader The upgrader.
744      * @param _name The unique name of the upgrader.
745      */
746     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
747         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
748         upgraders[_upgrader] = Info({exists: true, name: _name});
749         emit UpgraderRegistered(_upgrader, _name);
750     }
751 
752     /**
753      * @dev Deregisters an upgrader.
754      * @param _upgrader The _upgrader.
755      */
756     function deregisterUpgrader(address _upgrader) external onlyOwner {
757         require(upgraders[_upgrader].exists, "MR: upgrader does not exists");
758         delete upgraders[_upgrader];
759         emit UpgraderDeRegistered(_upgrader);
760     }
761 
762     /**
763     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
764     * registry.
765     * @param _token The token to recover.
766     */
767     function recoverToken(address _token) external onlyOwner {
768         uint total = ERC20(_token).balanceOf(address(this));
769         ERC20(_token).transfer(msg.sender, total);
770     } 
771 
772     /**
773      * @dev Gets the name of a module from its address.
774      * @param _module The module address.
775      * @return the name.
776      */
777     function moduleInfo(address _module) external view returns (bytes32) {
778         return modules[_module].name;
779     }
780 
781     /**
782      * @dev Gets the name of an upgrader from its address.
783      * @param _upgrader The upgrader address.
784      * @return the name.
785      */
786     function upgraderInfo(address _upgrader) external view returns (bytes32) {
787         return upgraders[_upgrader].name;
788     }
789 
790     /**
791      * @dev Checks if a module is registered.
792      * @param _module The module address.
793      * @return true if the module is registered.
794      */
795     function isRegisteredModule(address _module) external view returns (bool) {
796         return modules[_module].exists;
797     }
798 
799     /**
800      * @dev Checks if a list of modules are registered.
801      * @param _modules The list of modules address.
802      * @return true if all the modules are registered.
803      */
804     function isRegisteredModule(address[] _modules) external view returns (bool) {
805         for(uint i = 0; i < _modules.length; i++) {
806             if (!modules[_modules[i]].exists) {
807                 return false;
808             }
809         }
810         return true;
811     }  
812 
813     /**
814      * @dev Checks if an upgrader is registered.
815      * @param _upgrader The upgrader address.
816      * @return true if the upgrader is registered.
817      */
818     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
819         return upgraders[_upgrader].exists;
820     } 
821 }
822 
823 /**
824  * @title BaseWallet
825  * @dev Simple modular wallet that authorises modules to call its invoke() method.
826  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
827  * @author Julien Niset - <julien@argent.xyz>
828  */
829 contract BaseWallet {
830 
831     // The implementation of the proxy
832     address public implementation;
833     // The owner 
834     address public owner;
835     // The authorised modules
836     mapping (address => bool) public authorised;
837     // The enabled static calls
838     mapping (bytes4 => address) public enabled;
839     // The number of modules
840     uint public modules;
841     
842     event AuthorisedModule(address indexed module, bool value);
843     event EnabledStaticCall(address indexed module, bytes4 indexed method);
844     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
845     event Received(uint indexed value, address indexed sender, bytes data);
846     event OwnerChanged(address owner);
847     
848     /**
849      * @dev Throws if the sender is not an authorised module.
850      */
851     modifier moduleOnly {
852         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
853         _;
854     }
855 
856     /**
857      * @dev Inits the wallet by setting the owner and authorising a list of modules.
858      * @param _owner The owner.
859      * @param _modules The modules to authorise.
860      */
861     function init(address _owner, address[] _modules) external {
862         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
863         require(_modules.length > 0, "BW: construction requires at least 1 module");
864         owner = _owner;
865         modules = _modules.length;
866         for(uint256 i = 0; i < _modules.length; i++) {
867             require(authorised[_modules[i]] == false, "BW: module is already added");
868             authorised[_modules[i]] = true;
869             Module(_modules[i]).init(this);
870             emit AuthorisedModule(_modules[i], true);
871         }
872     }
873     
874     /**
875      * @dev Enables/Disables a module.
876      * @param _module The target module.
877      * @param _value Set to true to authorise the module.
878      */
879     function authoriseModule(address _module, bool _value) external moduleOnly {
880         if (authorised[_module] != _value) {
881             if(_value == true) {
882                 modules += 1;
883                 authorised[_module] = true;
884                 Module(_module).init(this);
885             }
886             else {
887                 modules -= 1;
888                 require(modules > 0, "BW: wallet must have at least one module");
889                 delete authorised[_module];
890             }
891             emit AuthorisedModule(_module, _value);
892         }
893     }
894 
895     /**
896     * @dev Enables a static method by specifying the target module to which the call
897     * must be delegated.
898     * @param _module The target module.
899     * @param _method The static method signature.
900     */
901     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
902         require(authorised[_module], "BW: must be an authorised module for static call");
903         enabled[_method] = _module;
904         emit EnabledStaticCall(_module, _method);
905     }
906 
907     /**
908      * @dev Sets a new owner for the wallet.
909      * @param _newOwner The new owner.
910      */
911     function setOwner(address _newOwner) external moduleOnly {
912         require(_newOwner != address(0), "BW: address cannot be null");
913         owner = _newOwner;
914         emit OwnerChanged(_newOwner);
915     }
916     
917     /**
918      * @dev Performs a generic transaction.
919      * @param _target The address for the transaction.
920      * @param _value The value of the transaction.
921      * @param _data The data of the transaction.
922      */
923     function invoke(address _target, uint _value, bytes _data) external moduleOnly {
924         // solium-disable-next-line security/no-call-value
925         require(_target.call.value(_value)(_data), "BW: call to target failed");
926         emit Invoked(msg.sender, _target, _value, _data);
927     }
928 
929     /**
930      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
931      * implement specific static methods. It delegates the static call to a target contract if the data corresponds 
932      * to an enabled method, or logs the call otherwise.
933      */
934     function() public payable {
935         if(msg.data.length > 0) { 
936             address module = enabled[msg.sig];
937             if(module == address(0)) {
938                 emit Received(msg.value, msg.sender, msg.data);
939             } 
940             else {
941                 require(authorised[module], "BW: must be an authorised module for static call");
942                 // solium-disable-next-line security/no-inline-assembly
943                 assembly {
944                     calldatacopy(0, 0, calldatasize())
945                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
946                     returndatacopy(0, 0, returndatasize())
947                     switch result 
948                     case 0 {revert(0, returndatasize())} 
949                     default {return (0, returndatasize())}
950                 }
951             }
952         }
953     }
954 }
955 
956 contract TokenPriceProvider {
957 
958     using SafeMath for uint256;
959 
960     // Mock token address for ETH
961     address constant internal ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
962     // Address of Kyber's trading contract
963     address constant internal KYBER_NETWORK_ADDRESS = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
964 
965     mapping(address => uint256) public cachedPrices;
966 
967     function syncPrice(ERC20 token) public {
968         uint256 expectedRate;
969         (expectedRate,) = kyberNetwork().getExpectedRate(token, ERC20(ETH_TOKEN_ADDRESS), 10000);
970         cachedPrices[token] = expectedRate;
971     }
972 
973     //
974     // Convenience functions
975     //
976 
977     function syncPriceForTokenList(ERC20[] tokens) public {
978         for(uint16 i = 0; i < tokens.length; i++) {
979             syncPrice(tokens[i]);
980         }
981     }
982 
983     /**
984      * @dev Converts the value of _amount tokens in ether.
985      * @param _amount the amount of tokens to convert (in 'token wei' twei)
986      * @param _token the ERC20 token contract
987      * @return the ether value (in wei) of _amount tokens with contract _token
988      */
989     function getEtherValue(uint256 _amount, address _token) public view returns (uint256) {
990         uint256 decimals = ERC20(_token).decimals();
991         uint256 price = cachedPrices[_token];
992         return price.mul(_amount).div(10**decimals);
993     }
994 
995     //
996     // Internal
997     //
998 
999     function kyberNetwork() internal view returns (KyberNetwork) {
1000         return KyberNetwork(KYBER_NETWORK_ADDRESS);
1001     }
1002 }
1003 
1004 contract KyberNetwork {
1005 
1006     function getExpectedRate(
1007         ERC20 src,
1008         ERC20 dest,
1009         uint srcQty
1010     )
1011         public
1012         view
1013         returns (uint expectedRate, uint slippageRate);
1014 
1015     function trade(
1016         ERC20 src,
1017         uint srcAmount,
1018         ERC20 dest,
1019         address destAddress,
1020         uint maxDestAmount,
1021         uint minConversionRate,
1022         address walletId
1023     )
1024         public
1025         payable
1026         returns(uint);
1027 }
1028 
1029 /**
1030  * @title Storage
1031  * @dev Base contract for the storage of a wallet.
1032  * @author Julien Niset - <julien@argent.xyz>
1033  */
1034 contract Storage {
1035 
1036     /**
1037      * @dev Throws if the caller is not an authorised module.
1038      */
1039     modifier onlyModule(BaseWallet _wallet) {
1040         require(_wallet.authorised(msg.sender), "TS: must be an authorized module to call this method");
1041         _;
1042     }
1043 }
1044 
1045 /**
1046  * @title GuardianStorage
1047  * @dev Contract storing the state of wallets related to guardians and lock.
1048  * The contract only defines basic setters and getters with no logic. Only modules authorised
1049  * for a wallet can modify its state.
1050  * @author Julien Niset - <julien@argent.xyz>
1051  * @author Olivier Van Den Biggelaar - <olivier@argent.xyz>
1052  */
1053 contract GuardianStorage is Storage {
1054 
1055     struct GuardianStorageConfig {
1056         // the list of guardians
1057         address[] guardians;
1058         // the info about guardians
1059         mapping (address => GuardianInfo) info;
1060         // the lock's release timestamp
1061         uint256 lock; 
1062         // the module that set the last lock
1063         address locker;
1064     }
1065 
1066     struct GuardianInfo {
1067         bool exists;
1068         uint128 index;
1069     }
1070 
1071     // wallet specific storage
1072     mapping (address => GuardianStorageConfig) internal configs;
1073 
1074     // *************** External Functions ********************* //
1075 
1076     /**
1077      * @dev Lets an authorised module add a guardian to a wallet.
1078      * @param _wallet The target wallet.
1079      * @param _guardian The guardian to add.
1080      */
1081     function addGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
1082         GuardianStorageConfig storage config = configs[_wallet];
1083         config.info[_guardian].exists = true;
1084         config.info[_guardian].index = uint128(config.guardians.push(_guardian) - 1);
1085     }
1086 
1087     /**
1088      * @dev Lets an authorised module revoke a guardian from a wallet.
1089      * @param _wallet The target wallet.
1090      * @param _guardian The guardian to revoke.
1091      */
1092     function revokeGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
1093         GuardianStorageConfig storage config = configs[_wallet];
1094         address lastGuardian = config.guardians[config.guardians.length - 1];
1095         if (_guardian != lastGuardian) {
1096             uint128 targetIndex = config.info[_guardian].index;
1097             config.guardians[targetIndex] = lastGuardian;
1098             config.info[lastGuardian].index = targetIndex;
1099         }
1100         config.guardians.length--;
1101         delete config.info[_guardian];
1102     }
1103 
1104     /**
1105      * @dev Returns the number of guardians for a wallet.
1106      * @param _wallet The target wallet.
1107      * @return the number of guardians.
1108      */
1109     function guardianCount(BaseWallet _wallet) external view returns (uint256) {
1110         return configs[_wallet].guardians.length;
1111     }
1112     
1113     /**
1114      * @dev Gets the list of guaridans for a wallet.
1115      * @param _wallet The target wallet.
1116      * @return the list of guardians.
1117      */
1118     function getGuardians(BaseWallet _wallet) external view returns (address[]) {
1119         GuardianStorageConfig storage config = configs[_wallet];
1120         address[] memory guardians = new address[](config.guardians.length);
1121         for (uint256 i = 0; i < config.guardians.length; i++) {
1122             guardians[i] = config.guardians[i];
1123         }
1124         return guardians;
1125     }
1126 
1127     /**
1128      * @dev Checks if an account is a guardian for a wallet.
1129      * @param _wallet The target wallet.
1130      * @param _guardian The account.
1131      * @return true if the account is a guardian for a wallet.
1132      */
1133     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool) {
1134         return configs[_wallet].info[_guardian].exists;
1135     }
1136 
1137     /**
1138      * @dev Lets an authorised module set the lock for a wallet.
1139      * @param _wallet The target wallet.
1140      * @param _releaseAfter The epoch time at which the lock should automatically release.
1141      */
1142     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external onlyModule(_wallet) {
1143         configs[_wallet].lock = _releaseAfter;
1144         if(_releaseAfter != 0 && msg.sender != configs[_wallet].locker) {
1145             configs[_wallet].locker = msg.sender;
1146         }
1147     }
1148 
1149     /**
1150      * @dev Checks if the lock is set for a wallet.
1151      * @param _wallet The target wallet.
1152      * @return true if the lock is set for the wallet.
1153      */
1154     function isLocked(BaseWallet _wallet) external view returns (bool) {
1155         return configs[_wallet].lock > now;
1156     }
1157 
1158     /**
1159      * @dev Gets the time at which the lock of a wallet will release.
1160      * @param _wallet The target wallet.
1161      * @return the time at which the lock of a wallet will release, or zero if there is no lock set.
1162      */
1163     function getLock(BaseWallet _wallet) external view returns (uint256) {
1164         return configs[_wallet].lock;
1165     }
1166 
1167     /**
1168      * @dev Gets the address of the last module that modified the lock for a wallet.
1169      * @param _wallet The target wallet.
1170      * @return the address of the last module that modified the lock for a wallet.
1171      */
1172     function getLocker(BaseWallet _wallet) external view returns (address) {
1173         return configs[_wallet].locker;
1174     }
1175 }
1176 
1177 /**
1178  * @title TransferStorage
1179  * @dev Contract storing the state of wallets related to transfers (limit and whitelist).
1180  * The contract only defines basic setters and getters with no logic. Only modules authorised
1181  * for a wallet can modify its state.
1182  * @author Julien Niset - <julien@argent.xyz>
1183  */
1184 contract TransferStorage is Storage {
1185 
1186     // wallet specific storage
1187     mapping (address => mapping (address => uint256)) internal whitelist;
1188 
1189     // *************** External Functions ********************* //
1190 
1191     /**
1192      * @dev Lets an authorised module add or remove an account from the whitelist of a wallet.
1193      * @param _wallet The target wallet.
1194      * @param _target The account to add/remove.
1195      * @param _value True for addition, false for revokation.
1196      */
1197     function setWhitelist(BaseWallet _wallet, address _target, uint256 _value) external onlyModule(_wallet) {
1198         whitelist[_wallet][_target] = _value;
1199     }
1200 
1201     /**
1202      * @dev Gets the whitelist state of an account for a wallet.
1203      * @param _wallet The target wallet.
1204      * @param _target The account.
1205      * @return the epoch time at which an account strats to be whitelisted, or zero if the account is not whitelisted.
1206      */
1207     function getWhitelist(BaseWallet _wallet, address _target) external view returns (uint256) {
1208         return whitelist[_wallet][_target];
1209     }
1210 }
1211 
1212 /**
1213  * @title TokenTransfer
1214  * @dev Module to transfer tokens (ETH or ERC20) based on a security context (daily limit, whitelist, etc).
1215  * @author Julien Niset - <julien@argent.xyz>
1216  */
1217 contract TokenTransfer is BaseModule, RelayerModule, LimitManager {
1218 
1219     bytes32 constant NAME = "TokenTransfer";
1220 
1221     bytes4 constant internal EXECUTE_PENDING_PREFIX = bytes4(keccak256("executePendingTransfer(address,address,address,uint256,bytes,uint256)"));
1222 
1223     bytes constant internal EMPTY_BYTES = "";
1224 
1225     using SafeMath for uint256;
1226 
1227     // Mock token address for ETH
1228     address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1229     // large limit when the limit can be considered disabled
1230     uint128 constant internal LIMIT_DISABLED = uint128(-1); // 3.40282366920938463463374607431768211455e+38
1231 
1232     struct TokenTransferConfig {
1233         // Mapping between pending transfer hash and their timestamp
1234         mapping (bytes32 => uint256) pendingTransfers;
1235     }
1236 
1237     // wallet specific storage
1238     mapping (address => TokenTransferConfig) internal configs;
1239 
1240     // The security period
1241     uint256 public securityPeriod;
1242     // The execution window
1243     uint256 public securityWindow;
1244     // The Guardian storage 
1245     GuardianStorage public guardianStorage;
1246     // The Token storage
1247     TransferStorage public transferStorage;
1248     // The Token price provider
1249     TokenPriceProvider public priceProvider;
1250 
1251     // *************** Events *************************** //
1252 
1253     event Transfer(address indexed wallet, address indexed token, uint256 indexed amount, address to, bytes data);    
1254     event AddedToWhitelist(address indexed wallet, address indexed target, uint64 whitelistAfter);
1255     event RemovedFromWhitelist(address indexed wallet, address indexed target);
1256     event PendingTransferCreated(address indexed wallet, bytes32 indexed id, uint256 indexed executeAfter, address token, address to, uint256 amount, bytes data);
1257     event PendingTransferExecuted(address indexed wallet, bytes32 indexed id);
1258     event PendingTransferCanceled(address indexed wallet, bytes32 indexed id);
1259 
1260     // *************** Modifiers *************************** //
1261 
1262     /**
1263      * @dev Throws if the caller is not the owner or an authorised module.
1264      */
1265     modifier onlyOwnerOrModule(BaseWallet _wallet) {
1266         require(isOwner(_wallet, msg.sender) || _wallet.authorised(msg.sender), "TT: must be wallet owner or module");
1267         _;
1268     }
1269 
1270     /**
1271      * @dev Throws if the wallet is locked.
1272      */
1273     modifier onlyWhenUnlocked(BaseWallet _wallet) {
1274         // solium-disable-next-line security/no-block-members
1275         require(!guardianStorage.isLocked(_wallet), "TT: wallet must be unlocked");
1276         _;
1277     }
1278 
1279     // *************** Constructor ********************** //
1280 
1281     constructor(
1282         ModuleRegistry _registry,
1283         TransferStorage _transferStorage, 
1284         GuardianStorage _guardianStorage, 
1285         address _priceProvider,
1286         uint256 _securityPeriod,
1287         uint256 _securityWindow, 
1288         uint256 _defaultLimit
1289     ) 
1290         BaseModule(_registry, NAME)
1291         LimitManager(_defaultLimit)
1292         public 
1293     {
1294         transferStorage = _transferStorage;
1295         guardianStorage = _guardianStorage;
1296         priceProvider = TokenPriceProvider(_priceProvider);
1297         securityPeriod = _securityPeriod;
1298         securityWindow = _securityWindow;
1299     }
1300 
1301     // *************** External/Public Functions ********************* //
1302 
1303     /**
1304     * @dev lets the owner transfer tokens (ETH or ERC20) from a wallet.
1305     * @param _wallet The target wallet.
1306     * @param _token The address of the token to transfer.
1307     * @param _to The destination address
1308     * @param _amount The amoutn of token to transfer
1309     * @param _data The data for the transaction
1310     */
1311     function transferToken(
1312         BaseWallet _wallet, 
1313         address _token, 
1314         address _to, 
1315         uint256 _amount, 
1316         bytes _data
1317     ) 
1318         external 
1319         onlyOwnerOrModule(_wallet) 
1320         onlyWhenUnlocked(_wallet)
1321     {
1322         if(isWhitelisted(_wallet, _to)) {
1323             // eth transfer to whitelist
1324             if(_token == ETH_TOKEN) {
1325                 transferETH(_wallet, _to, _amount, _data);
1326             }
1327             // erc20 transfer to whitelist
1328             else {
1329                 transferERC20(_wallet, _token, _to, _amount, _data);
1330             }
1331         }
1332         else {
1333             if(_token == ETH_TOKEN) {
1334                 // eth transfer under the limit
1335                 if (checkAndUpdateDailySpent(_wallet, _amount)) {
1336                     transferETH(_wallet, _to, _amount, _data);
1337                 }
1338                 // eth transfer above the limit
1339                 else {
1340                     addPendingTransfer(_wallet, ETH_TOKEN, _to, _amount, _data); 
1341                 }
1342             }
1343             else {
1344                 uint256 etherAmount = priceProvider.getEtherValue(_amount, _token);
1345                 // erc20 transfer under the limit
1346                 if (checkAndUpdateDailySpent(_wallet, etherAmount)) {
1347                     transferERC20(_wallet, _token, _to, _amount, _data);
1348                 }
1349                 // erc20 transfer above the limit
1350                 else {
1351                     addPendingTransfer(_wallet, _token, _to, _amount, _data); 
1352                 }
1353             }
1354         }
1355     }
1356 
1357     /**
1358      * @dev Adds an address to the whitelist of a wallet. 
1359      * @param _wallet The target wallet.
1360      * @param _target The address to add.
1361      */
1362     function addToWhitelist(
1363         BaseWallet _wallet, 
1364         address _target
1365     ) 
1366         external 
1367         onlyOwner(_wallet) 
1368         onlyWhenUnlocked(_wallet)
1369     {
1370         require(!isWhitelisted(_wallet, _target), "TT: target already whitelisted");
1371         // solium-disable-next-line security/no-block-members
1372         uint256 whitelistAfter = now.add(securityPeriod);
1373         transferStorage.setWhitelist(_wallet, _target, whitelistAfter);
1374         emit AddedToWhitelist(_wallet, _target, uint64(whitelistAfter));
1375     }
1376 
1377     /**
1378      * @dev Removes an address from the whitelist of a wallet. 
1379      * @param _wallet The target wallet.
1380      * @param _target The address to remove.
1381      */
1382     function removeFromWhitelist(
1383         BaseWallet _wallet, 
1384         address _target
1385     ) 
1386         external 
1387         onlyOwner(_wallet) 
1388         onlyWhenUnlocked(_wallet)
1389     {
1390         require(isWhitelisted(_wallet, _target), "TT: target not whitelisted");
1391         transferStorage.setWhitelist(_wallet, _target, 0);
1392         emit RemovedFromWhitelist(_wallet, _target);
1393     }
1394 
1395     /**
1396     * @dev Executes a pending transfer for a wallet. 
1397     * The destination address is automatically added to the whitelist.
1398     * The method can be called by anyone to enable orchestration.
1399     * @param _wallet The target wallet.
1400     * @param _token The token of the pending transfer. 
1401     * @param _to The destination address of the pending transfer.
1402     * @param _amount The amount of token to transfer of the pending transfer.
1403     * @param _block The block at which the pending transfer was created.
1404     */
1405     function executePendingTransfer(
1406         BaseWallet _wallet,
1407         address _token, 
1408         address _to, 
1409         uint _amount, 
1410         bytes _data,
1411         uint _block 
1412     ) 
1413         public 
1414         onlyWhenUnlocked(_wallet)
1415     {
1416         bytes32 id = keccak256(abi.encodePacked(_token, _to, _amount, _data, _block));
1417         uint executeAfter = configs[_wallet].pendingTransfers[id];
1418         uint executeBefore = executeAfter.add(securityWindow);
1419         require(executeAfter <= now && now <= executeBefore, "TT: outside of the execution window");
1420         removePendingTransfer(_wallet, id);
1421         if(_token == ETH_TOKEN) {
1422             transferETH(_wallet, _to, _amount, _data);
1423         }
1424         else {
1425             transferERC20(_wallet, _token, _to, _amount, _data);
1426         }
1427         emit PendingTransferExecuted(_wallet, id);
1428     }
1429 
1430     /**
1431     * @dev Cancels a pending transfer for a wallet. 
1432     * @param _wallet The target wallet.
1433     * @param _id the pending transfer Id. 
1434     */
1435     function cancelPendingTransfer(
1436         BaseWallet _wallet, 
1437         bytes32 _id
1438     ) 
1439         public 
1440         onlyOwner(_wallet) 
1441         onlyWhenUnlocked(_wallet) 
1442     {
1443         require(configs[_wallet].pendingTransfers[_id] > 0, "TT: unknown pending transfer");
1444         removePendingTransfer(_wallet, _id);
1445         emit PendingTransferCanceled(_wallet, _id);
1446     }
1447 
1448     /**
1449      * @dev Lets the owner of a wallet change its global limit. 
1450      * The limit is expressed in ETH. Changes to the limit take 24 hours.
1451      * @param _wallet The target wallet.
1452      * @param _newLimit The new limit.
1453      */
1454     function changeLimit(BaseWallet _wallet, uint256 _newLimit) public onlyOwner(_wallet) onlyWhenUnlocked(_wallet) {
1455         changeLimit(_wallet, _newLimit, securityPeriod);
1456     }
1457 
1458     /**
1459      * @dev Convenience method to disable the limit
1460      * The limit is disabled by setting it to an arbitrary large value.
1461      * @param _wallet The target wallet.
1462      */
1463     function disableLimit(BaseWallet _wallet) external onlyOwner(_wallet) onlyWhenUnlocked(_wallet) {
1464         changeLimit(_wallet, LIMIT_DISABLED, securityPeriod);
1465     }
1466 
1467     /**
1468     * @dev Checks if an address is whitelisted for a wallet.
1469     * @param _wallet The target wallet.
1470     * @param _target The address. 
1471     * @return true if the address is whitelisted.
1472     */
1473     function isWhitelisted(BaseWallet _wallet, address _target) public view returns (bool _isWhitelisted) {
1474         uint whitelistAfter = transferStorage.getWhitelist(_wallet, _target);
1475         // solium-disable-next-line security/no-block-members
1476         return whitelistAfter > 0 && whitelistAfter < now;
1477     }
1478 
1479     /**
1480     * @dev Gets the info of a pending transfer for a wallet.
1481     * @param _wallet The target wallet.
1482     * @param _id The pending transfer Id.
1483     * @return the epoch time at which the pending transfer can be executed.
1484     */
1485     function getPendingTransfer(BaseWallet _wallet, bytes32 _id) external view returns (uint64 _executeAfter) {
1486         _executeAfter = uint64(configs[_wallet].pendingTransfers[_id]);
1487     }
1488 
1489     // *************** Internal Functions ********************* //
1490 
1491     /**
1492     * @dev Helper method to transfer ETH for a wallet.
1493     * @param _wallet The target wallet.
1494     * @param _to The recipient.
1495     * @param _value The amount of ETH to transfer
1496     * @param _data The data to *log* with the transfer.
1497     */
1498     function transferETH(BaseWallet _wallet, address _to, uint256 _value, bytes _data) internal {
1499         _wallet.invoke(_to, _value, EMPTY_BYTES);
1500         emit Transfer(_wallet, ETH_TOKEN, _value, _to, _data);
1501     }
1502 
1503     /**
1504     * @dev Helper method to transfer ERC20 for a wallet.
1505     * @param _wallet The target wallet.
1506     * @param _token The ERC20 address.
1507     * @param _to The recipient.
1508     * @param _value The amount of token to transfer
1509     * @param _data The data to pass with the trnasfer.
1510     */
1511     function transferERC20(BaseWallet _wallet, address _token, address _to, uint256 _value, bytes _data) internal {
1512         bytes memory methodData = abi.encodeWithSignature("transfer(address,uint256)", _to, _value);
1513         _wallet.invoke(_token, 0, methodData);
1514         emit Transfer(_wallet, _token, _value, _to, _data);
1515     }
1516 
1517     /**
1518      * @dev Creates a new pending transfer for a wallet.
1519      * @param _wallet The target wallet.
1520      * @param _token The token for the transfer.
1521      * @param _to The recipient for the transfer.
1522      * @param _amount The amount of token to transfer.
1523      * @param _data The data associated to the transfer.
1524      * @return the identifier for the new pending transfer.
1525      */
1526     function addPendingTransfer(BaseWallet _wallet, address _token, address _to, uint _amount, bytes _data) internal returns (bytes32) {
1527         bytes32 id = keccak256(abi.encodePacked(_token, _to, _amount, _data, block.number));
1528         uint executeAfter = now.add(securityPeriod);
1529         configs[_wallet].pendingTransfers[id] = executeAfter;
1530         emit PendingTransferCreated(_wallet, id, executeAfter, _token, _to, _amount, _data);
1531     }
1532 
1533     /**
1534     * @dev Removes an existing pending transfer.
1535     * @param _wallet The target wallet
1536     * @param _id The id of the transfer to remove.
1537     */
1538     function removePendingTransfer(BaseWallet _wallet, bytes32 _id) internal {
1539         delete configs[_wallet].pendingTransfers[_id];
1540     }
1541 
1542     // *************** Implementation of RelayerModule methods ********************* //
1543 
1544     // Overrides refund to add the refund in the daily limit.
1545     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
1546         // 21000 (transaction) + 7620 (execution of refund) + 7324 (execution of updateDailySpent) + 672 to log the event + _gasUsed
1547         uint256 amount = 36616 + _gasUsed; 
1548         if(_gasPrice > 0 && _signatures > 0 && amount <= _gasLimit) {
1549             if(_gasPrice > tx.gasprice) {
1550                 amount = amount * tx.gasprice;
1551             }
1552             else {
1553                 amount = amount * _gasPrice;
1554             }
1555             updateDailySpent(_wallet, uint128(getCurrentLimit(_wallet)), amount);
1556             _wallet.invoke(_relayer, amount, "");
1557         }
1558     }
1559 
1560     // Overrides verifyRefund to add the refund in the daily limit.
1561     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
1562         if(_gasPrice > 0 && _signatures > 0 && (
1563             address(_wallet).balance < _gasUsed * _gasPrice 
1564             || isWithinDailyLimit(_wallet, getCurrentLimit(_wallet), _gasUsed * _gasPrice) == false
1565             || _wallet.authorised(this) == false
1566         ))
1567         {
1568             return false;
1569         }
1570         return true;
1571     }
1572 
1573     // Overrides to use the incremental nonce and save some gas
1574     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
1575         return checkAndUpdateNonce(_wallet, _nonce);
1576     }
1577 
1578     function validateSignatures(BaseWallet _wallet, bytes _data, bytes32 _signHash, bytes _signatures) internal view returns (bool) {
1579         address signer = recoverSigner(_signHash, _signatures, 0);
1580         return isOwner(_wallet, signer); // "TT: signer must be owner"
1581     }
1582 
1583     function getRequiredSignatures(BaseWallet _wallet, bytes _data) internal view returns (uint256) {
1584         bytes4 methodId = functionPrefix(_data);
1585         if (methodId == EXECUTE_PENDING_PREFIX) {
1586             return 0;
1587         }
1588         return 1;
1589     }
1590 }