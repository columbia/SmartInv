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
198       accounts [_to] = safeAdd (accounts [_to], _value);
199     }
200     emit Transfer (msg.sender, _to, _value);
201     return true;
202   }
203 
204   /**
205    * Transfer given number of tokens from given owner to given recipient.
206    *
207    * @param _from address to transfer tokens from the owner of
208    * @param _to address to transfer tokens to the owner of
209    * @param _value number of tokens to transfer from given owner to given
210    *        recipient
211    * @return true if tokens were transferred successfully, false otherwise
212    */
213   function transferFrom (address _from, address _to, uint256 _value)
214   public returns (bool success) {
215     require (allowances [_from][msg.sender] >= _value);
216     require (transferrableBalanceOf(_from) >= _value);
217 
218     allowances [_from][msg.sender] =
219       safeSub (allowances [_from][msg.sender], _value);
220 
221     if (_value > 0 && _from != _to) {
222       accounts [_from] = safeSub (accounts [_from], _value);
223       accounts [_to] = safeAdd (accounts [_to], _value);
224     }
225     emit Transfer (_from, _to, _value);
226     return true;
227   }
228 
229   /**
230    * Allow given spender to transfer given number of tokens from message sender.
231    *
232    * @param _spender address to allow the owner of to transfer tokens from
233    *        message sender
234    * @param _value number of tokens to allow to transfer
235    * @return true if token transfer was successfully approved, false otherwise
236    */
237   function approve (address _spender, uint256 _value) public returns (bool success) {
238     allowances [msg.sender][_spender] = _value;
239     emit Approval (msg.sender, _spender, _value);
240 
241     return true;
242   }
243 
244   /**
245    * Tell how many tokens given spender is currently allowed to transfer from
246    * given owner.
247    *
248    * @param _owner address to get number of tokens allowed to be transferred
249    *        from the owner of
250    * @param _spender address to get number of tokens allowed to be transferred
251    *        by the owner of
252    * @return number of tokens given spender is currently allowed to transfer
253    *         from given owner
254    */
255   function allowance (address _owner, address _spender) public constant
256   returns (uint256 remaining) {
257     return allowances [_owner][_spender];
258   }
259 
260   /**
261    * Mapping from addresses of token holders to the numbers of tokens belonging
262    * to these token holders.
263    */
264   mapping (address => uint256) accounts;
265 
266   /**
267    * Mapping from addresses of token holders to the mapping of addresses of
268    * spenders to the allowances set by these token holders to these spenders.
269    */
270   mapping (address => mapping (address => uint256)) private allowances;
271 
272   /**
273    * Mapping from addresses of token holds which cannot be spent until released.
274    */
275   mapping (address =>  uint256) internal holds;
276 }
277 /**
278  * Ponder token smart contract.
279  */
280 
281 
282 contract PonderAirdropToken is AbstractToken {
283   /**
284    * Address of the owner of this smart contract.
285    */
286   mapping (address => bool) private owners;
287   
288   /**
289    * Address of the account which holds the supply
290    */
291   address private supplyOwner;
292   
293   /**
294    * True if tokens transfers are currently frozen, false otherwise.
295    */
296   bool frozen = false;
297 
298   /**
299    * Create new Ponder token smart contract, with given number of tokens issued
300    * and given to msg.sender, and make msg.sender the owner of this smart
301    * contract.
302    */
303   function PonderAirdropToken () public {
304     supplyOwner = msg.sender;
305     owners[supplyOwner] = true;
306     accounts [supplyOwner] = totalSupply();
307   }
308 
309   /**
310    * Get total number of tokens in circulation.
311    *
312    * @return total number of tokens in circulation
313    */
314   function totalSupply () public constant returns (uint256 supply) {
315     return 480000000 * (uint256(10) ** decimals());
316   }
317 
318   /**
319    * Get name of this token.
320    *
321    * @return name of this token
322    */
323   function name () public pure returns (string result) {
324     return "Ponder Airdrop Token";
325   }
326 
327   /**
328    * Get symbol of this token.
329    *
330    * @return symbol of this token
331    */
332   function symbol () public pure returns (string result) {
333     return "PONA";
334   }
335 
336   /**
337    * Get number of decimals for this token.
338    *
339    * @return number of decimals for this token
340    */
341   function decimals () public pure returns (uint8 result) {
342     return 18;
343   }
344 
345   /**
346    * Transfer given number of tokens from message sender to given recipient.
347    *
348    * @param _to address to transfer tokens to the owner of
349    * @param _value number of tokens to transfer to the owner of given address
350    * @return true if tokens were transferred successfully, false otherwise
351    */
352   function transfer (address _to, uint256 _value) public returns (bool success) {
353     if (frozen) return false;
354     else return AbstractToken.transfer (_to, _value);
355   }
356 
357   /**
358    * Transfer given number of tokens from given owner to given recipient.
359    *
360    * @param _from address to transfer tokens from the owner of
361    * @param _to address to transfer tokens to the owner of
362    * @param _value number of tokens to transfer from given owner to given
363    *        recipient
364    * @return true if tokens were transferred successfully, false otherwise
365    */
366   function transferFrom (address _from, address _to, uint256 _value)
367     public returns (bool success) {
368     if (frozen) return false;
369     else return AbstractToken.transferFrom (_from, _to, _value);
370   }
371 
372   /**
373    * Change how many tokens given spender is allowed to transfer from message
374    * spender.  In order to prevent double spending of allowance, this method
375    * receives assumed current allowance value as an argument.  If actual
376    * allowance differs from an assumed one, this method just returns false.
377    *
378    * @param _spender address to allow the owner of to transfer tokens from
379    *        message sender
380    * @param _currentValue assumed number of tokens currently allowed to be
381    *        transferred
382    * @param _newValue number of tokens to allow to transfer
383    * @return true if token transfer was successfully approved, false otherwise
384    */
385   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
386     public returns (bool success) {
387     if (allowance (msg.sender, _spender) == _currentValue)
388       return approve (_spender, _newValue);
389     else return false;
390   }
391 
392   /**
393    * Set new owner for the smart contract.
394    * May only be called by smart contract owner.
395    *
396    * @param _address of new or existing owner of the smart contract
397    * @param _value boolean stating if the _address should be an owner or not
398    */
399   function setOwner (address _address, bool _value) public {
400     require (owners[msg.sender]);
401     // if removing the _address from owners list, make sure owner is not 
402     // removing himself (which could lead to an ownerless contract).
403     require (_value == true || _address != msg.sender);
404 
405     owners[_address] = _value;
406   }
407 
408   /**
409    * Initialize the token holders by contract owner
410    *
411    * @param _to addresses to allocate token for
412    * @param _value number of tokens to be allocated
413    */  
414   function initAccounts (address [] _to, uint256 [] _value) public {
415       require (owners[msg.sender]);
416       require (_to.length == _value.length);
417       for (uint256 i=0; i < _to.length; i++){
418           uint256 amountToAdd;
419           uint256 amountToSub;
420           if (_value[i] > accounts[_to[i]]){
421             amountToAdd = safeSub(_value[i], accounts[_to[i]]);
422           }else{
423             amountToSub = safeSub(accounts[_to[i]], _value[i]);
424           }
425           accounts [supplyOwner] = safeAdd (accounts [supplyOwner], amountToSub);
426           accounts [supplyOwner] = safeSub (accounts [supplyOwner], amountToAdd);
427           accounts [_to[i]] = _value[i];
428           if (amountToAdd > 0){
429             emit Transfer (supplyOwner, _to[i], amountToAdd);
430           }
431       }
432   }
433 
434   /**
435    * Initialize the token holders and hold amounts by contract owner
436    *
437    * @param _to addresses to allocate token for
438    * @param _value number of tokens to be allocated
439    * @param _holds number of tokens to hold from transferring
440    */  
441   function initAccounts (address [] _to, uint256 [] _value, uint256 [] _holds) public {
442     setHolds(_to, _holds);
443     initAccounts(_to, _value);
444   }
445   
446   /**
447    * Set the number of tokens to hold from transferring for a list of 
448    * token holders.
449    * 
450    * @param _account list of account holders
451    * @param _value list of token amounts to hold
452    */
453   function setHolds (address [] _account, uint256 [] _value) public {
454     require (owners[msg.sender]);
455     require (_account.length == _value.length);
456     for (uint256 i=0; i < _account.length; i++){
457         holds[_account[i]] = _value[i];
458     }
459   }
460   
461 
462   /**
463    * Freeze token transfers.
464    * May only be called by smart contract owner.
465    */
466   function freezeTransfers () public {
467     require (owners[msg.sender]);
468 
469     if (!frozen) {
470       frozen = true;
471       emit Freeze ();
472     }
473   }
474 
475   /**
476    * Unfreeze token transfers.
477    * May only be called by smart contract owner.
478    */
479   function unfreezeTransfers () public {
480     require (owners[msg.sender]);
481 
482     if (frozen) {
483       frozen = false;
484       emit Unfreeze ();
485     }
486   }
487 
488   /**
489    * Logged when token transfers were frozen.
490    */
491   event Freeze ();
492 
493   /**
494    * Logged when token transfers were unfrozen.
495    */
496   event Unfreeze ();
497 
498   /**
499    * Kill the token.
500    */
501   function kill() public { 
502     if (owners[msg.sender]) selfdestruct(msg.sender);
503   }
504 }