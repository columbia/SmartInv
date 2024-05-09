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
416 // File: contracts/TokenFRTProxy.sol
417 
418 contract TokenFRTProxy is Proxy, GnosisStandardToken {
419     /// @dev State variables remain for Blockchain exploring Proxied Token contracts
420     address public owner;
421 
422     string public constant symbol = "MGN";
423     string public constant name = "Magnolia Token";
424     uint8 public constant decimals = 18;
425 
426     constructor(address proxied, address _owner) public Proxy(proxied) {
427         require(_owner != address(0), "owner address cannot be 0");
428         owner = _owner;
429     }
430 }