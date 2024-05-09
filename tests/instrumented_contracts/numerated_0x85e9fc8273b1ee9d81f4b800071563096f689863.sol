1 pragma solidity ^0.4.21;
2 
3 // File: @gnosis.pm/util-contracts/contracts/Math.sol
4 
5 /// @title Math library - Allows calculation of logarithmic and exponential functions
6 /// @author Alan Lu - <alan.lu@gnosis.pm>
7 /// @author Stefan George - <stefan@gnosis.pm>
8 library Math {
9 
10     /*
11      *  Constants
12      */
13     // This is equal to 1 in our calculations
14     uint public constant ONE =  0x10000000000000000;
15     uint public constant LN2 = 0xb17217f7d1cf79ac;
16     uint public constant LOG2_E = 0x171547652b82fe177;
17 
18     /*
19      *  Public functions
20      */
21     /// @dev Returns natural exponential function value of given x
22     /// @param x x
23     /// @return e**x
24     function exp(int x)
25         public
26         pure
27         returns (uint)
28     {
29         // revert if x is > MAX_POWER, where
30         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
31         require(x <= 2454971259878909886679);
32         // return 0 if exp(x) is tiny, using
33         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
34         if (x < -818323753292969962227)
35             return 0;
36         // Transform so that e^x -> 2^x
37         x = x * int(ONE) / int(LN2);
38         // 2^x = 2^whole(x) * 2^frac(x)
39         //       ^^^^^^^^^^ is a bit shift
40         // so Taylor expand on z = frac(x)
41         int shift;
42         uint z;
43         if (x >= 0) {
44             shift = x / int(ONE);
45             z = uint(x % int(ONE));
46         }
47         else {
48             shift = x / int(ONE) - 1;
49             z = ONE - uint(-x % int(ONE));
50         }
51         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
52         //
53         // Can generate the z coefficients using mpmath and the following lines
54         // >>> from mpmath import mp
55         // >>> mp.dps = 100
56         // >>> ONE =  0x10000000000000000
57         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
58         // 0xb17217f7d1cf79ab
59         // 0x3d7f7bff058b1d50
60         // 0xe35846b82505fc5
61         // 0x276556df749cee5
62         // 0x5761ff9e299cc4
63         // 0xa184897c363c3
64         uint zpow = z;
65         uint result = ONE;
66         result += 0xb17217f7d1cf79ab * zpow / ONE;
67         zpow = zpow * z / ONE;
68         result += 0x3d7f7bff058b1d50 * zpow / ONE;
69         zpow = zpow * z / ONE;
70         result += 0xe35846b82505fc5 * zpow / ONE;
71         zpow = zpow * z / ONE;
72         result += 0x276556df749cee5 * zpow / ONE;
73         zpow = zpow * z / ONE;
74         result += 0x5761ff9e299cc4 * zpow / ONE;
75         zpow = zpow * z / ONE;
76         result += 0xa184897c363c3 * zpow / ONE;
77         zpow = zpow * z / ONE;
78         result += 0xffe5fe2c4586 * zpow / ONE;
79         zpow = zpow * z / ONE;
80         result += 0x162c0223a5c8 * zpow / ONE;
81         zpow = zpow * z / ONE;
82         result += 0x1b5253d395e * zpow / ONE;
83         zpow = zpow * z / ONE;
84         result += 0x1e4cf5158b * zpow / ONE;
85         zpow = zpow * z / ONE;
86         result += 0x1e8cac735 * zpow / ONE;
87         zpow = zpow * z / ONE;
88         result += 0x1c3bd650 * zpow / ONE;
89         zpow = zpow * z / ONE;
90         result += 0x1816193 * zpow / ONE;
91         zpow = zpow * z / ONE;
92         result += 0x131496 * zpow / ONE;
93         zpow = zpow * z / ONE;
94         result += 0xe1b7 * zpow / ONE;
95         zpow = zpow * z / ONE;
96         result += 0x9c7 * zpow / ONE;
97         if (shift >= 0) {
98             if (result >> (256-shift) > 0)
99                 return (2**256-1);
100             return result << shift;
101         }
102         else
103             return result >> (-shift);
104     }
105 
106     /// @dev Returns natural logarithm value of given x
107     /// @param x x
108     /// @return ln(x)
109     function ln(uint x)
110         public
111         pure
112         returns (int)
113     {
114         require(x > 0);
115         // binary search for floor(log2(x))
116         int ilog2 = floorLog2(x);
117         int z;
118         if (ilog2 < 0)
119             z = int(x << uint(-ilog2));
120         else
121             z = int(x >> uint(ilog2));
122         // z = x * 2^-⌊log₂x⌋
123         // so 1 <= z < 2
124         // and ln z = ln x - ⌊log₂x⌋/log₂e
125         // so just compute ln z using artanh series
126         // and calculate ln x from that
127         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
128         int halflnz = term;
129         int termpow = term * term / int(ONE) * term / int(ONE);
130         halflnz += termpow / 3;
131         termpow = termpow * term / int(ONE) * term / int(ONE);
132         halflnz += termpow / 5;
133         termpow = termpow * term / int(ONE) * term / int(ONE);
134         halflnz += termpow / 7;
135         termpow = termpow * term / int(ONE) * term / int(ONE);
136         halflnz += termpow / 9;
137         termpow = termpow * term / int(ONE) * term / int(ONE);
138         halflnz += termpow / 11;
139         termpow = termpow * term / int(ONE) * term / int(ONE);
140         halflnz += termpow / 13;
141         termpow = termpow * term / int(ONE) * term / int(ONE);
142         halflnz += termpow / 15;
143         termpow = termpow * term / int(ONE) * term / int(ONE);
144         halflnz += termpow / 17;
145         termpow = termpow * term / int(ONE) * term / int(ONE);
146         halflnz += termpow / 19;
147         termpow = termpow * term / int(ONE) * term / int(ONE);
148         halflnz += termpow / 21;
149         termpow = termpow * term / int(ONE) * term / int(ONE);
150         halflnz += termpow / 23;
151         termpow = termpow * term / int(ONE) * term / int(ONE);
152         halflnz += termpow / 25;
153         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
154     }
155 
156     /// @dev Returns base 2 logarithm value of given x
157     /// @param x x
158     /// @return logarithmic value
159     function floorLog2(uint x)
160         public
161         pure
162         returns (int lo)
163     {
164         lo = -64;
165         int hi = 193;
166         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
167         int mid = (hi + lo) >> 1;
168         while((lo + 1) < hi) {
169             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE)
170                 hi = mid;
171             else
172                 lo = mid;
173             mid = (hi + lo) >> 1;
174         }
175     }
176 
177     /// @dev Returns maximum of an array
178     /// @param nums Numbers to look through
179     /// @return Maximum number
180     function max(int[] nums)
181         public
182         pure
183         returns (int maxNum)
184     {
185         require(nums.length > 0);
186         maxNum = -2**255;
187         for (uint i = 0; i < nums.length; i++)
188             if (nums[i] > maxNum)
189                 maxNum = nums[i];
190     }
191 
192     /// @dev Returns whether an add operation causes an overflow
193     /// @param a First addend
194     /// @param b Second addend
195     /// @return Did no overflow occur?
196     function safeToAdd(uint a, uint b)
197         internal
198         pure
199         returns (bool)
200     {
201         return a + b >= a;
202     }
203 
204     /// @dev Returns whether a subtraction operation causes an underflow
205     /// @param a Minuend
206     /// @param b Subtrahend
207     /// @return Did no underflow occur?
208     function safeToSub(uint a, uint b)
209         internal
210         pure
211         returns (bool)
212     {
213         return a >= b;
214     }
215 
216     /// @dev Returns whether a multiply operation causes an overflow
217     /// @param a First factor
218     /// @param b Second factor
219     /// @return Did no overflow occur?
220     function safeToMul(uint a, uint b)
221         internal
222         pure
223         returns (bool)
224     {
225         return b == 0 || a * b / b == a;
226     }
227 
228     /// @dev Returns sum if no overflow occurred
229     /// @param a First addend
230     /// @param b Second addend
231     /// @return Sum
232     function add(uint a, uint b)
233         internal
234         pure
235         returns (uint)
236     {
237         require(safeToAdd(a, b));
238         return a + b;
239     }
240 
241     /// @dev Returns difference if no overflow occurred
242     /// @param a Minuend
243     /// @param b Subtrahend
244     /// @return Difference
245     function sub(uint a, uint b)
246         internal
247         pure
248         returns (uint)
249     {
250         require(safeToSub(a, b));
251         return a - b;
252     }
253 
254     /// @dev Returns product if no overflow occurred
255     /// @param a First factor
256     /// @param b Second factor
257     /// @return Product
258     function mul(uint a, uint b)
259         internal
260         pure
261         returns (uint)
262     {
263         require(safeToMul(a, b));
264         return a * b;
265     }
266 
267     /// @dev Returns whether an add operation causes an overflow
268     /// @param a First addend
269     /// @param b Second addend
270     /// @return Did no overflow occur?
271     function safeToAdd(int a, int b)
272         internal
273         pure
274         returns (bool)
275     {
276         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
277     }
278 
279     /// @dev Returns whether a subtraction operation causes an underflow
280     /// @param a Minuend
281     /// @param b Subtrahend
282     /// @return Did no underflow occur?
283     function safeToSub(int a, int b)
284         internal
285         pure
286         returns (bool)
287     {
288         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
289     }
290 
291     /// @dev Returns whether a multiply operation causes an overflow
292     /// @param a First factor
293     /// @param b Second factor
294     /// @return Did no overflow occur?
295     function safeToMul(int a, int b)
296         internal
297         pure
298         returns (bool)
299     {
300         return (b == 0) || (a * b / b == a);
301     }
302 
303     /// @dev Returns sum if no overflow occurred
304     /// @param a First addend
305     /// @param b Second addend
306     /// @return Sum
307     function add(int a, int b)
308         internal
309         pure
310         returns (int)
311     {
312         require(safeToAdd(a, b));
313         return a + b;
314     }
315 
316     /// @dev Returns difference if no overflow occurred
317     /// @param a Minuend
318     /// @param b Subtrahend
319     /// @return Difference
320     function sub(int a, int b)
321         internal
322         pure
323         returns (int)
324     {
325         require(safeToSub(a, b));
326         return a - b;
327     }
328 
329     /// @dev Returns product if no overflow occurred
330     /// @param a First factor
331     /// @param b Second factor
332     /// @return Product
333     function mul(int a, int b)
334         internal
335         pure
336         returns (int)
337     {
338         require(safeToMul(a, b));
339         return a * b;
340     }
341 }
342 
343 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
344 
345 /// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
346 /// @author Alan Lu - <alan@gnosis.pm>
347 contract Proxied {
348     address public masterCopy;
349 }
350 
351 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
352 /// @author Stefan George - <stefan@gnosis.pm>
353 contract Proxy is Proxied {
354     /// @dev Constructor function sets address of master copy contract.
355     /// @param _masterCopy Master copy address.
356     function Proxy(address _masterCopy)
357         public
358     {
359         require(_masterCopy != 0);
360         masterCopy = _masterCopy;
361     }
362 
363     /// @dev Fallback function forwards all transactions and returns all received return data.
364     function ()
365         external
366         payable
367     {
368         address _masterCopy = masterCopy;
369         assembly {
370             calldatacopy(0, 0, calldatasize())
371             let success := delegatecall(not(0), _masterCopy, 0, calldatasize(), 0, 0)
372             returndatacopy(0, 0, returndatasize())
373             switch success
374             case 0 { revert(0, returndatasize()) }
375             default { return(0, returndatasize()) }
376         }
377     }
378 }
379 
380 // File: @gnosis.pm/util-contracts/contracts/Token.sol
381 
382 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
383 pragma solidity ^0.4.21;
384 
385 
386 /// @title Abstract token contract - Functions to be implemented by token contracts
387 contract Token {
388 
389     /*
390      *  Events
391      */
392     event Transfer(address indexed from, address indexed to, uint value);
393     event Approval(address indexed owner, address indexed spender, uint value);
394 
395     /*
396      *  Public functions
397      */
398     function transfer(address to, uint value) public returns (bool);
399     function transferFrom(address from, address to, uint value) public returns (bool);
400     function approve(address spender, uint value) public returns (bool);
401     function balanceOf(address owner) public view returns (uint);
402     function allowance(address owner, address spender) public view returns (uint);
403     function totalSupply() public view returns (uint);
404 }
405 
406 // File: @gnosis.pm/util-contracts/contracts/StandardToken.sol
407 
408 contract StandardTokenData {
409 
410     /*
411      *  Storage
412      */
413     mapping (address => uint) balances;
414     mapping (address => mapping (address => uint)) allowances;
415     uint totalTokens;
416 }
417 
418 /// @title Standard token contract with overflow protection
419 contract StandardToken is Token, StandardTokenData {
420     using Math for *;
421 
422     /*
423      *  Public functions
424      */
425     /// @dev Transfers sender's tokens to a given address. Returns success
426     /// @param to Address of token receiver
427     /// @param value Number of tokens to transfer
428     /// @return Was transfer successful?
429     function transfer(address to, uint value)
430         public
431         returns (bool)
432     {
433         if (   !balances[msg.sender].safeToSub(value)
434             || !balances[to].safeToAdd(value))
435             return false;
436         balances[msg.sender] -= value;
437         balances[to] += value;
438         emit Transfer(msg.sender, to, value);
439         return true;
440     }
441 
442     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
443     /// @param from Address from where tokens are withdrawn
444     /// @param to Address to where tokens are sent
445     /// @param value Number of tokens to transfer
446     /// @return Was transfer successful?
447     function transferFrom(address from, address to, uint value)
448         public
449         returns (bool)
450     {
451         if (   !balances[from].safeToSub(value)
452             || !allowances[from][msg.sender].safeToSub(value)
453             || !balances[to].safeToAdd(value))
454             return false;
455         balances[from] -= value;
456         allowances[from][msg.sender] -= value;
457         balances[to] += value;
458         emit Transfer(from, to, value);
459         return true;
460     }
461 
462     /// @dev Sets approved amount of tokens for spender. Returns success
463     /// @param spender Address of allowed account
464     /// @param value Number of approved tokens
465     /// @return Was approval successful?
466     function approve(address spender, uint value)
467         public
468         returns (bool)
469     {
470         allowances[msg.sender][spender] = value;
471         emit Approval(msg.sender, spender, value);
472         return true;
473     }
474 
475     /// @dev Returns number of allowed tokens for given address
476     /// @param owner Address of token owner
477     /// @param spender Address of token spender
478     /// @return Remaining allowance for spender
479     function allowance(address owner, address spender)
480         public
481         view
482         returns (uint)
483     {
484         return allowances[owner][spender];
485     }
486 
487     /// @dev Returns number of tokens owned by given address
488     /// @param owner Address of token owner
489     /// @return Balance of owner
490     function balanceOf(address owner)
491         public
492         view
493         returns (uint)
494     {
495         return balances[owner];
496     }
497 
498     /// @dev Returns total supply of tokens
499     /// @return Total supply
500     function totalSupply()
501         public
502         view
503         returns (uint)
504     {
505         return totalTokens;
506     }
507 }
508 
509 // File: contracts/TokenOWL.sol
510 
511 contract TokenOWL is Proxied, StandardToken {
512     using Math for *;
513 
514     string public constant name = "OWL Token";
515     string public constant symbol = "OWL";
516     uint8 public constant decimals = 18;
517 
518     struct masterCopyCountdownType {
519         address masterCopy;
520         uint timeWhenAvailable;
521     }
522 
523     masterCopyCountdownType masterCopyCountdown;
524 
525     address public creator;
526     address public minter;
527 
528     event Minted(address indexed to, uint256 amount);
529     event Burnt(address indexed from, address indexed user, uint256 amount);
530 
531     modifier onlyCreator() {
532         // R1
533         require(msg.sender == creator);
534         _;
535     }
536     /// @dev trickers the update process via the proxyMaster for a new address _masterCopy 
537     /// updating is only possible after 30 days
538     function startMasterCopyCountdown (
539         address _masterCopy
540      )
541         public
542         onlyCreator()
543     {
544         require(address(_masterCopy) != 0);
545 
546         // Update masterCopyCountdown
547         masterCopyCountdown.masterCopy = _masterCopy;
548         masterCopyCountdown.timeWhenAvailable = now + 30 days;
549     }
550 
551      /// @dev executes the update process via the proxyMaster for a new address _masterCopy
552     function updateMasterCopy()
553         public
554         onlyCreator()
555     {   
556         require(address(masterCopyCountdown.masterCopy) != 0);
557         require(now >= masterCopyCountdown.timeWhenAvailable);
558 
559         // Update masterCopy
560         masterCopy = masterCopyCountdown.masterCopy;
561     }
562 
563     function getMasterCopy()
564         public
565         view
566         returns (address)
567     {
568         return masterCopy;
569     }
570 
571     /// @dev Set minter. Only the creator of this contract can call this.
572     /// @param newMinter The new address authorized to mint this token
573     function setMinter(address newMinter)
574         public
575         onlyCreator()
576     {
577         minter = newMinter;
578     }
579 
580 
581     /// @dev change owner/creator of the contract. Only the creator/owner of this contract can call this.
582     /// @param newOwner The new address, which should become the owner
583     function setNewOwner(address newOwner)
584         public
585         onlyCreator()
586     {
587         creator = newOwner;
588     }
589 
590     /// @dev Mints OWL.
591     /// @param to Address to which the minted token will be given
592     /// @param amount Amount of OWL to be minted
593     function mintOWL(address to, uint amount)
594         public
595     {
596         require(minter != 0 && msg.sender == minter);
597         balances[to] = balances[to].add(amount);
598         totalTokens = totalTokens.add(amount);
599         emit Minted(to, amount);
600     }
601 
602     /// @dev Burns OWL.
603     /// @param user Address of OWL owner
604     /// @param amount Amount of OWL to be burnt
605     function burnOWL(address user, uint amount)
606         public
607     {
608         allowances[user][msg.sender] = allowances[user][msg.sender].sub(amount);
609         balances[user] = balances[user].sub(amount);
610         totalTokens = totalTokens.sub(amount);
611         emit Burnt(msg.sender, user, amount);
612     }
613 }
614 
615 // File: @gnosis.pm/gno-token/contracts/TokenGNO.sol
616 
617 contract TokenGNO is StandardToken {
618     string public constant symbol = "GNO";
619     string public constant name = "Gnosis";
620     uint8 public constant decimals = 18;
621 
622     function TokenGNO(
623     	uint amount
624     )
625     	public 
626     {
627         totalTokens = amount;
628     	balances[msg.sender] = amount;
629     }
630 }
631 
632 // File: contracts/OWLAirdrop.sol
633 
634 contract OWLAirdrop {
635     using Math for *;
636 
637     TokenOWL public tokenOWL;
638     TokenGNO public tokenGNO;
639     mapping(address => uint) public lockedGNO;
640     uint public endTime;
641 
642     /// @dev Creates and starts the airdrop
643     /// @param _tokenOWL The OWL token contract
644     /// @param _tokenGNO The GNO token contract
645     /// @param _endTime The unix epoch timestamp in seconds of the time airdrop ends
646     function OWLAirdrop(TokenOWL _tokenOWL, TokenGNO _tokenGNO, uint _endTime)
647         public
648     {
649         require(now <= _endTime);
650         tokenOWL = _tokenOWL;
651         tokenGNO = _tokenGNO;
652         endTime = _endTime;
653     }
654 
655     /// @dev Locks GNO inside this contract and mints OWL for GNO if endTime is not past
656     /// @param amount Amount of GNO to lock
657     function lockGNO(uint amount)
658         public
659     {
660         require(now <= endTime && tokenGNO.transferFrom(msg.sender, this, amount));
661         lockedGNO[msg.sender] = lockedGNO[msg.sender].add(amount);
662         tokenOWL.mintOWL(msg.sender, amount.mul(10));
663     }
664 
665     /// @dev Withdraws locked GNO if endTime is past
666     function withdrawGNO()
667         public
668     {
669         require(now > endTime && tokenGNO.transfer(msg.sender, lockedGNO[msg.sender]));
670         lockedGNO[msg.sender] = 0;
671     }
672 }