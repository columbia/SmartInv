1 pragma solidity ^0.4.21;
2 /*
3  * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
4  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
5  */
6 
7 /**
8  * ERC-20 standard token interface, as defined
9  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
10  */
11 contract Token {
12   /**
13    * Get total number of tokens in circulation.
14    *
15    * @return total number of tokens in circulation
16    */
17   function totalSupply () public constant returns (uint256 supply);
18 
19   /**
20    * Get number of tokens currently belonging to given owner.
21    *
22    * @param _owner address to get number of tokens currently belonging to the
23    *        owner of
24    * @return number of tokens currently belonging to the owner of given address
25    */
26   function balanceOf (address _owner) public constant returns (uint256 balance);
27 
28   /**
29    * Transfer given number of tokens from message sender to given recipient.
30    *
31    * @param _to address to transfer tokens to the owner of
32    * @param _value number of tokens to transfer to the owner of given address
33    * @return true if tokens were transferred successfully, false otherwise
34    */
35   function transfer (address _to, uint256 _value) public returns (bool success);
36 
37   /**
38    * Transfer given number of tokens from given owner to given recipient.
39    *
40    * @param _from address to transfer tokens from the owner of
41    * @param _to address to transfer tokens to the owner of
42    * @param _value number of tokens to transfer from given owner to given
43    *        recipient
44    * @return true if tokens were transferred successfully, false otherwise
45    */
46   function transferFrom (address _from, address _to, uint256 _value)
47   public returns (bool success);
48 
49   /**
50    * Allow given spender to transfer given number of tokens from message sender.
51    *
52    * @param _spender address to allow the owner of to transfer tokens from
53    *        message sender
54    * @param _value number of tokens to allow to transfer
55    * @return true if token transfer was successfully approved, false otherwise
56    */
57   function approve (address _spender, uint256 _value) public returns (bool success);
58 
59   /**
60    * Tell how many tokens given spender is currently allowed to transfer from
61    * given owner.
62    *
63    * @param _owner address to get number of tokens allowed to be transferred
64    *        from the owner of
65    * @param _spender address to get number of tokens allowed to be transferred
66    *        by the owner of
67    * @return number of tokens given spender is currently allowed to transfer
68    *         from given owner
69    */
70   function allowance (address _owner, address _spender) constant
71   public returns (uint256 remaining);
72 
73   /**
74    * Logged when tokens were transferred from one owner to another.
75    *
76    * @param _from address of the owner, tokens were transferred from
77    * @param _to address of the owner, tokens were transferred to
78    * @param _value number of tokens transferred
79    */
80   event Transfer (address indexed _from, address indexed _to, uint256 _value);
81 
82   /**
83    * Logged when owner approved his tokens to be transferred by some spender.
84    *
85    * @param _owner owner who approved his tokens to be transferred
86    * @param _spender spender who were allowed to transfer the tokens belonging
87    *        to the owner
88    * @param _value number of tokens belonging to the owner, approved to be
89    *        transferred by the spender
90    */
91   event Approval (
92     address indexed _owner, address indexed _spender, uint256 _value);
93 }
94 /*
95  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
96  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
97  */
98 
99 /**
100  * Provides methods to safely add, subtract and multiply uint256 numbers.
101  */
102 contract SafeMath {
103   uint256 constant private MAX_UINT256 =
104     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
105 
106   /**
107    * Add two uint256 values, throw in case of overflow.
108    *
109    * @param x first value to add
110    * @param y second value to add
111    * @return x + y
112    */
113   function safeAdd (uint256 x, uint256 y)
114   pure internal
115   returns (uint256 z) {
116     assert (x <= MAX_UINT256 - y);
117     return x + y;
118   }
119 
120   /**
121    * Subtract one uint256 value from another, throw in case of underflow.
122    *
123    * @param x value to subtract from
124    * @param y value to subtract
125    * @return x - y
126    */
127   function safeSub (uint256 x, uint256 y)
128   pure internal
129   returns (uint256 z) {
130     assert (x >= y);
131     return x - y;
132   }
133 
134   /**
135    * Multiply two uint256 values, throw in case of overflow.
136    *
137    * @param x first value to multiply
138    * @param y second value to multiply
139    * @return x * y
140    */
141   function safeMul (uint256 x, uint256 y)
142   pure internal
143   returns (uint256 z) {
144     if (y == 0) return 0; // Prevent division by zero at the next line
145     assert (x <= MAX_UINT256 / y);
146     return x * y;
147   }
148 }
149 /**
150  * Abstract Token Smart Contract that could be used as a base contract for
151  * ERC-20 token contracts.
152  */
153 
154 contract AbstractToken is Token, SafeMath {
155   /**
156    * Create new Abstract Token contract.
157    */
158   function AbstractToken () public {
159     // Do nothing
160   }
161 
162   /**
163    * Get number of tokens currently belonging to given owner.
164    *
165    * @param _owner address to get number of tokens currently belonging to the
166    *        owner of
167    * @return number of tokens currently belonging to the owner of given address
168    */
169   function balanceOf (address _owner) public constant returns (uint256 balance) {
170     return accounts [_owner];
171   }
172 
173   /**
174    * Get number of tokens currently belonging to given owner and available for transfer.
175    *
176    * @param _owner address to get number of tokens currently belonging to the
177    *        owner of
178    * @return number of tokens currently belonging to the owner of given address
179    */
180   function transferrableBalanceOf (address _owner) public constant returns (uint256 balance) {
181     if (holds[_owner] > accounts[_owner]) {
182         return 0;
183     } else {
184         return safeSub(accounts[_owner], holds[_owner]);
185     }
186   }
187 
188   /**
189    * Transfer given number of tokens from message sender to given recipient.
190    *
191    * @param _to address to transfer tokens to the owner of
192    * @param _value number of tokens to transfer to the owner of given address
193    * @return true if tokens were transferred successfully, false otherwise
194    */
195   function transfer (address _to, uint256 _value) public returns (bool success) {
196     require (transferrableBalanceOf(msg.sender) >= _value);
197     if (_value > 0 && msg.sender != _to) {
198       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
199       if (!hasAccount[_to]) {
200           hasAccount[_to] = true;
201           accountList.push(_to);
202       }
203       accounts [_to] = safeAdd (accounts [_to], _value);
204     }
205     emit Transfer (msg.sender, _to, _value);
206     return true;
207   }
208 
209   /**
210    * Transfer given number of tokens from given owner to given recipient.
211    *
212    * @param _from address to transfer tokens from the owner of
213    * @param _to address to transfer tokens to the owner of
214    * @param _value number of tokens to transfer from given owner to given
215    *        recipient
216    * @return true if tokens were transferred successfully, false otherwise
217    */
218   function transferFrom (address _from, address _to, uint256 _value)
219   public returns (bool success) {
220     require (allowances [_from][msg.sender] >= _value);
221     require (transferrableBalanceOf(_from) >= _value);
222 
223     allowances [_from][msg.sender] =
224       safeSub (allowances [_from][msg.sender], _value);
225 
226     if (_value > 0 && _from != _to) {
227       accounts [_from] = safeSub (accounts [_from], _value);
228       if (!hasAccount[_to]) {
229           hasAccount[_to] = true;
230           accountList.push(_to);
231       }
232       accounts [_to] = safeAdd (accounts [_to], _value);
233     }
234     emit Transfer (_from, _to, _value);
235     return true;
236   }
237 
238   /**
239    * Allow given spender to transfer given number of tokens from message sender.
240    *
241    * @param _spender address to allow the owner of to transfer tokens from
242    *        message sender
243    * @param _value number of tokens to allow to transfer
244    * @return true if token transfer was successfully approved, false otherwise
245    */
246   function approve (address _spender, uint256 _value) public returns (bool success) {
247     allowances [msg.sender][_spender] = _value;
248     emit Approval (msg.sender, _spender, _value);
249 
250     return true;
251   }
252 
253   /**
254    * Tell how many tokens given spender is currently allowed to transfer from
255    * given owner.
256    *
257    * @param _owner address to get number of tokens allowed to be transferred
258    *        from the owner of
259    * @param _spender address to get number of tokens allowed to be transferred
260    *        by the owner of
261    * @return number of tokens given spender is currently allowed to transfer
262    *         from given owner
263    */
264   function allowance (address _owner, address _spender) public constant
265   returns (uint256 remaining) {
266     return allowances [_owner][_spender];
267   }
268 
269   /**
270    * Mapping from addresses of token holders to the numbers of tokens belonging
271    * to these token holders.
272    */
273   mapping (address => uint256) accounts;
274 
275   /**
276    * Mapping from address of token holders to a boolean to indicate if they have
277    * already been added to the system.
278    */
279   mapping (address => bool) internal hasAccount;
280   
281   /**
282    * List of available accounts.
283    */
284   address [] internal accountList;
285   
286   /**
287    * Mapping from addresses of token holders to the mapping of addresses of
288    * spenders to the allowances set by these token holders to these spenders.
289    */
290   mapping (address => mapping (address => uint256)) private allowances;
291 
292   /**
293    * Mapping from addresses of token holds which cannot be spent until released.
294    */
295   mapping (address =>  uint256) internal holds;
296 }
297 /**
298  * Ponder token smart contract.
299  */
300 
301 
302 contract PonderAirdropToken is AbstractToken {
303   /**
304    * Address of the owner of this smart contract.
305    */
306   mapping (address => bool) private owners;
307   
308   /**
309    * Address of the account which holds the supply
310    */
311   address private supplyOwner;
312   
313   /**
314    * True if tokens transfers are currently frozen, false otherwise.
315    */
316   bool frozen = false;
317 
318   /**
319    * Create new Ponder token smart contract, with given number of tokens issued
320    * and given to msg.sender, and make msg.sender the owner of this smart
321    * contract.
322    */
323   function PonderAirdropToken () public {
324     supplyOwner = msg.sender;
325     owners[supplyOwner] = true;
326     accounts [supplyOwner] = totalSupply();
327     hasAccount [supplyOwner] = true;
328     accountList.push(supplyOwner);
329   }
330 
331   /**
332    * Get total number of tokens in circulation.
333    *
334    * @return total number of tokens in circulation
335    */
336   function totalSupply () public constant returns (uint256 supply) {
337     return 480000000 * (uint256(10) ** decimals());
338   }
339 
340   /**
341    * Get name of this token.
342    *
343    * @return name of this token
344    */
345   function name () public pure returns (string result) {
346     return "Ponder Airdrop Token";
347   }
348 
349   /**
350    * Get symbol of this token.
351    *
352    * @return symbol of this token
353    */
354   function symbol () public pure returns (string result) {
355     return "PONA";
356   }
357 
358   /**
359    * Get number of decimals for this token.
360    *
361    * @return number of decimals for this token
362    */
363   function decimals () public pure returns (uint8 result) {
364     return 18;
365   }
366 
367   /**
368    * Transfer given number of tokens from message sender to given recipient.
369    *
370    * @param _to address to transfer tokens to the owner of
371    * @param _value number of tokens to transfer to the owner of given address
372    * @return true if tokens were transferred successfully, false otherwise
373    */
374   function transfer (address _to, uint256 _value) public returns (bool success) {
375     if (frozen) return false;
376     else return AbstractToken.transfer (_to, _value);
377   }
378 
379   /**
380    * Transfer given number of tokens from given owner to given recipient.
381    *
382    * @param _from address to transfer tokens from the owner of
383    * @param _to address to transfer tokens to the owner of
384    * @param _value number of tokens to transfer from given owner to given
385    *        recipient
386    * @return true if tokens were transferred successfully, false otherwise
387    */
388   function transferFrom (address _from, address _to, uint256 _value)
389     public returns (bool success) {
390     if (frozen) return false;
391     else return AbstractToken.transferFrom (_from, _to, _value);
392   }
393 
394   /**
395    * Change how many tokens given spender is allowed to transfer from message
396    * spender.  In order to prevent double spending of allowance, this method
397    * receives assumed current allowance value as an argument.  If actual
398    * allowance differs from an assumed one, this method just returns false.
399    *
400    * @param _spender address to allow the owner of to transfer tokens from
401    *        message sender
402    * @param _currentValue assumed number of tokens currently allowed to be
403    *        transferred
404    * @param _newValue number of tokens to allow to transfer
405    * @return true if token transfer was successfully approved, false otherwise
406    */
407   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
408     public returns (bool success) {
409     if (allowance (msg.sender, _spender) == _currentValue)
410       return approve (_spender, _newValue);
411     else return false;
412   }
413 
414   /**
415    * Set new owner for the smart contract.
416    * May only be called by smart contract owner.
417    *
418    * @param _address of new or existing owner of the smart contract
419    * @param _value boolean stating if the _address should be an owner or not
420    */
421   function setOwner (address _address, bool _value) public {
422     require (owners[msg.sender]);
423     // if removing the _address from owners list, make sure owner is not 
424     // removing himself (which could lead to an ownerless contract).
425     require (_value == true || _address != msg.sender);
426 
427     owners[_address] = _value;
428   }
429 
430   /**
431    * Initialize the token holders by contract owner
432    *
433    * @param _to addresses to allocate token for
434    * @param _value number of tokens to be allocated
435    */  
436   function initAccounts (address [] _to, uint256 [] _value) public {
437       require (owners[msg.sender]);
438       require (_to.length == _value.length);
439       for (uint256 i=0; i < _to.length; i++){
440           uint256 amountToAdd;
441           uint256 amountToSub;
442           if (_value[i] > accounts[_to[i]]){
443             amountToAdd = safeSub(_value[i], accounts[_to[i]]);
444           }else{
445             amountToSub = safeSub(accounts[_to[i]], _value[i]);
446           }
447           accounts [supplyOwner] = safeAdd (accounts [supplyOwner], amountToSub);
448           accounts [supplyOwner] = safeSub (accounts [supplyOwner], amountToAdd);
449           if (!hasAccount[_to[i]]) {
450               hasAccount[_to[i]] = true;
451               accountList.push(_to[i]);
452           }
453           accounts [_to[i]] = _value[i];
454           if (amountToAdd > 0){
455             emit Transfer (supplyOwner, _to[i], amountToAdd);
456           }
457       }
458   }
459 
460   /**
461    * Initialize the token holders and hold amounts by contract owner
462    *
463    * @param _to addresses to allocate token for
464    * @param _value number of tokens to be allocated
465    * @param _holds number of tokens to hold from transferring
466    */  
467   function initAccounts (address [] _to, uint256 [] _value, uint256 [] _holds) public {
468     setHolds(_to, _holds);
469     initAccounts(_to, _value);
470   }
471   
472   /**
473    * Set the number of tokens to hold from transferring for a list of 
474    * token holders.
475    * 
476    * @param _account list of account holders
477    * @param _value list of token amounts to hold
478    */
479   function setHolds (address [] _account, uint256 [] _value) public {
480     require (owners[msg.sender]);
481     require (_account.length == _value.length);
482     for (uint256 i=0; i < _account.length; i++){
483         holds[_account[i]] = _value[i];
484     }
485   }
486   
487   /**
488    * Get the number of account holders (for owner use)
489    *
490    * @return uint256
491    */  
492   function getNumAccounts () public constant returns (uint256 count) {
493     require (owners[msg.sender]);
494     return accountList.length;
495   }
496   
497   /**
498    * Get a list of account holder eth addresses (for owner use)
499    *
500    * @param _start index of the account holder list
501    * @param _count of items to return
502    * @return array of addresses
503    */  
504   function getAccounts (uint256 _start, uint256 _count) public constant returns (address [] addresses){
505     require (owners[msg.sender]);
506     require (_start >= 0 && _count >= 1);
507     if (_start == 0 && _count >= accountList.length) {
508       return accountList;
509     }
510     address [] memory _slice = new address[](_count);
511     for (uint256 i=0; i < _count; i++){
512       _slice[i] = accountList[i + _start];
513     }
514     return _slice;
515   }
516   
517   /**
518    * Freeze token transfers.
519    * May only be called by smart contract owner.
520    */
521   function freezeTransfers () public {
522     require (owners[msg.sender]);
523 
524     if (!frozen) {
525       frozen = true;
526       emit Freeze ();
527     }
528   }
529 
530   /**
531    * Unfreeze token transfers.
532    * May only be called by smart contract owner.
533    */
534   function unfreezeTransfers () public {
535     require (owners[msg.sender]);
536 
537     if (frozen) {
538       frozen = false;
539       emit Unfreeze ();
540     }
541   }
542 
543   /**
544    * Logged when token transfers were frozen.
545    */
546   event Freeze ();
547 
548   /**
549    * Logged when token transfers were unfrozen.
550    */
551   event Unfreeze ();
552 
553   /**
554    * Kill the token.
555    */
556   function kill() public { 
557     if (owners[msg.sender]) selfdestruct(msg.sender);
558   }
559 }