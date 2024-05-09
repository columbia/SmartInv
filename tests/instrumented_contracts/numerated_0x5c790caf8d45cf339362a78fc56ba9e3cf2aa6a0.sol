1 pragma solidity ^0.4.16;
2 
3 /*
4  * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
5  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
6  */
7 pragma solidity ^0.4.16;
8 
9 /*
10  * ERC-20 Standard Token Smart Contract Interface.
11  * Copyright © 2016–2017 by ABDK Consulting.
12  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
13  */
14 pragma solidity ^0.4.16;
15 
16 /**
17  * ERC-20 standard token interface, as defined
18  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
19  */
20 contract Token {
21   /**
22    * Get total number of tokens in circulation.
23    *
24    * @return total number of tokens in circulation
25    */
26   function totalSupply () constant returns (uint256 supply);
27 
28   /**
29    * Get number of tokens currently belonging to given owner.
30    *
31    * @param _owner address to get number of tokens currently belonging to the
32    *        owner of
33    * @return number of tokens currently belonging to the owner of given address
34    */
35   function balanceOf (address _owner) constant returns (uint256 balance);
36 
37   /**
38    * Transfer given number of tokens from message sender to given recipient.
39    *
40    * @param _to address to transfer tokens to the owner of
41    * @param _value number of tokens to transfer to the owner of given address
42    * @return true if tokens were transferred successfully, false otherwise
43    */
44   function transfer (address _to, uint256 _value) returns (bool success);
45 
46   /**
47    * Transfer given number of tokens from given owner to given recipient.
48    *
49    * @param _from address to transfer tokens from the owner of
50    * @param _to address to transfer tokens to the owner of
51    * @param _value number of tokens to transfer from given owner to given
52    *        recipient
53    * @return true if tokens were transferred successfully, false otherwise
54    */
55   function transferFrom (address _from, address _to, uint256 _value)
56   returns (bool success);
57 
58   /**
59    * Allow given spender to transfer given number of tokens from message sender.
60    *
61    * @param _spender address to allow the owner of to transfer tokens from
62    *        message sender
63    * @param _value number of tokens to allow to transfer
64    * @return true if token transfer was successfully approved, false otherwise
65    */
66   function approve (address _spender, uint256 _value) returns (bool success);
67 
68   /**
69    * Tell how many tokens given spender is currently allowed to transfer from
70    * given owner.
71    *
72    * @param _owner address to get number of tokens allowed to be transferred
73    *        from the owner of
74    * @param _spender address to get number of tokens allowed to be transferred
75    *        by the owner of
76    * @return number of tokens given spender is currently allowed to transfer
77    *         from given owner
78    */
79   function allowance (address _owner, address _spender) constant
80   returns (uint256 remaining);
81 
82   /**
83    * Logged when tokens were transferred from one owner to another.
84    *
85    * @param _from address of the owner, tokens were transferred from
86    * @param _to address of the owner, tokens were transferred to
87    * @param _value number of tokens transferred
88    */
89   event Transfer (address indexed _from, address indexed _to, uint256 _value);
90 
91   /**
92    * Logged when owner approved his tokens to be transferred by some spender.
93    *
94    * @param _owner owner who approved his tokens to be transferred
95    * @param _spender spender who were allowed to transfer the tokens belonging
96    *        to the owner
97    * @param _value number of tokens belonging to the owner, approved to be
98    *        transferred by the spender
99    */
100   event Approval (
101     address indexed _owner, address indexed _spender, uint256 _value);
102 }
103 
104 /*
105  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
106  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
107  */
108 pragma solidity ^0.4.16;
109 
110 /**
111  * Provides methods to safely add, subtract and multiply uint256 numbers.
112  */
113 contract SafeMath {
114   uint256 constant private MAX_UINT256 =
115     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
116 
117   /**
118    * Add two uint256 values, throw in case of overflow.
119    *
120    * @param x first value to add
121    * @param y second value to add
122    * @return x + y
123    */
124   function safeAdd (uint256 x, uint256 y)
125   constant internal
126   returns (uint256 z) {
127     assert (x <= MAX_UINT256 - y);
128     return x + y;
129   }
130 
131   /**
132    * Subtract one uint256 value from another, throw in case of underflow.
133    *
134    * @param x value to subtract from
135    * @param y value to subtract
136    * @return x - y
137    */
138   function safeSub (uint256 x, uint256 y)
139   constant internal
140   returns (uint256 z) {
141     assert (x >= y);
142     return x - y;
143   }
144 
145   /**
146    * Multiply two uint256 values, throw in case of overflow.
147    *
148    * @param x first value to multiply
149    * @param y second value to multiply
150    * @return x * y
151    */
152   function safeMul (uint256 x, uint256 y)
153   constant internal
154   returns (uint256 z) {
155     if (y == 0) return 0; // Prevent division by zero at the next line
156     assert (x <= MAX_UINT256 / y);
157     return x * y;
158   }
159 }
160 
161 
162 /**
163  * Abstract Token Smart Contract that could be used as a base contract for
164  * ERC-20 token contracts.
165  */
166 contract AbstractToken is Token, SafeMath {
167   /**
168    * Create new Abstract Token contract.
169    */
170   function AbstractToken () {
171     // Do nothing
172   }
173 
174   /**
175    * Get number of tokens currently belonging to given owner.
176    *
177    * @param _owner address to get number of tokens currently belonging to the
178    *        owner of
179    * @return number of tokens currently belonging to the owner of given address
180    */
181   function balanceOf (address _owner) constant returns (uint256 balance) {
182     return accounts [_owner];
183   }
184 
185   /**
186    * Transfer given number of tokens from message sender to given recipient.
187    *
188    * @param _to address to transfer tokens to the owner of
189    * @param _value number of tokens to transfer to the owner of given address
190    * @return true if tokens were transferred successfully, false otherwise
191    */
192   function transfer (address _to, uint256 _value) returns (bool success) {
193     if (accounts [msg.sender] < _value) return false;
194     if (_value > 0 && msg.sender != _to) {
195       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
196       accounts [_to] = safeAdd (accounts [_to], _value);
197     }
198     Transfer (msg.sender, _to, _value);
199     return true;
200   }
201 
202   /**
203    * Transfer given number of tokens from given owner to given recipient.
204    *
205    * @param _from address to transfer tokens from the owner of
206    * @param _to address to transfer tokens to the owner of
207    * @param _value number of tokens to transfer from given owner to given
208    *        recipient
209    * @return true if tokens were transferred successfully, false otherwise
210    */
211   function transferFrom (address _from, address _to, uint256 _value)
212   returns (bool success) {
213     if (allowances [_from][msg.sender] < _value) return false;
214     if (accounts [_from] < _value) return false;
215 
216     allowances [_from][msg.sender] =
217       safeSub (allowances [_from][msg.sender], _value);
218 
219     if (_value > 0 && _from != _to) {
220       accounts [_from] = safeSub (accounts [_from], _value);
221       accounts [_to] = safeAdd (accounts [_to], _value);
222     }
223     Transfer (_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * Allow given spender to transfer given number of tokens from message sender.
229    *
230    * @param _spender address to allow the owner of to transfer tokens from
231    *        message sender
232    * @param _value number of tokens to allow to transfer
233    * @return true if token transfer was successfully approved, false otherwise
234    */
235   function approve (address _spender, uint256 _value) returns (bool success) {
236     allowances [msg.sender][_spender] = _value;
237     Approval (msg.sender, _spender, _value);
238 
239     return true;
240   }
241 
242   /**
243    * Tell how many tokens given spender is currently allowed to transfer from
244    * given owner.
245    *
246    * @param _owner address to get number of tokens allowed to be transferred
247    *        from the owner of
248    * @param _spender address to get number of tokens allowed to be transferred
249    *        by the owner of
250    * @return number of tokens given spender is currently allowed to transfer
251    *         from given owner
252    */
253   function allowance (address _owner, address _spender) constant
254   returns (uint256 remaining) {
255     return allowances [_owner][_spender];
256   }
257 
258   /**
259    * Mapping from addresses of token holders to the numbers of tokens belonging
260    * to these token holders.
261    */
262   mapping (address => uint256) accounts;
263 
264   /**
265    * Mapping from addresses of token holders to the mapping of addresses of
266    * spenders to the allowances set by these token holders to these spenders.
267    */
268   mapping (address => mapping (address => uint256)) private allowances;
269 }
270 
271 
272 /**
273  * Genie token smart contract.
274  */
275 contract CGCoinToken is AbstractToken {
276   /**
277    * Maximum allowed number of tokens in circulation.
278    */
279   uint256 constant MAX_TOKEN_COUNT =
280     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
281 
282   /**
283    * Address of the owner of this smart contract.
284    */
285   address private owner;
286 
287   /**
288    * Current number of tokens in circulation.
289    */
290   uint256 tokenCount = 0;
291 
292   /**
293    * True if tokens transfers are currently frozen, false otherwise.
294    */
295   bool frozen = false;
296 
297   /**
298    * Create new Genie token smart contract and make msg.sender the
299    * owner of this smart contract.
300    */
301   function CGCoinToken () {
302     owner = msg.sender;
303   }
304 
305   /**
306    * Get total number of tokens in circulation.
307    *
308    * @return total number of tokens in circulation
309    */
310   function totalSupply () constant returns (uint256 supply) {
311     return tokenCount;
312   }
313 
314   /**
315    * Get name of this token.
316    *
317    * @return name of this token
318    */
319   function name () constant returns (string result) {
320     return "CGCOIN";
321   }
322 
323   /**
324    * Get symbol of this token.
325    *
326    * @return symbol of this token
327    */
328   function symbol () constant returns (string result) {
329     return "CGC";
330   }
331 
332   /**
333    * Get number of decimals for this token.
334    *
335    * @return number of decimals for this token
336    */
337   function decimals () constant returns (uint8 result) {
338     return 0;
339   }
340 
341   /**
342    * Transfer given number of tokens from message sender to given recipient.
343    *
344    * @param _to address to transfer tokens to the owner of
345    * @param _value number of tokens to transfer to the owner of given address
346    * @return true if tokens were transferred successfully, false otherwise
347    */
348   function transfer (address _to, uint256 _value) returns (bool success) {
349     if (frozen) return false;
350     else return AbstractToken.transfer (_to, _value);
351   }
352 
353   /**
354    * Transfer given number of tokens from given owner to given recipient.
355    *
356    * @param _from address to transfer tokens from the owner of
357    * @param _to address to transfer tokens to the owner of
358    * @param _value number of tokens to transfer from given owner to given
359    *        recipient
360    * @return true if tokens were transferred successfully, false otherwise
361    */
362   function transferFrom (address _from, address _to, uint256 _value)
363     returns (bool success) {
364     if (frozen) return false;
365     else return AbstractToken.transferFrom (_from, _to, _value);
366   }
367 
368   /**
369    * Change how many tokens given spender is allowed to transfer from message
370    * spender.  In order to prevent double spending of allowance, this method
371    * receives assumed current allowance value as an argument.  If actual
372    * allowance differs from an assumed one, this method just returns false.
373    *
374    * @param _spender address to allow the owner of to transfer tokens from
375    *        message sender
376    * @param _currentValue assumed number of tokens currently allowed to be
377    *        transferred
378    * @param _newValue number of tokens to allow to transfer
379    * @return true if token transfer was successfully approved, false otherwise
380    */
381   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
382     returns (bool success) {
383     if (allowance (msg.sender, _spender) == _currentValue)
384       return approve (_spender, _newValue);
385     else return false;
386   }
387 
388   /**
389    * Burn given number of tokens belonging to message sender.
390    *
391    * @param _value number of tokens to burn
392    * @return true on success, false on error
393    */
394   function burnTokens (uint256 _value) returns (bool success) {
395     if (_value > accounts [msg.sender]) return false;
396     else if (_value > 0) {
397       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
398       tokenCount = safeSub (tokenCount, _value);
399       return true;
400     } else return true;
401   }
402 
403   /**
404    * Create _value new tokens and give new created tokens to msg.sender.
405    * May only be called by smart contract owner.
406    *
407    * @param _value number of tokens to create
408    * @return true if tokens were created successfully, false otherwise
409    */
410   function createTokens (uint256 _value)
411     returns (bool success) {
412     require (msg.sender == owner);
413 
414     if (_value > 0) {
415       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
416       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
417       tokenCount = safeAdd (tokenCount, _value);
418     }
419 
420     return true;
421   }
422 
423   /**
424    * Set new owner for the smart contract.
425    * May only be called by smart contract owner.
426    *
427    * @param _newOwner address of new owner of the smart contract
428    */
429   function setOwner (address _newOwner) {
430     require (msg.sender == owner);
431 
432     owner = _newOwner;
433   }
434 
435   /**
436    * Freeze token transfers.
437    * May only be called by smart contract owner.
438    */
439   function freezeTransfers () {
440     require (msg.sender == owner);
441 
442     if (!frozen) {
443       frozen = true;
444       Freeze ();
445     }
446   }
447 
448   /**
449    * Unfreeze token transfers.
450    * May only be called by smart contract owner.
451    */
452   function unfreezeTransfers () {
453     require (msg.sender == owner);
454 
455     if (frozen) {
456       frozen = false;
457       Unfreeze ();
458     }
459   }
460 
461   /**
462    * Logged when token transfers were frozen.
463    */
464   event Freeze ();
465 
466   /**
467    * Logged when token transfers were unfrozen.
468    */
469   event Unfreeze ();
470 }