1 /**
2 
3 Deployed by Ren Project, https://renproject.io
4 
5 Commit hash: 9068f80
6 Repository: https://github.com/renproject/darknode-sol
7 Issues: https://github.com/renproject/darknode-sol/issues
8 
9 Licenses
10 @openzeppelin/contracts: (MIT) https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/LICENSE
11 darknode-sol: (GNU GPL V3) https://github.com/renproject/darknode-sol/blob/master/LICENSE
12 
13 */
14 
15 pragma solidity 0.5.16;
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
693 
694         
695         
696         
697         bytes32 codehash;
698         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
699         
700         assembly { codehash := extcodehash(account) }
701         return (codehash != 0x0 && codehash != accountHash);
702     }
703 
704     
705     function toPayable(address account) internal pure returns (address payable) {
706         return address(uint160(account));
707     }
708 
709     
710     function sendValue(address payable recipient, uint256 amount) internal {
711         require(address(this).balance >= amount, "Address: insufficient balance");
712 
713         
714         (bool success, ) = recipient.call.value(amount)("");
715         require(success, "Address: unable to send value, recipient may have reverted");
716     }
717 }
718 
719 library SafeERC20 {
720     using SafeMath for uint256;
721     using Address for address;
722 
723     function safeTransfer(IERC20 token, address to, uint256 value) internal {
724         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
725     }
726 
727     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
728         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
729     }
730 
731     function safeApprove(IERC20 token, address spender, uint256 value) internal {
732         
733         
734         
735         
736         require((value == 0) || (token.allowance(address(this), spender) == 0),
737             "SafeERC20: approve from non-zero to non-zero allowance"
738         );
739         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
740     }
741 
742     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
743         uint256 newAllowance = token.allowance(address(this), spender).add(value);
744         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
745     }
746 
747     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
748         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
749         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
750     }
751 
752     
753     function callOptionalReturn(IERC20 token, bytes memory data) private {
754         
755         
756 
757         
758         
759         
760         
761         
762         require(address(token).isContract(), "SafeERC20: call to non-contract");
763 
764         
765         (bool success, bytes memory returndata) = address(token).call(data);
766         require(success, "SafeERC20: low-level call failed");
767 
768         if (returndata.length > 0) { 
769             
770             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
771         }
772     }
773 }
774 
775 contract CanReclaimTokens is Claimable {
776     using SafeERC20 for ERC20;
777 
778     mapping(address => bool) private recoverableTokensBlacklist;
779 
780     function initialize(address _nextOwner) public initializer {
781         Claimable.initialize(_nextOwner);
782     }
783 
784     function blacklistRecoverableToken(address _token) public onlyOwner {
785         recoverableTokensBlacklist[_token] = true;
786     }
787 
788     
789     
790     function recoverTokens(address _token) external onlyOwner {
791         require(
792             !recoverableTokensBlacklist[_token],
793             "CanReclaimTokens: token is not recoverable"
794         );
795 
796         if (_token == address(0x0)) {
797             msg.sender.transfer(address(this).balance);
798         } else {
799             ERC20(_token).safeTransfer(
800                 msg.sender,
801                 ERC20(_token).balanceOf(address(this))
802             );
803         }
804     }
805 }
806 
807 contract ERC20WithRate is Initializable, Ownable, ERC20 {
808     using SafeMath for uint256;
809 
810     uint256 public constant _rateScale = 1e18;
811     uint256 internal _rate;
812 
813     event LogRateChanged(uint256 indexed _rate);
814 
815     
816     function initialize(address _nextOwner, uint256 _initialRate)
817         public
818         initializer
819     {
820         Ownable.initialize(_nextOwner);
821         _setRate(_initialRate);
822     }
823 
824     function setExchangeRate(uint256 _nextRate) public onlyOwner {
825         _setRate(_nextRate);
826     }
827 
828     function exchangeRateCurrent() public view returns (uint256) {
829         require(_rate != 0, "ERC20WithRate: rate has not been initialized");
830         return _rate;
831     }
832 
833     function _setRate(uint256 _nextRate) internal {
834         require(_nextRate > 0, "ERC20WithRate: rate must be greater than zero");
835         _rate = _nextRate;
836     }
837 
838     function balanceOfUnderlying(address _account)
839         public
840         view
841         returns (uint256)
842     {
843         return toUnderlying(balanceOf(_account));
844     }
845 
846     function toUnderlying(uint256 _amount) public view returns (uint256) {
847         return _amount.mul(_rate).div(_rateScale);
848     }
849 
850     function fromUnderlying(uint256 _amountUnderlying)
851         public
852         view
853         returns (uint256)
854     {
855         return _amountUnderlying.mul(_rateScale).div(_rate);
856     }
857 }
858 
859 contract ERC20WithPermit is Initializable, ERC20, ERC20Detailed {
860     using SafeMath for uint256;
861 
862     mapping(address => uint256) public nonces;
863 
864     
865     
866     string public version;
867 
868     
869     bytes32 public DOMAIN_SEPARATOR;
870     
871     
872     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
873 
874     function initialize(
875         uint256 _chainId,
876         string memory _version,
877         string memory _name,
878         string memory _symbol,
879         uint8 _decimals
880     ) public initializer {
881         ERC20Detailed.initialize(_name, _symbol, _decimals);
882         version = _version;
883         DOMAIN_SEPARATOR = keccak256(
884             abi.encode(
885                 keccak256(
886                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
887                 ),
888                 keccak256(bytes(name())),
889                 keccak256(bytes(version)),
890                 _chainId,
891                 address(this)
892             )
893         );
894     }
895 
896     
897     function permit(
898         address holder,
899         address spender,
900         uint256 nonce,
901         uint256 expiry,
902         bool allowed,
903         uint8 v,
904         bytes32 r,
905         bytes32 s
906     ) external {
907         bytes32 digest = keccak256(
908             abi.encodePacked(
909                 "\x19\x01",
910                 DOMAIN_SEPARATOR,
911                 keccak256(
912                     abi.encode(
913                         PERMIT_TYPEHASH,
914                         holder,
915                         spender,
916                         nonce,
917                         expiry,
918                         allowed
919                     )
920                 )
921             )
922         );
923 
924         require(holder != address(0), "ERC20WithRate: address must not be 0x0");
925         require(
926             holder == ecrecover(digest, v, r, s),
927             "ERC20WithRate: invalid signature"
928         );
929         require(
930             expiry == 0 || now <= expiry,
931             "ERC20WithRate: permit has expired"
932         );
933         require(nonce == nonces[holder]++, "ERC20WithRate: invalid nonce");
934         uint256 amount = allowed ? uint256(-1) : 0;
935         _approve(holder, spender, amount);
936     }
937 }
938 
939 contract RenERC20LogicV1 is
940     Initializable,
941     ERC20,
942     ERC20Detailed,
943     ERC20WithRate,
944     ERC20WithPermit,
945     Claimable,
946     CanReclaimTokens
947 {
948     
949     function initialize(
950         uint256 _chainId,
951         address _nextOwner,
952         uint256 _initialRate,
953         string memory _version,
954         string memory _name,
955         string memory _symbol,
956         uint8 _decimals
957     ) public initializer {
958         ERC20Detailed.initialize(_name, _symbol, _decimals);
959         ERC20WithRate.initialize(_nextOwner, _initialRate);
960         ERC20WithPermit.initialize(
961             _chainId,
962             _version,
963             _name,
964             _symbol,
965             _decimals
966         );
967         Claimable.initialize(_nextOwner);
968         CanReclaimTokens.initialize(_nextOwner);
969     }
970 
971     
972     
973     function mint(address _to, uint256 _amount) public onlyOwner {
974         _mint(_to, _amount);
975     }
976 
977     
978     
979     function burn(address _from, uint256 _amount) public onlyOwner {
980         _burn(_from, _amount);
981     }
982 
983     function transfer(address recipient, uint256 amount) public returns (bool) {
984         
985         
986         
987         require(
988             recipient != address(this),
989             "RenERC20: can't transfer to token address"
990         );
991         return super.transfer(recipient, amount);
992     }
993 
994     function transferFrom(address sender, address recipient, uint256 amount)
995         public
996         returns (bool)
997     {
998         
999         
1000         require(
1001             recipient != address(this),
1002             "RenERC20: can't transfer to token address"
1003         );
1004         return super.transferFrom(sender, recipient, amount);
1005     }
1006 }
1007 
1008 contract RenBTC is InitializableAdminUpgradeabilityProxy {}
1009 
1010 contract RenZEC is InitializableAdminUpgradeabilityProxy {}
1011 
1012 contract RenBCH is InitializableAdminUpgradeabilityProxy {}
1013 
1014 interface IMintGateway {
1015     function mint(
1016         bytes32 _pHash,
1017         uint256 _amount,
1018         bytes32 _nHash,
1019         bytes calldata _sig
1020     ) external returns (uint256);
1021     function mintFee() external view returns (uint256);
1022 }
1023 
1024 interface IBurnGateway {
1025     function burn(bytes calldata _to, uint256 _amountScaled)
1026         external
1027         returns (uint256);
1028     function burnFee() external view returns (uint256);
1029 }
1030 
1031 interface IGateway {
1032     
1033     function mint(
1034         bytes32 _pHash,
1035         uint256 _amount,
1036         bytes32 _nHash,
1037         bytes calldata _sig
1038     ) external returns (uint256);
1039     function mintFee() external view returns (uint256);
1040     
1041     function burn(bytes calldata _to, uint256 _amountScaled)
1042         external
1043         returns (uint256);
1044     function burnFee() external view returns (uint256);
1045 }
1046 
1047 contract GatewayStateV1 {
1048     uint256 constant BIPS_DENOMINATOR = 10000;
1049     uint256 public minimumBurnAmount;
1050 
1051     
1052     RenERC20LogicV1 public token;
1053 
1054     
1055     address public mintAuthority;
1056 
1057     
1058     
1059     
1060     
1061     address public feeRecipient;
1062 
1063     
1064     uint16 public mintFee;
1065 
1066     
1067     uint16 public burnFee;
1068 
1069     
1070     mapping(bytes32 => bool) public status;
1071 
1072     
1073     
1074     uint256 public nextN = 0;
1075 }
1076 
1077 contract GatewayLogicV1 is
1078     Initializable,
1079     Claimable,
1080     CanReclaimTokens,
1081     IGateway,
1082     GatewayStateV1
1083 {
1084     using SafeMath for uint256;
1085 
1086     event LogMintAuthorityUpdated(address indexed _newMintAuthority);
1087     event LogMint(
1088         address indexed _to,
1089         uint256 _amount,
1090         uint256 indexed _n,
1091         bytes32 indexed _signedMessageHash
1092     );
1093     event LogBurn(
1094         bytes _to,
1095         uint256 _amount,
1096         uint256 indexed _n,
1097         bytes indexed _indexedTo
1098     );
1099 
1100     
1101     modifier onlyOwnerOrMintAuthority() {
1102         require(
1103             msg.sender == mintAuthority || msg.sender == owner(),
1104             "Gateway: caller is not the owner or mint authority"
1105         );
1106         _;
1107     }
1108 
1109     
1110     
1111     
1112     
1113     
1114     
1115     
1116     
1117     function initialize(
1118         RenERC20LogicV1 _token,
1119         address _feeRecipient,
1120         address _mintAuthority,
1121         uint16 _mintFee,
1122         uint16 _burnFee,
1123         uint256 _minimumBurnAmount
1124     ) public initializer {
1125         Claimable.initialize(msg.sender);
1126         CanReclaimTokens.initialize(msg.sender);
1127         minimumBurnAmount = _minimumBurnAmount;
1128         token = _token;
1129         mintFee = _mintFee;
1130         burnFee = _burnFee;
1131         updateMintAuthority(_mintAuthority);
1132         updateFeeRecipient(_feeRecipient);
1133     }
1134 
1135     
1136 
1137     
1138     
1139     
1140     function claimTokenOwnership() public {
1141         token.claimOwnership();
1142     }
1143 
1144     
1145     function transferTokenOwnership(GatewayLogicV1 _nextTokenOwner)
1146         public
1147         onlyOwner
1148     {
1149         token.transferOwnership(address(_nextTokenOwner));
1150         _nextTokenOwner.claimTokenOwnership();
1151     }
1152 
1153     
1154     
1155     
1156     function updateMintAuthority(address _nextMintAuthority)
1157         public
1158         onlyOwnerOrMintAuthority
1159     {
1160         
1161         
1162         require(
1163             _nextMintAuthority != address(0),
1164             "Gateway: mintAuthority cannot be set to address zero"
1165         );
1166         mintAuthority = _nextMintAuthority;
1167         emit LogMintAuthorityUpdated(mintAuthority);
1168     }
1169 
1170     
1171     
1172     
1173     function updateMinimumBurnAmount(uint256 _minimumBurnAmount)
1174         public
1175         onlyOwner
1176     {
1177         minimumBurnAmount = _minimumBurnAmount;
1178     }
1179 
1180     
1181     
1182     
1183     function updateFeeRecipient(address _nextFeeRecipient) public onlyOwner {
1184         
1185         require(
1186             _nextFeeRecipient != address(0x0),
1187             "Gateway: fee recipient cannot be 0x0"
1188         );
1189 
1190         feeRecipient = _nextFeeRecipient;
1191     }
1192 
1193     
1194     
1195     
1196     function updateMintFee(uint16 _nextMintFee) public onlyOwner {
1197         mintFee = _nextMintFee;
1198     }
1199 
1200     
1201     
1202     
1203     function updateBurnFee(uint16 _nextBurnFee) public onlyOwner {
1204         burnFee = _nextBurnFee;
1205     }
1206 
1207     
1208     
1209     
1210     
1211     
1212     
1213     
1214     
1215     
1216     
1217     function mint(
1218         bytes32 _pHash,
1219         uint256 _amountUnderlying,
1220         bytes32 _nHash,
1221         bytes memory _sig
1222     ) public returns (uint256) {
1223         
1224         bytes32 signedMessageHash = hashForSignature(
1225             _pHash,
1226             _amountUnderlying,
1227             msg.sender,
1228             _nHash
1229         );
1230         require(
1231             status[signedMessageHash] == false,
1232             "Gateway: nonce hash already spent"
1233         );
1234         if (!verifySignature(signedMessageHash, _sig)) {
1235             
1236             
1237             
1238             revert(
1239                 String.add8(
1240                     "Gateway: invalid signature. pHash: ",
1241                     String.fromBytes32(_pHash),
1242                     ", amount: ",
1243                     String.fromUint(_amountUnderlying),
1244                     ", msg.sender: ",
1245                     String.fromAddress(msg.sender),
1246                     ", _nHash: ",
1247                     String.fromBytes32(_nHash)
1248                 )
1249             );
1250         }
1251         status[signedMessageHash] = true;
1252 
1253         uint256 amountScaled = token.fromUnderlying(_amountUnderlying);
1254 
1255         
1256         uint256 absoluteFeeScaled = amountScaled.mul(mintFee).div(
1257             BIPS_DENOMINATOR
1258         );
1259         uint256 receivedAmountScaled = amountScaled.sub(
1260             absoluteFeeScaled,
1261             "Gateway: fee exceeds amount"
1262         );
1263 
1264         
1265         token.mint(msg.sender, receivedAmountScaled);
1266         
1267         token.mint(feeRecipient, absoluteFeeScaled);
1268 
1269         
1270         uint256 receivedAmountUnderlying = token.toUnderlying(
1271             receivedAmountScaled
1272         );
1273         emit LogMint(
1274             msg.sender,
1275             receivedAmountUnderlying,
1276             nextN,
1277             signedMessageHash
1278         );
1279         nextN += 1;
1280 
1281         return receivedAmountScaled;
1282     }
1283 
1284     
1285     
1286     
1287     
1288     
1289     
1290     
1291     
1292     
1293     
1294     function burn(bytes memory _to, uint256 _amount) public returns (uint256) {
1295         
1296         
1297         require(_to.length != 0, "Gateway: to address is empty");
1298 
1299         
1300         uint256 fee = _amount.mul(burnFee).div(BIPS_DENOMINATOR);
1301         uint256 amountAfterFee = _amount.sub(
1302             fee,
1303             "Gateway: fee exceeds amount"
1304         );
1305 
1306         
1307         
1308         
1309         uint256 amountAfterFeeUnderlying = token.toUnderlying(amountAfterFee);
1310 
1311         
1312         token.burn(msg.sender, _amount);
1313         token.mint(feeRecipient, fee);
1314 
1315         require(
1316             
1317             
1318             amountAfterFeeUnderlying > minimumBurnAmount,
1319             "Gateway: amount is less than the minimum burn amount"
1320         );
1321 
1322         emit LogBurn(_to, amountAfterFeeUnderlying, nextN, _to);
1323         nextN += 1;
1324 
1325         return amountAfterFeeUnderlying;
1326     }
1327 
1328     
1329     
1330     function verifySignature(bytes32 _signedMessageHash, bytes memory _sig)
1331         public
1332         view
1333         returns (bool)
1334     {
1335         return mintAuthority == ECDSA.recover(_signedMessageHash, _sig);
1336     }
1337 
1338     
1339     function hashForSignature(
1340         bytes32 _pHash,
1341         uint256 _amount,
1342         address _to,
1343         bytes32 _nHash
1344     ) public view returns (bytes32) {
1345         return
1346             keccak256(abi.encode(_pHash, _amount, address(token), _to, _nHash));
1347     }
1348 }
1349 
1350 contract BTCGateway is InitializableAdminUpgradeabilityProxy {}
1351 
1352 contract ZECGateway is InitializableAdminUpgradeabilityProxy {}
1353 
1354 contract BCHGateway is InitializableAdminUpgradeabilityProxy {}