1 /*
2  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
3  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
4  */
5 pragma solidity ^0.4.16;
6 
7 /**
8  * Provides methods to safely add, subtract and multiply uint256 numbers.
9  */
10 contract SafeMath {
11   uint256 constant private MAX_UINT256 =
12     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
13 
14   /**
15    * Add two uint256 values, throw in case of overflow.
16    *
17    * @param x first value to add
18    * @param y second value to add
19    * @return x + y
20    */
21   function safeAdd (uint256 x, uint256 y)
22   constant internal
23   returns (uint256 z) {
24     assert (x <= MAX_UINT256 - y);
25     return x + y;
26   }
27 
28   /**
29    * Subtract one uint256 value from another, throw in case of underflow.
30    *
31    * @param x value to subtract from
32    * @param y value to subtract
33    * @return x - y
34    */
35   function safeSub (uint256 x, uint256 y)
36   constant internal
37   returns (uint256 z) {
38     assert (x >= y);
39     return x - y;
40   }
41 
42   /**
43    * Multiply two uint256 values, throw in case of overflow.
44    *
45    * @param x first value to multiply
46    * @param y second value to multiply
47    * @return x * y
48    */
49   function safeMul (uint256 x, uint256 y)
50   constant internal
51   returns (uint256 z) {
52     if (y == 0) return 0; // Prevent division by zero at the next line
53     assert (x <= MAX_UINT256 / y);
54     return x * y;
55   }
56 }
57 
58 /*
59  * ERC-20 Standard Token Smart Contract Interface.
60  * Copyright © 2016–2017 by ABDK Consulting.
61  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
62  */
63 
64 /**
65  * ERC-20 standard token interface, as defined
66  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
67  */
68 contract Token {
69   /**
70    * Get total number of tokens in circulation.
71    *
72    * @return total number of tokens in circulation
73    */
74   function totalSupply () constant returns (uint256 supply);
75 
76   /**
77    * Get number of tokens currently belonging to given owner.
78    *
79    * @param _owner address to get number of tokens currently belonging to the
80    *        owner of
81    * @return number of tokens currently belonging to the owner of given address
82    */
83   function balanceOf (address _owner) constant returns (uint256 balance);
84 
85   /**
86    * Transfer given number of tokens from message sender to given recipient.
87    *
88    * @param _to address to transfer tokens to the owner of
89    * @param _value number of tokens to transfer to the owner of given address
90    * @return true if tokens were transferred successfully, false otherwise
91    */
92   function transfer (address _to, uint256 _value) returns (bool success);
93 
94   /**
95    * Transfer given number of tokens from given owner to given recipient.
96    *
97    * @param _from address to transfer tokens from the owner of
98    * @param _to address to transfer tokens to the owner of
99    * @param _value number of tokens to transfer from given owner to given
100    *        recipient
101    * @return true if tokens were transferred successfully, false otherwise
102    */
103   function transferFrom (address _from, address _to, uint256 _value)
104   returns (bool success);
105 
106   /**
107    * Allow given spender to transfer given number of tokens from message sender.
108    *
109    * @param _spender address to allow the owner of to transfer tokens from
110    *        message sender
111    * @param _value number of tokens to allow to transfer
112    * @return true if token transfer was successfully approved, false otherwise
113    */
114   function approve (address _spender, uint256 _value) returns (bool success);
115 
116   /**
117    * Tell how many tokens given spender is currently allowed to transfer from
118    * given owner.
119    *
120    * @param _owner address to get number of tokens allowed to be transferred
121    *        from the owner of
122    * @param _spender address to get number of tokens allowed to be transferred
123    *        by the owner of
124    * @return number of tokens given spender is currently allowed to transfer
125    *         from given owner
126    */
127   function allowance (address _owner, address _spender) constant
128   returns (uint256 remaining);
129 
130   /**
131    * Logged when tokens were transferred from one owner to another.
132    *
133    * @param _from address of the owner, tokens were transferred from
134    * @param _to address of the owner, tokens were transferred to
135    * @param _value number of tokens transferred
136    */
137   event Transfer (address indexed _from, address indexed _to, uint256 _value);
138 
139   /**
140    * Logged when owner approved his tokens to be transferred by some spender.
141    *
142    * @param _owner owner who approved his tokens to be transferred
143    * @param _spender spender who were allowed to transfer the tokens belonging
144    *        to the owner
145    * @param _value number of tokens belonging to the owner, approved to be
146    *        transferred by the spender
147    */
148   event Approval (
149     address indexed _owner, address indexed _spender, uint256 _value);
150 }
151 
152 /*
153  * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
154  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
155  */
156 /**
157  * Abstract Token Smart Contract that could be used as a base contract for
158  * ERC-20 token contracts.
159  */
160 contract AbstractToken is Token, SafeMath {
161   /**
162    * Create new Abstract Token contract.
163    */
164   function AbstractToken () {
165     // Do nothing
166   }
167 
168   /**
169    * Get number of tokens currently belonging to given owner.
170    *
171    * @param _owner address to get number of tokens currently belonging to the
172    *        owner of
173    * @return number of tokens currently belonging to the owner of given address
174    */
175   function balanceOf (address _owner) constant returns (uint256 balance) {
176     return accounts [_owner];
177   }
178 
179   /**
180    * Transfer given number of tokens from message sender to given recipient.
181    *
182    * @param _to address to transfer tokens to the owner of
183    * @param _value number of tokens to transfer to the owner of given address
184    * @return true if tokens were transferred successfully, false otherwise
185    */
186   function transfer (address _to, uint256 _value) returns (bool success) {
187     uint256 fromBalance = accounts [msg.sender];
188     if (fromBalance < _value) return false;
189     if (_value > 0 && msg.sender != _to) {
190       accounts [msg.sender] = safeSub (fromBalance, _value);
191       accounts [_to] = safeAdd (accounts [_to], _value);
192       Transfer (msg.sender, _to, _value);
193     }
194     return true;
195   }
196 
197   /**
198    * Transfer given number of tokens from given owner to given recipient.
199    *
200    * @param _from address to transfer tokens from the owner of
201    * @param _to address to transfer tokens to the owner of
202    * @param _value number of tokens to transfer from given owner to given
203    *        recipient
204    * @return true if tokens were transferred successfully, false otherwise
205    */
206   function transferFrom (address _from, address _to, uint256 _value)
207   returns (bool success) {
208     uint256 spenderAllowance = allowances [_from][msg.sender];
209     if (spenderAllowance < _value) return false;
210     uint256 fromBalance = accounts [_from];
211     if (fromBalance < _value) return false;
212 
213     allowances [_from][msg.sender] =
214       safeSub (spenderAllowance, _value);
215 
216     if (_value > 0 && _from != _to) {
217       accounts [_from] = safeSub (fromBalance, _value);
218       accounts [_to] = safeAdd (accounts [_to], _value);
219       Transfer (_from, _to, _value);
220     }
221     return true;
222   }
223 
224   /**
225    * Allow given spender to transfer given number of tokens from message sender.
226    *
227    * @param _spender address to allow the owner of to transfer tokens from
228    *        message sender
229    * @param _value number of tokens to allow to transfer
230    * @return true if token transfer was successfully approved, false otherwise
231    */
232   function approve (address _spender, uint256 _value) returns (bool success) {
233     allowances [msg.sender][_spender] = _value;
234     Approval (msg.sender, _spender, _value);
235 
236     return true;
237   }
238 
239   /**
240    * Tell how many tokens given spender is currently allowed to transfer from
241    * given owner.
242    *
243    * @param _owner address to get number of tokens allowed to be transferred
244    *        from the owner of
245    * @param _spender address to get number of tokens allowed to be transferred
246    *        by the owner of
247    * @return number of tokens given spender is currently allowed to transfer
248    *         from given owner
249    */
250   function allowance (address _owner, address _spender) constant
251   returns (uint256 remaining) {
252     return allowances [_owner][_spender];
253   }
254 
255   /**
256    * Mapping from addresses of token holders to the numbers of tokens belonging
257    * to these token holders.
258    */
259   mapping (address => uint256) accounts;
260 
261   /**
262    * Mapping from addresses of token holders to the mapping of addresses of
263    * spenders to the allowances set by these token holders to these spenders.
264    */
265   mapping (address => mapping (address => uint256)) private allowances;
266 }
267 
268 
269 /*
270  * Abstract Virtual Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
271  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
272  */
273 
274 /**
275  * Abstract Token Smart Contract that could be used as a base contract for
276  * ERC-20 token contracts supporting virtual balance.
277  */
278 contract AbstractVirtualToken is AbstractToken {
279   /**
280    * Maximum number of real (i.e. non-virtual) tokens in circulation (2^255-1).
281    */
282   uint256 constant MAXIMUM_TOKENS_COUNT =
283     0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
284 
285   /**
286    * Mask used to extract real balance of an account (2^255-1).
287    */
288   uint256 constant BALANCE_MASK =
289     0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
290 
291   /**
292    * Mask used to extract "materialized" flag of an account (2^255).
293    */
294   uint256 constant MATERIALIZED_FLAG_MASK =
295     0x8000000000000000000000000000000000000000000000000000000000000000;
296 
297   /**
298    * Create new Abstract Virtual Token contract.
299    */
300   function AbstractVirtualToken () AbstractToken () {
301     // Do nothing
302   }
303 
304   /**
305    * Get total number of tokens in circulation.
306    *
307    * @return total number of tokens in circulation
308    */
309   function totalSupply () constant returns (uint256 supply) {
310     return tokensCount;
311   }
312 
313   /**
314    * Get number of tokens currently belonging to given owner.
315    *
316    * @param _owner address to get number of tokens currently belonging to the
317    *        owner of
318    * @return number of tokens currently belonging to the owner of given address
319    */
320   function balanceOf (address _owner) constant returns (uint256 balance) {
321     return safeAdd (
322       accounts [_owner] & BALANCE_MASK, getVirtualBalance (_owner));
323   }
324 
325   /**
326    * Transfer given number of tokens from message sender to given recipient.
327    *
328    * @param _to address to transfer tokens to the owner of
329    * @param _value number of tokens to transfer to the owner of given address
330    * @return true if tokens were transferred successfully, false otherwise
331    */
332   function transfer (address _to, uint256 _value) returns (bool success) {
333     if (_value > balanceOf (msg.sender)) return false;
334     else {
335       materializeBalanceIfNeeded (msg.sender, _value);
336       return AbstractToken.transfer (_to, _value);
337     }
338   }
339 
340   /**
341    * Transfer given number of tokens from given owner to given recipient.
342    *
343    * @param _from address to transfer tokens from the owner of
344    * @param _to address to transfer tokens to the owner of
345    * @param _value number of tokens to transfer from given owner to given
346    *        recipient
347    * @return true if tokens were transferred successfully, false otherwise
348    */
349   function transferFrom (address _from, address _to, uint256 _value)
350   returns (bool success) {
351     if (_value > allowance (_from, msg.sender)) return false;
352     if (_value > balanceOf (_from)) return false;
353     else {
354       materializeBalanceIfNeeded (_from, _value);
355       return AbstractToken.transferFrom (_from, _to, _value);
356     }
357   }
358 
359   /**
360    * Get virtual balance of the owner of given address.
361    *
362    * @param _owner address to get virtual balance for the owner of
363    * @return virtual balance of the owner of given address
364    */
365   function virtualBalanceOf (address _owner)
366   internal constant returns (uint256 _virtualBalance);
367 
368   /**
369    * Calculate virtual balance of the owner of given address taking into account
370    * materialized flag and total number of real tokens already in circulation.
371    */
372   function getVirtualBalance (address _owner)
373   private constant returns (uint256 _virtualBalance) {
374     if (accounts [_owner] & MATERIALIZED_FLAG_MASK != 0) return 0;
375     else {
376       _virtualBalance = virtualBalanceOf (_owner);
377       uint256 maxVirtualBalance = safeSub (MAXIMUM_TOKENS_COUNT, tokensCount);
378       if (_virtualBalance > maxVirtualBalance)
379         _virtualBalance = maxVirtualBalance;
380     }
381   }
382 
383   /**
384    * Materialize virtual balance of the owner of given address if this will help
385    * to transfer given number of tokens from it.
386    *
387    * @param _owner address to materialize virtual balance of
388    * @param _value number of tokens to be transferred
389    */
390   function materializeBalanceIfNeeded (address _owner, uint256 _value) private {
391     uint256 storedBalance = accounts [_owner];
392     if (storedBalance & MATERIALIZED_FLAG_MASK == 0) {
393       // Virtual balance is not materialized yet
394       if (_value > storedBalance) {
395         // Real balance is not enough
396         uint256 virtualBalance = getVirtualBalance (_owner);
397         require (safeSub (_value, storedBalance) <= virtualBalance);
398         accounts [_owner] = MATERIALIZED_FLAG_MASK |
399           safeAdd (storedBalance, virtualBalance);
400         tokensCount = safeAdd (tokensCount, virtualBalance);
401       }
402     }
403   }
404 
405   /**
406    * Number of real (i.e. non-virtual) tokens in circulation.
407    */
408   uint256 tokensCount;
409 }
410 
411 /*
412  * INS Promo Token Smart Contract.  Copyright © 2016-2017 by ABDK Consulting.
413  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
414  */
415 
416 /**
417  * EIP-20 token smart contract that manages INS promo tokens.
418  */
419 contract INSPromoToken is AbstractVirtualToken {
420   /**
421    * Balance threshold to assign virtual tokens to the owner of higher balances
422    * then this threshold.
423    */
424   uint256 private constant VIRTUAL_THRESHOLD = 0.1 ether;
425   
426   /**
427    * Number of virtual tokens to assign to the owners of balances higher than
428    * virtual threshold.
429    */
430   uint256 private constant VIRTUAL_COUNT = 777;
431   
432   /**
433    * Create new INS Promo Token smart contract and make message sender to be
434    * the owner of smart contract.
435    */
436   function INSPromoToken () AbstractVirtualToken () {
437     owner = msg.sender;
438   }
439 
440   /**
441    * Get name of this token.
442    *
443    * @return name of this token
444    */
445   function name () constant returns (string result) {
446     return "INS Promo";
447   }
448 
449   /**
450    * Get symbol of this token.
451    *
452    * @return symbol of this token
453    */
454   function symbol () constant returns (string result) {
455     return "INSP";
456   }
457 
458   /**
459    * Get number of decimals for this token.
460    *
461    * @return number of decimals for this token
462    */
463   function decimals () constant returns (uint8 result) {
464     return 0;
465   }
466 
467   /**
468    * Notify owners about their virtual balances.
469    *
470    * @param _owners addresses of the owners to be notified
471    */
472   function massNotify (address [] _owners) {
473     require (msg.sender == owner);
474     uint256 count = _owners.length;
475     for (uint256 i = 0; i < count; i++)
476       Transfer (address (0), _owners [i], VIRTUAL_COUNT);
477   }
478 
479   /**
480    * Kill this smart contract.
481    */
482   function kill () {
483     require (msg.sender == owner);
484     selfdestruct (owner);
485   }
486 
487   /**
488    * Get virtual balance of the owner of given address.
489    *
490    * @param _owner address to get virtual balance for the owner of
491    * @return virtual balance of the owner of given address
492    */
493   function virtualBalanceOf (address _owner)
494   internal constant returns (uint256 _virtualBalance) {
495     return _owner.balance >= VIRTUAL_THRESHOLD ? VIRTUAL_COUNT : 0;
496   }
497 
498   /**
499    * Address of the owner of this smart contract.
500    */
501   address private owner;
502 }