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
351     // 私募 20% 不锁定
352     address private_placement = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57;
353     // 基础设施建设 10% 不锁定
354     address infrastructure_building = 0x2A6a79F69439DE56a4Bdf8b16447D1Bea0e82Ce2;
355     // 基石 6% 不锁定 4% 锁定3个月
356     address cornerstone_investment = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
357     // 基金会发展费用金 3% 不锁定 3%锁定3个月 4%锁定9个月
358     address foundation_development = 0x6E46b4D8f4599D6bE5BE071CCC62554304901240;
359     // 团队奖励 3.75%锁定2年 3.75%锁定2.5年 3.75%锁定3年 3.75%锁定3.5年
360     address team_rewarding = 0x07bDB7D6aa3b119C29dCEDb3B7CA0DDDbFAE1bC0;
361 
362     function getLockWFee(address account, uint8 decimals, uint256 createTime) internal view returns (uint256) {
363         uint256 tempLockWFee = 0;
364         if (account == team_rewarding) {
365             // 团队奖励 3.75%锁定2年 3.75%锁定2.5年 3.75%锁定3年 3.75%锁定3.5年
366             if (now < createTime + 2 years) {
367                 tempLockWFee = 1500000000 * 10 ** uint256(decimals);
368             } else if (now < createTime + 2 years + 6 * 30 days) {
369                 tempLockWFee = 1125000000 * 10 ** uint256(decimals);
370             } else if (now < createTime + 3 years) {
371                 tempLockWFee = 750000000 * 10 ** uint256(decimals);
372             } else if (now < createTime + 3 years + 6 * 30 days) {
373                 tempLockWFee = 375000000 * 10 ** uint256(decimals);
374             }
375         } else if (account == foundation_development) {
376             // 基金会发展费用金 3% 不锁定 3%锁定3个月 4%锁定9个月
377             if (now < (createTime + 3 * 30 days)) {
378                 tempLockWFee = 700000000 * 10 ** uint256(decimals);
379             } else if (now < (createTime + 9 * 30 days)) {
380                 tempLockWFee = 400000000 * 10 ** uint256(decimals);
381             }
382         } else if (account == cornerstone_investment) {
383             // 基石 6% 不锁定 4% 锁定3个月
384             if (now < (createTime + 3 * 30 days)) {
385                 tempLockWFee = 400000000 * 10 ** uint256(decimals);
386             }
387         }
388         return tempLockWFee;
389     }
390 
391 }
392 
393 contract WFee is BaseERC20, BaseSafeMath, LockUtils {
394 
395     //The solidity created time
396     uint256 createTime;
397 
398     function WFee() public {
399         name = "WFee";
400         symbol = "WFEE";
401         decimals = 18;
402         totalSupply                       = 10000000000 * 10 ** uint256(decimals);
403         balanceOf[private_placement]       = 2000000000 * 10 ** uint256(decimals);
404         balanceOf[infrastructure_building] = 1000000000 * 10 ** uint256(decimals);
405         balanceOf[cornerstone_investment]  = 1000000000 * 10 ** uint256(decimals);
406         balanceOf[foundation_development]  = 1000000000 * 10 ** uint256(decimals);
407         balanceOf[team_rewarding]          = 1500000000 * 10 ** uint256(decimals);
408         balanceOf[msg.sender]              = 3500000000 * 10 ** uint256(decimals);
409         createTime = now;
410     }
411 
412     function _transfer(address _from, address _to, uint _value) internal {
413         // Prevent transfer to 0x0 address. Use burn() instead
414         require(_to != 0x0);
415         // Check if the sender has enough
416         // All transfer will check the available unlocked balance
417         require((balanceOf[_from] - getLockWFee(_from, decimals, createTime)) >= _value);
418         // require(balanceOf[_from] >= _value);
419         // Check for overflows
420         require((balanceOf[_to] + _value) > balanceOf[_to]);
421         // Save this for an assertion in the future
422         uint previousBalances = balanceOf[_from] + balanceOf[_to];
423         // Subtract from the sender
424         balanceOf[_from] -= _value;
425         // Add the same to the recipient
426         balanceOf[_to] += _value;
427         Transfer(_from, _to, _value);
428         // Asserts are used to use static analysis to find bugs in your code. They should never fail
429         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
430     }
431 
432     function transfer(address _to, uint256 _value) public {
433         _transfer(msg.sender, _to, _value);
434     }
435 
436     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
437         require(_value <= allowance[_from][msg.sender]);
438         // Check allowance
439         allowance[_from][msg.sender] -= _value;
440         _transfer(_from, _to, _value);
441         return true;
442     }
443 
444     function approve(address _spender, uint256 _value) public
445     returns (bool success) {
446         allowance[msg.sender][_spender] = _value;
447         return true;
448     }
449 
450     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
451     public
452     returns (bool success) {
453         tokenRecipient spender = tokenRecipient(_spender);
454         if (approve(_spender, _value)) {
455             spender.receiveApproval(msg.sender, _value, this, _extraData);
456             return true;
457         }
458     }
459 
460     function burn(uint256 _value) public returns (bool success) {
461         require(balanceOf[msg.sender] >= _value);
462         // Check if the sender has enough
463         balanceOf[msg.sender] -= _value;
464         // Subtract from the sender
465         totalSupply -= _value;
466         // Updates totalSupply
467         Burn(msg.sender, _value);
468         return true;
469     }
470 
471     function burnFrom(address _from, uint256 _value) public returns (bool success) {
472         require(balanceOf[_from] >= _value);
473         // Check if the targeted balance is enough
474         require(_value <= allowance[_from][msg.sender]);
475         // Check allowance
476         balanceOf[_from] -= _value;
477         // Subtract from the targeted balance
478         allowance[_from][msg.sender] -= _value;
479         // Subtract from the sender's allowance
480         totalSupply -= _value;
481         // Update totalSupply
482         Burn(_from, _value);
483         return true;
484     }
485 
486 }