1 pragma solidity 0.5.2;
2 
3 // File: contracts/ERC20Interface.sol
4 
5 // https://github.com/ethereum/EIPs/issues/20
6 interface ERC20 {
7     function totalSupply() external view returns (uint supply);
8     function balanceOf(address _owner) external view returns (uint balance);
9     function transfer(address _to, uint _value) external returns (bool success);
10     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
11     function approve(address _spender, uint _value) external returns (bool success);
12     function allowance(address _owner, address _spender) external view returns (uint remaining);
13     function decimals() external view returns(uint digits);
14     event Approval(address indexed _owner, address indexed _spender, uint _value);
15 }
16 
17 
18 contract ERC20WithSymbol is ERC20 {
19     function symbol() external view returns (string memory _symbol);
20 }
21 
22 // File: contracts/PermissionGroups.sol
23 
24 contract PermissionGroups {
25 
26     address public admin;
27     address public pendingAdmin;
28     mapping(address=>bool) internal operators;
29     mapping(address=>bool) internal alerters;
30     address[] internal operatorsGroup;
31     address[] internal alertersGroup;
32     uint constant internal MAX_GROUP_SIZE = 50;
33 
34     constructor() public {
35         admin = msg.sender;
36     }
37 
38     modifier onlyAdmin() {
39         require(msg.sender == admin, "Operation limited to admin");
40         _;
41     }
42 
43     modifier onlyOperator() {
44         require(operators[msg.sender], "Operation limited to operator");
45         _;
46     }
47 
48     modifier onlyAlerter() {
49         require(alerters[msg.sender], "Operation limited to alerter");
50         _;
51     }
52 
53     function getOperators () external view returns(address[] memory) {
54         return operatorsGroup;
55     }
56 
57     function getAlerters () external view returns(address[] memory) {
58         return alertersGroup;
59     }
60 
61     event TransferAdminPending(address pendingAdmin);
62 
63     /**
64      * @dev Allows the current admin to set the pendingAdmin address.
65      * @param newAdmin The address to transfer ownership to.
66      */
67     function transferAdmin(address newAdmin) public onlyAdmin {
68         require(newAdmin != address(0), "admin address cannot be 0");
69         emit TransferAdminPending(pendingAdmin);
70         pendingAdmin = newAdmin;
71     }
72 
73     /**
74      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
75      * @param newAdmin The address to transfer ownership to.
76      */
77     function transferAdminQuickly(address newAdmin) public onlyAdmin {
78         require(newAdmin != address(0), "admin address cannot be 0");
79         emit TransferAdminPending(newAdmin);
80         emit AdminClaimed(newAdmin, admin);
81         admin = newAdmin;
82     }
83 
84     event AdminClaimed( address newAdmin, address previousAdmin);
85 
86     /**
87      * @dev Allows the pendingAdmin address to finalize the change admin process.
88      */
89     function claimAdmin() public {
90         require(pendingAdmin == msg.sender, "admin address cannot be 0");
91         emit AdminClaimed(pendingAdmin, admin);
92         admin = pendingAdmin;
93         pendingAdmin = address(0);
94     }
95 
96     event AlerterAdded (address newAlerter, bool isAdd);
97 
98     function addAlerter(address newAlerter) public onlyAdmin {
99         // prevent duplicates.
100         require(!alerters[newAlerter], "alerter already configured");
101         require(
102             alertersGroup.length < MAX_GROUP_SIZE,
103             "alerter group exceeding maximum size"
104         );
105 
106         emit AlerterAdded(newAlerter, true);
107         alerters[newAlerter] = true;
108         alertersGroup.push(newAlerter);
109     }
110 
111     function removeAlerter (address alerter) public onlyAdmin {
112         require(alerters[alerter], "alerter not configured");
113         alerters[alerter] = false;
114 
115         for (uint i = 0; i < alertersGroup.length; ++i) {
116             if (alertersGroup[i] == alerter) {
117                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
118                 alertersGroup.length--;
119                 emit AlerterAdded(alerter, false);
120                 break;
121             }
122         }
123     }
124 
125     event OperatorAdded(address newOperator, bool isAdd);
126 
127     function addOperator(address newOperator) public onlyAdmin {
128         // prevent duplicates.
129         require(!operators[newOperator], "operator already configured");
130         require(
131             operatorsGroup.length < MAX_GROUP_SIZE,
132             "operator group exceeding maximum size"
133         );
134 
135         emit OperatorAdded(newOperator, true);
136         operators[newOperator] = true;
137         operatorsGroup.push(newOperator);
138     }
139 
140     function removeOperator (address operator) public onlyAdmin {
141         require(operators[operator], "operator not configured");
142         operators[operator] = false;
143 
144         for (uint i = 0; i < operatorsGroup.length; ++i) {
145             if (operatorsGroup[i] == operator) {
146                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
147                 operatorsGroup.length -= 1;
148                 emit OperatorAdded(operator, false);
149                 break;
150             }
151         }
152     }
153 }
154 
155 // File: contracts/Withdrawable.sol
156 
157 /**
158  * @title Contracts that should be able to recover tokens or ethers
159  * @author Ilan Doron
160  * @dev This allows to recover any tokens or Ethers received in a contract.
161  * This will prevent any accidental loss of tokens.
162  */
163 contract Withdrawable is PermissionGroups {
164 
165     event TokenWithdraw(
166         ERC20 indexed token,
167         uint amount,
168         address indexed sendTo
169     );
170 
171     /**
172      * @dev Withdraw all ERC20 compatible tokens
173      * @param token ERC20 The address of the token contract
174      */
175     function withdrawToken(
176       ERC20 token,
177       uint amount,
178       address sendTo
179     )
180         external
181         onlyAdmin
182     {
183         require(token.transfer(sendTo, amount), "Could not transfer tokens");
184         emit TokenWithdraw(token, amount, sendTo);
185     }
186 
187     event EtherWithdraw(
188         uint amount,
189         address indexed sendTo
190     );
191 
192     /**
193      * @dev Withdraw Ethers
194      */
195     function withdrawEther(
196         uint amount,
197         address payable sendTo
198     )
199         external
200         onlyAdmin
201     {
202         sendTo.transfer(amount);
203         emit EtherWithdraw(amount, sendTo);
204     }
205 }
206 
207 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
208 
209 /// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
210 /// @author Alan Lu - <alan@gnosis.pm>
211 contract Proxied {
212     address public masterCopy;
213 }
214 
215 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
216 /// @author Stefan George - <stefan@gnosis.pm>
217 contract Proxy is Proxied {
218     /// @dev Constructor function sets address of master copy contract.
219     /// @param _masterCopy Master copy address.
220     constructor(address _masterCopy) public {
221         require(_masterCopy != address(0), "The master copy is required");
222         masterCopy = _masterCopy;
223     }
224 
225     /// @dev Fallback function forwards all transactions and returns all received return data.
226     function() external payable {
227         address _masterCopy = masterCopy;
228         assembly {
229             calldatacopy(0, 0, calldatasize)
230             let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
231             returndatacopy(0, 0, returndatasize)
232             switch success
233                 case 0 {
234                     revert(0, returndatasize)
235                 }
236                 default {
237                     return(0, returndatasize)
238                 }
239         }
240     }
241 }
242 
243 // File: @gnosis.pm/util-contracts/contracts/Token.sol
244 
245 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
246 pragma solidity ^0.5.2;
247 
248 /// @title Abstract token contract - Functions to be implemented by token contracts
249 contract Token {
250     /*
251      *  Events
252      */
253     event Transfer(address indexed from, address indexed to, uint value);
254     event Approval(address indexed owner, address indexed spender, uint value);
255 
256     /*
257      *  Public functions
258      */
259     function transfer(address to, uint value) public returns (bool);
260     function transferFrom(address from, address to, uint value) public returns (bool);
261     function approve(address spender, uint value) public returns (bool);
262     function balanceOf(address owner) public view returns (uint);
263     function allowance(address owner, address spender) public view returns (uint);
264     function totalSupply() public view returns (uint);
265 }
266 
267 // File: @gnosis.pm/util-contracts/contracts/Math.sol
268 
269 /// @title Math library - Allows calculation of logarithmic and exponential functions
270 /// @author Alan Lu - <alan.lu@gnosis.pm>
271 /// @author Stefan George - <stefan@gnosis.pm>
272 library GnosisMath {
273     /*
274      *  Constants
275      */
276     // This is equal to 1 in our calculations
277     uint public constant ONE = 0x10000000000000000;
278     uint public constant LN2 = 0xb17217f7d1cf79ac;
279     uint public constant LOG2_E = 0x171547652b82fe177;
280 
281     /*
282      *  Public functions
283      */
284     /// @dev Returns natural exponential function value of given x
285     /// @param x x
286     /// @return e**x
287     function exp(int x) public pure returns (uint) {
288         // revert if x is > MAX_POWER, where
289         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
290         require(x <= 2454971259878909886679);
291         // return 0 if exp(x) is tiny, using
292         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
293         if (x < -818323753292969962227) return 0;
294         // Transform so that e^x -> 2^x
295         x = x * int(ONE) / int(LN2);
296         // 2^x = 2^whole(x) * 2^frac(x)
297         //       ^^^^^^^^^^ is a bit shift
298         // so Taylor expand on z = frac(x)
299         int shift;
300         uint z;
301         if (x >= 0) {
302             shift = x / int(ONE);
303             z = uint(x % int(ONE));
304         } else {
305             shift = x / int(ONE) - 1;
306             z = ONE - uint(-x % int(ONE));
307         }
308         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
309         //
310         // Can generate the z coefficients using mpmath and the following lines
311         // >>> from mpmath import mp
312         // >>> mp.dps = 100
313         // >>> ONE =  0x10000000000000000
314         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
315         // 0xb17217f7d1cf79ab
316         // 0x3d7f7bff058b1d50
317         // 0xe35846b82505fc5
318         // 0x276556df749cee5
319         // 0x5761ff9e299cc4
320         // 0xa184897c363c3
321         uint zpow = z;
322         uint result = ONE;
323         result += 0xb17217f7d1cf79ab * zpow / ONE;
324         zpow = zpow * z / ONE;
325         result += 0x3d7f7bff058b1d50 * zpow / ONE;
326         zpow = zpow * z / ONE;
327         result += 0xe35846b82505fc5 * zpow / ONE;
328         zpow = zpow * z / ONE;
329         result += 0x276556df749cee5 * zpow / ONE;
330         zpow = zpow * z / ONE;
331         result += 0x5761ff9e299cc4 * zpow / ONE;
332         zpow = zpow * z / ONE;
333         result += 0xa184897c363c3 * zpow / ONE;
334         zpow = zpow * z / ONE;
335         result += 0xffe5fe2c4586 * zpow / ONE;
336         zpow = zpow * z / ONE;
337         result += 0x162c0223a5c8 * zpow / ONE;
338         zpow = zpow * z / ONE;
339         result += 0x1b5253d395e * zpow / ONE;
340         zpow = zpow * z / ONE;
341         result += 0x1e4cf5158b * zpow / ONE;
342         zpow = zpow * z / ONE;
343         result += 0x1e8cac735 * zpow / ONE;
344         zpow = zpow * z / ONE;
345         result += 0x1c3bd650 * zpow / ONE;
346         zpow = zpow * z / ONE;
347         result += 0x1816193 * zpow / ONE;
348         zpow = zpow * z / ONE;
349         result += 0x131496 * zpow / ONE;
350         zpow = zpow * z / ONE;
351         result += 0xe1b7 * zpow / ONE;
352         zpow = zpow * z / ONE;
353         result += 0x9c7 * zpow / ONE;
354         if (shift >= 0) {
355             if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
356             return result << shift;
357         } else return result >> (-shift);
358     }
359 
360     /// @dev Returns natural logarithm value of given x
361     /// @param x x
362     /// @return ln(x)
363     function ln(uint x) public pure returns (int) {
364         require(x > 0);
365         // binary search for floor(log2(x))
366         int ilog2 = floorLog2(x);
367         int z;
368         if (ilog2 < 0) z = int(x << uint(-ilog2));
369         else z = int(x >> uint(ilog2));
370         // z = x * 2^-⌊log₂x⌋
371         // so 1 <= z < 2
372         // and ln z = ln x - ⌊log₂x⌋/log₂e
373         // so just compute ln z using artanh series
374         // and calculate ln x from that
375         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
376         int halflnz = term;
377         int termpow = term * term / int(ONE) * term / int(ONE);
378         halflnz += termpow / 3;
379         termpow = termpow * term / int(ONE) * term / int(ONE);
380         halflnz += termpow / 5;
381         termpow = termpow * term / int(ONE) * term / int(ONE);
382         halflnz += termpow / 7;
383         termpow = termpow * term / int(ONE) * term / int(ONE);
384         halflnz += termpow / 9;
385         termpow = termpow * term / int(ONE) * term / int(ONE);
386         halflnz += termpow / 11;
387         termpow = termpow * term / int(ONE) * term / int(ONE);
388         halflnz += termpow / 13;
389         termpow = termpow * term / int(ONE) * term / int(ONE);
390         halflnz += termpow / 15;
391         termpow = termpow * term / int(ONE) * term / int(ONE);
392         halflnz += termpow / 17;
393         termpow = termpow * term / int(ONE) * term / int(ONE);
394         halflnz += termpow / 19;
395         termpow = termpow * term / int(ONE) * term / int(ONE);
396         halflnz += termpow / 21;
397         termpow = termpow * term / int(ONE) * term / int(ONE);
398         halflnz += termpow / 23;
399         termpow = termpow * term / int(ONE) * term / int(ONE);
400         halflnz += termpow / 25;
401         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
402     }
403 
404     /// @dev Returns base 2 logarithm value of given x
405     /// @param x x
406     /// @return logarithmic value
407     function floorLog2(uint x) public pure returns (int lo) {
408         lo = -64;
409         int hi = 193;
410         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
411         int mid = (hi + lo) >> 1;
412         while ((lo + 1) < hi) {
413             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
414             else lo = mid;
415             mid = (hi + lo) >> 1;
416         }
417     }
418 
419     /// @dev Returns maximum of an array
420     /// @param nums Numbers to look through
421     /// @return Maximum number
422     function max(int[] memory nums) public pure returns (int maxNum) {
423         require(nums.length > 0);
424         maxNum = -2 ** 255;
425         for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
426     }
427 
428     /// @dev Returns whether an add operation causes an overflow
429     /// @param a First addend
430     /// @param b Second addend
431     /// @return Did no overflow occur?
432     function safeToAdd(uint a, uint b) internal pure returns (bool) {
433         return a + b >= a;
434     }
435 
436     /// @dev Returns whether a subtraction operation causes an underflow
437     /// @param a Minuend
438     /// @param b Subtrahend
439     /// @return Did no underflow occur?
440     function safeToSub(uint a, uint b) internal pure returns (bool) {
441         return a >= b;
442     }
443 
444     /// @dev Returns whether a multiply operation causes an overflow
445     /// @param a First factor
446     /// @param b Second factor
447     /// @return Did no overflow occur?
448     function safeToMul(uint a, uint b) internal pure returns (bool) {
449         return b == 0 || a * b / b == a;
450     }
451 
452     /// @dev Returns sum if no overflow occurred
453     /// @param a First addend
454     /// @param b Second addend
455     /// @return Sum
456     function add(uint a, uint b) internal pure returns (uint) {
457         require(safeToAdd(a, b));
458         return a + b;
459     }
460 
461     /// @dev Returns difference if no overflow occurred
462     /// @param a Minuend
463     /// @param b Subtrahend
464     /// @return Difference
465     function sub(uint a, uint b) internal pure returns (uint) {
466         require(safeToSub(a, b));
467         return a - b;
468     }
469 
470     /// @dev Returns product if no overflow occurred
471     /// @param a First factor
472     /// @param b Second factor
473     /// @return Product
474     function mul(uint a, uint b) internal pure returns (uint) {
475         require(safeToMul(a, b));
476         return a * b;
477     }
478 
479     /// @dev Returns whether an add operation causes an overflow
480     /// @param a First addend
481     /// @param b Second addend
482     /// @return Did no overflow occur?
483     function safeToAdd(int a, int b) internal pure returns (bool) {
484         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
485     }
486 
487     /// @dev Returns whether a subtraction operation causes an underflow
488     /// @param a Minuend
489     /// @param b Subtrahend
490     /// @return Did no underflow occur?
491     function safeToSub(int a, int b) internal pure returns (bool) {
492         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
493     }
494 
495     /// @dev Returns whether a multiply operation causes an overflow
496     /// @param a First factor
497     /// @param b Second factor
498     /// @return Did no overflow occur?
499     function safeToMul(int a, int b) internal pure returns (bool) {
500         return (b == 0) || (a * b / b == a);
501     }
502 
503     /// @dev Returns sum if no overflow occurred
504     /// @param a First addend
505     /// @param b Second addend
506     /// @return Sum
507     function add(int a, int b) internal pure returns (int) {
508         require(safeToAdd(a, b));
509         return a + b;
510     }
511 
512     /// @dev Returns difference if no overflow occurred
513     /// @param a Minuend
514     /// @param b Subtrahend
515     /// @return Difference
516     function sub(int a, int b) internal pure returns (int) {
517         require(safeToSub(a, b));
518         return a - b;
519     }
520 
521     /// @dev Returns product if no overflow occurred
522     /// @param a First factor
523     /// @param b Second factor
524     /// @return Product
525     function mul(int a, int b) internal pure returns (int) {
526         require(safeToMul(a, b));
527         return a * b;
528     }
529 }
530 
531 // File: @gnosis.pm/util-contracts/contracts/GnosisStandardToken.sol
532 
533 /**
534  * Deprecated: Use Open Zeppeling one instead
535  */
536 contract StandardTokenData {
537     /*
538      *  Storage
539      */
540     mapping(address => uint) balances;
541     mapping(address => mapping(address => uint)) allowances;
542     uint totalTokens;
543 }
544 
545 /**
546  * Deprecated: Use Open Zeppeling one instead
547  */
548 /// @title Standard token contract with overflow protection
549 contract GnosisStandardToken is Token, StandardTokenData {
550     using GnosisMath for *;
551 
552     /*
553      *  Public functions
554      */
555     /// @dev Transfers sender's tokens to a given address. Returns success
556     /// @param to Address of token receiver
557     /// @param value Number of tokens to transfer
558     /// @return Was transfer successful?
559     function transfer(address to, uint value) public returns (bool) {
560         if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
561             return false;
562         }
563 
564         balances[msg.sender] -= value;
565         balances[to] += value;
566         emit Transfer(msg.sender, to, value);
567         return true;
568     }
569 
570     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
571     /// @param from Address from where tokens are withdrawn
572     /// @param to Address to where tokens are sent
573     /// @param value Number of tokens to transfer
574     /// @return Was transfer successful?
575     function transferFrom(address from, address to, uint value) public returns (bool) {
576         if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
577             value
578         ) || !balances[to].safeToAdd(value)) {
579             return false;
580         }
581         balances[from] -= value;
582         allowances[from][msg.sender] -= value;
583         balances[to] += value;
584         emit Transfer(from, to, value);
585         return true;
586     }
587 
588     /// @dev Sets approved amount of tokens for spender. Returns success
589     /// @param spender Address of allowed account
590     /// @param value Number of approved tokens
591     /// @return Was approval successful?
592     function approve(address spender, uint value) public returns (bool) {
593         allowances[msg.sender][spender] = value;
594         emit Approval(msg.sender, spender, value);
595         return true;
596     }
597 
598     /// @dev Returns number of allowed tokens for given address
599     /// @param owner Address of token owner
600     /// @param spender Address of token spender
601     /// @return Remaining allowance for spender
602     function allowance(address owner, address spender) public view returns (uint) {
603         return allowances[owner][spender];
604     }
605 
606     /// @dev Returns number of tokens owned by given address
607     /// @param owner Address of token owner
608     /// @return Balance of owner
609     function balanceOf(address owner) public view returns (uint) {
610         return balances[owner];
611     }
612 
613     /// @dev Returns total supply of tokens
614     /// @return Total supply
615     function totalSupply() public view returns (uint) {
616         return totalTokens;
617     }
618 }
619 
620 // File: @gnosis.pm/dx-contracts/contracts/TokenFRT.sol
621 
622 /// @title Standard token contract with overflow protection
623 contract TokenFRT is Proxied, GnosisStandardToken {
624     address public owner;
625 
626     string public constant symbol = "MGN";
627     string public constant name = "Magnolia Token";
628     uint8 public constant decimals = 18;
629 
630     struct UnlockedToken {
631         uint amountUnlocked;
632         uint withdrawalTime;
633     }
634 
635     /*
636      *  Storage
637      */
638     address public minter;
639 
640     // user => UnlockedToken
641     mapping(address => UnlockedToken) public unlockedTokens;
642 
643     // user => amount
644     mapping(address => uint) public lockedTokenBalances;
645 
646     /*
647      *  Public functions
648      */
649 
650     // @dev allows to set the minter of Magnolia tokens once.
651     // @param   _minter the minter of the Magnolia tokens, should be the DX-proxy
652     function updateMinter(address _minter) public {
653         require(msg.sender == owner, "Only the minter can set a new one");
654         require(_minter != address(0), "The new minter must be a valid address");
655 
656         minter = _minter;
657     }
658 
659     // @dev the intention is to set the owner as the DX-proxy, once it is deployed
660     // Then only an update of the DX-proxy contract after a 30 days delay could change the minter again.
661     function updateOwner(address _owner) public {
662         require(msg.sender == owner, "Only the owner can update the owner");
663         require(_owner != address(0), "The new owner must be a valid address");
664         owner = _owner;
665     }
666 
667     function mintTokens(address user, uint amount) public {
668         require(msg.sender == minter, "Only the minter can mint tokens");
669 
670         lockedTokenBalances[user] = add(lockedTokenBalances[user], amount);
671         totalTokens = add(totalTokens, amount);
672     }
673 
674     /// @dev Lock Token
675     function lockTokens(uint amount) public returns (uint totalAmountLocked) {
676         // Adjust amount by balance
677         uint actualAmount = min(amount, balances[msg.sender]);
678 
679         // Update state variables
680         balances[msg.sender] = sub(balances[msg.sender], actualAmount);
681         lockedTokenBalances[msg.sender] = add(lockedTokenBalances[msg.sender], actualAmount);
682 
683         // Get return variable
684         totalAmountLocked = lockedTokenBalances[msg.sender];
685     }
686 
687     function unlockTokens() public returns (uint totalAmountUnlocked, uint withdrawalTime) {
688         // Adjust amount by locked balances
689         uint amount = lockedTokenBalances[msg.sender];
690 
691         if (amount > 0) {
692             // Update state variables
693             lockedTokenBalances[msg.sender] = sub(lockedTokenBalances[msg.sender], amount);
694             unlockedTokens[msg.sender].amountUnlocked = add(unlockedTokens[msg.sender].amountUnlocked, amount);
695             unlockedTokens[msg.sender].withdrawalTime = now + 24 hours;
696         }
697 
698         // Get return variables
699         totalAmountUnlocked = unlockedTokens[msg.sender].amountUnlocked;
700         withdrawalTime = unlockedTokens[msg.sender].withdrawalTime;
701     }
702 
703     function withdrawUnlockedTokens() public {
704         require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
705         balances[msg.sender] = add(balances[msg.sender], unlockedTokens[msg.sender].amountUnlocked);
706         unlockedTokens[msg.sender].amountUnlocked = 0;
707     }
708 
709     function min(uint a, uint b) public pure returns (uint) {
710         if (a < b) {
711             return a;
712         } else {
713             return b;
714         }
715     }
716     
717     /// @dev Returns whether an add operation causes an overflow
718     /// @param a First addend
719     /// @param b Second addend
720     /// @return Did no overflow occur?
721     function safeToAdd(uint a, uint b) public pure returns (bool) {
722         return a + b >= a;
723     }
724 
725     /// @dev Returns whether a subtraction operation causes an underflow
726     /// @param a Minuend
727     /// @param b Subtrahend
728     /// @return Did no underflow occur?
729     function safeToSub(uint a, uint b) public pure returns (bool) {
730         return a >= b;
731     }
732 
733     /// @dev Returns sum if no overflow occurred
734     /// @param a First addend
735     /// @param b Second addend
736     /// @return Sum
737     function add(uint a, uint b) public pure returns (uint) {
738         require(safeToAdd(a, b), "It must be a safe adition");
739         return a + b;
740     }
741 
742     /// @dev Returns difference if no overflow occurred
743     /// @param a Minuend
744     /// @param b Subtrahend
745     /// @return Difference
746     function sub(uint a, uint b) public pure returns (uint) {
747         require(safeToSub(a, b), "It must be a safe substraction");
748         return a - b;
749     }
750 }
751 
752 // File: @gnosis.pm/owl-token/contracts/TokenOWL.sol
753 
754 contract TokenOWL is Proxied, GnosisStandardToken {
755     using GnosisMath for *;
756 
757     string public constant name = "OWL Token";
758     string public constant symbol = "OWL";
759     uint8 public constant decimals = 18;
760 
761     struct masterCopyCountdownType {
762         address masterCopy;
763         uint timeWhenAvailable;
764     }
765 
766     masterCopyCountdownType masterCopyCountdown;
767 
768     address public creator;
769     address public minter;
770 
771     event Minted(address indexed to, uint256 amount);
772     event Burnt(address indexed from, address indexed user, uint256 amount);
773 
774     modifier onlyCreator() {
775         // R1
776         require(msg.sender == creator, "Only the creator can perform the transaction");
777         _;
778     }
779     /// @dev trickers the update process via the proxyMaster for a new address _masterCopy
780     /// updating is only possible after 30 days
781     function startMasterCopyCountdown(address _masterCopy) public onlyCreator {
782         require(address(_masterCopy) != address(0), "The master copy must be a valid address");
783 
784         // Update masterCopyCountdown
785         masterCopyCountdown.masterCopy = _masterCopy;
786         masterCopyCountdown.timeWhenAvailable = now + 30 days;
787     }
788 
789     /// @dev executes the update process via the proxyMaster for a new address _masterCopy
790     function updateMasterCopy() public onlyCreator {
791         require(address(masterCopyCountdown.masterCopy) != address(0), "The master copy must be a valid address");
792         require(
793             block.timestamp >= masterCopyCountdown.timeWhenAvailable,
794             "It's not possible to update the master copy during the waiting period"
795         );
796 
797         // Update masterCopy
798         masterCopy = masterCopyCountdown.masterCopy;
799     }
800 
801     function getMasterCopy() public view returns (address) {
802         return masterCopy;
803     }
804 
805     /// @dev Set minter. Only the creator of this contract can call this.
806     /// @param newMinter The new address authorized to mint this token
807     function setMinter(address newMinter) public onlyCreator {
808         minter = newMinter;
809     }
810 
811     /// @dev change owner/creator of the contract. Only the creator/owner of this contract can call this.
812     /// @param newOwner The new address, which should become the owner
813     function setNewOwner(address newOwner) public onlyCreator {
814         creator = newOwner;
815     }
816 
817     /// @dev Mints OWL.
818     /// @param to Address to which the minted token will be given
819     /// @param amount Amount of OWL to be minted
820     function mintOWL(address to, uint amount) public {
821         require(minter != address(0), "The minter must be initialized");
822         require(msg.sender == minter, "Only the minter can mint OWL");
823         balances[to] = balances[to].add(amount);
824         totalTokens = totalTokens.add(amount);
825         emit Minted(to, amount);
826     }
827 
828     /// @dev Burns OWL.
829     /// @param user Address of OWL owner
830     /// @param amount Amount of OWL to be burnt
831     function burnOWL(address user, uint amount) public {
832         allowances[user][msg.sender] = allowances[user][msg.sender].sub(amount);
833         balances[user] = balances[user].sub(amount);
834         totalTokens = totalTokens.sub(amount);
835         emit Burnt(msg.sender, user, amount);
836     }
837 }
838 
839 // File: @gnosis.pm/dx-contracts/contracts/base/SafeTransfer.sol
840 
841 interface BadToken {
842     function transfer(address to, uint value) external;
843     function transferFrom(address from, address to, uint value) external;
844 }
845 
846 contract SafeTransfer {
847     function safeTransfer(address token, address to, uint value, bool from) internal returns (bool result) {
848         if (from) {
849             BadToken(token).transferFrom(msg.sender, address(this), value);
850         } else {
851             BadToken(token).transfer(to, value);
852         }
853 
854         // solium-disable-next-line security/no-inline-assembly
855         assembly {
856             switch returndatasize
857                 case 0 {
858                     // This is our BadToken
859                     result := not(0) // result is true
860                 }
861                 case 32 {
862                     // This is our GoodToken
863                     returndatacopy(0, 0, 32)
864                     result := mload(0) // result == returndata of external call
865                 }
866                 default {
867                     // This is not an ERC20 token
868                     result := 0
869                 }
870         }
871         return result;
872     }
873 }
874 
875 // File: @gnosis.pm/dx-contracts/contracts/base/AuctioneerManaged.sol
876 
877 contract AuctioneerManaged {
878     // auctioneer has the power to manage some variables
879     address public auctioneer;
880 
881     function updateAuctioneer(address _auctioneer) public onlyAuctioneer {
882         require(_auctioneer != address(0), "The auctioneer must be a valid address");
883         auctioneer = _auctioneer;
884     }
885 
886     // > Modifiers
887     modifier onlyAuctioneer() {
888         // Only allows auctioneer to proceed
889         // R1
890         // require(msg.sender == auctioneer, "Only auctioneer can perform this operation");
891         require(msg.sender == auctioneer, "Only the auctioneer can nominate a new one");
892         _;
893     }
894 }
895 
896 // File: @gnosis.pm/dx-contracts/contracts/base/TokenWhitelist.sol
897 
898 contract TokenWhitelist is AuctioneerManaged {
899     // Mapping that stores the tokens, which are approved
900     // Only tokens approved by auctioneer generate frtToken tokens
901     // addressToken => boolApproved
902     mapping(address => bool) public approvedTokens;
903 
904     event Approval(address indexed token, bool approved);
905 
906     /// @dev for quick overview of approved Tokens
907     /// @param addressesToCheck are the ERC-20 token addresses to be checked whether they are approved
908     function getApprovedAddressesOfList(address[] calldata addressesToCheck) external view returns (bool[] memory) {
909         uint length = addressesToCheck.length;
910 
911         bool[] memory isApproved = new bool[](length);
912 
913         for (uint i = 0; i < length; i++) {
914             isApproved[i] = approvedTokens[addressesToCheck[i]];
915         }
916 
917         return isApproved;
918     }
919     
920     function updateApprovalOfToken(address[] memory token, bool approved) public onlyAuctioneer {
921         for (uint i = 0; i < token.length; i++) {
922             approvedTokens[token[i]] = approved;
923             emit Approval(token[i], approved);
924         }
925     }
926 
927 }
928 
929 // File: @gnosis.pm/dx-contracts/contracts/base/DxMath.sol
930 
931 contract DxMath {
932     // > Math fns
933     function min(uint a, uint b) public pure returns (uint) {
934         if (a < b) {
935             return a;
936         } else {
937             return b;
938         }
939     }
940 
941     function atleastZero(int a) public pure returns (uint) {
942         if (a < 0) {
943             return 0;
944         } else {
945             return uint(a);
946         }
947     }
948     
949     /// @dev Returns whether an add operation causes an overflow
950     /// @param a First addend
951     /// @param b Second addend
952     /// @return Did no overflow occur?
953     function safeToAdd(uint a, uint b) public pure returns (bool) {
954         return a + b >= a;
955     }
956 
957     /// @dev Returns whether a subtraction operation causes an underflow
958     /// @param a Minuend
959     /// @param b Subtrahend
960     /// @return Did no underflow occur?
961     function safeToSub(uint a, uint b) public pure returns (bool) {
962         return a >= b;
963     }
964 
965     /// @dev Returns whether a multiply operation causes an overflow
966     /// @param a First factor
967     /// @param b Second factor
968     /// @return Did no overflow occur?
969     function safeToMul(uint a, uint b) public pure returns (bool) {
970         return b == 0 || a * b / b == a;
971     }
972 
973     /// @dev Returns sum if no overflow occurred
974     /// @param a First addend
975     /// @param b Second addend
976     /// @return Sum
977     function add(uint a, uint b) public pure returns (uint) {
978         require(safeToAdd(a, b));
979         return a + b;
980     }
981 
982     /// @dev Returns difference if no overflow occurred
983     /// @param a Minuend
984     /// @param b Subtrahend
985     /// @return Difference
986     function sub(uint a, uint b) public pure returns (uint) {
987         require(safeToSub(a, b));
988         return a - b;
989     }
990 
991     /// @dev Returns product if no overflow occurred
992     /// @param a First factor
993     /// @param b Second factor
994     /// @return Product
995     function mul(uint a, uint b) public pure returns (uint) {
996         require(safeToMul(a, b));
997         return a * b;
998     }
999 }
1000 
1001 // File: @gnosis.pm/dx-contracts/contracts/Oracle/DSMath.sol
1002 
1003 contract DSMath {
1004     /*
1005     standard uint256 functions
1006      */
1007 
1008     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
1009         assert((z = x + y) >= x);
1010     }
1011 
1012     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
1013         assert((z = x - y) <= x);
1014     }
1015 
1016     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1017         assert((z = x * y) >= x);
1018     }
1019 
1020     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
1021         z = x / y;
1022     }
1023 
1024     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
1025         return x <= y ? x : y;
1026     }
1027 
1028     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
1029         return x >= y ? x : y;
1030     }
1031 
1032     /*
1033     uint128 functions (h is for half)
1034      */
1035 
1036     function hadd(uint128 x, uint128 y) internal pure returns (uint128 z) {
1037         assert((z = x + y) >= x);
1038     }
1039 
1040     function hsub(uint128 x, uint128 y) internal pure returns (uint128 z) {
1041         assert((z = x - y) <= x);
1042     }
1043 
1044     function hmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
1045         assert((z = x * y) >= x);
1046     }
1047 
1048     function hdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
1049         z = x / y;
1050     }
1051 
1052     function hmin(uint128 x, uint128 y) internal pure returns (uint128 z) {
1053         return x <= y ? x : y;
1054     }
1055 
1056     function hmax(uint128 x, uint128 y) internal pure returns (uint128 z) {
1057         return x >= y ? x : y;
1058     }
1059 
1060     /*
1061     int256 functions
1062      */
1063 
1064     function imin(int256 x, int256 y) internal pure returns (int256 z) {
1065         return x <= y ? x : y;
1066     }
1067 
1068     function imax(int256 x, int256 y) internal pure returns (int256 z) {
1069         return x >= y ? x : y;
1070     }
1071 
1072     /*
1073     WAD math
1074      */
1075 
1076     uint128 constant WAD = 10 ** 18;
1077 
1078     function wadd(uint128 x, uint128 y) internal pure returns (uint128) {
1079         return hadd(x, y);
1080     }
1081 
1082     function wsub(uint128 x, uint128 y) internal pure returns (uint128) {
1083         return hsub(x, y);
1084     }
1085 
1086     function wmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
1087         z = cast((uint256(x) * y + WAD / 2) / WAD);
1088     }
1089 
1090     function wdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
1091         z = cast((uint256(x) * WAD + y / 2) / y);
1092     }
1093 
1094     function wmin(uint128 x, uint128 y) internal pure returns (uint128) {
1095         return hmin(x, y);
1096     }
1097 
1098     function wmax(uint128 x, uint128 y) internal pure returns (uint128) {
1099         return hmax(x, y);
1100     }
1101 
1102     /*
1103     RAY math
1104      */
1105 
1106     uint128 constant RAY = 10 ** 27;
1107 
1108     function radd(uint128 x, uint128 y) internal pure returns (uint128) {
1109         return hadd(x, y);
1110     }
1111 
1112     function rsub(uint128 x, uint128 y) internal pure returns (uint128) {
1113         return hsub(x, y);
1114     }
1115 
1116     function rmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
1117         z = cast((uint256(x) * y + RAY / 2) / RAY);
1118     }
1119 
1120     function rdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
1121         z = cast((uint256(x) * RAY + y / 2) / y);
1122     }
1123 
1124     function rpow(uint128 x, uint64 n) internal pure returns (uint128 z) {
1125         // This famous algorithm is called "exponentiation by squaring"
1126         // and calculates x^n with x as fixed-point and n as regular unsigned.
1127         //
1128         // It's O(log n), instead of O(n) for naive repeated multiplication.
1129         //
1130         // These facts are why it works:
1131         //
1132         //  If n is even, then x^n = (x^2)^(n/2).
1133         //  If n is odd,  then x^n = x * x^(n-1),
1134         //   and applying the equation for even x gives
1135         //    x^n = x * (x^2)^((n-1) / 2).
1136         //
1137         //  Also, EVM division is flooring and
1138         //    floor[(n-1) / 2] = floor[n / 2].
1139 
1140         z = n % 2 != 0 ? x : RAY;
1141 
1142         for (n /= 2; n != 0; n /= 2) {
1143             x = rmul(x, x);
1144 
1145             if (n % 2 != 0) {
1146                 z = rmul(z, x);
1147             }
1148         }
1149     }
1150 
1151     function rmin(uint128 x, uint128 y) internal pure returns (uint128) {
1152         return hmin(x, y);
1153     }
1154 
1155     function rmax(uint128 x, uint128 y) internal pure returns (uint128) {
1156         return hmax(x, y);
1157     }
1158 
1159     function cast(uint256 x) internal pure returns (uint128 z) {
1160         assert((z = uint128(x)) == x);
1161     }
1162 
1163 }
1164 
1165 // File: @gnosis.pm/dx-contracts/contracts/Oracle/DSAuth.sol
1166 
1167 contract DSAuthority {
1168     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
1169 }
1170 
1171 
1172 contract DSAuthEvents {
1173     event LogSetAuthority(address indexed authority);
1174     event LogSetOwner(address indexed owner);
1175 }
1176 
1177 
1178 contract DSAuth is DSAuthEvents {
1179     DSAuthority public authority;
1180     address public owner;
1181 
1182     constructor() public {
1183         owner = msg.sender;
1184         emit LogSetOwner(msg.sender);
1185     }
1186 
1187     function setOwner(address owner_) public auth {
1188         owner = owner_;
1189         emit LogSetOwner(owner);
1190     }
1191 
1192     function setAuthority(DSAuthority authority_) public auth {
1193         authority = authority_;
1194         emit LogSetAuthority(address(authority));
1195     }
1196 
1197     modifier auth {
1198         require(isAuthorized(msg.sender, msg.sig), "It must be an authorized call");
1199         _;
1200     }
1201 
1202     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
1203         if (src == address(this)) {
1204             return true;
1205         } else if (src == owner) {
1206             return true;
1207         } else if (authority == DSAuthority(0)) {
1208             return false;
1209         } else {
1210             return authority.canCall(src, address(this), sig);
1211         }
1212     }
1213 }
1214 
1215 // File: @gnosis.pm/dx-contracts/contracts/Oracle/DSNote.sol
1216 
1217 contract DSNote {
1218     event LogNote(
1219         bytes4 indexed sig,
1220         address indexed guy,
1221         bytes32 indexed foo,
1222         bytes32 bar,
1223         uint wad,
1224         bytes fax
1225     );
1226 
1227     modifier note {
1228         bytes32 foo;
1229         bytes32 bar;
1230         // solium-disable-next-line security/no-inline-assembly
1231         assembly {
1232             foo := calldataload(4)
1233             bar := calldataload(36)
1234         }
1235 
1236         emit LogNote(
1237             msg.sig,
1238             msg.sender,
1239             foo,
1240             bar,
1241             msg.value,
1242             msg.data
1243         );
1244 
1245         _;
1246     }
1247 }
1248 
1249 // File: @gnosis.pm/dx-contracts/contracts/Oracle/DSThing.sol
1250 
1251 contract DSThing is DSAuth, DSNote, DSMath {}
1252 
1253 // File: @gnosis.pm/dx-contracts/contracts/Oracle/PriceFeed.sol
1254 
1255 /// price-feed.sol
1256 
1257 // Copyright (C) 2017  DappHub, LLC
1258 
1259 // Licensed under the Apache License, Version 2.0 (the "License").
1260 // You may not use this file except in compliance with the License.
1261 
1262 // Unless required by applicable law or agreed to in writing, software
1263 // distributed under the License is distributed on an "AS IS" BASIS,
1264 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1265 
1266 
1267 
1268 contract PriceFeed is DSThing {
1269     uint128 val;
1270     uint32 public zzz;
1271 
1272     function peek() public view returns (bytes32, bool) {
1273         return (bytes32(uint256(val)), block.timestamp < zzz);
1274     }
1275 
1276     function read() public view returns (bytes32) {
1277         assert(block.timestamp < zzz);
1278         return bytes32(uint256(val));
1279     }
1280 
1281     function post(uint128 val_, uint32 zzz_, address med_) public payable note auth {
1282         val = val_;
1283         zzz = zzz_;
1284         (bool success, ) = med_.call(abi.encodeWithSignature("poke()"));
1285         require(success, "The poke must succeed");
1286     }
1287 
1288     function void() public payable note auth {
1289         zzz = 0;
1290     }
1291 
1292 }
1293 
1294 // File: @gnosis.pm/dx-contracts/contracts/Oracle/DSValue.sol
1295 
1296 contract DSValue is DSThing {
1297     bool has;
1298     bytes32 val;
1299     function peek() public view returns (bytes32, bool) {
1300         return (val, has);
1301     }
1302 
1303     function read() public view returns (bytes32) {
1304         (bytes32 wut, bool _has) = peek();
1305         assert(_has);
1306         return wut;
1307     }
1308 
1309     function poke(bytes32 wut) public payable note auth {
1310         val = wut;
1311         has = true;
1312     }
1313 
1314     function void() public payable note auth {
1315         // unset the value
1316         has = false;
1317     }
1318 }
1319 
1320 // File: @gnosis.pm/dx-contracts/contracts/Oracle/Medianizer.sol
1321 
1322 contract Medianizer is DSValue {
1323     mapping(bytes12 => address) public values;
1324     mapping(address => bytes12) public indexes;
1325     bytes12 public next = bytes12(uint96(1));
1326     uint96 public minimun = 0x1;
1327 
1328     function set(address wat) public auth {
1329         bytes12 nextId = bytes12(uint96(next) + 1);
1330         assert(nextId != 0x0);
1331         set(next, wat);
1332         next = nextId;
1333     }
1334 
1335     function set(bytes12 pos, address wat) public payable note auth {
1336         require(pos != 0x0, "pos cannot be 0x0");
1337         require(wat == address(0) || indexes[wat] == 0, "wat is not defined or it has an index");
1338 
1339         indexes[values[pos]] = bytes12(0); // Making sure to remove a possible existing address in that position
1340 
1341         if (wat != address(0)) {
1342             indexes[wat] = pos;
1343         }
1344 
1345         values[pos] = wat;
1346     }
1347 
1348     function setMin(uint96 min_) public payable note auth {
1349         require(min_ != 0x0, "min cannot be 0x0");
1350         minimun = min_;
1351     }
1352 
1353     function setNext(bytes12 next_) public payable note auth {
1354         require(next_ != 0x0, "next cannot be 0x0");
1355         next = next_;
1356     }
1357 
1358     function unset(bytes12 pos) public {
1359         set(pos, address(0));
1360     }
1361 
1362     function unset(address wat) public {
1363         set(indexes[wat], address(0));
1364     }
1365 
1366     function poke() public {
1367         poke(0);
1368     }
1369 
1370     function poke(bytes32) public payable note {
1371         (val, has) = compute();
1372     }
1373 
1374     function compute() public view returns (bytes32, bool) {
1375         bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
1376         uint96 ctr = 0;
1377         for (uint96 i = 1; i < uint96(next); i++) {
1378             if (values[bytes12(i)] != address(0)) {
1379                 (bytes32 wut, bool wuz) = DSValue(values[bytes12(i)]).peek();
1380                 if (wuz) {
1381                     if (ctr == 0 || wut >= wuts[ctr - 1]) {
1382                         wuts[ctr] = wut;
1383                     } else {
1384                         uint96 j = 0;
1385                         while (wut >= wuts[j]) {
1386                             j++;
1387                         }
1388                         for (uint96 k = ctr; k > j; k--) {
1389                             wuts[k] = wuts[k - 1];
1390                         }
1391                         wuts[j] = wut;
1392                     }
1393                     ctr++;
1394                 }
1395             }
1396         }
1397 
1398         if (ctr < minimun)
1399             return (val, false);
1400 
1401         bytes32 value;
1402         if (ctr % 2 == 0) {
1403             uint128 val1 = uint128(uint(wuts[(ctr / 2) - 1]));
1404             uint128 val2 = uint128(uint(wuts[ctr / 2]));
1405             value = bytes32(uint256(wdiv(hadd(val1, val2), 2 ether)));
1406         } else {
1407             value = wuts[(ctr - 1) / 2];
1408         }
1409 
1410         return (value, true);
1411     }
1412 }
1413 
1414 // File: @gnosis.pm/dx-contracts/contracts/Oracle/PriceOracleInterface.sol
1415 
1416 /*
1417 This contract is the interface between the MakerDAO priceFeed and our DX platform.
1418 */
1419 
1420 
1421 
1422 
1423 contract PriceOracleInterface {
1424     address public priceFeedSource;
1425     address public owner;
1426     bool public emergencyMode;
1427 
1428     // Modifiers
1429     modifier onlyOwner() {
1430         require(msg.sender == owner, "Only the owner can do the operation");
1431         _;
1432     }
1433 
1434     /// @dev constructor of the contract
1435     /// @param _priceFeedSource address of price Feed Source -> should be maker feeds Medianizer contract
1436     constructor(address _owner, address _priceFeedSource) public {
1437         owner = _owner;
1438         priceFeedSource = _priceFeedSource;
1439     }
1440     
1441     /// @dev gives the owner the possibility to put the Interface into an emergencyMode, which will
1442     /// output always a price of 600 USD. This gives everyone time to set up a new pricefeed.
1443     function raiseEmergency(bool _emergencyMode) public onlyOwner {
1444         emergencyMode = _emergencyMode;
1445     }
1446 
1447     /// @dev updates the priceFeedSource
1448     /// @param _owner address of owner
1449     function updateCurator(address _owner) public onlyOwner {
1450         owner = _owner;
1451     }
1452 
1453     /// @dev returns the USDETH price
1454     function getUsdEthPricePeek() public view returns (bytes32 price, bool valid) {
1455         return Medianizer(priceFeedSource).peek();
1456     }
1457 
1458     /// @dev returns the USDETH price, ie gets the USD price from Maker feed with 18 digits, but last 18 digits are cut off
1459     function getUSDETHPrice() public view returns (uint256) {
1460         // if the contract is in the emergencyMode, because there is an issue with the oracle, we will simply return a price of 600 USD
1461         if (emergencyMode) {
1462             return 600;
1463         }
1464         (bytes32 price, ) = Medianizer(priceFeedSource).peek();
1465 
1466         // ensuring that there is no underflow or overflow possible,
1467         // even if the price is compromised
1468         uint priceUint = uint256(price)/(1 ether);
1469         if (priceUint == 0) {
1470             return 1;
1471         }
1472         if (priceUint > 1000000) {
1473             return 1000000; 
1474         }
1475         return priceUint;
1476     }
1477 }
1478 
1479 // File: @gnosis.pm/dx-contracts/contracts/base/EthOracle.sol
1480 
1481 contract EthOracle is AuctioneerManaged, DxMath {
1482     uint constant WAITING_PERIOD_CHANGE_ORACLE = 30 days;
1483 
1484     // Price Oracle interface
1485     PriceOracleInterface public ethUSDOracle;
1486     // Price Oracle interface proposals during update process
1487     PriceOracleInterface public newProposalEthUSDOracle;
1488 
1489     uint public oracleInterfaceCountdown;
1490 
1491     event NewOracleProposal(PriceOracleInterface priceOracleInterface);
1492 
1493     function initiateEthUsdOracleUpdate(PriceOracleInterface _ethUSDOracle) public onlyAuctioneer {
1494         require(address(_ethUSDOracle) != address(0), "The oracle address must be valid");
1495         newProposalEthUSDOracle = _ethUSDOracle;
1496         oracleInterfaceCountdown = add(block.timestamp, WAITING_PERIOD_CHANGE_ORACLE);
1497         emit NewOracleProposal(_ethUSDOracle);
1498     }
1499 
1500     function updateEthUSDOracle() public {
1501         require(address(newProposalEthUSDOracle) != address(0), "The new proposal must be a valid addres");
1502         require(
1503             oracleInterfaceCountdown < block.timestamp,
1504             "It's not possible to update the oracle during the waiting period"
1505         );
1506         ethUSDOracle = newProposalEthUSDOracle;
1507         newProposalEthUSDOracle = PriceOracleInterface(0);
1508     }
1509 }
1510 
1511 // File: @gnosis.pm/dx-contracts/contracts/base/DxUpgrade.sol
1512 
1513 contract DxUpgrade is Proxied, AuctioneerManaged, DxMath {
1514     uint constant WAITING_PERIOD_CHANGE_MASTERCOPY = 30 days;
1515 
1516     address public newMasterCopy;
1517     // Time when new masterCopy is updatabale
1518     uint public masterCopyCountdown;
1519 
1520     event NewMasterCopyProposal(address newMasterCopy);
1521 
1522     function startMasterCopyCountdown(address _masterCopy) public onlyAuctioneer {
1523         require(_masterCopy != address(0), "The new master copy must be a valid address");
1524 
1525         // Update masterCopyCountdown
1526         newMasterCopy = _masterCopy;
1527         masterCopyCountdown = add(block.timestamp, WAITING_PERIOD_CHANGE_MASTERCOPY);
1528         emit NewMasterCopyProposal(_masterCopy);
1529     }
1530 
1531     function updateMasterCopy() public {
1532         require(newMasterCopy != address(0), "The new master copy must be a valid address");
1533         require(block.timestamp >= masterCopyCountdown, "The master contract cannot be updated in a waiting period");
1534 
1535         // Update masterCopy
1536         masterCopy = newMasterCopy;
1537         newMasterCopy = address(0);
1538     }
1539 
1540 }
1541 
1542 // File: @gnosis.pm/dx-contracts/contracts/DutchExchange.sol
1543 
1544 /// @title Dutch Exchange - exchange token pairs with the clever mechanism of the dutch auction
1545 /// @author Alex Herrmann - <alex@gnosis.pm>
1546 /// @author Dominik Teiml - <dominik@gnosis.pm>
1547 
1548 contract DutchExchange is DxUpgrade, TokenWhitelist, EthOracle, SafeTransfer {
1549 
1550     // The price is a rational number, so we need a concept of a fraction
1551     struct Fraction {
1552         uint num;
1553         uint den;
1554     }
1555 
1556     uint constant WAITING_PERIOD_NEW_TOKEN_PAIR = 6 hours;
1557     uint constant WAITING_PERIOD_NEW_AUCTION = 10 minutes;
1558     uint constant AUCTION_START_WAITING_FOR_FUNDING = 1;
1559 
1560     // > Storage
1561     // Ether ERC-20 token
1562     address public ethToken;
1563 
1564     // Minimum required sell funding for adding a new token pair, in USD
1565     uint public thresholdNewTokenPair;
1566     // Minimum required sell funding for starting antoher auction, in USD
1567     uint public thresholdNewAuction;
1568     // Fee reduction token (magnolia, ERC-20 token)
1569     TokenFRT public frtToken;
1570     // Token for paying fees
1571     TokenOWL public owlToken;
1572 
1573     // For the following three mappings, there is one mapping for each token pair
1574     // The order which the tokens should be called is smaller, larger
1575     // These variables should never be called directly! They have getters below
1576     // Token => Token => index
1577     mapping(address => mapping(address => uint)) public latestAuctionIndices;
1578     // Token => Token => time
1579     mapping (address => mapping (address => uint)) public auctionStarts;
1580     // Token => Token => auctionIndex => time
1581     mapping (address => mapping (address => mapping (uint => uint))) public clearingTimes;
1582 
1583     // Token => Token => auctionIndex => price
1584     mapping(address => mapping(address => mapping(uint => Fraction))) public closingPrices;
1585 
1586     // Token => Token => amount
1587     mapping(address => mapping(address => uint)) public sellVolumesCurrent;
1588     // Token => Token => amount
1589     mapping(address => mapping(address => uint)) public sellVolumesNext;
1590     // Token => Token => amount
1591     mapping(address => mapping(address => uint)) public buyVolumes;
1592 
1593     // Token => user => amount
1594     // balances stores a user's balance in the DutchX
1595     mapping(address => mapping(address => uint)) public balances;
1596 
1597     // Token => Token => auctionIndex => amount
1598     mapping(address => mapping(address => mapping(uint => uint))) public extraTokens;
1599 
1600     // Token => Token =>  auctionIndex => user => amount
1601     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public sellerBalances;
1602     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public buyerBalances;
1603     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public claimedAmounts;
1604 
1605     function depositAndSell(address sellToken, address buyToken, uint amount)
1606         external
1607         returns (uint newBal, uint auctionIndex, uint newSellerBal)
1608     {
1609         newBal = deposit(sellToken, amount);
1610         (auctionIndex, newSellerBal) = postSellOrder(sellToken, buyToken, 0, amount);
1611     }
1612 
1613     function claimAndWithdraw(address sellToken, address buyToken, address user, uint auctionIndex, uint amount)
1614         external
1615         returns (uint returned, uint frtsIssued, uint newBal)
1616     {
1617         (returned, frtsIssued) = claimSellerFunds(sellToken, buyToken, user, auctionIndex);
1618         newBal = withdraw(buyToken, amount);
1619     }
1620 
1621     /// @dev for multiple claims
1622     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1623     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1624     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1625     /// @param user is the user who wants to his tokens
1626     function claimTokensFromSeveralAuctionsAsSeller(
1627         address[] calldata auctionSellTokens,
1628         address[] calldata auctionBuyTokens,
1629         uint[] calldata auctionIndices,
1630         address user
1631     ) external returns (uint[] memory, uint[] memory)
1632     {
1633         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1634 
1635         uint[] memory claimAmounts = new uint[](length);
1636         uint[] memory frtsIssuedList = new uint[](length);
1637 
1638         for (uint i = 0; i < length; i++) {
1639             (claimAmounts[i], frtsIssuedList[i]) = claimSellerFunds(
1640                 auctionSellTokens[i],
1641                 auctionBuyTokens[i],
1642                 user,
1643                 auctionIndices[i]
1644             );
1645         }
1646 
1647         return (claimAmounts, frtsIssuedList);
1648     }
1649 
1650     /// @dev for multiple claims
1651     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1652     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1653     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1654     /// @param user is the user who wants to his tokens
1655     function claimTokensFromSeveralAuctionsAsBuyer(
1656         address[] calldata auctionSellTokens,
1657         address[] calldata auctionBuyTokens,
1658         uint[] calldata auctionIndices,
1659         address user
1660     ) external returns (uint[] memory, uint[] memory)
1661     {
1662         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1663 
1664         uint[] memory claimAmounts = new uint[](length);
1665         uint[] memory frtsIssuedList = new uint[](length);
1666 
1667         for (uint i = 0; i < length; i++) {
1668             (claimAmounts[i], frtsIssuedList[i]) = claimBuyerFunds(
1669                 auctionSellTokens[i],
1670                 auctionBuyTokens[i],
1671                 user,
1672                 auctionIndices[i]
1673             );
1674         }
1675 
1676         return (claimAmounts, frtsIssuedList);
1677     }
1678 
1679     /// @dev for multiple withdraws
1680     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1681     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1682     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1683     function claimAndWithdrawTokensFromSeveralAuctionsAsSeller(
1684         address[] calldata auctionSellTokens,
1685         address[] calldata auctionBuyTokens,
1686         uint[] calldata auctionIndices
1687     ) external returns (uint[] memory, uint frtsIssued)
1688     {
1689         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1690 
1691         uint[] memory claimAmounts = new uint[](length);
1692         uint claimFrts = 0;
1693 
1694         for (uint i = 0; i < length; i++) {
1695             (claimAmounts[i], claimFrts) = claimSellerFunds(
1696                 auctionSellTokens[i],
1697                 auctionBuyTokens[i],
1698                 msg.sender,
1699                 auctionIndices[i]
1700             );
1701 
1702             frtsIssued += claimFrts;
1703 
1704             withdraw(auctionBuyTokens[i], claimAmounts[i]);
1705         }
1706 
1707         return (claimAmounts, frtsIssued);
1708     }
1709 
1710     /// @dev for multiple withdraws
1711     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1712     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1713     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1714     function claimAndWithdrawTokensFromSeveralAuctionsAsBuyer(
1715         address[] calldata auctionSellTokens,
1716         address[] calldata auctionBuyTokens,
1717         uint[] calldata auctionIndices
1718     ) external returns (uint[] memory, uint frtsIssued)
1719     {
1720         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1721 
1722         uint[] memory claimAmounts = new uint[](length);
1723         uint claimFrts = 0;
1724 
1725         for (uint i = 0; i < length; i++) {
1726             (claimAmounts[i], claimFrts) = claimBuyerFunds(
1727                 auctionSellTokens[i],
1728                 auctionBuyTokens[i],
1729                 msg.sender,
1730                 auctionIndices[i]
1731             );
1732 
1733             frtsIssued += claimFrts;
1734 
1735             withdraw(auctionSellTokens[i], claimAmounts[i]);
1736         }
1737 
1738         return (claimAmounts, frtsIssued);
1739     }
1740 
1741     function getMasterCopy() external view returns (address) {
1742         return masterCopy;
1743     }
1744 
1745     /// @dev Constructor-Function creates exchange
1746     /// @param _frtToken - address of frtToken ERC-20 token
1747     /// @param _owlToken - address of owlToken ERC-20 token
1748     /// @param _auctioneer - auctioneer for managing interfaces
1749     /// @param _ethToken - address of ETH ERC-20 token
1750     /// @param _ethUSDOracle - address of the oracle contract for fetching feeds
1751     /// @param _thresholdNewTokenPair - Minimum required sell funding for adding a new token pair, in USD
1752     function setupDutchExchange(
1753         TokenFRT _frtToken,
1754         TokenOWL _owlToken,
1755         address _auctioneer,
1756         address _ethToken,
1757         PriceOracleInterface _ethUSDOracle,
1758         uint _thresholdNewTokenPair,
1759         uint _thresholdNewAuction
1760     ) public
1761     {
1762         // Make sure contract hasn't been initialised
1763         require(ethToken == address(0), "The contract must be uninitialized");
1764 
1765         // Validates inputs
1766         require(address(_owlToken) != address(0), "The OWL address must be valid");
1767         require(address(_frtToken) != address(0), "The FRT address must be valid");
1768         require(_auctioneer != address(0), "The auctioneer address must be valid");
1769         require(_ethToken != address(0), "The WETH address must be valid");
1770         require(address(_ethUSDOracle) != address(0), "The oracle address must be valid");
1771 
1772         frtToken = _frtToken;
1773         owlToken = _owlToken;
1774         auctioneer = _auctioneer;
1775         ethToken = _ethToken;
1776         ethUSDOracle = _ethUSDOracle;
1777         thresholdNewTokenPair = _thresholdNewTokenPair;
1778         thresholdNewAuction = _thresholdNewAuction;
1779     }
1780 
1781     function updateThresholdNewTokenPair(uint _thresholdNewTokenPair) public onlyAuctioneer {
1782         thresholdNewTokenPair = _thresholdNewTokenPair;
1783     }
1784 
1785     function updateThresholdNewAuction(uint _thresholdNewAuction) public onlyAuctioneer {
1786         thresholdNewAuction = _thresholdNewAuction;
1787     }
1788 
1789     /// @param initialClosingPriceNum initial price will be 2 * initialClosingPrice. This is its numerator
1790     /// @param initialClosingPriceDen initial price will be 2 * initialClosingPrice. This is its denominator
1791     function addTokenPair(
1792         address token1,
1793         address token2,
1794         uint token1Funding,
1795         uint token2Funding,
1796         uint initialClosingPriceNum,
1797         uint initialClosingPriceDen
1798     ) public
1799     {
1800         // R1
1801         require(token1 != token2, "You cannot add a token pair using the same token");
1802 
1803         // R2
1804         require(initialClosingPriceNum != 0, "You must set the numerator for the initial price");
1805 
1806         // R3
1807         require(initialClosingPriceDen != 0, "You must set the denominator for the initial price");
1808 
1809         // R4
1810         require(getAuctionIndex(token1, token2) == 0, "The token pair was already added");
1811 
1812         // R5: to prevent overflow
1813         require(initialClosingPriceNum < 10 ** 18, "You must set a smaller numerator for the initial price");
1814 
1815         // R6
1816         require(initialClosingPriceDen < 10 ** 18, "You must set a smaller denominator for the initial price");
1817 
1818         setAuctionIndex(token1, token2);
1819 
1820         token1Funding = min(token1Funding, balances[token1][msg.sender]);
1821         token2Funding = min(token2Funding, balances[token2][msg.sender]);
1822 
1823         // R7
1824         require(token1Funding < 10 ** 30, "You should use a smaller funding for token 1");
1825 
1826         // R8
1827         require(token2Funding < 10 ** 30, "You should use a smaller funding for token 2");
1828 
1829         uint fundedValueUSD;
1830         uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();
1831 
1832         // Compute fundedValueUSD
1833         address ethTokenMem = ethToken;
1834         if (token1 == ethTokenMem) {
1835             // C1
1836             // MUL: 10^30 * 10^6 = 10^36
1837             fundedValueUSD = mul(token1Funding, ethUSDPrice);
1838         } else if (token2 == ethTokenMem) {
1839             // C2
1840             // MUL: 10^30 * 10^6 = 10^36
1841             fundedValueUSD = mul(token2Funding, ethUSDPrice);
1842         } else {
1843             // C3: Neither token is ethToken
1844             fundedValueUSD = calculateFundedValueTokenToken(
1845                 token1,
1846                 token2,
1847                 token1Funding,
1848                 token2Funding,
1849                 ethTokenMem,
1850                 ethUSDPrice
1851             );
1852         }
1853 
1854         // R5
1855         require(fundedValueUSD >= thresholdNewTokenPair, "You should surplus the threshold for adding token pairs");
1856 
1857         // Save prices of opposite auctions
1858         closingPrices[token1][token2][0] = Fraction(initialClosingPriceNum, initialClosingPriceDen);
1859         closingPrices[token2][token1][0] = Fraction(initialClosingPriceDen, initialClosingPriceNum);
1860 
1861         // Split into two fns because of 16 local-var cap
1862         addTokenPairSecondPart(token1, token2, token1Funding, token2Funding);
1863     }
1864 
1865     function deposit(address tokenAddress, uint amount) public returns (uint) {
1866         // R1
1867         require(safeTransfer(tokenAddress, msg.sender, amount, true), "The deposit transaction must succeed");
1868 
1869         uint newBal = add(balances[tokenAddress][msg.sender], amount);
1870 
1871         balances[tokenAddress][msg.sender] = newBal;
1872 
1873         emit NewDeposit(tokenAddress, amount);
1874 
1875         return newBal;
1876     }
1877 
1878     function withdraw(address tokenAddress, uint amount) public returns (uint) {
1879         uint usersBalance = balances[tokenAddress][msg.sender];
1880         amount = min(amount, usersBalance);
1881 
1882         // R1
1883         require(amount > 0, "The amount must be greater than 0");
1884 
1885         uint newBal = sub(usersBalance, amount);
1886         balances[tokenAddress][msg.sender] = newBal;
1887 
1888         // R2
1889         require(safeTransfer(tokenAddress, msg.sender, amount, false), "The withdraw transfer must succeed");
1890         emit NewWithdrawal(tokenAddress, amount);
1891 
1892         return newBal;
1893     }
1894 
1895     function postSellOrder(address sellToken, address buyToken, uint auctionIndex, uint amount)
1896         public
1897         returns (uint, uint)
1898     {
1899         // Note: if a user specifies auctionIndex of 0, it
1900         // means he is agnostic which auction his sell order goes into
1901 
1902         amount = min(amount, balances[sellToken][msg.sender]);
1903 
1904         // R1
1905         // require(amount >= 0, "Sell amount should be greater than 0");
1906 
1907         // R2
1908         uint latestAuctionIndex = getAuctionIndex(sellToken, buyToken);
1909         require(latestAuctionIndex > 0);
1910 
1911         // R3
1912         uint auctionStart = getAuctionStart(sellToken, buyToken);
1913         if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING || auctionStart > now) {
1914             // C1: We are in the 10 minute buffer period
1915             // OR waiting for an auction to receive sufficient sellVolume
1916             // Auction has already cleared, and index has been incremented
1917             // sell order must use that auction index
1918             // R1.1
1919             if (auctionIndex == 0) {
1920                 auctionIndex = latestAuctionIndex;
1921             } else {
1922                 require(auctionIndex == latestAuctionIndex, "Auction index should be equal to latest auction index");
1923             }
1924 
1925             // R1.2
1926             require(add(sellVolumesCurrent[sellToken][buyToken], amount) < 10 ** 30);
1927         } else {
1928             // C2
1929             // R2.1: Sell orders must go to next auction
1930             if (auctionIndex == 0) {
1931                 auctionIndex = latestAuctionIndex + 1;
1932             } else {
1933                 require(auctionIndex == latestAuctionIndex + 1);
1934             }
1935 
1936             // R2.2
1937             require(add(sellVolumesNext[sellToken][buyToken], amount) < 10 ** 30);
1938         }
1939 
1940         // Fee mechanism, fees are added to extraTokens
1941         uint amountAfterFee = settleFee(sellToken, buyToken, auctionIndex, amount);
1942 
1943         // Update variables
1944         balances[sellToken][msg.sender] = sub(balances[sellToken][msg.sender], amount);
1945         uint newSellerBal = add(sellerBalances[sellToken][buyToken][auctionIndex][msg.sender], amountAfterFee);
1946         sellerBalances[sellToken][buyToken][auctionIndex][msg.sender] = newSellerBal;
1947 
1948         if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING || auctionStart > now) {
1949             // C1
1950             uint sellVolumeCurrent = sellVolumesCurrent[sellToken][buyToken];
1951             sellVolumesCurrent[sellToken][buyToken] = add(sellVolumeCurrent, amountAfterFee);
1952         } else {
1953             // C2
1954             uint sellVolumeNext = sellVolumesNext[sellToken][buyToken];
1955             sellVolumesNext[sellToken][buyToken] = add(sellVolumeNext, amountAfterFee);
1956 
1957             // close previous auction if theoretically closed
1958             closeTheoreticalClosedAuction(sellToken, buyToken, latestAuctionIndex);
1959         }
1960 
1961         if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING) {
1962             scheduleNextAuction(sellToken, buyToken);
1963         }
1964 
1965         emit NewSellOrder(sellToken, buyToken, msg.sender, auctionIndex, amountAfterFee);
1966 
1967         return (auctionIndex, newSellerBal);
1968     }
1969 
1970     function postBuyOrder(address sellToken, address buyToken, uint auctionIndex, uint amount)
1971         public
1972         returns (uint newBuyerBal)
1973     {
1974         // R1: auction must not have cleared
1975         require(closingPrices[sellToken][buyToken][auctionIndex].den == 0);
1976 
1977         uint auctionStart = getAuctionStart(sellToken, buyToken);
1978 
1979         // R2
1980         require(auctionStart <= now);
1981 
1982         // R4
1983         require(auctionIndex == getAuctionIndex(sellToken, buyToken));
1984 
1985         // R5: auction must not be in waiting period
1986         require(auctionStart > AUCTION_START_WAITING_FOR_FUNDING);
1987 
1988         // R6: auction must be funded
1989         require(sellVolumesCurrent[sellToken][buyToken] > 0);
1990 
1991         uint buyVolume = buyVolumes[sellToken][buyToken];
1992         amount = min(amount, balances[buyToken][msg.sender]);
1993 
1994         // R7
1995         require(add(buyVolume, amount) < 10 ** 30);
1996 
1997         // Overbuy is when a part of a buy order clears an auction
1998         // In that case we only process the part before the overbuy
1999         // To calculate overbuy, we first get current price
2000         uint sellVolume = sellVolumesCurrent[sellToken][buyToken];
2001 
2002         uint num;
2003         uint den;
2004         (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
2005         // 10^30 * 10^37 = 10^67
2006         uint outstandingVolume = atleastZero(int(mul(sellVolume, num) / den - buyVolume));
2007 
2008         uint amountAfterFee;
2009         if (amount < outstandingVolume) {
2010             if (amount > 0) {
2011                 amountAfterFee = settleFee(buyToken, sellToken, auctionIndex, amount);
2012             }
2013         } else {
2014             amount = outstandingVolume;
2015             amountAfterFee = outstandingVolume;
2016         }
2017 
2018         // Here we could also use outstandingVolume or amountAfterFee, it doesn't matter
2019         if (amount > 0) {
2020             // Update variables
2021             balances[buyToken][msg.sender] = sub(balances[buyToken][msg.sender], amount);
2022             newBuyerBal = add(buyerBalances[sellToken][buyToken][auctionIndex][msg.sender], amountAfterFee);
2023             buyerBalances[sellToken][buyToken][auctionIndex][msg.sender] = newBuyerBal;
2024             buyVolumes[sellToken][buyToken] = add(buyVolumes[sellToken][buyToken], amountAfterFee);
2025             emit NewBuyOrder(sellToken, buyToken, msg.sender, auctionIndex, amountAfterFee);
2026         }
2027 
2028         // Checking for equality would suffice here. nevertheless:
2029         if (amount >= outstandingVolume) {
2030             // Clear auction
2031             clearAuction(sellToken, buyToken, auctionIndex, sellVolume);
2032         }
2033 
2034         return (newBuyerBal);
2035     }
2036 
2037     function claimSellerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
2038         public
2039         returns (
2040         // < (10^60, 10^61)
2041         uint returned,
2042         uint frtsIssued
2043     )
2044     {
2045         closeTheoreticalClosedAuction(sellToken, buyToken, auctionIndex);
2046         uint sellerBalance = sellerBalances[sellToken][buyToken][auctionIndex][user];
2047 
2048         // R1
2049         require(sellerBalance > 0);
2050 
2051         // Get closing price for said auction
2052         Fraction memory closingPrice = closingPrices[sellToken][buyToken][auctionIndex];
2053         uint num = closingPrice.num;
2054         uint den = closingPrice.den;
2055 
2056         // R2: require auction to have cleared
2057         require(den > 0);
2058 
2059         // Calculate return
2060         // < 10^30 * 10^30 = 10^60
2061         returned = mul(sellerBalance, num) / den;
2062 
2063         frtsIssued = issueFrts(
2064             sellToken,
2065             buyToken,
2066             returned,
2067             auctionIndex,
2068             sellerBalance,
2069             user
2070         );
2071 
2072         // Claim tokens
2073         sellerBalances[sellToken][buyToken][auctionIndex][user] = 0;
2074         if (returned > 0) {
2075             balances[buyToken][user] = add(balances[buyToken][user], returned);
2076         }
2077         emit NewSellerFundsClaim(
2078             sellToken,
2079             buyToken,
2080             user,
2081             auctionIndex,
2082             returned,
2083             frtsIssued
2084         );
2085     }
2086 
2087     function claimBuyerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
2088         public
2089         returns (uint returned, uint frtsIssued)
2090     {
2091         closeTheoreticalClosedAuction(sellToken, buyToken, auctionIndex);
2092 
2093         uint num;
2094         uint den;
2095         (returned, num, den) = getUnclaimedBuyerFunds(sellToken, buyToken, user, auctionIndex);
2096 
2097         if (closingPrices[sellToken][buyToken][auctionIndex].den == 0) {
2098             // Auction is running
2099             claimedAmounts[sellToken][buyToken][auctionIndex][user] = add(
2100                 claimedAmounts[sellToken][buyToken][auctionIndex][user],
2101                 returned
2102             );
2103         } else {
2104             // Auction has closed
2105             // We DON'T want to check for returned > 0, because that would fail if a user claims
2106             // intermediate funds & auction clears in same block (he/she would not be able to claim extraTokens)
2107 
2108             // Assign extra sell tokens (this is possible only after auction has cleared,
2109             // because buyVolume could still increase before that)
2110             uint extraTokensTotal = extraTokens[sellToken][buyToken][auctionIndex];
2111             uint buyerBalance = buyerBalances[sellToken][buyToken][auctionIndex][user];
2112 
2113             // closingPrices.num represents buyVolume
2114             // < 10^30 * 10^30 = 10^60
2115             uint tokensExtra = mul(
2116                 buyerBalance,
2117                 extraTokensTotal
2118             ) / closingPrices[sellToken][buyToken][auctionIndex].num;
2119             returned = add(returned, tokensExtra);
2120 
2121             frtsIssued = issueFrts(
2122                 buyToken,
2123                 sellToken,
2124                 mul(buyerBalance, den) / num,
2125                 auctionIndex,
2126                 buyerBalance,
2127                 user
2128             );
2129 
2130             // Auction has closed
2131             // Reset buyerBalances and claimedAmounts
2132             buyerBalances[sellToken][buyToken][auctionIndex][user] = 0;
2133             claimedAmounts[sellToken][buyToken][auctionIndex][user] = 0;
2134         }
2135 
2136         // Claim tokens
2137         if (returned > 0) {
2138             balances[sellToken][user] = add(balances[sellToken][user], returned);
2139         }
2140 
2141         emit NewBuyerFundsClaim(
2142             sellToken,
2143             buyToken,
2144             user,
2145             auctionIndex,
2146             returned,
2147             frtsIssued
2148         );
2149     }
2150 
2151     /// @dev allows to close possible theoretical closed markets
2152     /// @param sellToken sellToken of an auction
2153     /// @param buyToken buyToken of an auction
2154     /// @param auctionIndex is the auctionIndex of the auction
2155     function closeTheoreticalClosedAuction(address sellToken, address buyToken, uint auctionIndex) public {
2156         if (auctionIndex == getAuctionIndex(
2157             buyToken,
2158             sellToken
2159         ) && closingPrices[sellToken][buyToken][auctionIndex].num == 0) {
2160             uint buyVolume = buyVolumes[sellToken][buyToken];
2161             uint sellVolume = sellVolumesCurrent[sellToken][buyToken];
2162             uint num;
2163             uint den;
2164             (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
2165             // 10^30 * 10^37 = 10^67
2166             if (sellVolume > 0) {
2167                 uint outstandingVolume = atleastZero(int(mul(sellVolume, num) / den - buyVolume));
2168 
2169                 if (outstandingVolume == 0) {
2170                     postBuyOrder(sellToken, buyToken, auctionIndex, 0);
2171                 }
2172             }
2173         }
2174     }
2175 
2176     /// @dev Claim buyer funds for one auction
2177     function getUnclaimedBuyerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
2178         public
2179         view
2180         returns (
2181         // < (10^67, 10^37)
2182         uint unclaimedBuyerFunds,
2183         uint num,
2184         uint den
2185     )
2186     {
2187         // R1: checks if particular auction has ever run
2188         require(auctionIndex <= getAuctionIndex(sellToken, buyToken));
2189 
2190         (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
2191 
2192         if (num == 0) {
2193             // This should rarely happen - as long as there is >= 1 buy order,
2194             // auction will clear before price = 0. So this is just fail-safe
2195             unclaimedBuyerFunds = 0;
2196         } else {
2197             uint buyerBalance = buyerBalances[sellToken][buyToken][auctionIndex][user];
2198             // < 10^30 * 10^37 = 10^67
2199             unclaimedBuyerFunds = atleastZero(
2200                 int(mul(buyerBalance, den) / num - claimedAmounts[sellToken][buyToken][auctionIndex][user])
2201             );
2202         }
2203     }
2204 
2205     function getFeeRatio(address user)
2206         public
2207         view
2208         returns (
2209         // feeRatio < 10^4
2210         uint num,
2211         uint den
2212     )
2213     {
2214         uint totalSupply = frtToken.totalSupply();
2215         uint lockedFrt = frtToken.lockedTokenBalances(user);
2216 
2217         /*
2218           Fee Model:
2219             locked FRT range     Fee
2220             -----------------   ------
2221             [0, 0.01%)           0.5%
2222             [0.01%, 0.1%)        0.4%
2223             [0.1%, 1%)           0.3%
2224             [1%, 10%)            0.2%
2225             [10%, 100%)          0.1%
2226         */
2227 
2228         if (lockedFrt * 10000 < totalSupply || totalSupply == 0) {
2229             // Maximum fee, if user has locked less than 0.01% of the total FRT
2230             // Fee: 0.5%
2231             num = 1;
2232             den = 200;
2233         } else if (lockedFrt * 1000 < totalSupply) {
2234             // If user has locked more than 0.01% and less than 0.1% of the total FRT
2235             // Fee: 0.4%
2236             num = 1;
2237             den = 250;
2238         } else if (lockedFrt * 100 < totalSupply) {
2239             // If user has locked more than 0.1% and less than 1% of the total FRT
2240             // Fee: 0.3%
2241             num = 3;
2242             den = 1000;
2243         } else if (lockedFrt * 10 < totalSupply) {
2244             // If user has locked more than 1% and less than 10% of the total FRT
2245             // Fee: 0.2%
2246             num = 1;
2247             den = 500;
2248         } else {
2249             // If user has locked more than 10% of the total FRT
2250             // Fee: 0.1%
2251             num = 1;
2252             den = 1000;
2253         }
2254     }
2255 
2256     //@ dev returns price in units [token2]/[token1]
2257     //@ param token1 first token for price calculation
2258     //@ param token2 second token for price calculation
2259     //@ param auctionIndex index for the auction to get the averaged price from
2260     function getPriceInPastAuction(
2261         address token1,
2262         address token2,
2263         uint auctionIndex
2264     )
2265         public
2266         view
2267         // price < 10^31
2268         returns (uint num, uint den)
2269     {
2270         if (token1 == token2) {
2271             // C1
2272             num = 1;
2273             den = 1;
2274         } else {
2275             // C2
2276             // R2.1
2277             // require(auctionIndex >= 0);
2278 
2279             // C3
2280             // R3.1
2281             require(auctionIndex <= getAuctionIndex(token1, token2));
2282             // auction still running
2283 
2284             uint i = 0;
2285             bool correctPair = false;
2286             Fraction memory closingPriceToken1;
2287             Fraction memory closingPriceToken2;
2288 
2289             while (!correctPair) {
2290                 closingPriceToken2 = closingPrices[token2][token1][auctionIndex - i];
2291                 closingPriceToken1 = closingPrices[token1][token2][auctionIndex - i];
2292 
2293                 if (closingPriceToken1.num > 0 && closingPriceToken1.den > 0 ||
2294                     closingPriceToken2.num > 0 && closingPriceToken2.den > 0)
2295                 {
2296                     correctPair = true;
2297                 }
2298                 i++;
2299             }
2300 
2301             // At this point at least one closing price is strictly positive
2302             // If only one is positive, we want to output that
2303             if (closingPriceToken1.num == 0 || closingPriceToken1.den == 0) {
2304                 num = closingPriceToken2.den;
2305                 den = closingPriceToken2.num;
2306             } else if (closingPriceToken2.num == 0 || closingPriceToken2.den == 0) {
2307                 num = closingPriceToken1.num;
2308                 den = closingPriceToken1.den;
2309             } else {
2310                 // If both prices are positive, output weighted average
2311                 num = closingPriceToken2.den + closingPriceToken1.num;
2312                 den = closingPriceToken2.num + closingPriceToken1.den;
2313             }
2314         }
2315     }
2316 
2317     function scheduleNextAuction(
2318         address sellToken,
2319         address buyToken
2320     )
2321         internal
2322     {
2323         (uint sellVolume, uint sellVolumeOpp) = getSellVolumesInUSD(sellToken, buyToken);
2324 
2325         bool enoughSellVolume = sellVolume >= thresholdNewAuction;
2326         bool enoughSellVolumeOpp = sellVolumeOpp >= thresholdNewAuction;
2327         bool schedule;
2328         // Make sure both sides have liquidity in order to start the auction
2329         if (enoughSellVolume && enoughSellVolumeOpp) {
2330             schedule = true;
2331         } else if (enoughSellVolume || enoughSellVolumeOpp) {
2332             // But if the auction didn't start in 24h, then is enough to have
2333             // liquidity in one of the two sides
2334             uint latestAuctionIndex = getAuctionIndex(sellToken, buyToken);
2335             uint clearingTime = getClearingTime(sellToken, buyToken, latestAuctionIndex - 1);
2336             schedule = clearingTime <= now - 24 hours;
2337         }
2338 
2339         if (schedule) {
2340             // Schedule next auction
2341             setAuctionStart(sellToken, buyToken, WAITING_PERIOD_NEW_AUCTION);
2342         } else {
2343             resetAuctionStart(sellToken, buyToken);
2344         }
2345     }
2346 
2347     function getSellVolumesInUSD(
2348         address sellToken,
2349         address buyToken
2350     )
2351         internal
2352         view
2353         returns (uint sellVolume, uint sellVolumeOpp)
2354     {
2355         // Check if auctions received enough sell orders
2356         uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();
2357 
2358         uint sellNum;
2359         uint sellDen;
2360         (sellNum, sellDen) = getPriceOfTokenInLastAuction(sellToken);
2361 
2362         uint buyNum;
2363         uint buyDen;
2364         (buyNum, buyDen) = getPriceOfTokenInLastAuction(buyToken);
2365 
2366         // We use current sell volume, because in clearAuction() we set
2367         // sellVolumesCurrent = sellVolumesNext before calling this function
2368         // (this is so that we don't need case work,
2369         // since it might also be called from postSellOrder())
2370 
2371         // < 10^30 * 10^31 * 10^6 = 10^67
2372         sellVolume = mul(mul(sellVolumesCurrent[sellToken][buyToken], sellNum), ethUSDPrice) / sellDen;
2373         sellVolumeOpp = mul(mul(sellVolumesCurrent[buyToken][sellToken], buyNum), ethUSDPrice) / buyDen;
2374     }
2375 
2376     /// @dev Gives best estimate for market price of a token in ETH of any price oracle on the Ethereum network
2377     /// @param token address of ERC-20 token
2378     /// @return Weighted average of closing prices of opposite Token-ethToken auctions, based on their sellVolume
2379     function getPriceOfTokenInLastAuction(address token)
2380         public
2381         view
2382         returns (
2383         // price < 10^31
2384         uint num,
2385         uint den
2386     )
2387     {
2388         uint latestAuctionIndex = getAuctionIndex(token, ethToken);
2389         // getPriceInPastAuction < 10^30
2390         (num, den) = getPriceInPastAuction(token, ethToken, latestAuctionIndex - 1);
2391     }
2392 
2393     function getCurrentAuctionPrice(address sellToken, address buyToken, uint auctionIndex)
2394         public
2395         view
2396         returns (
2397         // price < 10^37
2398         uint num,
2399         uint den
2400     )
2401     {
2402         Fraction memory closingPrice = closingPrices[sellToken][buyToken][auctionIndex];
2403 
2404         if (closingPrice.den != 0) {
2405             // Auction has closed
2406             (num, den) = (closingPrice.num, closingPrice.den);
2407         } else if (auctionIndex > getAuctionIndex(sellToken, buyToken)) {
2408             (num, den) = (0, 0);
2409         } else {
2410             // Auction is running
2411             uint pastNum;
2412             uint pastDen;
2413             (pastNum, pastDen) = getPriceInPastAuction(sellToken, buyToken, auctionIndex - 1);
2414 
2415             // If we're calling the function into an unstarted auction,
2416             // it will return the starting price of that auction
2417             uint timeElapsed = atleastZero(int(now - getAuctionStart(sellToken, buyToken)));
2418 
2419             // The numbers below are chosen such that
2420             // P(0 hrs) = 2 * lastClosingPrice, P(6 hrs) = lastClosingPrice, P(>=24 hrs) = 0
2421 
2422             // 10^5 * 10^31 = 10^36
2423             num = atleastZero(int((24 hours - timeElapsed) * pastNum));
2424             // 10^6 * 10^31 = 10^37
2425             den = mul((timeElapsed + 12 hours), pastDen);
2426 
2427             if (mul(num, sellVolumesCurrent[sellToken][buyToken]) <= mul(den, buyVolumes[sellToken][buyToken])) {
2428                 num = buyVolumes[sellToken][buyToken];
2429                 den = sellVolumesCurrent[sellToken][buyToken];
2430             }
2431         }
2432     }
2433 
2434     // > Helper fns
2435     function getTokenOrder(address token1, address token2) public pure returns (address, address) {
2436         if (token2 < token1) {
2437             (token1, token2) = (token2, token1);
2438         }
2439 
2440         return (token1, token2);
2441     }
2442 
2443     function getAuctionStart(address token1, address token2) public view returns (uint auctionStart) {
2444         (token1, token2) = getTokenOrder(token1, token2);
2445         auctionStart = auctionStarts[token1][token2];
2446     }
2447 
2448     function getAuctionIndex(address token1, address token2) public view returns (uint auctionIndex) {
2449         (token1, token2) = getTokenOrder(token1, token2);
2450         auctionIndex = latestAuctionIndices[token1][token2];
2451     }
2452 
2453     function calculateFundedValueTokenToken(
2454         address token1,
2455         address token2,
2456         uint token1Funding,
2457         uint token2Funding,
2458         address ethTokenMem,
2459         uint ethUSDPrice
2460     )
2461         internal
2462         view
2463         returns (uint fundedValueUSD)
2464     {
2465         // We require there to exist ethToken-Token auctions
2466         // R3.1
2467         require(getAuctionIndex(token1, ethTokenMem) > 0);
2468 
2469         // R3.2
2470         require(getAuctionIndex(token2, ethTokenMem) > 0);
2471 
2472         // Price of Token 1
2473         uint priceToken1Num;
2474         uint priceToken1Den;
2475         (priceToken1Num, priceToken1Den) = getPriceOfTokenInLastAuction(token1);
2476 
2477         // Price of Token 2
2478         uint priceToken2Num;
2479         uint priceToken2Den;
2480         (priceToken2Num, priceToken2Den) = getPriceOfTokenInLastAuction(token2);
2481 
2482         // Compute funded value in ethToken and USD
2483         // 10^30 * 10^30 = 10^60
2484         uint fundedValueETH = add(
2485             mul(token1Funding, priceToken1Num) / priceToken1Den,
2486             token2Funding * priceToken2Num / priceToken2Den
2487         );
2488 
2489         fundedValueUSD = mul(fundedValueETH, ethUSDPrice);
2490     }
2491 
2492     function addTokenPairSecondPart(
2493         address token1,
2494         address token2,
2495         uint token1Funding,
2496         uint token2Funding
2497     )
2498         internal
2499     {
2500         balances[token1][msg.sender] = sub(balances[token1][msg.sender], token1Funding);
2501         balances[token2][msg.sender] = sub(balances[token2][msg.sender], token2Funding);
2502 
2503         // Fee mechanism, fees are added to extraTokens
2504         uint token1FundingAfterFee = settleFee(token1, token2, 1, token1Funding);
2505         uint token2FundingAfterFee = settleFee(token2, token1, 1, token2Funding);
2506 
2507         // Update other variables
2508         sellVolumesCurrent[token1][token2] = token1FundingAfterFee;
2509         sellVolumesCurrent[token2][token1] = token2FundingAfterFee;
2510         sellerBalances[token1][token2][1][msg.sender] = token1FundingAfterFee;
2511         sellerBalances[token2][token1][1][msg.sender] = token2FundingAfterFee;
2512 
2513         // Save clearingTime as adding time
2514         (address tokenA, address tokenB) = getTokenOrder(token1, token2);
2515         clearingTimes[tokenA][tokenB][0] = now;
2516 
2517         setAuctionStart(token1, token2, WAITING_PERIOD_NEW_TOKEN_PAIR);
2518         emit NewTokenPair(token1, token2);
2519     }
2520 
2521     function setClearingTime(
2522         address token1,
2523         address token2,
2524         uint auctionIndex,
2525         uint auctionStart,
2526         uint sellVolume,
2527         uint buyVolume
2528     )
2529         internal
2530     {
2531         (uint pastNum, uint pastDen) = getPriceInPastAuction(token1, token2, auctionIndex - 1);
2532         // timeElapsed = (12 hours)*(2 * pastNum * sellVolume - buyVolume * pastDen)/
2533             // (sellVolume * pastNum + buyVolume * pastDen)
2534         uint numerator = sub(mul(mul(pastNum, sellVolume), 24 hours), mul(mul(buyVolume, pastDen), 12 hours));
2535         uint timeElapsed = numerator / (add(mul(sellVolume, pastNum), mul(buyVolume, pastDen)));
2536         uint clearingTime = auctionStart + timeElapsed;
2537         (token1, token2) = getTokenOrder(token1, token2);
2538         clearingTimes[token1][token2][auctionIndex] = clearingTime;
2539     }
2540 
2541     function getClearingTime(
2542         address token1,
2543         address token2,
2544         uint auctionIndex
2545     )
2546         public
2547         view
2548         returns (uint time)
2549     {
2550         (token1, token2) = getTokenOrder(token1, token2);
2551         time = clearingTimes[token1][token2][auctionIndex];
2552     }
2553 
2554     function issueFrts(
2555         address primaryToken,
2556         address secondaryToken,
2557         uint x,
2558         uint auctionIndex,
2559         uint bal,
2560         address user
2561     )
2562         internal
2563         returns (uint frtsIssued)
2564     {
2565         if (approvedTokens[primaryToken] && approvedTokens[secondaryToken]) {
2566             address ethTokenMem = ethToken;
2567             // Get frts issued based on ETH price of returned tokens
2568             if (primaryToken == ethTokenMem) {
2569                 frtsIssued = bal;
2570             } else if (secondaryToken == ethTokenMem) {
2571                 // 10^30 * 10^39 = 10^66
2572                 frtsIssued = x;
2573             } else {
2574                 // Neither token is ethToken, so we use getHhistoricalPriceOracle()
2575                 uint pastNum;
2576                 uint pastDen;
2577                 (pastNum, pastDen) = getPriceInPastAuction(primaryToken, ethTokenMem, auctionIndex - 1);
2578                 // 10^30 * 10^35 = 10^65
2579                 frtsIssued = mul(bal, pastNum) / pastDen;
2580             }
2581 
2582             if (frtsIssued > 0) {
2583                 // Issue frtToken
2584                 frtToken.mintTokens(user, frtsIssued);
2585             }
2586         }
2587     }
2588 
2589     function settleFee(address primaryToken, address secondaryToken, uint auctionIndex, uint amount)
2590         internal
2591         returns (
2592         // < 10^30
2593         uint amountAfterFee
2594     )
2595     {
2596         uint feeNum;
2597         uint feeDen;
2598         (feeNum, feeDen) = getFeeRatio(msg.sender);
2599         // 10^30 * 10^3 / 10^4 = 10^29
2600         uint fee = mul(amount, feeNum) / feeDen;
2601 
2602         if (fee > 0) {
2603             fee = settleFeeSecondPart(primaryToken, fee);
2604 
2605             uint usersExtraTokens = extraTokens[primaryToken][secondaryToken][auctionIndex + 1];
2606             extraTokens[primaryToken][secondaryToken][auctionIndex + 1] = add(usersExtraTokens, fee);
2607 
2608             emit Fee(primaryToken, secondaryToken, msg.sender, auctionIndex, fee);
2609         }
2610 
2611         amountAfterFee = sub(amount, fee);
2612     }
2613 
2614     function settleFeeSecondPart(address primaryToken, uint fee) internal returns (uint newFee) {
2615         // Allow user to reduce up to half of the fee with owlToken
2616         uint num;
2617         uint den;
2618         (num, den) = getPriceOfTokenInLastAuction(primaryToken);
2619 
2620         // Convert fee to ETH, then USD
2621         // 10^29 * 10^30 / 10^30 = 10^29
2622         uint feeInETH = mul(fee, num) / den;
2623 
2624         uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();
2625         // 10^29 * 10^6 = 10^35
2626         // Uses 18 decimal places <> exactly as owlToken tokens: 10**18 owlToken == 1 USD
2627         uint feeInUSD = mul(feeInETH, ethUSDPrice);
2628         uint amountOfowlTokenBurned = min(owlToken.allowance(msg.sender, address(this)), feeInUSD / 2);
2629         amountOfowlTokenBurned = min(owlToken.balanceOf(msg.sender), amountOfowlTokenBurned);
2630 
2631         if (amountOfowlTokenBurned > 0) {
2632             owlToken.burnOWL(msg.sender, amountOfowlTokenBurned);
2633             // Adjust fee
2634             // 10^35 * 10^29 = 10^64
2635             uint adjustment = mul(amountOfowlTokenBurned, fee) / feeInUSD;
2636             newFee = sub(fee, adjustment);
2637         } else {
2638             newFee = fee;
2639         }
2640     }
2641 
2642     // addClearTimes
2643     /// @dev clears an Auction
2644     /// @param sellToken sellToken of the auction
2645     /// @param buyToken  buyToken of the auction
2646     /// @param auctionIndex of the auction to be cleared.
2647     function clearAuction(
2648         address sellToken,
2649         address buyToken,
2650         uint auctionIndex,
2651         uint sellVolume
2652     )
2653         internal
2654     {
2655         // Get variables
2656         uint buyVolume = buyVolumes[sellToken][buyToken];
2657         uint sellVolumeOpp = sellVolumesCurrent[buyToken][sellToken];
2658         uint closingPriceOppDen = closingPrices[buyToken][sellToken][auctionIndex].den;
2659         uint auctionStart = getAuctionStart(sellToken, buyToken);
2660 
2661         // Update closing price
2662         if (sellVolume > 0) {
2663             closingPrices[sellToken][buyToken][auctionIndex] = Fraction(buyVolume, sellVolume);
2664         }
2665 
2666         // if (opposite is 0 auction OR price = 0 OR opposite auction cleared)
2667         // price = 0 happens if auction pair has been running for >= 24 hrs
2668         if (sellVolumeOpp == 0 || now >= auctionStart + 24 hours || closingPriceOppDen > 0) {
2669             // Close auction pair
2670             uint buyVolumeOpp = buyVolumes[buyToken][sellToken];
2671             if (closingPriceOppDen == 0 && sellVolumeOpp > 0) {
2672                 // Save opposite price
2673                 closingPrices[buyToken][sellToken][auctionIndex] = Fraction(buyVolumeOpp, sellVolumeOpp);
2674             }
2675 
2676             uint sellVolumeNext = sellVolumesNext[sellToken][buyToken];
2677             uint sellVolumeNextOpp = sellVolumesNext[buyToken][sellToken];
2678 
2679             // Update state variables for both auctions
2680             sellVolumesCurrent[sellToken][buyToken] = sellVolumeNext;
2681             if (sellVolumeNext > 0) {
2682                 sellVolumesNext[sellToken][buyToken] = 0;
2683             }
2684             if (buyVolume > 0) {
2685                 buyVolumes[sellToken][buyToken] = 0;
2686             }
2687 
2688             sellVolumesCurrent[buyToken][sellToken] = sellVolumeNextOpp;
2689             if (sellVolumeNextOpp > 0) {
2690                 sellVolumesNext[buyToken][sellToken] = 0;
2691             }
2692             if (buyVolumeOpp > 0) {
2693                 buyVolumes[buyToken][sellToken] = 0;
2694             }
2695 
2696             // Save clearing time
2697             setClearingTime(sellToken, buyToken, auctionIndex, auctionStart, sellVolume, buyVolume);
2698             // Increment auction index
2699             setAuctionIndex(sellToken, buyToken);
2700             // Check if next auction can be scheduled
2701             scheduleNextAuction(sellToken, buyToken);
2702         }
2703 
2704         emit AuctionCleared(sellToken, buyToken, sellVolume, buyVolume, auctionIndex);
2705     }
2706 
2707     function setAuctionStart(address token1, address token2, uint value) internal {
2708         (token1, token2) = getTokenOrder(token1, token2);
2709         uint auctionStart = now + value;
2710         uint auctionIndex = latestAuctionIndices[token1][token2];
2711         auctionStarts[token1][token2] = auctionStart;
2712         emit AuctionStartScheduled(token1, token2, auctionIndex, auctionStart);
2713     }
2714 
2715     function resetAuctionStart(address token1, address token2) internal {
2716         (token1, token2) = getTokenOrder(token1, token2);
2717         if (auctionStarts[token1][token2] != AUCTION_START_WAITING_FOR_FUNDING) {
2718             auctionStarts[token1][token2] = AUCTION_START_WAITING_FOR_FUNDING;
2719         }
2720     }
2721 
2722     function setAuctionIndex(address token1, address token2) internal {
2723         (token1, token2) = getTokenOrder(token1, token2);
2724         latestAuctionIndices[token1][token2] += 1;
2725     }
2726 
2727     function checkLengthsForSeveralAuctionClaiming(
2728         address[] memory auctionSellTokens,
2729         address[] memory auctionBuyTokens,
2730         uint[] memory auctionIndices
2731     ) internal pure returns (uint length)
2732     {
2733         length = auctionSellTokens.length;
2734         uint length2 = auctionBuyTokens.length;
2735         require(length == length2);
2736 
2737         uint length3 = auctionIndices.length;
2738         require(length2 == length3);
2739     }
2740 
2741     // > Events
2742     event NewDeposit(address indexed token, uint amount);
2743 
2744     event NewWithdrawal(address indexed token, uint amount);
2745 
2746     event NewSellOrder(
2747         address indexed sellToken,
2748         address indexed buyToken,
2749         address indexed user,
2750         uint auctionIndex,
2751         uint amount
2752     );
2753 
2754     event NewBuyOrder(
2755         address indexed sellToken,
2756         address indexed buyToken,
2757         address indexed user,
2758         uint auctionIndex,
2759         uint amount
2760     );
2761 
2762     event NewSellerFundsClaim(
2763         address indexed sellToken,
2764         address indexed buyToken,
2765         address indexed user,
2766         uint auctionIndex,
2767         uint amount,
2768         uint frtsIssued
2769     );
2770 
2771     event NewBuyerFundsClaim(
2772         address indexed sellToken,
2773         address indexed buyToken,
2774         address indexed user,
2775         uint auctionIndex,
2776         uint amount,
2777         uint frtsIssued
2778     );
2779 
2780     event NewTokenPair(address indexed sellToken, address indexed buyToken);
2781 
2782     event AuctionCleared(
2783         address indexed sellToken,
2784         address indexed buyToken,
2785         uint sellVolume,
2786         uint buyVolume,
2787         uint indexed auctionIndex
2788     );
2789 
2790     event AuctionStartScheduled(
2791         address indexed sellToken,
2792         address indexed buyToken,
2793         uint indexed auctionIndex,
2794         uint auctionStart
2795     );
2796 
2797     event Fee(
2798         address indexed primaryToken,
2799         address indexed secondarToken,
2800         address indexed user,
2801         uint auctionIndex,
2802         uint fee
2803     );
2804 }
2805 
2806 // File: @gnosis.pm/util-contracts/contracts/EtherToken.sol
2807 
2808 /// @title Token contract - Token exchanging Ether 1:1
2809 /// @author Stefan George - <stefan@gnosis.pm>
2810 contract EtherToken is GnosisStandardToken {
2811     using GnosisMath for *;
2812 
2813     /*
2814      *  Events
2815      */
2816     event Deposit(address indexed sender, uint value);
2817     event Withdrawal(address indexed receiver, uint value);
2818 
2819     /*
2820      *  Constants
2821      */
2822     string public constant name = "Ether Token";
2823     string public constant symbol = "ETH";
2824     uint8 public constant decimals = 18;
2825 
2826     /*
2827      *  Public functions
2828      */
2829     /// @dev Buys tokens with Ether, exchanging them 1:1
2830     function deposit() public payable {
2831         balances[msg.sender] = balances[msg.sender].add(msg.value);
2832         totalTokens = totalTokens.add(msg.value);
2833         emit Deposit(msg.sender, msg.value);
2834     }
2835 
2836     /// @dev Sells tokens in exchange for Ether, exchanging them 1:1
2837     /// @param value Number of tokens to sell
2838     function withdraw(uint value) public {
2839         // Balance covers value
2840         balances[msg.sender] = balances[msg.sender].sub(value);
2841         totalTokens = totalTokens.sub(value);
2842         msg.sender.transfer(value);
2843         emit Withdrawal(msg.sender, value);
2844     }
2845 }
2846 
2847 // File: contracts/KyberDxMarketMaker.sol
2848 
2849 interface KyberNetworkProxy {
2850     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
2851         external
2852         view
2853         returns (uint expectedRate, uint slippageRate);
2854 }
2855 
2856 
2857 contract KyberDxMarketMaker is Withdrawable {
2858     // This is the representation of ETH as an ERC20 Token for Kyber Network.
2859     ERC20 constant internal KYBER_ETH_TOKEN = ERC20(
2860         0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
2861     );
2862 
2863     // Declared in DutchExchange contract but not public.
2864     uint public constant DX_AUCTION_START_WAITING_FOR_FUNDING = 1;
2865 
2866     enum AuctionState {
2867         WAITING_FOR_FUNDING,
2868         WAITING_FOR_OPP_FUNDING,
2869         WAITING_FOR_SCHEDULED_AUCTION,
2870         AUCTION_IN_PROGRESS,
2871         WAITING_FOR_OPP_TO_FINISH,
2872         AUCTION_EXPIRED
2873     }
2874 
2875     // Exposing the enum values to external tools.
2876     AuctionState constant public WAITING_FOR_FUNDING = AuctionState.WAITING_FOR_FUNDING;
2877     AuctionState constant public WAITING_FOR_OPP_FUNDING = AuctionState.WAITING_FOR_OPP_FUNDING;
2878     AuctionState constant public WAITING_FOR_SCHEDULED_AUCTION = AuctionState.WAITING_FOR_SCHEDULED_AUCTION;
2879     AuctionState constant public AUCTION_IN_PROGRESS = AuctionState.AUCTION_IN_PROGRESS;
2880     AuctionState constant public WAITING_FOR_OPP_TO_FINISH = AuctionState.WAITING_FOR_OPP_TO_FINISH;
2881     AuctionState constant public AUCTION_EXPIRED = AuctionState.AUCTION_EXPIRED;
2882 
2883     DutchExchange public dx;
2884     EtherToken public weth;
2885     KyberNetworkProxy public kyberNetworkProxy;
2886 
2887     // Token => Token => auctionIndex
2888     mapping (address => mapping (address => uint)) public lastParticipatedAuction;
2889 
2890     constructor(
2891         DutchExchange _dx,
2892         KyberNetworkProxy _kyberNetworkProxy
2893     ) public {
2894         require(
2895             address(_dx) != address(0),
2896             "DutchExchange address cannot be 0"
2897         );
2898         require(
2899             address(_kyberNetworkProxy) != address(0),
2900             "KyberNetworkProxy address cannot be 0"
2901         );
2902 
2903         dx = DutchExchange(_dx);
2904         weth = EtherToken(dx.ethToken());
2905         kyberNetworkProxy = KyberNetworkProxy(_kyberNetworkProxy);
2906     }
2907 
2908     event KyberNetworkProxyUpdated(
2909         KyberNetworkProxy kyberNetworkProxy
2910     );
2911 
2912     function setKyberNetworkProxy(
2913         KyberNetworkProxy _kyberNetworkProxy
2914     )
2915         public
2916         onlyAdmin
2917         returns (bool)
2918     {
2919         require(
2920             address(_kyberNetworkProxy) != address(0),
2921             "KyberNetworkProxy address cannot be 0"
2922         );
2923 
2924         kyberNetworkProxy = _kyberNetworkProxy;
2925         emit KyberNetworkProxyUpdated(kyberNetworkProxy);
2926         return true;
2927     }
2928 
2929     event AmountDepositedToDx(
2930         address indexed token,
2931         uint amount
2932     );
2933 
2934     function depositToDx(
2935         address token,
2936         uint amount
2937     )
2938         public
2939         onlyOperator
2940         returns (uint)
2941     {
2942         require(ERC20(token).approve(address(dx), amount), "Cannot approve deposit");
2943         uint deposited = dx.deposit(token, amount);
2944         emit AmountDepositedToDx(token, deposited);
2945         return deposited;
2946     }
2947 
2948     event AmountWithdrawnFromDx(
2949         address indexed token,
2950         uint amount
2951     );
2952 
2953     function withdrawFromDx(
2954         address token,
2955         uint amount
2956     )
2957         public
2958         onlyOperator
2959         returns (uint)
2960     {
2961         uint withdrawn = dx.withdraw(token, amount);
2962         emit AmountWithdrawnFromDx(token, withdrawn);
2963         return withdrawn;
2964     }
2965 
2966     /**
2967       Claims funds from a specific auction.
2968 
2969       sellerFunds - the amount in token wei of *buyToken* that was returned.
2970       buyerFunds - the amount in token wei of *sellToken* that was returned.
2971       */
2972     function claimSpecificAuctionFunds(
2973         address sellToken,
2974         address buyToken,
2975         uint auctionIndex
2976     )
2977         public
2978         returns (uint sellerFunds, uint buyerFunds)
2979     {
2980         uint availableFunds;
2981         availableFunds = dx.sellerBalances(
2982             sellToken,
2983             buyToken,
2984             auctionIndex,
2985             address(this)
2986         );
2987         if (availableFunds > 0) {
2988             (sellerFunds, ) = dx.claimSellerFunds(
2989                 sellToken,
2990                 buyToken,
2991                 address(this),
2992                 auctionIndex
2993             );
2994         }
2995 
2996         availableFunds = dx.buyerBalances(
2997             sellToken,
2998             buyToken,
2999             auctionIndex,
3000             address(this)
3001         );
3002         if (availableFunds > 0) {
3003             (buyerFunds, ) = dx.claimBuyerFunds(
3004                 sellToken,
3005                 buyToken,
3006                 address(this),
3007                 auctionIndex
3008             );
3009         }
3010     }
3011 
3012     /**
3013         Participates in the auction by taking the appropriate step according to
3014         the auction state.
3015 
3016         Returns true if there is a step to be taken in this auction at this
3017         stage, false otherwise.
3018     */
3019     // TODO: consider removing onlyOperator limitation
3020     function step(
3021         address sellToken,
3022         address buyToken
3023     )
3024         public
3025         onlyOperator
3026         returns (bool)
3027     {
3028         // KyberNetworkProxy.getExpectedRate() always returns a rate between
3029         // tokens (and not between token wei as DutchX does).
3030         // For this reason the rate is currently compatible only for tokens that
3031         // have 18 decimals and is handled as though it is rate / 10**18.
3032         // TODO: handle tokens with number of decimals other than 18.
3033         require(
3034             ERC20(sellToken).decimals() == 18 && ERC20(buyToken).decimals() == 18,
3035             "Only 18 decimals tokens are supported"
3036         );
3037 
3038         // Deposit dxmm token balance to DutchX.
3039         depositAllBalance(sellToken);
3040         depositAllBalance(buyToken);
3041 
3042         AuctionState state = getAuctionState(sellToken, buyToken);
3043         uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
3044         emit CurrentAuctionState(sellToken, buyToken, auctionIndex, state);
3045 
3046         if (state == AuctionState.WAITING_FOR_FUNDING) {
3047             // Update the dutchX balance with the funds from the previous auction.
3048             claimSpecificAuctionFunds(
3049                 sellToken,
3050                 buyToken,
3051                 lastParticipatedAuction[sellToken][buyToken]
3052             );
3053             require(fundAuctionDirection(sellToken, buyToken));
3054             return true;
3055         }
3056 
3057         if (state == AuctionState.WAITING_FOR_OPP_FUNDING ||
3058             state == AuctionState.WAITING_FOR_SCHEDULED_AUCTION) {
3059             return false;
3060         }
3061 
3062         if (state == AuctionState.AUCTION_IN_PROGRESS) {
3063             if (isPriceRightForBuying(sellToken, buyToken, auctionIndex)) {
3064                 return buyInAuction(sellToken, buyToken);
3065             }
3066             return false;
3067         }
3068 
3069         if (state == AuctionState.WAITING_FOR_OPP_TO_FINISH) {
3070             return false;
3071         }
3072 
3073         if (state == AuctionState.AUCTION_EXPIRED) {
3074             dx.closeTheoreticalClosedAuction(sellToken, buyToken, auctionIndex);
3075             dx.closeTheoreticalClosedAuction(buyToken, sellToken, auctionIndex);
3076             return true;
3077         }
3078 
3079         // Should be unreachable.
3080         revert("Unknown auction state");
3081     }
3082 
3083     function willAmountClearAuction(
3084         address sellToken,
3085         address buyToken,
3086         uint auctionIndex,
3087         uint amount
3088     )
3089         public
3090         view
3091         returns (bool)
3092     {
3093         return amount >= auctionOutstandingVolume(sellToken, buyToken, auctionIndex);
3094     }
3095 
3096     // TODO: consider adding a "safety margin" to compensate for accuracy issues.
3097     function thresholdNewAuctionToken(
3098         address token
3099     )
3100         public
3101         view
3102         returns (uint)
3103     {
3104         uint priceTokenNum;
3105         uint priceTokenDen;
3106         (priceTokenNum, priceTokenDen) = dx.getPriceOfTokenInLastAuction(token);
3107 
3108         // TODO: maybe not add 1 if token is WETH
3109         // Rounding up to make sure we pass the threshold
3110         return 1 + div(
3111             // mul() takes care of overflows
3112             mul(
3113                 dx.thresholdNewAuction(),
3114                 priceTokenDen
3115             ),
3116             mul(
3117                 dx.ethUSDOracle().getUSDETHPrice(),
3118                 priceTokenNum
3119             )
3120         );
3121     }
3122 
3123     function calculateMissingTokenForAuctionStart(
3124         address sellToken,
3125         address buyToken
3126     )
3127         public
3128         view
3129         returns (uint)
3130     {
3131         uint currentAuctionSellVolume = dx.sellVolumesCurrent(sellToken, buyToken);
3132         uint thresholdTokenWei = thresholdNewAuctionToken(sellToken);
3133 
3134         if (thresholdTokenWei > currentAuctionSellVolume) {
3135             return sub(thresholdTokenWei, currentAuctionSellVolume);
3136         }
3137 
3138         return 0;
3139     }
3140 
3141     function addFee(
3142         uint amount
3143     )
3144         public
3145         view
3146         returns (uint)
3147     {
3148         uint num;
3149         uint den;
3150         (num, den) = dx.getFeeRatio(msg.sender);
3151 
3152         // amount / (1 - num / den)
3153         return div(
3154             mul(amount, den),
3155             sub(den, num)
3156         );
3157     }
3158 
3159     function getAuctionState(
3160         address sellToken,
3161         address buyToken
3162     )
3163         public
3164         view
3165         returns (AuctionState)
3166     {
3167 
3168         // Unfunded auctions have an auctionStart time equal to a constant (1)
3169         uint auctionStart = dx.getAuctionStart(sellToken, buyToken);
3170         if (auctionStart == DX_AUCTION_START_WAITING_FOR_FUNDING) {
3171             // Other side might also be not fully funded, but we're primarily
3172             // interested in this direction.
3173             if (calculateMissingTokenForAuctionStart(sellToken, buyToken) > 0) {
3174                 return AuctionState.WAITING_FOR_FUNDING;
3175             } else {
3176                 return AuctionState.WAITING_FOR_OPP_FUNDING;
3177             }
3178         }
3179 
3180         // DutchExchange logic uses auction start time.
3181         /* solhint-disable-next-line not-rely-on-time */
3182         if (auctionStart > now) {
3183             // After 24 hours have passed since last auction closed,
3184             // DutchExchange will trigger a new auction even if only the
3185             // opposite side is funded.
3186             // In these cases we want this side to be funded as well.
3187             if (calculateMissingTokenForAuctionStart(sellToken, buyToken) > 0) {
3188                 return AuctionState.WAITING_FOR_FUNDING;
3189             } else {
3190                 return AuctionState.WAITING_FOR_SCHEDULED_AUCTION;
3191             }
3192         }
3193 
3194         uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
3195 
3196         // If over 24 hours have passed, the auction is no longer viable and
3197         // should be closed.
3198         /* solhint-disable-next-line not-rely-on-time */
3199         if (now - auctionStart > 24 hours) {
3200             return AuctionState.AUCTION_EXPIRED;
3201         }
3202 
3203         uint closingPriceDen;
3204         (, closingPriceDen) = dx.closingPrices(sellToken, buyToken, auctionIndex);
3205         if (closingPriceDen == 0) {
3206             // If auction has no remaining outstanding sell volume it should also be
3207             // considered expired.
3208             if (auctionOutstandingVolume(sellToken, buyToken, auctionIndex) == 0) {
3209                 return AuctionState.AUCTION_EXPIRED;
3210             }
3211             return AuctionState.AUCTION_IN_PROGRESS;
3212         }
3213 
3214         return AuctionState.WAITING_FOR_OPP_TO_FINISH;
3215     }
3216 
3217     function getKyberRate(
3218         address srcToken,
3219         address destToken,
3220         uint amount
3221     )
3222         public
3223         view
3224         returns (uint num, uint den)
3225     {
3226         // KyberNetworkProxy.getExpectedRate() always returns a rate between
3227         // tokens (and not between token wei as DutchX does.
3228         // For this reason the rate is currently compatible only for tokens that
3229         // have 18 decimals and is handled as though it is rate / 10**18.
3230         // TODO: handle tokens with number of decimals other than 18.
3231         require(
3232             ERC20(srcToken).decimals() == 18 && ERC20(destToken).decimals() == 18,
3233             "Only 18 decimals tokens are supported"
3234         );
3235 
3236         // Kyber uses a special constant address for representing ETH.
3237         uint rate;
3238         (rate, ) = kyberNetworkProxy.getExpectedRate(
3239             srcToken == address(weth) ? KYBER_ETH_TOKEN : ERC20(srcToken),
3240             destToken == address(weth) ? KYBER_ETH_TOKEN : ERC20(destToken),
3241             amount
3242         );
3243 
3244         return (rate, 10 ** 18);
3245     }
3246 
3247     function auctionOutstandingVolume(
3248         address sellToken,
3249         address buyToken,
3250         uint auctionIndex
3251     )
3252         public
3253         view
3254         returns (uint)
3255     {
3256         uint buyVolume = dx.buyVolumes(sellToken, buyToken);
3257         uint sellVolume = dx.sellVolumesCurrent(sellToken, buyToken);
3258 
3259         uint num;
3260         uint den;
3261         (num, den) = dx.getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
3262         // sellVolume * num / den - buyVolume
3263         return atleastZero(int(sub(div(mul(sellVolume, num), den), buyVolume)));
3264     }
3265 
3266     function tokensSoldInCurrentAuction(
3267         address sellToken,
3268         address buyToken,
3269         uint auctionIndex,
3270         address account
3271     )
3272         public
3273         view
3274         returns (uint)
3275     {
3276         return dx.sellerBalances(sellToken, buyToken, auctionIndex, account);
3277     }
3278 
3279     // The amount of tokens that matches the amount sold by provided account in
3280     // specified auction index, deducting the amount that was already bought.
3281     function calculateAuctionBuyTokens(
3282         address sellToken,
3283         address buyToken,
3284         uint auctionIndex,
3285         address account
3286     )
3287         public
3288         view
3289         returns (uint)
3290     {
3291         uint sellVolume = tokensSoldInCurrentAuction(
3292             sellToken,
3293             buyToken,
3294             auctionIndex,
3295             account
3296         );
3297 
3298         uint num;
3299         uint den;
3300         (num, den) = dx.getCurrentAuctionPrice(
3301             sellToken,
3302             buyToken,
3303             auctionIndex
3304         );
3305 
3306         // No price for this auction, it is a future one.
3307         if (den == 0) return 0;
3308 
3309         uint desiredBuyVolume = div(mul(sellVolume, num), den);
3310 
3311         // Calculate available buy volume
3312         uint auctionSellVolume = dx.sellVolumesCurrent(sellToken, buyToken);
3313         uint existingBuyVolume = dx.buyVolumes(sellToken, buyToken);
3314         uint availableBuyVolume = atleastZero(
3315             int(mul(auctionSellVolume, num) / den - existingBuyVolume)
3316         );
3317 
3318         return desiredBuyVolume < availableBuyVolume
3319             ? desiredBuyVolume
3320             : availableBuyVolume;
3321     }
3322 
3323     function atleastZero(int a)
3324         public
3325         pure
3326         returns (uint)
3327     {
3328         if (a < 0) {
3329             return 0;
3330         } else {
3331             return uint(a);
3332         }
3333     }
3334 
3335     event Execution(
3336         bool success,
3337         address caller,
3338         address destination,
3339         uint value,
3340         bytes data,
3341         bytes result
3342     );
3343 
3344     // FFU
3345     function executeTransaction(
3346         address destination,
3347         uint value,
3348         bytes memory data
3349     )
3350         public
3351         onlyAdmin
3352     {
3353         (bool success, bytes memory result) = destination.call.value(value)(data);
3354         if (success) {
3355             emit Execution(true, msg.sender, destination, value, data, result);
3356         } else {
3357             revert();
3358         }
3359     }
3360 
3361     function adminBuyInAuction(
3362         address sellToken,
3363         address buyToken
3364     )
3365         public
3366         onlyAdmin
3367         returns (bool bought)
3368     {
3369         return buyInAuction(sellToken, buyToken);
3370     }
3371 
3372     event AuctionDirectionFunded(
3373         address indexed sellToken,
3374         address indexed buyToken,
3375         uint indexed auctionIndex,
3376         uint sellTokenAmount,
3377         uint sellTokenAmountWithFee
3378     );
3379 
3380     function fundAuctionDirection(
3381         address sellToken,
3382         address buyToken
3383     )
3384         internal
3385         returns (bool)
3386     {
3387         uint missingTokens = calculateMissingTokenForAuctionStart(
3388             sellToken,
3389             buyToken
3390         );
3391         uint missingTokensWithFee = addFee(missingTokens);
3392         if (missingTokensWithFee == 0) return false;
3393 
3394         uint balance = dx.balances(sellToken, address(this));
3395         require(
3396             balance >= missingTokensWithFee,
3397             "Not enough tokens to fund auction direction"
3398         );
3399 
3400         uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
3401         dx.postSellOrder(sellToken, buyToken, auctionIndex, missingTokensWithFee);
3402         lastParticipatedAuction[sellToken][buyToken] = auctionIndex;
3403 
3404         emit AuctionDirectionFunded(
3405             sellToken,
3406             buyToken,
3407             auctionIndex,
3408             missingTokens,
3409             missingTokensWithFee
3410         );
3411         return true;
3412     }
3413 
3414     // TODO: check for all the requirements of dutchx
3415     event BoughtInAuction(
3416         address indexed sellToken,
3417         address indexed buyToken,
3418         uint auctionIndex,
3419         uint buyTokenAmount,
3420         bool clearedAuction
3421     );
3422 
3423     /**
3424         Will calculate the amount that the bot has sold in current auction and
3425         buy that amount.
3426 
3427         Returns false if ended up not buying.
3428         Reverts if no auction active or not enough tokens for buying.
3429     */
3430     function buyInAuction(
3431         address sellToken,
3432         address buyToken
3433     )
3434         internal
3435         returns (bool bought)
3436     {
3437         require(
3438             getAuctionState(sellToken, buyToken) == AuctionState.AUCTION_IN_PROGRESS,
3439             "No auction in progress"
3440         );
3441 
3442         uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
3443         uint buyTokenAmount = calculateAuctionBuyTokens(
3444             sellToken,
3445             buyToken,
3446             auctionIndex,
3447             address(this)
3448         );
3449 
3450         if (buyTokenAmount == 0) {
3451             return false;
3452         }
3453 
3454         bool willClearAuction = willAmountClearAuction(
3455             sellToken,
3456             buyToken,
3457             auctionIndex,
3458             buyTokenAmount
3459         );
3460         if (!willClearAuction) {
3461             buyTokenAmount = addFee(buyTokenAmount);
3462         }
3463 
3464         require(
3465             dx.balances(buyToken, address(this)) >= buyTokenAmount,
3466             "Not enough buy token to buy required amount"
3467         );
3468 
3469         dx.postBuyOrder(sellToken, buyToken, auctionIndex, buyTokenAmount);
3470         emit BoughtInAuction(
3471             sellToken,
3472             buyToken,
3473             auctionIndex,
3474             buyTokenAmount,
3475             willClearAuction
3476         );
3477         return true;
3478     }
3479 
3480     function depositAllBalance(
3481         address token
3482     )
3483         internal
3484         returns (uint)
3485     {
3486         uint amount;
3487         uint balance = ERC20(token).balanceOf(address(this));
3488         if (balance > 0) {
3489             amount = depositToDx(token, balance);
3490         }
3491         return amount;
3492     }
3493 
3494     event CurrentAuctionState(
3495         address indexed sellToken,
3496         address indexed buyToken,
3497         uint auctionIndex,
3498         AuctionState auctionState
3499     );
3500 
3501     event PriceIsRightForBuying(
3502         address indexed sellToken,
3503         address indexed buyToken,
3504         uint auctionIndex,
3505         uint amount,
3506         uint dutchExchangePriceNum,
3507         uint dutchExchangePriceDen,
3508         uint kyberPriceNum,
3509         uint kyberPriceDen,
3510         bool shouldBuy
3511     );
3512 
3513     function isPriceRightForBuying(
3514         address sellToken,
3515         address buyToken,
3516         uint auctionIndex
3517     )
3518         internal
3519         returns (bool)
3520     {
3521         uint dNum;
3522         uint dDen;
3523         (dNum, dDen) = dx.getCurrentAuctionPrice(
3524             sellToken,
3525             buyToken,
3526             auctionIndex
3527         );
3528 
3529         uint amount = calculateAuctionBuyTokens(
3530             sellToken,
3531             buyToken,
3532             auctionIndex,
3533             address(this)
3534         );
3535 
3536         // Compare with the price a user will get if they were buying
3537         // sellToken using buyToken.
3538         // Note: Kyber returns destToken / srcToken rate (i.e. sellToken / buyToken
3539         // rate in this case) so we use a 1 / rate by reversing the kNum and kDen
3540         // order.
3541         uint kNum;
3542         uint kDen;
3543         (kDen, kNum) = getKyberRate(
3544             buyToken, /* srcToken */
3545             sellToken, /* destToken */
3546             amount
3547         );
3548 
3549         // TODO: Check for overflow explicitly?
3550         bool shouldBuy = mul(dNum, kDen) <= mul(kNum, dDen);
3551         // TODO: should we add a boolean for shouldBuy?
3552         emit PriceIsRightForBuying(
3553             sellToken,
3554             buyToken,
3555             auctionIndex,
3556             amount,
3557             dNum,
3558             dDen,
3559             kNum,
3560             kDen,
3561             shouldBuy
3562         );
3563         return shouldBuy;
3564     }
3565 
3566     // --- Safe Math functions ---
3567     // (https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol)
3568     /**
3569     * @dev Multiplies two numbers, reverts on overflow.
3570     */
3571     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3572         // Gas optimization: this is cheaper than requiring 'a' not being zero,
3573         // but the benefit is lost if 'b' is also tested.
3574         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
3575         if (a == 0) {
3576             return 0;
3577         }
3578 
3579         uint256 c = a * b;
3580         require(c / a == b);
3581 
3582         return c;
3583     }
3584 
3585     /**
3586     * @dev Integer division of two numbers truncating the quotient, reverts on
3587         division by zero.
3588     */
3589     function div(uint256 a, uint256 b) internal pure returns (uint256) {
3590         // Solidity only automatically asserts when dividing by 0
3591         require(b > 0);
3592         uint256 c = a / b;
3593         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
3594 
3595         return c;
3596     }
3597 
3598     /**
3599     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if
3600         subtrahend is greater than minuend).
3601     */
3602     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
3603         require(b <= a);
3604         uint256 c = a - b;
3605 
3606         return c;
3607     }
3608 }