1 /**
2  *Submitted for verification at Etherscan.io on 2020-04-02
3 */
4 
5 // Sources flattened with buidler v1.2.0 https://buidler.dev
6 
7 // File @pie-dao/proxy/contracts/PProxyStorage.sol@v0.0.6
8 
9 pragma solidity ^0.6.2;
10 
11 contract PProxyStorage {
12 
13     function readString(bytes32 _key) public view returns(string memory) {
14         return bytes32ToString(storageRead(_key));
15     }
16 
17     function setString(bytes32 _key, string memory _value) internal {
18         storageSet(_key, stringToBytes32(_value));
19     }
20 
21     function readBool(bytes32 _key) public view returns(bool) {
22         return storageRead(_key) == bytes32(uint256(1));
23     }
24 
25     function setBool(bytes32 _key, bool _value) internal {
26         if(_value) {
27             storageSet(_key, bytes32(uint256(1)));
28         } else {
29             storageSet(_key, bytes32(uint256(0)));
30         }
31     }
32 
33     function readAddress(bytes32 _key) public view returns(address) {
34         return bytes32ToAddress(storageRead(_key));
35     }
36 
37     function setAddress(bytes32 _key, address _value) internal {
38         storageSet(_key, addressToBytes32(_value));
39     }
40 
41     function storageRead(bytes32 _key) public view returns(bytes32) {
42         bytes32 value;
43         //solium-disable-next-line security/no-inline-assembly
44         assembly {
45             value := sload(_key)
46         }
47         return value;
48     }
49 
50     function storageSet(bytes32 _key, bytes32 _value) internal {
51         // targetAddress = _address;  // No!
52         bytes32 implAddressStorageKey = _key;
53         //solium-disable-next-line security/no-inline-assembly
54         assembly {
55             sstore(implAddressStorageKey, _value)
56         }
57     }
58 
59     function bytes32ToAddress(bytes32 _value) public pure returns(address) {
60         return address(uint160(uint256(_value)));
61     }
62 
63     function addressToBytes32(address _value) public pure returns(bytes32) {
64         return bytes32(uint256(_value));
65     }
66 
67     function stringToBytes32(string memory _value) public pure returns (bytes32 result) {
68         bytes memory tempEmptyStringTest = bytes(_value);
69         if (tempEmptyStringTest.length == 0) {
70             return 0x0;
71         }
72 
73         assembly {
74             result := mload(add(_value, 32))
75         }
76     }
77 
78     function bytes32ToString(bytes32 _value) public pure returns (string memory) {
79         bytes memory bytesString = new bytes(32);
80         uint charCount = 0;
81         for (uint256 j = 0; j < 32; j++) {
82             byte char = byte(bytes32(uint(_value) * 2 ** (8 * j)));
83             if (char != 0) {
84                 bytesString[charCount] = char;
85                 charCount++;
86             }
87         }
88         bytes memory bytesStringTrimmed = new bytes(charCount);
89         for (uint256 j = 0; j < charCount; j++) {
90             bytesStringTrimmed[j] = bytesString[j];
91         }
92         return string(bytesStringTrimmed);
93     }
94 }
95 
96 
97 // File @pie-dao/proxy/contracts/PProxy.sol@v0.0.6
98 
99 pragma solidity ^0.6.2;
100 
101 
102 contract PProxy is PProxyStorage {
103 
104     bytes32 constant IMPLEMENTATION_SLOT = keccak256(abi.encodePacked("IMPLEMENTATION_SLOT"));
105     bytes32 constant OWNER_SLOT = keccak256(abi.encodePacked("OWNER_SLOT"));
106 
107     modifier onlyProxyOwner() {
108         require(msg.sender == readAddress(OWNER_SLOT), "PProxy.onlyProxyOwner: msg sender not owner");
109         _;
110     }
111 
112     constructor () public {
113         setAddress(OWNER_SLOT, msg.sender);
114     }
115 
116     function getProxyOwner() public view returns (address) {
117        return readAddress(OWNER_SLOT);
118     }
119 
120     function setProxyOwner(address _newOwner) onlyProxyOwner public {
121         setAddress(OWNER_SLOT, _newOwner);
122     }
123 
124     function getImplementation() public view returns (address) {
125         return readAddress(IMPLEMENTATION_SLOT);
126     }
127 
128     function setImplementation(address _newImplementation) onlyProxyOwner public {
129         setAddress(IMPLEMENTATION_SLOT, _newImplementation);
130     }
131 
132 
133     fallback () external payable {
134        return internalFallback();
135     }
136 
137     function internalFallback() internal virtual {
138         address contractAddr = readAddress(IMPLEMENTATION_SLOT);
139         assembly {
140             let ptr := mload(0x40)
141             calldatacopy(ptr, 0, calldatasize())
142             let result := delegatecall(gas(), contractAddr, ptr, calldatasize(), 0, 0)
143             let size := returndatasize()
144             returndatacopy(ptr, 0, size)
145 
146             switch result
147             case 0 { revert(ptr, size) }
148             default { return(ptr, size) }
149         }
150     }
151 
152 }
153 
154 
155 // File @pie-dao/proxy/contracts/PProxyPausable.sol@v0.0.6
156 
157 pragma solidity ^0.6.2;
158 
159 
160 contract PProxyPausable is PProxy {
161 
162     bytes32 constant PAUSED_SLOT = keccak256(abi.encodePacked("PAUSED_SLOT"));
163     bytes32 constant PAUZER_SLOT = keccak256(abi.encodePacked("PAUZER_SLOT"));
164 
165     constructor() PProxy() public {
166         setAddress(PAUZER_SLOT, msg.sender);
167     }
168 
169     modifier onlyPauzer() {
170         require(msg.sender == readAddress(PAUZER_SLOT), "PProxyPausable.onlyPauzer: msg sender not pauzer");
171         _;
172     }
173 
174     modifier notPaused() {
175         require(!readBool(PAUSED_SLOT), "PProxyPausable.notPaused: contract is paused");
176         _;
177     }
178 
179     function getPauzer() public view returns (address) {
180         return readAddress(PAUZER_SLOT);
181     }
182 
183     function setPauzer(address _newPauzer) public onlyProxyOwner{
184         setAddress(PAUZER_SLOT, _newPauzer);
185     }
186 
187     function renouncePauzer() public onlyPauzer {
188         setAddress(PAUZER_SLOT, address(0));
189     }
190 
191     function getPaused() public view returns (bool) {
192         return readBool(PAUSED_SLOT);
193     }
194 
195     function setPaused(bool _value) public onlyPauzer {
196         setBool(PAUSED_SLOT, _value);
197     }
198 
199     function internalFallback() internal virtual override notPaused {
200         super.internalFallback();
201     }
202 
203 }
204 
205 
206 // File contracts/interfaces/IBFactory.sol
207 
208 pragma solidity ^0.6.4;
209 
210 interface IBFactory {
211     function newBPool() external returns (address);
212 }
213 
214 
215 // File contracts/interfaces/IBPool.sol
216 
217 // This program is free software: you can redistribute it and/or modify
218 // it under the terms of the GNU General Public License as published by
219 // the Free Software Foundation, either version 3 of the License, or
220 // (at your option) any later version.
221 
222 // This program is disstributed in the hope that it will be useful,
223 // but WITHOUT ANY WARRANTY; without even the implied warranty of
224 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
225 // GNU General Public License for more details.
226 
227 // You should have received a copy of the GNU General Public License
228 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
229 
230 pragma solidity 0.6.4;
231 
232 interface IBPool {
233     function isBound(address token) external view returns(bool);
234     function getBalance(address token) external view returns (uint);
235     function rebind(address token, uint balance, uint denorm) external;
236     function setSwapFee(uint swapFee) external;
237     function setPublicSwap(bool _public) external;
238     function bind(address token, uint balance, uint denorm) external;
239     function unbind(address token) external;
240     function getDenormalizedWeight(address token) external view returns (uint);
241     function getTotalDenormalizedWeight() external view returns (uint);
242     function getCurrentTokens() external view returns(address[] memory);
243     function setController(address manager) external;
244     function isPublicSwap() external view returns(bool);
245     function getSwapFee() external view returns (uint256);
246     function gulp(address token) external;
247 
248     function calcPoolOutGivenSingleIn(
249         uint tokenBalanceIn,
250         uint tokenWeightIn,
251         uint poolSupply,
252         uint totalWeight,
253         uint tokenAmountIn,
254         uint swapFee
255     )
256         external pure
257         returns (uint poolAmountOut);
258 
259     function calcSingleInGivenPoolOut(
260         uint tokenBalanceIn,
261         uint tokenWeightIn,
262         uint poolSupply,
263         uint totalWeight,
264         uint poolAmountOut,
265         uint swapFee
266     )
267         external pure
268         returns (uint tokenAmountIn);
269 
270     function calcSingleOutGivenPoolIn(
271         uint tokenBalanceOut,
272         uint tokenWeightOut,
273         uint poolSupply,
274         uint totalWeight,
275         uint poolAmountIn,
276         uint swapFee
277     )
278         external pure
279         returns (uint tokenAmountOut);
280 
281     function calcPoolInGivenSingleOut(
282         uint tokenBalanceOut,
283         uint tokenWeightOut,
284         uint poolSupply,
285         uint totalWeight,
286         uint tokenAmountOut,
287         uint swapFee
288     )
289         external pure
290         returns (uint poolAmountIn);
291 }
292 
293 
294 // File contracts/interfaces/IERC20.sol
295 
296 pragma solidity ^0.6.4;
297 
298 interface IERC20 {
299     event Approval(address indexed _src, address indexed _dst, uint _amount);
300     event Transfer(address indexed _src, address indexed _dst, uint _amount);
301 
302     function totalSupply() external view returns (uint);
303     function balanceOf(address _whom) external view returns (uint);
304     function allowance(address _src, address _dst) external view returns (uint);
305 
306     function approve(address _dst, uint _amount) external returns (bool);
307     function transfer(address _dst, uint _amount) external returns (bool);
308     function transferFrom(
309         address _src, address _dst, uint _amount
310     ) external returns (bool);
311 }
312 
313 
314 // File contracts/Ownable.sol
315 
316 pragma solidity ^0.6.4;
317 
318 // TODO move this generic contract to a seperate repo with all generic smart contracts
319 
320 contract Ownable {
321 
322     bytes32 constant public oSlot = keccak256("Ownable.storage.location");
323 
324     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
325 
326     // Ownable struct
327     struct os {
328         address owner;
329     }
330 
331     modifier onlyOwner(){
332         require(msg.sender == los().owner, "Ownable.onlyOwner: msg.sender not owner");
333         _;
334     }
335 
336     /**
337         @notice Transfer ownership to a new address
338         @param _newOwner Address of the new owner
339     */
340     function transferOwnership(address _newOwner) onlyOwner external {
341         _setOwner(_newOwner);
342     }
343 
344     /**
345         @notice Internal method to set the owner
346         @param _newOwner Address of the new owner
347     */
348     function _setOwner(address _newOwner) internal {
349         emit OwnerChanged(los().owner, _newOwner);
350         los().owner = _newOwner;
351     }
352 
353     /**
354         @notice Load ownable storage
355         @return s Storage pointer to the Ownable storage struct
356     */
357     function los() internal pure returns (os storage s) {
358         bytes32 loc = oSlot;
359         assembly {
360             s_slot := loc
361         }
362     }
363 
364 }
365 
366 
367 // File contracts/interfaces/IPSmartPool.sol
368 
369 pragma solidity ^0.6.4;
370 
371 interface IPSmartPool is IERC20 {
372     function joinPool(uint256 _amount) external;
373     function exitPool(uint256 _amount) external;
374     function getController() external view returns(address);
375     function getTokens() external view returns(address[] memory);
376     function calcTokensForAmount(uint256 _amount) external view  returns(address[] memory tokens, uint256[] memory amounts);
377 }
378 
379 
380 // File contracts/PCTokenStorage.sol
381 
382 pragma solidity ^0.6.4;
383 
384 contract PCTokenStorage {
385 
386     bytes32 constant public ptSlot = keccak256("PCToken.storage.location");
387     struct pts {
388         string name;
389         string symbol;
390         uint256 totalSupply;
391         mapping(address => uint256) balance;
392         mapping(address => mapping(address=>uint256)) allowance;
393     }
394 
395     /**
396         @notice Load pool token storage
397         @return s Storage pointer to the pool token struct
398     */
399     function lpts() internal pure returns (pts storage s) {
400         bytes32 loc = ptSlot;
401         assembly {
402             s_slot := loc
403         }
404     }
405 
406 }
407 
408 
409 // File contracts/PCToken.sol
410 
411 // This program is free software: you can redistribute it and/or modify
412 // it under the terms of the GNU General Public License as published by
413 // the Free Software Foundation, either version 3 of the License, or
414 // (at your option) any later version.
415 
416 // This program is distributed in the hope that it will be useful,
417 // but WITHOUT ANY WARRANTY; without even the implied warranty of
418 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
419 // GNU General Public License for more details.
420 
421 // You should have received a copy of the GNU General Public License
422 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
423 
424 pragma solidity ^0.6.4;
425 
426 
427 
428 // Highly opinionated token implementation
429 // Based on the balancer Implementation
430 
431 
432 contract PCToken is IERC20, PCTokenStorage {
433 
434     event Approval(address indexed _src, address indexed _dst, uint _amount);
435     event Transfer(address indexed _src, address indexed _dst, uint _amount);
436 
437     uint8 public constant decimals = 18;
438     uint public constant BONE              = 10**18;
439     uint public constant MAX_BOUND_TOKENS  = 8;
440     uint public constant MIN_WEIGHT        = BONE;
441     uint public constant MAX_WEIGHT        = BONE * 50;
442     uint public constant MAX_TOTAL_WEIGHT  = BONE * 50;
443     uint public constant MIN_BALANCE       = BONE / 10**6;
444     uint public constant MAX_BALANCE       = BONE * 10**12;
445 
446     uint public constant MIN_POOL_SUPPLY   = BONE;
447 
448     function badd(uint a, uint b)
449         internal pure
450         returns (uint)
451     {
452         uint c = a + b;
453         require(c >= a, "ERR_ADD_OVERFLOW");
454         return c;
455     }
456 
457     function bsub(uint a, uint b)
458         internal pure
459         returns (uint)
460     {
461         (uint c, bool flag) = bsubSign(a, b);
462         require(!flag, "ERR_SUB_UNDERFLOW");
463         return c;
464     }
465 
466     function bsubSign(uint a, uint b)
467         internal pure
468         returns (uint, bool)
469     {
470         if (a >= b) {
471             return (a - b, false);
472         } else {
473             return (b - a, true);
474         }
475     }
476 
477     function bmul(uint a, uint b)
478         internal pure
479         returns (uint)
480     {
481         uint c0 = a * b;
482         require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
483         uint c1 = c0 + (BONE / 2);
484         require(c1 >= c0, "ERR_MUL_OVERFLOW");
485         uint c2 = c1 / BONE;
486         return c2;
487     }
488 
489     function bdiv(uint a, uint b)
490         internal pure
491         returns (uint)
492     {
493         require(b != 0, "ERR_DIV_ZERO");
494         uint c0 = a * BONE;
495         require(a == 0 || c0 / a == BONE, "ERR_DIV_INTERNAL"); // bmul overflow
496         uint c1 = c0 + (b / 2);
497         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
498         uint c2 = c1 / b;
499         return c2;
500     }
501 
502     function _mint(uint _amount) internal {
503         pts storage s = lpts();
504         s.balance[address(this)] = badd(s.balance[address(this)], _amount);
505         s.totalSupply = badd(s.totalSupply, _amount);
506         emit Transfer(address(0), address(this), _amount);
507     }
508 
509     function _burn(uint _amount) internal {
510         pts storage s = lpts();
511         require(s.balance[address(this)] >= _amount, "ERR_INSUFFICIENT_BAL");
512         s.balance[address(this)] = bsub(s.balance[address(this)], _amount);
513         s.totalSupply = bsub(s.totalSupply, _amount);
514         emit Transfer(address(this), address(0), _amount);
515     }
516 
517     function _move(address _src, address _dst, uint _amount) internal {
518         pts storage s = lpts();
519         require(s.balance[_src] >= _amount, "ERR_INSUFFICIENT_BAL");
520         s.balance[_src] = bsub(s.balance[_src], _amount);
521         s.balance[_dst] = badd(s.balance[_dst], _amount);
522         emit Transfer(_src, _dst, _amount);
523     }
524 
525     function _push(address _to, uint _amount) internal {
526         _move(address(this), _to, _amount);
527     }
528 
529     function _pull(address _from, uint _amount) internal {
530         _move(_from, address(this), _amount);
531     }
532 
533     function allowance(address _src, address _dst) external view override returns (uint) {
534         return lpts().allowance[_src][_dst];
535     }
536 
537     function balanceOf(address _whom) external view override returns (uint) {
538         return lpts().balance[_whom];
539     }
540 
541     function totalSupply() public view override returns (uint) {
542         return lpts().totalSupply;
543     }
544 
545     function name() external view returns (string memory) {
546         return lpts().name;
547     }
548 
549     function symbol() external view returns (string memory) {
550         return lpts().symbol;
551     }
552 
553     function approve(address _dst, uint _amount) external override returns (bool) {
554         lpts().allowance[msg.sender][_dst] = _amount;
555         emit Approval(msg.sender, _dst, _amount);
556         return true;
557     }
558 
559     function increaseApproval(address _dst, uint _amount) external returns (bool) {
560         pts storage s = lpts();
561         s.allowance[msg.sender][_dst] = badd(s.allowance[msg.sender][_dst], _amount);
562         emit Approval(msg.sender, _dst, s.allowance[msg.sender][_dst]);
563         return true;
564     }
565 
566     function decreaseApproval(address _dst, uint _amount) external returns (bool) {
567         pts storage s = lpts();
568         uint oldValue = s.allowance[msg.sender][_dst];
569         if (_amount > oldValue) {
570             s.allowance[msg.sender][_dst] = 0;
571         } else {
572             s.allowance[msg.sender][_dst] = bsub(oldValue, _amount);
573         }
574         emit Approval(msg.sender, _dst, s.allowance[msg.sender][_dst]);
575         return true;
576     }
577 
578     function transfer(address _dst, uint _amount) external override returns (bool) {
579         _move(msg.sender, _dst, _amount);
580         return true;
581     }
582 
583     function transferFrom(address _src, address _dst, uint _amount) external override returns (bool) {
584         pts storage s = lpts();
585         require(msg.sender == _src || _amount <= s.allowance[_src][msg.sender], "ERR_PCTOKEN_BAD_CALLER");
586         _move(_src, _dst, _amount);
587         if (msg.sender != _src && s.allowance[_src][msg.sender] != uint256(-1)) {
588             s.allowance[_src][msg.sender] = bsub(s.allowance[_src][msg.sender], _amount);
589             emit Approval(msg.sender, _dst, s.allowance[_src][msg.sender]);
590         }
591         return true;
592     }
593 }
594 
595 
596 // File contracts/ReentryProtection.sol
597 
598 pragma solidity ^0.6.4;
599 
600 // TODO move this generic contract to a seperate repo with all generic smart contracts
601 
602 contract ReentryProtection {
603 
604     bytes32 constant public rpSlot = keccak256("ReentryProtection.storage.location");
605 
606     // reentry protection storage
607     struct rps {
608         uint256 lockCounter;
609     }
610 
611     modifier noReentry {
612         // Use counter to only write to storage once
613         lrps().lockCounter ++;
614         uint256 lockValue = lrps().lockCounter;
615         _;
616         require(lockValue == lrps().lockCounter, "ReentryProtection.noReentry: reentry detected");
617     }
618 
619     /**
620         @notice Load reentry protection storage
621         @return s Pointer to the reentry protection storage struct
622     */
623     function lrps() internal pure returns (rps storage s) {
624         bytes32 loc = rpSlot;
625         assembly {
626             s_slot := loc
627         }
628     }
629 
630 }
631 
632 
633 // File contracts/smart-pools/PBasicSmartPool.sol
634 
635 pragma solidity ^0.6.4;
636 
637 
638 
639 
640 
641 contract PBasicSmartPool is IPSmartPool, PCToken, ReentryProtection {
642     
643     // P Basic Smart Struct
644     bytes32 constant public pbsSlot = keccak256("PBasicSmartPool.storage.location");
645     struct pbs {
646         IBPool bPool;
647         address controller;
648         address publicSwapSetter;
649         address tokenBinder;
650     }
651     
652     modifier ready() {
653         require(address(lpbs().bPool) != address(0), "PBasicSmartPool.ready: not ready");
654         _;
655     }   
656 
657      event LOG_JOIN(
658         address indexed caller,
659         address indexed tokenIn,
660         uint256 tokenAmountIn
661     );
662 
663     event LOG_EXIT(
664         address indexed caller,
665         address indexed tokenOut,
666         uint256 tokenAmountOut
667     );
668 
669     event TokensApproved();
670     event ControllerChanged(address indexed previousController, address indexed newController);
671     event PublicSwapSetterChanged(address indexed previousSetter, address indexed newSetter);
672     event TokenBinderChanged(address indexed previousTokenBinder, address indexed newTokenBinder);
673     event PublicSwapSet(address indexed setter, bool indexed value);
674     event SwapFeeSet(address indexed setter, uint256 newFee);
675     event PoolJoined(address indexed from, uint256 amount);
676     event PoolExited(address indexed from, uint256 amount);
677 
678     modifier onlyController() {
679         require(msg.sender == lpbs().controller, "PBasicSmartPool.onlyController: not controller");
680         _;
681     }
682 
683     modifier onlyPublicSwapSetter() {
684         require(msg.sender == lpbs().publicSwapSetter, "PBasicSmartPool.onlyPublicSwapSetter: not public swap setter");
685         _;
686     }
687 
688     modifier onlyTokenBinder() {
689         require(msg.sender == lpbs().tokenBinder, "PBasicSmartPool.onlyTokenBinder: not token binder");
690         _;
691     }
692 
693     /**
694         @notice Initialises the contract
695         @param _bPool Address of the underlying balancer pool
696         @param _name Name for the smart pool token
697         @param _symbol Symbol for the smart pool token
698         @param _initialSupply Initial token supply to mint
699     */
700     function init(address _bPool, string calldata _name, string calldata _symbol, uint256 _initialSupply) external {
701         pbs storage s = lpbs();
702         require(address(s.bPool) == address(0), "PBasicSmartPool.init: already initialised");
703         s.bPool = IBPool(_bPool);
704         s.controller = msg.sender;
705         s.publicSwapSetter = msg.sender;
706         s.tokenBinder = msg.sender;
707         lpts().name = _name;
708         lpts().symbol = _symbol;
709         _mintPoolShare(_initialSupply);
710         _pushPoolShare(msg.sender, _initialSupply);
711     }
712 
713     /**
714         @notice Sets approval to all tokens to the underlying balancer pool
715         @dev It uses this function to save on gas in joinPool
716     */
717     function approveTokens() public {
718         IBPool bPool = lpbs().bPool;
719         address[] memory tokens = bPool.getCurrentTokens();
720         for(uint256 i = 0; i < tokens.length; i ++) {
721             IERC20(tokens[i]).approve(address(bPool), uint256(-1));
722         }
723         emit TokensApproved();
724     }
725 
726     /**
727         @notice Sets the controller address. Can only be set by the current controller
728         @param _controller Address of the new controller
729     */
730     function setController(address _controller) onlyController noReentry external {
731         emit ControllerChanged(lpbs().controller, _controller);
732         lpbs().controller = _controller;
733     }
734 
735     /**
736         @notice Sets public swap setter address. Can only be set by the controller
737         @param _newPublicSwapSetter Address of the new public swap setter
738     */
739     function setPublicSwapSetter(address _newPublicSwapSetter) onlyController external {
740         emit PublicSwapSetterChanged(lpbs().publicSwapSetter, _newPublicSwapSetter);
741         lpbs().publicSwapSetter = _newPublicSwapSetter;
742     }
743 
744     /**
745         @notice Sets the token binder address. Can only be set by the controller
746         @param _newTokenBinder Address of the new token binder
747     */
748     function setTokenBinder(address _newTokenBinder) onlyController external {
749         emit TokenBinderChanged(lpbs().tokenBinder, _newTokenBinder);
750         lpbs().tokenBinder = _newTokenBinder;
751     }
752 
753     /**
754         @notice Enables or disables public swapping on the underlying balancer pool. Can only be set by the controller
755         @param _public Public or not
756     */
757     function setPublicSwap(bool _public) onlyPublicSwapSetter external {
758         emit PublicSwapSet(msg.sender, _public);
759         lpbs().bPool.setPublicSwap(_public);
760     }
761 
762     /**
763         @notice Set the swap fee on the underlying balancer pool. Can only be called by the controller
764         @param _swapFee The new swap fee
765     */
766     function setSwapFee(uint256 _swapFee) onlyController external {
767         emit SwapFeeSet(msg.sender, _swapFee);
768         lpbs().bPool.setSwapFee(_swapFee);
769     }
770 
771     /** 
772         @notice Mints pool shares in exchange for underlying assets
773         @param _amount Amount of pool shares to mint
774     */
775     function joinPool(uint256 _amount) external override virtual ready {
776         _joinPool(_amount);
777     }
778 
779     /**
780         @notice Internal join pool function. See joinPool for more info
781         @param _amount Amount of pool shares to mint
782     */
783     function _joinPool(uint256 _amount) internal virtual ready {
784         IBPool bPool = lpbs().bPool;
785         uint poolTotal = totalSupply();
786         uint ratio = bdiv(_amount, poolTotal);
787         require(ratio != 0);
788 
789         address[] memory tokens = bPool.getCurrentTokens();
790 
791         for (uint i = 0; i < tokens.length; i++) {
792             address t = tokens[i];
793             uint bal = bPool.getBalance(t);
794             uint tokenAmountIn = bmul(ratio, bal);
795             emit LOG_JOIN(msg.sender, t, tokenAmountIn);
796             _pullUnderlying(t, msg.sender, tokenAmountIn, bal);
797         }
798         _mintPoolShare(_amount);
799         _pushPoolShare(msg.sender, _amount);
800         emit PoolJoined(msg.sender, _amount);
801     }
802 
803     /** 
804         @notice Burns pool shares and sends back the underlying assets
805         @param _amount Amount of pool tokens to burn
806     */
807     function exitPool(uint256 _amount) external override ready noReentry {
808         IBPool bPool = lpbs().bPool;
809         uint poolTotal = totalSupply();
810         uint ratio = bdiv(_amount, poolTotal);
811         require(ratio != 0);
812 
813         _pullPoolShare(msg.sender, _amount);
814         _burnPoolShare(_amount);
815 
816         address[] memory tokens = bPool.getCurrentTokens();
817 
818         for (uint i = 0; i < tokens.length; i++) {
819             address t = tokens[i];
820             uint bal = bPool.getBalance(t);
821             uint tAo = bmul(ratio, bal);
822             emit LOG_EXIT(msg.sender, t, tAo);  
823             _pushUnderlying(t, msg.sender, tAo, bal);
824         }
825         emit PoolExited(msg.sender, _amount);
826     }
827 
828     /**
829         @notice Bind a token to the underlying balancer pool. Can only be called by the token binder
830         @param _token Token to bind
831         @param _balance Amount to bind
832         @param _denorm Denormalised weight
833     */
834     function bind(address _token, uint256 _balance, uint256 _denorm) external onlyTokenBinder {
835         IBPool bPool = lpbs().bPool;
836         IERC20 token = IERC20(_token);
837         token.transferFrom(msg.sender, address(this), _balance);
838         token.approve(address(bPool), uint256(-1));
839         bPool.bind(_token, _balance, _denorm);
840     }
841 
842     /**
843         @notice Rebind a token to the pool
844         @param _token Token to bind
845         @param _balance Amount to bind
846         @param _denorm Denormalised weight
847     */
848     function rebind(address _token, uint256 _balance, uint256 _denorm) external onlyTokenBinder {
849         IBPool bPool = lpbs().bPool;
850         IERC20 token = IERC20(_token);
851         
852         // gulp old non acounted for token balance in the contract
853         bPool.gulp(_token);
854 
855         uint256 oldBalance = token.balanceOf(address(bPool));
856         // If tokens need to be pulled from msg.sender
857         if(_balance > oldBalance) {
858             token.transferFrom(msg.sender, address(this), bsub(_balance, oldBalance));
859             token.approve(address(bPool), uint256(-1));
860         }
861 
862         bPool.rebind(_token, _balance, _denorm);
863 
864         // If any tokens are in this contract send them to msg.sender
865         uint256 tokenBalance = token.balanceOf(address(this));
866         if(tokenBalance > 0) {
867             token.transfer(msg.sender, tokenBalance);
868         }
869     }
870 
871     /**
872         @notice Unbind a token
873         @param _token Token to unbind
874     */
875     function unbind(address _token) external onlyTokenBinder {
876         IBPool bPool = lpbs().bPool;
877         IERC20 token = IERC20(_token);
878         // unbind the token in the bPool
879         bPool.unbind(_token);
880 
881         // If any tokens are in this contract send them to msg.sender
882         uint256 tokenBalance = token.balanceOf(address(this));
883         if(tokenBalance > 0) {
884             token.transfer(msg.sender, tokenBalance);
885         }
886     }
887 
888     function getTokens() external view override returns(address[] memory) {
889         return lpbs().bPool.getCurrentTokens();
890     }
891 
892     /**
893         @notice Gets the underlying assets and amounts to mint specific pool shares.
894         @param _amount Amount of pool shares to calculate the values for
895         @return tokens The addresses of the tokens
896         @return amounts The amounts of tokens needed to mint that amount of pool shares
897     */
898     function calcTokensForAmount(uint256 _amount) external view override returns(address[] memory tokens, uint256[] memory amounts) {
899         tokens = lpbs().bPool.getCurrentTokens();
900         amounts = new uint256[](tokens.length);
901         uint256 ratio = bdiv(_amount, totalSupply());
902 
903         for(uint256 i = 0; i < tokens.length; i ++) {
904             address t = tokens[i];
905             uint256 bal = lpbs().bPool.getBalance(t);
906             uint256 amount = bmul(ratio, bal);
907             amounts[i] = amount;
908         }
909     }
910 
911     /** 
912         @notice Get the address of the controller
913         @return The address of the pool
914     */
915     function getController() external view override returns(address) {
916         return lpbs().controller;
917     }
918 
919     /** 
920         @notice Get the address of the public swap setter
921         @return The public swap setter address
922     */
923     function getPublicSwapSetter() external view returns(address) {
924         return lpbs().publicSwapSetter;
925     }
926 
927     /**
928         @notice Get the address of the token binder
929         @return The token binder address
930     */
931     function getTokenBinder() external view returns(address) {
932         return lpbs().tokenBinder;
933     }
934 
935     /**
936         @notice Get if public swapping is enabled
937         @return If public swapping is enabled
938     */
939     function isPublicSwap() external view returns (bool) {
940         return lpbs().bPool.isPublicSwap();
941     }
942 
943     /**
944         @notice Get the current swap fee
945         @return The current swap fee
946     */
947     function getSwapFee() external view returns (uint256) {
948         return lpbs().bPool.getSwapFee();
949     }
950 
951     /**
952         @notice Get the address of the underlying Balancer pool
953         @return The address of the underlying balancer pool
954     */
955     function getBPool() external view returns(address) {
956         return address(lpbs().bPool);
957     }
958 
959     /**
960         @notice Pull the underlying token from an address and rebind it to the balancer pool
961         @param _token Address of the token to pull
962         @param _from Address to pull the token from
963         @param _amount Amount of token to pull
964         @param _tokenBalance Balance of the token already in the balancer pool
965     */
966     function _pullUnderlying(address _token, address _from, uint256 _amount, uint256 _tokenBalance)
967         internal
968     {   
969         IBPool bPool = lpbs().bPool;
970         // Gets current Balance of token i, Bi, and weight of token i, Wi, from BPool.
971         uint tokenWeight = bPool.getDenormalizedWeight(_token);
972 
973         bool xfer = IERC20(_token).transferFrom(_from, address(this), _amount);
974         require(xfer, "ERR_ERC20_FALSE");
975         bPool.rebind(_token, badd(_tokenBalance, _amount), tokenWeight);
976     }
977 
978     /** 
979         @notice Push a underlying token and rebind the token to the balancer pool
980         @param _token Address of the token to push
981         @param _to Address to pull the token to
982         @param _amount Amount of token to push
983         @param _tokenBalance Balance of the token already in the balancer pool
984     */
985     function _pushUnderlying(address _token, address _to, uint256 _amount, uint256 _tokenBalance)
986         internal
987     {   
988         IBPool bPool = lpbs().bPool;
989         // Gets current Balance of token i, Bi, and weight of token i, Wi, from BPool.
990         uint tokenWeight = bPool.getDenormalizedWeight(_token);
991         bPool.rebind(_token, bsub(_tokenBalance, _amount), tokenWeight);
992 
993         bool xfer = IERC20(_token).transfer(_to, _amount);
994         require(xfer, "ERR_ERC20_FALSE");
995     }
996 
997     /**
998         @notice Pull pool shares
999         @param _from Address to pull pool shares from
1000         @param _amount Amount of pool shares to pull
1001     */
1002     function _pullPoolShare(address _from, uint256 _amount)
1003         internal
1004     {
1005         _pull(_from, _amount);
1006     }
1007 
1008     /**
1009         @notice Burn pool shares
1010         @param _amount Amount of pool shares to burn
1011     */
1012     function _burnPoolShare(uint256 _amount)
1013         internal
1014     {
1015         _burn(_amount);
1016     }
1017 
1018     /** 
1019         @notice Mint pool shares 
1020         @param _amount Amount of pool shares to mint
1021     */
1022     function _mintPoolShare(uint256 _amount)
1023         internal
1024     {
1025         _mint(_amount);
1026     }
1027 
1028     /**
1029         @notice Push pool shares to account
1030         @param _to Address to push the pool shares to
1031         @param _amount Amount of pool shares to push
1032     */
1033     function _pushPoolShare(address _to, uint256 _amount)
1034         internal
1035     {
1036         _push(_to, _amount);
1037     }
1038 
1039     /**
1040         @notice Load PBasicPool storage
1041         @return s Pointer to the storage struct
1042     */
1043     function lpbs() internal pure returns (pbs storage s) {
1044         bytes32 loc = pbsSlot;
1045         assembly {
1046             s_slot := loc
1047         }
1048     }
1049 
1050 }
1051 
1052 
1053 // File contracts/smart-pools/PCappedSmartPool.sol
1054 
1055 pragma solidity ^0.6.4;
1056 
1057 contract PCappedSmartPool is PBasicSmartPool {
1058 
1059     bytes32 constant public pcsSlot = keccak256("PCappedSmartPool.storage.location");
1060 
1061     event CapChanged(address indexed setter, uint256 oldCap, uint256 newCap);
1062 
1063     struct pcs {
1064         uint256 cap;
1065     }
1066 
1067     modifier withinCap() {
1068         _;
1069         require(totalSupply() < lpcs().cap, "PCappedSmartPool.withinCap: Cap limit reached");
1070     }
1071 
1072     /**
1073         @notice Set the maximum cap of the contract
1074         @param _cap New cap in wei
1075     */
1076     function setCap(uint256 _cap) onlyController external {
1077         emit CapChanged(msg.sender, lpcs().cap, _cap);
1078         lpcs().cap = _cap;
1079     }
1080 
1081     /**
1082         @notice Takes underlying assets and mints smart pool tokens. Enforces the cap
1083         @param _amount Amount of pool tokens to mint
1084     */
1085     function joinPool(uint256 _amount) external override withinCap {
1086         super._joinPool(_amount);
1087     }
1088 
1089 
1090     /**
1091         @notice Get the current cap
1092         @return The current cap in wei
1093     */
1094     function getCap() external view returns(uint256) {
1095         return lpcs().cap;
1096     }
1097 
1098     /**
1099         @notice Load the PCappedSmartPool storage
1100         @return s Pointer to the storage struct
1101     */
1102     function lpcs() internal pure returns (pcs storage s) {
1103         bytes32 loc = pcsSlot;
1104         assembly {
1105             s_slot := loc
1106         }
1107     }
1108 
1109 }
1110 
1111 
1112 // File contracts/factory/PProxiedFactory.sol
1113 
1114 pragma solidity ^0.6.4;
1115 
1116 
1117 
1118 
1119 
1120 
1121 
1122 contract PProxiedFactory is Ownable {
1123 
1124     IBFactory public balancerFactory;
1125     address public smartPoolImplementation;
1126     mapping(address => bool) public isPool;
1127     address[] public pools;
1128 
1129     event SmartPoolCreated(address indexed poolAddress, string name, string symbol);
1130 
1131     function init(address _balancerFactory) public {
1132         require(smartPoolImplementation == address(0), "Already initialised");
1133         _setOwner(msg.sender);
1134         balancerFactory = IBFactory(_balancerFactory);
1135         
1136         PCappedSmartPool implementation = new PCappedSmartPool();
1137         // function init(address _bPool, string calldata _name, string calldata _symbol, uint256 _initialSupply) external {
1138         implementation.init(address(0), "IMPL", "IMPL", 1 ether);
1139         smartPoolImplementation = address(implementation);
1140     }
1141 
1142     function newProxiedSmartPool(
1143         string memory _name, 
1144         string memory _symbol,
1145         uint256 _initialSupply,
1146         address[] memory _tokens,
1147         uint256[] memory _amounts,
1148         uint256[] memory _weights,
1149         uint256 _cap
1150     ) public onlyOwner returns(address) {
1151         // Deploy proxy contract
1152         PProxyPausable proxy = new PProxyPausable();
1153         
1154         // Setup proxy
1155         proxy.setImplementation(smartPoolImplementation);
1156         proxy.setPauzer(msg.sender);
1157         proxy.setProxyOwner(msg.sender); 
1158         
1159         // Setup balancer pool
1160         address balancerPoolAddress = balancerFactory.newBPool();
1161         IBPool bPool = IBPool(balancerPoolAddress);
1162 
1163         for(uint256 i = 0; i < _tokens.length; i ++) {
1164             IERC20 token = IERC20(_tokens[i]);
1165             // Transfer tokens to this contract
1166             token.transferFrom(msg.sender, address(this), _amounts[i]);
1167             // Approve the balancer pool
1168             token.approve(balancerPoolAddress, uint256(-1));
1169             // Bind tokens
1170             bPool.bind(_tokens[i], _amounts[i], _weights[i]);
1171         }
1172         bPool.setController(address(proxy));
1173         
1174         // Setup smart pool
1175         PCappedSmartPool smartPool = PCappedSmartPool(address(proxy));
1176     
1177         smartPool.init(balancerPoolAddress, _name, _symbol, _initialSupply);
1178         smartPool.setCap(_cap);
1179         smartPool.setPublicSwapSetter(msg.sender);
1180         smartPool.setTokenBinder(msg.sender);
1181         smartPool.setController(msg.sender);
1182         smartPool.approveTokens();
1183         
1184         isPool[address(smartPool)] = true;
1185         pools.push(address(smartPool));
1186 
1187         emit SmartPoolCreated(address(smartPool), _name, _symbol);
1188 
1189         smartPool.transfer(msg.sender, _initialSupply);
1190 
1191         return address(smartPool);
1192     }
1193 
1194 }
1195 
1196 
1197 // File contracts/interfaces/IUniswapFactory.sol
1198 
1199 pragma solidity ^0.6.4;
1200 
1201 interface IUniswapFactory {
1202     // Create Exchange
1203     function createExchange(address token) external returns (address exchange);
1204     // Get Exchange and Token Info
1205     function getExchange(address token) external view returns (address exchange);
1206     function getToken(address exchange) external view returns (address token);
1207     function getTokenWithId(uint256 tokenId) external view returns (address token);
1208     // Never use
1209     function initializeFactory(address template) external;
1210 }
1211 
1212 
1213 // File contracts/interfaces/IUniswapExchange.sol
1214 
1215 pragma solidity ^0.6.4;
1216 
1217 interface IUniswapExchange {
1218     // Address of ERC20 token sold on this exchange
1219     function tokenAddress() external view returns (address token);
1220     // Address of Uniswap Factory
1221     function factoryAddress() external view returns (address factory);
1222     // Provide Liquidity
1223     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
1224     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
1225     // Get Prices
1226     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
1227     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
1228     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
1229     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
1230     // Trade ETH to ERC20
1231     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
1232     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
1233     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
1234     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
1235     // Trade ERC20 to ETH
1236     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
1237     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
1238     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
1239     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
1240     // Trade ERC20 to ERC20
1241     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
1242     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
1243     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
1244     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
1245     // Trade ERC20 to Custom Pool
1246     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
1247     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
1248     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
1249     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
1250     // ERC20 comaptibility for liquidity tokens
1251     // bytes32 public name;
1252     // bytes32 public symbol;
1253     // uint256 public decimals;
1254     function transfer(address _to, uint256 _value) external returns (bool);
1255     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
1256     function approve(address _spender, uint256 _value) external returns (bool);
1257     function allowance(address _owner, address _spender) external view returns (uint256);
1258     function balanceOf(address _owner) external view returns (uint256);
1259     function totalSupply() external view returns (uint256);
1260     // Never use
1261     function setup(address token_addr) external;
1262 }
1263 
1264 
1265 // File contracts/recipes/PUniswapPoolRecipe.sol
1266 
1267 pragma solidity ^0.6.4;
1268 
1269 
1270 
1271 
1272 
1273 // Takes ETH and mints smart pool tokens
1274 contract PUniswapPoolRecipe {
1275     
1276     bytes32 constant public uprSlot = keccak256("PUniswapPoolRecipe.storage.location");
1277 
1278     // Uniswap pool recipe struct
1279     struct uprs {
1280         IPSmartPool pool;
1281         IUniswapFactory uniswapFactory;
1282     }
1283 
1284     function init(address _pool, address _uniswapFactory) public virtual {
1285         uprs storage s = luprs();
1286         require(address(s.pool) == address(0), "already initialised");
1287         s.pool = IPSmartPool(_pool);
1288         s.uniswapFactory = IUniswapFactory(_uniswapFactory);
1289     }
1290 
1291     // Using same interface as Uniswap for compatibility
1292     function ethToTokenTransferOutput(uint256 _tokens_bought, uint256 _deadline, address _recipient) public payable returns (uint256  eth_sold) {
1293         uprs storage s = luprs();
1294         require(_deadline >= block.timestamp);
1295         (address[] memory tokens, uint256[] memory amounts) = s.pool.calcTokensForAmount(_tokens_bought);
1296 
1297         eth_sold = 0;
1298         // Buy and approve tokens
1299         for(uint256 i = 0; i < tokens.length; i ++) {
1300             eth_sold += _ethToToken(tokens[i], amounts[i]);
1301             IERC20(tokens[i]).approve(address(s.pool), uint256(-1));
1302         }
1303 
1304         // Calculate amount of eth sold
1305         eth_sold = msg.value - address(this).balance;
1306         // Send back excess eth
1307         msg.sender.transfer(address(this).balance);
1308 
1309         // Join pool
1310         s.pool.joinPool(_tokens_bought);
1311 
1312         // Send pool tokens to receiver
1313         s.pool.transfer(_recipient, s.pool.balanceOf(address(this)));
1314         return eth_sold;
1315     }
1316 
1317     function ethToTokenSwapOutput(uint256 _tokens_bought, uint256 _deadline) external payable returns (uint256 eth_sold) {
1318         return ethToTokenTransferOutput(_tokens_bought, _deadline, msg.sender);
1319     }
1320 
1321     function _ethToToken(address _token, uint256 _tokens_bought) internal virtual returns (uint256) {
1322         uprs storage s = luprs();
1323         IUniswapExchange exchange = IUniswapExchange(s.uniswapFactory.getExchange(_token));
1324         return exchange.ethToTokenSwapOutput{value: address(this).balance}(_tokens_bought, uint256(-1));
1325     }
1326 
1327     function getEthToTokenOutputPrice(uint256 _tokens_bought) external view virtual returns (uint256 eth_sold) {
1328         uprs storage s = luprs();
1329         (address[] memory tokens, uint256[] memory amounts) = s.pool.calcTokensForAmount(_tokens_bought);
1330 
1331         eth_sold = 0;
1332 
1333         for(uint256 i = 0; i < tokens.length; i ++) {
1334             IUniswapExchange exchange = IUniswapExchange(s.uniswapFactory.getExchange(tokens[i]));
1335             eth_sold += exchange.getEthToTokenOutputPrice(amounts[i]);
1336         }
1337 
1338         return eth_sold;
1339     }
1340 
1341     function tokenToEthTransferInput(uint256 _tokens_sold, uint256 _min_eth, uint256 _deadline, address _recipient) public returns (uint256 eth_bought) {
1342         uprs storage s = luprs();
1343         require(_deadline >= block.timestamp);
1344         require(s.pool.transferFrom(msg.sender, address(this), _tokens_sold), "PUniswapPoolRecipe.tokenToEthTransferInput: transferFrom failed");
1345 
1346         s.pool.exitPool(_tokens_sold);
1347 
1348         address[] memory tokens = s.pool.getTokens();
1349 
1350         uint256 ethAmount = 0;
1351 
1352         for(uint256 i = 0; i < tokens.length; i ++) {
1353             IERC20 token = IERC20(tokens[i]);
1354             
1355             uint256 balance = token.balanceOf(address(this));
1356            
1357             // Exchange for ETH
1358             ethAmount += _tokenToEth(token, balance, _recipient);
1359         }
1360 
1361         require(ethAmount > _min_eth, "PUniswapPoolRecipe.tokenToEthTransferInput: not enough ETH");
1362         return ethAmount;
1363     }
1364 
1365     function tokenToEthSwapInput(uint256 _tokens_sold, uint256 _min_eth, uint256 _deadline) external returns (uint256 eth_bought) {
1366         return tokenToEthTransferInput(_tokens_sold, _min_eth, _deadline, msg.sender);
1367     }
1368 
1369     function _tokenToEth(IERC20 _token, uint256 _tokens_sold, address _recipient) internal virtual returns (uint256 eth_bought) {
1370         uprs storage s = luprs();
1371         IUniswapExchange exchange = IUniswapExchange(s.uniswapFactory.getExchange(address(_token)));
1372         _token.approve(address(exchange), _tokens_sold);
1373         // Exchange for ETH
1374         return exchange.tokenToEthTransferInput(_tokens_sold, 1, uint256(-1), _recipient);
1375     }
1376 
1377     function getTokenToEthInputPrice(uint256 _tokens_sold) external view virtual returns (uint256 eth_bought) {
1378         uprs storage s = luprs();
1379         (address[] memory tokens, uint256[] memory amounts) = s.pool.calcTokensForAmount(_tokens_sold);
1380 
1381         eth_bought = 0;
1382 
1383         for(uint256 i = 0; i < tokens.length; i ++) {
1384             IUniswapExchange exchange = IUniswapExchange(s.uniswapFactory.getExchange(address(tokens[i])));
1385             eth_bought += exchange.getTokenToEthInputPrice(amounts[i]);
1386         }
1387 
1388         return eth_bought;
1389     }
1390 
1391     function pool() external view returns (address) {
1392         return address(luprs().pool);
1393     }
1394 
1395     receive() external payable {
1396 
1397     }
1398 
1399     // Load uniswap pool recipe
1400     function luprs() internal pure returns (uprs storage s) {
1401         bytes32 loc = uprSlot;
1402         assembly {
1403             s_slot := loc
1404         }
1405     }
1406 }
1407 
1408 
1409 // File contracts/interfaces/IKyberNetwork.sol
1410 
1411 pragma solidity ^0.6.4;
1412 
1413 interface IKyberNetwork {
1414 
1415     function trade(
1416         address src,
1417         uint srcAmount,
1418         address dest,
1419         address payable destAddress,
1420         uint maxDestAmount,
1421         uint minConversionRate,
1422         address walletId
1423     ) external payable returns(uint256);
1424 }
1425 
1426 
1427 // File contracts/recipes/PUniswapKyberPoolRecipe.sol
1428 
1429 pragma solidity ^0.6.4;
1430 
1431 
1432 
1433 
1434 contract PUniswapKyberPoolRecipe is PUniswapPoolRecipe, Ownable {
1435 
1436     bytes32 constant public ukprSlot = keccak256("PUniswapKyberPoolRecipe.storage.location");
1437 
1438     // Uniswap pool recipe struct
1439     struct ukprs {
1440         mapping(address => bool) swapOnKyber;
1441         IKyberNetwork kyber;
1442         address feeReceiver;
1443     }
1444 
1445     address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1446     
1447     function init(address, address) public override {
1448         require(false, "not enabled");
1449     }
1450 
1451     // Use seperate init function
1452     function initUK(address _pool, address _uniswapFactory, address _kyber, address[] memory _swapOnKyber, address _feeReciever) public {
1453         // UnsiwapRecipe enforces that init can only be called once
1454         ukprs storage s = lukprs();
1455 
1456         PUniswapPoolRecipe.init(_pool, _uniswapFactory);
1457         s.kyber = IKyberNetwork(_kyber);
1458         s.feeReceiver = _feeReciever;
1459 
1460         _setOwner(msg.sender);
1461 
1462         for(uint256 i = 0; i < _swapOnKyber.length; i ++) {
1463             s.swapOnKyber[_swapOnKyber[i]] = true;
1464         }
1465     }
1466 
1467     function setKyberSwap(address _token, bool _value) external onlyOwner {
1468         ukprs storage s = lukprs();
1469         s.swapOnKyber[_token] = _value;
1470     }
1471 
1472     function _ethToToken(address _token, uint256 _tokens_bought) internal override returns (uint256) {
1473         ukprs storage s = lukprs();
1474         if(!s.swapOnKyber[_token]) {
1475             return super._ethToToken(_token, _tokens_bought);
1476         }
1477 
1478         uint256 ethBefore = address(this).balance;
1479         s.kyber.trade{value: address(this).balance}(ETH, address(this).balance, _token, address(this), _tokens_bought, 1, s.feeReceiver);
1480         uint256 ethAfter = address(this).balance;
1481 
1482         // return amount of ETH spend
1483         return ethBefore - ethAfter;
1484     }
1485 
1486     function _tokenToEth(IERC20 _token, uint256 _tokens_sold, address _recipient) internal override returns (uint256 eth_bought) {
1487         ukprs storage s = lukprs();
1488         if(!s.swapOnKyber[address(_token)]) {
1489             return super._tokenToEth(_token, _tokens_sold, _recipient);
1490         }
1491 
1492         uint256 ethBefore = address(this).balance;
1493         _token.approve(address(s.kyber), uint256(-1));
1494         s.kyber.trade(address(_token), _tokens_sold, ETH, address(this), uint256(-1), 1, s.feeReceiver);
1495         uint256 ethAfter = address(this).balance;
1496 
1497         // return amount of ETH received
1498         return ethAfter - ethBefore;
1499     }
1500 
1501     // Load uniswap pool recipe
1502     function lukprs() internal pure returns (ukprs storage s) {
1503         bytes32 loc = ukprSlot;
1504         assembly {
1505             s_slot := loc
1506         }
1507     }
1508 
1509 }
1510 
1511 
1512 // File contracts/test/TestReentryProtection.sol
1513 
1514 pragma solidity ^0.6.4;
1515 
1516 
1517 contract TestReentryProtection is ReentryProtection {
1518 
1519     // This should fail
1520     function test() external noReentry {
1521         reenter();
1522     }
1523 
1524     function reenter() public noReentry {
1525         // Do nothing
1526     }
1527 
1528 }