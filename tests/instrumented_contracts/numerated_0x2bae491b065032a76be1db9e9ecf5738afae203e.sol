1 pragma solidity ^0.5.2;
2 
3 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
4 
5 /// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
6 /// @author Alan Lu - <alan@gnosis.pm>
7 contract Proxied {
8     address public masterCopy;
9 }
10 
11 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
12 /// @author Stefan George - <stefan@gnosis.pm>
13 contract Proxy is Proxied {
14     /// @dev Constructor function sets address of master copy contract.
15     /// @param _masterCopy Master copy address.
16     constructor(address _masterCopy) public {
17         require(_masterCopy != address(0), "The master copy is required");
18         masterCopy = _masterCopy;
19     }
20 
21     /// @dev Fallback function forwards all transactions and returns all received return data.
22     function() external payable {
23         address _masterCopy = masterCopy;
24         assembly {
25             calldatacopy(0, 0, calldatasize)
26             let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
27             returndatacopy(0, 0, returndatasize)
28             switch success
29                 case 0 {
30                     revert(0, returndatasize)
31                 }
32                 default {
33                     return(0, returndatasize)
34                 }
35         }
36     }
37 }
38 
39 // File: @gnosis.pm/util-contracts/contracts/Token.sol
40 
41 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
42 pragma solidity ^0.5.2;
43 
44 /// @title Abstract token contract - Functions to be implemented by token contracts
45 contract Token {
46     /*
47      *  Events
48      */
49     event Transfer(address indexed from, address indexed to, uint value);
50     event Approval(address indexed owner, address indexed spender, uint value);
51 
52     /*
53      *  Public functions
54      */
55     function transfer(address to, uint value) public returns (bool);
56     function transferFrom(address from, address to, uint value) public returns (bool);
57     function approve(address spender, uint value) public returns (bool);
58     function balanceOf(address owner) public view returns (uint);
59     function allowance(address owner, address spender) public view returns (uint);
60     function totalSupply() public view returns (uint);
61 }
62 
63 // File: @gnosis.pm/util-contracts/contracts/Math.sol
64 
65 /// @title Math library - Allows calculation of logarithmic and exponential functions
66 /// @author Alan Lu - <alan.lu@gnosis.pm>
67 /// @author Stefan George - <stefan@gnosis.pm>
68 library GnosisMath {
69     /*
70      *  Constants
71      */
72     // This is equal to 1 in our calculations
73     uint public constant ONE = 0x10000000000000000;
74     uint public constant LN2 = 0xb17217f7d1cf79ac;
75     uint public constant LOG2_E = 0x171547652b82fe177;
76 
77     /*
78      *  Public functions
79      */
80     /// @dev Returns natural exponential function value of given x
81     /// @param x x
82     /// @return e**x
83     function exp(int x) public pure returns (uint) {
84         // revert if x is > MAX_POWER, where
85         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
86         require(x <= 2454971259878909886679);
87         // return 0 if exp(x) is tiny, using
88         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
89         if (x < -818323753292969962227) return 0;
90         // Transform so that e^x -> 2^x
91         x = x * int(ONE) / int(LN2);
92         // 2^x = 2^whole(x) * 2^frac(x)
93         //       ^^^^^^^^^^ is a bit shift
94         // so Taylor expand on z = frac(x)
95         int shift;
96         uint z;
97         if (x >= 0) {
98             shift = x / int(ONE);
99             z = uint(x % int(ONE));
100         } else {
101             shift = x / int(ONE) - 1;
102             z = ONE - uint(-x % int(ONE));
103         }
104         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
105         //
106         // Can generate the z coefficients using mpmath and the following lines
107         // >>> from mpmath import mp
108         // >>> mp.dps = 100
109         // >>> ONE =  0x10000000000000000
110         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
111         // 0xb17217f7d1cf79ab
112         // 0x3d7f7bff058b1d50
113         // 0xe35846b82505fc5
114         // 0x276556df749cee5
115         // 0x5761ff9e299cc4
116         // 0xa184897c363c3
117         uint zpow = z;
118         uint result = ONE;
119         result += 0xb17217f7d1cf79ab * zpow / ONE;
120         zpow = zpow * z / ONE;
121         result += 0x3d7f7bff058b1d50 * zpow / ONE;
122         zpow = zpow * z / ONE;
123         result += 0xe35846b82505fc5 * zpow / ONE;
124         zpow = zpow * z / ONE;
125         result += 0x276556df749cee5 * zpow / ONE;
126         zpow = zpow * z / ONE;
127         result += 0x5761ff9e299cc4 * zpow / ONE;
128         zpow = zpow * z / ONE;
129         result += 0xa184897c363c3 * zpow / ONE;
130         zpow = zpow * z / ONE;
131         result += 0xffe5fe2c4586 * zpow / ONE;
132         zpow = zpow * z / ONE;
133         result += 0x162c0223a5c8 * zpow / ONE;
134         zpow = zpow * z / ONE;
135         result += 0x1b5253d395e * zpow / ONE;
136         zpow = zpow * z / ONE;
137         result += 0x1e4cf5158b * zpow / ONE;
138         zpow = zpow * z / ONE;
139         result += 0x1e8cac735 * zpow / ONE;
140         zpow = zpow * z / ONE;
141         result += 0x1c3bd650 * zpow / ONE;
142         zpow = zpow * z / ONE;
143         result += 0x1816193 * zpow / ONE;
144         zpow = zpow * z / ONE;
145         result += 0x131496 * zpow / ONE;
146         zpow = zpow * z / ONE;
147         result += 0xe1b7 * zpow / ONE;
148         zpow = zpow * z / ONE;
149         result += 0x9c7 * zpow / ONE;
150         if (shift >= 0) {
151             if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
152             return result << shift;
153         } else return result >> (-shift);
154     }
155 
156     /// @dev Returns natural logarithm value of given x
157     /// @param x x
158     /// @return ln(x)
159     function ln(uint x) public pure returns (int) {
160         require(x > 0);
161         // binary search for floor(log2(x))
162         int ilog2 = floorLog2(x);
163         int z;
164         if (ilog2 < 0) z = int(x << uint(-ilog2));
165         else z = int(x >> uint(ilog2));
166         // z = x * 2^-⌊log₂x⌋
167         // so 1 <= z < 2
168         // and ln z = ln x - ⌊log₂x⌋/log₂e
169         // so just compute ln z using artanh series
170         // and calculate ln x from that
171         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
172         int halflnz = term;
173         int termpow = term * term / int(ONE) * term / int(ONE);
174         halflnz += termpow / 3;
175         termpow = termpow * term / int(ONE) * term / int(ONE);
176         halflnz += termpow / 5;
177         termpow = termpow * term / int(ONE) * term / int(ONE);
178         halflnz += termpow / 7;
179         termpow = termpow * term / int(ONE) * term / int(ONE);
180         halflnz += termpow / 9;
181         termpow = termpow * term / int(ONE) * term / int(ONE);
182         halflnz += termpow / 11;
183         termpow = termpow * term / int(ONE) * term / int(ONE);
184         halflnz += termpow / 13;
185         termpow = termpow * term / int(ONE) * term / int(ONE);
186         halflnz += termpow / 15;
187         termpow = termpow * term / int(ONE) * term / int(ONE);
188         halflnz += termpow / 17;
189         termpow = termpow * term / int(ONE) * term / int(ONE);
190         halflnz += termpow / 19;
191         termpow = termpow * term / int(ONE) * term / int(ONE);
192         halflnz += termpow / 21;
193         termpow = termpow * term / int(ONE) * term / int(ONE);
194         halflnz += termpow / 23;
195         termpow = termpow * term / int(ONE) * term / int(ONE);
196         halflnz += termpow / 25;
197         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
198     }
199 
200     /// @dev Returns base 2 logarithm value of given x
201     /// @param x x
202     /// @return logarithmic value
203     function floorLog2(uint x) public pure returns (int lo) {
204         lo = -64;
205         int hi = 193;
206         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
207         int mid = (hi + lo) >> 1;
208         while ((lo + 1) < hi) {
209             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
210             else lo = mid;
211             mid = (hi + lo) >> 1;
212         }
213     }
214 
215     /// @dev Returns maximum of an array
216     /// @param nums Numbers to look through
217     /// @return Maximum number
218     function max(int[] memory nums) public pure returns (int maxNum) {
219         require(nums.length > 0);
220         maxNum = -2 ** 255;
221         for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
222     }
223 
224     /// @dev Returns whether an add operation causes an overflow
225     /// @param a First addend
226     /// @param b Second addend
227     /// @return Did no overflow occur?
228     function safeToAdd(uint a, uint b) internal pure returns (bool) {
229         return a + b >= a;
230     }
231 
232     /// @dev Returns whether a subtraction operation causes an underflow
233     /// @param a Minuend
234     /// @param b Subtrahend
235     /// @return Did no underflow occur?
236     function safeToSub(uint a, uint b) internal pure returns (bool) {
237         return a >= b;
238     }
239 
240     /// @dev Returns whether a multiply operation causes an overflow
241     /// @param a First factor
242     /// @param b Second factor
243     /// @return Did no overflow occur?
244     function safeToMul(uint a, uint b) internal pure returns (bool) {
245         return b == 0 || a * b / b == a;
246     }
247 
248     /// @dev Returns sum if no overflow occurred
249     /// @param a First addend
250     /// @param b Second addend
251     /// @return Sum
252     function add(uint a, uint b) internal pure returns (uint) {
253         require(safeToAdd(a, b));
254         return a + b;
255     }
256 
257     /// @dev Returns difference if no overflow occurred
258     /// @param a Minuend
259     /// @param b Subtrahend
260     /// @return Difference
261     function sub(uint a, uint b) internal pure returns (uint) {
262         require(safeToSub(a, b));
263         return a - b;
264     }
265 
266     /// @dev Returns product if no overflow occurred
267     /// @param a First factor
268     /// @param b Second factor
269     /// @return Product
270     function mul(uint a, uint b) internal pure returns (uint) {
271         require(safeToMul(a, b));
272         return a * b;
273     }
274 
275     /// @dev Returns whether an add operation causes an overflow
276     /// @param a First addend
277     /// @param b Second addend
278     /// @return Did no overflow occur?
279     function safeToAdd(int a, int b) internal pure returns (bool) {
280         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
281     }
282 
283     /// @dev Returns whether a subtraction operation causes an underflow
284     /// @param a Minuend
285     /// @param b Subtrahend
286     /// @return Did no underflow occur?
287     function safeToSub(int a, int b) internal pure returns (bool) {
288         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
289     }
290 
291     /// @dev Returns whether a multiply operation causes an overflow
292     /// @param a First factor
293     /// @param b Second factor
294     /// @return Did no overflow occur?
295     function safeToMul(int a, int b) internal pure returns (bool) {
296         return (b == 0) || (a * b / b == a);
297     }
298 
299     /// @dev Returns sum if no overflow occurred
300     /// @param a First addend
301     /// @param b Second addend
302     /// @return Sum
303     function add(int a, int b) internal pure returns (int) {
304         require(safeToAdd(a, b));
305         return a + b;
306     }
307 
308     /// @dev Returns difference if no overflow occurred
309     /// @param a Minuend
310     /// @param b Subtrahend
311     /// @return Difference
312     function sub(int a, int b) internal pure returns (int) {
313         require(safeToSub(a, b));
314         return a - b;
315     }
316 
317     /// @dev Returns product if no overflow occurred
318     /// @param a First factor
319     /// @param b Second factor
320     /// @return Product
321     function mul(int a, int b) internal pure returns (int) {
322         require(safeToMul(a, b));
323         return a * b;
324     }
325 }
326 
327 // File: @gnosis.pm/util-contracts/contracts/GnosisStandardToken.sol
328 
329 /**
330  * Deprecated: Use Open Zeppeling one instead
331  */
332 contract StandardTokenData {
333     /*
334      *  Storage
335      */
336     mapping(address => uint) balances;
337     mapping(address => mapping(address => uint)) allowances;
338     uint totalTokens;
339 }
340 
341 /**
342  * Deprecated: Use Open Zeppeling one instead
343  */
344 /// @title Standard token contract with overflow protection
345 contract GnosisStandardToken is Token, StandardTokenData {
346     using GnosisMath for *;
347 
348     /*
349      *  Public functions
350      */
351     /// @dev Transfers sender's tokens to a given address. Returns success
352     /// @param to Address of token receiver
353     /// @param value Number of tokens to transfer
354     /// @return Was transfer successful?
355     function transfer(address to, uint value) public returns (bool) {
356         if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
357             return false;
358         }
359 
360         balances[msg.sender] -= value;
361         balances[to] += value;
362         emit Transfer(msg.sender, to, value);
363         return true;
364     }
365 
366     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
367     /// @param from Address from where tokens are withdrawn
368     /// @param to Address to where tokens are sent
369     /// @param value Number of tokens to transfer
370     /// @return Was transfer successful?
371     function transferFrom(address from, address to, uint value) public returns (bool) {
372         if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
373             value
374         ) || !balances[to].safeToAdd(value)) {
375             return false;
376         }
377         balances[from] -= value;
378         allowances[from][msg.sender] -= value;
379         balances[to] += value;
380         emit Transfer(from, to, value);
381         return true;
382     }
383 
384     /// @dev Sets approved amount of tokens for spender. Returns success
385     /// @param spender Address of allowed account
386     /// @param value Number of approved tokens
387     /// @return Was approval successful?
388     function approve(address spender, uint value) public returns (bool) {
389         allowances[msg.sender][spender] = value;
390         emit Approval(msg.sender, spender, value);
391         return true;
392     }
393 
394     /// @dev Returns number of allowed tokens for given address
395     /// @param owner Address of token owner
396     /// @param spender Address of token spender
397     /// @return Remaining allowance for spender
398     function allowance(address owner, address spender) public view returns (uint) {
399         return allowances[owner][spender];
400     }
401 
402     /// @dev Returns number of tokens owned by given address
403     /// @param owner Address of token owner
404     /// @return Balance of owner
405     function balanceOf(address owner) public view returns (uint) {
406         return balances[owner];
407     }
408 
409     /// @dev Returns total supply of tokens
410     /// @return Total supply
411     function totalSupply() public view returns (uint) {
412         return totalTokens;
413     }
414 }
415 
416 // File: contracts/TokenFRT.sol
417 
418 /// @title Standard token contract with overflow protection
419 contract TokenFRT is Proxied, GnosisStandardToken {
420     address public owner;
421 
422     string public constant symbol = "MGN";
423     string public constant name = "Magnolia Token";
424     uint8 public constant decimals = 18;
425 
426     struct UnlockedToken {
427         uint amountUnlocked;
428         uint withdrawalTime;
429     }
430 
431     /*
432      *  Storage
433      */
434     address public minter;
435 
436     // user => UnlockedToken
437     mapping(address => UnlockedToken) public unlockedTokens;
438 
439     // user => amount
440     mapping(address => uint) public lockedTokenBalances;
441 
442     /*
443      *  Public functions
444      */
445 
446     // @dev allows to set the minter of Magnolia tokens once.
447     // @param   _minter the minter of the Magnolia tokens, should be the DX-proxy
448     function updateMinter(address _minter) public {
449         require(msg.sender == owner, "Only the minter can set a new one");
450         require(_minter != address(0), "The new minter must be a valid address");
451 
452         minter = _minter;
453     }
454 
455     // @dev the intention is to set the owner as the DX-proxy, once it is deployed
456     // Then only an update of the DX-proxy contract after a 30 days delay could change the minter again.
457     function updateOwner(address _owner) public {
458         require(msg.sender == owner, "Only the owner can update the owner");
459         require(_owner != address(0), "The new owner must be a valid address");
460         owner = _owner;
461     }
462 
463     function mintTokens(address user, uint amount) public {
464         require(msg.sender == minter, "Only the minter can mint tokens");
465 
466         lockedTokenBalances[user] = add(lockedTokenBalances[user], amount);
467         totalTokens = add(totalTokens, amount);
468     }
469 
470     /// @dev Lock Token
471     function lockTokens(uint amount) public returns (uint totalAmountLocked) {
472         // Adjust amount by balance
473         uint actualAmount = min(amount, balances[msg.sender]);
474 
475         // Update state variables
476         balances[msg.sender] = sub(balances[msg.sender], actualAmount);
477         lockedTokenBalances[msg.sender] = add(lockedTokenBalances[msg.sender], actualAmount);
478 
479         // Get return variable
480         totalAmountLocked = lockedTokenBalances[msg.sender];
481     }
482 
483     function unlockTokens() public returns (uint totalAmountUnlocked, uint withdrawalTime) {
484         // Adjust amount by locked balances
485         uint amount = lockedTokenBalances[msg.sender];
486 
487         if (amount > 0) {
488             // Update state variables
489             lockedTokenBalances[msg.sender] = sub(lockedTokenBalances[msg.sender], amount);
490             unlockedTokens[msg.sender].amountUnlocked = add(unlockedTokens[msg.sender].amountUnlocked, amount);
491             unlockedTokens[msg.sender].withdrawalTime = now + 24 hours;
492         }
493 
494         // Get return variables
495         totalAmountUnlocked = unlockedTokens[msg.sender].amountUnlocked;
496         withdrawalTime = unlockedTokens[msg.sender].withdrawalTime;
497     }
498 
499     function withdrawUnlockedTokens() public {
500         require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
501         balances[msg.sender] = add(balances[msg.sender], unlockedTokens[msg.sender].amountUnlocked);
502         unlockedTokens[msg.sender].amountUnlocked = 0;
503     }
504 
505     function min(uint a, uint b) public pure returns (uint) {
506         if (a < b) {
507             return a;
508         } else {
509             return b;
510         }
511     }
512     
513     /// @dev Returns whether an add operation causes an overflow
514     /// @param a First addend
515     /// @param b Second addend
516     /// @return Did no overflow occur?
517     function safeToAdd(uint a, uint b) public pure returns (bool) {
518         return a + b >= a;
519     }
520 
521     /// @dev Returns whether a subtraction operation causes an underflow
522     /// @param a Minuend
523     /// @param b Subtrahend
524     /// @return Did no underflow occur?
525     function safeToSub(uint a, uint b) public pure returns (bool) {
526         return a >= b;
527     }
528 
529     /// @dev Returns sum if no overflow occurred
530     /// @param a First addend
531     /// @param b Second addend
532     /// @return Sum
533     function add(uint a, uint b) public pure returns (uint) {
534         require(safeToAdd(a, b), "It must be a safe adition");
535         return a + b;
536     }
537 
538     /// @dev Returns difference if no overflow occurred
539     /// @param a Minuend
540     /// @param b Subtrahend
541     /// @return Difference
542     function sub(uint a, uint b) public pure returns (uint) {
543         require(safeToSub(a, b), "It must be a safe substraction");
544         return a - b;
545     }
546 }
547 
548 // File: @gnosis.pm/owl-token/contracts/TokenOWL.sol
549 
550 contract TokenOWL is Proxied, GnosisStandardToken {
551     using GnosisMath for *;
552 
553     string public constant name = "OWL Token";
554     string public constant symbol = "OWL";
555     uint8 public constant decimals = 18;
556 
557     struct masterCopyCountdownType {
558         address masterCopy;
559         uint timeWhenAvailable;
560     }
561 
562     masterCopyCountdownType masterCopyCountdown;
563 
564     address public creator;
565     address public minter;
566 
567     event Minted(address indexed to, uint256 amount);
568     event Burnt(address indexed from, address indexed user, uint256 amount);
569 
570     modifier onlyCreator() {
571         // R1
572         require(msg.sender == creator, "Only the creator can perform the transaction");
573         _;
574     }
575     /// @dev trickers the update process via the proxyMaster for a new address _masterCopy
576     /// updating is only possible after 30 days
577     function startMasterCopyCountdown(address _masterCopy) public onlyCreator {
578         require(address(_masterCopy) != address(0), "The master copy must be a valid address");
579 
580         // Update masterCopyCountdown
581         masterCopyCountdown.masterCopy = _masterCopy;
582         masterCopyCountdown.timeWhenAvailable = now + 30 days;
583     }
584 
585     /// @dev executes the update process via the proxyMaster for a new address _masterCopy
586     function updateMasterCopy() public onlyCreator {
587         require(address(masterCopyCountdown.masterCopy) != address(0), "The master copy must be a valid address");
588         require(
589             block.timestamp >= masterCopyCountdown.timeWhenAvailable,
590             "It's not possible to update the master copy during the waiting period"
591         );
592 
593         // Update masterCopy
594         masterCopy = masterCopyCountdown.masterCopy;
595     }
596 
597     function getMasterCopy() public view returns (address) {
598         return masterCopy;
599     }
600 
601     /// @dev Set minter. Only the creator of this contract can call this.
602     /// @param newMinter The new address authorized to mint this token
603     function setMinter(address newMinter) public onlyCreator {
604         minter = newMinter;
605     }
606 
607     /// @dev change owner/creator of the contract. Only the creator/owner of this contract can call this.
608     /// @param newOwner The new address, which should become the owner
609     function setNewOwner(address newOwner) public onlyCreator {
610         creator = newOwner;
611     }
612 
613     /// @dev Mints OWL.
614     /// @param to Address to which the minted token will be given
615     /// @param amount Amount of OWL to be minted
616     function mintOWL(address to, uint amount) public {
617         require(minter != address(0), "The minter must be initialized");
618         require(msg.sender == minter, "Only the minter can mint OWL");
619         balances[to] = balances[to].add(amount);
620         totalTokens = totalTokens.add(amount);
621         emit Minted(to, amount);
622     }
623 
624     /// @dev Burns OWL.
625     /// @param user Address of OWL owner
626     /// @param amount Amount of OWL to be burnt
627     function burnOWL(address user, uint amount) public {
628         allowances[user][msg.sender] = allowances[user][msg.sender].sub(amount);
629         balances[user] = balances[user].sub(amount);
630         totalTokens = totalTokens.sub(amount);
631         emit Burnt(msg.sender, user, amount);
632     }
633 }
634 
635 // File: contracts/base/SafeTransfer.sol
636 
637 interface BadToken {
638     function transfer(address to, uint value) external;
639     function transferFrom(address from, address to, uint value) external;
640 }
641 
642 contract SafeTransfer {
643     function safeTransfer(address token, address to, uint value, bool from) internal returns (bool result) {
644         if (from) {
645             BadToken(token).transferFrom(msg.sender, address(this), value);
646         } else {
647             BadToken(token).transfer(to, value);
648         }
649 
650         // solium-disable-next-line security/no-inline-assembly
651         assembly {
652             switch returndatasize
653                 case 0 {
654                     // This is our BadToken
655                     result := not(0) // result is true
656                 }
657                 case 32 {
658                     // This is our GoodToken
659                     returndatacopy(0, 0, 32)
660                     result := mload(0) // result == returndata of external call
661                 }
662                 default {
663                     // This is not an ERC20 token
664                     result := 0
665                 }
666         }
667         return result;
668     }
669 }
670 
671 // File: contracts/base/AuctioneerManaged.sol
672 
673 contract AuctioneerManaged {
674     // auctioneer has the power to manage some variables
675     address public auctioneer;
676 
677     function updateAuctioneer(address _auctioneer) public onlyAuctioneer {
678         require(_auctioneer != address(0), "The auctioneer must be a valid address");
679         auctioneer = _auctioneer;
680     }
681 
682     // > Modifiers
683     modifier onlyAuctioneer() {
684         // Only allows auctioneer to proceed
685         // R1
686         // require(msg.sender == auctioneer, "Only auctioneer can perform this operation");
687         require(msg.sender == auctioneer, "Only the auctioneer can nominate a new one");
688         _;
689     }
690 }
691 
692 // File: contracts/base/TokenWhitelist.sol
693 
694 contract TokenWhitelist is AuctioneerManaged {
695     // Mapping that stores the tokens, which are approved
696     // Only tokens approved by auctioneer generate frtToken tokens
697     // addressToken => boolApproved
698     mapping(address => bool) public approvedTokens;
699 
700     event Approval(address indexed token, bool approved);
701 
702     /// @dev for quick overview of approved Tokens
703     /// @param addressesToCheck are the ERC-20 token addresses to be checked whether they are approved
704     function getApprovedAddressesOfList(address[] calldata addressesToCheck) external view returns (bool[] memory) {
705         uint length = addressesToCheck.length;
706 
707         bool[] memory isApproved = new bool[](length);
708 
709         for (uint i = 0; i < length; i++) {
710             isApproved[i] = approvedTokens[addressesToCheck[i]];
711         }
712 
713         return isApproved;
714     }
715     
716     function updateApprovalOfToken(address[] memory token, bool approved) public onlyAuctioneer {
717         for (uint i = 0; i < token.length; i++) {
718             approvedTokens[token[i]] = approved;
719             emit Approval(token[i], approved);
720         }
721     }
722 
723 }
724 
725 // File: contracts/base/DxMath.sol
726 
727 contract DxMath {
728     // > Math fns
729     function min(uint a, uint b) public pure returns (uint) {
730         if (a < b) {
731             return a;
732         } else {
733             return b;
734         }
735     }
736 
737     function atleastZero(int a) public pure returns (uint) {
738         if (a < 0) {
739             return 0;
740         } else {
741             return uint(a);
742         }
743     }
744     
745     /// @dev Returns whether an add operation causes an overflow
746     /// @param a First addend
747     /// @param b Second addend
748     /// @return Did no overflow occur?
749     function safeToAdd(uint a, uint b) public pure returns (bool) {
750         return a + b >= a;
751     }
752 
753     /// @dev Returns whether a subtraction operation causes an underflow
754     /// @param a Minuend
755     /// @param b Subtrahend
756     /// @return Did no underflow occur?
757     function safeToSub(uint a, uint b) public pure returns (bool) {
758         return a >= b;
759     }
760 
761     /// @dev Returns whether a multiply operation causes an overflow
762     /// @param a First factor
763     /// @param b Second factor
764     /// @return Did no overflow occur?
765     function safeToMul(uint a, uint b) public pure returns (bool) {
766         return b == 0 || a * b / b == a;
767     }
768 
769     /// @dev Returns sum if no overflow occurred
770     /// @param a First addend
771     /// @param b Second addend
772     /// @return Sum
773     function add(uint a, uint b) public pure returns (uint) {
774         require(safeToAdd(a, b));
775         return a + b;
776     }
777 
778     /// @dev Returns difference if no overflow occurred
779     /// @param a Minuend
780     /// @param b Subtrahend
781     /// @return Difference
782     function sub(uint a, uint b) public pure returns (uint) {
783         require(safeToSub(a, b));
784         return a - b;
785     }
786 
787     /// @dev Returns product if no overflow occurred
788     /// @param a First factor
789     /// @param b Second factor
790     /// @return Product
791     function mul(uint a, uint b) public pure returns (uint) {
792         require(safeToMul(a, b));
793         return a * b;
794     }
795 }
796 
797 // File: contracts/Oracle/DSMath.sol
798 
799 contract DSMath {
800     /*
801     standard uint256 functions
802      */
803 
804     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
805         assert((z = x + y) >= x);
806     }
807 
808     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
809         assert((z = x - y) <= x);
810     }
811 
812     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
813         assert((z = x * y) >= x);
814     }
815 
816     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
817         z = x / y;
818     }
819 
820     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
821         return x <= y ? x : y;
822     }
823 
824     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
825         return x >= y ? x : y;
826     }
827 
828     /*
829     uint128 functions (h is for half)
830      */
831 
832     function hadd(uint128 x, uint128 y) internal pure returns (uint128 z) {
833         assert((z = x + y) >= x);
834     }
835 
836     function hsub(uint128 x, uint128 y) internal pure returns (uint128 z) {
837         assert((z = x - y) <= x);
838     }
839 
840     function hmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
841         assert((z = x * y) >= x);
842     }
843 
844     function hdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
845         z = x / y;
846     }
847 
848     function hmin(uint128 x, uint128 y) internal pure returns (uint128 z) {
849         return x <= y ? x : y;
850     }
851 
852     function hmax(uint128 x, uint128 y) internal pure returns (uint128 z) {
853         return x >= y ? x : y;
854     }
855 
856     /*
857     int256 functions
858      */
859 
860     function imin(int256 x, int256 y) internal pure returns (int256 z) {
861         return x <= y ? x : y;
862     }
863 
864     function imax(int256 x, int256 y) internal pure returns (int256 z) {
865         return x >= y ? x : y;
866     }
867 
868     /*
869     WAD math
870      */
871 
872     uint128 constant WAD = 10 ** 18;
873 
874     function wadd(uint128 x, uint128 y) internal pure returns (uint128) {
875         return hadd(x, y);
876     }
877 
878     function wsub(uint128 x, uint128 y) internal pure returns (uint128) {
879         return hsub(x, y);
880     }
881 
882     function wmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
883         z = cast((uint256(x) * y + WAD / 2) / WAD);
884     }
885 
886     function wdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
887         z = cast((uint256(x) * WAD + y / 2) / y);
888     }
889 
890     function wmin(uint128 x, uint128 y) internal pure returns (uint128) {
891         return hmin(x, y);
892     }
893 
894     function wmax(uint128 x, uint128 y) internal pure returns (uint128) {
895         return hmax(x, y);
896     }
897 
898     /*
899     RAY math
900      */
901 
902     uint128 constant RAY = 10 ** 27;
903 
904     function radd(uint128 x, uint128 y) internal pure returns (uint128) {
905         return hadd(x, y);
906     }
907 
908     function rsub(uint128 x, uint128 y) internal pure returns (uint128) {
909         return hsub(x, y);
910     }
911 
912     function rmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
913         z = cast((uint256(x) * y + RAY / 2) / RAY);
914     }
915 
916     function rdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
917         z = cast((uint256(x) * RAY + y / 2) / y);
918     }
919 
920     function rpow(uint128 x, uint64 n) internal pure returns (uint128 z) {
921         // This famous algorithm is called "exponentiation by squaring"
922         // and calculates x^n with x as fixed-point and n as regular unsigned.
923         //
924         // It's O(log n), instead of O(n) for naive repeated multiplication.
925         //
926         // These facts are why it works:
927         //
928         //  If n is even, then x^n = (x^2)^(n/2).
929         //  If n is odd,  then x^n = x * x^(n-1),
930         //   and applying the equation for even x gives
931         //    x^n = x * (x^2)^((n-1) / 2).
932         //
933         //  Also, EVM division is flooring and
934         //    floor[(n-1) / 2] = floor[n / 2].
935 
936         z = n % 2 != 0 ? x : RAY;
937 
938         for (n /= 2; n != 0; n /= 2) {
939             x = rmul(x, x);
940 
941             if (n % 2 != 0) {
942                 z = rmul(z, x);
943             }
944         }
945     }
946 
947     function rmin(uint128 x, uint128 y) internal pure returns (uint128) {
948         return hmin(x, y);
949     }
950 
951     function rmax(uint128 x, uint128 y) internal pure returns (uint128) {
952         return hmax(x, y);
953     }
954 
955     function cast(uint256 x) internal pure returns (uint128 z) {
956         assert((z = uint128(x)) == x);
957     }
958 
959 }
960 
961 // File: contracts/Oracle/DSAuth.sol
962 
963 contract DSAuthority {
964     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
965 }
966 
967 
968 contract DSAuthEvents {
969     event LogSetAuthority(address indexed authority);
970     event LogSetOwner(address indexed owner);
971 }
972 
973 
974 contract DSAuth is DSAuthEvents {
975     DSAuthority public authority;
976     address public owner;
977 
978     constructor() public {
979         owner = msg.sender;
980         emit LogSetOwner(msg.sender);
981     }
982 
983     function setOwner(address owner_) public auth {
984         owner = owner_;
985         emit LogSetOwner(owner);
986     }
987 
988     function setAuthority(DSAuthority authority_) public auth {
989         authority = authority_;
990         emit LogSetAuthority(address(authority));
991     }
992 
993     modifier auth {
994         require(isAuthorized(msg.sender, msg.sig), "It must be an authorized call");
995         _;
996     }
997 
998     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
999         if (src == address(this)) {
1000             return true;
1001         } else if (src == owner) {
1002             return true;
1003         } else if (authority == DSAuthority(0)) {
1004             return false;
1005         } else {
1006             return authority.canCall(src, address(this), sig);
1007         }
1008     }
1009 }
1010 
1011 // File: contracts/Oracle/DSNote.sol
1012 
1013 contract DSNote {
1014     event LogNote(
1015         bytes4 indexed sig,
1016         address indexed guy,
1017         bytes32 indexed foo,
1018         bytes32 bar,
1019         uint wad,
1020         bytes fax
1021     );
1022 
1023     modifier note {
1024         bytes32 foo;
1025         bytes32 bar;
1026         // solium-disable-next-line security/no-inline-assembly
1027         assembly {
1028             foo := calldataload(4)
1029             bar := calldataload(36)
1030         }
1031 
1032         emit LogNote(
1033             msg.sig,
1034             msg.sender,
1035             foo,
1036             bar,
1037             msg.value,
1038             msg.data
1039         );
1040 
1041         _;
1042     }
1043 }
1044 
1045 // File: contracts/Oracle/DSThing.sol
1046 
1047 contract DSThing is DSAuth, DSNote, DSMath {}
1048 
1049 // File: contracts/Oracle/PriceFeed.sol
1050 
1051 /// price-feed.sol
1052 
1053 // Copyright (C) 2017  DappHub, LLC
1054 
1055 // Licensed under the Apache License, Version 2.0 (the "License").
1056 // You may not use this file except in compliance with the License.
1057 
1058 // Unless required by applicable law or agreed to in writing, software
1059 // distributed under the License is distributed on an "AS IS" BASIS,
1060 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1061 
1062 
1063 
1064 contract PriceFeed is DSThing {
1065     uint128 val;
1066     uint32 public zzz;
1067 
1068     function peek() public view returns (bytes32, bool) {
1069         return (bytes32(uint256(val)), block.timestamp < zzz);
1070     }
1071 
1072     function read() public view returns (bytes32) {
1073         assert(block.timestamp < zzz);
1074         return bytes32(uint256(val));
1075     }
1076 
1077     function post(uint128 val_, uint32 zzz_, address med_) public payable note auth {
1078         val = val_;
1079         zzz = zzz_;
1080         (bool success, ) = med_.call(abi.encodeWithSignature("poke()"));
1081         require(success, "The poke must succeed");
1082     }
1083 
1084     function void() public payable note auth {
1085         zzz = 0;
1086     }
1087 
1088 }
1089 
1090 // File: contracts/Oracle/DSValue.sol
1091 
1092 contract DSValue is DSThing {
1093     bool has;
1094     bytes32 val;
1095     function peek() public view returns (bytes32, bool) {
1096         return (val, has);
1097     }
1098 
1099     function read() public view returns (bytes32) {
1100         (bytes32 wut, bool _has) = peek();
1101         assert(_has);
1102         return wut;
1103     }
1104 
1105     function poke(bytes32 wut) public payable note auth {
1106         val = wut;
1107         has = true;
1108     }
1109 
1110     function void() public payable note auth {
1111         // unset the value
1112         has = false;
1113     }
1114 }
1115 
1116 // File: contracts/Oracle/Medianizer.sol
1117 
1118 contract Medianizer is DSValue {
1119     mapping(bytes12 => address) public values;
1120     mapping(address => bytes12) public indexes;
1121     bytes12 public next = bytes12(uint96(1));
1122     uint96 public minimun = 0x1;
1123 
1124     function set(address wat) public auth {
1125         bytes12 nextId = bytes12(uint96(next) + 1);
1126         assert(nextId != 0x0);
1127         set(next, wat);
1128         next = nextId;
1129     }
1130 
1131     function set(bytes12 pos, address wat) public payable note auth {
1132         require(pos != 0x0, "pos cannot be 0x0");
1133         require(wat == address(0) || indexes[wat] == 0, "wat is not defined or it has an index");
1134 
1135         indexes[values[pos]] = bytes12(0); // Making sure to remove a possible existing address in that position
1136 
1137         if (wat != address(0)) {
1138             indexes[wat] = pos;
1139         }
1140 
1141         values[pos] = wat;
1142     }
1143 
1144     function setMin(uint96 min_) public payable note auth {
1145         require(min_ != 0x0, "min cannot be 0x0");
1146         minimun = min_;
1147     }
1148 
1149     function setNext(bytes12 next_) public payable note auth {
1150         require(next_ != 0x0, "next cannot be 0x0");
1151         next = next_;
1152     }
1153 
1154     function unset(bytes12 pos) public {
1155         set(pos, address(0));
1156     }
1157 
1158     function unset(address wat) public {
1159         set(indexes[wat], address(0));
1160     }
1161 
1162     function poke() public {
1163         poke(0);
1164     }
1165 
1166     function poke(bytes32) public payable note {
1167         (val, has) = compute();
1168     }
1169 
1170     function compute() public view returns (bytes32, bool) {
1171         bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
1172         uint96 ctr = 0;
1173         for (uint96 i = 1; i < uint96(next); i++) {
1174             if (values[bytes12(i)] != address(0)) {
1175                 (bytes32 wut, bool wuz) = DSValue(values[bytes12(i)]).peek();
1176                 if (wuz) {
1177                     if (ctr == 0 || wut >= wuts[ctr - 1]) {
1178                         wuts[ctr] = wut;
1179                     } else {
1180                         uint96 j = 0;
1181                         while (wut >= wuts[j]) {
1182                             j++;
1183                         }
1184                         for (uint96 k = ctr; k > j; k--) {
1185                             wuts[k] = wuts[k - 1];
1186                         }
1187                         wuts[j] = wut;
1188                     }
1189                     ctr++;
1190                 }
1191             }
1192         }
1193 
1194         if (ctr < minimun)
1195             return (val, false);
1196 
1197         bytes32 value;
1198         if (ctr % 2 == 0) {
1199             uint128 val1 = uint128(uint(wuts[(ctr / 2) - 1]));
1200             uint128 val2 = uint128(uint(wuts[ctr / 2]));
1201             value = bytes32(uint256(wdiv(hadd(val1, val2), 2 ether)));
1202         } else {
1203             value = wuts[(ctr - 1) / 2];
1204         }
1205 
1206         return (value, true);
1207     }
1208 }
1209 
1210 // File: contracts/Oracle/PriceOracleInterface.sol
1211 
1212 /*
1213 This contract is the interface between the MakerDAO priceFeed and our DX platform.
1214 */
1215 
1216 
1217 
1218 
1219 contract PriceOracleInterface {
1220     address public priceFeedSource;
1221     address public owner;
1222     bool public emergencyMode;
1223 
1224     // Modifiers
1225     modifier onlyOwner() {
1226         require(msg.sender == owner, "Only the owner can do the operation");
1227         _;
1228     }
1229 
1230     /// @dev constructor of the contract
1231     /// @param _priceFeedSource address of price Feed Source -> should be maker feeds Medianizer contract
1232     constructor(address _owner, address _priceFeedSource) public {
1233         owner = _owner;
1234         priceFeedSource = _priceFeedSource;
1235     }
1236     
1237     /// @dev gives the owner the possibility to put the Interface into an emergencyMode, which will
1238     /// output always a price of 600 USD. This gives everyone time to set up a new pricefeed.
1239     function raiseEmergency(bool _emergencyMode) public onlyOwner {
1240         emergencyMode = _emergencyMode;
1241     }
1242 
1243     /// @dev updates the priceFeedSource
1244     /// @param _owner address of owner
1245     function updateCurator(address _owner) public onlyOwner {
1246         owner = _owner;
1247     }
1248 
1249     /// @dev returns the USDETH price
1250     function getUsdEthPricePeek() public view returns (bytes32 price, bool valid) {
1251         return Medianizer(priceFeedSource).peek();
1252     }
1253 
1254     /// @dev returns the USDETH price, ie gets the USD price from Maker feed with 18 digits, but last 18 digits are cut off
1255     function getUSDETHPrice() public view returns (uint256) {
1256         // if the contract is in the emergencyMode, because there is an issue with the oracle, we will simply return a price of 600 USD
1257         if (emergencyMode) {
1258             return 600;
1259         }
1260         (bytes32 price, ) = Medianizer(priceFeedSource).peek();
1261 
1262         // ensuring that there is no underflow or overflow possible,
1263         // even if the price is compromised
1264         uint priceUint = uint256(price)/(1 ether);
1265         if (priceUint == 0) {
1266             return 1;
1267         }
1268         if (priceUint > 1000000) {
1269             return 1000000; 
1270         }
1271         return priceUint;
1272     }
1273 }
1274 
1275 // File: contracts/base/EthOracle.sol
1276 
1277 contract EthOracle is AuctioneerManaged, DxMath {
1278     uint constant WAITING_PERIOD_CHANGE_ORACLE = 30 days;
1279 
1280     // Price Oracle interface
1281     PriceOracleInterface public ethUSDOracle;
1282     // Price Oracle interface proposals during update process
1283     PriceOracleInterface public newProposalEthUSDOracle;
1284 
1285     uint public oracleInterfaceCountdown;
1286 
1287     event NewOracleProposal(PriceOracleInterface priceOracleInterface);
1288 
1289     function initiateEthUsdOracleUpdate(PriceOracleInterface _ethUSDOracle) public onlyAuctioneer {
1290         require(address(_ethUSDOracle) != address(0), "The oracle address must be valid");
1291         newProposalEthUSDOracle = _ethUSDOracle;
1292         oracleInterfaceCountdown = add(block.timestamp, WAITING_PERIOD_CHANGE_ORACLE);
1293         emit NewOracleProposal(_ethUSDOracle);
1294     }
1295 
1296     function updateEthUSDOracle() public {
1297         require(address(newProposalEthUSDOracle) != address(0), "The new proposal must be a valid addres");
1298         require(
1299             oracleInterfaceCountdown < block.timestamp,
1300             "It's not possible to update the oracle during the waiting period"
1301         );
1302         ethUSDOracle = newProposalEthUSDOracle;
1303         newProposalEthUSDOracle = PriceOracleInterface(0);
1304     }
1305 }
1306 
1307 // File: contracts/base/DxUpgrade.sol
1308 
1309 contract DxUpgrade is Proxied, AuctioneerManaged, DxMath {
1310     uint constant WAITING_PERIOD_CHANGE_MASTERCOPY = 30 days;
1311 
1312     address public newMasterCopy;
1313     // Time when new masterCopy is updatabale
1314     uint public masterCopyCountdown;
1315 
1316     event NewMasterCopyProposal(address newMasterCopy);
1317 
1318     function startMasterCopyCountdown(address _masterCopy) public onlyAuctioneer {
1319         require(_masterCopy != address(0), "The new master copy must be a valid address");
1320 
1321         // Update masterCopyCountdown
1322         newMasterCopy = _masterCopy;
1323         masterCopyCountdown = add(block.timestamp, WAITING_PERIOD_CHANGE_MASTERCOPY);
1324         emit NewMasterCopyProposal(_masterCopy);
1325     }
1326 
1327     function updateMasterCopy() public {
1328         require(newMasterCopy != address(0), "The new master copy must be a valid address");
1329         require(block.timestamp >= masterCopyCountdown, "The master contract cannot be updated in a waiting period");
1330 
1331         // Update masterCopy
1332         masterCopy = newMasterCopy;
1333         newMasterCopy = address(0);
1334     }
1335 
1336 }
1337 
1338 // File: contracts/DutchExchange.sol
1339 
1340 /// @title Dutch Exchange - exchange token pairs with the clever mechanism of the dutch auction
1341 /// @author Alex Herrmann - <alex@gnosis.pm>
1342 /// @author Dominik Teiml - <dominik@gnosis.pm>
1343 
1344 contract DutchExchange is DxUpgrade, TokenWhitelist, EthOracle, SafeTransfer {
1345 
1346     // The price is a rational number, so we need a concept of a fraction
1347     struct Fraction {
1348         uint num;
1349         uint den;
1350     }
1351 
1352     uint constant WAITING_PERIOD_NEW_TOKEN_PAIR = 6 hours;
1353     uint constant WAITING_PERIOD_NEW_AUCTION = 10 minutes;
1354     uint constant AUCTION_START_WAITING_FOR_FUNDING = 1;
1355 
1356     // > Storage
1357     // Ether ERC-20 token
1358     address public ethToken;
1359 
1360     // Minimum required sell funding for adding a new token pair, in USD
1361     uint public thresholdNewTokenPair;
1362     // Minimum required sell funding for starting antoher auction, in USD
1363     uint public thresholdNewAuction;
1364     // Fee reduction token (magnolia, ERC-20 token)
1365     TokenFRT public frtToken;
1366     // Token for paying fees
1367     TokenOWL public owlToken;
1368 
1369     // For the following three mappings, there is one mapping for each token pair
1370     // The order which the tokens should be called is smaller, larger
1371     // These variables should never be called directly! They have getters below
1372     // Token => Token => index
1373     mapping(address => mapping(address => uint)) public latestAuctionIndices;
1374     // Token => Token => time
1375     mapping (address => mapping (address => uint)) public auctionStarts;
1376     // Token => Token => auctionIndex => time
1377     mapping (address => mapping (address => mapping (uint => uint))) public clearingTimes;
1378 
1379     // Token => Token => auctionIndex => price
1380     mapping(address => mapping(address => mapping(uint => Fraction))) public closingPrices;
1381 
1382     // Token => Token => amount
1383     mapping(address => mapping(address => uint)) public sellVolumesCurrent;
1384     // Token => Token => amount
1385     mapping(address => mapping(address => uint)) public sellVolumesNext;
1386     // Token => Token => amount
1387     mapping(address => mapping(address => uint)) public buyVolumes;
1388 
1389     // Token => user => amount
1390     // balances stores a user's balance in the DutchX
1391     mapping(address => mapping(address => uint)) public balances;
1392 
1393     // Token => Token => auctionIndex => amount
1394     mapping(address => mapping(address => mapping(uint => uint))) public extraTokens;
1395 
1396     // Token => Token =>  auctionIndex => user => amount
1397     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public sellerBalances;
1398     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public buyerBalances;
1399     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public claimedAmounts;
1400 
1401     function depositAndSell(address sellToken, address buyToken, uint amount)
1402         external
1403         returns (uint newBal, uint auctionIndex, uint newSellerBal)
1404     {
1405         newBal = deposit(sellToken, amount);
1406         (auctionIndex, newSellerBal) = postSellOrder(sellToken, buyToken, 0, amount);
1407     }
1408 
1409     function claimAndWithdraw(address sellToken, address buyToken, address user, uint auctionIndex, uint amount)
1410         external
1411         returns (uint returned, uint frtsIssued, uint newBal)
1412     {
1413         (returned, frtsIssued) = claimSellerFunds(sellToken, buyToken, user, auctionIndex);
1414         newBal = withdraw(buyToken, amount);
1415     }
1416 
1417     /// @dev for multiple claims
1418     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1419     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1420     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1421     /// @param user is the user who wants to his tokens
1422     function claimTokensFromSeveralAuctionsAsSeller(
1423         address[] calldata auctionSellTokens,
1424         address[] calldata auctionBuyTokens,
1425         uint[] calldata auctionIndices,
1426         address user
1427     ) external returns (uint[] memory, uint[] memory)
1428     {
1429         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1430 
1431         uint[] memory claimAmounts = new uint[](length);
1432         uint[] memory frtsIssuedList = new uint[](length);
1433 
1434         for (uint i = 0; i < length; i++) {
1435             (claimAmounts[i], frtsIssuedList[i]) = claimSellerFunds(
1436                 auctionSellTokens[i],
1437                 auctionBuyTokens[i],
1438                 user,
1439                 auctionIndices[i]
1440             );
1441         }
1442 
1443         return (claimAmounts, frtsIssuedList);
1444     }
1445 
1446     /// @dev for multiple claims
1447     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1448     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1449     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1450     /// @param user is the user who wants to his tokens
1451     function claimTokensFromSeveralAuctionsAsBuyer(
1452         address[] calldata auctionSellTokens,
1453         address[] calldata auctionBuyTokens,
1454         uint[] calldata auctionIndices,
1455         address user
1456     ) external returns (uint[] memory, uint[] memory)
1457     {
1458         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1459 
1460         uint[] memory claimAmounts = new uint[](length);
1461         uint[] memory frtsIssuedList = new uint[](length);
1462 
1463         for (uint i = 0; i < length; i++) {
1464             (claimAmounts[i], frtsIssuedList[i]) = claimBuyerFunds(
1465                 auctionSellTokens[i],
1466                 auctionBuyTokens[i],
1467                 user,
1468                 auctionIndices[i]
1469             );
1470         }
1471 
1472         return (claimAmounts, frtsIssuedList);
1473     }
1474 
1475     /// @dev for multiple withdraws
1476     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1477     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1478     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1479     function claimAndWithdrawTokensFromSeveralAuctionsAsSeller(
1480         address[] calldata auctionSellTokens,
1481         address[] calldata auctionBuyTokens,
1482         uint[] calldata auctionIndices
1483     ) external returns (uint[] memory, uint frtsIssued)
1484     {
1485         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1486 
1487         uint[] memory claimAmounts = new uint[](length);
1488         uint claimFrts = 0;
1489 
1490         for (uint i = 0; i < length; i++) {
1491             (claimAmounts[i], claimFrts) = claimSellerFunds(
1492                 auctionSellTokens[i],
1493                 auctionBuyTokens[i],
1494                 msg.sender,
1495                 auctionIndices[i]
1496             );
1497 
1498             frtsIssued += claimFrts;
1499 
1500             withdraw(auctionBuyTokens[i], claimAmounts[i]);
1501         }
1502 
1503         return (claimAmounts, frtsIssued);
1504     }
1505 
1506     /// @dev for multiple withdraws
1507     /// @param auctionSellTokens are the sellTokens defining an auctionPair
1508     /// @param auctionBuyTokens are the buyTokens defining an auctionPair
1509     /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
1510     function claimAndWithdrawTokensFromSeveralAuctionsAsBuyer(
1511         address[] calldata auctionSellTokens,
1512         address[] calldata auctionBuyTokens,
1513         uint[] calldata auctionIndices
1514     ) external returns (uint[] memory, uint frtsIssued)
1515     {
1516         uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);
1517 
1518         uint[] memory claimAmounts = new uint[](length);
1519         uint claimFrts = 0;
1520 
1521         for (uint i = 0; i < length; i++) {
1522             (claimAmounts[i], claimFrts) = claimBuyerFunds(
1523                 auctionSellTokens[i],
1524                 auctionBuyTokens[i],
1525                 msg.sender,
1526                 auctionIndices[i]
1527             );
1528 
1529             frtsIssued += claimFrts;
1530 
1531             withdraw(auctionSellTokens[i], claimAmounts[i]);
1532         }
1533 
1534         return (claimAmounts, frtsIssued);
1535     }
1536 
1537     function getMasterCopy() external view returns (address) {
1538         return masterCopy;
1539     }
1540 
1541     /// @dev Constructor-Function creates exchange
1542     /// @param _frtToken - address of frtToken ERC-20 token
1543     /// @param _owlToken - address of owlToken ERC-20 token
1544     /// @param _auctioneer - auctioneer for managing interfaces
1545     /// @param _ethToken - address of ETH ERC-20 token
1546     /// @param _ethUSDOracle - address of the oracle contract for fetching feeds
1547     /// @param _thresholdNewTokenPair - Minimum required sell funding for adding a new token pair, in USD
1548     function setupDutchExchange(
1549         TokenFRT _frtToken,
1550         TokenOWL _owlToken,
1551         address _auctioneer,
1552         address _ethToken,
1553         PriceOracleInterface _ethUSDOracle,
1554         uint _thresholdNewTokenPair,
1555         uint _thresholdNewAuction
1556     ) public
1557     {
1558         // Make sure contract hasn't been initialised
1559         require(ethToken == address(0), "The contract must be uninitialized");
1560 
1561         // Validates inputs
1562         require(address(_owlToken) != address(0), "The OWL address must be valid");
1563         require(address(_frtToken) != address(0), "The FRT address must be valid");
1564         require(_auctioneer != address(0), "The auctioneer address must be valid");
1565         require(_ethToken != address(0), "The WETH address must be valid");
1566         require(address(_ethUSDOracle) != address(0), "The oracle address must be valid");
1567 
1568         frtToken = _frtToken;
1569         owlToken = _owlToken;
1570         auctioneer = _auctioneer;
1571         ethToken = _ethToken;
1572         ethUSDOracle = _ethUSDOracle;
1573         thresholdNewTokenPair = _thresholdNewTokenPair;
1574         thresholdNewAuction = _thresholdNewAuction;
1575     }
1576 
1577     function updateThresholdNewTokenPair(uint _thresholdNewTokenPair) public onlyAuctioneer {
1578         thresholdNewTokenPair = _thresholdNewTokenPair;
1579     }
1580 
1581     function updateThresholdNewAuction(uint _thresholdNewAuction) public onlyAuctioneer {
1582         thresholdNewAuction = _thresholdNewAuction;
1583     }
1584 
1585     /// @param initialClosingPriceNum initial price will be 2 * initialClosingPrice. This is its numerator
1586     /// @param initialClosingPriceDen initial price will be 2 * initialClosingPrice. This is its denominator
1587     function addTokenPair(
1588         address token1,
1589         address token2,
1590         uint token1Funding,
1591         uint token2Funding,
1592         uint initialClosingPriceNum,
1593         uint initialClosingPriceDen
1594     ) public
1595     {
1596         // R1
1597         require(token1 != token2, "You cannot add a token pair using the same token");
1598 
1599         // R2
1600         require(initialClosingPriceNum != 0, "You must set the numerator for the initial price");
1601 
1602         // R3
1603         require(initialClosingPriceDen != 0, "You must set the denominator for the initial price");
1604 
1605         // R4
1606         require(getAuctionIndex(token1, token2) == 0, "The token pair was already added");
1607 
1608         // R5: to prevent overflow
1609         require(initialClosingPriceNum < 10 ** 18, "You must set a smaller numerator for the initial price");
1610 
1611         // R6
1612         require(initialClosingPriceDen < 10 ** 18, "You must set a smaller denominator for the initial price");
1613 
1614         setAuctionIndex(token1, token2);
1615 
1616         token1Funding = min(token1Funding, balances[token1][msg.sender]);
1617         token2Funding = min(token2Funding, balances[token2][msg.sender]);
1618 
1619         // R7
1620         require(token1Funding < 10 ** 30, "You should use a smaller funding for token 1");
1621 
1622         // R8
1623         require(token2Funding < 10 ** 30, "You should use a smaller funding for token 2");
1624 
1625         uint fundedValueUSD;
1626         uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();
1627 
1628         // Compute fundedValueUSD
1629         address ethTokenMem = ethToken;
1630         if (token1 == ethTokenMem) {
1631             // C1
1632             // MUL: 10^30 * 10^6 = 10^36
1633             fundedValueUSD = mul(token1Funding, ethUSDPrice);
1634         } else if (token2 == ethTokenMem) {
1635             // C2
1636             // MUL: 10^30 * 10^6 = 10^36
1637             fundedValueUSD = mul(token2Funding, ethUSDPrice);
1638         } else {
1639             // C3: Neither token is ethToken
1640             fundedValueUSD = calculateFundedValueTokenToken(
1641                 token1,
1642                 token2,
1643                 token1Funding,
1644                 token2Funding,
1645                 ethTokenMem,
1646                 ethUSDPrice
1647             );
1648         }
1649 
1650         // R5
1651         require(fundedValueUSD >= thresholdNewTokenPair, "You should surplus the threshold for adding token pairs");
1652 
1653         // Save prices of opposite auctions
1654         closingPrices[token1][token2][0] = Fraction(initialClosingPriceNum, initialClosingPriceDen);
1655         closingPrices[token2][token1][0] = Fraction(initialClosingPriceDen, initialClosingPriceNum);
1656 
1657         // Split into two fns because of 16 local-var cap
1658         addTokenPairSecondPart(token1, token2, token1Funding, token2Funding);
1659     }
1660 
1661     function deposit(address tokenAddress, uint amount) public returns (uint) {
1662         // R1
1663         require(safeTransfer(tokenAddress, msg.sender, amount, true), "The deposit transaction must succeed");
1664 
1665         uint newBal = add(balances[tokenAddress][msg.sender], amount);
1666 
1667         balances[tokenAddress][msg.sender] = newBal;
1668 
1669         emit NewDeposit(tokenAddress, amount);
1670 
1671         return newBal;
1672     }
1673 
1674     function withdraw(address tokenAddress, uint amount) public returns (uint) {
1675         uint usersBalance = balances[tokenAddress][msg.sender];
1676         amount = min(amount, usersBalance);
1677 
1678         // R1
1679         require(amount > 0, "The amount must be greater than 0");
1680 
1681         uint newBal = sub(usersBalance, amount);
1682         balances[tokenAddress][msg.sender] = newBal;
1683 
1684         // R2
1685         require(safeTransfer(tokenAddress, msg.sender, amount, false), "The withdraw transfer must succeed");
1686         emit NewWithdrawal(tokenAddress, amount);
1687 
1688         return newBal;
1689     }
1690 
1691     function postSellOrder(address sellToken, address buyToken, uint auctionIndex, uint amount)
1692         public
1693         returns (uint, uint)
1694     {
1695         // Note: if a user specifies auctionIndex of 0, it
1696         // means he is agnostic which auction his sell order goes into
1697 
1698         amount = min(amount, balances[sellToken][msg.sender]);
1699 
1700         // R1
1701         // require(amount >= 0, "Sell amount should be greater than 0");
1702 
1703         // R2
1704         uint latestAuctionIndex = getAuctionIndex(sellToken, buyToken);
1705         require(latestAuctionIndex > 0);
1706 
1707         // R3
1708         uint auctionStart = getAuctionStart(sellToken, buyToken);
1709         if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING || auctionStart > now) {
1710             // C1: We are in the 10 minute buffer period
1711             // OR waiting for an auction to receive sufficient sellVolume
1712             // Auction has already cleared, and index has been incremented
1713             // sell order must use that auction index
1714             // R1.1
1715             if (auctionIndex == 0) {
1716                 auctionIndex = latestAuctionIndex;
1717             } else {
1718                 require(auctionIndex == latestAuctionIndex, "Auction index should be equal to latest auction index");
1719             }
1720 
1721             // R1.2
1722             require(add(sellVolumesCurrent[sellToken][buyToken], amount) < 10 ** 30);
1723         } else {
1724             // C2
1725             // R2.1: Sell orders must go to next auction
1726             if (auctionIndex == 0) {
1727                 auctionIndex = latestAuctionIndex + 1;
1728             } else {
1729                 require(auctionIndex == latestAuctionIndex + 1);
1730             }
1731 
1732             // R2.2
1733             require(add(sellVolumesNext[sellToken][buyToken], amount) < 10 ** 30);
1734         }
1735 
1736         // Fee mechanism, fees are added to extraTokens
1737         uint amountAfterFee = settleFee(sellToken, buyToken, auctionIndex, amount);
1738 
1739         // Update variables
1740         balances[sellToken][msg.sender] = sub(balances[sellToken][msg.sender], amount);
1741         uint newSellerBal = add(sellerBalances[sellToken][buyToken][auctionIndex][msg.sender], amountAfterFee);
1742         sellerBalances[sellToken][buyToken][auctionIndex][msg.sender] = newSellerBal;
1743 
1744         if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING || auctionStart > now) {
1745             // C1
1746             uint sellVolumeCurrent = sellVolumesCurrent[sellToken][buyToken];
1747             sellVolumesCurrent[sellToken][buyToken] = add(sellVolumeCurrent, amountAfterFee);
1748         } else {
1749             // C2
1750             uint sellVolumeNext = sellVolumesNext[sellToken][buyToken];
1751             sellVolumesNext[sellToken][buyToken] = add(sellVolumeNext, amountAfterFee);
1752 
1753             // close previous auction if theoretically closed
1754             closeTheoreticalClosedAuction(sellToken, buyToken, latestAuctionIndex);
1755         }
1756 
1757         if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING) {
1758             scheduleNextAuction(sellToken, buyToken);
1759         }
1760 
1761         emit NewSellOrder(sellToken, buyToken, msg.sender, auctionIndex, amountAfterFee);
1762 
1763         return (auctionIndex, newSellerBal);
1764     }
1765 
1766     function postBuyOrder(address sellToken, address buyToken, uint auctionIndex, uint amount)
1767         public
1768         returns (uint newBuyerBal)
1769     {
1770         // R1: auction must not have cleared
1771         require(closingPrices[sellToken][buyToken][auctionIndex].den == 0);
1772 
1773         uint auctionStart = getAuctionStart(sellToken, buyToken);
1774 
1775         // R2
1776         require(auctionStart <= now);
1777 
1778         // R4
1779         require(auctionIndex == getAuctionIndex(sellToken, buyToken));
1780 
1781         // R5: auction must not be in waiting period
1782         require(auctionStart > AUCTION_START_WAITING_FOR_FUNDING);
1783 
1784         // R6: auction must be funded
1785         require(sellVolumesCurrent[sellToken][buyToken] > 0);
1786 
1787         uint buyVolume = buyVolumes[sellToken][buyToken];
1788         amount = min(amount, balances[buyToken][msg.sender]);
1789 
1790         // R7
1791         require(add(buyVolume, amount) < 10 ** 30);
1792 
1793         // Overbuy is when a part of a buy order clears an auction
1794         // In that case we only process the part before the overbuy
1795         // To calculate overbuy, we first get current price
1796         uint sellVolume = sellVolumesCurrent[sellToken][buyToken];
1797 
1798         uint num;
1799         uint den;
1800         (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
1801         // 10^30 * 10^37 = 10^67
1802         uint outstandingVolume = atleastZero(int(mul(sellVolume, num) / den - buyVolume));
1803 
1804         uint amountAfterFee;
1805         if (amount < outstandingVolume) {
1806             if (amount > 0) {
1807                 amountAfterFee = settleFee(buyToken, sellToken, auctionIndex, amount);
1808             }
1809         } else {
1810             amount = outstandingVolume;
1811             amountAfterFee = outstandingVolume;
1812         }
1813 
1814         // Here we could also use outstandingVolume or amountAfterFee, it doesn't matter
1815         if (amount > 0) {
1816             // Update variables
1817             balances[buyToken][msg.sender] = sub(balances[buyToken][msg.sender], amount);
1818             newBuyerBal = add(buyerBalances[sellToken][buyToken][auctionIndex][msg.sender], amountAfterFee);
1819             buyerBalances[sellToken][buyToken][auctionIndex][msg.sender] = newBuyerBal;
1820             buyVolumes[sellToken][buyToken] = add(buyVolumes[sellToken][buyToken], amountAfterFee);
1821             emit NewBuyOrder(sellToken, buyToken, msg.sender, auctionIndex, amountAfterFee);
1822         }
1823 
1824         // Checking for equality would suffice here. nevertheless:
1825         if (amount >= outstandingVolume) {
1826             // Clear auction
1827             clearAuction(sellToken, buyToken, auctionIndex, sellVolume);
1828         }
1829 
1830         return (newBuyerBal);
1831     }
1832 
1833     function claimSellerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
1834         public
1835         returns (
1836         // < (10^60, 10^61)
1837         uint returned,
1838         uint frtsIssued
1839     )
1840     {
1841         closeTheoreticalClosedAuction(sellToken, buyToken, auctionIndex);
1842         uint sellerBalance = sellerBalances[sellToken][buyToken][auctionIndex][user];
1843 
1844         // R1
1845         require(sellerBalance > 0);
1846 
1847         // Get closing price for said auction
1848         Fraction memory closingPrice = closingPrices[sellToken][buyToken][auctionIndex];
1849         uint num = closingPrice.num;
1850         uint den = closingPrice.den;
1851 
1852         // R2: require auction to have cleared
1853         require(den > 0);
1854 
1855         // Calculate return
1856         // < 10^30 * 10^30 = 10^60
1857         returned = mul(sellerBalance, num) / den;
1858 
1859         frtsIssued = issueFrts(
1860             sellToken,
1861             buyToken,
1862             returned,
1863             auctionIndex,
1864             sellerBalance,
1865             user
1866         );
1867 
1868         // Claim tokens
1869         sellerBalances[sellToken][buyToken][auctionIndex][user] = 0;
1870         if (returned > 0) {
1871             balances[buyToken][user] = add(balances[buyToken][user], returned);
1872         }
1873         emit NewSellerFundsClaim(
1874             sellToken,
1875             buyToken,
1876             user,
1877             auctionIndex,
1878             returned,
1879             frtsIssued
1880         );
1881     }
1882 
1883     function claimBuyerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
1884         public
1885         returns (uint returned, uint frtsIssued)
1886     {
1887         closeTheoreticalClosedAuction(sellToken, buyToken, auctionIndex);
1888 
1889         uint num;
1890         uint den;
1891         (returned, num, den) = getUnclaimedBuyerFunds(sellToken, buyToken, user, auctionIndex);
1892 
1893         if (closingPrices[sellToken][buyToken][auctionIndex].den == 0) {
1894             // Auction is running
1895             claimedAmounts[sellToken][buyToken][auctionIndex][user] = add(
1896                 claimedAmounts[sellToken][buyToken][auctionIndex][user],
1897                 returned
1898             );
1899         } else {
1900             // Auction has closed
1901             // We DON'T want to check for returned > 0, because that would fail if a user claims
1902             // intermediate funds & auction clears in same block (he/she would not be able to claim extraTokens)
1903 
1904             // Assign extra sell tokens (this is possible only after auction has cleared,
1905             // because buyVolume could still increase before that)
1906             uint extraTokensTotal = extraTokens[sellToken][buyToken][auctionIndex];
1907             uint buyerBalance = buyerBalances[sellToken][buyToken][auctionIndex][user];
1908 
1909             // closingPrices.num represents buyVolume
1910             // < 10^30 * 10^30 = 10^60
1911             uint tokensExtra = mul(
1912                 buyerBalance,
1913                 extraTokensTotal
1914             ) / closingPrices[sellToken][buyToken][auctionIndex].num;
1915             returned = add(returned, tokensExtra);
1916 
1917             frtsIssued = issueFrts(
1918                 buyToken,
1919                 sellToken,
1920                 mul(buyerBalance, den) / num,
1921                 auctionIndex,
1922                 buyerBalance,
1923                 user
1924             );
1925 
1926             // Auction has closed
1927             // Reset buyerBalances and claimedAmounts
1928             buyerBalances[sellToken][buyToken][auctionIndex][user] = 0;
1929             claimedAmounts[sellToken][buyToken][auctionIndex][user] = 0;
1930         }
1931 
1932         // Claim tokens
1933         if (returned > 0) {
1934             balances[sellToken][user] = add(balances[sellToken][user], returned);
1935         }
1936 
1937         emit NewBuyerFundsClaim(
1938             sellToken,
1939             buyToken,
1940             user,
1941             auctionIndex,
1942             returned,
1943             frtsIssued
1944         );
1945     }
1946 
1947     /// @dev allows to close possible theoretical closed markets
1948     /// @param sellToken sellToken of an auction
1949     /// @param buyToken buyToken of an auction
1950     /// @param auctionIndex is the auctionIndex of the auction
1951     function closeTheoreticalClosedAuction(address sellToken, address buyToken, uint auctionIndex) public {
1952         if (auctionIndex == getAuctionIndex(
1953             buyToken,
1954             sellToken
1955         ) && closingPrices[sellToken][buyToken][auctionIndex].num == 0) {
1956             uint buyVolume = buyVolumes[sellToken][buyToken];
1957             uint sellVolume = sellVolumesCurrent[sellToken][buyToken];
1958             uint num;
1959             uint den;
1960             (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
1961             // 10^30 * 10^37 = 10^67
1962             if (sellVolume > 0) {
1963                 uint outstandingVolume = atleastZero(int(mul(sellVolume, num) / den - buyVolume));
1964 
1965                 if (outstandingVolume == 0) {
1966                     postBuyOrder(sellToken, buyToken, auctionIndex, 0);
1967                 }
1968             }
1969         }
1970     }
1971 
1972     /// @dev Claim buyer funds for one auction
1973     function getUnclaimedBuyerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
1974         public
1975         view
1976         returns (
1977         // < (10^67, 10^37)
1978         uint unclaimedBuyerFunds,
1979         uint num,
1980         uint den
1981     )
1982     {
1983         // R1: checks if particular auction has ever run
1984         require(auctionIndex <= getAuctionIndex(sellToken, buyToken));
1985 
1986         (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
1987 
1988         if (num == 0) {
1989             // This should rarely happen - as long as there is >= 1 buy order,
1990             // auction will clear before price = 0. So this is just fail-safe
1991             unclaimedBuyerFunds = 0;
1992         } else {
1993             uint buyerBalance = buyerBalances[sellToken][buyToken][auctionIndex][user];
1994             // < 10^30 * 10^37 = 10^67
1995             unclaimedBuyerFunds = atleastZero(
1996                 int(mul(buyerBalance, den) / num - claimedAmounts[sellToken][buyToken][auctionIndex][user])
1997             );
1998         }
1999     }
2000 
2001     function getFeeRatio(address user)
2002         public
2003         view
2004         returns (
2005         // feeRatio < 10^4
2006         uint num,
2007         uint den
2008     )
2009     {
2010         uint totalSupply = frtToken.totalSupply();
2011         uint lockedFrt = frtToken.lockedTokenBalances(user);
2012 
2013         /*
2014           Fee Model:
2015             locked FRT range     Fee
2016             -----------------   ------
2017             [0, 0.01%)           0.5%
2018             [0.01%, 0.1%)        0.4%
2019             [0.1%, 1%)           0.3%
2020             [1%, 10%)            0.2%
2021             [10%, 100%)          0.1%
2022         */
2023 
2024         if (lockedFrt * 10000 < totalSupply || totalSupply == 0) {
2025             // Maximum fee, if user has locked less than 0.01% of the total FRT
2026             // Fee: 0.5%
2027             num = 1;
2028             den = 200;
2029         } else if (lockedFrt * 1000 < totalSupply) {
2030             // If user has locked more than 0.01% and less than 0.1% of the total FRT
2031             // Fee: 0.4%
2032             num = 1;
2033             den = 250;
2034         } else if (lockedFrt * 100 < totalSupply) {
2035             // If user has locked more than 0.1% and less than 1% of the total FRT
2036             // Fee: 0.3%
2037             num = 3;
2038             den = 1000;
2039         } else if (lockedFrt * 10 < totalSupply) {
2040             // If user has locked more than 1% and less than 10% of the total FRT
2041             // Fee: 0.2%
2042             num = 1;
2043             den = 500;
2044         } else {
2045             // If user has locked more than 10% of the total FRT
2046             // Fee: 0.1%
2047             num = 1;
2048             den = 1000;
2049         }
2050     }
2051 
2052     //@ dev returns price in units [token2]/[token1]
2053     //@ param token1 first token for price calculation
2054     //@ param token2 second token for price calculation
2055     //@ param auctionIndex index for the auction to get the averaged price from
2056     function getPriceInPastAuction(
2057         address token1,
2058         address token2,
2059         uint auctionIndex
2060     )
2061         public
2062         view
2063         // price < 10^31
2064         returns (uint num, uint den)
2065     {
2066         if (token1 == token2) {
2067             // C1
2068             num = 1;
2069             den = 1;
2070         } else {
2071             // C2
2072             // R2.1
2073             // require(auctionIndex >= 0);
2074 
2075             // C3
2076             // R3.1
2077             require(auctionIndex <= getAuctionIndex(token1, token2));
2078             // auction still running
2079 
2080             uint i = 0;
2081             bool correctPair = false;
2082             Fraction memory closingPriceToken1;
2083             Fraction memory closingPriceToken2;
2084 
2085             while (!correctPair) {
2086                 closingPriceToken2 = closingPrices[token2][token1][auctionIndex - i];
2087                 closingPriceToken1 = closingPrices[token1][token2][auctionIndex - i];
2088 
2089                 if (closingPriceToken1.num > 0 && closingPriceToken1.den > 0 ||
2090                     closingPriceToken2.num > 0 && closingPriceToken2.den > 0)
2091                 {
2092                     correctPair = true;
2093                 }
2094                 i++;
2095             }
2096 
2097             // At this point at least one closing price is strictly positive
2098             // If only one is positive, we want to output that
2099             if (closingPriceToken1.num == 0 || closingPriceToken1.den == 0) {
2100                 num = closingPriceToken2.den;
2101                 den = closingPriceToken2.num;
2102             } else if (closingPriceToken2.num == 0 || closingPriceToken2.den == 0) {
2103                 num = closingPriceToken1.num;
2104                 den = closingPriceToken1.den;
2105             } else {
2106                 // If both prices are positive, output weighted average
2107                 num = closingPriceToken2.den + closingPriceToken1.num;
2108                 den = closingPriceToken2.num + closingPriceToken1.den;
2109             }
2110         }
2111     }
2112 
2113     function scheduleNextAuction(
2114         address sellToken,
2115         address buyToken
2116     )
2117         internal
2118     {
2119         (uint sellVolume, uint sellVolumeOpp) = getSellVolumesInUSD(sellToken, buyToken);
2120 
2121         bool enoughSellVolume = sellVolume >= thresholdNewAuction;
2122         bool enoughSellVolumeOpp = sellVolumeOpp >= thresholdNewAuction;
2123         bool schedule;
2124         // Make sure both sides have liquidity in order to start the auction
2125         if (enoughSellVolume && enoughSellVolumeOpp) {
2126             schedule = true;
2127         } else if (enoughSellVolume || enoughSellVolumeOpp) {
2128             // But if the auction didn't start in 24h, then is enough to have
2129             // liquidity in one of the two sides
2130             uint latestAuctionIndex = getAuctionIndex(sellToken, buyToken);
2131             uint clearingTime = getClearingTime(sellToken, buyToken, latestAuctionIndex - 1);
2132             schedule = clearingTime <= now - 24 hours;
2133         }
2134 
2135         if (schedule) {
2136             // Schedule next auction
2137             setAuctionStart(sellToken, buyToken, WAITING_PERIOD_NEW_AUCTION);
2138         } else {
2139             resetAuctionStart(sellToken, buyToken);
2140         }
2141     }
2142 
2143     function getSellVolumesInUSD(
2144         address sellToken,
2145         address buyToken
2146     )
2147         internal
2148         view
2149         returns (uint sellVolume, uint sellVolumeOpp)
2150     {
2151         // Check if auctions received enough sell orders
2152         uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();
2153 
2154         uint sellNum;
2155         uint sellDen;
2156         (sellNum, sellDen) = getPriceOfTokenInLastAuction(sellToken);
2157 
2158         uint buyNum;
2159         uint buyDen;
2160         (buyNum, buyDen) = getPriceOfTokenInLastAuction(buyToken);
2161 
2162         // We use current sell volume, because in clearAuction() we set
2163         // sellVolumesCurrent = sellVolumesNext before calling this function
2164         // (this is so that we don't need case work,
2165         // since it might also be called from postSellOrder())
2166 
2167         // < 10^30 * 10^31 * 10^6 = 10^67
2168         sellVolume = mul(mul(sellVolumesCurrent[sellToken][buyToken], sellNum), ethUSDPrice) / sellDen;
2169         sellVolumeOpp = mul(mul(sellVolumesCurrent[buyToken][sellToken], buyNum), ethUSDPrice) / buyDen;
2170     }
2171 
2172     /// @dev Gives best estimate for market price of a token in ETH of any price oracle on the Ethereum network
2173     /// @param token address of ERC-20 token
2174     /// @return Weighted average of closing prices of opposite Token-ethToken auctions, based on their sellVolume
2175     function getPriceOfTokenInLastAuction(address token)
2176         public
2177         view
2178         returns (
2179         // price < 10^31
2180         uint num,
2181         uint den
2182     )
2183     {
2184         uint latestAuctionIndex = getAuctionIndex(token, ethToken);
2185         // getPriceInPastAuction < 10^30
2186         (num, den) = getPriceInPastAuction(token, ethToken, latestAuctionIndex - 1);
2187     }
2188 
2189     function getCurrentAuctionPrice(address sellToken, address buyToken, uint auctionIndex)
2190         public
2191         view
2192         returns (
2193         // price < 10^37
2194         uint num,
2195         uint den
2196     )
2197     {
2198         Fraction memory closingPrice = closingPrices[sellToken][buyToken][auctionIndex];
2199 
2200         if (closingPrice.den != 0) {
2201             // Auction has closed
2202             (num, den) = (closingPrice.num, closingPrice.den);
2203         } else if (auctionIndex > getAuctionIndex(sellToken, buyToken)) {
2204             (num, den) = (0, 0);
2205         } else {
2206             // Auction is running
2207             uint pastNum;
2208             uint pastDen;
2209             (pastNum, pastDen) = getPriceInPastAuction(sellToken, buyToken, auctionIndex - 1);
2210 
2211             // If we're calling the function into an unstarted auction,
2212             // it will return the starting price of that auction
2213             uint timeElapsed = atleastZero(int(now - getAuctionStart(sellToken, buyToken)));
2214 
2215             // The numbers below are chosen such that
2216             // P(0 hrs) = 2 * lastClosingPrice, P(6 hrs) = lastClosingPrice, P(>=24 hrs) = 0
2217 
2218             // 10^5 * 10^31 = 10^36
2219             num = atleastZero(int((24 hours - timeElapsed) * pastNum));
2220             // 10^6 * 10^31 = 10^37
2221             den = mul((timeElapsed + 12 hours), pastDen);
2222 
2223             if (mul(num, sellVolumesCurrent[sellToken][buyToken]) <= mul(den, buyVolumes[sellToken][buyToken])) {
2224                 num = buyVolumes[sellToken][buyToken];
2225                 den = sellVolumesCurrent[sellToken][buyToken];
2226             }
2227         }
2228     }
2229 
2230     // > Helper fns
2231     function getTokenOrder(address token1, address token2) public pure returns (address, address) {
2232         if (token2 < token1) {
2233             (token1, token2) = (token2, token1);
2234         }
2235 
2236         return (token1, token2);
2237     }
2238 
2239     function getAuctionStart(address token1, address token2) public view returns (uint auctionStart) {
2240         (token1, token2) = getTokenOrder(token1, token2);
2241         auctionStart = auctionStarts[token1][token2];
2242     }
2243 
2244     function getAuctionIndex(address token1, address token2) public view returns (uint auctionIndex) {
2245         (token1, token2) = getTokenOrder(token1, token2);
2246         auctionIndex = latestAuctionIndices[token1][token2];
2247     }
2248 
2249     function calculateFundedValueTokenToken(
2250         address token1,
2251         address token2,
2252         uint token1Funding,
2253         uint token2Funding,
2254         address ethTokenMem,
2255         uint ethUSDPrice
2256     )
2257         internal
2258         view
2259         returns (uint fundedValueUSD)
2260     {
2261         // We require there to exist ethToken-Token auctions
2262         // R3.1
2263         require(getAuctionIndex(token1, ethTokenMem) > 0);
2264 
2265         // R3.2
2266         require(getAuctionIndex(token2, ethTokenMem) > 0);
2267 
2268         // Price of Token 1
2269         uint priceToken1Num;
2270         uint priceToken1Den;
2271         (priceToken1Num, priceToken1Den) = getPriceOfTokenInLastAuction(token1);
2272 
2273         // Price of Token 2
2274         uint priceToken2Num;
2275         uint priceToken2Den;
2276         (priceToken2Num, priceToken2Den) = getPriceOfTokenInLastAuction(token2);
2277 
2278         // Compute funded value in ethToken and USD
2279         // 10^30 * 10^30 = 10^60
2280         uint fundedValueETH = add(
2281             mul(token1Funding, priceToken1Num) / priceToken1Den,
2282             token2Funding * priceToken2Num / priceToken2Den
2283         );
2284 
2285         fundedValueUSD = mul(fundedValueETH, ethUSDPrice);
2286     }
2287 
2288     function addTokenPairSecondPart(
2289         address token1,
2290         address token2,
2291         uint token1Funding,
2292         uint token2Funding
2293     )
2294         internal
2295     {
2296         balances[token1][msg.sender] = sub(balances[token1][msg.sender], token1Funding);
2297         balances[token2][msg.sender] = sub(balances[token2][msg.sender], token2Funding);
2298 
2299         // Fee mechanism, fees are added to extraTokens
2300         uint token1FundingAfterFee = settleFee(token1, token2, 1, token1Funding);
2301         uint token2FundingAfterFee = settleFee(token2, token1, 1, token2Funding);
2302 
2303         // Update other variables
2304         sellVolumesCurrent[token1][token2] = token1FundingAfterFee;
2305         sellVolumesCurrent[token2][token1] = token2FundingAfterFee;
2306         sellerBalances[token1][token2][1][msg.sender] = token1FundingAfterFee;
2307         sellerBalances[token2][token1][1][msg.sender] = token2FundingAfterFee;
2308 
2309         // Save clearingTime as adding time
2310         (address tokenA, address tokenB) = getTokenOrder(token1, token2);
2311         clearingTimes[tokenA][tokenB][0] = now;
2312 
2313         setAuctionStart(token1, token2, WAITING_PERIOD_NEW_TOKEN_PAIR);
2314         emit NewTokenPair(token1, token2);
2315     }
2316 
2317     function setClearingTime(
2318         address token1,
2319         address token2,
2320         uint auctionIndex,
2321         uint auctionStart,
2322         uint sellVolume,
2323         uint buyVolume
2324     )
2325         internal
2326     {
2327         (uint pastNum, uint pastDen) = getPriceInPastAuction(token1, token2, auctionIndex - 1);
2328         // timeElapsed = (12 hours)*(2 * pastNum * sellVolume - buyVolume * pastDen)/
2329             // (sellVolume * pastNum + buyVolume * pastDen)
2330         uint numerator = sub(mul(mul(pastNum, sellVolume), 24 hours), mul(mul(buyVolume, pastDen), 12 hours));
2331         uint timeElapsed = numerator / (add(mul(sellVolume, pastNum), mul(buyVolume, pastDen)));
2332         uint clearingTime = auctionStart + timeElapsed;
2333         (token1, token2) = getTokenOrder(token1, token2);
2334         clearingTimes[token1][token2][auctionIndex] = clearingTime;
2335     }
2336 
2337     function getClearingTime(
2338         address token1,
2339         address token2,
2340         uint auctionIndex
2341     )
2342         public
2343         view
2344         returns (uint time)
2345     {
2346         (token1, token2) = getTokenOrder(token1, token2);
2347         time = clearingTimes[token1][token2][auctionIndex];
2348     }
2349 
2350     function issueFrts(
2351         address primaryToken,
2352         address secondaryToken,
2353         uint x,
2354         uint auctionIndex,
2355         uint bal,
2356         address user
2357     )
2358         internal
2359         returns (uint frtsIssued)
2360     {
2361         if (approvedTokens[primaryToken] && approvedTokens[secondaryToken]) {
2362             address ethTokenMem = ethToken;
2363             // Get frts issued based on ETH price of returned tokens
2364             if (primaryToken == ethTokenMem) {
2365                 frtsIssued = bal;
2366             } else if (secondaryToken == ethTokenMem) {
2367                 // 10^30 * 10^39 = 10^66
2368                 frtsIssued = x;
2369             } else {
2370                 // Neither token is ethToken, so we use getHhistoricalPriceOracle()
2371                 uint pastNum;
2372                 uint pastDen;
2373                 (pastNum, pastDen) = getPriceInPastAuction(primaryToken, ethTokenMem, auctionIndex - 1);
2374                 // 10^30 * 10^35 = 10^65
2375                 frtsIssued = mul(bal, pastNum) / pastDen;
2376             }
2377 
2378             if (frtsIssued > 0) {
2379                 // Issue frtToken
2380                 frtToken.mintTokens(user, frtsIssued);
2381             }
2382         }
2383     }
2384 
2385     function settleFee(address primaryToken, address secondaryToken, uint auctionIndex, uint amount)
2386         internal
2387         returns (
2388         // < 10^30
2389         uint amountAfterFee
2390     )
2391     {
2392         uint feeNum;
2393         uint feeDen;
2394         (feeNum, feeDen) = getFeeRatio(msg.sender);
2395         // 10^30 * 10^3 / 10^4 = 10^29
2396         uint fee = mul(amount, feeNum) / feeDen;
2397 
2398         if (fee > 0) {
2399             fee = settleFeeSecondPart(primaryToken, fee);
2400 
2401             uint usersExtraTokens = extraTokens[primaryToken][secondaryToken][auctionIndex + 1];
2402             extraTokens[primaryToken][secondaryToken][auctionIndex + 1] = add(usersExtraTokens, fee);
2403 
2404             emit Fee(primaryToken, secondaryToken, msg.sender, auctionIndex, fee);
2405         }
2406 
2407         amountAfterFee = sub(amount, fee);
2408     }
2409 
2410     function settleFeeSecondPart(address primaryToken, uint fee) internal returns (uint newFee) {
2411         // Allow user to reduce up to half of the fee with owlToken
2412         uint num;
2413         uint den;
2414         (num, den) = getPriceOfTokenInLastAuction(primaryToken);
2415 
2416         // Convert fee to ETH, then USD
2417         // 10^29 * 10^30 / 10^30 = 10^29
2418         uint feeInETH = mul(fee, num) / den;
2419 
2420         uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();
2421         // 10^29 * 10^6 = 10^35
2422         // Uses 18 decimal places <> exactly as owlToken tokens: 10**18 owlToken == 1 USD
2423         uint feeInUSD = mul(feeInETH, ethUSDPrice);
2424         uint amountOfowlTokenBurned = min(owlToken.allowance(msg.sender, address(this)), feeInUSD / 2);
2425         amountOfowlTokenBurned = min(owlToken.balanceOf(msg.sender), amountOfowlTokenBurned);
2426 
2427         if (amountOfowlTokenBurned > 0) {
2428             owlToken.burnOWL(msg.sender, amountOfowlTokenBurned);
2429             // Adjust fee
2430             // 10^35 * 10^29 = 10^64
2431             uint adjustment = mul(amountOfowlTokenBurned, fee) / feeInUSD;
2432             newFee = sub(fee, adjustment);
2433         } else {
2434             newFee = fee;
2435         }
2436     }
2437 
2438     // addClearTimes
2439     /// @dev clears an Auction
2440     /// @param sellToken sellToken of the auction
2441     /// @param buyToken  buyToken of the auction
2442     /// @param auctionIndex of the auction to be cleared.
2443     function clearAuction(
2444         address sellToken,
2445         address buyToken,
2446         uint auctionIndex,
2447         uint sellVolume
2448     )
2449         internal
2450     {
2451         // Get variables
2452         uint buyVolume = buyVolumes[sellToken][buyToken];
2453         uint sellVolumeOpp = sellVolumesCurrent[buyToken][sellToken];
2454         uint closingPriceOppDen = closingPrices[buyToken][sellToken][auctionIndex].den;
2455         uint auctionStart = getAuctionStart(sellToken, buyToken);
2456 
2457         // Update closing price
2458         if (sellVolume > 0) {
2459             closingPrices[sellToken][buyToken][auctionIndex] = Fraction(buyVolume, sellVolume);
2460         }
2461 
2462         // if (opposite is 0 auction OR price = 0 OR opposite auction cleared)
2463         // price = 0 happens if auction pair has been running for >= 24 hrs
2464         if (sellVolumeOpp == 0 || now >= auctionStart + 24 hours || closingPriceOppDen > 0) {
2465             // Close auction pair
2466             uint buyVolumeOpp = buyVolumes[buyToken][sellToken];
2467             if (closingPriceOppDen == 0 && sellVolumeOpp > 0) {
2468                 // Save opposite price
2469                 closingPrices[buyToken][sellToken][auctionIndex] = Fraction(buyVolumeOpp, sellVolumeOpp);
2470             }
2471 
2472             uint sellVolumeNext = sellVolumesNext[sellToken][buyToken];
2473             uint sellVolumeNextOpp = sellVolumesNext[buyToken][sellToken];
2474 
2475             // Update state variables for both auctions
2476             sellVolumesCurrent[sellToken][buyToken] = sellVolumeNext;
2477             if (sellVolumeNext > 0) {
2478                 sellVolumesNext[sellToken][buyToken] = 0;
2479             }
2480             if (buyVolume > 0) {
2481                 buyVolumes[sellToken][buyToken] = 0;
2482             }
2483 
2484             sellVolumesCurrent[buyToken][sellToken] = sellVolumeNextOpp;
2485             if (sellVolumeNextOpp > 0) {
2486                 sellVolumesNext[buyToken][sellToken] = 0;
2487             }
2488             if (buyVolumeOpp > 0) {
2489                 buyVolumes[buyToken][sellToken] = 0;
2490             }
2491 
2492             // Save clearing time
2493             setClearingTime(sellToken, buyToken, auctionIndex, auctionStart, sellVolume, buyVolume);
2494             // Increment auction index
2495             setAuctionIndex(sellToken, buyToken);
2496             // Check if next auction can be scheduled
2497             scheduleNextAuction(sellToken, buyToken);
2498         }
2499 
2500         emit AuctionCleared(sellToken, buyToken, sellVolume, buyVolume, auctionIndex);
2501     }
2502 
2503     function setAuctionStart(address token1, address token2, uint value) internal {
2504         (token1, token2) = getTokenOrder(token1, token2);
2505         uint auctionStart = now + value;
2506         uint auctionIndex = latestAuctionIndices[token1][token2];
2507         auctionStarts[token1][token2] = auctionStart;
2508         emit AuctionStartScheduled(token1, token2, auctionIndex, auctionStart);
2509     }
2510 
2511     function resetAuctionStart(address token1, address token2) internal {
2512         (token1, token2) = getTokenOrder(token1, token2);
2513         if (auctionStarts[token1][token2] != AUCTION_START_WAITING_FOR_FUNDING) {
2514             auctionStarts[token1][token2] = AUCTION_START_WAITING_FOR_FUNDING;
2515         }
2516     }
2517 
2518     function setAuctionIndex(address token1, address token2) internal {
2519         (token1, token2) = getTokenOrder(token1, token2);
2520         latestAuctionIndices[token1][token2] += 1;
2521     }
2522 
2523     function checkLengthsForSeveralAuctionClaiming(
2524         address[] memory auctionSellTokens,
2525         address[] memory auctionBuyTokens,
2526         uint[] memory auctionIndices
2527     ) internal pure returns (uint length)
2528     {
2529         length = auctionSellTokens.length;
2530         uint length2 = auctionBuyTokens.length;
2531         require(length == length2);
2532 
2533         uint length3 = auctionIndices.length;
2534         require(length2 == length3);
2535     }
2536 
2537     // > Events
2538     event NewDeposit(address indexed token, uint amount);
2539 
2540     event NewWithdrawal(address indexed token, uint amount);
2541 
2542     event NewSellOrder(
2543         address indexed sellToken,
2544         address indexed buyToken,
2545         address indexed user,
2546         uint auctionIndex,
2547         uint amount
2548     );
2549 
2550     event NewBuyOrder(
2551         address indexed sellToken,
2552         address indexed buyToken,
2553         address indexed user,
2554         uint auctionIndex,
2555         uint amount
2556     );
2557 
2558     event NewSellerFundsClaim(
2559         address indexed sellToken,
2560         address indexed buyToken,
2561         address indexed user,
2562         uint auctionIndex,
2563         uint amount,
2564         uint frtsIssued
2565     );
2566 
2567     event NewBuyerFundsClaim(
2568         address indexed sellToken,
2569         address indexed buyToken,
2570         address indexed user,
2571         uint auctionIndex,
2572         uint amount,
2573         uint frtsIssued
2574     );
2575 
2576     event NewTokenPair(address indexed sellToken, address indexed buyToken);
2577 
2578     event AuctionCleared(
2579         address indexed sellToken,
2580         address indexed buyToken,
2581         uint sellVolume,
2582         uint buyVolume,
2583         uint indexed auctionIndex
2584     );
2585 
2586     event AuctionStartScheduled(
2587         address indexed sellToken,
2588         address indexed buyToken,
2589         uint indexed auctionIndex,
2590         uint auctionStart
2591     );
2592 
2593     event Fee(
2594         address indexed primaryToken,
2595         address indexed secondarToken,
2596         address indexed user,
2597         uint auctionIndex,
2598         uint fee
2599     );
2600 }