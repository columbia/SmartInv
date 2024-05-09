1 pragma solidity 0.4.18;
2 
3 /// @title Math library - Allows calculation of logarithmic and exponential functions
4 /// @author Alan Lu - <alan.lu@gnosis.pm>
5 /// @author Stefan George - <stefan@gnosis.pm>
6 library Math {
7 
8     /*
9      *  Constants
10      */
11     // This is equal to 1 in our calculations
12     uint public constant ONE =  0x10000000000000000;
13     uint public constant LN2 = 0xb17217f7d1cf79ac;
14     uint public constant LOG2_E = 0x171547652b82fe177;
15 
16     /*
17      *  Public functions
18      */
19     /// @dev Returns natural exponential function value of given x
20     /// @param x x
21     /// @return e**x
22     function exp(int x)
23         public
24         constant
25         returns (uint)
26     {
27         // revert if x is > MAX_POWER, where
28         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
29         require(x <= 2454971259878909886679);
30         // return 0 if exp(x) is tiny, using
31         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
32         if (x < -818323753292969962227)
33             return 0;
34         // Transform so that e^x -> 2^x
35         x = x * int(ONE) / int(LN2);
36         // 2^x = 2^whole(x) * 2^frac(x)
37         //       ^^^^^^^^^^ is a bit shift
38         // so Taylor expand on z = frac(x)
39         int shift;
40         uint z;
41         if (x >= 0) {
42             shift = x / int(ONE);
43             z = uint(x % int(ONE));
44         }
45         else {
46             shift = x / int(ONE) - 1;
47             z = ONE - uint(-x % int(ONE));
48         }
49         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
50         //
51         // Can generate the z coefficients using mpmath and the following lines
52         // >>> from mpmath import mp
53         // >>> mp.dps = 100
54         // >>> ONE =  0x10000000000000000
55         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
56         // 0xb17217f7d1cf79ab
57         // 0x3d7f7bff058b1d50
58         // 0xe35846b82505fc5
59         // 0x276556df749cee5
60         // 0x5761ff9e299cc4
61         // 0xa184897c363c3
62         uint zpow = z;
63         uint result = ONE;
64         result += 0xb17217f7d1cf79ab * zpow / ONE;
65         zpow = zpow * z / ONE;
66         result += 0x3d7f7bff058b1d50 * zpow / ONE;
67         zpow = zpow * z / ONE;
68         result += 0xe35846b82505fc5 * zpow / ONE;
69         zpow = zpow * z / ONE;
70         result += 0x276556df749cee5 * zpow / ONE;
71         zpow = zpow * z / ONE;
72         result += 0x5761ff9e299cc4 * zpow / ONE;
73         zpow = zpow * z / ONE;
74         result += 0xa184897c363c3 * zpow / ONE;
75         zpow = zpow * z / ONE;
76         result += 0xffe5fe2c4586 * zpow / ONE;
77         zpow = zpow * z / ONE;
78         result += 0x162c0223a5c8 * zpow / ONE;
79         zpow = zpow * z / ONE;
80         result += 0x1b5253d395e * zpow / ONE;
81         zpow = zpow * z / ONE;
82         result += 0x1e4cf5158b * zpow / ONE;
83         zpow = zpow * z / ONE;
84         result += 0x1e8cac735 * zpow / ONE;
85         zpow = zpow * z / ONE;
86         result += 0x1c3bd650 * zpow / ONE;
87         zpow = zpow * z / ONE;
88         result += 0x1816193 * zpow / ONE;
89         zpow = zpow * z / ONE;
90         result += 0x131496 * zpow / ONE;
91         zpow = zpow * z / ONE;
92         result += 0xe1b7 * zpow / ONE;
93         zpow = zpow * z / ONE;
94         result += 0x9c7 * zpow / ONE;
95         if (shift >= 0) {
96             if (result >> (256-shift) > 0)
97                 return (2**256-1);
98             return result << shift;
99         }
100         else
101             return result >> (-shift);
102     }
103 
104     /// @dev Returns natural logarithm value of given x
105     /// @param x x
106     /// @return ln(x)
107     function ln(uint x)
108         public
109         constant
110         returns (int)
111     {
112         require(x > 0);
113         // binary search for floor(log2(x))
114         int ilog2 = floorLog2(x);
115         int z;
116         if (ilog2 < 0)
117             z = int(x << uint(-ilog2));
118         else
119             z = int(x >> uint(ilog2));
120         // z = x * 2^-⌊log₂x⌋
121         // so 1 <= z < 2
122         // and ln z = ln x - ⌊log₂x⌋/log₂e
123         // so just compute ln z using artanh series
124         // and calculate ln x from that
125         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
126         int halflnz = term;
127         int termpow = term * term / int(ONE) * term / int(ONE);
128         halflnz += termpow / 3;
129         termpow = termpow * term / int(ONE) * term / int(ONE);
130         halflnz += termpow / 5;
131         termpow = termpow * term / int(ONE) * term / int(ONE);
132         halflnz += termpow / 7;
133         termpow = termpow * term / int(ONE) * term / int(ONE);
134         halflnz += termpow / 9;
135         termpow = termpow * term / int(ONE) * term / int(ONE);
136         halflnz += termpow / 11;
137         termpow = termpow * term / int(ONE) * term / int(ONE);
138         halflnz += termpow / 13;
139         termpow = termpow * term / int(ONE) * term / int(ONE);
140         halflnz += termpow / 15;
141         termpow = termpow * term / int(ONE) * term / int(ONE);
142         halflnz += termpow / 17;
143         termpow = termpow * term / int(ONE) * term / int(ONE);
144         halflnz += termpow / 19;
145         termpow = termpow * term / int(ONE) * term / int(ONE);
146         halflnz += termpow / 21;
147         termpow = termpow * term / int(ONE) * term / int(ONE);
148         halflnz += termpow / 23;
149         termpow = termpow * term / int(ONE) * term / int(ONE);
150         halflnz += termpow / 25;
151         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
152     }
153 
154     /// @dev Returns base 2 logarithm value of given x
155     /// @param x x
156     /// @return logarithmic value
157     function floorLog2(uint x)
158         public
159         constant
160         returns (int lo)
161     {
162         lo = -64;
163         int hi = 193;
164         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
165         int mid = (hi + lo) >> 1;
166         while((lo + 1) < hi) {
167             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE)
168                 hi = mid;
169             else
170                 lo = mid;
171             mid = (hi + lo) >> 1;
172         }
173     }
174 
175     /// @dev Returns maximum of an array
176     /// @param nums Numbers to look through
177     /// @return Maximum number
178     function max(int[] nums)
179         public
180         constant
181         returns (int max)
182     {
183         require(nums.length > 0);
184         max = -2**255;
185         for (uint i = 0; i < nums.length; i++)
186             if (nums[i] > max)
187                 max = nums[i];
188     }
189 
190     /// @dev Returns whether an add operation causes an overflow
191     /// @param a First addend
192     /// @param b Second addend
193     /// @return Did no overflow occur?
194     function safeToAdd(uint a, uint b)
195         public
196         constant
197         returns (bool)
198     {
199         return a + b >= a;
200     }
201 
202     /// @dev Returns whether a subtraction operation causes an underflow
203     /// @param a Minuend
204     /// @param b Subtrahend
205     /// @return Did no underflow occur?
206     function safeToSub(uint a, uint b)
207         public
208         constant
209         returns (bool)
210     {
211         return a >= b;
212     }
213 
214     /// @dev Returns whether a multiply operation causes an overflow
215     /// @param a First factor
216     /// @param b Second factor
217     /// @return Did no overflow occur?
218     function safeToMul(uint a, uint b)
219         public
220         constant
221         returns (bool)
222     {
223         return b == 0 || a * b / b == a;
224     }
225 
226     /// @dev Returns sum if no overflow occurred
227     /// @param a First addend
228     /// @param b Second addend
229     /// @return Sum
230     function add(uint a, uint b)
231         public
232         constant
233         returns (uint)
234     {
235         require(safeToAdd(a, b));
236         return a + b;
237     }
238 
239     /// @dev Returns difference if no overflow occurred
240     /// @param a Minuend
241     /// @param b Subtrahend
242     /// @return Difference
243     function sub(uint a, uint b)
244         public
245         constant
246         returns (uint)
247     {
248         require(safeToSub(a, b));
249         return a - b;
250     }
251 
252     /// @dev Returns product if no overflow occurred
253     /// @param a First factor
254     /// @param b Second factor
255     /// @return Product
256     function mul(uint a, uint b)
257         public
258         constant
259         returns (uint)
260     {
261         require(safeToMul(a, b));
262         return a * b;
263     }
264 
265     /// @dev Returns whether an add operation causes an overflow
266     /// @param a First addend
267     /// @param b Second addend
268     /// @return Did no overflow occur?
269     function safeToAdd(int a, int b)
270         public
271         constant
272         returns (bool)
273     {
274         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
275     }
276 
277     /// @dev Returns whether a subtraction operation causes an underflow
278     /// @param a Minuend
279     /// @param b Subtrahend
280     /// @return Did no underflow occur?
281     function safeToSub(int a, int b)
282         public
283         constant
284         returns (bool)
285     {
286         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
287     }
288 
289     /// @dev Returns whether a multiply operation causes an overflow
290     /// @param a First factor
291     /// @param b Second factor
292     /// @return Did no overflow occur?
293     function safeToMul(int a, int b)
294         public
295         constant
296         returns (bool)
297     {
298         return (b == 0) || (a * b / b == a);
299     }
300 
301     /// @dev Returns sum if no overflow occurred
302     /// @param a First addend
303     /// @param b Second addend
304     /// @return Sum
305     function add(int a, int b)
306         public
307         constant
308         returns (int)
309     {
310         require(safeToAdd(a, b));
311         return a + b;
312     }
313 
314     /// @dev Returns difference if no overflow occurred
315     /// @param a Minuend
316     /// @param b Subtrahend
317     /// @return Difference
318     function sub(int a, int b)
319         public
320         constant
321         returns (int)
322     {
323         require(safeToSub(a, b));
324         return a - b;
325     }
326 
327     /// @dev Returns product if no overflow occurred
328     /// @param a First factor
329     /// @param b Second factor
330     /// @return Product
331     function mul(int a, int b)
332         public
333         constant
334         returns (int)
335     {
336         require(safeToMul(a, b));
337         return a * b;
338     }
339 }
340 
341 /// @title Abstract token contract - Functions to be implemented by token contracts
342 contract Token {
343 
344     /*
345      *  Events
346      */
347     event Transfer(address indexed from, address indexed to, uint value);
348     event Approval(address indexed owner, address indexed spender, uint value);
349 
350     /*
351      *  Public functions
352      */
353     function transfer(address to, uint value) public returns (bool);
354     function transferFrom(address from, address to, uint value) public returns (bool);
355     function approve(address spender, uint value) public returns (bool);
356     function balanceOf(address owner) public constant returns (uint);
357     function allowance(address owner, address spender) public constant returns (uint);
358     function totalSupply() public constant returns (uint);
359 }
360 
361 
362 /// @title Standard token contract with overflow protection
363 contract StandardToken is Token {
364     using Math for *;
365 
366     /*
367      *  Storage
368      */
369     mapping (address => uint) balances;
370     mapping (address => mapping (address => uint)) allowances;
371     uint totalTokens;
372 
373     /*
374      *  Public functions
375      */
376     /// @dev Transfers sender's tokens to a given address. Returns success
377     /// @param to Address of token receiver
378     /// @param value Number of tokens to transfer
379     /// @return Was transfer successful?
380     function transfer(address to, uint value)
381         public
382         returns (bool)
383     {
384         if (   !balances[msg.sender].safeToSub(value)
385             || !balances[to].safeToAdd(value))
386             return false;
387         balances[msg.sender] -= value;
388         balances[to] += value;
389         Transfer(msg.sender, to, value);
390         return true;
391     }
392 
393     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
394     /// @param from Address from where tokens are withdrawn
395     /// @param to Address to where tokens are sent
396     /// @param value Number of tokens to transfer
397     /// @return Was transfer successful?
398     function transferFrom(address from, address to, uint value)
399         public
400         returns (bool)
401     {
402         if (   !balances[from].safeToSub(value)
403             || !allowances[from][msg.sender].safeToSub(value)
404             || !balances[to].safeToAdd(value))
405             return false;
406         balances[from] -= value;
407         allowances[from][msg.sender] -= value;
408         balances[to] += value;
409         Transfer(from, to, value);
410         return true;
411     }
412 
413     /// @dev Sets approved amount of tokens for spender. Returns success
414     /// @param spender Address of allowed account
415     /// @param value Number of approved tokens
416     /// @return Was approval successful?
417     function approve(address spender, uint value)
418         public
419         returns (bool)
420     {
421         allowances[msg.sender][spender] = value;
422         Approval(msg.sender, spender, value);
423         return true;
424     }
425 
426     /// @dev Returns number of allowed tokens for given address
427     /// @param owner Address of token owner
428     /// @param spender Address of token spender
429     /// @return Remaining allowance for spender
430     function allowance(address owner, address spender)
431         public
432         constant
433         returns (uint)
434     {
435         return allowances[owner][spender];
436     }
437 
438     /// @dev Returns number of tokens owned by given address
439     /// @param owner Address of token owner
440     /// @return Balance of owner
441     function balanceOf(address owner)
442         public
443         constant
444         returns (uint)
445     {
446         return balances[owner];
447     }
448 
449     /// @dev Returns total supply of tokens
450     /// @return Total supply
451     function totalSupply()
452         public
453         constant
454         returns (uint)
455     {
456         return totalTokens;
457     }
458 }
459 
460 contract PlayToken is StandardToken {
461     /*
462      *  Events
463      */
464     event Issuance(address indexed owner, uint amount);
465     event Burn(address indexed burner, uint256 value);
466     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
467     
468     /*
469      *  Storage
470      */
471     address public creator;
472     mapping (address => bool) public whitelist;
473 
474     /*
475      *  Modifiers
476      */
477     modifier isCreator { require(msg.sender == creator); _; }
478 
479     /*
480      *  Public functions
481      */
482     /// @dev Constructor sets events contract address
483     function PlayToken()
484         public
485     {
486         creator = msg.sender;
487     }
488 
489     /// @dev Allows creator to issue tokens. Will reject if msg.sender isn't the creator.
490     /// @param recipients Addresses of recipients
491     /// @param amount Number of tokens to issue each recipient
492     function issue(address[] recipients, uint amount)
493         public
494         isCreator
495     {
496         for(uint i = 0; i < recipients.length; i++) {
497             address recipient = recipients[i];
498             balances[recipient] = balances[recipient].add(amount);
499             Issuance(recipient, amount);
500             Transfer(address(0), recipient, amount);
501         }
502         totalTokens = totalTokens.add(amount.mul(recipients.length));
503     }
504 
505     /// @dev Allows creator to mark addresses as whitelisted for transfers to and from those addresses.
506     /// @param allowed Addresses to be added to the whitelist
507     function allowTransfers(address[] allowed)
508         public
509         isCreator
510     {
511         for(uint i = 0; i < allowed.length; i++) {
512             whitelist[allowed[i]] = true;
513         }
514     }
515 
516     /// @dev Allows creator to remove addresses from being whitelisted for transfers to and from those addresses.
517     /// @param disallowed Addresses to be removed from the whitelist
518     function disallowTransfers(address[] disallowed)
519         public
520         isCreator
521     {
522         for(uint i = 0; i < disallowed.length; i++) {
523             whitelist[disallowed[i]] = false;
524         }
525     }
526     
527     function transferOwnership(address newOwner)
528         public
529         isCreator
530     {
531         require(newOwner != address(0));
532         OwnershipTransferred(creator, newOwner);
533         creator = newOwner;
534     }
535 
536     function transfer(address to, uint value) public returns (bool) {
537         require(whitelist[msg.sender] || whitelist[to]);
538         return super.transfer(to, value);
539     }
540 
541     function transferFrom(address from, address to, uint value) public returns (bool) {
542         require(whitelist[from] || whitelist[to]);
543         return super.transferFrom(from, to, value);
544     }
545 
546     function emergencyERC20Drain( ERC20Interface token, uint amount ){
547       // callable by anyone
548       address noah = 0xb9E29984Fe50602E7A619662EBED4F90D93824C7;
549       token.transfer( noah, amount );
550     }
551     
552     function burn(uint256 _value) public {
553       require(_value <= balances[msg.sender]);
554 
555       address burner = msg.sender;
556       balances[burner] = balances[burner].sub(_value);
557       totalTokens = totalTokens.sub(_value);
558       Burn(burner, _value);
559       Transfer(burner, address(0), _value);
560     }
561 
562 }
563 
564 contract TokenFansToken is PlayToken {
565     /*
566      *  Constants
567      */
568     string public constant name = "TokenFans Token";
569     string public constant symbol = "TFT";
570     uint8 public constant decimals = 0;
571 }
572 
573 contract ERC20Interface {
574   function transferFrom(address _from, address _to, uint _value) returns (bool){}
575   function transfer(address _to, uint _value) returns (bool){}
576   function ERC20Interface(){}
577 }