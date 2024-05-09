1 pragma solidity ^0.4.21;
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
16     function Proxy(address _masterCopy)
17         public
18     {
19         require(_masterCopy != 0);
20         masterCopy = _masterCopy;
21     }
22 
23     /// @dev Fallback function forwards all transactions and returns all received return data.
24     function ()
25         external
26         payable
27     {
28         address _masterCopy = masterCopy;
29         assembly {
30             calldatacopy(0, 0, calldatasize())
31             let success := delegatecall(not(0), _masterCopy, 0, calldatasize(), 0, 0)
32             returndatacopy(0, 0, returndatasize())
33             switch success
34             case 0 { revert(0, returndatasize()) }
35             default { return(0, returndatasize()) }
36         }
37     }
38 }
39 
40 // File: @gnosis.pm/util-contracts/contracts/Math.sol
41 
42 /// @title Math library - Allows calculation of logarithmic and exponential functions
43 /// @author Alan Lu - <alan.lu@gnosis.pm>
44 /// @author Stefan George - <stefan@gnosis.pm>
45 library Math {
46 
47     /*
48      *  Constants
49      */
50     // This is equal to 1 in our calculations
51     uint public constant ONE =  0x10000000000000000;
52     uint public constant LN2 = 0xb17217f7d1cf79ac;
53     uint public constant LOG2_E = 0x171547652b82fe177;
54 
55     /*
56      *  Public functions
57      */
58     /// @dev Returns natural exponential function value of given x
59     /// @param x x
60     /// @return e**x
61     function exp(int x)
62         public
63         pure
64         returns (uint)
65     {
66         // revert if x is > MAX_POWER, where
67         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
68         require(x <= 2454971259878909886679);
69         // return 0 if exp(x) is tiny, using
70         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
71         if (x < -818323753292969962227)
72             return 0;
73         // Transform so that e^x -> 2^x
74         x = x * int(ONE) / int(LN2);
75         // 2^x = 2^whole(x) * 2^frac(x)
76         //       ^^^^^^^^^^ is a bit shift
77         // so Taylor expand on z = frac(x)
78         int shift;
79         uint z;
80         if (x >= 0) {
81             shift = x / int(ONE);
82             z = uint(x % int(ONE));
83         }
84         else {
85             shift = x / int(ONE) - 1;
86             z = ONE - uint(-x % int(ONE));
87         }
88         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
89         //
90         // Can generate the z coefficients using mpmath and the following lines
91         // >>> from mpmath import mp
92         // >>> mp.dps = 100
93         // >>> ONE =  0x10000000000000000
94         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
95         // 0xb17217f7d1cf79ab
96         // 0x3d7f7bff058b1d50
97         // 0xe35846b82505fc5
98         // 0x276556df749cee5
99         // 0x5761ff9e299cc4
100         // 0xa184897c363c3
101         uint zpow = z;
102         uint result = ONE;
103         result += 0xb17217f7d1cf79ab * zpow / ONE;
104         zpow = zpow * z / ONE;
105         result += 0x3d7f7bff058b1d50 * zpow / ONE;
106         zpow = zpow * z / ONE;
107         result += 0xe35846b82505fc5 * zpow / ONE;
108         zpow = zpow * z / ONE;
109         result += 0x276556df749cee5 * zpow / ONE;
110         zpow = zpow * z / ONE;
111         result += 0x5761ff9e299cc4 * zpow / ONE;
112         zpow = zpow * z / ONE;
113         result += 0xa184897c363c3 * zpow / ONE;
114         zpow = zpow * z / ONE;
115         result += 0xffe5fe2c4586 * zpow / ONE;
116         zpow = zpow * z / ONE;
117         result += 0x162c0223a5c8 * zpow / ONE;
118         zpow = zpow * z / ONE;
119         result += 0x1b5253d395e * zpow / ONE;
120         zpow = zpow * z / ONE;
121         result += 0x1e4cf5158b * zpow / ONE;
122         zpow = zpow * z / ONE;
123         result += 0x1e8cac735 * zpow / ONE;
124         zpow = zpow * z / ONE;
125         result += 0x1c3bd650 * zpow / ONE;
126         zpow = zpow * z / ONE;
127         result += 0x1816193 * zpow / ONE;
128         zpow = zpow * z / ONE;
129         result += 0x131496 * zpow / ONE;
130         zpow = zpow * z / ONE;
131         result += 0xe1b7 * zpow / ONE;
132         zpow = zpow * z / ONE;
133         result += 0x9c7 * zpow / ONE;
134         if (shift >= 0) {
135             if (result >> (256-shift) > 0)
136                 return (2**256-1);
137             return result << shift;
138         }
139         else
140             return result >> (-shift);
141     }
142 
143     /// @dev Returns natural logarithm value of given x
144     /// @param x x
145     /// @return ln(x)
146     function ln(uint x)
147         public
148         pure
149         returns (int)
150     {
151         require(x > 0);
152         // binary search for floor(log2(x))
153         int ilog2 = floorLog2(x);
154         int z;
155         if (ilog2 < 0)
156             z = int(x << uint(-ilog2));
157         else
158             z = int(x >> uint(ilog2));
159         // z = x * 2^-⌊log₂x⌋
160         // so 1 <= z < 2
161         // and ln z = ln x - ⌊log₂x⌋/log₂e
162         // so just compute ln z using artanh series
163         // and calculate ln x from that
164         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
165         int halflnz = term;
166         int termpow = term * term / int(ONE) * term / int(ONE);
167         halflnz += termpow / 3;
168         termpow = termpow * term / int(ONE) * term / int(ONE);
169         halflnz += termpow / 5;
170         termpow = termpow * term / int(ONE) * term / int(ONE);
171         halflnz += termpow / 7;
172         termpow = termpow * term / int(ONE) * term / int(ONE);
173         halflnz += termpow / 9;
174         termpow = termpow * term / int(ONE) * term / int(ONE);
175         halflnz += termpow / 11;
176         termpow = termpow * term / int(ONE) * term / int(ONE);
177         halflnz += termpow / 13;
178         termpow = termpow * term / int(ONE) * term / int(ONE);
179         halflnz += termpow / 15;
180         termpow = termpow * term / int(ONE) * term / int(ONE);
181         halflnz += termpow / 17;
182         termpow = termpow * term / int(ONE) * term / int(ONE);
183         halflnz += termpow / 19;
184         termpow = termpow * term / int(ONE) * term / int(ONE);
185         halflnz += termpow / 21;
186         termpow = termpow * term / int(ONE) * term / int(ONE);
187         halflnz += termpow / 23;
188         termpow = termpow * term / int(ONE) * term / int(ONE);
189         halflnz += termpow / 25;
190         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
191     }
192 
193     /// @dev Returns base 2 logarithm value of given x
194     /// @param x x
195     /// @return logarithmic value
196     function floorLog2(uint x)
197         public
198         pure
199         returns (int lo)
200     {
201         lo = -64;
202         int hi = 193;
203         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
204         int mid = (hi + lo) >> 1;
205         while((lo + 1) < hi) {
206             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE)
207                 hi = mid;
208             else
209                 lo = mid;
210             mid = (hi + lo) >> 1;
211         }
212     }
213 
214     /// @dev Returns maximum of an array
215     /// @param nums Numbers to look through
216     /// @return Maximum number
217     function max(int[] nums)
218         public
219         pure
220         returns (int maxNum)
221     {
222         require(nums.length > 0);
223         maxNum = -2**255;
224         for (uint i = 0; i < nums.length; i++)
225             if (nums[i] > maxNum)
226                 maxNum = nums[i];
227     }
228 
229     /// @dev Returns whether an add operation causes an overflow
230     /// @param a First addend
231     /// @param b Second addend
232     /// @return Did no overflow occur?
233     function safeToAdd(uint a, uint b)
234         internal
235         pure
236         returns (bool)
237     {
238         return a + b >= a;
239     }
240 
241     /// @dev Returns whether a subtraction operation causes an underflow
242     /// @param a Minuend
243     /// @param b Subtrahend
244     /// @return Did no underflow occur?
245     function safeToSub(uint a, uint b)
246         internal
247         pure
248         returns (bool)
249     {
250         return a >= b;
251     }
252 
253     /// @dev Returns whether a multiply operation causes an overflow
254     /// @param a First factor
255     /// @param b Second factor
256     /// @return Did no overflow occur?
257     function safeToMul(uint a, uint b)
258         internal
259         pure
260         returns (bool)
261     {
262         return b == 0 || a * b / b == a;
263     }
264 
265     /// @dev Returns sum if no overflow occurred
266     /// @param a First addend
267     /// @param b Second addend
268     /// @return Sum
269     function add(uint a, uint b)
270         internal
271         pure
272         returns (uint)
273     {
274         require(safeToAdd(a, b));
275         return a + b;
276     }
277 
278     /// @dev Returns difference if no overflow occurred
279     /// @param a Minuend
280     /// @param b Subtrahend
281     /// @return Difference
282     function sub(uint a, uint b)
283         internal
284         pure
285         returns (uint)
286     {
287         require(safeToSub(a, b));
288         return a - b;
289     }
290 
291     /// @dev Returns product if no overflow occurred
292     /// @param a First factor
293     /// @param b Second factor
294     /// @return Product
295     function mul(uint a, uint b)
296         internal
297         pure
298         returns (uint)
299     {
300         require(safeToMul(a, b));
301         return a * b;
302     }
303 
304     /// @dev Returns whether an add operation causes an overflow
305     /// @param a First addend
306     /// @param b Second addend
307     /// @return Did no overflow occur?
308     function safeToAdd(int a, int b)
309         internal
310         pure
311         returns (bool)
312     {
313         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
314     }
315 
316     /// @dev Returns whether a subtraction operation causes an underflow
317     /// @param a Minuend
318     /// @param b Subtrahend
319     /// @return Did no underflow occur?
320     function safeToSub(int a, int b)
321         internal
322         pure
323         returns (bool)
324     {
325         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
326     }
327 
328     /// @dev Returns whether a multiply operation causes an overflow
329     /// @param a First factor
330     /// @param b Second factor
331     /// @return Did no overflow occur?
332     function safeToMul(int a, int b)
333         internal
334         pure
335         returns (bool)
336     {
337         return (b == 0) || (a * b / b == a);
338     }
339 
340     /// @dev Returns sum if no overflow occurred
341     /// @param a First addend
342     /// @param b Second addend
343     /// @return Sum
344     function add(int a, int b)
345         internal
346         pure
347         returns (int)
348     {
349         require(safeToAdd(a, b));
350         return a + b;
351     }
352 
353     /// @dev Returns difference if no overflow occurred
354     /// @param a Minuend
355     /// @param b Subtrahend
356     /// @return Difference
357     function sub(int a, int b)
358         internal
359         pure
360         returns (int)
361     {
362         require(safeToSub(a, b));
363         return a - b;
364     }
365 
366     /// @dev Returns product if no overflow occurred
367     /// @param a First factor
368     /// @param b Second factor
369     /// @return Product
370     function mul(int a, int b)
371         internal
372         pure
373         returns (int)
374     {
375         require(safeToMul(a, b));
376         return a * b;
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
509 // File: contracts/TokenOWLProxy.sol
510 
511 contract TokenOWLProxy is Proxy, StandardToken {
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
528     /// @dev Constructor of the contract OWL, which distributes tokens
529     function TokenOWLProxy(address proxied)
530         Proxy(proxied)
531         public
532     {
533         creator = msg.sender;
534     }
535 }