1 pragma solidity ^0.4.16;
2 
3 /**
4 
5  * Math operations with safety checks
6 
7  */
8 
9 contract BaseSafeMath {
10 
11 
12     /*
13 
14     standard uint256 functions
15 
16      */
17 
18 
19 
20     function add(uint256 a, uint256 b) internal pure
21 
22     returns (uint256) {
23 
24         uint256 c = a + b;
25 
26         assert(c >= a);
27 
28         return c;
29 
30     }
31 
32 
33     function sub(uint256 a, uint256 b) internal pure
34 
35     returns (uint256) {
36 
37         assert(b <= a);
38 
39         return a - b;
40 
41     }
42 
43 
44     function mul(uint256 a, uint256 b) internal pure
45 
46     returns (uint256) {
47 
48         uint256 c = a * b;
49 
50         assert(a == 0 || c / a == b);
51 
52         return c;
53 
54     }
55 
56 
57     function div(uint256 a, uint256 b) internal pure
58 
59     returns (uint256) {
60 
61         uint256 c = a / b;
62 
63         return c;
64 
65     }
66 
67 
68     function min(uint256 x, uint256 y) internal pure
69 
70     returns (uint256 z) {
71 
72         return x <= y ? x : y;
73 
74     }
75 
76 
77     function max(uint256 x, uint256 y) internal pure
78 
79     returns (uint256 z) {
80 
81         return x >= y ? x : y;
82 
83     }
84 
85 
86 
87     /*
88 
89     uint128 functions
90 
91      */
92 
93 
94 
95     function madd(uint128 a, uint128 b) internal pure
96 
97     returns (uint128) {
98 
99         uint128 c = a + b;
100 
101         assert(c >= a);
102 
103         return c;
104 
105     }
106 
107 
108     function msub(uint128 a, uint128 b) internal pure
109 
110     returns (uint128) {
111 
112         assert(b <= a);
113 
114         return a - b;
115 
116     }
117 
118 
119     function mmul(uint128 a, uint128 b) internal pure
120 
121     returns (uint128) {
122 
123         uint128 c = a * b;
124 
125         assert(a == 0 || c / a == b);
126 
127         return c;
128 
129     }
130 
131 
132     function mdiv(uint128 a, uint128 b) internal pure
133 
134     returns (uint128) {
135 
136         uint128 c = a / b;
137 
138         return c;
139 
140     }
141 
142 
143     function mmin(uint128 x, uint128 y) internal pure
144 
145     returns (uint128 z) {
146 
147         return x <= y ? x : y;
148 
149     }
150 
151 
152     function mmax(uint128 x, uint128 y) internal pure
153 
154     returns (uint128 z) {
155 
156         return x >= y ? x : y;
157 
158     }
159 
160 
161 
162     /*
163 
164     uint64 functions
165 
166      */
167 
168 
169 
170     function miadd(uint64 a, uint64 b) internal pure
171 
172     returns (uint64) {
173 
174         uint64 c = a + b;
175 
176         assert(c >= a);
177 
178         return c;
179 
180     }
181 
182 
183     function misub(uint64 a, uint64 b) internal pure
184 
185     returns (uint64) {
186 
187         assert(b <= a);
188 
189         return a - b;
190 
191     }
192 
193 
194     function mimul(uint64 a, uint64 b) internal pure
195 
196     returns (uint64) {
197 
198         uint64 c = a * b;
199 
200         assert(a == 0 || c / a == b);
201 
202         return c;
203 
204     }
205 
206 
207     function midiv(uint64 a, uint64 b) internal pure
208 
209     returns (uint64) {
210 
211         uint64 c = a / b;
212 
213         return c;
214 
215     }
216 
217 
218     function mimin(uint64 x, uint64 y) internal pure
219 
220     returns (uint64 z) {
221 
222         return x <= y ? x : y;
223 
224     }
225 
226 
227     function mimax(uint64 x, uint64 y) internal pure
228 
229     returns (uint64 z) {
230 
231         return x >= y ? x : y;
232 
233     }
234 
235 
236 }
237 
238 
239 // Abstract contract for the full ERC 20 Token standard
240 
241 // https://github.com/ethereum/EIPs/issues/20
242 
243 
244 
245 contract BaseERC20 {
246 
247     // Public variables of the token
248     string public name;
249     string public symbol;
250     uint8 public decimals;
251     // 18 decimals is the strongly suggested default, avoid changing it
252     uint256 public totalSupply;
253 
254     // This creates an array with all balances
255     mapping(address => uint256) public balanceOf;
256     mapping(address => mapping(address => uint256)) public allowance;
257 
258     // This generates a public event on the blockchain that will notify clients
259     event Transfer(address indexed from, address indexed to, uint256 value);
260 
261     // This notifies clients about the amount burnt
262     event Burn(address indexed from, uint256 value);
263 
264     /**
265      * Internal transfer, only can be called by this contract
266      */
267     function _transfer(address _from, address _to, uint _value) internal;
268 
269     /**
270      * Transfer tokens
271      *
272      * Send `_value` tokens to `_to` from your account
273      *
274      * @param _to The address of the recipient
275      * @param _value the amount to send
276      */
277     function transfer(address _to, uint256 _value) public;
278 
279     /**
280      * Transfer tokens from other address
281      *
282      * Send `_value` tokens to `_to` on behalf of `_from`
283      *
284      * @param _from The address of the sender
285      * @param _to The address of the recipient
286      * @param _value the amount to send
287      */
288     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
289 
290     /**
291      * Set allowance for other address
292      *
293      * Allows `_spender` to spend no more than `_value` tokens on your behalf
294      *
295      * @param _spender The address authorized to spend
296      * @param _value the max amount they can spend
297      */
298     function approve(address _spender, uint256 _value) public returns (bool success);
299 
300     /**
301      * Set allowance for other address and notify
302      *
303      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
304      *
305      * @param _spender The address authorized to spend
306      * @param _value the max amount they can spend
307      * @param _extraData some extra information to send to the approved contract
308      */
309     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
310 
311     /**
312      * Destroy tokens
313      *
314      * Remove `_value` tokens from the system irreversibly
315      *
316      * @param _value the amount of money to burn
317      */
318     function burn(uint256 _value) public returns (bool success);
319 
320     /**
321      * Destroy tokens from other account
322      *
323      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
324      *
325      * @param _from the address of the sender
326      * @param _value the amount of money to burn
327      */
328     function burnFrom(address _from, uint256 _value) public returns (bool success);
329 
330 }
331 
332 
333 /**
334 
335  * @title Standard ERC20 token
336 
337  *
338 
339  * @dev Implementation of the basic standard token.
340 
341  * @dev https://github.com/ethereum/EIPs/issues/20
342 
343  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
344 
345  */
346 
347 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;}
348 
349 
350 contract LockUtils {
351 
352     function getLockWFee(address account, uint8 decimals, uint256 createTime, address developer) internal view returns (uint256) {
353         uint256 tempLockWFee = 0;
354         if (account == developer) {
355             if (now < (createTime + 10 minutes)) {
356                 tempLockWFee = 1500000000 * 10 ** uint256(decimals);
357             } else if (now < (createTime + 20 minutes)) {
358                 tempLockWFee = 1125000000 * 10 ** uint256(decimals);
359             } else if (now < (createTime + 30 minutes)) {
360                 tempLockWFee = 750000000 * 10 ** uint256(decimals);
361             } else if (now < (createTime + 40 minutes)) {
362                 tempLockWFee = 375000000 * 10 ** uint256(decimals);
363             }
364             //            if (now < createTime + 2 years) {
365             //                tempLockWFee = 1500000000 * 10 ** uint256(decimals);
366             //            } else if (now < createTime + 2 years + 6 * 30 days) {
367             //                tempLockWFee = 1125000000 * 10 ** uint256(decimals);
368             //            } else if (now < createTime + 3 years) {
369             //                tempLockWFee = 750000000 * 10 ** uint256(decimals);
370             //            } else if (now < createTime + 3 years + 6 * 30 days) {
371             //                tempLockWFee = 375000000 * 10 ** uint256(decimals);
372             //            }
373         }
374         return tempLockWFee;
375     }
376 
377 }
378 
379 contract WFee is BaseERC20, BaseSafeMath, LockUtils {
380     string public name = "WFee";
381     string public symbol = "WFEE";
382     uint8 public decimals = 18;// 精度为18
383     uint256 public totalSupply;// 100亿 构造方法初始化
384     uint256 createTime;// 创建时间
385     mapping(address => uint256) public balanceOf;
386     mapping(address => mapping(address => uint256)) public allowance;
387     address developer;
388 
389     event Transfer(address indexed from, address indexed to, uint256 value);
390     event Burn(address indexed from, uint256 value);
391 
392     function WFee() public {
393         totalSupply = 10000000000 * 10 ** uint256(decimals);
394         balanceOf[msg.sender] = totalSupply;
395         developer = msg.sender;
396         createTime = now;
397     }
398 
399     function _transfer(address _from, address _to, uint _value) internal {
400         // Prevent transfer to 0x0 address. Use burn() instead
401         require(_to != 0x0);
402         // Check if the sender has enough
403         // 转账必由之路，锁定的钱不可动
404         require((balanceOf[_from] - getLockWFee(_from, decimals, createTime, developer)) >= _value);
405         // require(balanceOf[_from] >= _value);
406         // Check for overflows
407         require((balanceOf[_to] + _value) > balanceOf[_to]);
408         // Save this for an assertion in the future
409         uint previousBalances = balanceOf[_from] + balanceOf[_to];
410         // Subtract from the sender
411         balanceOf[_from] -= _value;
412         // Add the same to the recipient
413         balanceOf[_to] += _value;
414         Transfer(_from, _to, _value);
415         // Asserts are used to use static analysis to find bugs in your code. They should never fail
416         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
417     }
418 
419     function transfer(address _to, uint256 _value) public {
420         _transfer(msg.sender, _to, _value);
421     }
422 
423     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
424         require(_value <= allowance[_from][msg.sender]);
425         // Check allowance
426         allowance[_from][msg.sender] -= _value;
427         _transfer(_from, _to, _value);
428         return true;
429     }
430 
431     function approve(address _spender, uint256 _value) public
432     returns (bool success) {
433         allowance[msg.sender][_spender] = _value;
434         return true;
435     }
436 
437     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
438     public
439     returns (bool success) {
440         tokenRecipient spender = tokenRecipient(_spender);
441         if (approve(_spender, _value)) {
442             spender.receiveApproval(msg.sender, _value, this, _extraData);
443             return true;
444         }
445     }
446 
447     function burn(uint256 _value) public returns (bool success) {
448         require(balanceOf[msg.sender] >= _value);
449         // Check if the sender has enough
450         balanceOf[msg.sender] -= _value;
451         // Subtract from the sender
452         totalSupply -= _value;
453         // Updates totalSupply
454         Burn(msg.sender, _value);
455         return true;
456     }
457 
458     function burnFrom(address _from, uint256 _value) public returns (bool success) {
459         require(balanceOf[_from] >= _value);
460         // Check if the targeted balance is enough
461         require(_value <= allowance[_from][msg.sender]);
462         // Check allowance
463         balanceOf[_from] -= _value;
464         // Subtract from the targeted balance
465         allowance[_from][msg.sender] -= _value;
466         // Subtract from the sender's allowance
467         totalSupply -= _value;
468         // Update totalSupply
469         Burn(_from, _value);
470         return true;
471     }
472 
473 }