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
175     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
176         require(token.transfer(sendTo, amount), "Could not transfer tokens");
177         emit TokenWithdraw(token, amount, sendTo);
178     }
179 
180     event EtherWithdraw(
181         uint amount,
182         address indexed sendTo
183     );
184 
185     /**
186      * @dev Withdraw Ethers
187      */
188     function withdrawEther(uint amount, address payable sendTo) external onlyAdmin {
189         sendTo.transfer(amount);
190         emit EtherWithdraw(amount, sendTo);
191     }
192 }
193 
194 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
195 
196 /// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
197 /// @author Alan Lu - <alan@gnosis.pm>
198 contract Proxied {
199     address public masterCopy;
200 }
201 
202 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
203 /// @author Stefan George - <stefan@gnosis.pm>
204 contract Proxy is Proxied {
205     /// @dev Constructor function sets address of master copy contract.
206     /// @param _masterCopy Master copy address.
207     constructor(address _masterCopy) public {
208         require(_masterCopy != address(0), "The master copy is required");
209         masterCopy = _masterCopy;
210     }
211 
212     /// @dev Fallback function forwards all transactions and returns all received return data.
213     function() external payable {
214         address _masterCopy = masterCopy;
215         assembly {
216             calldatacopy(0, 0, calldatasize)
217             let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
218             returndatacopy(0, 0, returndatasize)
219             switch success
220                 case 0 {
221                     revert(0, returndatasize)
222                 }
223                 default {
224                     return(0, returndatasize)
225                 }
226         }
227     }
228 }
229 
230 // File: @gnosis.pm/util-contracts/contracts/Token.sol
231 
232 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
233 pragma solidity ^0.5.2;
234 
235 /// @title Abstract token contract - Functions to be implemented by token contracts
236 contract Token {
237     /*
238      *  Events
239      */
240     event Transfer(address indexed from, address indexed to, uint value);
241     event Approval(address indexed owner, address indexed spender, uint value);
242 
243     /*
244      *  Public functions
245      */
246     function transfer(address to, uint value) public returns (bool);
247     function transferFrom(address from, address to, uint value) public returns (bool);
248     function approve(address spender, uint value) public returns (bool);
249     function balanceOf(address owner) public view returns (uint);
250     function allowance(address owner, address spender) public view returns (uint);
251     function totalSupply() public view returns (uint);
252 }
253 
254 // File: @gnosis.pm/util-contracts/contracts/Math.sol
255 
256 /// @title Math library - Allows calculation of logarithmic and exponential functions
257 /// @author Alan Lu - <alan.lu@gnosis.pm>
258 /// @author Stefan George - <stefan@gnosis.pm>
259 library GnosisMath {
260     /*
261      *  Constants
262      */
263     // This is equal to 1 in our calculations
264     uint public constant ONE = 0x10000000000000000;
265     uint public constant LN2 = 0xb17217f7d1cf79ac;
266     uint public constant LOG2_E = 0x171547652b82fe177;
267 
268     /*
269      *  Public functions
270      */
271     /// @dev Returns natural exponential function value of given x
272     /// @param x x
273     /// @return e**x
274     function exp(int x) public pure returns (uint) {
275         // revert if x is > MAX_POWER, where
276         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
277         require(x <= 2454971259878909886679);
278         // return 0 if exp(x) is tiny, using
279         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
280         if (x < -818323753292969962227) return 0;
281         // Transform so that e^x -> 2^x
282         x = x * int(ONE) / int(LN2);
283         // 2^x = 2^whole(x) * 2^frac(x)
284         //       ^^^^^^^^^^ is a bit shift
285         // so Taylor expand on z = frac(x)
286         int shift;
287         uint z;
288         if (x >= 0) {
289             shift = x / int(ONE);
290             z = uint(x % int(ONE));
291         } else {
292             shift = x / int(ONE) - 1;
293             z = ONE - uint(-x % int(ONE));
294         }
295         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
296         //
297         // Can generate the z coefficients using mpmath and the following lines
298         // >>> from mpmath import mp
299         // >>> mp.dps = 100
300         // >>> ONE =  0x10000000000000000
301         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
302         // 0xb17217f7d1cf79ab
303         // 0x3d7f7bff058b1d50
304         // 0xe35846b82505fc5
305         // 0x276556df749cee5
306         // 0x5761ff9e299cc4
307         // 0xa184897c363c3
308         uint zpow = z;
309         uint result = ONE;
310         result += 0xb17217f7d1cf79ab * zpow / ONE;
311         zpow = zpow * z / ONE;
312         result += 0x3d7f7bff058b1d50 * zpow / ONE;
313         zpow = zpow * z / ONE;
314         result += 0xe35846b82505fc5 * zpow / ONE;
315         zpow = zpow * z / ONE;
316         result += 0x276556df749cee5 * zpow / ONE;
317         zpow = zpow * z / ONE;
318         result += 0x5761ff9e299cc4 * zpow / ONE;
319         zpow = zpow * z / ONE;
320         result += 0xa184897c363c3 * zpow / ONE;
321         zpow = zpow * z / ONE;
322         result += 0xffe5fe2c4586 * zpow / ONE;
323         zpow = zpow * z / ONE;
324         result += 0x162c0223a5c8 * zpow / ONE;
325         zpow = zpow * z / ONE;
326         result += 0x1b5253d395e * zpow / ONE;
327         zpow = zpow * z / ONE;
328         result += 0x1e4cf5158b * zpow / ONE;
329         zpow = zpow * z / ONE;
330         result += 0x1e8cac735 * zpow / ONE;
331         zpow = zpow * z / ONE;
332         result += 0x1c3bd650 * zpow / ONE;
333         zpow = zpow * z / ONE;
334         result += 0x1816193 * zpow / ONE;
335         zpow = zpow * z / ONE;
336         result += 0x131496 * zpow / ONE;
337         zpow = zpow * z / ONE;
338         result += 0xe1b7 * zpow / ONE;
339         zpow = zpow * z / ONE;
340         result += 0x9c7 * zpow / ONE;
341         if (shift >= 0) {
342             if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
343             return result << shift;
344         } else return result >> (-shift);
345     }
346 
347     /// @dev Returns natural logarithm value of given x
348     /// @param x x
349     /// @return ln(x)
350     function ln(uint x) public pure returns (int) {
351         require(x > 0);
352         // binary search for floor(log2(x))
353         int ilog2 = floorLog2(x);
354         int z;
355         if (ilog2 < 0) z = int(x << uint(-ilog2));
356         else z = int(x >> uint(ilog2));
357         // z = x * 2^-⌊log₂x⌋
358         // so 1 <= z < 2
359         // and ln z = ln x - ⌊log₂x⌋/log₂e
360         // so just compute ln z using artanh series
361         // and calculate ln x from that
362         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
363         int halflnz = term;
364         int termpow = term * term / int(ONE) * term / int(ONE);
365         halflnz += termpow / 3;
366         termpow = termpow * term / int(ONE) * term / int(ONE);
367         halflnz += termpow / 5;
368         termpow = termpow * term / int(ONE) * term / int(ONE);
369         halflnz += termpow / 7;
370         termpow = termpow * term / int(ONE) * term / int(ONE);
371         halflnz += termpow / 9;
372         termpow = termpow * term / int(ONE) * term / int(ONE);
373         halflnz += termpow / 11;
374         termpow = termpow * term / int(ONE) * term / int(ONE);
375         halflnz += termpow / 13;
376         termpow = termpow * term / int(ONE) * term / int(ONE);
377         halflnz += termpow / 15;
378         termpow = termpow * term / int(ONE) * term / int(ONE);
379         halflnz += termpow / 17;
380         termpow = termpow * term / int(ONE) * term / int(ONE);
381         halflnz += termpow / 19;
382         termpow = termpow * term / int(ONE) * term / int(ONE);
383         halflnz += termpow / 21;
384         termpow = termpow * term / int(ONE) * term / int(ONE);
385         halflnz += termpow / 23;
386         termpow = termpow * term / int(ONE) * term / int(ONE);
387         halflnz += termpow / 25;
388         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
389     }
390 
391     /// @dev Returns base 2 logarithm value of given x
392     /// @param x x
393     /// @return logarithmic value
394     function floorLog2(uint x) public pure returns (int lo) {
395         lo = -64;
396         int hi = 193;
397         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
398         int mid = (hi + lo) >> 1;
399         while ((lo + 1) < hi) {
400             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
401             else lo = mid;
402             mid = (hi + lo) >> 1;
403         }
404     }
405 
406     /// @dev Returns maximum of an array
407     /// @param nums Numbers to look through
408     /// @return Maximum number
409     function max(int[] memory nums) public pure returns (int maxNum) {
410         require(nums.length > 0);
411         maxNum = -2 ** 255;
412         for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
413     }
414 
415     /// @dev Returns whether an add operation causes an overflow
416     /// @param a First addend
417     /// @param b Second addend
418     /// @return Did no overflow occur?
419     function safeToAdd(uint a, uint b) internal pure returns (bool) {
420         return a + b >= a;
421     }
422 
423     /// @dev Returns whether a subtraction operation causes an underflow
424     /// @param a Minuend
425     /// @param b Subtrahend
426     /// @return Did no underflow occur?
427     function safeToSub(uint a, uint b) internal pure returns (bool) {
428         return a >= b;
429     }
430 
431     /// @dev Returns whether a multiply operation causes an overflow
432     /// @param a First factor
433     /// @param b Second factor
434     /// @return Did no overflow occur?
435     function safeToMul(uint a, uint b) internal pure returns (bool) {
436         return b == 0 || a * b / b == a;
437     }
438 
439     /// @dev Returns sum if no overflow occurred
440     /// @param a First addend
441     /// @param b Second addend
442     /// @return Sum
443     function add(uint a, uint b) internal pure returns (uint) {
444         require(safeToAdd(a, b));
445         return a + b;
446     }
447 
448     /// @dev Returns difference if no overflow occurred
449     /// @param a Minuend
450     /// @param b Subtrahend
451     /// @return Difference
452     function sub(uint a, uint b) internal pure returns (uint) {
453         require(safeToSub(a, b));
454         return a - b;
455     }
456 
457     /// @dev Returns product if no overflow occurred
458     /// @param a First factor
459     /// @param b Second factor
460     /// @return Product
461     function mul(uint a, uint b) internal pure returns (uint) {
462         require(safeToMul(a, b));
463         return a * b;
464     }
465 
466     /// @dev Returns whether an add operation causes an overflow
467     /// @param a First addend
468     /// @param b Second addend
469     /// @return Did no overflow occur?
470     function safeToAdd(int a, int b) internal pure returns (bool) {
471         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
472     }
473 
474     /// @dev Returns whether a subtraction operation causes an underflow
475     /// @param a Minuend
476     /// @param b Subtrahend
477     /// @return Did no underflow occur?
478     function safeToSub(int a, int b) internal pure returns (bool) {
479         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
480     }
481 
482     /// @dev Returns whether a multiply operation causes an overflow
483     /// @param a First factor
484     /// @param b Second factor
485     /// @return Did no overflow occur?
486     function safeToMul(int a, int b) internal pure returns (bool) {
487         return (b == 0) || (a * b / b == a);
488     }
489 
490     /// @dev Returns sum if no overflow occurred
491     /// @param a First addend
492     /// @param b Second addend
493     /// @return Sum
494     function add(int a, int b) internal pure returns (int) {
495         require(safeToAdd(a, b));
496         return a + b;
497     }
498 
499     /// @dev Returns difference if no overflow occurred
500     /// @param a Minuend
501     /// @param b Subtrahend
502     /// @return Difference
503     function sub(int a, int b) internal pure returns (int) {
504         require(safeToSub(a, b));
505         return a - b;
506     }
507 
508     /// @dev Returns product if no overflow occurred
509     /// @param a First factor
510     /// @param b Second factor
511     /// @return Product
512     function mul(int a, int b) internal pure returns (int) {
513         require(safeToMul(a, b));
514         return a * b;
515     }
516 }
517 
518 // File: @gnosis.pm/util-contracts/contracts/GnosisStandardToken.sol
519 
520 /**
521  * Deprecated: Use Open Zeppeling one instead
522  */
523 contract StandardTokenData {
524     /*
525      *  Storage
526      */
527     mapping(address => uint) balances;
528     mapping(address => mapping(address => uint)) allowances;
529     uint totalTokens;
530 }
531 
532 /**
533  * Deprecated: Use Open Zeppeling one instead
534  */
535 /// @title Standard token contract with overflow protection
536 contract GnosisStandardToken is Token, StandardTokenData {
537     using GnosisMath for *;
538 
539     /*
540      *  Public functions
541      */
542     /// @dev Transfers sender's tokens to a given address. Returns success
543     /// @param to Address of token receiver
544     /// @param value Number of tokens to transfer
545     /// @return Was transfer successful?
546     function transfer(address to, uint value) public returns (bool) {
547         if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
548             return false;
549         }
550 
551         balances[msg.sender] -= value;
552         balances[to] += value;
553         emit Transfer(msg.sender, to, value);
554         return true;
555     }
556 
557     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
558     /// @param from Address from where tokens are withdrawn
559     /// @param to Address to where tokens are sent
560     /// @param value Number of tokens to transfer
561     /// @return Was transfer successful?
562     function transferFrom(address from, address to, uint value) public returns (bool) {
563         if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
564             value
565         ) || !balances[to].safeToAdd(value)) {
566             return false;
567         }
568         balances[from] -= value;
569         allowances[from][msg.sender] -= value;
570         balances[to] += value;
571         emit Transfer(from, to, value);
572         return true;
573     }
574 
575     /// @dev Sets approved amount of tokens for spender. Returns success
576     /// @param spender Address of allowed account
577     /// @param value Number of approved tokens
578     /// @return Was approval successful?
579     function approve(address spender, uint value) public returns (bool) {
580         allowances[msg.sender][spender] = value;
581         emit Approval(msg.sender, spender, value);
582         return true;
583     }
584 
585     /// @dev Returns number of allowed tokens for given address
586     /// @param owner Address of token owner
587     /// @param spender Address of token spender
588     /// @return Remaining allowance for spender
589     function allowance(address owner, address spender) public view returns (uint) {
590         return allowances[owner][spender];
591     }
592 
593     /// @dev Returns number of tokens owned by given address
594     /// @param owner Address of token owner
595     /// @return Balance of owner
596     function balanceOf(address owner) public view returns (uint) {
597         return balances[owner];
598     }
599 
600     /// @dev Returns total supply of tokens
601     /// @return Total supply
602     function totalSupply() public view returns (uint) {
603         return totalTokens;
604     }
605 }
606 
607 // File: @gnosis.pm/dx-contracts/contracts/TokenFRT.sol
608 
609 /// @title Standard token contract with overflow protection
610 contract TokenFRT is Proxied, GnosisStandardToken {
611     address public owner;
612 
613     string public constant symbol = "MGN";
614     string public constant name = "Magnolia Token";
615     uint8 public constant decimals = 18;
616 
617     struct UnlockedToken {
618         uint amountUnlocked;
619         uint withdrawalTime;
620     }
621 
622     /*
623      *  Storage
624      */
625     address public minter;
626 
627     // user => UnlockedToken
628     mapping(address => UnlockedToken) public unlockedTokens;
629 
630     // user => amount
631     mapping(address => uint) public lockedTokenBalances;
632 
633     /*
634      *  Public functions
635      */
636 
637     // @dev allows to set the minter of Magnolia tokens once.
638     // @param   _minter the minter of the Magnolia tokens, should be the DX-proxy
639     function updateMinter(address _minter) public {
640         require(msg.sender == owner, "Only the minter can set a new one");
641         require(_minter != address(0), "The new minter must be a valid address");
642 
643         minter = _minter;
644     }
645 
646     // @dev the intention is to set the owner as the DX-proxy, once it is deployed
647     // Then only an update of the DX-proxy contract after a 30 days delay could change the minter again.
648     function updateOwner(address _owner) public {
649         require(msg.sender == owner, "Only the owner can update the owner");
650         require(_owner != address(0), "The new owner must be a valid address");
651         owner = _owner;
652     }
653 
654     function mintTokens(address user, uint amount) public {
655         require(msg.sender == minter, "Only the minter can mint tokens");
656 
657         lockedTokenBalances[user] = add(lockedTokenBalances[user], amount);
658         totalTokens = add(totalTokens, amount);
659     }
660 
661     /// @dev Lock Token
662     function lockTokens(uint amount) public returns (uint totalAmountLocked) {
663         // Adjust amount by balance
664         uint actualAmount = min(amount, balances[msg.sender]);
665 
666         // Update state variables
667         balances[msg.sender] = sub(balances[msg.sender], actualAmount);
668         lockedTokenBalances[msg.sender] = add(lockedTokenBalances[msg.sender], actualAmount);
669 
670         // Get return variable
671         totalAmountLocked = lockedTokenBalances[msg.sender];
672     }
673 
674     function unlockTokens() public returns (uint totalAmountUnlocked, uint withdrawalTime) {
675         // Adjust amount by locked balances
676         uint amount = lockedTokenBalances[msg.sender];
677 
678         if (amount > 0) {
679             // Update state variables
680             lockedTokenBalances[msg.sender] = sub(lockedTokenBalances[msg.sender], amount);
681             unlockedTokens[msg.sender].amountUnlocked = add(unlockedTokens[msg.sender].amountUnlocked, amount);
682             unlockedTokens[msg.sender].withdrawalTime = now + 24 hours;
683         }
684 
685         // Get return variables
686         totalAmountUnlocked = unlockedTokens[msg.sender].amountUnlocked;
687         withdrawalTime = unlockedTokens[msg.sender].withdrawalTime;
688     }
689 
690     function withdrawUnlockedTokens() public {
691         require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
692         balances[msg.sender] = add(balances[msg.sender], unlockedTokens[msg.sender].amountUnlocked);
693         unlockedTokens[msg.sender].amountUnlocked = 0;
694     }
695 
696     function min(uint a, uint b) public pure returns (uint) {
697         if (a < b) {
698             return a;
699         } else {
700             return b;
701         }
702     }
703     
704     /// @dev Returns whether an add operation causes an overflow
705     /// @param a First addend
706     /// @param b Second addend
707     /// @return Did no overflow occur?
708     function safeToAdd(uint a, uint b) public pure returns (bool) {
709         return a + b >= a;
710     }
711 
712     /// @dev Returns whether a subtraction operation causes an underflow
713     /// @param a Minuend
714     /// @param b Subtrahend
715     /// @return Did no underflow occur?
716     function safeToSub(uint a, uint b) public pure returns (bool) {
717         return a >= b;
718     }
719 
720     /// @dev Returns sum if no overflow occurred
721     /// @param a First addend
722     /// @param b Second addend
723     /// @return Sum
724     function add(uint a, uint b) public pure returns (uint) {
725         require(safeToAdd(a, b), "It must be a safe adition");
726         return a + b;
727     }
728 
729     /// @dev Returns difference if no overflow occurred
730     /// @param a Minuend
731     /// @param b Subtrahend
732     /// @return Difference
733     function sub(uint a, uint b) public pure returns (uint) {
734         require(safeToSub(a, b), "It must be a safe substraction");
735         return a - b;
736     }
737 }
738 
739 // File: @gnosis.pm/owl-token/contracts/TokenOWL.sol
740 
741 contract TokenOWL is Proxied, GnosisStandardToken {
742     using GnosisMath for *;
743 
744     string public constant name = "OWL Token";
745     string public constant symbol = "OWL";
746     uint8 public constant decimals = 18;
747 
748     struct masterCopyCountdownType {
749         address masterCopy;
750         uint timeWhenAvailable;
751     }
752 
753     masterCopyCountdownType masterCopyCountdown;
754 
755     address public creator;
756     address public minter;
757 
758     event Minted(address indexed to, uint256 amount);
759     event Burnt(address indexed from, address indexed user, uint256 amount);
760 
761     modifier onlyCreator() {
762         // R1
763         require(msg.sender == creator, "Only the creator can perform the transaction");
764         _;
765     }
766     /// @dev trickers the update process via the proxyMaster for a new address _masterCopy
767     /// updating is only possible after 30 days
768     function startMasterCopyCountdown(address _masterCopy) public onlyCreator {
769         require(address(_masterCopy) != address(0), "The master copy must be a valid address");
770 
771         // Update masterCopyCountdown
772         masterCopyCountdown.masterCopy = _masterCopy;
773         masterCopyCountdown.timeWhenAvailable = now + 30 days;
774     }
775 
776     /// @dev executes the update process via the proxyMaster for a new address _masterCopy
777     function updateMasterCopy() public onlyCreator {
778         require(address(masterCopyCountdown.masterCopy) != address(0), "The master copy must be a valid address");
779         require(
780             block.timestamp >= masterCopyCountdown.timeWhenAvailable,
781             "It's not possible to update the master copy during the waiting period"
782         );
783 
784         // Update masterCopy
785         masterCopy = masterCopyCountdown.masterCopy;
786     }
787 
788     function getMasterCopy() public view returns (address) {
789         return masterCopy;
790     }
791 
792     /// @dev Set minter. Only the creator of this contract can call this.
793     /// @param newMinter The new address authorized to mint this token
794     function setMinter(address newMinter) public onlyCreator {
795         minter = newMinter;
796     }
797 
798     /// @dev change owner/creator of the contract. Only the creator/owner of this contract can call this.
799     /// @param newOwner The new address, which should become the owner
800     function setNewOwner(address newOwner) public onlyCreator {
801         creator = newOwner;
802     }
803 
804     /// @dev Mints OWL.
805     /// @param to Address to which the minted token will be given
806     /// @param amount Amount of OWL to be minted
807     function mintOWL(address to, uint amount) public {
808         require(minter != address(0), "The minter must be initialized");
809         require(msg.sender == minter, "Only the minter can mint OWL");
810         balances[to] = balances[to].add(amount);
811         totalTokens = totalTokens.add(amount);
812         emit Minted(to, amount);
813     }
814 
815     /// @dev Burns OWL.
816     /// @param user Address of OWL owner
817     /// @param amount Amount of OWL to be burnt
818     function burnOWL(address user, uint amount) public {
819         allowances[user][msg.sender] = allowances[user][msg.sender].sub(amount);
820         balances[user] = balances[user].sub(amount);
821         totalTokens = totalTokens.sub(amount);
822         emit Burnt(msg.sender, user, amount);
823     }
824 }
825 
826 // File: @gnosis.pm/dx-contracts/contracts/base/SafeTransfer.sol
827 
828 interface BadToken {
829     function transfer(address to, uint value) external;
830     function transferFrom(address from, address to, uint value) external;
831 }
832 
833 contract SafeTransfer {
834     function safeTransfer(address token, address to, uint value, bool from) internal returns (bool result) {
835         if (from) {
836             BadToken(token).transferFrom(msg.sender, address(this), value);
837         } else {
838             BadToken(token).transfer(to, value);
839         }
840 
841         // solium-disable-next-line security/no-inline-assembly
842         assembly {
843             switch returndatasize
844                 case 0 {
845                     // This is our BadToken
846                     result := not(0) // result is true
847                 }
848                 case 32 {
849                     // This is our GoodToken
850                     returndatacopy(0, 0, 32)
851                     result := mload(0) // result == returndata of external call
852                 }
853                 default {
854                     // This is not an ERC20 token
855                     result := 0
856                 }
857         }
858         return result;
859     }
860 }
861 
862 // File: @gnosis.pm/dx-contracts/contracts/base/AuctioneerManaged.sol
863 
864 contract AuctioneerManaged {
865     // auctioneer has the power to manage some variables
866     address public auctioneer;
867 
868     function updateAuctioneer(address _auctioneer) public onlyAuctioneer {
869         require(_auctioneer != address(0), "The auctioneer must be a valid address");
870         auctioneer = _auctioneer;
871     }
872 
873     // > Modifiers
874     modifier onlyAuctioneer() {
875         // Only allows auctioneer to proceed
876         // R1
877         // require(msg.sender == auctioneer, "Only auctioneer can perform this operation");
878         require(msg.sender == auctioneer, "Only the auctioneer can nominate a new one");
879         _;
880     }
881 }
882 
883 // File: @gnosis.pm/dx-contracts/contracts/base/TokenWhitelist.sol
884 
885 contract TokenWhitelist is AuctioneerManaged {
886     // Mapping that stores the tokens, which are approved
887     // Only tokens approved by auctioneer generate frtToken tokens
888     // addressToken => boolApproved
889     mapping(address => bool) public approvedTokens;
890 
891     event Approval(address indexed token, bool approved);
892 
893     /// @dev for quick overview of approved Tokens
894     /// @param addressesToCheck are the ERC-20 token addresses to be checked whether they are approved
895     function getApprovedAddressesOfList(address[] calldata addressesToCheck) external view returns (bool[] memory) {
896         uint length = addressesToCheck.length;
897 
898         bool[] memory isApproved = new bool[](length);
899 
900         for (uint i = 0; i < length; i++) {
901             isApproved[i] = approvedTokens[addressesToCheck[i]];
902         }
903 
904         return isApproved;
905     }
906     
907     function updateApprovalOfToken(address[] memory token, bool approved) public onlyAuctioneer {
908         for (uint i = 0; i < token.length; i++) {
909             approvedTokens[token[i]] = approved;
910             emit Approval(token[i], approved);
911         }
912     }
913 
914 }
915 
916 // File: @gnosis.pm/dx-contracts/contracts/base/DxMath.sol
917 
918 contract DxMath {
919     // > Math fns
920     function min(uint a, uint b) public pure returns (uint) {
921         if (a < b) {
922             return a;
923         } else {
924             return b;
925         }
926     }
927 
928     function atleastZero(int a) public pure returns (uint) {
929         if (a < 0) {
930             return 0;
931         } else {
932             return uint(a);
933         }
934     }
935     
936     /// @dev Returns whether an add operation causes an overflow
937     /// @param a First addend
938     /// @param b Second addend
939     /// @return Did no overflow occur?
940     function safeToAdd(uint a, uint b) public pure returns (bool) {
941         return a + b >= a;
942     }
943 
944     /// @dev Returns whether a subtraction operation causes an underflow
945     /// @param a Minuend
946     /// @param b Subtrahend
947     /// @return Did no underflow occur?
948     function safeToSub(uint a, uint b) public pure returns (bool) {
949         return a >= b;
950     }
951 
952     /// @dev Returns whether a multiply operation causes an overflow
953     /// @param a First factor
954     /// @param b Second factor
955     /// @return Did no overflow occur?
956     function safeToMul(uint a, uint b) public pure returns (bool) {
957         return b == 0 || a * b / b == a;
958     }
959 
960     /// @dev Returns sum if no overflow occurred
961     /// @param a First addend
962     /// @param b Second addend
963     /// @return Sum
964     function add(uint a, uint b) public pure returns (uint) {
965         require(safeToAdd(a, b));
966         return a + b;
967     }
968 
969     /// @dev Returns difference if no overflow occurred
970     /// @param a Minuend
971     /// @param b Subtrahend
972     /// @return Difference
973     function sub(uint a, uint b) public pure returns (uint) {
974         require(safeToSub(a, b));
975         return a - b;
976     }
977 
978     /// @dev Returns product if no overflow occurred
979     /// @param a First factor
980     /// @param b Second factor
981     /// @return Product
982     function mul(uint a, uint b) public pure returns (uint) {
983         require(safeToMul(a, b));
984         return a * b;
985     }
986 }
987 
988 // File: @gnosis.pm/dx-contracts/contracts/Oracle/DSMath.sol
989 
990 contract DSMath {
991     /*
992     standard uint256 functions
993      */
994 
995     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
996         assert((z = x + y) >= x);
997     }
998 
999     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
1000         assert((z = x - y) <= x);
1001     }
1002 
1003     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1004         assert((z = x * y) >= x);
1005     }
1006 
1007     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
1008         z = x / y;
1009     }
1010 
1011     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
1012         return x <= y ? x : y;
1013     }
1014 
1015     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
1016         return x >= y ? x : y;
1017     }
1018 
1019     /*
1020     uint128 functions (h is for half)
1021      */
1022 
1023     function hadd(uint128 x, uint128 y) internal pure returns (uint128 z) {
1024         assert((z = x + y) >= x);
1025     }
1026 
1027     function hsub(uint128 x, uint128 y) internal pure returns (uint128 z) {
1028         assert((z = x - y) <= x);
1029     }
1030 
1031     function hmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
1032         assert((z = x * y) >= x);
1033     }
1034 
1035     function hdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
1036         z = x / y;
1037     }
1038 
1039     function hmin(uint128 x, uint128 y) internal pure returns (uint128 z) {
1040         return x <= y ? x : y;
1041     }
1042 
1043     function hmax(uint128 x, uint128 y) internal pure returns (uint128 z) {
1044         return x >= y ? x : y;
1045     }
1046 
1047     /*
1048     int256 functions
1049      */
1050 
1051     function imin(int256 x, int256 y) internal pure returns (int256 z) {
1052         return x <= y ? x : y;
1053     }
1054 
1055     function imax(int256 x, int256 y) internal pure returns (int256 z) {
1056         return x >= y ? x : y;
1057     }
1058 
1059     /*
1060     WAD math
1061      */
1062 
1063     uint128 constant WAD = 10 ** 18;
1064 
1065     function wadd(uint128 x, uint128 y) internal pure returns (uint128) {
1066         return hadd(x, y);
1067     }
1068 
1069     function wsub(uint128 x, uint128 y) internal pure returns (uint128) {
1070         return hsub(x, y);
1071     }
1072 
1073     function wmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
1074         z = cast((uint256(x) * y + WAD / 2) / WAD);
1075     }
1076 
1077     function wdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
1078         z = cast((uint256(x) * WAD + y / 2) / y);
1079     }
1080 
1081     function wmin(uint128 x, uint128 y) internal pure returns (uint128) {
1082         return hmin(x, y);
1083     }
1084 
1085     function wmax(uint128 x, uint128 y) internal pure returns (uint128) {
1086         return hmax(x, y);
1087     }
1088 
1089     /*
1090     RAY math
1091      */
1092 
1093     uint128 constant RAY = 10 ** 27;
1094 
1095     function radd(uint128 x, uint128 y) internal pure returns (uint128) {
1096         return hadd(x, y);
1097     }
1098 
1099     function rsub(uint128 x, uint128 y) internal pure returns (uint128) {
1100         return hsub(x, y);
1101     }
1102 
1103     function rmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
1104         z = cast((uint256(x) * y + RAY / 2) / RAY);
1105     }
1106 
1107     function rdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
1108         z = cast((uint256(x) * RAY + y / 2) / y);
1109     }
1110 
1111     function rpow(uint128 x, uint64 n) internal pure returns (uint128 z) {
1112         // This famous algorithm is called "exponentiation by squaring"
1113         // and calculates x^n with x as fixed-point and n as regular unsigned.
1114         //
1115         // It's O(log n), instead of O(n) for naive repeated multiplication.
1116         //
1117         // These facts are why it works:
1118         //
1119         //  If n is even, then x^n = (x^2)^(n/2).
1120         //  If n is odd,  then x^n = x * x^(n-1),
1121         //   and applying the equation for even x gives
1122         //    x^n = x * (x^2)^((n-1) / 2).
1123         //
1124         //  Also, EVM division is flooring and
1125         //    floor[(n-1) / 2] = floor[n / 2].
1126 
1127         z = n % 2 != 0 ? x : RAY;
1128 
1129         for (n /= 2; n != 0; n /= 2) {
1130             x = rmul(x, x);
1131 
1132             if (n % 2 != 0) {
1133                 z = rmul(z, x);
1134             }
1135         }
1136     }
1137 
1138     function rmin(uint128 x, uint128 y) internal pure returns (uint128) {
1139         return hmin(x, y);
1140     }
1141 
1142     function rmax(uint128 x, uint128 y) internal pure returns (uint128) {
1143         return hmax(x, y);
1144     }
1145 
1146     function cast(uint256 x) internal pure returns (uint128 z) {
1147         assert((z = uint128(x)) == x);
1148     }
1149 
1150 }
1151 
1152 // File: @gnosis.pm/dx-contracts/contracts/Oracle/DSAuth.sol
1153 
1154 contract DSAuthority {
1155     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
1156 }
1157 
1158 
1159 contract DSAuthEvents {
1160     event LogSetAuthority(address indexed authority);
1161     event LogSetOwner(address indexed owner);
1162 }
1163 
1164 
1165 contract DSAuth is DSAuthEvents {
1166     DSAuthority public authority;
1167     address public owner;
1168 
1169     constructor() public {
1170         owner = msg.sender;
1171         emit LogSetOwner(msg.sender);
1172     }
1173 
1174     function setOwner(address owner_) public auth {
1175         owner = owner_;
1176         emit LogSetOwner(owner);
1177     }
1178 
1179     function setAuthority(DSAuthority authority_) public auth {
1180         authority = authority_;
1181         emit LogSetAuthority(address(authority));
1182     }
1183 
1184     modifier auth {
1185         require(isAuthorized(msg.sender, msg.sig), "It must be an authorized call");
1186         _;
1187     }
1188 
1189     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
1190         if (src == address(this)) {
1191             return true;
1192         } else if (src == owner) {
1193             return true;
1194         } else if (authority == DSAuthority(0)) {
1195             return false;
1196         } else {
1197             return authority.canCall(src, address(this), sig);
1198         }
1199     }
1200 }
1201 
1202 // File: @gnosis.pm/dx-contracts/contracts/Oracle/DSNote.sol
1203 
1204 contract DSNote {
1205     event LogNote(
1206         bytes4 indexed sig,
1207         address indexed guy,
1208         bytes32 indexed foo,
1209         bytes32 bar,
1210         uint wad,
1211         bytes fax
1212     );
1213 
1214     modifier note {
1215         bytes32 foo;
1216         bytes32 bar;
1217         // solium-disable-next-line security/no-inline-assembly
1218         assembly {
1219             foo := calldataload(4)
1220             bar := calldataload(36)
1221         }
1222 
1223         emit LogNote(
1224             msg.sig,
1225             msg.sender,
1226             foo,
1227             bar,
1228             msg.value,
1229             msg.data
1230         );
1231 
1232         _;
1233     }
1234 }
1235 
1236 // File: @gnosis.pm/dx-contracts/contracts/Oracle/DSThing.sol
1237 
1238 contract DSThing is DSAuth, DSNote, DSMath {}
1239 
1240 // File: @gnosis.pm/dx-contracts/contracts/Oracle/PriceFeed.sol
1241 
1242 /// price-feed.sol
1243 
1244 // Copyright (C) 2017  DappHub, LLC
1245 
1246 // Licensed under the Apache License, Version 2.0 (the "License").
1247 // You may not use this file except in compliance with the License.
1248 
1249 // Unless required by applicable law or agreed to in writing, software
1250 // distributed under the License is distributed on an "AS IS" BASIS,
1251 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1252 
1253 
1254 
1255 contract PriceFeed is DSThing {
1256     uint128 val;
1257     uint32 public zzz;
1258 
1259     function peek() public view returns (bytes32, bool) {
1260         return (bytes32(uint256(val)), block.timestamp < zzz);
1261     }
1262 
1263     function read() public view returns (bytes32) {
1264         assert(block.timestamp < zzz);
1265         return bytes32(uint256(val));
1266     }
1267 
1268     function post(uint128 val_, uint32 zzz_, address med_) public payable note auth {
1269         val = val_;
1270         zzz = zzz_;
1271         (bool success, ) = med_.call(abi.encodeWithSignature("poke()"));
1272         require(success, "The poke must succeed");
1273     }
1274 
1275     function void() public payable note auth {
1276         zzz = 0;
1277     }
1278 
1279 }
1280 
1281 // File: @gnosis.pm/dx-contracts/contracts/Oracle/DSValue.sol
1282 
1283 contract DSValue is DSThing {
1284     bool has;
1285     bytes32 val;
1286     function peek() public view returns (bytes32, bool) {
1287         return (val, has);
1288     }
1289 
1290     function read() public view returns (bytes32) {
1291         (bytes32 wut, bool _has) = peek();
1292         assert(_has);
1293         return wut;
1294     }
1295 
1296     function poke(bytes32 wut) public payable note auth {
1297         val = wut;
1298         has = true;
1299     }
1300 
1301     function void() public payable note auth {
1302         // unset the value
1303         has = false;
1304     }
1305 }
1306 
1307 // File: @gnosis.pm/dx-contracts/contracts/Oracle/Medianizer.sol
1308 
1309 contract Medianizer is DSValue {
1310     mapping(bytes12 => address) public values;
1311     mapping(address => bytes12) public indexes;
1312     bytes12 public next = bytes12(uint96(1));
1313     uint96 public minimun = 0x1;
1314 
1315     function set(address wat) public auth {
1316         bytes12 nextId = bytes12(uint96(next) + 1);
1317         assert(nextId != 0x0);
1318         set(next, wat);
1319         next = nextId;
1320     }
1321 
1322     function set(bytes12 pos, address wat) public payable note auth {
1323         require(pos != 0x0, "pos cannot be 0x0");
1324         require(wat == address(0) || indexes[wat] == 0, "wat is not defined or it has an index");
1325 
1326         indexes[values[pos]] = bytes12(0); // Making sure to remove a possible existing address in that position
1327 
1328         if (wat != address(0)) {
1329             indexes[wat] = pos;
1330         }
1331 
1332         values[pos] = wat;
1333     }
1334 
1335     function setMin(uint96 min_) public payable note auth {
1336         require(min_ != 0x0, "min cannot be 0x0");
1337         minimun = min_;
1338     }
1339 
1340     function setNext(bytes12 next_) public payable note auth {
1341         require(next_ != 0x0, "next cannot be 0x0");
1342         next = next_;
1343     }
1344 
1345     function unset(bytes12 pos) public {
1346         set(pos, address(0));
1347     }
1348 
1349     function unset(address wat) public {
1350         set(indexes[wat], address(0));
1351     }
1352 
1353     function poke() public {
1354         poke(0);
1355     }
1356 
1357     function poke(bytes32) public payable note {
1358         (val, has) = compute();
1359     }
1360 
1361     function compute() public view returns (bytes32, bool) {
1362         bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
1363         uint96 ctr = 0;
1364         for (uint96 i = 1; i < uint96(next); i++) {
1365             if (values[bytes12(i)] != address(0)) {
1366                 (bytes32 wut, bool wuz) = DSValue(values[bytes12(i)]).peek();
1367                 if (wuz) {
1368                     if (ctr == 0 || wut >= wuts[ctr - 1]) {
1369                         wuts[ctr] = wut;
1370                     } else {
1371                         uint96 j = 0;
1372                         while (wut >= wuts[j]) {
1373                             j++;
1374                         }
1375                         for (uint96 k = ctr; k > j; k--) {
1376                             wuts[k] = wuts[k - 1];
1377                         }
1378                         wuts[j] = wut;
1379                     }
1380                     ctr++;
1381                 }
1382             }
1383         }
1384 
1385         if (ctr < minimun)
1386             return (val, false);
1387 
1388         bytes32 value;
1389         if (ctr % 2 == 0) {
1390             uint128 val1 = uint128(uint(wuts[(ctr / 2) - 1]));
1391             uint128 val2 = uint128(uint(wuts[ctr / 2]));
1392             value = bytes32(uint256(wdiv(hadd(val1, val2), 2 ether)));
1393         } else {
1394             value = wuts[(ctr - 1) / 2];
1395         }
1396 
1397         return (value, true);
1398     }
1399 }
1400 
1401 // File: @gnosis.pm/dx-contracts/contracts/Oracle/PriceOracleInterface.sol
1402 
1403 /*
1404 This contract is the interface between the MakerDAO priceFeed and our DX platform.
1405 */
1406 
1407 
1408 
1409 
1410 contract PriceOracleInterface {
1411     address public priceFeedSource;
1412     address public owner;
1413     bool public emergencyMode;
1414 
1415     // Modifiers
1416     modifier onlyOwner() {
1417         require(msg.sender == owner, "Only the owner can do the operation");
1418         _;
1419     }
1420 
1421     /// @dev constructor of the contract
1422     /// @param _priceFeedSource address of price Feed Source -> should be maker feeds Medianizer contract
1423     constructor(address _owner, address _priceFeedSource) public {
1424         owner = _owner;
1425         priceFeedSource = _priceFeedSource;
1426     }
1427     
1428     /// @dev gives the owner the possibility to put the Interface into an emergencyMode, which will
1429     /// output always a price of 600 USD. This gives everyone time to set up a new pricefeed.
1430     function raiseEmergency(bool _emergencyMode) public onlyOwner {
1431         emergencyMode = _emergencyMode;
1432     }
1433 
1434     /// @dev updates the priceFeedSource
1435     /// @param _owner address of owner
1436     function updateCurator(address _owner) public onlyOwner {
1437         owner = _owner;
1438     }
1439 
1440     /// @dev returns the USDETH price
1441     function getUsdEthPricePeek() public view returns (bytes32 price, bool valid) {
1442         return Medianizer(priceFeedSource).peek();
1443     }
1444 
1445     /// @dev returns the USDETH price, ie gets the USD price from Maker feed with 18 digits, but last 18 digits are cut off
1446     function getUSDETHPrice() public view returns (uint256) {
1447         // if the contract is in the emergencyMode, because there is an issue with the oracle, we will simply return a price of 600 USD
1448         if (emergencyMode) {
1449             return 600;
1450         }
1451         (bytes32 price, ) = Medianizer(priceFeedSource).peek();
1452 
1453         // ensuring that there is no underflow or overflow possible,
1454         // even if the price is compromised
1455         uint priceUint = uint256(price)/(1 ether);
1456         if (priceUint == 0) {
1457             return 1;
1458         }
1459         if (priceUint > 1000000) {
1460             return 1000000; 
1461         }
1462         return priceUint;
1463     }
1464 }
1465 
1466 // File: @gnosis.pm/dx-contracts/contracts/base/EthOracle.sol
1467 
1468 contract EthOracle is AuctioneerManaged, DxMath {
1469     uint constant WAITING_PERIOD_CHANGE_ORACLE = 30 days;
1470 
1471     // Price Oracle interface
1472     PriceOracleInterface public ethUSDOracle;
1473     // Price Oracle interface proposals during update process
1474     PriceOracleInterface public newProposalEthUSDOracle;
1475 
1476     uint public oracleInterfaceCountdown;
1477 
1478     event NewOracleProposal(PriceOracleInterface priceOracleInterface);
1479 
1480     function initiateEthUsdOracleUpdate(PriceOracleInterface _ethUSDOracle) public onlyAuctioneer {
1481         require(address(_ethUSDOracle) != address(0), "The oracle address must be valid");
1482         newProposalEthUSDOracle = _ethUSDOracle;
1483         oracleInterfaceCountdown = add(block.timestamp, WAITING_PERIOD_CHANGE_ORACLE);
1484         emit NewOracleProposal(_ethUSDOracle);
1485     }
1486 
1487     function updateEthUSDOracle() public {
1488         require(address(newProposalEthUSDOracle) != address(0), "The new proposal must be a valid addres");
1489         require(
1490             oracleInterfaceCountdown < block.timestamp,
1491             "It's not possible to update the oracle during the waiting period"
1492         );
1493         ethUSDOracle = newProposalEthUSDOracle;
1494         newProposalEthUSDOracle = PriceOracleInterface(0);
1495     }
1496 }
1497 
1498 // File: @gnosis.pm/dx-contracts/contracts/base/DxUpgrade.sol
1499 
1500 contract DxUpgrade is Proxied, AuctioneerManaged, DxMath {
1501     uint constant WAITING_PERIOD_CHANGE_MASTERCOPY = 30 days;
1502 
1503     address public newMasterCopy;
1504     // Time when new masterCopy is updatabale
1505     uint public masterCopyCountdown;
1506 
1507     event NewMasterCopyProposal(address newMasterCopy);
1508 
1509     function startMasterCopyCountdown(address _masterCopy) public onlyAuctioneer {
1510         require(_masterCopy != address(0), "The new master copy must be a valid address");
1511 
1512         // Update masterCopyCountdown
1513         newMasterCopy = _masterCopy;
1514         masterCopyCountdown = add(block.timestamp, WAITING_PERIOD_CHANGE_MASTERCOPY);
1515         emit NewMasterCopyProposal(_masterCopy);
1516     }
1517 
1518     function updateMasterCopy() public {
1519         require(newMasterCopy != address(0), "The new master copy must be a valid address");
1520         require(block.timestamp >= masterCopyCountdown, "The master contract cannot be updated in a waiting period");
1521 
1522         // Update masterCopy
1523         masterCopy = newMasterCopy;
1524         newMasterCopy = address(0);
1525     }
1526 
1527 }
1528 
1529 // File: @gnosis.pm/dx-contracts/contracts/DutchExchange.sol
1530 
1531 /// @title Dutch Exchange - exchange token pairs with the clever mechanism of the dutch auction
1532 /// @author Alex Herrmann - <alex@gnosis.pm>
1533 /// @author Dominik Teiml - <dominik@gnosis.pm>
1534 
1535 contract DutchExchange is DxUpgrade, TokenWhitelist, EthOracle, SafeTransfer {
1536 
1537     // The price is a rational number, so we need a concept of a fraction
1538     struct Fraction {
1539         uint num;
1540         uint den;
1541     }
1542 
1543     uint constant WAITING_PERIOD_NEW_TOKEN_PAIR = 6 hours;
1544     uint constant WAITING_PERIOD_NEW_AUCTION = 10 minutes;
1545     uint constant AUCTION_START_WAITING_FOR_FUNDING = 1;
1546 
1547     // > Storage
1548     // Ether ERC-20 token
1549     address public ethToken;
1550 
1551     // Minimum required sell funding for adding a new token pair, in USD
1552     uint public thresholdNewTokenPair;
1553     // Minimum required sell funding for starting antoher auction, in USD
1554     uint public thresholdNewAuction;
1555     // Fee reduction token (magnolia, ERC-20 token)
1556     TokenFRT public frtToken;
1557     // Token for paying fees
1558     TokenOWL public owlToken;
1559 
1560     // For the following three mappings, there is one mapping for each token pair
1561     // The order which the tokens should be called is smaller, larger
1562     // These variables should never be called directly! They have getters below
1563     // Token => Token => index
1564     mapping(address => mapping(address => uint)) public latestAuctionIndices;
1565     // Token => Token => time
1566     mapping (address => mapping (address => uint)) public auctionStarts;
1567     // Token => Token => auctionIndex => time
1568     mapping (address => mapping (address => mapping (uint => uint))) public clearingTimes;
1569 
1570     // Token => Token => auctionIndex => price
1571     mapping(address => mapping(address => mapping(uint => Fraction))) public closingPrices;
1572 
1573     // Token => Token => amount
1574     mapping(address => mapping(address => uint)) public sellVolumesCurrent;
1575     // Token => Token => amount
1576     mapping(address => mapping(address => uint)) public sellVolumesNext;
1577     // Token => Token => amount
1578     mapping(address => mapping(address => uint)) public buyVolumes;
1579 
1580     // Token => user => amount
1581     // balances stores a user's balance in the DutchX
1582     mapping(address => mapping(address => uint)) public balances;
1583 
1584     // Token => Token => auctionIndex => amount
1585     mapping(address => mapping(address => mapping(uint => uint))) public extraTokens;
1586 
1587     // Token => Token =>  auctionIndex => user => amount
1588     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public sellerBalances;
1589     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public buyerBalances;
1590     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public claimedAmounts;
1591 
1592     function depositAndSell(address sellToken, address buyToken, uint amount)
1593         external
1594         returns (uint newBal, uint auctionIndex, uint newSellerBal)
1595     {
1596         newBal = deposit(sellToken, amount);
1597         (auctionIndex, newSellerBal) = postSellOrder(sellToken, buyToken, 0, amount);
1598     }
1599 
1600     function claimAndWithdraw(address sellToken, address buyToken, address user, uint auctionIndex, uint amount)
1601         external
1602         returns (uint returned, uint frtsIssued, uint newBal)
1603     {
1604         (returned, frtsIssued) = claimSellerFunds(sellToken, buyToken, user, auctionIndex);
1605         newBal = withdraw(buyToken, amount);
1606     }
1607 
1608     /// @dev for multiple claims
1609     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1610     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1611     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1612     /// @param user is the user who wants to his tokens
1613     function claimTokensFromSeveralAuctionsAsSeller(
1614         address[] calldata auctionSellTokens,
1615         address[] calldata auctionBuyTokens,
1616         uint[] calldata auctionIndices,
1617         address user
1618     ) external returns (uint[] memory, uint[] memory)
1619     {
1620         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1621 
1622         uint[] memory claimAmounts = new uint[](length);
1623         uint[] memory frtsIssuedList = new uint[](length);
1624 
1625         for (uint i = 0; i < length; i++) {
1626             (claimAmounts[i], frtsIssuedList[i]) = claimSellerFunds(
1627                 auctionSellTokens[i],
1628                 auctionBuyTokens[i],
1629                 user,
1630                 auctionIndices[i]
1631             );
1632         }
1633 
1634         return (claimAmounts, frtsIssuedList);
1635     }
1636 
1637     /// @dev for multiple claims
1638     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1639     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1640     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1641     /// @param user is the user who wants to his tokens
1642     function claimTokensFromSeveralAuctionsAsBuyer(
1643         address[] calldata auctionSellTokens,
1644         address[] calldata auctionBuyTokens,
1645         uint[] calldata auctionIndices,
1646         address user
1647     ) external returns (uint[] memory, uint[] memory)
1648     {
1649         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1650 
1651         uint[] memory claimAmounts = new uint[](length);
1652         uint[] memory frtsIssuedList = new uint[](length);
1653 
1654         for (uint i = 0; i < length; i++) {
1655             (claimAmounts[i], frtsIssuedList[i]) = claimBuyerFunds(
1656                 auctionSellTokens[i],
1657                 auctionBuyTokens[i],
1658                 user,
1659                 auctionIndices[i]
1660             );
1661         }
1662 
1663         return (claimAmounts, frtsIssuedList);
1664     }
1665 
1666     /// @dev for multiple withdraws
1667     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1668     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1669     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1670     function claimAndWithdrawTokensFromSeveralAuctionsAsSeller(
1671         address[] calldata auctionSellTokens,
1672         address[] calldata auctionBuyTokens,
1673         uint[] calldata auctionIndices
1674     ) external returns (uint[] memory, uint frtsIssued)
1675     {
1676         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1677 
1678         uint[] memory claimAmounts = new uint[](length);
1679         uint claimFrts = 0;
1680 
1681         for (uint i = 0; i < length; i++) {
1682             (claimAmounts[i], claimFrts) = claimSellerFunds(
1683                 auctionSellTokens[i],
1684                 auctionBuyTokens[i],
1685                 msg.sender,
1686                 auctionIndices[i]
1687             );
1688 
1689             frtsIssued += claimFrts;
1690 
1691             withdraw(auctionBuyTokens[i], claimAmounts[i]);
1692         }
1693 
1694         return (claimAmounts, frtsIssued);
1695     }
1696 
1697     /// @dev for multiple withdraws
1698     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1699     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1700     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1701     function claimAndWithdrawTokensFromSeveralAuctionsAsBuyer(
1702         address[] calldata auctionSellTokens,
1703         address[] calldata auctionBuyTokens,
1704         uint[] calldata auctionIndices
1705     ) external returns (uint[] memory, uint frtsIssued)
1706     {
1707         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1708 
1709         uint[] memory claimAmounts = new uint[](length);
1710         uint claimFrts = 0;
1711 
1712         for (uint i = 0; i < length; i++) {
1713             (claimAmounts[i], claimFrts) = claimBuyerFunds(
1714                 auctionSellTokens[i],
1715                 auctionBuyTokens[i],
1716                 msg.sender,
1717                 auctionIndices[i]
1718             );
1719 
1720             frtsIssued += claimFrts;
1721 
1722             withdraw(auctionSellTokens[i], claimAmounts[i]);
1723         }
1724 
1725         return (claimAmounts, frtsIssued);
1726     }
1727 
1728     function getMasterCopy() external view returns (address) {
1729         return masterCopy;
1730     }
1731 
1732     /// @dev Constructor-Function creates exchange
1733     /// @param _frtToken - address of frtToken ERC-20 token
1734     /// @param _owlToken - address of owlToken ERC-20 token
1735     /// @param _auctioneer - auctioneer for managing interfaces
1736     /// @param _ethToken - address of ETH ERC-20 token
1737     /// @param _ethUSDOracle - address of the oracle contract for fetching feeds
1738     /// @param _thresholdNewTokenPair - Minimum required sell funding for adding a new token pair, in USD
1739     function setupDutchExchange(
1740         TokenFRT _frtToken,
1741         TokenOWL _owlToken,
1742         address _auctioneer,
1743         address _ethToken,
1744         PriceOracleInterface _ethUSDOracle,
1745         uint _thresholdNewTokenPair,
1746         uint _thresholdNewAuction
1747     ) public
1748     {
1749         // Make sure contract hasn't been initialised
1750         require(ethToken == address(0), "The contract must be uninitialized");
1751 
1752         // Validates inputs
1753         require(address(_owlToken) != address(0), "The OWL address must be valid");
1754         require(address(_frtToken) != address(0), "The FRT address must be valid");
1755         require(_auctioneer != address(0), "The auctioneer address must be valid");
1756         require(_ethToken != address(0), "The WETH address must be valid");
1757         require(address(_ethUSDOracle) != address(0), "The oracle address must be valid");
1758 
1759         frtToken = _frtToken;
1760         owlToken = _owlToken;
1761         auctioneer = _auctioneer;
1762         ethToken = _ethToken;
1763         ethUSDOracle = _ethUSDOracle;
1764         thresholdNewTokenPair = _thresholdNewTokenPair;
1765         thresholdNewAuction = _thresholdNewAuction;
1766     }
1767 
1768     function updateThresholdNewTokenPair(uint _thresholdNewTokenPair) public onlyAuctioneer {
1769         thresholdNewTokenPair = _thresholdNewTokenPair;
1770     }
1771 
1772     function updateThresholdNewAuction(uint _thresholdNewAuction) public onlyAuctioneer {
1773         thresholdNewAuction = _thresholdNewAuction;
1774     }
1775 
1776     /// @param initialClosingPriceNum initial price will be 2 * initialClosingPrice. This is its numerator
1777     /// @param initialClosingPriceDen initial price will be 2 * initialClosingPrice. This is its denominator
1778     function addTokenPair(
1779         address token1,
1780         address token2,
1781         uint token1Funding,
1782         uint token2Funding,
1783         uint initialClosingPriceNum,
1784         uint initialClosingPriceDen
1785     ) public
1786     {
1787         // R1
1788         require(token1 != token2, "You cannot add a token pair using the same token");
1789 
1790         // R2
1791         require(initialClosingPriceNum != 0, "You must set the numerator for the initial price");
1792 
1793         // R3
1794         require(initialClosingPriceDen != 0, "You must set the denominator for the initial price");
1795 
1796         // R4
1797         require(getAuctionIndex(token1, token2) == 0, "The token pair was already added");
1798 
1799         // R5: to prevent overflow
1800         require(initialClosingPriceNum < 10 ** 18, "You must set a smaller numerator for the initial price");
1801 
1802         // R6
1803         require(initialClosingPriceDen < 10 ** 18, "You must set a smaller denominator for the initial price");
1804 
1805         setAuctionIndex(token1, token2);
1806 
1807         token1Funding = min(token1Funding, balances[token1][msg.sender]);
1808         token2Funding = min(token2Funding, balances[token2][msg.sender]);
1809 
1810         // R7
1811         require(token1Funding < 10 ** 30, "You should use a smaller funding for token 1");
1812 
1813         // R8
1814         require(token2Funding < 10 ** 30, "You should use a smaller funding for token 2");
1815 
1816         uint fundedValueUSD;
1817         uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();
1818 
1819         // Compute fundedValueUSD
1820         address ethTokenMem = ethToken;
1821         if (token1 == ethTokenMem) {
1822             // C1
1823             // MUL: 10^30 * 10^6 = 10^36
1824             fundedValueUSD = mul(token1Funding, ethUSDPrice);
1825         } else if (token2 == ethTokenMem) {
1826             // C2
1827             // MUL: 10^30 * 10^6 = 10^36
1828             fundedValueUSD = mul(token2Funding, ethUSDPrice);
1829         } else {
1830             // C3: Neither token is ethToken
1831             fundedValueUSD = calculateFundedValueTokenToken(
1832                 token1,
1833                 token2,
1834                 token1Funding,
1835                 token2Funding,
1836                 ethTokenMem,
1837                 ethUSDPrice
1838             );
1839         }
1840 
1841         // R5
1842         require(fundedValueUSD >= thresholdNewTokenPair, "You should surplus the threshold for adding token pairs");
1843 
1844         // Save prices of opposite auctions
1845         closingPrices[token1][token2][0] = Fraction(initialClosingPriceNum, initialClosingPriceDen);
1846         closingPrices[token2][token1][0] = Fraction(initialClosingPriceDen, initialClosingPriceNum);
1847 
1848         // Split into two fns because of 16 local-var cap
1849         addTokenPairSecondPart(token1, token2, token1Funding, token2Funding);
1850     }
1851 
1852     function deposit(address tokenAddress, uint amount) public returns (uint) {
1853         // R1
1854         require(safeTransfer(tokenAddress, msg.sender, amount, true), "The deposit transaction must succeed");
1855 
1856         uint newBal = add(balances[tokenAddress][msg.sender], amount);
1857 
1858         balances[tokenAddress][msg.sender] = newBal;
1859 
1860         emit NewDeposit(tokenAddress, amount);
1861 
1862         return newBal;
1863     }
1864 
1865     function withdraw(address tokenAddress, uint amount) public returns (uint) {
1866         uint usersBalance = balances[tokenAddress][msg.sender];
1867         amount = min(amount, usersBalance);
1868 
1869         // R1
1870         require(amount > 0, "The amount must be greater than 0");
1871 
1872         uint newBal = sub(usersBalance, amount);
1873         balances[tokenAddress][msg.sender] = newBal;
1874 
1875         // R2
1876         require(safeTransfer(tokenAddress, msg.sender, amount, false), "The withdraw transfer must succeed");
1877         emit NewWithdrawal(tokenAddress, amount);
1878 
1879         return newBal;
1880     }
1881 
1882     function postSellOrder(address sellToken, address buyToken, uint auctionIndex, uint amount)
1883         public
1884         returns (uint, uint)
1885     {
1886         // Note: if a user specifies auctionIndex of 0, it
1887         // means he is agnostic which auction his sell order goes into
1888 
1889         amount = min(amount, balances[sellToken][msg.sender]);
1890 
1891         // R1
1892         // require(amount >= 0, "Sell amount should be greater than 0");
1893 
1894         // R2
1895         uint latestAuctionIndex = getAuctionIndex(sellToken, buyToken);
1896         require(latestAuctionIndex > 0);
1897 
1898         // R3
1899         uint auctionStart = getAuctionStart(sellToken, buyToken);
1900         if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING || auctionStart > now) {
1901             // C1: We are in the 10 minute buffer period
1902             // OR waiting for an auction to receive sufficient sellVolume
1903             // Auction has already cleared, and index has been incremented
1904             // sell order must use that auction index
1905             // R1.1
1906             if (auctionIndex == 0) {
1907                 auctionIndex = latestAuctionIndex;
1908             } else {
1909                 require(auctionIndex == latestAuctionIndex, "Auction index should be equal to latest auction index");
1910             }
1911 
1912             // R1.2
1913             require(add(sellVolumesCurrent[sellToken][buyToken], amount) < 10 ** 30);
1914         } else {
1915             // C2
1916             // R2.1: Sell orders must go to next auction
1917             if (auctionIndex == 0) {
1918                 auctionIndex = latestAuctionIndex + 1;
1919             } else {
1920                 require(auctionIndex == latestAuctionIndex + 1);
1921             }
1922 
1923             // R2.2
1924             require(add(sellVolumesNext[sellToken][buyToken], amount) < 10 ** 30);
1925         }
1926 
1927         // Fee mechanism, fees are added to extraTokens
1928         uint amountAfterFee = settleFee(sellToken, buyToken, auctionIndex, amount);
1929 
1930         // Update variables
1931         balances[sellToken][msg.sender] = sub(balances[sellToken][msg.sender], amount);
1932         uint newSellerBal = add(sellerBalances[sellToken][buyToken][auctionIndex][msg.sender], amountAfterFee);
1933         sellerBalances[sellToken][buyToken][auctionIndex][msg.sender] = newSellerBal;
1934 
1935         if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING || auctionStart > now) {
1936             // C1
1937             uint sellVolumeCurrent = sellVolumesCurrent[sellToken][buyToken];
1938             sellVolumesCurrent[sellToken][buyToken] = add(sellVolumeCurrent, amountAfterFee);
1939         } else {
1940             // C2
1941             uint sellVolumeNext = sellVolumesNext[sellToken][buyToken];
1942             sellVolumesNext[sellToken][buyToken] = add(sellVolumeNext, amountAfterFee);
1943 
1944             // close previous auction if theoretically closed
1945             closeTheoreticalClosedAuction(sellToken, buyToken, latestAuctionIndex);
1946         }
1947 
1948         if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING) {
1949             scheduleNextAuction(sellToken, buyToken);
1950         }
1951 
1952         emit NewSellOrder(sellToken, buyToken, msg.sender, auctionIndex, amountAfterFee);
1953 
1954         return (auctionIndex, newSellerBal);
1955     }
1956 
1957     function postBuyOrder(address sellToken, address buyToken, uint auctionIndex, uint amount)
1958         public
1959         returns (uint newBuyerBal)
1960     {
1961         // R1: auction must not have cleared
1962         require(closingPrices[sellToken][buyToken][auctionIndex].den == 0);
1963 
1964         uint auctionStart = getAuctionStart(sellToken, buyToken);
1965 
1966         // R2
1967         require(auctionStart <= now);
1968 
1969         // R4
1970         require(auctionIndex == getAuctionIndex(sellToken, buyToken));
1971 
1972         // R5: auction must not be in waiting period
1973         require(auctionStart > AUCTION_START_WAITING_FOR_FUNDING);
1974 
1975         // R6: auction must be funded
1976         require(sellVolumesCurrent[sellToken][buyToken] > 0);
1977 
1978         uint buyVolume = buyVolumes[sellToken][buyToken];
1979         amount = min(amount, balances[buyToken][msg.sender]);
1980 
1981         // R7
1982         require(add(buyVolume, amount) < 10 ** 30);
1983 
1984         // Overbuy is when a part of a buy order clears an auction
1985         // In that case we only process the part before the overbuy
1986         // To calculate overbuy, we first get current price
1987         uint sellVolume = sellVolumesCurrent[sellToken][buyToken];
1988 
1989         uint num;
1990         uint den;
1991         (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
1992         // 10^30 * 10^37 = 10^67
1993         uint outstandingVolume = atleastZero(int(mul(sellVolume, num) / den - buyVolume));
1994 
1995         uint amountAfterFee;
1996         if (amount < outstandingVolume) {
1997             if (amount > 0) {
1998                 amountAfterFee = settleFee(buyToken, sellToken, auctionIndex, amount);
1999             }
2000         } else {
2001             amount = outstandingVolume;
2002             amountAfterFee = outstandingVolume;
2003         }
2004 
2005         // Here we could also use outstandingVolume or amountAfterFee, it doesn't matter
2006         if (amount > 0) {
2007             // Update variables
2008             balances[buyToken][msg.sender] = sub(balances[buyToken][msg.sender], amount);
2009             newBuyerBal = add(buyerBalances[sellToken][buyToken][auctionIndex][msg.sender], amountAfterFee);
2010             buyerBalances[sellToken][buyToken][auctionIndex][msg.sender] = newBuyerBal;
2011             buyVolumes[sellToken][buyToken] = add(buyVolumes[sellToken][buyToken], amountAfterFee);
2012             emit NewBuyOrder(sellToken, buyToken, msg.sender, auctionIndex, amountAfterFee);
2013         }
2014 
2015         // Checking for equality would suffice here. nevertheless:
2016         if (amount >= outstandingVolume) {
2017             // Clear auction
2018             clearAuction(sellToken, buyToken, auctionIndex, sellVolume);
2019         }
2020 
2021         return (newBuyerBal);
2022     }
2023 
2024     function claimSellerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
2025         public
2026         returns (
2027         // < (10^60, 10^61)
2028         uint returned,
2029         uint frtsIssued
2030     )
2031     {
2032         closeTheoreticalClosedAuction(sellToken, buyToken, auctionIndex);
2033         uint sellerBalance = sellerBalances[sellToken][buyToken][auctionIndex][user];
2034 
2035         // R1
2036         require(sellerBalance > 0);
2037 
2038         // Get closing price for said auction
2039         Fraction memory closingPrice = closingPrices[sellToken][buyToken][auctionIndex];
2040         uint num = closingPrice.num;
2041         uint den = closingPrice.den;
2042 
2043         // R2: require auction to have cleared
2044         require(den > 0);
2045 
2046         // Calculate return
2047         // < 10^30 * 10^30 = 10^60
2048         returned = mul(sellerBalance, num) / den;
2049 
2050         frtsIssued = issueFrts(
2051             sellToken,
2052             buyToken,
2053             returned,
2054             auctionIndex,
2055             sellerBalance,
2056             user
2057         );
2058 
2059         // Claim tokens
2060         sellerBalances[sellToken][buyToken][auctionIndex][user] = 0;
2061         if (returned > 0) {
2062             balances[buyToken][user] = add(balances[buyToken][user], returned);
2063         }
2064         emit NewSellerFundsClaim(
2065             sellToken,
2066             buyToken,
2067             user,
2068             auctionIndex,
2069             returned,
2070             frtsIssued
2071         );
2072     }
2073 
2074     function claimBuyerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
2075         public
2076         returns (uint returned, uint frtsIssued)
2077     {
2078         closeTheoreticalClosedAuction(sellToken, buyToken, auctionIndex);
2079 
2080         uint num;
2081         uint den;
2082         (returned, num, den) = getUnclaimedBuyerFunds(sellToken, buyToken, user, auctionIndex);
2083 
2084         if (closingPrices[sellToken][buyToken][auctionIndex].den == 0) {
2085             // Auction is running
2086             claimedAmounts[sellToken][buyToken][auctionIndex][user] = add(
2087                 claimedAmounts[sellToken][buyToken][auctionIndex][user],
2088                 returned
2089             );
2090         } else {
2091             // Auction has closed
2092             // We DON'T want to check for returned > 0, because that would fail if a user claims
2093             // intermediate funds & auction clears in same block (he/she would not be able to claim extraTokens)
2094 
2095             // Assign extra sell tokens (this is possible only after auction has cleared,
2096             // because buyVolume could still increase before that)
2097             uint extraTokensTotal = extraTokens[sellToken][buyToken][auctionIndex];
2098             uint buyerBalance = buyerBalances[sellToken][buyToken][auctionIndex][user];
2099 
2100             // closingPrices.num represents buyVolume
2101             // < 10^30 * 10^30 = 10^60
2102             uint tokensExtra = mul(
2103                 buyerBalance,
2104                 extraTokensTotal
2105             ) / closingPrices[sellToken][buyToken][auctionIndex].num;
2106             returned = add(returned, tokensExtra);
2107 
2108             frtsIssued = issueFrts(
2109                 buyToken,
2110                 sellToken,
2111                 mul(buyerBalance, den) / num,
2112                 auctionIndex,
2113                 buyerBalance,
2114                 user
2115             );
2116 
2117             // Auction has closed
2118             // Reset buyerBalances and claimedAmounts
2119             buyerBalances[sellToken][buyToken][auctionIndex][user] = 0;
2120             claimedAmounts[sellToken][buyToken][auctionIndex][user] = 0;
2121         }
2122 
2123         // Claim tokens
2124         if (returned > 0) {
2125             balances[sellToken][user] = add(balances[sellToken][user], returned);
2126         }
2127 
2128         emit NewBuyerFundsClaim(
2129             sellToken,
2130             buyToken,
2131             user,
2132             auctionIndex,
2133             returned,
2134             frtsIssued
2135         );
2136     }
2137 
2138     /// @dev allows to close possible theoretical closed markets
2139     /// @param sellToken sellToken of an auction
2140     /// @param buyToken buyToken of an auction
2141     /// @param auctionIndex is the auctionIndex of the auction
2142     function closeTheoreticalClosedAuction(address sellToken, address buyToken, uint auctionIndex) public {
2143         if (auctionIndex == getAuctionIndex(
2144             buyToken,
2145             sellToken
2146         ) && closingPrices[sellToken][buyToken][auctionIndex].num == 0) {
2147             uint buyVolume = buyVolumes[sellToken][buyToken];
2148             uint sellVolume = sellVolumesCurrent[sellToken][buyToken];
2149             uint num;
2150             uint den;
2151             (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
2152             // 10^30 * 10^37 = 10^67
2153             if (sellVolume > 0) {
2154                 uint outstandingVolume = atleastZero(int(mul(sellVolume, num) / den - buyVolume));
2155 
2156                 if (outstandingVolume == 0) {
2157                     postBuyOrder(sellToken, buyToken, auctionIndex, 0);
2158                 }
2159             }
2160         }
2161     }
2162 
2163     /// @dev Claim buyer funds for one auction
2164     function getUnclaimedBuyerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
2165         public
2166         view
2167         returns (
2168         // < (10^67, 10^37)
2169         uint unclaimedBuyerFunds,
2170         uint num,
2171         uint den
2172     )
2173     {
2174         // R1: checks if particular auction has ever run
2175         require(auctionIndex <= getAuctionIndex(sellToken, buyToken));
2176 
2177         (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
2178 
2179         if (num == 0) {
2180             // This should rarely happen - as long as there is >= 1 buy order,
2181             // auction will clear before price = 0. So this is just fail-safe
2182             unclaimedBuyerFunds = 0;
2183         } else {
2184             uint buyerBalance = buyerBalances[sellToken][buyToken][auctionIndex][user];
2185             // < 10^30 * 10^37 = 10^67
2186             unclaimedBuyerFunds = atleastZero(
2187                 int(mul(buyerBalance, den) / num - claimedAmounts[sellToken][buyToken][auctionIndex][user])
2188             );
2189         }
2190     }
2191 
2192     function getFeeRatio(address user)
2193         public
2194         view
2195         returns (
2196         // feeRatio < 10^4
2197         uint num,
2198         uint den
2199     )
2200     {
2201         uint totalSupply = frtToken.totalSupply();
2202         uint lockedFrt = frtToken.lockedTokenBalances(user);
2203 
2204         /*
2205           Fee Model:
2206             locked FRT range     Fee
2207             -----------------   ------
2208             [0, 0.01%)           0.5%
2209             [0.01%, 0.1%)        0.4%
2210             [0.1%, 1%)           0.3%
2211             [1%, 10%)            0.2%
2212             [10%, 100%)          0.1%
2213         */
2214 
2215         if (lockedFrt * 10000 < totalSupply || totalSupply == 0) {
2216             // Maximum fee, if user has locked less than 0.01% of the total FRT
2217             // Fee: 0.5%
2218             num = 1;
2219             den = 200;
2220         } else if (lockedFrt * 1000 < totalSupply) {
2221             // If user has locked more than 0.01% and less than 0.1% of the total FRT
2222             // Fee: 0.4%
2223             num = 1;
2224             den = 250;
2225         } else if (lockedFrt * 100 < totalSupply) {
2226             // If user has locked more than 0.1% and less than 1% of the total FRT
2227             // Fee: 0.3%
2228             num = 3;
2229             den = 1000;
2230         } else if (lockedFrt * 10 < totalSupply) {
2231             // If user has locked more than 1% and less than 10% of the total FRT
2232             // Fee: 0.2%
2233             num = 1;
2234             den = 500;
2235         } else {
2236             // If user has locked more than 10% of the total FRT
2237             // Fee: 0.1%
2238             num = 1;
2239             den = 1000;
2240         }
2241     }
2242 
2243     //@ dev returns price in units [token2]/[token1]
2244     //@ param token1 first token for price calculation
2245     //@ param token2 second token for price calculation
2246     //@ param auctionIndex index for the auction to get the averaged price from
2247     function getPriceInPastAuction(
2248         address token1,
2249         address token2,
2250         uint auctionIndex
2251     )
2252         public
2253         view
2254         // price < 10^31
2255         returns (uint num, uint den)
2256     {
2257         if (token1 == token2) {
2258             // C1
2259             num = 1;
2260             den = 1;
2261         } else {
2262             // C2
2263             // R2.1
2264             // require(auctionIndex >= 0);
2265 
2266             // C3
2267             // R3.1
2268             require(auctionIndex <= getAuctionIndex(token1, token2));
2269             // auction still running
2270 
2271             uint i = 0;
2272             bool correctPair = false;
2273             Fraction memory closingPriceToken1;
2274             Fraction memory closingPriceToken2;
2275 
2276             while (!correctPair) {
2277                 closingPriceToken2 = closingPrices[token2][token1][auctionIndex - i];
2278                 closingPriceToken1 = closingPrices[token1][token2][auctionIndex - i];
2279 
2280                 if (closingPriceToken1.num > 0 && closingPriceToken1.den > 0 ||
2281                     closingPriceToken2.num > 0 && closingPriceToken2.den > 0)
2282                 {
2283                     correctPair = true;
2284                 }
2285                 i++;
2286             }
2287 
2288             // At this point at least one closing price is strictly positive
2289             // If only one is positive, we want to output that
2290             if (closingPriceToken1.num == 0 || closingPriceToken1.den == 0) {
2291                 num = closingPriceToken2.den;
2292                 den = closingPriceToken2.num;
2293             } else if (closingPriceToken2.num == 0 || closingPriceToken2.den == 0) {
2294                 num = closingPriceToken1.num;
2295                 den = closingPriceToken1.den;
2296             } else {
2297                 // If both prices are positive, output weighted average
2298                 num = closingPriceToken2.den + closingPriceToken1.num;
2299                 den = closingPriceToken2.num + closingPriceToken1.den;
2300             }
2301         }
2302     }
2303 
2304     function scheduleNextAuction(
2305         address sellToken,
2306         address buyToken
2307     )
2308         internal
2309     {
2310         (uint sellVolume, uint sellVolumeOpp) = getSellVolumesInUSD(sellToken, buyToken);
2311 
2312         bool enoughSellVolume = sellVolume >= thresholdNewAuction;
2313         bool enoughSellVolumeOpp = sellVolumeOpp >= thresholdNewAuction;
2314         bool schedule;
2315         // Make sure both sides have liquidity in order to start the auction
2316         if (enoughSellVolume && enoughSellVolumeOpp) {
2317             schedule = true;
2318         } else if (enoughSellVolume || enoughSellVolumeOpp) {
2319             // But if the auction didn't start in 24h, then is enough to have
2320             // liquidity in one of the two sides
2321             uint latestAuctionIndex = getAuctionIndex(sellToken, buyToken);
2322             uint clearingTime = getClearingTime(sellToken, buyToken, latestAuctionIndex - 1);
2323             schedule = clearingTime <= now - 24 hours;
2324         }
2325 
2326         if (schedule) {
2327             // Schedule next auction
2328             setAuctionStart(sellToken, buyToken, WAITING_PERIOD_NEW_AUCTION);
2329         } else {
2330             resetAuctionStart(sellToken, buyToken);
2331         }
2332     }
2333 
2334     function getSellVolumesInUSD(
2335         address sellToken,
2336         address buyToken
2337     )
2338         internal
2339         view
2340         returns (uint sellVolume, uint sellVolumeOpp)
2341     {
2342         // Check if auctions received enough sell orders
2343         uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();
2344 
2345         uint sellNum;
2346         uint sellDen;
2347         (sellNum, sellDen) = getPriceOfTokenInLastAuction(sellToken);
2348 
2349         uint buyNum;
2350         uint buyDen;
2351         (buyNum, buyDen) = getPriceOfTokenInLastAuction(buyToken);
2352 
2353         // We use current sell volume, because in clearAuction() we set
2354         // sellVolumesCurrent = sellVolumesNext before calling this function
2355         // (this is so that we don't need case work,
2356         // since it might also be called from postSellOrder())
2357 
2358         // < 10^30 * 10^31 * 10^6 = 10^67
2359         sellVolume = mul(mul(sellVolumesCurrent[sellToken][buyToken], sellNum), ethUSDPrice) / sellDen;
2360         sellVolumeOpp = mul(mul(sellVolumesCurrent[buyToken][sellToken], buyNum), ethUSDPrice) / buyDen;
2361     }
2362 
2363     /// @dev Gives best estimate for market price of a token in ETH of any price oracle on the Ethereum network
2364     /// @param token address of ERC-20 token
2365     /// @return Weighted average of closing prices of opposite Token-ethToken auctions, based on their sellVolume
2366     function getPriceOfTokenInLastAuction(address token)
2367         public
2368         view
2369         returns (
2370         // price < 10^31
2371         uint num,
2372         uint den
2373     )
2374     {
2375         uint latestAuctionIndex = getAuctionIndex(token, ethToken);
2376         // getPriceInPastAuction < 10^30
2377         (num, den) = getPriceInPastAuction(token, ethToken, latestAuctionIndex - 1);
2378     }
2379 
2380     function getCurrentAuctionPrice(address sellToken, address buyToken, uint auctionIndex)
2381         public
2382         view
2383         returns (
2384         // price < 10^37
2385         uint num,
2386         uint den
2387     )
2388     {
2389         Fraction memory closingPrice = closingPrices[sellToken][buyToken][auctionIndex];
2390 
2391         if (closingPrice.den != 0) {
2392             // Auction has closed
2393             (num, den) = (closingPrice.num, closingPrice.den);
2394         } else if (auctionIndex > getAuctionIndex(sellToken, buyToken)) {
2395             (num, den) = (0, 0);
2396         } else {
2397             // Auction is running
2398             uint pastNum;
2399             uint pastDen;
2400             (pastNum, pastDen) = getPriceInPastAuction(sellToken, buyToken, auctionIndex - 1);
2401 
2402             // If we're calling the function into an unstarted auction,
2403             // it will return the starting price of that auction
2404             uint timeElapsed = atleastZero(int(now - getAuctionStart(sellToken, buyToken)));
2405 
2406             // The numbers below are chosen such that
2407             // P(0 hrs) = 2 * lastClosingPrice, P(6 hrs) = lastClosingPrice, P(>=24 hrs) = 0
2408 
2409             // 10^5 * 10^31 = 10^36
2410             num = atleastZero(int((24 hours - timeElapsed) * pastNum));
2411             // 10^6 * 10^31 = 10^37
2412             den = mul((timeElapsed + 12 hours), pastDen);
2413 
2414             if (mul(num, sellVolumesCurrent[sellToken][buyToken]) <= mul(den, buyVolumes[sellToken][buyToken])) {
2415                 num = buyVolumes[sellToken][buyToken];
2416                 den = sellVolumesCurrent[sellToken][buyToken];
2417             }
2418         }
2419     }
2420 
2421     // > Helper fns
2422     function getTokenOrder(address token1, address token2) public pure returns (address, address) {
2423         if (token2 < token1) {
2424             (token1, token2) = (token2, token1);
2425         }
2426 
2427         return (token1, token2);
2428     }
2429 
2430     function getAuctionStart(address token1, address token2) public view returns (uint auctionStart) {
2431         (token1, token2) = getTokenOrder(token1, token2);
2432         auctionStart = auctionStarts[token1][token2];
2433     }
2434 
2435     function getAuctionIndex(address token1, address token2) public view returns (uint auctionIndex) {
2436         (token1, token2) = getTokenOrder(token1, token2);
2437         auctionIndex = latestAuctionIndices[token1][token2];
2438     }
2439 
2440     function calculateFundedValueTokenToken(
2441         address token1,
2442         address token2,
2443         uint token1Funding,
2444         uint token2Funding,
2445         address ethTokenMem,
2446         uint ethUSDPrice
2447     )
2448         internal
2449         view
2450         returns (uint fundedValueUSD)
2451     {
2452         // We require there to exist ethToken-Token auctions
2453         // R3.1
2454         require(getAuctionIndex(token1, ethTokenMem) > 0);
2455 
2456         // R3.2
2457         require(getAuctionIndex(token2, ethTokenMem) > 0);
2458 
2459         // Price of Token 1
2460         uint priceToken1Num;
2461         uint priceToken1Den;
2462         (priceToken1Num, priceToken1Den) = getPriceOfTokenInLastAuction(token1);
2463 
2464         // Price of Token 2
2465         uint priceToken2Num;
2466         uint priceToken2Den;
2467         (priceToken2Num, priceToken2Den) = getPriceOfTokenInLastAuction(token2);
2468 
2469         // Compute funded value in ethToken and USD
2470         // 10^30 * 10^30 = 10^60
2471         uint fundedValueETH = add(
2472             mul(token1Funding, priceToken1Num) / priceToken1Den,
2473             token2Funding * priceToken2Num / priceToken2Den
2474         );
2475 
2476         fundedValueUSD = mul(fundedValueETH, ethUSDPrice);
2477     }
2478 
2479     function addTokenPairSecondPart(
2480         address token1,
2481         address token2,
2482         uint token1Funding,
2483         uint token2Funding
2484     )
2485         internal
2486     {
2487         balances[token1][msg.sender] = sub(balances[token1][msg.sender], token1Funding);
2488         balances[token2][msg.sender] = sub(balances[token2][msg.sender], token2Funding);
2489 
2490         // Fee mechanism, fees are added to extraTokens
2491         uint token1FundingAfterFee = settleFee(token1, token2, 1, token1Funding);
2492         uint token2FundingAfterFee = settleFee(token2, token1, 1, token2Funding);
2493 
2494         // Update other variables
2495         sellVolumesCurrent[token1][token2] = token1FundingAfterFee;
2496         sellVolumesCurrent[token2][token1] = token2FundingAfterFee;
2497         sellerBalances[token1][token2][1][msg.sender] = token1FundingAfterFee;
2498         sellerBalances[token2][token1][1][msg.sender] = token2FundingAfterFee;
2499 
2500         // Save clearingTime as adding time
2501         (address tokenA, address tokenB) = getTokenOrder(token1, token2);
2502         clearingTimes[tokenA][tokenB][0] = now;
2503 
2504         setAuctionStart(token1, token2, WAITING_PERIOD_NEW_TOKEN_PAIR);
2505         emit NewTokenPair(token1, token2);
2506     }
2507 
2508     function setClearingTime(
2509         address token1,
2510         address token2,
2511         uint auctionIndex,
2512         uint auctionStart,
2513         uint sellVolume,
2514         uint buyVolume
2515     )
2516         internal
2517     {
2518         (uint pastNum, uint pastDen) = getPriceInPastAuction(token1, token2, auctionIndex - 1);
2519         // timeElapsed = (12 hours)*(2 * pastNum * sellVolume - buyVolume * pastDen)/
2520             // (sellVolume * pastNum + buyVolume * pastDen)
2521         uint numerator = sub(mul(mul(pastNum, sellVolume), 24 hours), mul(mul(buyVolume, pastDen), 12 hours));
2522         uint timeElapsed = numerator / (add(mul(sellVolume, pastNum), mul(buyVolume, pastDen)));
2523         uint clearingTime = auctionStart + timeElapsed;
2524         (token1, token2) = getTokenOrder(token1, token2);
2525         clearingTimes[token1][token2][auctionIndex] = clearingTime;
2526     }
2527 
2528     function getClearingTime(
2529         address token1,
2530         address token2,
2531         uint auctionIndex
2532     )
2533         public
2534         view
2535         returns (uint time)
2536     {
2537         (token1, token2) = getTokenOrder(token1, token2);
2538         time = clearingTimes[token1][token2][auctionIndex];
2539     }
2540 
2541     function issueFrts(
2542         address primaryToken,
2543         address secondaryToken,
2544         uint x,
2545         uint auctionIndex,
2546         uint bal,
2547         address user
2548     )
2549         internal
2550         returns (uint frtsIssued)
2551     {
2552         if (approvedTokens[primaryToken] && approvedTokens[secondaryToken]) {
2553             address ethTokenMem = ethToken;
2554             // Get frts issued based on ETH price of returned tokens
2555             if (primaryToken == ethTokenMem) {
2556                 frtsIssued = bal;
2557             } else if (secondaryToken == ethTokenMem) {
2558                 // 10^30 * 10^39 = 10^66
2559                 frtsIssued = x;
2560             } else {
2561                 // Neither token is ethToken, so we use getHhistoricalPriceOracle()
2562                 uint pastNum;
2563                 uint pastDen;
2564                 (pastNum, pastDen) = getPriceInPastAuction(primaryToken, ethTokenMem, auctionIndex - 1);
2565                 // 10^30 * 10^35 = 10^65
2566                 frtsIssued = mul(bal, pastNum) / pastDen;
2567             }
2568 
2569             if (frtsIssued > 0) {
2570                 // Issue frtToken
2571                 frtToken.mintTokens(user, frtsIssued);
2572             }
2573         }
2574     }
2575 
2576     function settleFee(address primaryToken, address secondaryToken, uint auctionIndex, uint amount)
2577         internal
2578         returns (
2579         // < 10^30
2580         uint amountAfterFee
2581     )
2582     {
2583         uint feeNum;
2584         uint feeDen;
2585         (feeNum, feeDen) = getFeeRatio(msg.sender);
2586         // 10^30 * 10^3 / 10^4 = 10^29
2587         uint fee = mul(amount, feeNum) / feeDen;
2588 
2589         if (fee > 0) {
2590             fee = settleFeeSecondPart(primaryToken, fee);
2591 
2592             uint usersExtraTokens = extraTokens[primaryToken][secondaryToken][auctionIndex + 1];
2593             extraTokens[primaryToken][secondaryToken][auctionIndex + 1] = add(usersExtraTokens, fee);
2594 
2595             emit Fee(primaryToken, secondaryToken, msg.sender, auctionIndex, fee);
2596         }
2597 
2598         amountAfterFee = sub(amount, fee);
2599     }
2600 
2601     function settleFeeSecondPart(address primaryToken, uint fee) internal returns (uint newFee) {
2602         // Allow user to reduce up to half of the fee with owlToken
2603         uint num;
2604         uint den;
2605         (num, den) = getPriceOfTokenInLastAuction(primaryToken);
2606 
2607         // Convert fee to ETH, then USD
2608         // 10^29 * 10^30 / 10^30 = 10^29
2609         uint feeInETH = mul(fee, num) / den;
2610 
2611         uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();
2612         // 10^29 * 10^6 = 10^35
2613         // Uses 18 decimal places <> exactly as owlToken tokens: 10**18 owlToken == 1 USD
2614         uint feeInUSD = mul(feeInETH, ethUSDPrice);
2615         uint amountOfowlTokenBurned = min(owlToken.allowance(msg.sender, address(this)), feeInUSD / 2);
2616         amountOfowlTokenBurned = min(owlToken.balanceOf(msg.sender), amountOfowlTokenBurned);
2617 
2618         if (amountOfowlTokenBurned > 0) {
2619             owlToken.burnOWL(msg.sender, amountOfowlTokenBurned);
2620             // Adjust fee
2621             // 10^35 * 10^29 = 10^64
2622             uint adjustment = mul(amountOfowlTokenBurned, fee) / feeInUSD;
2623             newFee = sub(fee, adjustment);
2624         } else {
2625             newFee = fee;
2626         }
2627     }
2628 
2629     // addClearTimes
2630     /// @dev clears an Auction
2631     /// @param sellToken sellToken of the auction
2632     /// @param buyToken  buyToken of the auction
2633     /// @param auctionIndex of the auction to be cleared.
2634     function clearAuction(
2635         address sellToken,
2636         address buyToken,
2637         uint auctionIndex,
2638         uint sellVolume
2639     )
2640         internal
2641     {
2642         // Get variables
2643         uint buyVolume = buyVolumes[sellToken][buyToken];
2644         uint sellVolumeOpp = sellVolumesCurrent[buyToken][sellToken];
2645         uint closingPriceOppDen = closingPrices[buyToken][sellToken][auctionIndex].den;
2646         uint auctionStart = getAuctionStart(sellToken, buyToken);
2647 
2648         // Update closing price
2649         if (sellVolume > 0) {
2650             closingPrices[sellToken][buyToken][auctionIndex] = Fraction(buyVolume, sellVolume);
2651         }
2652 
2653         // if (opposite is 0 auction OR price = 0 OR opposite auction cleared)
2654         // price = 0 happens if auction pair has been running for >= 24 hrs
2655         if (sellVolumeOpp == 0 || now >= auctionStart + 24 hours || closingPriceOppDen > 0) {
2656             // Close auction pair
2657             uint buyVolumeOpp = buyVolumes[buyToken][sellToken];
2658             if (closingPriceOppDen == 0 && sellVolumeOpp > 0) {
2659                 // Save opposite price
2660                 closingPrices[buyToken][sellToken][auctionIndex] = Fraction(buyVolumeOpp, sellVolumeOpp);
2661             }
2662 
2663             uint sellVolumeNext = sellVolumesNext[sellToken][buyToken];
2664             uint sellVolumeNextOpp = sellVolumesNext[buyToken][sellToken];
2665 
2666             // Update state variables for both auctions
2667             sellVolumesCurrent[sellToken][buyToken] = sellVolumeNext;
2668             if (sellVolumeNext > 0) {
2669                 sellVolumesNext[sellToken][buyToken] = 0;
2670             }
2671             if (buyVolume > 0) {
2672                 buyVolumes[sellToken][buyToken] = 0;
2673             }
2674 
2675             sellVolumesCurrent[buyToken][sellToken] = sellVolumeNextOpp;
2676             if (sellVolumeNextOpp > 0) {
2677                 sellVolumesNext[buyToken][sellToken] = 0;
2678             }
2679             if (buyVolumeOpp > 0) {
2680                 buyVolumes[buyToken][sellToken] = 0;
2681             }
2682 
2683             // Save clearing time
2684             setClearingTime(sellToken, buyToken, auctionIndex, auctionStart, sellVolume, buyVolume);
2685             // Increment auction index
2686             setAuctionIndex(sellToken, buyToken);
2687             // Check if next auction can be scheduled
2688             scheduleNextAuction(sellToken, buyToken);
2689         }
2690 
2691         emit AuctionCleared(sellToken, buyToken, sellVolume, buyVolume, auctionIndex);
2692     }
2693 
2694     function setAuctionStart(address token1, address token2, uint value) internal {
2695         (token1, token2) = getTokenOrder(token1, token2);
2696         uint auctionStart = now + value;
2697         uint auctionIndex = latestAuctionIndices[token1][token2];
2698         auctionStarts[token1][token2] = auctionStart;
2699         emit AuctionStartScheduled(token1, token2, auctionIndex, auctionStart);
2700     }
2701 
2702     function resetAuctionStart(address token1, address token2) internal {
2703         (token1, token2) = getTokenOrder(token1, token2);
2704         if (auctionStarts[token1][token2] != AUCTION_START_WAITING_FOR_FUNDING) {
2705             auctionStarts[token1][token2] = AUCTION_START_WAITING_FOR_FUNDING;
2706         }
2707     }
2708 
2709     function setAuctionIndex(address token1, address token2) internal {
2710         (token1, token2) = getTokenOrder(token1, token2);
2711         latestAuctionIndices[token1][token2] += 1;
2712     }
2713 
2714     function checkLengthsForSeveralAuctionClaiming(
2715         address[] memory auctionSellTokens,
2716         address[] memory auctionBuyTokens,
2717         uint[] memory auctionIndices
2718     ) internal pure returns (uint length)
2719     {
2720         length = auctionSellTokens.length;
2721         uint length2 = auctionBuyTokens.length;
2722         require(length == length2);
2723 
2724         uint length3 = auctionIndices.length;
2725         require(length2 == length3);
2726     }
2727 
2728     // > Events
2729     event NewDeposit(address indexed token, uint amount);
2730 
2731     event NewWithdrawal(address indexed token, uint amount);
2732 
2733     event NewSellOrder(
2734         address indexed sellToken,
2735         address indexed buyToken,
2736         address indexed user,
2737         uint auctionIndex,
2738         uint amount
2739     );
2740 
2741     event NewBuyOrder(
2742         address indexed sellToken,
2743         address indexed buyToken,
2744         address indexed user,
2745         uint auctionIndex,
2746         uint amount
2747     );
2748 
2749     event NewSellerFundsClaim(
2750         address indexed sellToken,
2751         address indexed buyToken,
2752         address indexed user,
2753         uint auctionIndex,
2754         uint amount,
2755         uint frtsIssued
2756     );
2757 
2758     event NewBuyerFundsClaim(
2759         address indexed sellToken,
2760         address indexed buyToken,
2761         address indexed user,
2762         uint auctionIndex,
2763         uint amount,
2764         uint frtsIssued
2765     );
2766 
2767     event NewTokenPair(address indexed sellToken, address indexed buyToken);
2768 
2769     event AuctionCleared(
2770         address indexed sellToken,
2771         address indexed buyToken,
2772         uint sellVolume,
2773         uint buyVolume,
2774         uint indexed auctionIndex
2775     );
2776 
2777     event AuctionStartScheduled(
2778         address indexed sellToken,
2779         address indexed buyToken,
2780         uint indexed auctionIndex,
2781         uint auctionStart
2782     );
2783 
2784     event Fee(
2785         address indexed primaryToken,
2786         address indexed secondarToken,
2787         address indexed user,
2788         uint auctionIndex,
2789         uint fee
2790     );
2791 }
2792 
2793 // File: @gnosis.pm/util-contracts/contracts/EtherToken.sol
2794 
2795 /// @title Token contract - Token exchanging Ether 1:1
2796 /// @author Stefan George - <stefan@gnosis.pm>
2797 contract EtherToken is GnosisStandardToken {
2798     using GnosisMath for *;
2799 
2800     /*
2801      *  Events
2802      */
2803     event Deposit(address indexed sender, uint value);
2804     event Withdrawal(address indexed receiver, uint value);
2805 
2806     /*
2807      *  Constants
2808      */
2809     string public constant name = "Ether Token";
2810     string public constant symbol = "ETH";
2811     uint8 public constant decimals = 18;
2812 
2813     /*
2814      *  Public functions
2815      */
2816     /// @dev Buys tokens with Ether, exchanging them 1:1
2817     function deposit() public payable {
2818         balances[msg.sender] = balances[msg.sender].add(msg.value);
2819         totalTokens = totalTokens.add(msg.value);
2820         emit Deposit(msg.sender, msg.value);
2821     }
2822 
2823     /// @dev Sells tokens in exchange for Ether, exchanging them 1:1
2824     /// @param value Number of tokens to sell
2825     function withdraw(uint value) public {
2826         // Balance covers value
2827         balances[msg.sender] = balances[msg.sender].sub(value);
2828         totalTokens = totalTokens.sub(value);
2829         msg.sender.transfer(value);
2830         emit Withdrawal(msg.sender, value);
2831     }
2832 }
2833 
2834 // File: contracts/KyberDxMarketMaker.sol
2835 
2836 interface KyberNetworkProxy {
2837     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
2838         external
2839         view
2840         returns (uint expectedRate, uint slippageRate);
2841 }
2842 
2843 
2844 contract KyberDxMarketMaker is Withdrawable {
2845     // This is the representation of ETH as an ERC20 Token for Kyber Network.
2846     ERC20 constant internal KYBER_ETH_TOKEN = ERC20(
2847         0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
2848     );
2849 
2850     // Declared in DutchExchange contract but not public.
2851     uint public constant DX_AUCTION_START_WAITING_FOR_FUNDING = 1;
2852 
2853     enum AuctionState {
2854         WAITING_FOR_FUNDING,
2855         WAITING_FOR_OPP_FUNDING,
2856         WAITING_FOR_SCHEDULED_AUCTION,
2857         AUCTION_IN_PROGRESS,
2858         WAITING_FOR_OPP_TO_FINISH,
2859         AUCTION_EXPIRED
2860     }
2861 
2862     // Exposing the enum values to external tools.
2863     AuctionState constant public WAITING_FOR_FUNDING = AuctionState.WAITING_FOR_FUNDING;
2864     AuctionState constant public WAITING_FOR_OPP_FUNDING = AuctionState.WAITING_FOR_OPP_FUNDING;
2865     AuctionState constant public WAITING_FOR_SCHEDULED_AUCTION = AuctionState.WAITING_FOR_SCHEDULED_AUCTION;
2866     AuctionState constant public AUCTION_IN_PROGRESS = AuctionState.AUCTION_IN_PROGRESS;
2867     AuctionState constant public WAITING_FOR_OPP_TO_FINISH = AuctionState.WAITING_FOR_OPP_TO_FINISH;
2868     AuctionState constant public AUCTION_EXPIRED = AuctionState.AUCTION_EXPIRED;
2869 
2870     DutchExchange public dx;
2871     EtherToken public weth;
2872     KyberNetworkProxy public kyberNetworkProxy;
2873 
2874     // Token => Token => auctionIndex
2875     mapping (address => mapping (address => uint)) public lastParticipatedAuction;
2876 
2877     constructor(
2878         DutchExchange _dx,
2879         KyberNetworkProxy _kyberNetworkProxy
2880     ) public {
2881         require(
2882             address(_dx) != address(0),
2883             "DutchExchange address cannot be 0"
2884         );
2885         require(
2886             address(_kyberNetworkProxy) != address(0),
2887             "KyberNetworkProxy address cannot be 0"
2888         );
2889 
2890         dx = DutchExchange(_dx);
2891         weth = EtherToken(dx.ethToken());
2892         kyberNetworkProxy = KyberNetworkProxy(_kyberNetworkProxy);
2893     }
2894 
2895     event KyberNetworkProxyUpdated(
2896         KyberNetworkProxy kyberNetworkProxy
2897     );
2898 
2899     function setKyberNetworkProxy(
2900         KyberNetworkProxy _kyberNetworkProxy
2901     )
2902         public
2903         onlyAdmin
2904         returns (bool)
2905     {
2906         require(
2907             address(_kyberNetworkProxy) != address(0),
2908             "KyberNetworkProxy address cannot be 0"
2909         );
2910 
2911         kyberNetworkProxy = _kyberNetworkProxy;
2912         emit KyberNetworkProxyUpdated(kyberNetworkProxy);
2913         return true;
2914     }
2915 
2916     event AmountDepositedToDx(
2917         address indexed token,
2918         uint amount
2919     );
2920 
2921     function depositToDx(
2922         address token,
2923         uint amount
2924     )
2925         public
2926         onlyOperator
2927         returns (uint)
2928     {
2929         require(ERC20(token).approve(address(dx), amount), "Cannot approve deposit");
2930         uint deposited = dx.deposit(token, amount);
2931         emit AmountDepositedToDx(token, deposited);
2932         return deposited;
2933     }
2934 
2935     event AmountWithdrawnFromDx(
2936         address indexed token,
2937         uint amount
2938     );
2939 
2940     function withdrawFromDx(
2941         address token,
2942         uint amount
2943     )
2944         public
2945         onlyOperator
2946         returns (uint)
2947     {
2948         uint withdrawn = dx.withdraw(token, amount);
2949         emit AmountWithdrawnFromDx(token, withdrawn);
2950         return withdrawn;
2951     }
2952 
2953     /**
2954       Claims funds from a specific auction.
2955 
2956       sellerFunds - the amount in token wei of *buyToken* that was returned.
2957       buyerFunds - the amount in token wei of *sellToken* that was returned.
2958       */
2959     function claimSpecificAuctionFunds(
2960         address sellToken,
2961         address buyToken,
2962         uint auctionIndex
2963     )
2964         public
2965         returns (uint sellerFunds, uint buyerFunds)
2966     {
2967         uint availableFunds;
2968         availableFunds = dx.sellerBalances(
2969             sellToken,
2970             buyToken,
2971             auctionIndex,
2972             address(this)
2973         );
2974         if (availableFunds > 0) {
2975             (sellerFunds, ) = dx.claimSellerFunds(
2976                 sellToken,
2977                 buyToken,
2978                 address(this),
2979                 auctionIndex
2980             );
2981         }
2982 
2983         availableFunds = dx.buyerBalances(
2984             sellToken,
2985             buyToken,
2986             auctionIndex,
2987             address(this)
2988         );
2989         if (availableFunds > 0) {
2990             (buyerFunds, ) = dx.claimBuyerFunds(
2991                 sellToken,
2992                 buyToken,
2993                 address(this),
2994                 auctionIndex
2995             );
2996         }
2997     }
2998 
2999     /**
3000         Participates in the auction by taking the appropriate step according to
3001         the auction state.
3002 
3003         Returns true if there is a step to be taken in this auction at this
3004         stage, false otherwise.
3005     */
3006     // TODO: consider removing onlyOperator limitation
3007     function step(
3008         address sellToken,
3009         address buyToken
3010     )
3011         public
3012         onlyOperator
3013         returns (bool)
3014     {
3015         // KyberNetworkProxy.getExpectedRate() always returns a rate between
3016         // tokens (and not between token wei as DutchX does).
3017         // For this reason the rate is currently compatible only for tokens that
3018         // have 18 decimals and is handled as though it is rate / 10**18.
3019         // TODO: handle tokens with number of decimals other than 18.
3020         require(
3021             ERC20(sellToken).decimals() == 18 && ERC20(buyToken).decimals() == 18,
3022             "Only 18 decimals tokens are supported"
3023         );
3024 
3025         // Deposit dxmm token balance to DutchX.
3026         depositAllBalance(sellToken);
3027         depositAllBalance(buyToken);
3028 
3029         AuctionState state = getAuctionState(sellToken, buyToken);
3030         uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
3031         emit CurrentAuctionState(sellToken, buyToken, auctionIndex, state);
3032 
3033         if (state == AuctionState.WAITING_FOR_FUNDING) {
3034             // Update the dutchX balance with the funds from the previous auction.
3035             claimSpecificAuctionFunds(
3036                 sellToken,
3037                 buyToken,
3038                 lastParticipatedAuction[sellToken][buyToken]
3039             );
3040             require(fundAuctionDirection(sellToken, buyToken));
3041             return true;
3042         }
3043 
3044         if (state == AuctionState.WAITING_FOR_OPP_FUNDING ||
3045             state == AuctionState.WAITING_FOR_SCHEDULED_AUCTION) {
3046             return false;
3047         }
3048 
3049         if (state == AuctionState.AUCTION_IN_PROGRESS) {
3050             if (isPriceRightForBuying(sellToken, buyToken, auctionIndex)) {
3051                 return buyInAuction(sellToken, buyToken);
3052             }
3053             return false;
3054         }
3055 
3056         if (state == AuctionState.WAITING_FOR_OPP_TO_FINISH) {
3057             return false;
3058         }
3059 
3060         if (state == AuctionState.AUCTION_EXPIRED) {
3061             dx.closeTheoreticalClosedAuction(sellToken, buyToken, auctionIndex);
3062             dx.closeTheoreticalClosedAuction(buyToken, sellToken, auctionIndex);
3063             return true;
3064         }
3065 
3066         // Should be unreachable.
3067         revert("Unknown auction state");
3068     }
3069 
3070     function willAmountClearAuction(
3071         address sellToken,
3072         address buyToken,
3073         uint auctionIndex,
3074         uint amount
3075     )
3076         public
3077         view
3078         returns (bool)
3079     {
3080         uint buyVolume = dx.buyVolumes(sellToken, buyToken);
3081 
3082         // Overbuy is when a part of a buy order clears an auction
3083         // In that case we only process the part before the overbuy
3084         // To calculate overbuy, we first get current price
3085         uint sellVolume = dx.sellVolumesCurrent(sellToken, buyToken);
3086 
3087         uint num;
3088         uint den;
3089         (num, den) = dx.getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
3090         // 10^30 * 10^37 = 10^67
3091         uint outstandingVolume = atleastZero(int(div(mul(sellVolume, num), sub(den, buyVolume))));
3092         return amount >= outstandingVolume;
3093     }
3094 
3095     // TODO: consider adding a "safety margin" to compensate for accuracy issues.
3096     function thresholdNewAuctionToken(
3097         address token
3098     )
3099         public
3100         view
3101         returns (uint)
3102     {
3103         uint priceTokenNum;
3104         uint priceTokenDen;
3105         (priceTokenNum, priceTokenDen) = dx.getPriceOfTokenInLastAuction(token);
3106 
3107         // TODO: maybe not add 1 if token is WETH
3108         // Rounding up to make sure we pass the threshold
3109         return 1 + div(
3110             // mul() takes care of overflows
3111             mul(
3112                 dx.thresholdNewAuction(),
3113                 priceTokenDen
3114             ),
3115             mul(
3116                 dx.ethUSDOracle().getUSDETHPrice(),
3117                 priceTokenNum
3118             )
3119         );
3120     }
3121 
3122     function calculateMissingTokenForAuctionStart(
3123         address sellToken,
3124         address buyToken
3125     )
3126         public
3127         view
3128         returns (uint)
3129     {
3130         uint currentAuctionSellVolume = dx.sellVolumesCurrent(sellToken, buyToken);
3131         uint thresholdTokenWei = thresholdNewAuctionToken(sellToken);
3132 
3133         if (thresholdTokenWei > currentAuctionSellVolume) {
3134             return sub(thresholdTokenWei, currentAuctionSellVolume);
3135         }
3136 
3137         return 0;
3138     }
3139 
3140     function addFee(
3141         uint amount
3142     )
3143         public
3144         view
3145         returns (uint)
3146     {
3147         uint num;
3148         uint den;
3149         (num, den) = dx.getFeeRatio(msg.sender);
3150 
3151         // amount / (1 - num / den)
3152         return div(
3153             mul(amount, den),
3154             sub(den, num)
3155         );
3156     }
3157 
3158     function getAuctionState(
3159         address sellToken,
3160         address buyToken
3161     )
3162         public
3163         view
3164         returns (AuctionState)
3165     {
3166 
3167         // Unfunded auctions have an auctionStart time equal to a constant (1)
3168         uint auctionStart = dx.getAuctionStart(sellToken, buyToken);
3169         if (auctionStart == DX_AUCTION_START_WAITING_FOR_FUNDING) {
3170             // Other side might also be not fully funded, but we're primarily
3171             // interested in this direction.
3172             if (calculateMissingTokenForAuctionStart(sellToken, buyToken) > 0) {
3173                 return AuctionState.WAITING_FOR_FUNDING;
3174             } else {
3175                 return AuctionState.WAITING_FOR_OPP_FUNDING;
3176             }
3177         }
3178 
3179         // DutchExchange logic uses auction start time.
3180         /* solhint-disable-next-line not-rely-on-time */
3181         if (auctionStart > now) {
3182             // After 24 hours have passed since last auction closed,
3183             // DutchExchange will trigger a new auction even if only the
3184             // opposite side is funded.
3185             // In these cases we want this side to be funded as well.
3186             if (calculateMissingTokenForAuctionStart(sellToken, buyToken) > 0) {
3187                 return AuctionState.WAITING_FOR_FUNDING;
3188             } else {
3189                 return AuctionState.WAITING_FOR_SCHEDULED_AUCTION;
3190             }
3191         }
3192 
3193         // If over 24 hours have passed, the auction is no longer viable and
3194         // should be closed.
3195         /* solhint-disable-next-line not-rely-on-time */
3196         if (now - auctionStart > 24 hours) {
3197             return AuctionState.AUCTION_EXPIRED;
3198         }
3199 
3200         uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
3201         uint closingPriceDen;
3202         (, closingPriceDen) = dx.closingPrices(sellToken, buyToken, auctionIndex);
3203         if (closingPriceDen == 0) {
3204             return AuctionState.AUCTION_IN_PROGRESS;
3205         }
3206 
3207         return AuctionState.WAITING_FOR_OPP_TO_FINISH;
3208     }
3209 
3210     function getKyberRate(
3211         address _sellToken,
3212         address _buyToken,
3213         uint amount
3214     )
3215         public
3216         view
3217         returns (uint num, uint den)
3218     {
3219         // KyberNetworkProxy.getExpectedRate() always returns a rate between
3220         // tokens (and not between token wei as DutchX does.
3221         // For this reason the rate is currently compatible only for tokens that
3222         // have 18 decimals and is handled as though it is rate / 10**18.
3223         // TODO: handle tokens with number of decimals other than 18.
3224         require(
3225             ERC20(_sellToken).decimals() == 18 && ERC20(_buyToken).decimals() == 18,
3226             "Only 18 decimals tokens are supported"
3227         );
3228 
3229         // Kyber uses a special constant address for representing ETH.
3230         ERC20 sellToken = _sellToken == address(weth) ? KYBER_ETH_TOKEN : ERC20(_sellToken);
3231         ERC20 buyToken = _buyToken == address(weth) ? KYBER_ETH_TOKEN : ERC20(_buyToken);
3232         uint rate;
3233         (rate, ) = kyberNetworkProxy.getExpectedRate(
3234             sellToken,
3235             buyToken,
3236             amount
3237         );
3238 
3239         return (rate, 10 ** 18);
3240     }
3241 
3242     function tokensSoldInCurrentAuction(
3243         address sellToken,
3244         address buyToken,
3245         uint auctionIndex,
3246         address account
3247     )
3248         public
3249         view
3250         returns (uint)
3251     {
3252         return dx.sellerBalances(sellToken, buyToken, auctionIndex, account);
3253     }
3254 
3255     // The amount of tokens that matches the amount sold by provided account in
3256     // specified auction index, deducting the amount that was already bought.
3257     function calculateAuctionBuyTokens(
3258         address sellToken,
3259         address buyToken,
3260         uint auctionIndex,
3261         address account
3262     )
3263         public
3264         view
3265         returns (uint)
3266     {
3267         uint sellVolume = tokensSoldInCurrentAuction(
3268             sellToken,
3269             buyToken,
3270             auctionIndex,
3271             account
3272         );
3273 
3274         uint num;
3275         uint den;
3276         (num, den) = dx.getCurrentAuctionPrice(
3277             sellToken,
3278             buyToken,
3279             auctionIndex
3280         );
3281 
3282         // No price for this auction, it is a future one.
3283         if (den == 0) return 0;
3284 
3285         uint wantedBuyVolume = div(mul(sellVolume, num), den);
3286 
3287         uint auctionSellVolume = dx.sellVolumesCurrent(sellToken, buyToken);
3288         uint buyVolume = dx.buyVolumes(sellToken, buyToken);
3289         uint outstandingBuyVolume = atleastZero(
3290             int(mul(auctionSellVolume, num) / den - buyVolume)
3291         );
3292 
3293         return wantedBuyVolume < outstandingBuyVolume
3294             ? wantedBuyVolume
3295             : outstandingBuyVolume;
3296     }
3297 
3298     function atleastZero(int a)
3299         public
3300         pure
3301         returns (uint)
3302     {
3303         if (a < 0) {
3304             return 0;
3305         } else {
3306             return uint(a);
3307         }
3308     }
3309 
3310     event AuctionDirectionFunded(
3311         address indexed sellToken,
3312         address indexed buyToken,
3313         uint indexed auctionIndex,
3314         uint sellTokenAmount,
3315         uint sellTokenAmountWithFee
3316     );
3317 
3318     function fundAuctionDirection(
3319         address sellToken,
3320         address buyToken
3321     )
3322         internal
3323         returns (bool)
3324     {
3325         uint missingTokens = calculateMissingTokenForAuctionStart(
3326             sellToken,
3327             buyToken
3328         );
3329         uint missingTokensWithFee = addFee(missingTokens);
3330         if (missingTokensWithFee == 0) return false;
3331 
3332         uint balance = dx.balances(sellToken, address(this));
3333         require(
3334             balance >= missingTokensWithFee,
3335             "Not enough tokens to fund auction direction"
3336         );
3337 
3338         uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
3339         dx.postSellOrder(sellToken, buyToken, auctionIndex, missingTokensWithFee);
3340         lastParticipatedAuction[sellToken][buyToken] = auctionIndex;
3341 
3342         emit AuctionDirectionFunded(
3343             sellToken,
3344             buyToken,
3345             auctionIndex,
3346             missingTokens,
3347             missingTokensWithFee
3348         );
3349         return true;
3350     }
3351 
3352     // TODO: check for all the requirements of dutchx
3353     event BoughtInAuction(
3354         address indexed sellToken,
3355         address indexed buyToken,
3356         uint auctionIndex,
3357         uint buyTokenAmount,
3358         bool clearedAuction
3359     );
3360 
3361     /**
3362         Will calculate the amount that the bot has sold in current auction and
3363         buy that amount.
3364 
3365         Returns false if ended up not buying.
3366         Reverts if no auction active or not enough tokens for buying.
3367     */
3368     function buyInAuction(
3369         address sellToken,
3370         address buyToken
3371     )
3372         internal
3373         returns (bool bought)
3374     {
3375         require(
3376             getAuctionState(sellToken, buyToken) == AuctionState.AUCTION_IN_PROGRESS,
3377             "No auction in progress"
3378         );
3379 
3380         uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
3381         uint buyTokenAmount = calculateAuctionBuyTokens(
3382             sellToken,
3383             buyToken,
3384             auctionIndex,
3385             address(this)
3386         );
3387 
3388         if (buyTokenAmount == 0) {
3389             return false;
3390         }
3391 
3392         bool willClearAuction = willAmountClearAuction(
3393             sellToken,
3394             buyToken,
3395             auctionIndex,
3396             buyTokenAmount
3397         );
3398         if (!willClearAuction) {
3399             buyTokenAmount = addFee(buyTokenAmount);
3400         }
3401 
3402         require(
3403             dx.balances(buyToken, address(this)) >= buyTokenAmount,
3404             "Not enough buy token to buy required amount"
3405         );
3406 
3407         dx.postBuyOrder(sellToken, buyToken, auctionIndex, buyTokenAmount);
3408         emit BoughtInAuction(
3409             sellToken,
3410             buyToken,
3411             auctionIndex,
3412             buyTokenAmount,
3413             willClearAuction
3414         );
3415         return true;
3416     }
3417 
3418     function depositAllBalance(
3419         address token
3420     )
3421         internal
3422         returns (uint)
3423     {
3424         uint amount;
3425         uint balance = ERC20(token).balanceOf(address(this));
3426         if (balance > 0) {
3427             amount = depositToDx(token, balance);
3428         }
3429         return amount;
3430     }
3431 
3432     event CurrentAuctionState(
3433         address indexed sellToken,
3434         address indexed buyToken,
3435         uint auctionIndex,
3436         AuctionState auctionState
3437     );
3438 
3439     event PriceIsRightForBuying(
3440         address indexed sellToken,
3441         address indexed buyToken,
3442         uint auctionIndex,
3443         uint amount,
3444         uint dutchExchangePriceNum,
3445         uint dutchExchangePriceDen,
3446         uint kyberPriceNum,
3447         uint kyberPriceDen
3448     );
3449 
3450     function isPriceRightForBuying(
3451         address sellToken,
3452         address buyToken,
3453         uint auctionIndex
3454     )
3455         internal
3456         returns (bool)
3457     {
3458         uint amount = calculateAuctionBuyTokens(
3459             sellToken,
3460             buyToken,
3461             auctionIndex,
3462             address(this)
3463         );
3464 
3465         uint dNum;
3466         uint dDen;
3467         (dNum, dDen) = dx.getCurrentAuctionPrice(
3468             sellToken,
3469             buyToken,
3470             auctionIndex
3471         );
3472 
3473         uint kNum;
3474         uint kDen;
3475         (kNum, kDen) = getKyberRate(sellToken, buyToken, amount);
3476 
3477         // TODO: Check for overflow explicitly?
3478         bool shouldBuy = mul(dNum, kDen) <= mul(kNum, dDen);
3479         // TODO: should we add a boolean for shouldBuy?
3480         emit PriceIsRightForBuying(
3481             sellToken,
3482             buyToken,
3483             auctionIndex,
3484             amount,
3485             dNum,
3486             dDen,
3487             kNum,
3488             kDen
3489         );
3490         return shouldBuy;
3491     }
3492 
3493     // --- Safe Math functions ---
3494     // (https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol)
3495     /**
3496     * @dev Multiplies two numbers, reverts on overflow.
3497     */
3498     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3499         // Gas optimization: this is cheaper than requiring 'a' not being zero,
3500         // but the benefit is lost if 'b' is also tested.
3501         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
3502         if (a == 0) {
3503             return 0;
3504         }
3505 
3506         uint256 c = a * b;
3507         require(c / a == b);
3508 
3509         return c;
3510     }
3511 
3512     /**
3513     * @dev Integer division of two numbers truncating the quotient, reverts on
3514         division by zero.
3515     */
3516     function div(uint256 a, uint256 b) internal pure returns (uint256) {
3517         // Solidity only automatically asserts when dividing by 0
3518         require(b > 0);
3519         uint256 c = a / b;
3520         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
3521 
3522         return c;
3523     }
3524 
3525     /**
3526     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if
3527         subtrahend is greater than minuend).
3528     */
3529     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
3530         require(b <= a);
3531         uint256 c = a - b;
3532 
3533         return c;
3534     }
3535 }