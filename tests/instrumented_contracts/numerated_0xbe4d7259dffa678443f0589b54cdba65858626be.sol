1 /*
2  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
3  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
4  */
5 pragma solidity ^0.4.20;
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
22   pure internal
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
36   pure internal
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
50   pure internal
51   returns (uint256 z) {
52     if (y == 0) return 0; // Prevent division by zero at the next line
53     assert (x <= MAX_UINT256 / y);
54     return x * y;
55   }
56 }
57 /*
58  * EIP-20 Standard Token Smart Contract Interface.
59  * Copyright © 2016–2018 by ABDK Consulting.
60  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
61  */
62 
63 /**
64  * ERC-20 standard token interface, as defined
65  * <a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md">here</a>.
66  */
67 contract Token {
68   /**
69    * Get total number of tokens in circulation.
70    *
71    * @return total number of tokens in circulation
72    */
73   function totalSupply () public view returns (uint256 supply);
74 
75   /**
76    * Get number of tokens currently belonging to given owner.
77    *
78    * @param _owner address to get number of tokens currently belonging to the
79    *        owner of
80    * @return number of tokens currently belonging to the owner of given address
81    */
82   function balanceOf (address _owner) public view returns (uint256 balance);
83 
84   /**
85    * Transfer given number of tokens from message sender to given recipient.
86    *
87    * @param _to address to transfer tokens to the owner of
88    * @param _value number of tokens to transfer to the owner of given address
89    * @return true if tokens were transferred successfully, false otherwise
90    */
91   function transfer (address _to, uint256 _value)
92   public returns (bool success);
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
104   public returns (bool success);
105 
106   /**
107    * Allow given spender to transfer given number of tokens from message sender.
108    *
109    * @param _spender address to allow the owner of to transfer tokens from
110    *        message sender
111    * @param _value number of tokens to allow to transfer
112    * @return true if token transfer was successfully approved, false otherwise
113    */
114   function approve (address _spender, uint256 _value)
115   public returns (bool success);
116 
117   /**
118    * Tell how many tokens given spender is currently allowed to transfer from
119    * given owner.
120    *
121    * @param _owner address to get number of tokens allowed to be transferred
122    *        from the owner of
123    * @param _spender address to get number of tokens allowed to be transferred
124    *        by the owner of
125    * @return number of tokens given spender is currently allowed to transfer
126    *         from given owner
127    */
128   function allowance (address _owner, address _spender)
129   public view returns (uint256 remaining);
130 
131   /**
132    * Logged when tokens were transferred from one owner to another.
133    *
134    * @param _from address of the owner, tokens were transferred from
135    * @param _to address of the owner, tokens were transferred to
136    * @param _value number of tokens transferred
137    */
138   event Transfer (address indexed _from, address indexed _to, uint256 _value);
139 
140   /**
141    * Logged when owner approved his tokens to be transferred by some spender.
142    *
143    * @param _owner owner who approved his tokens to be transferred
144    * @param _spender spender who were allowed to transfer the tokens belonging
145    *        to the owner
146    * @param _value number of tokens belonging to the owner, approved to be
147    *        transferred by the spender
148    */
149   event Approval (
150     address indexed _owner, address indexed _spender, uint256 _value);
151 }/*
152  * Address Set Smart Contract Interface.
153  * Copyright © 2017–2018 by ABDK Consulting.
154  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
155  */
156 
157 /**
158  * Address Set smart contract interface.
159  */
160 contract AddressSet {
161   /**
162    * Check whether address set contains given address.
163    *
164    * @param _address address to check
165    * @return true if address set contains given address, false otherwise
166    */
167   function contains (address _address) public view returns (bool);
168 }
169 /*
170  * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
171  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
172  */
173 
174 /**
175  * Abstract Token Smart Contract that could be used as a base contract for
176  * ERC-20 token contracts.
177  */
178 contract AbstractToken is Token, SafeMath {
179   /**
180    * Create new Abstract Token contract.
181    */
182   function AbstractToken () public {
183     // Do nothing
184   }
185 
186   /**
187    * Get number of tokens currently belonging to given owner.
188    *
189    * @param _owner address to get number of tokens currently belonging to the
190    *        owner of
191    * @return number of tokens currently belonging to the owner of given address
192    */
193   function balanceOf (address _owner) public view returns (uint256 balance) {
194     return accounts [_owner];
195   }
196 
197   /**
198    * Transfer given number of tokens from message sender to given recipient.
199    *
200    * @param _to address to transfer tokens to the owner of
201    * @param _value number of tokens to transfer to the owner of given address
202    * @return true if tokens were transferred successfully, false otherwise
203    */
204   function transfer (address _to, uint256 _value)
205   public returns (bool success) {
206     uint256 fromBalance = accounts [msg.sender];
207     if (fromBalance < _value) return false;
208     if (_value > 0 && msg.sender != _to) {
209       accounts [msg.sender] = safeSub (fromBalance, _value);
210       accounts [_to] = safeAdd (accounts [_to], _value);
211     }
212     Transfer (msg.sender, _to, _value);
213     return true;
214   }
215 
216   /**
217    * Transfer given number of tokens from given owner to given recipient.
218    *
219    * @param _from address to transfer tokens from the owner of
220    * @param _to address to transfer tokens to the owner of
221    * @param _value number of tokens to transfer from given owner to given
222    *        recipient
223    * @return true if tokens were transferred successfully, false otherwise
224    */
225   function transferFrom (address _from, address _to, uint256 _value)
226   public returns (bool success) {
227     uint256 spenderAllowance = allowances [_from][msg.sender];
228     if (spenderAllowance < _value) return false;
229     uint256 fromBalance = accounts [_from];
230     if (fromBalance < _value) return false;
231 
232     allowances [_from][msg.sender] =
233       safeSub (spenderAllowance, _value);
234 
235     if (_value > 0 && _from != _to) {
236       accounts [_from] = safeSub (fromBalance, _value);
237       accounts [_to] = safeAdd (accounts [_to], _value);
238     }
239     Transfer (_from, _to, _value);
240     return true;
241   }
242 
243   /**
244    * Allow given spender to transfer given number of tokens from message sender.
245    *
246    * @param _spender address to allow the owner of to transfer tokens from
247    *        message sender
248    * @param _value number of tokens to allow to transfer
249    * @return true if token transfer was successfully approved, false otherwise
250    */
251   function approve (address _spender, uint256 _value)
252   public returns (bool success) {
253     allowances [msg.sender][_spender] = _value;
254     Approval (msg.sender, _spender, _value);
255 
256     return true;
257   }
258 
259   /**
260    * Tell how many tokens given spender is currently allowed to transfer from
261    * given owner.
262    *
263    * @param _owner address to get number of tokens allowed to be transferred
264    *        from the owner of
265    * @param _spender address to get number of tokens allowed to be transferred
266    *        by the owner of
267    * @return number of tokens given spender is currently allowed to transfer
268    *         from given owner
269    */
270   function allowance (address _owner, address _spender)
271   public view returns (uint256 remaining) {
272     return allowances [_owner][_spender];
273   }
274 
275   /**
276    * Mapping from addresses of token holders to the numbers of tokens belonging
277    * to these token holders.
278    */
279   mapping (address => uint256) internal accounts;
280 
281   /**
282    * Mapping from addresses of token holders to the mapping of addresses of
283    * spenders to the allowances set by these token holders to these spenders.
284    */
285   mapping (address => mapping (address => uint256)) internal allowances;
286 }
287 /*
288  * Abstract Virtual Token Smart Contract.
289  * Copyright © 2017–2018 by ABDK Consulting.
290  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
291  */
292 
293 
294 /**
295  * Abstract Token Smart Contract that could be used as a base contract for
296  * ERC-20 token contracts supporting virtual balance.
297  */
298 contract AbstractVirtualToken is AbstractToken {
299   /**
300    * Maximum number of real (i.e. non-virtual) tokens in circulation (2^255-1).
301    */
302   uint256 constant MAXIMUM_TOKENS_COUNT =
303     0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
304 
305   /**
306    * Mask used to extract real balance of an account (2^255-1).
307    */
308   uint256 constant BALANCE_MASK =
309     0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
310 
311   /**
312    * Mask used to extract "materialized" flag of an account (2^255).
313    */
314   uint256 constant MATERIALIZED_FLAG_MASK =
315     0x8000000000000000000000000000000000000000000000000000000000000000;
316 
317   /**
318    * Create new Abstract Virtual Token contract.
319    */
320   function AbstractVirtualToken () public AbstractToken () {
321     // Do nothing
322   }
323 
324   /**
325    * Get total number of tokens in circulation.
326    *
327    * @return total number of tokens in circulation
328    */
329   function totalSupply () public view returns (uint256 supply) {
330     return tokensCount;
331   }
332 
333   /**
334    * Get number of tokens currently belonging to given owner.
335    *
336    * @param _owner address to get number of tokens currently belonging to the
337    *        owner of
338    * @return number of tokens currently belonging to the owner of given address
339    */
340   function balanceOf (address _owner) public view returns (uint256 balance) {
341     return safeAdd (
342       accounts [_owner] & BALANCE_MASK, getVirtualBalance (_owner));
343   }
344 
345   /**
346    * Transfer given number of tokens from message sender to given recipient.
347    *
348    * @param _to address to transfer tokens to the owner of
349    * @param _value number of tokens to transfer to the owner of given address
350    * @return true if tokens were transferred successfully, false otherwise
351    */
352   function transfer (address _to, uint256 _value)
353   public returns (bool success) {
354     if (_value > balanceOf (msg.sender)) return false;
355     else {
356       materializeBalanceIfNeeded (msg.sender, _value);
357       return AbstractToken.transfer (_to, _value);
358     }
359   }
360 
361   /**
362    * Transfer given number of tokens from given owner to given recipient.
363    *
364    * @param _from address to transfer tokens from the owner of
365    * @param _to address to transfer tokens to the owner of
366    * @param _value number of tokens to transfer from given owner to given
367    *        recipient
368    * @return true if tokens were transferred successfully, false otherwise
369    */
370   function transferFrom (address _from, address _to, uint256 _value)
371   public returns (bool success) {
372     if (_value > allowance (_from, msg.sender)) return false;
373     if (_value > balanceOf (_from)) return false;
374     else {
375       materializeBalanceIfNeeded (_from, _value);
376       return AbstractToken.transferFrom (_from, _to, _value);
377     }
378   }
379 
380   /**
381    * Get virtual balance of the owner of given address.
382    *
383    * @param _owner address to get virtual balance for the owner of
384    * @return virtual balance of the owner of given address
385    */
386   function virtualBalanceOf (address _owner)
387   internal view returns (uint256 _virtualBalance);
388 
389   /**
390    * Calculate virtual balance of the owner of given address taking into account
391    * materialized flag and total number of real tokens already in circulation.
392    */
393   function getVirtualBalance (address _owner)
394   private view returns (uint256 _virtualBalance) {
395     if (accounts [_owner] & MATERIALIZED_FLAG_MASK != 0) return 0;
396     else {
397       _virtualBalance = virtualBalanceOf (_owner);
398       uint256 maxVirtualBalance = safeSub (MAXIMUM_TOKENS_COUNT, tokensCount);
399       if (_virtualBalance > maxVirtualBalance)
400         _virtualBalance = maxVirtualBalance;
401     }
402   }
403 
404   /**
405    * Materialize virtual balance of the owner of given address if this will help
406    * to transfer given number of tokens from it.
407    *
408    * @param _owner address to materialize virtual balance of
409    * @param _value number of tokens to be transferred
410    */
411   function materializeBalanceIfNeeded (address _owner, uint256 _value) private {
412     uint256 storedBalance = accounts [_owner];
413     if (storedBalance & MATERIALIZED_FLAG_MASK == 0) {
414       // Virtual balance is not materialized yet
415       if (_value > storedBalance) {
416         // Real balance is not enough
417         uint256 virtualBalance = getVirtualBalance (_owner);
418         require (safeSub (_value, storedBalance) <= virtualBalance);
419         accounts [_owner] = MATERIALIZED_FLAG_MASK |
420           safeAdd (storedBalance, virtualBalance);
421         tokensCount = safeAdd (tokensCount, virtualBalance);
422       }
423     }
424   }
425 
426   /**
427    * Number of real (i.e. non-virtual) tokens in circulation.
428    */
429   uint256 internal tokensCount;
430 }
431 /*
432  * MediChain Promo Token Smart Contract.  Copyright © 2018 by ABDK Consulting.
433  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
434  */
435 
436 /**
437  * MediChain Promo Token Smart Contract.
438  */
439 contract MediChainBonus30PToken is AbstractVirtualToken {
440   /**
441    * Number of virtual tokens to assign to the owners of addresses from given
442    * address set.
443    */
444   uint256 private constant VIRTUAL_COUNT = 10e8;
445   
446    /**
447    * Number of real tokens to assign to the contract owner.
448    */
449   uint256 private constant INITIAL_SUPPLY=3000000e8;
450 
451   /**
452    * Create MediChainBonusToken smart contract with given address set.
453    *
454    * @param _addressSet address set to use
455    */
456   function MediChainBonus30PToken (AddressSet _addressSet)
457   public AbstractVirtualToken () {
458     owner = msg.sender;
459 	accounts[owner] = INITIAL_SUPPLY;
460     addressSet = _addressSet;
461     tokensCount = INITIAL_SUPPLY;
462   }
463 
464   /**
465    * Get name of this token.
466    *
467    * @return name of this token
468    */
469   function name () public pure returns (string) {
470     return "MediChain Bonus30Percent Token";
471   }
472 
473   /**
474    * Get symbol of this token.
475    *
476    * @return symbol of this token
477    */
478   function symbol () public pure returns (string) {
479     return "XMCU2";
480   }
481 
482   /**
483    * Get number of decimals for this token.
484    *
485    * @return number of decimals for this token
486    */
487   function decimals () public pure returns (uint8) {
488     return 8;
489   }
490 
491   /**
492    * Notify owners about their virtual balances.
493    *
494    * @param _owners addresses of the owners to be notified
495    */
496   function massNotify (address [] _owners) public {
497     require (msg.sender == owner);
498     uint256 count = _owners.length;
499     for (uint256 i = 0; i < count; i++)
500       Transfer (address (0), _owners [i], VIRTUAL_COUNT);
501   }
502 
503   /**
504    * Kill this smart contract.
505    */
506   function kill () public {
507     require (msg.sender == owner);
508     selfdestruct (owner);
509   }
510 
511   /**
512    * Change owner of the smart contract.
513    *
514    * @param _owner address of a new owner of the smart contract
515    */
516   function changeOwner (address _owner) public {
517     require (msg.sender == owner);
518 
519     owner = _owner;
520   }
521   
522    /**
523    * Change address set of the smart contract.
524    *
525    * @param _addressSet address of a new address set of the smart contract
526    */
527   function changeAddressSet (AddressSet _addressSet) public {
528     require (msg.sender == owner);
529 
530     addressSet = _addressSet;
531   }
532 
533   /**
534    * Get virtual balance of the owner of given address.
535    *
536    * @param _owner address to get virtual balance for the owner of
537    * @return virtual balance of the owner of given address
538    */
539   function virtualBalanceOf (address _owner)
540   internal view returns (uint256 _virtualBalance) {
541     return addressSet.contains (_owner) ? VIRTUAL_COUNT : 0;
542   }
543 
544   /**
545    * Address of the owner of this smart contract.
546    */
547   address internal owner;
548 
549   /**
550    * Address set of addresses that are eligible for initial balance.
551    */
552   AddressSet internal addressSet;
553 }