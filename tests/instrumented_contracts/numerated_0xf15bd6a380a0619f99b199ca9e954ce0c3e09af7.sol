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
243 contract BaseERC20 {
244 
245     // Public variables of the token
246     string public name;
247     string public symbol;
248     uint8 public decimals;
249     // 18 decimals is the strongly suggested default, avoid changing it
250     uint256 public totalSupply;
251 
252     // This creates an array with all balances
253     mapping(address => uint256) public balanceOf;
254     mapping(address => mapping(address => uint256)) public allowance;
255 
256     // This generates a public event on the blockchain that will notify clients
257     event Transfer(address indexed from, address indexed to, uint256 value);
258 
259     /**
260      * Internal transfer, only can be called by this contract
261      */
262     function _transfer(address _from, address _to, uint _value) internal;
263 
264     /**
265      * Transfer tokens
266      *
267      * Send `_value` tokens to `_to` from your account
268      *
269      * @param _to The address of the recipient
270      * @param _value the amount to send
271      */
272     function transfer(address _to, uint256 _value) public;
273 
274     /**
275      * Transfer tokens from other address
276      *
277      * Send `_value` tokens to `_to` on behalf of `_from`
278      *
279      * @param _from The address of the sender
280      * @param _to The address of the recipient
281      * @param _value the amount to send
282      */
283     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
284 
285     /**
286      * Set allowance for other address
287      *
288      * Allows `_spender` to spend no more than `_value` tokens on your behalf
289      *
290      * @param _spender The address authorized to spend
291      * @param _value the max amount they can spend
292      */
293     function approve(address _spender, uint256 _value) public returns (bool success);
294 
295     /**
296      * Set allowance for other address and notify
297      *
298      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
299      *
300      * @param _spender The address authorized to spend
301      * @param _value the max amount they can spend
302      * @param _extraData some extra information to send to the approved contract
303      */
304     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
305 
306 }
307 
308 
309 /**
310 
311  * @title Standard ERC20 token
312 
313  *
314 
315  * @dev Implementation of the basic standard token.
316 
317  * @dev https://github.com/ethereum/EIPs/issues/20
318 
319  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
320 
321  */
322 
323 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;}
324 
325 
326 contract LockUtils {
327     // Advance mining
328     address advance_mining = 0x5EDBe36c4c4a816f150959B445d5Ae1F33054a82;
329     // community
330     address community = 0xacF2e917E296547C0C476fDACf957111ca0307ce;
331     // foundation_investment
332     address foundation_investment = 0x9746079BEbcFfFf177818e23AedeC834ad0fb5f9;
333     // mining
334     address mining = 0xBB7d6f428E77f98069AE1E01964A9Ed6db3c5Fe5;
335     // adviser
336     address adviser = 0x0aE269Ae5F511786Fce5938c141DbF42e8A71E12;
337     // unlock start time 2018-09-10
338     uint256 unlock_time_0910 = 1536508800;
339     // unlock start time 2018-10-10
340     uint256 unlock_time_1010 = 1539100800;
341     // unlock start time 2018-11-10
342     uint256 unlock_time_1110 = 1541779200;
343     // unlock start time 2018-12-10
344     uint256 unlock_time_1210 = 1544371200;
345     // unlock start time 2019-01-10
346     uint256 unlock_time_0110 = 1547049600;
347     // unlock start time 2019-02-10
348     uint256 unlock_time_0210 = 1549728000;
349     // unlock start time 2019-03-10
350     uint256 unlock_time_0310 = 1552147200;
351     // unlock start time 2019-04-10
352     uint256 unlock_time_0410 = 1554825600;
353     // unlock start time 2019-05-10
354     uint256 unlock_time_0510 = 1557417600;
355     // unlock start time 2019-06-10
356     uint256 unlock_time_0610 = 1560096000;
357     // unlock start time 2019-07-10
358     uint256 unlock_time_0710 = 1562688000;
359     // unlock start time 2019-08-10
360     uint256 unlock_time_0810 = 1565366400;
361     // unlock start time 2019-09-10
362     uint256 unlock_time_end  = 1568044800;
363     // 1 monthss
364     uint256 time_months = 2678400;
365     // xxx
366     function getLockBalance(address account, uint8 decimals) internal view returns (uint256) {
367         uint256 tempLock = 0;
368         if (account == advance_mining) {
369             if (now < unlock_time_0910) {
370                 tempLock = 735000000 * 10 ** uint256(decimals);
371             } else if (now >= unlock_time_0910 && now < unlock_time_1210) {
372                 tempLock = 367500000 * 10 ** uint256(decimals);
373             } else if (now >= unlock_time_1210 && now < unlock_time_0310) {
374                 tempLock = 183750000 * 10 ** uint256(decimals);
375             }
376         } else if (account == community) {
377             if (now < unlock_time_0910) {
378                 tempLock = 18375000 * 6 * 10 ** uint256(decimals);
379             } else if (now >= unlock_time_0910 && now < unlock_time_1010) {
380                 tempLock = 18375000 * 5 * 10 ** uint256(decimals);
381             } else if (now >= unlock_time_1010 && now < unlock_time_1110) {
382                 tempLock = 18375000 * 4 * 10 ** uint256(decimals);
383             } else if (now >= unlock_time_1110 && now < unlock_time_1210) {
384                 tempLock = 18375000 * 3 * 10 ** uint256(decimals);
385             } else if (now >= unlock_time_1210 && now < unlock_time_0110) {
386                 tempLock = 18375000 * 2 * 10 ** uint256(decimals);
387             } else if (now >= unlock_time_0110 && now < unlock_time_0210) {
388                 tempLock = 18375000 * 1 * 10 ** uint256(decimals);
389             }
390         } else if (account == foundation_investment) {
391             if (now < unlock_time_0910) {
392                 tempLock = 18812500 * 12 * 10 ** uint256(decimals);
393             } else if (now >= unlock_time_0910 && now < unlock_time_1010) {
394                 tempLock = 18812500 * 11 * 10 ** uint256(decimals);
395             } else if (now >= unlock_time_1010 && now < unlock_time_1110) {
396                 tempLock = 18812500 * 10 * 10 ** uint256(decimals);
397             } else if (now >= unlock_time_1110 && now < unlock_time_1210) {
398                 tempLock = 18812500 * 9 * 10 ** uint256(decimals);
399             } else if (now >= unlock_time_1210 && now < unlock_time_0110) {
400                 tempLock = 18812500 * 8 * 10 ** uint256(decimals);
401             } else if (now >= unlock_time_0110 && now < unlock_time_0210) {
402                 tempLock = 18812500 * 7 * 10 ** uint256(decimals);
403             } else if (now >= unlock_time_0210 && now < unlock_time_0310) {
404                 tempLock = 18812500 * 6 * 10 ** uint256(decimals);
405             } else if (now >= unlock_time_0310 && now < unlock_time_0410) {
406                 tempLock = 18812500 * 5 * 10 ** uint256(decimals);
407             } else if (now >= unlock_time_0410 && now < unlock_time_0510) {
408                 tempLock = 18812500 * 4 * 10 ** uint256(decimals);
409             } else if (now >= unlock_time_0510 && now < unlock_time_0610) {
410                 tempLock = 18812500 * 3 * 10 ** uint256(decimals);
411             } else if (now >= unlock_time_0610 && now < unlock_time_0710) {
412                 tempLock = 18812500 * 2 * 10 ** uint256(decimals);
413             } else if (now >= unlock_time_0710 && now < unlock_time_0810) {
414                 tempLock = 18812500 * 1 * 10 ** uint256(decimals);
415             }
416         } else if (account == mining) {
417             if (now < unlock_time_0910) {
418                 tempLock = 840000000 * 10 ** uint256(decimals);
419             }
420         } else if (account == adviser) {
421             if (now < unlock_time_0910) {
422                 tempLock = 15750000 * 12 * 10 ** uint256(decimals);
423             } else if (now >= unlock_time_0910 && now < unlock_time_1010) {
424                 tempLock = 15750000 * 11 * 10 ** uint256(decimals);
425             } else if (now >= unlock_time_1010 && now < unlock_time_1110) {
426                 tempLock = 15750000 * 10 * 10 ** uint256(decimals);
427             } else if (now >= unlock_time_1110 && now < unlock_time_1210) {
428                 tempLock = 15750000 * 9 * 10 ** uint256(decimals);
429             } else if (now >= unlock_time_1210 && now < unlock_time_0110) {
430                 tempLock = 15750000 * 8 * 10 ** uint256(decimals);
431             } else if (now >= unlock_time_0110 && now < unlock_time_0210) {
432                 tempLock = 15750000 * 7 * 10 ** uint256(decimals);
433             } else if (now >= unlock_time_0210 && now < unlock_time_0310) {
434                 tempLock = 15750000 * 6 * 10 ** uint256(decimals);
435             } else if (now >= unlock_time_0310 && now < unlock_time_0410) {
436                 tempLock = 15750000 * 5 * 10 ** uint256(decimals);
437             } else if (now >= unlock_time_0410 && now < unlock_time_0510) {
438                 tempLock = 15750000 * 4 * 10 ** uint256(decimals);
439             } else if (now >= unlock_time_0510 && now < unlock_time_0610) {
440                 tempLock = 15750000 * 3 * 10 ** uint256(decimals);
441             } else if (now >= unlock_time_0610 && now < unlock_time_0710) {
442                 tempLock = 15750000 * 2 * 10 ** uint256(decimals);
443             } else if (now >= unlock_time_0710 && now < unlock_time_0810) {
444                 tempLock = 15750000 * 1 * 10 ** uint256(decimals);
445             }
446         }
447         return tempLock;
448     }
449 }
450 
451 contract PDTToken is BaseERC20, BaseSafeMath, LockUtils {
452 
453     //The solidity created time
454     
455 
456     function PDTToken() public {
457         name = "Matrix World";
458         symbol = "PDT";
459         decimals = 18;
460         totalSupply = 2100000000 * 10 ** uint256(decimals);
461         balanceOf[msg.sender] = totalSupply;
462         // balanceOf[0x5EDBe36c4c4a816f150959B445d5Ae1F33054a82] = 735000000 * 10 ** uint256(decimals);
463         // balanceOf[0xacF2e917E296547C0C476fDACf957111ca0307ce] = 110250000 * 10 ** uint256(decimals);
464         // balanceOf[0x9746079BEbcFfFf177818e23AedeC834ad0fb5f9] = 225750000 * 10 ** uint256(decimals);
465         // balanceOf[0xBB7d6f428E77f98069AE1E01964A9Ed6db3c5Fe5] = 840000000 * 10 ** uint256(decimals);
466         // balanceOf[0x0aE269Ae5F511786Fce5938c141DbF42e8A71E12] = 189000000 * 10 ** uint256(decimals);
467     }
468 
469     function _transfer(address _from, address _to, uint _value) internal {
470         // Prevent transfer to 0x0 address. Use burn() instead
471         require(_to != 0x0);
472         // Check if the sender has enough
473         // All transfer will check the available unlocked balance
474         require((balanceOf[_from] - getLockBalance(_from, decimals)) >= _value);
475         // Check balance
476         require(balanceOf[_from] >= _value);
477         // Check for overflows
478         require((balanceOf[_to] + _value) > balanceOf[_to]);
479         // Save this for an assertion in the future
480         uint previousBalances = balanceOf[_from] + balanceOf[_to];
481         // Subtract from the sender
482         balanceOf[_from] -= _value;
483         // Add the same to the recipient
484         balanceOf[_to] += _value;
485         Transfer(_from, _to, _value);
486         // Asserts are used to use static analysis to find bugs in your code. They should never fail
487         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
488     }
489     
490     function lockBalanceOf(address _owner) public returns (uint256) {
491         return getLockBalance(_owner, decimals);
492     }
493 
494     function transfer(address _to, uint256 _value) public {
495         _transfer(msg.sender, _to, _value);
496     }
497 
498     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
499         require(_value <= allowance[_from][msg.sender]);
500         // Check allowance
501         allowance[_from][msg.sender] -= _value;
502         _transfer(_from, _to, _value);
503         return true;
504     }
505 
506     function approve(address _spender, uint256 _value) public
507     returns (bool success) {
508         allowance[msg.sender][_spender] = _value;
509         return true;
510     }
511 
512     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
513     public
514     returns (bool success) {
515         tokenRecipient spender = tokenRecipient(_spender);
516         if (approve(_spender, _value)) {
517             spender.receiveApproval(msg.sender, _value, this, _extraData);
518             return true;
519         }
520     }
521 }