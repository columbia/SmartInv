1 /**
2 
3 Deployed by Ren Project, https://renproject.io
4 
5 Commit hash: 1e106b3
6 Repository: https://github.com/renproject/gateway-sol
7 Issues: https://github.com/renproject/gateway-sol/issues
8 
9 Licenses
10 @openzeppelin/contracts: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/LICENSE
11 gateway-sol: https://github.com/renproject/gateway-sol/blob/master/LICENSE
12 
13 */
14 
15 pragma solidity ^0.5.16;
16 
17 
18 contract Initializable {
19 
20   
21   bool private initialized;
22 
23   
24   bool private initializing;
25 
26   
27   modifier initializer() {
28     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
29 
30     bool isTopLevelCall = !initializing;
31     if (isTopLevelCall) {
32       initializing = true;
33       initialized = true;
34     }
35 
36     _;
37 
38     if (isTopLevelCall) {
39       initializing = false;
40     }
41   }
42 
43   
44   function isConstructor() private view returns (bool) {
45     
46     
47     
48     
49     
50     address self = address(this);
51     uint256 cs;
52     assembly { cs := extcodesize(self) }
53     return cs == 0;
54   }
55 
56   
57   uint256[50] private ______gap;
58 }
59 
60 library SafeMath {
61     
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         require(c >= a, "SafeMath: addition overflow");
65 
66         return c;
67     }
68 
69     
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         return sub(a, b, "SafeMath: subtraction overflow");
72     }
73 
74     
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         
85         
86         
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93 
94         return c;
95     }
96 
97     
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         
108 
109         return c;
110     }
111 
112     
113     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114         return mod(a, b, "SafeMath: modulo by zero");
115     }
116 
117     
118     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b != 0, errorMessage);
120         return a % b;
121     }
122 }
123 
124 library ECDSA {
125     
126     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
127         
128         if (signature.length != 65) {
129             revert("ECDSA: signature length is invalid");
130         }
131 
132         
133         bytes32 r;
134         bytes32 s;
135         uint8 v;
136 
137         
138         
139         
140         assembly {
141             r := mload(add(signature, 0x20))
142             s := mload(add(signature, 0x40))
143             v := byte(0, mload(add(signature, 0x60)))
144         }
145 
146         
147         
148         
149         
150         
151         
152         
153         
154         
155         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
156             revert("ECDSA: signature.s is in the wrong range");
157         }
158 
159         if (v != 27 && v != 28) {
160             revert("ECDSA: signature.v is in the wrong range");
161         }
162 
163         
164         return ecrecover(hash, v, r, s);
165     }
166 
167     
168     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
169         
170         
171         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
172     }
173 }
174 
175 contract Proxy {
176   
177   function () payable external {
178     _fallback();
179   }
180 
181   
182   function _implementation() internal view returns (address);
183 
184   
185   function _delegate(address implementation) internal {
186     assembly {
187       
188       
189       
190       calldatacopy(0, 0, calldatasize)
191 
192       
193       
194       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
195 
196       
197       returndatacopy(0, 0, returndatasize)
198 
199       switch result
200       
201       case 0 { revert(0, returndatasize) }
202       default { return(0, returndatasize) }
203     }
204   }
205 
206   
207   function _willFallback() internal {
208   }
209 
210   
211   function _fallback() internal {
212     _willFallback();
213     _delegate(_implementation());
214   }
215 }
216 
217 library OpenZeppelinUpgradesAddress {
218     
219     function isContract(address account) internal view returns (bool) {
220         uint256 size;
221         
222         
223         
224         
225         
226         
227         
228         assembly { size := extcodesize(account) }
229         return size > 0;
230     }
231 }
232 
233 contract BaseUpgradeabilityProxy is Proxy {
234   
235   event Upgraded(address indexed implementation);
236 
237   
238   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
239 
240   
241   function _implementation() internal view returns (address impl) {
242     bytes32 slot = IMPLEMENTATION_SLOT;
243     assembly {
244       impl := sload(slot)
245     }
246   }
247 
248   
249   function _upgradeTo(address newImplementation) internal {
250     _setImplementation(newImplementation);
251     emit Upgraded(newImplementation);
252   }
253 
254   
255   function _setImplementation(address newImplementation) internal {
256     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
257 
258     bytes32 slot = IMPLEMENTATION_SLOT;
259 
260     assembly {
261       sstore(slot, newImplementation)
262     }
263   }
264 }
265 
266 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
267   
268   constructor(address _logic, bytes memory _data) public payable {
269     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
270     _setImplementation(_logic);
271     if(_data.length > 0) {
272       (bool success,) = _logic.delegatecall(_data);
273       require(success);
274     }
275   }  
276 }
277 
278 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
279   
280   event AdminChanged(address previousAdmin, address newAdmin);
281 
282   
283 
284   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
285 
286   
287   modifier ifAdmin() {
288     if (msg.sender == _admin()) {
289       _;
290     } else {
291       _fallback();
292     }
293   }
294 
295   
296   function admin() external ifAdmin returns (address) {
297     return _admin();
298   }
299 
300   
301   function implementation() external ifAdmin returns (address) {
302     return _implementation();
303   }
304 
305   
306   function changeAdmin(address newAdmin) external ifAdmin {
307     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
308     emit AdminChanged(_admin(), newAdmin);
309     _setAdmin(newAdmin);
310   }
311 
312   
313   function upgradeTo(address newImplementation) external ifAdmin {
314     _upgradeTo(newImplementation);
315   }
316 
317   
318   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
319     _upgradeTo(newImplementation);
320     (bool success,) = newImplementation.delegatecall(data);
321     require(success);
322   }
323 
324   
325   function _admin() internal view returns (address adm) {
326     bytes32 slot = ADMIN_SLOT;
327     assembly {
328       adm := sload(slot)
329     }
330   }
331 
332   
333   function _setAdmin(address newAdmin) internal {
334     bytes32 slot = ADMIN_SLOT;
335 
336     assembly {
337       sstore(slot, newAdmin)
338     }
339   }
340 
341   
342   function _willFallback() internal {
343     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
344     super._willFallback();
345   }
346 }
347 
348 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
349   
350   function initialize(address _logic, bytes memory _data) public payable {
351     require(_implementation() == address(0));
352     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
353     _setImplementation(_logic);
354     if(_data.length > 0) {
355       (bool success,) = _logic.delegatecall(_data);
356       require(success);
357     }
358   }  
359 }
360 
361 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
362   
363   function initialize(address _logic, address _admin, bytes memory _data) public payable {
364     require(_implementation() == address(0));
365     InitializableUpgradeabilityProxy.initialize(_logic, _data);
366     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
367     _setAdmin(_admin);
368   }
369 }
370 
371 contract Context is Initializable {
372     
373     
374     constructor () internal { }
375     
376 
377     function _msgSender() internal view returns (address payable) {
378         return msg.sender;
379     }
380 
381     function _msgData() internal view returns (bytes memory) {
382         this; 
383         return msg.data;
384     }
385 }
386 
387 contract Ownable is Initializable, Context {
388     address private _owner;
389 
390     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
391 
392     
393     function initialize(address sender) public initializer {
394         _owner = sender;
395         emit OwnershipTransferred(address(0), _owner);
396     }
397 
398     
399     function owner() public view returns (address) {
400         return _owner;
401     }
402 
403     
404     modifier onlyOwner() {
405         require(isOwner(), "Ownable: caller is not the owner");
406         _;
407     }
408 
409     
410     function isOwner() public view returns (bool) {
411         return _msgSender() == _owner;
412     }
413 
414     
415     function renounceOwnership() public onlyOwner {
416         emit OwnershipTransferred(_owner, address(0));
417         _owner = address(0);
418     }
419 
420     
421     function transferOwnership(address newOwner) public onlyOwner {
422         _transferOwnership(newOwner);
423     }
424 
425     
426     function _transferOwnership(address newOwner) internal {
427         require(newOwner != address(0), "Ownable: new owner is the zero address");
428         emit OwnershipTransferred(_owner, newOwner);
429         _owner = newOwner;
430     }
431 
432     uint256[50] private ______gap;
433 }
434 
435 contract Claimable is Initializable, Ownable {
436     address public pendingOwner;
437 
438     function initialize(address _nextOwner) public initializer {
439         Ownable.initialize(_nextOwner);
440     }
441 
442     modifier onlyPendingOwner() {
443         require(
444             _msgSender() == pendingOwner,
445             "Claimable: caller is not the pending owner"
446         );
447         _;
448     }
449 
450     function transferOwnership(address newOwner) public onlyOwner {
451         require(
452             newOwner != owner() && newOwner != pendingOwner,
453             "Claimable: invalid new owner"
454         );
455         pendingOwner = newOwner;
456     }
457 
458     function claimOwnership() public onlyPendingOwner {
459         _transferOwnership(pendingOwner);
460         delete pendingOwner;
461     }
462 }
463 
464 library String {
465     
466     
467     function fromUint(uint256 _i) internal pure returns (string memory) {
468         if (_i == 0) {
469             return "0";
470         }
471         uint256 j = _i;
472         uint256 len;
473         while (j != 0) {
474             len++;
475             j /= 10;
476         }
477         bytes memory bstr = new bytes(len);
478         uint256 k = len - 1;
479         while (_i != 0) {
480             bstr[k--] = bytes1(uint8(48 + (_i % 10)));
481             _i /= 10;
482         }
483         return string(bstr);
484     }
485 
486     
487     function fromBytes32(bytes32 _value) internal pure returns (string memory) {
488         bytes memory alphabet = "0123456789abcdef";
489 
490         bytes memory str = new bytes(32 * 2 + 2);
491         str[0] = "0";
492         str[1] = "x";
493         for (uint256 i = 0; i < 32; i++) {
494             str[2 + i * 2] = alphabet[uint256(uint8(_value[i] >> 4))];
495             str[3 + i * 2] = alphabet[uint256(uint8(_value[i] & 0x0f))];
496         }
497         return string(str);
498     }
499 
500     
501     function fromAddress(address _addr) internal pure returns (string memory) {
502         bytes32 value = bytes32(uint256(_addr));
503         bytes memory alphabet = "0123456789abcdef";
504 
505         bytes memory str = new bytes(20 * 2 + 2);
506         str[0] = "0";
507         str[1] = "x";
508         for (uint256 i = 0; i < 20; i++) {
509             str[2 + i * 2] = alphabet[uint256(uint8(value[i + 12] >> 4))];
510             str[3 + i * 2] = alphabet[uint256(uint8(value[i + 12] & 0x0f))];
511         }
512         return string(str);
513     }
514 
515     
516     function add8(
517         string memory a,
518         string memory b,
519         string memory c,
520         string memory d,
521         string memory e,
522         string memory f,
523         string memory g,
524         string memory h
525     ) internal pure returns (string memory) {
526         return string(abi.encodePacked(a, b, c, d, e, f, g, h));
527     }
528 }
529 
530 interface IERC20 {
531     
532     function totalSupply() external view returns (uint256);
533 
534     
535     function balanceOf(address account) external view returns (uint256);
536 
537     
538     function transfer(address recipient, uint256 amount) external returns (bool);
539 
540     
541     function allowance(address owner, address spender) external view returns (uint256);
542 
543     
544     function approve(address spender, uint256 amount) external returns (bool);
545 
546     
547     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
548 
549     
550     event Transfer(address indexed from, address indexed to, uint256 value);
551 
552     
553     event Approval(address indexed owner, address indexed spender, uint256 value);
554 }
555 
556 contract ERC20 is Initializable, Context, IERC20 {
557     using SafeMath for uint256;
558 
559     mapping (address => uint256) private _balances;
560 
561     mapping (address => mapping (address => uint256)) private _allowances;
562 
563     uint256 private _totalSupply;
564 
565     
566     function totalSupply() public view returns (uint256) {
567         return _totalSupply;
568     }
569 
570     
571     function balanceOf(address account) public view returns (uint256) {
572         return _balances[account];
573     }
574 
575     
576     function transfer(address recipient, uint256 amount) public returns (bool) {
577         _transfer(_msgSender(), recipient, amount);
578         return true;
579     }
580 
581     
582     function allowance(address owner, address spender) public view returns (uint256) {
583         return _allowances[owner][spender];
584     }
585 
586     
587     function approve(address spender, uint256 amount) public returns (bool) {
588         _approve(_msgSender(), spender, amount);
589         return true;
590     }
591 
592     
593     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
594         _transfer(sender, recipient, amount);
595         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
596         return true;
597     }
598 
599     
600     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
601         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
602         return true;
603     }
604 
605     
606     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
607         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
608         return true;
609     }
610 
611     
612     function _transfer(address sender, address recipient, uint256 amount) internal {
613         require(sender != address(0), "ERC20: transfer from the zero address");
614         require(recipient != address(0), "ERC20: transfer to the zero address");
615 
616         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
617         _balances[recipient] = _balances[recipient].add(amount);
618         emit Transfer(sender, recipient, amount);
619     }
620 
621     
622     function _mint(address account, uint256 amount) internal {
623         require(account != address(0), "ERC20: mint to the zero address");
624 
625         _totalSupply = _totalSupply.add(amount);
626         _balances[account] = _balances[account].add(amount);
627         emit Transfer(address(0), account, amount);
628     }
629 
630     
631     function _burn(address account, uint256 amount) internal {
632         require(account != address(0), "ERC20: burn from the zero address");
633 
634         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
635         _totalSupply = _totalSupply.sub(amount);
636         emit Transfer(account, address(0), amount);
637     }
638 
639     
640     function _approve(address owner, address spender, uint256 amount) internal {
641         require(owner != address(0), "ERC20: approve from the zero address");
642         require(spender != address(0), "ERC20: approve to the zero address");
643 
644         _allowances[owner][spender] = amount;
645         emit Approval(owner, spender, amount);
646     }
647 
648     
649     function _burnFrom(address account, uint256 amount) internal {
650         _burn(account, amount);
651         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
652     }
653 
654     uint256[50] private ______gap;
655 }
656 
657 contract ERC20Detailed is Initializable, IERC20 {
658     string private _name;
659     string private _symbol;
660     uint8 private _decimals;
661 
662     
663     function initialize(string memory name, string memory symbol, uint8 decimals) public initializer {
664         _name = name;
665         _symbol = symbol;
666         _decimals = decimals;
667     }
668 
669     
670     function name() public view returns (string memory) {
671         return _name;
672     }
673 
674     
675     function symbol() public view returns (string memory) {
676         return _symbol;
677     }
678 
679     
680     function decimals() public view returns (uint8) {
681         return _decimals;
682     }
683 
684     uint256[50] private ______gap;
685 }
686 
687 library Address {
688     
689     function isContract(address account) internal view returns (bool) {
690         
691         
692         
693         bytes32 codehash;
694         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
695         
696         assembly { codehash := extcodehash(account) }
697         return (codehash != accountHash && codehash != 0x0);
698     }
699 
700     
701     function toPayable(address account) internal pure returns (address payable) {
702         return address(uint160(account));
703     }
704 
705     
706     function sendValue(address payable recipient, uint256 amount) internal {
707         require(address(this).balance >= amount, "Address: insufficient balance");
708 
709         
710         (bool success, ) = recipient.call.value(amount)("");
711         require(success, "Address: unable to send value, recipient may have reverted");
712     }
713 }
714 
715 library SafeERC20 {
716     using SafeMath for uint256;
717     using Address for address;
718 
719     function safeTransfer(IERC20 token, address to, uint256 value) internal {
720         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
721     }
722 
723     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
724         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
725     }
726 
727     function safeApprove(IERC20 token, address spender, uint256 value) internal {
728         
729         
730         
731         
732         require((value == 0) || (token.allowance(address(this), spender) == 0),
733             "SafeERC20: approve from non-zero to non-zero allowance"
734         );
735         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
736     }
737 
738     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
739         uint256 newAllowance = token.allowance(address(this), spender).add(value);
740         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
741     }
742 
743     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
744         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
745         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
746     }
747 
748     
749     function callOptionalReturn(IERC20 token, bytes memory data) private {
750         
751         
752 
753         
754         
755         
756         
757         
758         require(address(token).isContract(), "SafeERC20: call to non-contract");
759 
760         
761         (bool success, bytes memory returndata) = address(token).call(data);
762         require(success, "SafeERC20: low-level call failed");
763 
764         if (returndata.length > 0) { 
765             
766             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
767         }
768     }
769 }
770 
771 contract CanReclaimTokens is Claimable {
772     using SafeERC20 for ERC20;
773 
774     mapping(address => bool) private recoverableTokensBlacklist;
775 
776     function initialize(address _nextOwner) public initializer {
777         Claimable.initialize(_nextOwner);
778     }
779 
780     function blacklistRecoverableToken(address _token) public onlyOwner {
781         recoverableTokensBlacklist[_token] = true;
782     }
783 
784     
785     
786     function recoverTokens(address _token) external onlyOwner {
787         require(
788             !recoverableTokensBlacklist[_token],
789             "CanReclaimTokens: token is not recoverable"
790         );
791 
792         if (_token == address(0x0)) {
793             msg.sender.transfer(address(this).balance);
794         } else {
795             ERC20(_token).safeTransfer(
796                 msg.sender,
797                 ERC20(_token).balanceOf(address(this))
798             );
799         }
800     }
801 }
802 
803 contract ERC20WithRate is Initializable, Ownable, ERC20 {
804     using SafeMath for uint256;
805 
806     uint256 public constant _rateScale = 1e18;
807     uint256 internal _rate;
808 
809     event LogRateChanged(uint256 indexed _rate);
810 
811     
812     function initialize(address _nextOwner, uint256 _initialRate)
813         public
814         initializer
815     {
816         Ownable.initialize(_nextOwner);
817         _setRate(_initialRate);
818     }
819 
820     function setExchangeRate(uint256 _nextRate) public onlyOwner {
821         _setRate(_nextRate);
822     }
823 
824     function exchangeRateCurrent() public view returns (uint256) {
825         require(_rate != 0, "ERC20WithRate: rate has not been initialized");
826         return _rate;
827     }
828 
829     function _setRate(uint256 _nextRate) internal {
830         require(_nextRate > 0, "ERC20WithRate: rate must be greater than zero");
831         _rate = _nextRate;
832     }
833 
834     function balanceOfUnderlying(address _account)
835         public
836         view
837         returns (uint256)
838     {
839         return toUnderlying(balanceOf(_account));
840     }
841 
842     function toUnderlying(uint256 _amount) public view returns (uint256) {
843         return _amount.mul(_rate).div(_rateScale);
844     }
845 
846     function fromUnderlying(uint256 _amountUnderlying)
847         public
848         view
849         returns (uint256)
850     {
851         return _amountUnderlying.mul(_rateScale).div(_rate);
852     }
853 }
854 
855 contract ERC20WithPermit is Initializable, ERC20, ERC20Detailed {
856     using SafeMath for uint256;
857 
858     mapping(address => uint256) public nonces;
859 
860     
861     
862     string public version;
863 
864     
865     bytes32 public DOMAIN_SEPARATOR;
866     
867     
868     bytes32
869         public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
870 
871     function initialize(
872         uint256 _chainId,
873         string memory _version,
874         string memory _name,
875         string memory _symbol,
876         uint8 _decimals
877     ) public initializer {
878         ERC20Detailed.initialize(_name, _symbol, _decimals);
879         version = _version;
880         DOMAIN_SEPARATOR = keccak256(
881             abi.encode(
882                 keccak256(
883                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
884                 ),
885                 keccak256(bytes(name())),
886                 keccak256(bytes(version)),
887                 _chainId,
888                 address(this)
889             )
890         );
891     }
892 
893     
894     function permit(
895         address holder,
896         address spender,
897         uint256 nonce,
898         uint256 expiry,
899         bool allowed,
900         uint8 v,
901         bytes32 r,
902         bytes32 s
903     ) external {
904         bytes32 digest = keccak256(
905             abi.encodePacked(
906                 "\x19\x01",
907                 DOMAIN_SEPARATOR,
908                 keccak256(
909                     abi.encode(
910                         PERMIT_TYPEHASH,
911                         holder,
912                         spender,
913                         nonce,
914                         expiry,
915                         allowed
916                     )
917                 )
918             )
919         );
920 
921         require(holder != address(0), "ERC20WithRate: address must not be 0x0");
922         require(
923             holder == ecrecover(digest, v, r, s),
924             "ERC20WithRate: invalid signature"
925         );
926         require(
927             expiry == 0 || now <= expiry,
928             "ERC20WithRate: permit has expired"
929         );
930         require(nonce == nonces[holder]++, "ERC20WithRate: invalid nonce");
931         uint256 amount = allowed ? uint256(-1) : 0;
932         _approve(holder, spender, amount);
933     }
934 }
935 
936 contract RenERC20LogicV1 is
937     Initializable,
938     ERC20,
939     ERC20Detailed,
940     ERC20WithRate,
941     ERC20WithPermit,
942     Claimable,
943     CanReclaimTokens
944 {
945     
946     function initialize(
947         uint256 _chainId,
948         address _nextOwner,
949         uint256 _initialRate,
950         string memory _version,
951         string memory _name,
952         string memory _symbol,
953         uint8 _decimals
954     ) public initializer {
955         ERC20Detailed.initialize(_name, _symbol, _decimals);
956         ERC20WithRate.initialize(_nextOwner, _initialRate);
957         ERC20WithPermit.initialize(
958             _chainId,
959             _version,
960             _name,
961             _symbol,
962             _decimals
963         );
964         Claimable.initialize(_nextOwner);
965         CanReclaimTokens.initialize(_nextOwner);
966     }
967 
968     
969     
970     function mint(address _to, uint256 _amount) public onlyOwner {
971         _mint(_to, _amount);
972     }
973 
974     
975     
976     function burn(address _from, uint256 _amount) public onlyOwner {
977         _burn(_from, _amount);
978     }
979 
980     function transfer(address recipient, uint256 amount) public returns (bool) {
981         
982         
983         
984         require(
985             recipient != address(this),
986             "RenERC20: can't transfer to token address"
987         );
988         return super.transfer(recipient, amount);
989     }
990 
991     function transferFrom(
992         address sender,
993         address recipient,
994         uint256 amount
995     ) public returns (bool) {
996         
997         
998         require(
999             recipient != address(this),
1000             "RenERC20: can't transfer to token address"
1001         );
1002         return super.transferFrom(sender, recipient, amount);
1003     }
1004 }
1005 
1006 contract RenERC20Proxy is InitializableAdminUpgradeabilityProxy {
1007 
1008 }
1009 
1010 interface IMintGateway {
1011     function mint(
1012         bytes32 _pHash,
1013         uint256 _amount,
1014         bytes32 _nHash,
1015         bytes calldata _sig
1016     ) external returns (uint256);
1017 
1018     function mintFee() external view returns (uint256);
1019 }
1020 
1021 interface IBurnGateway {
1022     function burn(bytes calldata _to, uint256 _amountScaled)
1023         external
1024         returns (uint256);
1025 
1026     function burnFee() external view returns (uint256);
1027 }
1028 
1029 interface IGateway {
1030     
1031     function mint(
1032         bytes32 _pHash,
1033         uint256 _amount,
1034         bytes32 _nHash,
1035         bytes calldata _sig
1036     ) external returns (uint256);
1037 
1038     function mintFee() external view returns (uint256);
1039 
1040     
1041     function burn(bytes calldata _to, uint256 _amountScaled)
1042         external
1043         returns (uint256);
1044 
1045     function burnFee() external view returns (uint256);
1046 }
1047 
1048 contract GatewayStateV1 {
1049     uint256 constant BIPS_DENOMINATOR = 10000;
1050     uint256 public minimumBurnAmount;
1051 
1052     
1053     RenERC20LogicV1 public token;
1054 
1055     
1056     address public mintAuthority;
1057 
1058     
1059     
1060     
1061     
1062     address public feeRecipient;
1063 
1064     
1065     uint16 public mintFee;
1066 
1067     
1068     uint16 public burnFee;
1069 
1070     
1071     mapping(bytes32 => bool) public status;
1072 
1073     
1074     
1075     uint256 public nextN = 0;
1076 }
1077 
1078 contract GatewayStateV2 {
1079     struct Burn {
1080         uint256 _blocknumber;
1081         bytes _to;
1082         uint256 _amount;
1083         
1084         string _chain;
1085         bytes _payload;
1086     }
1087 
1088     mapping(uint256 => Burn) internal burns;
1089 
1090     bytes32 public selectorHash;
1091 }
1092 
1093 contract MintGatewayLogicV1 is
1094     Initializable,
1095     Claimable,
1096     CanReclaimTokens,
1097     IGateway,
1098     GatewayStateV1,
1099     GatewayStateV2
1100 {
1101     using SafeMath for uint256;
1102 
1103     event LogMintAuthorityUpdated(address indexed _newMintAuthority);
1104     event LogMint(
1105         address indexed _to,
1106         uint256 _amount,
1107         uint256 indexed _n,
1108         bytes32 indexed _nHash
1109     );
1110     event LogBurn(
1111         bytes _to,
1112         uint256 _amount,
1113         uint256 indexed _n,
1114         bytes indexed _indexedTo
1115     );
1116 
1117     
1118     modifier onlyOwnerOrMintAuthority() {
1119         require(
1120             msg.sender == mintAuthority || msg.sender == owner(),
1121             "MintGateway: caller is not the owner or mint authority"
1122         );
1123         _;
1124     }
1125 
1126     
1127     
1128     
1129     
1130     
1131     
1132     
1133     
1134     function initialize(
1135         RenERC20LogicV1 _token,
1136         address _feeRecipient,
1137         address _mintAuthority,
1138         uint16 _mintFee,
1139         uint16 _burnFee,
1140         uint256 _minimumBurnAmount
1141     ) public initializer {
1142         Claimable.initialize(msg.sender);
1143         CanReclaimTokens.initialize(msg.sender);
1144         minimumBurnAmount = _minimumBurnAmount;
1145         token = _token;
1146         mintFee = _mintFee;
1147         burnFee = _burnFee;
1148         updateMintAuthority(_mintAuthority);
1149         updateFeeRecipient(_feeRecipient);
1150     }
1151 
1152     
1153     
1154     
1155     function updateSelectorHash(bytes32 _selectorHash) public onlyOwner {
1156         selectorHash = _selectorHash;
1157     }
1158 
1159     
1160 
1161     
1162     
1163     
1164     function claimTokenOwnership() public {
1165         token.claimOwnership();
1166     }
1167 
1168     
1169     function transferTokenOwnership(MintGatewayLogicV1 _nextTokenOwner)
1170         public
1171         onlyOwner
1172     {
1173         token.transferOwnership(address(_nextTokenOwner));
1174         _nextTokenOwner.claimTokenOwnership();
1175     }
1176 
1177     
1178     
1179     
1180     function updateMintAuthority(address _nextMintAuthority)
1181         public
1182         onlyOwnerOrMintAuthority
1183     {
1184         
1185         
1186         require(
1187             _nextMintAuthority != address(0),
1188             "MintGateway: mintAuthority cannot be set to address zero"
1189         );
1190         mintAuthority = _nextMintAuthority;
1191         emit LogMintAuthorityUpdated(mintAuthority);
1192     }
1193 
1194     
1195     
1196     
1197     function updateMinimumBurnAmount(uint256 _minimumBurnAmount)
1198         public
1199         onlyOwner
1200     {
1201         minimumBurnAmount = _minimumBurnAmount;
1202     }
1203 
1204     
1205     
1206     
1207     function updateFeeRecipient(address _nextFeeRecipient) public onlyOwner {
1208         
1209         require(
1210             _nextFeeRecipient != address(0x0),
1211             "MintGateway: fee recipient cannot be 0x0"
1212         );
1213 
1214         feeRecipient = _nextFeeRecipient;
1215     }
1216 
1217     
1218     
1219     
1220     function updateMintFee(uint16 _nextMintFee) public onlyOwner {
1221         mintFee = _nextMintFee;
1222     }
1223 
1224     
1225     
1226     
1227     function updateBurnFee(uint16 _nextBurnFee) public onlyOwner {
1228         burnFee = _nextBurnFee;
1229     }
1230 
1231     
1232     
1233     
1234     
1235     
1236     
1237     
1238     
1239     
1240     
1241     function mint(
1242         bytes32 _pHash,
1243         uint256 _amountUnderlying,
1244         bytes32 _nHash,
1245         bytes memory _sig
1246     ) public returns (uint256) {
1247         
1248         bytes32 sigHash = hashForSignature(
1249             _pHash,
1250             _amountUnderlying,
1251             msg.sender,
1252             _nHash
1253         );
1254         require(
1255             status[sigHash] == false,
1256             "MintGateway: nonce hash already spent"
1257         );
1258         if (!verifySignature(sigHash, _sig)) {
1259             
1260             
1261             
1262             revert(
1263                 String.add8(
1264                     "MintGateway: invalid signature. pHash: ",
1265                     String.fromBytes32(_pHash),
1266                     ", amount: ",
1267                     String.fromUint(_amountUnderlying),
1268                     ", msg.sender: ",
1269                     String.fromAddress(msg.sender),
1270                     ", _nHash: ",
1271                     String.fromBytes32(_nHash)
1272                 )
1273             );
1274         }
1275         status[sigHash] = true;
1276 
1277         uint256 amountScaled = token.fromUnderlying(_amountUnderlying);
1278 
1279         
1280         uint256 absoluteFeeScaled = amountScaled.mul(mintFee).div(
1281             BIPS_DENOMINATOR
1282         );
1283         uint256 receivedAmountScaled = amountScaled.sub(
1284             absoluteFeeScaled,
1285             "MintGateway: fee exceeds amount"
1286         );
1287 
1288         
1289         token.mint(msg.sender, receivedAmountScaled);
1290         
1291         token.mint(feeRecipient, absoluteFeeScaled);
1292 
1293         
1294         uint256 receivedAmountUnderlying = token.toUnderlying(
1295             receivedAmountScaled
1296         );
1297         emit LogMint(msg.sender, receivedAmountUnderlying, nextN, _nHash);
1298         nextN += 1;
1299 
1300         return receivedAmountScaled;
1301     }
1302 
1303     
1304     
1305     
1306     
1307     
1308     
1309     
1310     
1311     
1312     
1313     function burn(bytes memory _to, uint256 _amount) public returns (uint256) {
1314         
1315         
1316         require(_to.length != 0, "MintGateway: to address is empty");
1317 
1318         
1319         uint256 fee = _amount.mul(burnFee).div(BIPS_DENOMINATOR);
1320         uint256 amountAfterFee = _amount.sub(
1321             fee,
1322             "MintGateway: fee exceeds amount"
1323         );
1324 
1325         
1326         
1327         
1328         uint256 amountAfterFeeUnderlying = token.toUnderlying(amountAfterFee);
1329 
1330         
1331         token.burn(msg.sender, _amount);
1332         token.mint(feeRecipient, fee);
1333 
1334         require(
1335             
1336             
1337             amountAfterFeeUnderlying > minimumBurnAmount,
1338             "MintGateway: amount is less than the minimum burn amount"
1339         );
1340 
1341         emit LogBurn(_to, amountAfterFeeUnderlying, nextN, _to);
1342         bytes memory payload;
1343         GatewayStateV2.burns[nextN] = Burn({
1344             _blocknumber: block.number,
1345             _to: _to,
1346             _amount: amountAfterFeeUnderlying,
1347             _chain: "",
1348             _payload: payload
1349         });
1350 
1351         nextN += 1;
1352 
1353         return amountAfterFeeUnderlying;
1354     }
1355 
1356     function getBurn(uint256 _n)
1357         public
1358         view
1359         returns (
1360             uint256 _blocknumber,
1361             bytes memory _to,
1362             uint256 _amount,
1363             
1364             string memory _chain,
1365             bytes memory _payload
1366         )
1367     {
1368         Burn memory burnStruct = GatewayStateV2.burns[_n];
1369         require(burnStruct._to.length > 0, "MintGateway: burn not found");
1370         return (
1371             burnStruct._blocknumber,
1372             burnStruct._to,
1373             burnStruct._amount,
1374             burnStruct._chain,
1375             burnStruct._payload
1376         );
1377     }
1378 
1379     
1380     
1381     function verifySignature(bytes32 _sigHash, bytes memory _sig)
1382         public
1383         view
1384         returns (bool)
1385     {
1386         return mintAuthority == ECDSA.recover(_sigHash, _sig);
1387     }
1388 
1389     
1390     function hashForSignature(
1391         bytes32 _pHash,
1392         uint256 _amount,
1393         address _to,
1394         bytes32 _nHash
1395     ) public view returns (bytes32) {
1396         return
1397             keccak256(abi.encode(_pHash, _amount, selectorHash, _to, _nHash));
1398     }
1399 }
1400 
1401 contract MintGatewayProxy is InitializableAdminUpgradeabilityProxy {
1402 
1403 }