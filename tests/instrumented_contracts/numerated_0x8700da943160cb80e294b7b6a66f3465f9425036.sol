1 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
2 
3 pragma solidity ^0.5.2;
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
65 pragma solidity ^0.5.2;
66 
67 /// @title Math library - Allows calculation of logarithmic and exponential functions
68 /// @author Alan Lu - <alan.lu@gnosis.pm>
69 /// @author Stefan George - <stefan@gnosis.pm>
70 library GnosisMath {
71     /*
72      *  Constants
73      */
74     // This is equal to 1 in our calculations
75     uint public constant ONE = 0x10000000000000000;
76     uint public constant LN2 = 0xb17217f7d1cf79ac;
77     uint public constant LOG2_E = 0x171547652b82fe177;
78 
79     /*
80      *  Public functions
81      */
82     /// @dev Returns natural exponential function value of given x
83     /// @param x x
84     /// @return e**x
85     function exp(int x) public pure returns (uint) {
86         // revert if x is > MAX_POWER, where
87         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
88         require(x <= 2454971259878909886679);
89         // return 0 if exp(x) is tiny, using
90         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
91         if (x < -818323753292969962227) return 0;
92         // Transform so that e^x -> 2^x
93         x = x * int(ONE) / int(LN2);
94         // 2^x = 2^whole(x) * 2^frac(x)
95         //       ^^^^^^^^^^ is a bit shift
96         // so Taylor expand on z = frac(x)
97         int shift;
98         uint z;
99         if (x >= 0) {
100             shift = x / int(ONE);
101             z = uint(x % int(ONE));
102         } else {
103             shift = x / int(ONE) - 1;
104             z = ONE - uint(-x % int(ONE));
105         }
106         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
107         //
108         // Can generate the z coefficients using mpmath and the following lines
109         // >>> from mpmath import mp
110         // >>> mp.dps = 100
111         // >>> ONE =  0x10000000000000000
112         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
113         // 0xb17217f7d1cf79ab
114         // 0x3d7f7bff058b1d50
115         // 0xe35846b82505fc5
116         // 0x276556df749cee5
117         // 0x5761ff9e299cc4
118         // 0xa184897c363c3
119         uint zpow = z;
120         uint result = ONE;
121         result += 0xb17217f7d1cf79ab * zpow / ONE;
122         zpow = zpow * z / ONE;
123         result += 0x3d7f7bff058b1d50 * zpow / ONE;
124         zpow = zpow * z / ONE;
125         result += 0xe35846b82505fc5 * zpow / ONE;
126         zpow = zpow * z / ONE;
127         result += 0x276556df749cee5 * zpow / ONE;
128         zpow = zpow * z / ONE;
129         result += 0x5761ff9e299cc4 * zpow / ONE;
130         zpow = zpow * z / ONE;
131         result += 0xa184897c363c3 * zpow / ONE;
132         zpow = zpow * z / ONE;
133         result += 0xffe5fe2c4586 * zpow / ONE;
134         zpow = zpow * z / ONE;
135         result += 0x162c0223a5c8 * zpow / ONE;
136         zpow = zpow * z / ONE;
137         result += 0x1b5253d395e * zpow / ONE;
138         zpow = zpow * z / ONE;
139         result += 0x1e4cf5158b * zpow / ONE;
140         zpow = zpow * z / ONE;
141         result += 0x1e8cac735 * zpow / ONE;
142         zpow = zpow * z / ONE;
143         result += 0x1c3bd650 * zpow / ONE;
144         zpow = zpow * z / ONE;
145         result += 0x1816193 * zpow / ONE;
146         zpow = zpow * z / ONE;
147         result += 0x131496 * zpow / ONE;
148         zpow = zpow * z / ONE;
149         result += 0xe1b7 * zpow / ONE;
150         zpow = zpow * z / ONE;
151         result += 0x9c7 * zpow / ONE;
152         if (shift >= 0) {
153             if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
154             return result << shift;
155         } else return result >> (-shift);
156     }
157 
158     /// @dev Returns natural logarithm value of given x
159     /// @param x x
160     /// @return ln(x)
161     function ln(uint x) public pure returns (int) {
162         require(x > 0);
163         // binary search for floor(log2(x))
164         int ilog2 = floorLog2(x);
165         int z;
166         if (ilog2 < 0) z = int(x << uint(-ilog2));
167         else z = int(x >> uint(ilog2));
168         // z = x * 2^-⌊log₂x⌋
169         // so 1 <= z < 2
170         // and ln z = ln x - ⌊log₂x⌋/log₂e
171         // so just compute ln z using artanh series
172         // and calculate ln x from that
173         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
174         int halflnz = term;
175         int termpow = term * term / int(ONE) * term / int(ONE);
176         halflnz += termpow / 3;
177         termpow = termpow * term / int(ONE) * term / int(ONE);
178         halflnz += termpow / 5;
179         termpow = termpow * term / int(ONE) * term / int(ONE);
180         halflnz += termpow / 7;
181         termpow = termpow * term / int(ONE) * term / int(ONE);
182         halflnz += termpow / 9;
183         termpow = termpow * term / int(ONE) * term / int(ONE);
184         halflnz += termpow / 11;
185         termpow = termpow * term / int(ONE) * term / int(ONE);
186         halflnz += termpow / 13;
187         termpow = termpow * term / int(ONE) * term / int(ONE);
188         halflnz += termpow / 15;
189         termpow = termpow * term / int(ONE) * term / int(ONE);
190         halflnz += termpow / 17;
191         termpow = termpow * term / int(ONE) * term / int(ONE);
192         halflnz += termpow / 19;
193         termpow = termpow * term / int(ONE) * term / int(ONE);
194         halflnz += termpow / 21;
195         termpow = termpow * term / int(ONE) * term / int(ONE);
196         halflnz += termpow / 23;
197         termpow = termpow * term / int(ONE) * term / int(ONE);
198         halflnz += termpow / 25;
199         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
200     }
201 
202     /// @dev Returns base 2 logarithm value of given x
203     /// @param x x
204     /// @return logarithmic value
205     function floorLog2(uint x) public pure returns (int lo) {
206         lo = -64;
207         int hi = 193;
208         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
209         int mid = (hi + lo) >> 1;
210         while ((lo + 1) < hi) {
211             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
212             else lo = mid;
213             mid = (hi + lo) >> 1;
214         }
215     }
216 
217     /// @dev Returns maximum of an array
218     /// @param nums Numbers to look through
219     /// @return Maximum number
220     function max(int[] memory nums) public pure returns (int maxNum) {
221         require(nums.length > 0);
222         maxNum = -2 ** 255;
223         for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
224     }
225 
226     /// @dev Returns whether an add operation causes an overflow
227     /// @param a First addend
228     /// @param b Second addend
229     /// @return Did no overflow occur?
230     function safeToAdd(uint a, uint b) internal pure returns (bool) {
231         return a + b >= a;
232     }
233 
234     /// @dev Returns whether a subtraction operation causes an underflow
235     /// @param a Minuend
236     /// @param b Subtrahend
237     /// @return Did no underflow occur?
238     function safeToSub(uint a, uint b) internal pure returns (bool) {
239         return a >= b;
240     }
241 
242     /// @dev Returns whether a multiply operation causes an overflow
243     /// @param a First factor
244     /// @param b Second factor
245     /// @return Did no overflow occur?
246     function safeToMul(uint a, uint b) internal pure returns (bool) {
247         return b == 0 || a * b / b == a;
248     }
249 
250     /// @dev Returns sum if no overflow occurred
251     /// @param a First addend
252     /// @param b Second addend
253     /// @return Sum
254     function add(uint a, uint b) internal pure returns (uint) {
255         require(safeToAdd(a, b));
256         return a + b;
257     }
258 
259     /// @dev Returns difference if no overflow occurred
260     /// @param a Minuend
261     /// @param b Subtrahend
262     /// @return Difference
263     function sub(uint a, uint b) internal pure returns (uint) {
264         require(safeToSub(a, b));
265         return a - b;
266     }
267 
268     /// @dev Returns product if no overflow occurred
269     /// @param a First factor
270     /// @param b Second factor
271     /// @return Product
272     function mul(uint a, uint b) internal pure returns (uint) {
273         require(safeToMul(a, b));
274         return a * b;
275     }
276 
277     /// @dev Returns whether an add operation causes an overflow
278     /// @param a First addend
279     /// @param b Second addend
280     /// @return Did no overflow occur?
281     function safeToAdd(int a, int b) internal pure returns (bool) {
282         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
283     }
284 
285     /// @dev Returns whether a subtraction operation causes an underflow
286     /// @param a Minuend
287     /// @param b Subtrahend
288     /// @return Did no underflow occur?
289     function safeToSub(int a, int b) internal pure returns (bool) {
290         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
291     }
292 
293     /// @dev Returns whether a multiply operation causes an overflow
294     /// @param a First factor
295     /// @param b Second factor
296     /// @return Did no overflow occur?
297     function safeToMul(int a, int b) internal pure returns (bool) {
298         return (b == 0) || (a * b / b == a);
299     }
300 
301     /// @dev Returns sum if no overflow occurred
302     /// @param a First addend
303     /// @param b Second addend
304     /// @return Sum
305     function add(int a, int b) internal pure returns (int) {
306         require(safeToAdd(a, b));
307         return a + b;
308     }
309 
310     /// @dev Returns difference if no overflow occurred
311     /// @param a Minuend
312     /// @param b Subtrahend
313     /// @return Difference
314     function sub(int a, int b) internal pure returns (int) {
315         require(safeToSub(a, b));
316         return a - b;
317     }
318 
319     /// @dev Returns product if no overflow occurred
320     /// @param a First factor
321     /// @param b Second factor
322     /// @return Product
323     function mul(int a, int b) internal pure returns (int) {
324         require(safeToMul(a, b));
325         return a * b;
326     }
327 }
328 
329 // File: @gnosis.pm/util-contracts/contracts/GnosisStandardToken.sol
330 
331 pragma solidity ^0.5.2;
332 
333 
334 
335 
336 /**
337  * Deprecated: Use Open Zeppeling one instead
338  */
339 contract StandardTokenData {
340     /*
341      *  Storage
342      */
343     mapping(address => uint) balances;
344     mapping(address => mapping(address => uint)) allowances;
345     uint totalTokens;
346 }
347 
348 /**
349  * Deprecated: Use Open Zeppeling one instead
350  */
351 /// @title Standard token contract with overflow protection
352 contract GnosisStandardToken is Token, StandardTokenData {
353     using GnosisMath for *;
354 
355     /*
356      *  Public functions
357      */
358     /// @dev Transfers sender's tokens to a given address. Returns success
359     /// @param to Address of token receiver
360     /// @param value Number of tokens to transfer
361     /// @return Was transfer successful?
362     function transfer(address to, uint value) public returns (bool) {
363         if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
364             return false;
365         }
366 
367         balances[msg.sender] -= value;
368         balances[to] += value;
369         emit Transfer(msg.sender, to, value);
370         return true;
371     }
372 
373     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
374     /// @param from Address from where tokens are withdrawn
375     /// @param to Address to where tokens are sent
376     /// @param value Number of tokens to transfer
377     /// @return Was transfer successful?
378     function transferFrom(address from, address to, uint value) public returns (bool) {
379         if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
380             value
381         ) || !balances[to].safeToAdd(value)) {
382             return false;
383         }
384         balances[from] -= value;
385         allowances[from][msg.sender] -= value;
386         balances[to] += value;
387         emit Transfer(from, to, value);
388         return true;
389     }
390 
391     /// @dev Sets approved amount of tokens for spender. Returns success
392     /// @param spender Address of allowed account
393     /// @param value Number of approved tokens
394     /// @return Was approval successful?
395     function approve(address spender, uint value) public returns (bool) {
396         allowances[msg.sender][spender] = value;
397         emit Approval(msg.sender, spender, value);
398         return true;
399     }
400 
401     /// @dev Returns number of allowed tokens for given address
402     /// @param owner Address of token owner
403     /// @param spender Address of token spender
404     /// @return Remaining allowance for spender
405     function allowance(address owner, address spender) public view returns (uint) {
406         return allowances[owner][spender];
407     }
408 
409     /// @dev Returns number of tokens owned by given address
410     /// @param owner Address of token owner
411     /// @return Balance of owner
412     function balanceOf(address owner) public view returns (uint) {
413         return balances[owner];
414     }
415 
416     /// @dev Returns total supply of tokens
417     /// @return Total supply
418     function totalSupply() public view returns (uint) {
419         return totalTokens;
420     }
421 }
422 
423 // File: contracts/TokenFRTProxy.sol
424 
425 pragma solidity ^0.5.2;
426 
427 
428 
429 
430 contract TokenFRTProxy is Proxy, GnosisStandardToken {
431     /// @dev State variables remain for Blockchain exploring Proxied Token contracts
432     address public owner;
433 
434     string public constant symbol = "MGN";
435     string public constant name = "Magnolia Token";
436     uint8 public constant decimals = 18;
437 
438     constructor(address proxied, address _owner) public Proxy(proxied) {
439         require(_owner != address(0), "owner address cannot be 0");
440         owner = _owner;
441     }
442 }