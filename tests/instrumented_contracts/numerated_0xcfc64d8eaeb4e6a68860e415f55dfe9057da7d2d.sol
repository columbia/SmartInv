1 pragma solidity ^0.4.21;
2 
3 // File: @gnosis.pm/util-contracts/contracts/Token.sol
4 
5 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 pragma solidity ^0.4.18;
7 
8 
9 /// @title Abstract token contract - Functions to be implemented by token contracts
10 contract Token {
11 
12     /*
13      *  Events
14      */
15     event Transfer(address indexed from, address indexed to, uint value);
16     event Approval(address indexed owner, address indexed spender, uint value);
17 
18     /*
19      *  Public functions
20      */
21     function transfer(address to, uint value) public returns (bool);
22     function transferFrom(address from, address to, uint value) public returns (bool);
23     function approve(address spender, uint value) public returns (bool);
24     function balanceOf(address owner) public view returns (uint);
25     function allowance(address owner, address spender) public view returns (uint);
26     function totalSupply() public view returns (uint);
27 }
28 
29 // File: @gnosis.pm/util-contracts/contracts/Math.sol
30 
31 /// @title Math library - Allows calculation of logarithmic and exponential functions
32 /// @author Alan Lu - <alan.lu@gnosis.pm>
33 /// @author Stefan George - <stefan@gnosis.pm>
34 library Math {
35 
36     /*
37      *  Constants
38      */
39     // This is equal to 1 in our calculations
40     uint public constant ONE =  0x10000000000000000;
41     uint public constant LN2 = 0xb17217f7d1cf79ac;
42     uint public constant LOG2_E = 0x171547652b82fe177;
43 
44     /*
45      *  Public functions
46      */
47     /// @dev Returns natural exponential function value of given x
48     /// @param x x
49     /// @return e**x
50     function exp(int x)
51         public
52         pure
53         returns (uint)
54     {
55         // revert if x is > MAX_POWER, where
56         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
57         require(x <= 2454971259878909886679);
58         // return 0 if exp(x) is tiny, using
59         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
60         if (x < -818323753292969962227)
61             return 0;
62         // Transform so that e^x -> 2^x
63         x = x * int(ONE) / int(LN2);
64         // 2^x = 2^whole(x) * 2^frac(x)
65         //       ^^^^^^^^^^ is a bit shift
66         // so Taylor expand on z = frac(x)
67         int shift;
68         uint z;
69         if (x >= 0) {
70             shift = x / int(ONE);
71             z = uint(x % int(ONE));
72         }
73         else {
74             shift = x / int(ONE) - 1;
75             z = ONE - uint(-x % int(ONE));
76         }
77         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
78         //
79         // Can generate the z coefficients using mpmath and the following lines
80         // >>> from mpmath import mp
81         // >>> mp.dps = 100
82         // >>> ONE =  0x10000000000000000
83         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
84         // 0xb17217f7d1cf79ab
85         // 0x3d7f7bff058b1d50
86         // 0xe35846b82505fc5
87         // 0x276556df749cee5
88         // 0x5761ff9e299cc4
89         // 0xa184897c363c3
90         uint zpow = z;
91         uint result = ONE;
92         result += 0xb17217f7d1cf79ab * zpow / ONE;
93         zpow = zpow * z / ONE;
94         result += 0x3d7f7bff058b1d50 * zpow / ONE;
95         zpow = zpow * z / ONE;
96         result += 0xe35846b82505fc5 * zpow / ONE;
97         zpow = zpow * z / ONE;
98         result += 0x276556df749cee5 * zpow / ONE;
99         zpow = zpow * z / ONE;
100         result += 0x5761ff9e299cc4 * zpow / ONE;
101         zpow = zpow * z / ONE;
102         result += 0xa184897c363c3 * zpow / ONE;
103         zpow = zpow * z / ONE;
104         result += 0xffe5fe2c4586 * zpow / ONE;
105         zpow = zpow * z / ONE;
106         result += 0x162c0223a5c8 * zpow / ONE;
107         zpow = zpow * z / ONE;
108         result += 0x1b5253d395e * zpow / ONE;
109         zpow = zpow * z / ONE;
110         result += 0x1e4cf5158b * zpow / ONE;
111         zpow = zpow * z / ONE;
112         result += 0x1e8cac735 * zpow / ONE;
113         zpow = zpow * z / ONE;
114         result += 0x1c3bd650 * zpow / ONE;
115         zpow = zpow * z / ONE;
116         result += 0x1816193 * zpow / ONE;
117         zpow = zpow * z / ONE;
118         result += 0x131496 * zpow / ONE;
119         zpow = zpow * z / ONE;
120         result += 0xe1b7 * zpow / ONE;
121         zpow = zpow * z / ONE;
122         result += 0x9c7 * zpow / ONE;
123         if (shift >= 0) {
124             if (result >> (256-shift) > 0)
125                 return (2**256-1);
126             return result << shift;
127         }
128         else
129             return result >> (-shift);
130     }
131 
132     /// @dev Returns natural logarithm value of given x
133     /// @param x x
134     /// @return ln(x)
135     function ln(uint x)
136         public
137         pure
138         returns (int)
139     {
140         require(x > 0);
141         // binary search for floor(log2(x))
142         int ilog2 = floorLog2(x);
143         int z;
144         if (ilog2 < 0)
145             z = int(x << uint(-ilog2));
146         else
147             z = int(x >> uint(ilog2));
148         // z = x * 2^-⌊log₂x⌋
149         // so 1 <= z < 2
150         // and ln z = ln x - ⌊log₂x⌋/log₂e
151         // so just compute ln z using artanh series
152         // and calculate ln x from that
153         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
154         int halflnz = term;
155         int termpow = term * term / int(ONE) * term / int(ONE);
156         halflnz += termpow / 3;
157         termpow = termpow * term / int(ONE) * term / int(ONE);
158         halflnz += termpow / 5;
159         termpow = termpow * term / int(ONE) * term / int(ONE);
160         halflnz += termpow / 7;
161         termpow = termpow * term / int(ONE) * term / int(ONE);
162         halflnz += termpow / 9;
163         termpow = termpow * term / int(ONE) * term / int(ONE);
164         halflnz += termpow / 11;
165         termpow = termpow * term / int(ONE) * term / int(ONE);
166         halflnz += termpow / 13;
167         termpow = termpow * term / int(ONE) * term / int(ONE);
168         halflnz += termpow / 15;
169         termpow = termpow * term / int(ONE) * term / int(ONE);
170         halflnz += termpow / 17;
171         termpow = termpow * term / int(ONE) * term / int(ONE);
172         halflnz += termpow / 19;
173         termpow = termpow * term / int(ONE) * term / int(ONE);
174         halflnz += termpow / 21;
175         termpow = termpow * term / int(ONE) * term / int(ONE);
176         halflnz += termpow / 23;
177         termpow = termpow * term / int(ONE) * term / int(ONE);
178         halflnz += termpow / 25;
179         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
180     }
181 
182     /// @dev Returns base 2 logarithm value of given x
183     /// @param x x
184     /// @return logarithmic value
185     function floorLog2(uint x)
186         public
187         pure
188         returns (int lo)
189     {
190         lo = -64;
191         int hi = 193;
192         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
193         int mid = (hi + lo) >> 1;
194         while((lo + 1) < hi) {
195             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE)
196                 hi = mid;
197             else
198                 lo = mid;
199             mid = (hi + lo) >> 1;
200         }
201     }
202 
203     /// @dev Returns maximum of an array
204     /// @param nums Numbers to look through
205     /// @return Maximum number
206     function max(int[] nums)
207         public
208         pure
209         returns (int maxNum)
210     {
211         require(nums.length > 0);
212         maxNum = -2**255;
213         for (uint i = 0; i < nums.length; i++)
214             if (nums[i] > maxNum)
215                 maxNum = nums[i];
216     }
217 
218     /// @dev Returns whether an add operation causes an overflow
219     /// @param a First addend
220     /// @param b Second addend
221     /// @return Did no overflow occur?
222     function safeToAdd(uint a, uint b)
223         internal
224         pure
225         returns (bool)
226     {
227         return a + b >= a;
228     }
229 
230     /// @dev Returns whether a subtraction operation causes an underflow
231     /// @param a Minuend
232     /// @param b Subtrahend
233     /// @return Did no underflow occur?
234     function safeToSub(uint a, uint b)
235         internal
236         pure
237         returns (bool)
238     {
239         return a >= b;
240     }
241 
242     /// @dev Returns whether a multiply operation causes an overflow
243     /// @param a First factor
244     /// @param b Second factor
245     /// @return Did no overflow occur?
246     function safeToMul(uint a, uint b)
247         internal
248         pure
249         returns (bool)
250     {
251         return b == 0 || a * b / b == a;
252     }
253 
254     /// @dev Returns sum if no overflow occurred
255     /// @param a First addend
256     /// @param b Second addend
257     /// @return Sum
258     function add(uint a, uint b)
259         internal
260         pure
261         returns (uint)
262     {
263         require(safeToAdd(a, b));
264         return a + b;
265     }
266 
267     /// @dev Returns difference if no overflow occurred
268     /// @param a Minuend
269     /// @param b Subtrahend
270     /// @return Difference
271     function sub(uint a, uint b)
272         internal
273         pure
274         returns (uint)
275     {
276         require(safeToSub(a, b));
277         return a - b;
278     }
279 
280     /// @dev Returns product if no overflow occurred
281     /// @param a First factor
282     /// @param b Second factor
283     /// @return Product
284     function mul(uint a, uint b)
285         internal
286         pure
287         returns (uint)
288     {
289         require(safeToMul(a, b));
290         return a * b;
291     }
292 
293     /// @dev Returns whether an add operation causes an overflow
294     /// @param a First addend
295     /// @param b Second addend
296     /// @return Did no overflow occur?
297     function safeToAdd(int a, int b)
298         internal
299         pure
300         returns (bool)
301     {
302         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
303     }
304 
305     /// @dev Returns whether a subtraction operation causes an underflow
306     /// @param a Minuend
307     /// @param b Subtrahend
308     /// @return Did no underflow occur?
309     function safeToSub(int a, int b)
310         internal
311         pure
312         returns (bool)
313     {
314         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
315     }
316 
317     /// @dev Returns whether a multiply operation causes an overflow
318     /// @param a First factor
319     /// @param b Second factor
320     /// @return Did no overflow occur?
321     function safeToMul(int a, int b)
322         internal
323         pure
324         returns (bool)
325     {
326         return (b == 0) || (a * b / b == a);
327     }
328 
329     /// @dev Returns sum if no overflow occurred
330     /// @param a First addend
331     /// @param b Second addend
332     /// @return Sum
333     function add(int a, int b)
334         internal
335         pure
336         returns (int)
337     {
338         require(safeToAdd(a, b));
339         return a + b;
340     }
341 
342     /// @dev Returns difference if no overflow occurred
343     /// @param a Minuend
344     /// @param b Subtrahend
345     /// @return Difference
346     function sub(int a, int b)
347         internal
348         pure
349         returns (int)
350     {
351         require(safeToSub(a, b));
352         return a - b;
353     }
354 
355     /// @dev Returns product if no overflow occurred
356     /// @param a First factor
357     /// @param b Second factor
358     /// @return Product
359     function mul(int a, int b)
360         internal
361         pure
362         returns (int)
363     {
364         require(safeToMul(a, b));
365         return a * b;
366     }
367 }
368 
369 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
370 
371 /// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
372 /// @author Alan Lu - <alan@gnosis.pm>
373 contract Proxied {
374     address public masterCopy;
375 }
376 
377 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
378 /// @author Stefan George - <stefan@gnosis.pm>
379 contract Proxy is Proxied {
380     /// @dev Constructor function sets address of master copy contract.
381     /// @param _masterCopy Master copy address.
382     function Proxy(address _masterCopy)
383         public
384     {
385         require(_masterCopy != 0);
386         masterCopy = _masterCopy;
387     }
388 
389     /// @dev Fallback function forwards all transactions and returns all received return data.
390     function ()
391         external
392         payable
393     {
394         address _masterCopy = masterCopy;
395         assembly {
396             calldatacopy(0, 0, calldatasize())
397             let success := delegatecall(not(0), _masterCopy, 0, calldatasize(), 0, 0)
398             returndatacopy(0, 0, returndatasize())
399             switch success
400             case 0 { revert(0, returndatasize()) }
401             default { return(0, returndatasize()) }
402         }
403     }
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
438         Transfer(msg.sender, to, value);
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
458         Transfer(from, to, value);
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
471         Approval(msg.sender, spender, value);
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
509 // File: contracts/PlayToken.sol
510 
511 contract PlayToken is StandardToken {
512     /*
513      *  Events
514      */
515     event Issuance(address indexed owner, uint amount);
516 
517     /*
518      *  Constants
519      */
520     bool public constant isPlayToken = true;
521 
522     /*
523      *  Storage
524      */
525     address public creator;
526     mapping (address => bool) public whitelist;
527     mapping (address => bool) public admins;
528 
529     /*
530      *  Modifiers
531      */
532     modifier isCreator {
533         require(msg.sender == creator);
534         _;
535     }
536     modifier isAdmin {
537         require(msg.sender == creator || admins[msg.sender] == true);
538         _;
539     }
540 
541     /*
542      *  Public functions
543      */
544     /// @dev Constructor sets events contract address
545     function PlayToken()
546         public
547     {
548         creator = msg.sender;
549     }
550 
551     /// @dev Allows creator to issue tokens. Will reject if msg.sender isn't the creator.
552     /// @param recipients Addresses of recipients
553     /// @param amount Number of tokens to issue each recipient
554     function issue(address[] recipients, uint amount)
555         public
556         isCreator
557     {
558         for(uint i = 0; i < recipients.length; i++) {
559             address recipient = recipients[i];
560             balances[recipient] = balances[recipient].add(amount);
561             emit Issuance(recipient, amount);
562         }
563         totalTokens = totalTokens.add(amount.mul(recipients.length));
564     }
565 
566     /// @dev Allows creator to mark addresses as whitelisted for transfers to and from those addresses.
567     /// @param allowed Addresses to be added to the whitelist
568     function allowTransfers(address[] allowed)
569         public
570         isAdmin
571     {
572         for(uint i = 0; i < allowed.length; i++) {
573             whitelist[allowed[i]] = true;
574         }
575     }
576 
577     /// @dev Allows creator to remove addresses from being whitelisted for transfers to and from those addresses.
578     /// @param disallowed Addresses to be removed from the whitelist
579     function disallowTransfers(address[] disallowed)
580         public
581         isAdmin
582     {
583         for(uint i = 0; i < disallowed.length; i++) {
584             whitelist[disallowed[i]] = false;
585         }
586     }
587 
588     /// @dev Allows creator to add admins that can whitelist addresses.
589     /// @param _admins Addresses to be added as admin role
590     function addAdmin(address[] _admins)
591         public
592         isCreator
593     {
594         for(uint i = 0; i < _admins.length; i++) {
595             admins[_admins[i]] = true;
596         }
597     }
598 
599     /// @dev Allows creator to remove addresses from admin role.
600     /// @param _admins Addresses to be removed from the admin mapping
601     function removeAdmin(address[] _admins)
602         public
603         isCreator
604     {
605         for(uint i = 0; i < _admins.length; i++) {
606             admins[_admins[i]] = false;
607         }
608     }
609 
610     function transfer(address to, uint value) public returns (bool) {
611         require(whitelist[msg.sender] || whitelist[to]);
612         return super.transfer(to, value);
613     }
614 
615     function transferFrom(address from, address to, uint value) public returns (bool) {
616         require(whitelist[from] || whitelist[to]);
617         return super.transferFrom(from, to, value);
618     }
619 }
620 
621 // File: contracts/OlympiaToken.sol
622 
623 contract OlympiaToken is PlayToken {
624     /*
625      *  Constants
626      */
627     string public constant name = "Helena Proton";
628     string public constant symbol = "P+";
629     uint8 public constant decimals = 18;
630 }