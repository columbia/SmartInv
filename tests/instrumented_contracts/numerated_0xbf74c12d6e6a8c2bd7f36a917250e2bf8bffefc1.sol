1 
2 // File: @gnosis.pm/util-contracts/contracts/Token.sol
3 
4 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
5 pragma solidity ^0.5.2;
6 
7 /// @title Abstract token contract - Functions to be implemented by token contracts
8 contract Token {
9     /*
10      *  Events
11      */
12     event Transfer(address indexed from, address indexed to, uint value);
13     event Approval(address indexed owner, address indexed spender, uint value);
14 
15     /*
16      *  Public functions
17      */
18     function transfer(address to, uint value) public returns (bool);
19     function transferFrom(address from, address to, uint value) public returns (bool);
20     function approve(address spender, uint value) public returns (bool);
21     function balanceOf(address owner) public view returns (uint);
22     function allowance(address owner, address spender) public view returns (uint);
23     function totalSupply() public view returns (uint);
24 }
25 
26 // File: @gnosis.pm/util-contracts/contracts/Math.sol
27 
28 pragma solidity ^0.5.2;
29 
30 /// @title Math library - Allows calculation of logarithmic and exponential functions
31 /// @author Alan Lu - <alan.lu@gnosis.pm>
32 /// @author Stefan George - <stefan@gnosis.pm>
33 library GnosisMath {
34     /*
35      *  Constants
36      */
37     // This is equal to 1 in our calculations
38     uint public constant ONE = 0x10000000000000000;
39     uint public constant LN2 = 0xb17217f7d1cf79ac;
40     uint public constant LOG2_E = 0x171547652b82fe177;
41 
42     /*
43      *  Public functions
44      */
45     /// @dev Returns natural exponential function value of given x
46     /// @param x x
47     /// @return e**x
48     function exp(int x) public pure returns (uint) {
49         // revert if x is > MAX_POWER, where
50         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
51         require(x <= 2454971259878909886679);
52         // return 0 if exp(x) is tiny, using
53         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
54         if (x < -818323753292969962227) return 0;
55         // Transform so that e^x -> 2^x
56         x = x * int(ONE) / int(LN2);
57         // 2^x = 2^whole(x) * 2^frac(x)
58         //       ^^^^^^^^^^ is a bit shift
59         // so Taylor expand on z = frac(x)
60         int shift;
61         uint z;
62         if (x >= 0) {
63             shift = x / int(ONE);
64             z = uint(x % int(ONE));
65         } else {
66             shift = x / int(ONE) - 1;
67             z = ONE - uint(-x % int(ONE));
68         }
69         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
70         //
71         // Can generate the z coefficients using mpmath and the following lines
72         // >>> from mpmath import mp
73         // >>> mp.dps = 100
74         // >>> ONE =  0x10000000000000000
75         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
76         // 0xb17217f7d1cf79ab
77         // 0x3d7f7bff058b1d50
78         // 0xe35846b82505fc5
79         // 0x276556df749cee5
80         // 0x5761ff9e299cc4
81         // 0xa184897c363c3
82         uint zpow = z;
83         uint result = ONE;
84         result += 0xb17217f7d1cf79ab * zpow / ONE;
85         zpow = zpow * z / ONE;
86         result += 0x3d7f7bff058b1d50 * zpow / ONE;
87         zpow = zpow * z / ONE;
88         result += 0xe35846b82505fc5 * zpow / ONE;
89         zpow = zpow * z / ONE;
90         result += 0x276556df749cee5 * zpow / ONE;
91         zpow = zpow * z / ONE;
92         result += 0x5761ff9e299cc4 * zpow / ONE;
93         zpow = zpow * z / ONE;
94         result += 0xa184897c363c3 * zpow / ONE;
95         zpow = zpow * z / ONE;
96         result += 0xffe5fe2c4586 * zpow / ONE;
97         zpow = zpow * z / ONE;
98         result += 0x162c0223a5c8 * zpow / ONE;
99         zpow = zpow * z / ONE;
100         result += 0x1b5253d395e * zpow / ONE;
101         zpow = zpow * z / ONE;
102         result += 0x1e4cf5158b * zpow / ONE;
103         zpow = zpow * z / ONE;
104         result += 0x1e8cac735 * zpow / ONE;
105         zpow = zpow * z / ONE;
106         result += 0x1c3bd650 * zpow / ONE;
107         zpow = zpow * z / ONE;
108         result += 0x1816193 * zpow / ONE;
109         zpow = zpow * z / ONE;
110         result += 0x131496 * zpow / ONE;
111         zpow = zpow * z / ONE;
112         result += 0xe1b7 * zpow / ONE;
113         zpow = zpow * z / ONE;
114         result += 0x9c7 * zpow / ONE;
115         if (shift >= 0) {
116             if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
117             return result << shift;
118         } else return result >> (-shift);
119     }
120 
121     /// @dev Returns natural logarithm value of given x
122     /// @param x x
123     /// @return ln(x)
124     function ln(uint x) public pure returns (int) {
125         require(x > 0);
126         // binary search for floor(log2(x))
127         int ilog2 = floorLog2(x);
128         int z;
129         if (ilog2 < 0) z = int(x << uint(-ilog2));
130         else z = int(x >> uint(ilog2));
131         // z = x * 2^-⌊log₂x⌋
132         // so 1 <= z < 2
133         // and ln z = ln x - ⌊log₂x⌋/log₂e
134         // so just compute ln z using artanh series
135         // and calculate ln x from that
136         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
137         int halflnz = term;
138         int termpow = term * term / int(ONE) * term / int(ONE);
139         halflnz += termpow / 3;
140         termpow = termpow * term / int(ONE) * term / int(ONE);
141         halflnz += termpow / 5;
142         termpow = termpow * term / int(ONE) * term / int(ONE);
143         halflnz += termpow / 7;
144         termpow = termpow * term / int(ONE) * term / int(ONE);
145         halflnz += termpow / 9;
146         termpow = termpow * term / int(ONE) * term / int(ONE);
147         halflnz += termpow / 11;
148         termpow = termpow * term / int(ONE) * term / int(ONE);
149         halflnz += termpow / 13;
150         termpow = termpow * term / int(ONE) * term / int(ONE);
151         halflnz += termpow / 15;
152         termpow = termpow * term / int(ONE) * term / int(ONE);
153         halflnz += termpow / 17;
154         termpow = termpow * term / int(ONE) * term / int(ONE);
155         halflnz += termpow / 19;
156         termpow = termpow * term / int(ONE) * term / int(ONE);
157         halflnz += termpow / 21;
158         termpow = termpow * term / int(ONE) * term / int(ONE);
159         halflnz += termpow / 23;
160         termpow = termpow * term / int(ONE) * term / int(ONE);
161         halflnz += termpow / 25;
162         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
163     }
164 
165     /// @dev Returns base 2 logarithm value of given x
166     /// @param x x
167     /// @return logarithmic value
168     function floorLog2(uint x) public pure returns (int lo) {
169         lo = -64;
170         int hi = 193;
171         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
172         int mid = (hi + lo) >> 1;
173         while ((lo + 1) < hi) {
174             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
175             else lo = mid;
176             mid = (hi + lo) >> 1;
177         }
178     }
179 
180     /// @dev Returns maximum of an array
181     /// @param nums Numbers to look through
182     /// @return Maximum number
183     function max(int[] memory nums) public pure returns (int maxNum) {
184         require(nums.length > 0);
185         maxNum = -2 ** 255;
186         for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
187     }
188 
189     /// @dev Returns whether an add operation causes an overflow
190     /// @param a First addend
191     /// @param b Second addend
192     /// @return Did no overflow occur?
193     function safeToAdd(uint a, uint b) internal pure returns (bool) {
194         return a + b >= a;
195     }
196 
197     /// @dev Returns whether a subtraction operation causes an underflow
198     /// @param a Minuend
199     /// @param b Subtrahend
200     /// @return Did no underflow occur?
201     function safeToSub(uint a, uint b) internal pure returns (bool) {
202         return a >= b;
203     }
204 
205     /// @dev Returns whether a multiply operation causes an overflow
206     /// @param a First factor
207     /// @param b Second factor
208     /// @return Did no overflow occur?
209     function safeToMul(uint a, uint b) internal pure returns (bool) {
210         return b == 0 || a * b / b == a;
211     }
212 
213     /// @dev Returns sum if no overflow occurred
214     /// @param a First addend
215     /// @param b Second addend
216     /// @return Sum
217     function add(uint a, uint b) internal pure returns (uint) {
218         require(safeToAdd(a, b));
219         return a + b;
220     }
221 
222     /// @dev Returns difference if no overflow occurred
223     /// @param a Minuend
224     /// @param b Subtrahend
225     /// @return Difference
226     function sub(uint a, uint b) internal pure returns (uint) {
227         require(safeToSub(a, b));
228         return a - b;
229     }
230 
231     /// @dev Returns product if no overflow occurred
232     /// @param a First factor
233     /// @param b Second factor
234     /// @return Product
235     function mul(uint a, uint b) internal pure returns (uint) {
236         require(safeToMul(a, b));
237         return a * b;
238     }
239 
240     /// @dev Returns whether an add operation causes an overflow
241     /// @param a First addend
242     /// @param b Second addend
243     /// @return Did no overflow occur?
244     function safeToAdd(int a, int b) internal pure returns (bool) {
245         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
246     }
247 
248     /// @dev Returns whether a subtraction operation causes an underflow
249     /// @param a Minuend
250     /// @param b Subtrahend
251     /// @return Did no underflow occur?
252     function safeToSub(int a, int b) internal pure returns (bool) {
253         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
254     }
255 
256     /// @dev Returns whether a multiply operation causes an overflow
257     /// @param a First factor
258     /// @param b Second factor
259     /// @return Did no overflow occur?
260     function safeToMul(int a, int b) internal pure returns (bool) {
261         return (b == 0) || (a * b / b == a);
262     }
263 
264     /// @dev Returns sum if no overflow occurred
265     /// @param a First addend
266     /// @param b Second addend
267     /// @return Sum
268     function add(int a, int b) internal pure returns (int) {
269         require(safeToAdd(a, b));
270         return a + b;
271     }
272 
273     /// @dev Returns difference if no overflow occurred
274     /// @param a Minuend
275     /// @param b Subtrahend
276     /// @return Difference
277     function sub(int a, int b) internal pure returns (int) {
278         require(safeToSub(a, b));
279         return a - b;
280     }
281 
282     /// @dev Returns product if no overflow occurred
283     /// @param a First factor
284     /// @param b Second factor
285     /// @return Product
286     function mul(int a, int b) internal pure returns (int) {
287         require(safeToMul(a, b));
288         return a * b;
289     }
290 }
291 
292 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
293 
294 pragma solidity ^0.5.2;
295 
296 /// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
297 /// @author Alan Lu - <alan@gnosis.pm>
298 contract Proxied {
299     address public masterCopy;
300 }
301 
302 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
303 /// @author Stefan George - <stefan@gnosis.pm>
304 contract Proxy is Proxied {
305     /// @dev Constructor function sets address of master copy contract.
306     /// @param _masterCopy Master copy address.
307     constructor(address _masterCopy) public {
308         require(_masterCopy != address(0), "The master copy is required");
309         masterCopy = _masterCopy;
310     }
311 
312     /// @dev Fallback function forwards all transactions and returns all received return data.
313     function() external payable {
314         address _masterCopy = masterCopy;
315         assembly {
316             calldatacopy(0, 0, calldatasize)
317             let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
318             returndatacopy(0, 0, returndatasize)
319             switch success
320                 case 0 {
321                     revert(0, returndatasize)
322                 }
323                 default {
324                     return(0, returndatasize)
325                 }
326         }
327     }
328 }
329 
330 // File: @gnosis.pm/util-contracts/contracts/GnosisStandardToken.sol
331 
332 pragma solidity ^0.5.2;
333 
334 
335 
336 
337 /**
338  * Deprecated: Use Open Zeppeling one instead
339  */
340 contract StandardTokenData {
341     /*
342      *  Storage
343      */
344     mapping(address => uint) balances;
345     mapping(address => mapping(address => uint)) allowances;
346     uint totalTokens;
347 }
348 
349 /**
350  * Deprecated: Use Open Zeppeling one instead
351  */
352 /// @title Standard token contract with overflow protection
353 contract GnosisStandardToken is Token, StandardTokenData {
354     using GnosisMath for *;
355 
356     /*
357      *  Public functions
358      */
359     /// @dev Transfers sender's tokens to a given address. Returns success
360     /// @param to Address of token receiver
361     /// @param value Number of tokens to transfer
362     /// @return Was transfer successful?
363     function transfer(address to, uint value) public returns (bool) {
364         if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
365             return false;
366         }
367 
368         balances[msg.sender] -= value;
369         balances[to] += value;
370         emit Transfer(msg.sender, to, value);
371         return true;
372     }
373 
374     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
375     /// @param from Address from where tokens are withdrawn
376     /// @param to Address to where tokens are sent
377     /// @param value Number of tokens to transfer
378     /// @return Was transfer successful?
379     function transferFrom(address from, address to, uint value) public returns (bool) {
380         if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
381             value
382         ) || !balances[to].safeToAdd(value)) {
383             return false;
384         }
385         balances[from] -= value;
386         allowances[from][msg.sender] -= value;
387         balances[to] += value;
388         emit Transfer(from, to, value);
389         return true;
390     }
391 
392     /// @dev Sets approved amount of tokens for spender. Returns success
393     /// @param spender Address of allowed account
394     /// @param value Number of approved tokens
395     /// @return Was approval successful?
396     function approve(address spender, uint value) public returns (bool) {
397         allowances[msg.sender][spender] = value;
398         emit Approval(msg.sender, spender, value);
399         return true;
400     }
401 
402     /// @dev Returns number of allowed tokens for given address
403     /// @param owner Address of token owner
404     /// @param spender Address of token spender
405     /// @return Remaining allowance for spender
406     function allowance(address owner, address spender) public view returns (uint) {
407         return allowances[owner][spender];
408     }
409 
410     /// @dev Returns number of tokens owned by given address
411     /// @param owner Address of token owner
412     /// @return Balance of owner
413     function balanceOf(address owner) public view returns (uint) {
414         return balances[owner];
415     }
416 
417     /// @dev Returns total supply of tokens
418     /// @return Total supply
419     function totalSupply() public view returns (uint) {
420         return totalTokens;
421     }
422 }
423 
424 // File: @gnosis.pm/gno-token/contracts/TokenGNO.sol
425 
426 pragma solidity ^0.5.2;
427 
428 
429 contract TokenGNO is GnosisStandardToken {
430     string public constant symbol = "GNO";
431     string public constant name = "Gnosis";
432     uint8 public constant decimals = 18;
433 
434     constructor(uint amount) public {
435         totalTokens = amount;
436         balances[msg.sender] = amount;
437     }
438 }
439 
440 // File: contracts/TokenOWL.sol
441 
442 pragma solidity ^0.5.2;
443 
444 
445 
446 
447 contract TokenOWL is Proxied, GnosisStandardToken {
448     using GnosisMath for *;
449 
450     string public constant name = "OWL Token";
451     string public constant symbol = "OWL";
452     uint8 public constant decimals = 18;
453 
454     struct masterCopyCountdownType {
455         address masterCopy;
456         uint timeWhenAvailable;
457     }
458 
459     masterCopyCountdownType masterCopyCountdown;
460 
461     address public creator;
462     address public minter;
463 
464     event Minted(address indexed to, uint256 amount);
465     event Burnt(address indexed from, address indexed user, uint256 amount);
466 
467     modifier onlyCreator() {
468         // R1
469         require(msg.sender == creator, "Only the creator can perform the transaction");
470         _;
471     }
472     /// @dev trickers the update process via the proxyMaster for a new address _masterCopy
473     /// updating is only possible after 30 days
474     function startMasterCopyCountdown(address _masterCopy) public onlyCreator {
475         require(address(_masterCopy) != address(0), "The master copy must be a valid address");
476 
477         // Update masterCopyCountdown
478         masterCopyCountdown.masterCopy = _masterCopy;
479         masterCopyCountdown.timeWhenAvailable = now + 30 days;
480     }
481 
482     /// @dev executes the update process via the proxyMaster for a new address _masterCopy
483     function updateMasterCopy() public onlyCreator {
484         require(address(masterCopyCountdown.masterCopy) != address(0), "The master copy must be a valid address");
485         require(
486             block.timestamp >= masterCopyCountdown.timeWhenAvailable,
487             "It's not possible to update the master copy during the waiting period"
488         );
489 
490         // Update masterCopy
491         masterCopy = masterCopyCountdown.masterCopy;
492     }
493 
494     function getMasterCopy() public view returns (address) {
495         return masterCopy;
496     }
497 
498     /// @dev Set minter. Only the creator of this contract can call this.
499     /// @param newMinter The new address authorized to mint this token
500     function setMinter(address newMinter) public onlyCreator {
501         minter = newMinter;
502     }
503 
504     /// @dev change owner/creator of the contract. Only the creator/owner of this contract can call this.
505     /// @param newOwner The new address, which should become the owner
506     function setNewOwner(address newOwner) public onlyCreator {
507         creator = newOwner;
508     }
509 
510     /// @dev Mints OWL.
511     /// @param to Address to which the minted token will be given
512     /// @param amount Amount of OWL to be minted
513     function mintOWL(address to, uint amount) public {
514         require(minter != address(0), "The minter must be initialized");
515         require(msg.sender == minter, "Only the minter can mint OWL");
516         balances[to] = balances[to].add(amount);
517         totalTokens = totalTokens.add(amount);
518         emit Minted(to, amount);
519         emit Transfer(address(0), to, amount);
520     }
521 
522     /// @dev Burns OWL.
523     /// @param user Address of OWL owner
524     /// @param amount Amount of OWL to be burnt
525     function burnOWL(address user, uint amount) public {
526         allowances[user][msg.sender] = allowances[user][msg.sender].sub(amount);
527         balances[user] = balances[user].sub(amount);
528         totalTokens = totalTokens.sub(amount);
529         emit Burnt(msg.sender, user, amount);
530         emit Transfer(user, address(0), amount);
531     }
532 }
533 
534 // File: contracts/OWLAirdrop.sol
535 
536 pragma solidity ^0.5.2;
537 
538 
539 
540 contract OWLAirdrop {
541     using GnosisMath for *;
542 
543     TokenOWL public tokenOWL;
544     TokenGNO public tokenGNO;
545     mapping(address => uint) public lockedGNO;
546     uint public endTime;
547     uint public multiplier;
548 
549     /// @dev Creates and starts the airdrop
550     /// @param _tokenOWL The OWL token contract
551     /// @param _tokenGNO The GNO token contract
552     /// @param _endTime The unix epoch timestamp in seconds of the time airdrop ends
553     constructor(TokenOWL _tokenOWL, TokenGNO _tokenGNO, uint _endTime, uint _multiplier) public {
554         require(block.timestamp <= _endTime, "The end time cannot be in the past");
555         tokenOWL = _tokenOWL;
556         tokenGNO = _tokenGNO;
557         endTime = _endTime;
558         multiplier = _multiplier;
559     }
560 
561     /// @dev Locks GNO inside this contract and mints OWL for GNO if endTime is not past
562     /// @param amount Amount of GNO to lock
563     function lockGNO(uint amount) public {
564         require(block.timestamp <= endTime, "The locking period has ended");
565         require(tokenGNO.transferFrom(msg.sender, address(this), amount), "The GNO transfer must succeed");
566         lockedGNO[msg.sender] = lockedGNO[msg.sender].add(amount);
567         tokenOWL.mintOWL(msg.sender, amount.mul(multiplier));
568     }
569 
570     /// @dev Withdraws locked GNO if endTime is past
571     function withdrawGNO() public {
572         require(block.timestamp > endTime, "It's not allowed to withdraw during the locking time");
573         require(tokenGNO.transfer(msg.sender, lockedGNO[msg.sender]), "The GNO withdrawal must succeed");
574         lockedGNO[msg.sender] = 0;
575     }
576 }
