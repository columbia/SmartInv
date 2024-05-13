1 pragma solidity ^0.5.16;
2 
3 import "./CarefulMath.sol";
4 
5 /**
6  * @title Exponential module for storing fixed-precision decimals
7  * @author Compound
8  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
9  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
10  *         `Exp({mantissa: 5100000000000000000})`.
11  */
12 contract Exponential is CarefulMath {
13     uint256 constant expScale = 1e18;
14     uint256 constant doubleScale = 1e36;
15     uint256 constant halfExpScale = expScale / 2;
16     uint256 constant mantissaOne = expScale;
17 
18     struct Exp {
19         uint256 mantissa;
20     }
21 
22     struct Double {
23         uint256 mantissa;
24     }
25 
26     /**
27      * @dev Creates an exponential from numerator and denominator values.
28      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
29      *            or if `denom` is zero.
30      */
31     function getExp(uint256 num, uint256 denom) internal pure returns (MathError, Exp memory) {
32         (MathError err0, uint256 scaledNumerator) = mulUInt(num, expScale);
33         if (err0 != MathError.NO_ERROR) {
34             return (err0, Exp({mantissa: 0}));
35         }
36 
37         (MathError err1, uint256 rational) = divUInt(scaledNumerator, denom);
38         if (err1 != MathError.NO_ERROR) {
39             return (err1, Exp({mantissa: 0}));
40         }
41 
42         return (MathError.NO_ERROR, Exp({mantissa: rational}));
43     }
44 
45     /**
46      * @dev Adds two exponentials, returning a new exponential.
47      */
48     function addExp(Exp memory a, Exp memory b) internal pure returns (MathError, Exp memory) {
49         (MathError error, uint256 result) = addUInt(a.mantissa, b.mantissa);
50 
51         return (error, Exp({mantissa: result}));
52     }
53 
54     /**
55      * @dev Subtracts two exponentials, returning a new exponential.
56      */
57     function subExp(Exp memory a, Exp memory b) internal pure returns (MathError, Exp memory) {
58         (MathError error, uint256 result) = subUInt(a.mantissa, b.mantissa);
59 
60         return (error, Exp({mantissa: result}));
61     }
62 
63     /**
64      * @dev Multiply an Exp by a scalar, returning a new Exp.
65      */
66     function mulScalar(Exp memory a, uint256 scalar) internal pure returns (MathError, Exp memory) {
67         (MathError err0, uint256 scaledMantissa) = mulUInt(a.mantissa, scalar);
68         if (err0 != MathError.NO_ERROR) {
69             return (err0, Exp({mantissa: 0}));
70         }
71 
72         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
73     }
74 
75     /**
76      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
77      */
78     function mulScalarTruncate(Exp memory a, uint256 scalar) internal pure returns (MathError, uint256) {
79         (MathError err, Exp memory product) = mulScalar(a, scalar);
80         if (err != MathError.NO_ERROR) {
81             return (err, 0);
82         }
83 
84         return (MathError.NO_ERROR, truncate(product));
85     }
86 
87     /**
88      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
89      */
90     function mulScalarTruncateAddUInt(
91         Exp memory a,
92         uint256 scalar,
93         uint256 addend
94     ) internal pure returns (MathError, uint256) {
95         (MathError err, Exp memory product) = mulScalar(a, scalar);
96         if (err != MathError.NO_ERROR) {
97             return (err, 0);
98         }
99 
100         return addUInt(truncate(product), addend);
101     }
102 
103     /**
104      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
105      */
106     function mul_ScalarTruncate(Exp memory a, uint256 scalar) internal pure returns (uint256) {
107         Exp memory product = mul_(a, scalar);
108         return truncate(product);
109     }
110 
111     /**
112      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
113      */
114     function mul_ScalarTruncateAddUInt(
115         Exp memory a,
116         uint256 scalar,
117         uint256 addend
118     ) internal pure returns (uint256) {
119         Exp memory product = mul_(a, scalar);
120         return add_(truncate(product), addend);
121     }
122 
123     /**
124      * @dev Divide an Exp by a scalar, returning a new Exp.
125      */
126     function divScalar(Exp memory a, uint256 scalar) internal pure returns (MathError, Exp memory) {
127         (MathError err0, uint256 descaledMantissa) = divUInt(a.mantissa, scalar);
128         if (err0 != MathError.NO_ERROR) {
129             return (err0, Exp({mantissa: 0}));
130         }
131 
132         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
133     }
134 
135     /**
136      * @dev Divide a scalar by an Exp, returning a new Exp.
137      */
138     function divScalarByExp(uint256 scalar, Exp memory divisor) internal pure returns (MathError, Exp memory) {
139         /*
140           We are doing this as:
141           getExp(mulUInt(expScale, scalar), divisor.mantissa)
142 
143           How it works:
144           Exp = a / b;
145           Scalar = s;
146           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
147         */
148         (MathError err0, uint256 numerator) = mulUInt(expScale, scalar);
149         if (err0 != MathError.NO_ERROR) {
150             return (err0, Exp({mantissa: 0}));
151         }
152         return getExp(numerator, divisor.mantissa);
153     }
154 
155     /**
156      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
157      */
158     function divScalarByExpTruncate(uint256 scalar, Exp memory divisor) internal pure returns (MathError, uint256) {
159         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
160         if (err != MathError.NO_ERROR) {
161             return (err, 0);
162         }
163 
164         return (MathError.NO_ERROR, truncate(fraction));
165     }
166 
167     /**
168      * @dev Divide a scalar by an Exp, returning a new Exp.
169      */
170     function div_ScalarByExp(uint256 scalar, Exp memory divisor) internal pure returns (Exp memory) {
171         /*
172           We are doing this as:
173           getExp(mulUInt(expScale, scalar), divisor.mantissa)
174 
175           How it works:
176           Exp = a / b;
177           Scalar = s;
178           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
179         */
180         uint256 numerator = mul_(expScale, scalar);
181         return Exp({mantissa: div_(numerator, divisor)});
182     }
183 
184     /**
185      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
186      */
187     function div_ScalarByExpTruncate(uint256 scalar, Exp memory divisor) internal pure returns (uint256) {
188         Exp memory fraction = div_ScalarByExp(scalar, divisor);
189         return truncate(fraction);
190     }
191 
192     /**
193      * @dev Multiplies two exponentials, returning a new exponential.
194      */
195     function mulExp(Exp memory a, Exp memory b) internal pure returns (MathError, Exp memory) {
196         (MathError err0, uint256 doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
197         if (err0 != MathError.NO_ERROR) {
198             return (err0, Exp({mantissa: 0}));
199         }
200 
201         // We add half the scale before dividing so that we get rounding instead of truncation.
202         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
203         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
204         (MathError err1, uint256 doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
205         if (err1 != MathError.NO_ERROR) {
206             return (err1, Exp({mantissa: 0}));
207         }
208 
209         (MathError err2, uint256 product) = divUInt(doubleScaledProductWithHalfScale, expScale);
210         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
211         assert(err2 == MathError.NO_ERROR);
212 
213         return (MathError.NO_ERROR, Exp({mantissa: product}));
214     }
215 
216     /**
217      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
218      */
219     function mulExp(uint256 a, uint256 b) internal pure returns (MathError, Exp memory) {
220         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
221     }
222 
223     /**
224      * @dev Multiplies three exponentials, returning a new exponential.
225      */
226     function mulExp3(
227         Exp memory a,
228         Exp memory b,
229         Exp memory c
230     ) internal pure returns (MathError, Exp memory) {
231         (MathError err, Exp memory ab) = mulExp(a, b);
232         if (err != MathError.NO_ERROR) {
233             return (err, ab);
234         }
235         return mulExp(ab, c);
236     }
237 
238     /**
239      * @dev Divides two exponentials, returning a new exponential.
240      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
241      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
242      */
243     function divExp(Exp memory a, Exp memory b) internal pure returns (MathError, Exp memory) {
244         return getExp(a.mantissa, b.mantissa);
245     }
246 
247     /**
248      * @dev Truncates the given exp to a whole number value.
249      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
250      */
251     function truncate(Exp memory exp) internal pure returns (uint256) {
252         // Note: We are not using careful math here as we're performing a division that cannot fail
253         return exp.mantissa / expScale;
254     }
255 
256     /**
257      * @dev Checks if first Exp is less than second Exp.
258      */
259     function lessThanExp(Exp memory left, Exp memory right) internal pure returns (bool) {
260         return left.mantissa < right.mantissa;
261     }
262 
263     /**
264      * @dev Checks if left Exp <= right Exp.
265      */
266     function lessThanOrEqualExp(Exp memory left, Exp memory right) internal pure returns (bool) {
267         return left.mantissa <= right.mantissa;
268     }
269 
270     /**
271      * @dev returns true if Exp is exactly zero
272      */
273     function isZeroExp(Exp memory value) internal pure returns (bool) {
274         return value.mantissa == 0;
275     }
276 
277     function safe224(uint256 n, string memory errorMessage) internal pure returns (uint224) {
278         require(n < 2**224, errorMessage);
279         return uint224(n);
280     }
281 
282     function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
283         require(n < 2**32, errorMessage);
284         return uint32(n);
285     }
286 
287     function add_(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
288         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
289     }
290 
291     function add_(Double memory a, Double memory b) internal pure returns (Double memory) {
292         return Double({mantissa: add_(a.mantissa, b.mantissa)});
293     }
294 
295     function add_(uint256 a, uint256 b) internal pure returns (uint256) {
296         return add_(a, b, "addition overflow");
297     }
298 
299     function add_(
300         uint256 a,
301         uint256 b,
302         string memory errorMessage
303     ) internal pure returns (uint256) {
304         uint256 c = a + b;
305         require(c >= a, errorMessage);
306         return c;
307     }
308 
309     function sub_(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
310         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
311     }
312 
313     function sub_(Double memory a, Double memory b) internal pure returns (Double memory) {
314         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
315     }
316 
317     function sub_(uint256 a, uint256 b) internal pure returns (uint256) {
318         return sub_(a, b, "subtraction underflow");
319     }
320 
321     function sub_(
322         uint256 a,
323         uint256 b,
324         string memory errorMessage
325     ) internal pure returns (uint256) {
326         require(b <= a, errorMessage);
327         return a - b;
328     }
329 
330     function mul_(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
331         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
332     }
333 
334     function mul_(Exp memory a, uint256 b) internal pure returns (Exp memory) {
335         return Exp({mantissa: mul_(a.mantissa, b)});
336     }
337 
338     function mul_(uint256 a, Exp memory b) internal pure returns (uint256) {
339         return mul_(a, b.mantissa) / expScale;
340     }
341 
342     function mul_(Double memory a, Double memory b) internal pure returns (Double memory) {
343         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
344     }
345 
346     function mul_(Double memory a, uint256 b) internal pure returns (Double memory) {
347         return Double({mantissa: mul_(a.mantissa, b)});
348     }
349 
350     function mul_(uint256 a, Double memory b) internal pure returns (uint256) {
351         return mul_(a, b.mantissa) / doubleScale;
352     }
353 
354     function mul_(uint256 a, uint256 b) internal pure returns (uint256) {
355         return mul_(a, b, "multiplication overflow");
356     }
357 
358     function mul_(
359         uint256 a,
360         uint256 b,
361         string memory errorMessage
362     ) internal pure returns (uint256) {
363         if (a == 0 || b == 0) {
364             return 0;
365         }
366         uint256 c = a * b;
367         require(c / a == b, errorMessage);
368         return c;
369     }
370 
371     function div_(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
372         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
373     }
374 
375     function div_(Exp memory a, uint256 b) internal pure returns (Exp memory) {
376         return Exp({mantissa: div_(a.mantissa, b)});
377     }
378 
379     function div_(uint256 a, Exp memory b) internal pure returns (uint256) {
380         return div_(mul_(a, expScale), b.mantissa);
381     }
382 
383     function div_(Double memory a, Double memory b) internal pure returns (Double memory) {
384         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
385     }
386 
387     function div_(Double memory a, uint256 b) internal pure returns (Double memory) {
388         return Double({mantissa: div_(a.mantissa, b)});
389     }
390 
391     function div_(uint256 a, Double memory b) internal pure returns (uint256) {
392         return div_(mul_(a, doubleScale), b.mantissa);
393     }
394 
395     function div_(uint256 a, uint256 b) internal pure returns (uint256) {
396         return div_(a, b, "divide by zero");
397     }
398 
399     function div_(
400         uint256 a,
401         uint256 b,
402         string memory errorMessage
403     ) internal pure returns (uint256) {
404         require(b > 0, errorMessage);
405         return a / b;
406     }
407 
408     function fraction(uint256 a, uint256 b) internal pure returns (Double memory) {
409         return Double({mantissa: div_(mul_(a, doubleScale), b)});
410     }
411 
412     // implementation from https://github.com/Uniswap/uniswap-lib/commit/99f3f28770640ba1bb1ff460ac7c5292fb8291a0
413     // original implementation: https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
414     function sqrt(uint256 x) internal pure returns (uint256) {
415         if (x == 0) return 0;
416         uint256 xx = x;
417         uint256 r = 1;
418 
419         if (xx >= 0x100000000000000000000000000000000) {
420             xx >>= 128;
421             r <<= 64;
422         }
423         if (xx >= 0x10000000000000000) {
424             xx >>= 64;
425             r <<= 32;
426         }
427         if (xx >= 0x100000000) {
428             xx >>= 32;
429             r <<= 16;
430         }
431         if (xx >= 0x10000) {
432             xx >>= 16;
433             r <<= 8;
434         }
435         if (xx >= 0x100) {
436             xx >>= 8;
437             r <<= 4;
438         }
439         if (xx >= 0x10) {
440             xx >>= 4;
441             r <<= 2;
442         }
443         if (xx >= 0x8) {
444             r <<= 1;
445         }
446 
447         r = (r + x / r) >> 1;
448         r = (r + x / r) >> 1;
449         r = (r + x / r) >> 1;
450         r = (r + x / r) >> 1;
451         r = (r + x / r) >> 1;
452         r = (r + x / r) >> 1;
453         r = (r + x / r) >> 1; // Seven iterations should be enough
454         uint256 r1 = x / r;
455         return (r < r1 ? r : r1);
456     }
457 }
