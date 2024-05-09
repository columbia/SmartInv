1 /**
2  *Submitted for verification at Etherscan.io on 2020-04-02
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-04-02
7 */
8 
9 // Sources flattened with buidler v1.2.0 https://buidler.dev
10 
11 // File @pie-dao/proxy/contracts/PProxyStorage.sol@v0.0.6
12 
13 pragma solidity ^0.6.2;
14 
15 contract PProxyStorage {
16 
17     function readString(bytes32 _key) public view returns(string memory) {
18         return bytes32ToString(storageRead(_key));
19     }
20 
21     function setString(bytes32 _key, string memory _value) internal {
22         storageSet(_key, stringToBytes32(_value));
23     }
24 
25     function readBool(bytes32 _key) public view returns(bool) {
26         return storageRead(_key) == bytes32(uint256(1));
27     }
28 
29     function setBool(bytes32 _key, bool _value) internal {
30         if(_value) {
31             storageSet(_key, bytes32(uint256(1)));
32         } else {
33             storageSet(_key, bytes32(uint256(0)));
34         }
35     }
36 
37     function readAddress(bytes32 _key) public view returns(address) {
38         return bytes32ToAddress(storageRead(_key));
39     }
40 
41     function setAddress(bytes32 _key, address _value) internal {
42         storageSet(_key, addressToBytes32(_value));
43     }
44 
45     function storageRead(bytes32 _key) public view returns(bytes32) {
46         bytes32 value;
47         //solium-disable-next-line security/no-inline-assembly
48         assembly {
49             value := sload(_key)
50         }
51         return value;
52     }
53 
54     function storageSet(bytes32 _key, bytes32 _value) internal {
55         // targetAddress = _address;  // No!
56         bytes32 implAddressStorageKey = _key;
57         //solium-disable-next-line security/no-inline-assembly
58         assembly {
59             sstore(implAddressStorageKey, _value)
60         }
61     }
62 
63     function bytes32ToAddress(bytes32 _value) public pure returns(address) {
64         return address(uint160(uint256(_value)));
65     }
66 
67     function addressToBytes32(address _value) public pure returns(bytes32) {
68         return bytes32(uint256(_value));
69     }
70 
71     function stringToBytes32(string memory _value) public pure returns (bytes32 result) {
72         bytes memory tempEmptyStringTest = bytes(_value);
73         if (tempEmptyStringTest.length == 0) {
74             return 0x0;
75         }
76 
77         assembly {
78             result := mload(add(_value, 32))
79         }
80     }
81 
82     function bytes32ToString(bytes32 _value) public pure returns (string memory) {
83         bytes memory bytesString = new bytes(32);
84         uint charCount = 0;
85         for (uint256 j = 0; j < 32; j++) {
86             byte char = byte(bytes32(uint(_value) * 2 ** (8 * j)));
87             if (char != 0) {
88                 bytesString[charCount] = char;
89                 charCount++;
90             }
91         }
92         bytes memory bytesStringTrimmed = new bytes(charCount);
93         for (uint256 j = 0; j < charCount; j++) {
94             bytesStringTrimmed[j] = bytesString[j];
95         }
96         return string(bytesStringTrimmed);
97     }
98 }
99 
100 
101 // File @pie-dao/proxy/contracts/PProxy.sol@v0.0.6
102 
103 pragma solidity ^0.6.2;
104 
105 
106 contract PProxy is PProxyStorage {
107 
108     bytes32 constant IMPLEMENTATION_SLOT = keccak256(abi.encodePacked("IMPLEMENTATION_SLOT"));
109     bytes32 constant OWNER_SLOT = keccak256(abi.encodePacked("OWNER_SLOT"));
110 
111     modifier onlyProxyOwner() {
112         require(msg.sender == readAddress(OWNER_SLOT), "PProxy.onlyProxyOwner: msg sender not owner");
113         _;
114     }
115 
116     constructor () public {
117         setAddress(OWNER_SLOT, msg.sender);
118     }
119 
120     function getProxyOwner() public view returns (address) {
121        return readAddress(OWNER_SLOT);
122     }
123 
124     function setProxyOwner(address _newOwner) onlyProxyOwner public {
125         setAddress(OWNER_SLOT, _newOwner);
126     }
127 
128     function getImplementation() public view returns (address) {
129         return readAddress(IMPLEMENTATION_SLOT);
130     }
131 
132     function setImplementation(address _newImplementation) onlyProxyOwner public {
133         setAddress(IMPLEMENTATION_SLOT, _newImplementation);
134     }
135 
136 
137     fallback () external payable {
138        return internalFallback();
139     }
140 
141     function internalFallback() internal virtual {
142         address contractAddr = readAddress(IMPLEMENTATION_SLOT);
143         assembly {
144             let ptr := mload(0x40)
145             calldatacopy(ptr, 0, calldatasize())
146             let result := delegatecall(gas(), contractAddr, ptr, calldatasize(), 0, 0)
147             let size := returndatasize()
148             returndatacopy(ptr, 0, size)
149 
150             switch result
151             case 0 { revert(ptr, size) }
152             default { return(ptr, size) }
153         }
154     }
155 
156 }
157 
158 
159 // File @pie-dao/proxy/contracts/PProxyPausable.sol@v0.0.6
160 
161 pragma solidity ^0.6.2;
162 
163 
164 contract PProxyPausable is PProxy {
165 
166     bytes32 constant PAUSED_SLOT = keccak256(abi.encodePacked("PAUSED_SLOT"));
167     bytes32 constant PAUZER_SLOT = keccak256(abi.encodePacked("PAUZER_SLOT"));
168 
169     constructor() PProxy() public {
170         setAddress(PAUZER_SLOT, msg.sender);
171     }
172 
173     modifier onlyPauzer() {
174         require(msg.sender == readAddress(PAUZER_SLOT), "PProxyPausable.onlyPauzer: msg sender not pauzer");
175         _;
176     }
177 
178     modifier notPaused() {
179         require(!readBool(PAUSED_SLOT), "PProxyPausable.notPaused: contract is paused");
180         _;
181     }
182 
183     function getPauzer() public view returns (address) {
184         return readAddress(PAUZER_SLOT);
185     }
186 
187     function setPauzer(address _newPauzer) public onlyProxyOwner{
188         setAddress(PAUZER_SLOT, _newPauzer);
189     }
190 
191     function renouncePauzer() public onlyPauzer {
192         setAddress(PAUZER_SLOT, address(0));
193     }
194 
195     function getPaused() public view returns (bool) {
196         return readBool(PAUSED_SLOT);
197     }
198 
199     function setPaused(bool _value) public onlyPauzer {
200         setBool(PAUSED_SLOT, _value);
201     }
202 
203     function internalFallback() internal virtual override notPaused {
204         super.internalFallback();
205     }
206 
207 }
208 
209 
210 // File contracts/interfaces/IBFactory.sol
211 
212 pragma solidity ^0.6.4;
213 
214 interface IBFactory {
215     function newBPool() external returns (address);
216 }
217 
218 
219 // File contracts/interfaces/IBPool.sol
220 
221 // This program is free software: you can redistribute it and/or modify
222 // it under the terms of the GNU General Public License as published by
223 // the Free Software Foundation, either version 3 of the License, or
224 // (at your option) any later version.
225 
226 // This program is disstributed in the hope that it will be useful,
227 // but WITHOUT ANY WARRANTY; without even the implied warranty of
228 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
229 // GNU General Public License for more details.
230 
231 // You should have received a copy of the GNU General Public License
232 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
233 
234 pragma solidity 0.6.4;
235 
236 interface IBPool {
237     function isBound(address token) external view returns(bool);
238     function getBalance(address token) external view returns (uint);
239     function rebind(address token, uint balance, uint denorm) external;
240     function setSwapFee(uint swapFee) external;
241     function setPublicSwap(bool _public) external;
242     function bind(address token, uint balance, uint denorm) external;
243     function unbind(address token) external;
244     function getDenormalizedWeight(address token) external view returns (uint);
245     function getTotalDenormalizedWeight() external view returns (uint);
246     function getCurrentTokens() external view returns(address[] memory);
247     function setController(address manager) external;
248     function isPublicSwap() external view returns(bool);
249     function getSwapFee() external view returns (uint256);
250     function gulp(address token) external;
251 
252     function calcPoolOutGivenSingleIn(
253         uint tokenBalanceIn,
254         uint tokenWeightIn,
255         uint poolSupply,
256         uint totalWeight,
257         uint tokenAmountIn,
258         uint swapFee
259     )
260         external pure
261         returns (uint poolAmountOut);
262 
263     function calcSingleInGivenPoolOut(
264         uint tokenBalanceIn,
265         uint tokenWeightIn,
266         uint poolSupply,
267         uint totalWeight,
268         uint poolAmountOut,
269         uint swapFee
270     )
271         external pure
272         returns (uint tokenAmountIn);
273 
274     function calcSingleOutGivenPoolIn(
275         uint tokenBalanceOut,
276         uint tokenWeightOut,
277         uint poolSupply,
278         uint totalWeight,
279         uint poolAmountIn,
280         uint swapFee
281     )
282         external pure
283         returns (uint tokenAmountOut);
284 
285     function calcPoolInGivenSingleOut(
286         uint tokenBalanceOut,
287         uint tokenWeightOut,
288         uint poolSupply,
289         uint totalWeight,
290         uint tokenAmountOut,
291         uint swapFee
292     )
293         external pure
294         returns (uint poolAmountIn);
295 }
296 
297 
298 // File contracts/interfaces/IERC20.sol
299 
300 pragma solidity ^0.6.4;
301 
302 interface IERC20 {
303     event Approval(address indexed _src, address indexed _dst, uint _amount);
304     event Transfer(address indexed _src, address indexed _dst, uint _amount);
305 
306     function totalSupply() external view returns (uint);
307     function balanceOf(address _whom) external view returns (uint);
308     function allowance(address _src, address _dst) external view returns (uint);
309 
310     function approve(address _dst, uint _amount) external returns (bool);
311     function transfer(address _dst, uint _amount) external returns (bool);
312     function transferFrom(
313         address _src, address _dst, uint _amount
314     ) external returns (bool);
315 }
316 
317 
318 // File contracts/Ownable.sol
319 
320 pragma solidity ^0.6.4;
321 
322 // TODO move this generic contract to a seperate repo with all generic smart contracts
323 
324 contract Ownable {
325 
326     bytes32 constant public oSlot = keccak256("Ownable.storage.location");
327 
328     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
329 
330     // Ownable struct
331     struct os {
332         address owner;
333     }
334 
335     modifier onlyOwner(){
336         require(msg.sender == los().owner, "Ownable.onlyOwner: msg.sender not owner");
337         _;
338     }
339 
340     /**
341         @notice Transfer ownership to a new address
342         @param _newOwner Address of the new owner
343     */
344     function transferOwnership(address _newOwner) onlyOwner external {
345         _setOwner(_newOwner);
346     }
347 
348     /**
349         @notice Internal method to set the owner
350         @param _newOwner Address of the new owner
351     */
352     function _setOwner(address _newOwner) internal {
353         emit OwnerChanged(los().owner, _newOwner);
354         los().owner = _newOwner;
355     }
356 
357     /**
358         @notice Load ownable storage
359         @return s Storage pointer to the Ownable storage struct
360     */
361     function los() internal pure returns (os storage s) {
362         bytes32 loc = oSlot;
363         assembly {
364             s_slot := loc
365         }
366     }
367 
368 }
369 
370 
371 // File contracts/interfaces/IPSmartPool.sol
372 
373 pragma solidity ^0.6.4;
374 
375 interface IPSmartPool is IERC20 {
376     function joinPool(uint256 _amount) external;
377     function exitPool(uint256 _amount) external;
378     function getController() external view returns(address);
379     function getTokens() external view returns(address[] memory);
380     function calcTokensForAmount(uint256 _amount) external view  returns(address[] memory tokens, uint256[] memory amounts);
381 }
382 
383 
384 // File contracts/PCTokenStorage.sol
385 
386 pragma solidity ^0.6.4;
387 
388 contract PCTokenStorage {
389 
390     bytes32 constant public ptSlot = keccak256("PCToken.storage.location");
391     struct pts {
392         string name;
393         string symbol;
394         uint256 totalSupply;
395         mapping(address => uint256) balance;
396         mapping(address => mapping(address=>uint256)) allowance;
397     }
398 
399     /**
400         @notice Load pool token storage
401         @return s Storage pointer to the pool token struct
402     */
403     function lpts() internal pure returns (pts storage s) {
404         bytes32 loc = ptSlot;
405         assembly {
406             s_slot := loc
407         }
408     }
409 
410 }
411 
412 
413 // File contracts/PCToken.sol
414 
415 // This program is free software: you can redistribute it and/or modify
416 // it under the terms of the GNU General Public License as published by
417 // the Free Software Foundation, either version 3 of the License, or
418 // (at your option) any later version.
419 
420 // This program is distributed in the hope that it will be useful,
421 // but WITHOUT ANY WARRANTY; without even the implied warranty of
422 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
423 // GNU General Public License for more details.
424 
425 // You should have received a copy of the GNU General Public License
426 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
427 
428 pragma solidity ^0.6.4;
429 
430 
431 
432 // Highly opinionated token implementation
433 // Based on the balancer Implementation
434 
435 
436 contract PCToken is IERC20, PCTokenStorage {
437 
438     event Approval(address indexed _src, address indexed _dst, uint _amount);
439     event Transfer(address indexed _src, address indexed _dst, uint _amount);
440 
441     uint8 public constant decimals = 18;
442     uint public constant BONE              = 10**18;
443     uint public constant MAX_BOUND_TOKENS  = 8;
444     uint public constant MIN_WEIGHT        = BONE;
445     uint public constant MAX_WEIGHT        = BONE * 50;
446     uint public constant MAX_TOTAL_WEIGHT  = BONE * 50;
447     uint public constant MIN_BALANCE       = BONE / 10**6;
448     uint public constant MAX_BALANCE       = BONE * 10**12;
449 
450     uint public constant MIN_POOL_SUPPLY   = BONE;
451 
452     function badd(uint a, uint b)
453         internal pure
454         returns (uint)
455     {
456         uint c = a + b;
457         require(c >= a, "ERR_ADD_OVERFLOW");
458         return c;
459     }
460 
461     function bsub(uint a, uint b)
462         internal pure
463         returns (uint)
464     {
465         (uint c, bool flag) = bsubSign(a, b);
466         require(!flag, "ERR_SUB_UNDERFLOW");
467         return c;
468     }
469 
470     function bsubSign(uint a, uint b)
471         internal pure
472         returns (uint, bool)
473     {
474         if (a >= b) {
475             return (a - b, false);
476         } else {
477             return (b - a, true);
478         }
479     }
480 
481     function bmul(uint a, uint b)
482         internal pure
483         returns (uint)
484     {
485         uint c0 = a * b;
486         require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
487         uint c1 = c0 + (BONE / 2);
488         require(c1 >= c0, "ERR_MUL_OVERFLOW");
489         uint c2 = c1 / BONE;
490         return c2;
491     }
492 
493     function bdiv(uint a, uint b)
494         internal pure
495         returns (uint)
496     {
497         require(b != 0, "ERR_DIV_ZERO");
498         uint c0 = a * BONE;
499         require(a == 0 || c0 / a == BONE, "ERR_DIV_INTERNAL"); // bmul overflow
500         uint c1 = c0 + (b / 2);
501         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
502         uint c2 = c1 / b;
503         return c2;
504     }
505 
506     function _mint(uint _amount) internal {
507         pts storage s = lpts();
508         s.balance[address(this)] = badd(s.balance[address(this)], _amount);
509         s.totalSupply = badd(s.totalSupply, _amount);
510         emit Transfer(address(0), address(this), _amount);
511     }
512 
513     function _burn(uint _amount) internal {
514         pts storage s = lpts();
515         require(s.balance[address(this)] >= _amount, "ERR_INSUFFICIENT_BAL");
516         s.balance[address(this)] = bsub(s.balance[address(this)], _amount);
517         s.totalSupply = bsub(s.totalSupply, _amount);
518         emit Transfer(address(this), address(0), _amount);
519     }
520 
521     function _move(address _src, address _dst, uint _amount) internal {
522         pts storage s = lpts();
523         require(s.balance[_src] >= _amount, "ERR_INSUFFICIENT_BAL");
524         s.balance[_src] = bsub(s.balance[_src], _amount);
525         s.balance[_dst] = badd(s.balance[_dst], _amount);
526         emit Transfer(_src, _dst, _amount);
527     }
528 
529     function _push(address _to, uint _amount) internal {
530         _move(address(this), _to, _amount);
531     }
532 
533     function _pull(address _from, uint _amount) internal {
534         _move(_from, address(this), _amount);
535     }
536 
537     function allowance(address _src, address _dst) external view override returns (uint) {
538         return lpts().allowance[_src][_dst];
539     }
540 
541     function balanceOf(address _whom) external view override returns (uint) {
542         return lpts().balance[_whom];
543     }
544 
545     function totalSupply() public view override returns (uint) {
546         return lpts().totalSupply;
547     }
548 
549     function name() external view returns (string memory) {
550         return lpts().name;
551     }
552 
553     function symbol() external view returns (string memory) {
554         return lpts().symbol;
555     }
556 
557     function approve(address _dst, uint _amount) external override returns (bool) {
558         lpts().allowance[msg.sender][_dst] = _amount;
559         emit Approval(msg.sender, _dst, _amount);
560         return true;
561     }
562 
563     function increaseApproval(address _dst, uint _amount) external returns (bool) {
564         pts storage s = lpts();
565         s.allowance[msg.sender][_dst] = badd(s.allowance[msg.sender][_dst], _amount);
566         emit Approval(msg.sender, _dst, s.allowance[msg.sender][_dst]);
567         return true;
568     }
569 
570     function decreaseApproval(address _dst, uint _amount) external returns (bool) {
571         pts storage s = lpts();
572         uint oldValue = s.allowance[msg.sender][_dst];
573         if (_amount > oldValue) {
574             s.allowance[msg.sender][_dst] = 0;
575         } else {
576             s.allowance[msg.sender][_dst] = bsub(oldValue, _amount);
577         }
578         emit Approval(msg.sender, _dst, s.allowance[msg.sender][_dst]);
579         return true;
580     }
581 
582     function transfer(address _dst, uint _amount) external override returns (bool) {
583         _move(msg.sender, _dst, _amount);
584         return true;
585     }
586 
587     function transferFrom(address _src, address _dst, uint _amount) external override returns (bool) {
588         pts storage s = lpts();
589         require(msg.sender == _src || _amount <= s.allowance[_src][msg.sender], "ERR_PCTOKEN_BAD_CALLER");
590         _move(_src, _dst, _amount);
591         if (msg.sender != _src && s.allowance[_src][msg.sender] != uint256(-1)) {
592             s.allowance[_src][msg.sender] = bsub(s.allowance[_src][msg.sender], _amount);
593             emit Approval(msg.sender, _dst, s.allowance[_src][msg.sender]);
594         }
595         return true;
596     }
597 }
598 
599 
600 // File contracts/ReentryProtection.sol
601 
602 pragma solidity ^0.6.4;
603 
604 // TODO move this generic contract to a seperate repo with all generic smart contracts
605 
606 contract ReentryProtection {
607 
608     bytes32 constant public rpSlot = keccak256("ReentryProtection.storage.location");
609 
610     // reentry protection storage
611     struct rps {
612         uint256 lockCounter;
613     }
614 
615     modifier noReentry {
616         // Use counter to only write to storage once
617         lrps().lockCounter ++;
618         uint256 lockValue = lrps().lockCounter;
619         _;
620         require(lockValue == lrps().lockCounter, "ReentryProtection.noReentry: reentry detected");
621     }
622 
623     /**
624         @notice Load reentry protection storage
625         @return s Pointer to the reentry protection storage struct
626     */
627     function lrps() internal pure returns (rps storage s) {
628         bytes32 loc = rpSlot;
629         assembly {
630             s_slot := loc
631         }
632     }
633 
634 }
635 
636 
637 // File contracts/smart-pools/PBasicSmartPool.sol
638 
639 pragma solidity ^0.6.4;
640 
641 
642 
643 
644 
645 contract PBasicSmartPool is IPSmartPool, PCToken, ReentryProtection {
646     
647     // P Basic Smart Struct
648     bytes32 constant public pbsSlot = keccak256("PBasicSmartPool.storage.location");
649     struct pbs {
650         IBPool bPool;
651         address controller;
652         address publicSwapSetter;
653         address tokenBinder;
654     }
655     
656     modifier ready() {
657         require(address(lpbs().bPool) != address(0), "PBasicSmartPool.ready: not ready");
658         _;
659     }   
660 
661      event LOG_JOIN(
662         address indexed caller,
663         address indexed tokenIn,
664         uint256 tokenAmountIn
665     );
666 
667     event LOG_EXIT(
668         address indexed caller,
669         address indexed tokenOut,
670         uint256 tokenAmountOut
671     );
672 
673     event TokensApproved();
674     event ControllerChanged(address indexed previousController, address indexed newController);
675     event PublicSwapSetterChanged(address indexed previousSetter, address indexed newSetter);
676     event TokenBinderChanged(address indexed previousTokenBinder, address indexed newTokenBinder);
677     event PublicSwapSet(address indexed setter, bool indexed value);
678     event SwapFeeSet(address indexed setter, uint256 newFee);
679     event PoolJoined(address indexed from, uint256 amount);
680     event PoolExited(address indexed from, uint256 amount);
681 
682     modifier onlyController() {
683         require(msg.sender == lpbs().controller, "PBasicSmartPool.onlyController: not controller");
684         _;
685     }
686 
687     modifier onlyPublicSwapSetter() {
688         require(msg.sender == lpbs().publicSwapSetter, "PBasicSmartPool.onlyPublicSwapSetter: not public swap setter");
689         _;
690     }
691 
692     modifier onlyTokenBinder() {
693         require(msg.sender == lpbs().tokenBinder, "PBasicSmartPool.onlyTokenBinder: not token binder");
694         _;
695     }
696 
697     /**
698         @notice Initialises the contract
699         @param _bPool Address of the underlying balancer pool
700         @param _name Name for the smart pool token
701         @param _symbol Symbol for the smart pool token
702         @param _initialSupply Initial token supply to mint
703     */
704     function init(address _bPool, string calldata _name, string calldata _symbol, uint256 _initialSupply) external {
705         pbs storage s = lpbs();
706         require(address(s.bPool) == address(0), "PBasicSmartPool.init: already initialised");
707         s.bPool = IBPool(_bPool);
708         s.controller = msg.sender;
709         s.publicSwapSetter = msg.sender;
710         s.tokenBinder = msg.sender;
711         lpts().name = _name;
712         lpts().symbol = _symbol;
713         _mintPoolShare(_initialSupply);
714         _pushPoolShare(msg.sender, _initialSupply);
715     }
716 
717     /**
718         @notice Sets approval to all tokens to the underlying balancer pool
719         @dev It uses this function to save on gas in joinPool
720     */
721     function approveTokens() public {
722         IBPool bPool = lpbs().bPool;
723         address[] memory tokens = bPool.getCurrentTokens();
724         for(uint256 i = 0; i < tokens.length; i ++) {
725             IERC20(tokens[i]).approve(address(bPool), uint256(-1));
726         }
727         emit TokensApproved();
728     }
729 
730     /**
731         @notice Sets the controller address. Can only be set by the current controller
732         @param _controller Address of the new controller
733     */
734     function setController(address _controller) onlyController noReentry external {
735         emit ControllerChanged(lpbs().controller, _controller);
736         lpbs().controller = _controller;
737     }
738 
739     /**
740         @notice Sets public swap setter address. Can only be set by the controller
741         @param _newPublicSwapSetter Address of the new public swap setter
742     */
743     function setPublicSwapSetter(address _newPublicSwapSetter) onlyController external {
744         emit PublicSwapSetterChanged(lpbs().publicSwapSetter, _newPublicSwapSetter);
745         lpbs().publicSwapSetter = _newPublicSwapSetter;
746     }
747 
748     /**
749         @notice Sets the token binder address. Can only be set by the controller
750         @param _newTokenBinder Address of the new token binder
751     */
752     function setTokenBinder(address _newTokenBinder) onlyController external {
753         emit TokenBinderChanged(lpbs().tokenBinder, _newTokenBinder);
754         lpbs().tokenBinder = _newTokenBinder;
755     }
756 
757     /**
758         @notice Enables or disables public swapping on the underlying balancer pool. Can only be set by the controller
759         @param _public Public or not
760     */
761     function setPublicSwap(bool _public) onlyPublicSwapSetter external {
762         emit PublicSwapSet(msg.sender, _public);
763         lpbs().bPool.setPublicSwap(_public);
764     }
765 
766     /**
767         @notice Set the swap fee on the underlying balancer pool. Can only be called by the controller
768         @param _swapFee The new swap fee
769     */
770     function setSwapFee(uint256 _swapFee) onlyController external {
771         emit SwapFeeSet(msg.sender, _swapFee);
772         lpbs().bPool.setSwapFee(_swapFee);
773     }
774 
775     /** 
776         @notice Mints pool shares in exchange for underlying assets
777         @param _amount Amount of pool shares to mint
778     */
779     function joinPool(uint256 _amount) external override virtual ready {
780         _joinPool(_amount);
781     }
782 
783     /**
784         @notice Internal join pool function. See joinPool for more info
785         @param _amount Amount of pool shares to mint
786     */
787     function _joinPool(uint256 _amount) internal virtual ready {
788         IBPool bPool = lpbs().bPool;
789         uint poolTotal = totalSupply();
790         uint ratio = bdiv(_amount, poolTotal);
791         require(ratio != 0);
792 
793         address[] memory tokens = bPool.getCurrentTokens();
794 
795         for (uint i = 0; i < tokens.length; i++) {
796             address t = tokens[i];
797             uint bal = bPool.getBalance(t);
798             uint tokenAmountIn = bmul(ratio, bal);
799             emit LOG_JOIN(msg.sender, t, tokenAmountIn);
800             _pullUnderlying(t, msg.sender, tokenAmountIn, bal);
801         }
802         _mintPoolShare(_amount);
803         _pushPoolShare(msg.sender, _amount);
804         emit PoolJoined(msg.sender, _amount);
805     }
806 
807     /** 
808         @notice Burns pool shares and sends back the underlying assets
809         @param _amount Amount of pool tokens to burn
810     */
811     function exitPool(uint256 _amount) external override ready noReentry {
812         IBPool bPool = lpbs().bPool;
813         uint poolTotal = totalSupply();
814         uint ratio = bdiv(_amount, poolTotal);
815         require(ratio != 0);
816 
817         _pullPoolShare(msg.sender, _amount);
818         _burnPoolShare(_amount);
819 
820         address[] memory tokens = bPool.getCurrentTokens();
821 
822         for (uint i = 0; i < tokens.length; i++) {
823             address t = tokens[i];
824             uint bal = bPool.getBalance(t);
825             uint tAo = bmul(ratio, bal);
826             emit LOG_EXIT(msg.sender, t, tAo);  
827             _pushUnderlying(t, msg.sender, tAo, bal);
828         }
829         emit PoolExited(msg.sender, _amount);
830     }
831 
832     /**
833         @notice Bind a token to the underlying balancer pool. Can only be called by the token binder
834         @param _token Token to bind
835         @param _balance Amount to bind
836         @param _denorm Denormalised weight
837     */
838     function bind(address _token, uint256 _balance, uint256 _denorm) external onlyTokenBinder {
839         IBPool bPool = lpbs().bPool;
840         IERC20 token = IERC20(_token);
841         token.transferFrom(msg.sender, address(this), _balance);
842         token.approve(address(bPool), uint256(-1));
843         bPool.bind(_token, _balance, _denorm);
844     }
845 
846     /**
847         @notice Rebind a token to the pool
848         @param _token Token to bind
849         @param _balance Amount to bind
850         @param _denorm Denormalised weight
851     */
852     function rebind(address _token, uint256 _balance, uint256 _denorm) external onlyTokenBinder {
853         IBPool bPool = lpbs().bPool;
854         IERC20 token = IERC20(_token);
855         
856         // gulp old non acounted for token balance in the contract
857         bPool.gulp(_token);
858 
859         uint256 oldBalance = token.balanceOf(address(bPool));
860         // If tokens need to be pulled from msg.sender
861         if(_balance > oldBalance) {
862             token.transferFrom(msg.sender, address(this), bsub(_balance, oldBalance));
863             token.approve(address(bPool), uint256(-1));
864         }
865 
866         bPool.rebind(_token, _balance, _denorm);
867 
868         // If any tokens are in this contract send them to msg.sender
869         uint256 tokenBalance = token.balanceOf(address(this));
870         if(tokenBalance > 0) {
871             token.transfer(msg.sender, tokenBalance);
872         }
873     }
874 
875     /**
876         @notice Unbind a token
877         @param _token Token to unbind
878     */
879     function unbind(address _token) external onlyTokenBinder {
880         IBPool bPool = lpbs().bPool;
881         IERC20 token = IERC20(_token);
882         // unbind the token in the bPool
883         bPool.unbind(_token);
884 
885         // If any tokens are in this contract send them to msg.sender
886         uint256 tokenBalance = token.balanceOf(address(this));
887         if(tokenBalance > 0) {
888             token.transfer(msg.sender, tokenBalance);
889         }
890     }
891 
892     function getTokens() external view override returns(address[] memory) {
893         return lpbs().bPool.getCurrentTokens();
894     }
895 
896     /**
897         @notice Gets the underlying assets and amounts to mint specific pool shares.
898         @param _amount Amount of pool shares to calculate the values for
899         @return tokens The addresses of the tokens
900         @return amounts The amounts of tokens needed to mint that amount of pool shares
901     */
902     function calcTokensForAmount(uint256 _amount) external view override returns(address[] memory tokens, uint256[] memory amounts) {
903         tokens = lpbs().bPool.getCurrentTokens();
904         amounts = new uint256[](tokens.length);
905         uint256 ratio = bdiv(_amount, totalSupply());
906 
907         for(uint256 i = 0; i < tokens.length; i ++) {
908             address t = tokens[i];
909             uint256 bal = lpbs().bPool.getBalance(t);
910             uint256 amount = bmul(ratio, bal);
911             amounts[i] = amount;
912         }
913     }
914 
915     /** 
916         @notice Get the address of the controller
917         @return The address of the pool
918     */
919     function getController() external view override returns(address) {
920         return lpbs().controller;
921     }
922 
923     /** 
924         @notice Get the address of the public swap setter
925         @return The public swap setter address
926     */
927     function getPublicSwapSetter() external view returns(address) {
928         return lpbs().publicSwapSetter;
929     }
930 
931     /**
932         @notice Get the address of the token binder
933         @return The token binder address
934     */
935     function getTokenBinder() external view returns(address) {
936         return lpbs().tokenBinder;
937     }
938 
939     /**
940         @notice Get if public swapping is enabled
941         @return If public swapping is enabled
942     */
943     function isPublicSwap() external view returns (bool) {
944         return lpbs().bPool.isPublicSwap();
945     }
946 
947     /**
948         @notice Get the current swap fee
949         @return The current swap fee
950     */
951     function getSwapFee() external view returns (uint256) {
952         return lpbs().bPool.getSwapFee();
953     }
954 
955     /**
956         @notice Get the address of the underlying Balancer pool
957         @return The address of the underlying balancer pool
958     */
959     function getBPool() external view returns(address) {
960         return address(lpbs().bPool);
961     }
962 
963     /**
964         @notice Pull the underlying token from an address and rebind it to the balancer pool
965         @param _token Address of the token to pull
966         @param _from Address to pull the token from
967         @param _amount Amount of token to pull
968         @param _tokenBalance Balance of the token already in the balancer pool
969     */
970     function _pullUnderlying(address _token, address _from, uint256 _amount, uint256 _tokenBalance)
971         internal
972     {   
973         IBPool bPool = lpbs().bPool;
974         // Gets current Balance of token i, Bi, and weight of token i, Wi, from BPool.
975         uint tokenWeight = bPool.getDenormalizedWeight(_token);
976 
977         bool xfer = IERC20(_token).transferFrom(_from, address(this), _amount);
978         require(xfer, "ERR_ERC20_FALSE");
979         bPool.rebind(_token, badd(_tokenBalance, _amount), tokenWeight);
980     }
981 
982     /** 
983         @notice Push a underlying token and rebind the token to the balancer pool
984         @param _token Address of the token to push
985         @param _to Address to pull the token to
986         @param _amount Amount of token to push
987         @param _tokenBalance Balance of the token already in the balancer pool
988     */
989     function _pushUnderlying(address _token, address _to, uint256 _amount, uint256 _tokenBalance)
990         internal
991     {   
992         IBPool bPool = lpbs().bPool;
993         // Gets current Balance of token i, Bi, and weight of token i, Wi, from BPool.
994         uint tokenWeight = bPool.getDenormalizedWeight(_token);
995         bPool.rebind(_token, bsub(_tokenBalance, _amount), tokenWeight);
996 
997         bool xfer = IERC20(_token).transfer(_to, _amount);
998         require(xfer, "ERR_ERC20_FALSE");
999     }
1000 
1001     /**
1002         @notice Pull pool shares
1003         @param _from Address to pull pool shares from
1004         @param _amount Amount of pool shares to pull
1005     */
1006     function _pullPoolShare(address _from, uint256 _amount)
1007         internal
1008     {
1009         _pull(_from, _amount);
1010     }
1011 
1012     /**
1013         @notice Burn pool shares
1014         @param _amount Amount of pool shares to burn
1015     */
1016     function _burnPoolShare(uint256 _amount)
1017         internal
1018     {
1019         _burn(_amount);
1020     }
1021 
1022     /** 
1023         @notice Mint pool shares 
1024         @param _amount Amount of pool shares to mint
1025     */
1026     function _mintPoolShare(uint256 _amount)
1027         internal
1028     {
1029         _mint(_amount);
1030     }
1031 
1032     /**
1033         @notice Push pool shares to account
1034         @param _to Address to push the pool shares to
1035         @param _amount Amount of pool shares to push
1036     */
1037     function _pushPoolShare(address _to, uint256 _amount)
1038         internal
1039     {
1040         _push(_to, _amount);
1041     }
1042 
1043     /**
1044         @notice Load PBasicPool storage
1045         @return s Pointer to the storage struct
1046     */
1047     function lpbs() internal pure returns (pbs storage s) {
1048         bytes32 loc = pbsSlot;
1049         assembly {
1050             s_slot := loc
1051         }
1052     }
1053 
1054 }
1055 
1056 
1057 // File contracts/smart-pools/PCappedSmartPool.sol
1058 
1059 pragma solidity ^0.6.4;
1060 
1061 contract PCappedSmartPool is PBasicSmartPool {
1062 
1063     bytes32 constant public pcsSlot = keccak256("PCappedSmartPool.storage.location");
1064 
1065     event CapChanged(address indexed setter, uint256 oldCap, uint256 newCap);
1066 
1067     struct pcs {
1068         uint256 cap;
1069     }
1070 
1071     modifier withinCap() {
1072         _;
1073         require(totalSupply() < lpcs().cap, "PCappedSmartPool.withinCap: Cap limit reached");
1074     }
1075 
1076     /**
1077         @notice Set the maximum cap of the contract
1078         @param _cap New cap in wei
1079     */
1080     function setCap(uint256 _cap) onlyController external {
1081         emit CapChanged(msg.sender, lpcs().cap, _cap);
1082         lpcs().cap = _cap;
1083     }
1084 
1085     /**
1086         @notice Takes underlying assets and mints smart pool tokens. Enforces the cap
1087         @param _amount Amount of pool tokens to mint
1088     */
1089     function joinPool(uint256 _amount) external override withinCap {
1090         super._joinPool(_amount);
1091     }
1092 
1093 
1094     /**
1095         @notice Get the current cap
1096         @return The current cap in wei
1097     */
1098     function getCap() external view returns(uint256) {
1099         return lpcs().cap;
1100     }
1101 
1102     /**
1103         @notice Load the PCappedSmartPool storage
1104         @return s Pointer to the storage struct
1105     */
1106     function lpcs() internal pure returns (pcs storage s) {
1107         bytes32 loc = pcsSlot;
1108         assembly {
1109             s_slot := loc
1110         }
1111     }
1112 
1113 }
1114 
1115 
1116 // File contracts/factory/PProxiedFactory.sol
1117 
1118 pragma solidity ^0.6.4;
1119 
1120 
1121 
1122 
1123 
1124 
1125 
1126 contract PProxiedFactory is Ownable {
1127 
1128     IBFactory public balancerFactory;
1129     address public smartPoolImplementation;
1130     mapping(address => bool) public isPool;
1131     address[] public pools;
1132 
1133     event SmartPoolCreated(address indexed poolAddress, string name, string symbol);
1134 
1135     function init(address _balancerFactory) public {
1136         require(smartPoolImplementation == address(0), "Already initialised");
1137         _setOwner(msg.sender);
1138         balancerFactory = IBFactory(_balancerFactory);
1139         
1140         PCappedSmartPool implementation = new PCappedSmartPool();
1141         // function init(address _bPool, string calldata _name, string calldata _symbol, uint256 _initialSupply) external {
1142         implementation.init(address(0), "IMPL", "IMPL", 1 ether);
1143         smartPoolImplementation = address(implementation);
1144     }
1145 
1146     function newProxiedSmartPool(
1147         string memory _name, 
1148         string memory _symbol,
1149         uint256 _initialSupply,
1150         address[] memory _tokens,
1151         uint256[] memory _amounts,
1152         uint256[] memory _weights,
1153         uint256 _cap
1154     ) public onlyOwner returns(address) {
1155         // Deploy proxy contract
1156         PProxyPausable proxy = new PProxyPausable();
1157         
1158         // Setup proxy
1159         proxy.setImplementation(smartPoolImplementation);
1160         proxy.setPauzer(msg.sender);
1161         proxy.setProxyOwner(msg.sender); 
1162         
1163         // Setup balancer pool
1164         address balancerPoolAddress = balancerFactory.newBPool();
1165         IBPool bPool = IBPool(balancerPoolAddress);
1166 
1167         for(uint256 i = 0; i < _tokens.length; i ++) {
1168             IERC20 token = IERC20(_tokens[i]);
1169             // Transfer tokens to this contract
1170             token.transferFrom(msg.sender, address(this), _amounts[i]);
1171             // Approve the balancer pool
1172             token.approve(balancerPoolAddress, uint256(-1));
1173             // Bind tokens
1174             bPool.bind(_tokens[i], _amounts[i], _weights[i]);
1175         }
1176         bPool.setController(address(proxy));
1177         
1178         // Setup smart pool
1179         PCappedSmartPool smartPool = PCappedSmartPool(address(proxy));
1180     
1181         smartPool.init(balancerPoolAddress, _name, _symbol, _initialSupply);
1182         smartPool.setCap(_cap);
1183         smartPool.setPublicSwapSetter(msg.sender);
1184         smartPool.setTokenBinder(msg.sender);
1185         smartPool.setController(msg.sender);
1186         smartPool.approveTokens();
1187         
1188         isPool[address(smartPool)] = true;
1189         pools.push(address(smartPool));
1190 
1191         emit SmartPoolCreated(address(smartPool), _name, _symbol);
1192 
1193         smartPool.transfer(msg.sender, _initialSupply);
1194 
1195         return address(smartPool);
1196     }
1197 
1198 }
1199 
1200 
1201 // File contracts/interfaces/IUniswapFactory.sol
1202 
1203 pragma solidity ^0.6.4;
1204 
1205 interface IUniswapFactory {
1206     // Create Exchange
1207     function createExchange(address token) external returns (address exchange);
1208     // Get Exchange and Token Info
1209     function getExchange(address token) external view returns (address exchange);
1210     function getToken(address exchange) external view returns (address token);
1211     function getTokenWithId(uint256 tokenId) external view returns (address token);
1212     // Never use
1213     function initializeFactory(address template) external;
1214 }
1215 
1216 
1217 // File contracts/interfaces/IUniswapExchange.sol
1218 
1219 pragma solidity ^0.6.4;
1220 
1221 interface IUniswapExchange {
1222     // Address of ERC20 token sold on this exchange
1223     function tokenAddress() external view returns (address token);
1224     // Address of Uniswap Factory
1225     function factoryAddress() external view returns (address factory);
1226     // Provide Liquidity
1227     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
1228     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
1229     // Get Prices
1230     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
1231     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
1232     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
1233     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
1234     // Trade ETH to ERC20
1235     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
1236     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
1237     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
1238     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
1239     // Trade ERC20 to ETH
1240     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
1241     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
1242     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
1243     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
1244     // Trade ERC20 to ERC20
1245     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
1246     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
1247     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
1248     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
1249     // Trade ERC20 to Custom Pool
1250     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
1251     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
1252     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
1253     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
1254     // ERC20 comaptibility for liquidity tokens
1255     // bytes32 public name;
1256     // bytes32 public symbol;
1257     // uint256 public decimals;
1258     function transfer(address _to, uint256 _value) external returns (bool);
1259     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
1260     function approve(address _spender, uint256 _value) external returns (bool);
1261     function allowance(address _owner, address _spender) external view returns (uint256);
1262     function balanceOf(address _owner) external view returns (uint256);
1263     function totalSupply() external view returns (uint256);
1264     // Never use
1265     function setup(address token_addr) external;
1266 }
1267 
1268 
1269 // File contracts/recipes/PUniswapPoolRecipe.sol
1270 
1271 pragma solidity ^0.6.4;
1272 
1273 
1274 
1275 
1276 
1277 // Takes ETH and mints smart pool tokens
1278 contract PUniswapPoolRecipe {
1279     
1280     bytes32 constant public uprSlot = keccak256("PUniswapPoolRecipe.storage.location");
1281 
1282     // Uniswap pool recipe struct
1283     struct uprs {
1284         IPSmartPool pool;
1285         IUniswapFactory uniswapFactory;
1286     }
1287 
1288     function init(address _pool, address _uniswapFactory) public virtual {
1289         uprs storage s = luprs();
1290         require(address(s.pool) == address(0), "already initialised");
1291         s.pool = IPSmartPool(_pool);
1292         s.uniswapFactory = IUniswapFactory(_uniswapFactory);
1293     }
1294 
1295     // Using same interface as Uniswap for compatibility
1296     function ethToTokenTransferOutput(uint256 _tokens_bought, uint256 _deadline, address _recipient) public payable returns (uint256  eth_sold) {
1297         uprs storage s = luprs();
1298         require(_deadline >= block.timestamp);
1299         (address[] memory tokens, uint256[] memory amounts) = s.pool.calcTokensForAmount(_tokens_bought);
1300 
1301         eth_sold = 0;
1302         // Buy and approve tokens
1303         for(uint256 i = 0; i < tokens.length; i ++) {
1304             eth_sold += _ethToToken(tokens[i], amounts[i]);
1305             IERC20(tokens[i]).approve(address(s.pool), uint256(-1));
1306         }
1307 
1308         // Calculate amount of eth sold
1309         eth_sold = msg.value - address(this).balance;
1310         // Send back excess eth
1311         msg.sender.transfer(address(this).balance);
1312 
1313         // Join pool
1314         s.pool.joinPool(_tokens_bought);
1315 
1316         // Send pool tokens to receiver
1317         s.pool.transfer(_recipient, s.pool.balanceOf(address(this)));
1318         return eth_sold;
1319     }
1320 
1321     function ethToTokenSwapOutput(uint256 _tokens_bought, uint256 _deadline) external payable returns (uint256 eth_sold) {
1322         return ethToTokenTransferOutput(_tokens_bought, _deadline, msg.sender);
1323     }
1324 
1325     function _ethToToken(address _token, uint256 _tokens_bought) internal virtual returns (uint256) {
1326         uprs storage s = luprs();
1327         IUniswapExchange exchange = IUniswapExchange(s.uniswapFactory.getExchange(_token));
1328         return exchange.ethToTokenSwapOutput{value: address(this).balance}(_tokens_bought, uint256(-1));
1329     }
1330 
1331     function getEthToTokenOutputPrice(uint256 _tokens_bought) external view virtual returns (uint256 eth_sold) {
1332         uprs storage s = luprs();
1333         (address[] memory tokens, uint256[] memory amounts) = s.pool.calcTokensForAmount(_tokens_bought);
1334 
1335         eth_sold = 0;
1336 
1337         for(uint256 i = 0; i < tokens.length; i ++) {
1338             IUniswapExchange exchange = IUniswapExchange(s.uniswapFactory.getExchange(tokens[i]));
1339             eth_sold += exchange.getEthToTokenOutputPrice(amounts[i]);
1340         }
1341 
1342         return eth_sold;
1343     }
1344 
1345     function tokenToEthTransferInput(uint256 _tokens_sold, uint256 _min_eth, uint256 _deadline, address _recipient) public returns (uint256 eth_bought) {
1346         uprs storage s = luprs();
1347         require(_deadline >= block.timestamp);
1348         require(s.pool.transferFrom(msg.sender, address(this), _tokens_sold), "PUniswapPoolRecipe.tokenToEthTransferInput: transferFrom failed");
1349 
1350         s.pool.exitPool(_tokens_sold);
1351 
1352         address[] memory tokens = s.pool.getTokens();
1353 
1354         uint256 ethAmount = 0;
1355 
1356         for(uint256 i = 0; i < tokens.length; i ++) {
1357             IERC20 token = IERC20(tokens[i]);
1358             
1359             uint256 balance = token.balanceOf(address(this));
1360            
1361             // Exchange for ETH
1362             ethAmount += _tokenToEth(token, balance, _recipient);
1363         }
1364 
1365         require(ethAmount > _min_eth, "PUniswapPoolRecipe.tokenToEthTransferInput: not enough ETH");
1366         return ethAmount;
1367     }
1368 
1369     function tokenToEthSwapInput(uint256 _tokens_sold, uint256 _min_eth, uint256 _deadline) external returns (uint256 eth_bought) {
1370         return tokenToEthTransferInput(_tokens_sold, _min_eth, _deadline, msg.sender);
1371     }
1372 
1373     function _tokenToEth(IERC20 _token, uint256 _tokens_sold, address _recipient) internal virtual returns (uint256 eth_bought) {
1374         uprs storage s = luprs();
1375         IUniswapExchange exchange = IUniswapExchange(s.uniswapFactory.getExchange(address(_token)));
1376         _token.approve(address(exchange), _tokens_sold);
1377         // Exchange for ETH
1378         return exchange.tokenToEthTransferInput(_tokens_sold, 1, uint256(-1), _recipient);
1379     }
1380 
1381     function getTokenToEthInputPrice(uint256 _tokens_sold) external view virtual returns (uint256 eth_bought) {
1382         uprs storage s = luprs();
1383         (address[] memory tokens, uint256[] memory amounts) = s.pool.calcTokensForAmount(_tokens_sold);
1384 
1385         eth_bought = 0;
1386 
1387         for(uint256 i = 0; i < tokens.length; i ++) {
1388             IUniswapExchange exchange = IUniswapExchange(s.uniswapFactory.getExchange(address(tokens[i])));
1389             eth_bought += exchange.getTokenToEthInputPrice(amounts[i]);
1390         }
1391 
1392         return eth_bought;
1393     }
1394 
1395     function pool() external view returns (address) {
1396         return address(luprs().pool);
1397     }
1398 
1399     receive() external payable {
1400 
1401     }
1402 
1403     // Load uniswap pool recipe
1404     function luprs() internal pure returns (uprs storage s) {
1405         bytes32 loc = uprSlot;
1406         assembly {
1407             s_slot := loc
1408         }
1409     }
1410 }
1411 
1412 
1413 // File contracts/interfaces/IKyberNetwork.sol
1414 
1415 pragma solidity ^0.6.4;
1416 
1417 interface IKyberNetwork {
1418 
1419     function trade(
1420         address src,
1421         uint srcAmount,
1422         address dest,
1423         address payable destAddress,
1424         uint maxDestAmount,
1425         uint minConversionRate,
1426         address walletId
1427     ) external payable returns(uint256);
1428 }
1429 
1430 
1431 // File contracts/recipes/PUniswapKyberPoolRecipe.sol
1432 
1433 pragma solidity ^0.6.4;
1434 
1435 
1436 
1437 
1438 contract PUniswapKyberPoolRecipe is PUniswapPoolRecipe, Ownable {
1439 
1440     bytes32 constant public ukprSlot = keccak256("PUniswapKyberPoolRecipe.storage.location");
1441 
1442     // Uniswap pool recipe struct
1443     struct ukprs {
1444         mapping(address => bool) swapOnKyber;
1445         IKyberNetwork kyber;
1446         address feeReceiver;
1447     }
1448 
1449     address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1450     
1451     function init(address, address) public override {
1452         require(false, "not enabled");
1453     }
1454 
1455     // Use seperate init function
1456     function initUK(address _pool, address _uniswapFactory, address _kyber, address[] memory _swapOnKyber, address _feeReciever) public {
1457         // UnsiwapRecipe enforces that init can only be called once
1458         ukprs storage s = lukprs();
1459 
1460         PUniswapPoolRecipe.init(_pool, _uniswapFactory);
1461         s.kyber = IKyberNetwork(_kyber);
1462         s.feeReceiver = _feeReciever;
1463 
1464         _setOwner(msg.sender);
1465 
1466         for(uint256 i = 0; i < _swapOnKyber.length; i ++) {
1467             s.swapOnKyber[_swapOnKyber[i]] = true;
1468         }
1469     }
1470 
1471     function setKyberSwap(address _token, bool _value) external onlyOwner {
1472         ukprs storage s = lukprs();
1473         s.swapOnKyber[_token] = _value;
1474     }
1475 
1476     function _ethToToken(address _token, uint256 _tokens_bought) internal override returns (uint256) {
1477         ukprs storage s = lukprs();
1478         if(!s.swapOnKyber[_token]) {
1479             return super._ethToToken(_token, _tokens_bought);
1480         }
1481 
1482         uint256 ethBefore = address(this).balance;
1483         s.kyber.trade{value: address(this).balance}(ETH, address(this).balance, _token, address(this), _tokens_bought, 1, s.feeReceiver);
1484         uint256 ethAfter = address(this).balance;
1485 
1486         // return amount of ETH spend
1487         return ethBefore - ethAfter;
1488     }
1489 
1490     function _tokenToEth(IERC20 _token, uint256 _tokens_sold, address _recipient) internal override returns (uint256 eth_bought) {
1491         ukprs storage s = lukprs();
1492         if(!s.swapOnKyber[address(_token)]) {
1493             return super._tokenToEth(_token, _tokens_sold, _recipient);
1494         }
1495 
1496         uint256 ethBefore = address(this).balance;
1497         _token.approve(address(s.kyber), uint256(-1));
1498         s.kyber.trade(address(_token), _tokens_sold, ETH, address(this), uint256(-1), 1, s.feeReceiver);
1499         uint256 ethAfter = address(this).balance;
1500 
1501         // return amount of ETH received
1502         return ethAfter - ethBefore;
1503     }
1504 
1505     // Load uniswap pool recipe
1506     function lukprs() internal pure returns (ukprs storage s) {
1507         bytes32 loc = ukprSlot;
1508         assembly {
1509             s_slot := loc
1510         }
1511     }
1512 
1513 }
1514 
1515 
1516 // File contracts/test/TestReentryProtection.sol
1517 
1518 pragma solidity ^0.6.4;
1519 
1520 
1521 contract TestReentryProtection is ReentryProtection {
1522 
1523     // This should fail
1524     function test() external noReentry {
1525         reenter();
1526     }
1527 
1528     function reenter() public noReentry {
1529         // Do nothing
1530     }
1531 
1532 }