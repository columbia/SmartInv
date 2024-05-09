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
158   constructor () public {
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
199       accounts [_to] = safeAdd (accounts [_to], _value);
200     }
201     emit Transfer (msg.sender, _to, _value);
202     return true;
203   }
204 
205   /**
206    * Transfer given number of tokens from given owner to given recipient.
207    *
208    * @param _from address to transfer tokens from the owner of
209    * @param _to address to transfer tokens to the owner of
210    * @param _value number of tokens to transfer from given owner to given
211    *        recipient
212    * @return true if tokens were transferred successfully, false otherwise
213    */
214   function transferFrom (address _from, address _to, uint256 _value)
215   public returns (bool success) {
216     require (allowances [_from][msg.sender] >= _value);
217     require (transferrableBalanceOf(_from) >= _value);
218 
219     allowances [_from][msg.sender] =
220       safeSub (allowances [_from][msg.sender], _value);
221 
222     if (_value > 0 && _from != _to) {
223       accounts [_from] = safeSub (accounts [_from], _value);
224       accounts [_to] = safeAdd (accounts [_to], _value);
225     }
226     emit Transfer (_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * Allow given spender to transfer given number of tokens from message sender.
232    *
233    * @param _spender address to allow the owner of to transfer tokens from
234    *        message sender
235    * @param _value number of tokens to allow to transfer
236    * @return true if token transfer was successfully approved, false otherwise
237    */
238   function approve (address _spender, uint256 _value) public returns (bool success) {
239     allowances [msg.sender][_spender] = _value;
240     emit Approval (msg.sender, _spender, _value);
241 
242     return true;
243   }
244 
245   /**
246    * Tell how many tokens given spender is currently allowed to transfer from
247    * given owner.
248    *
249    * @param _owner address to get number of tokens allowed to be transferred
250    *        from the owner of
251    * @param _spender address to get number of tokens allowed to be transferred
252    *        by the owner of
253    * @return number of tokens given spender is currently allowed to transfer
254    *         from given owner
255    */
256   function allowance (address _owner, address _spender) public constant
257   returns (uint256 remaining) {
258     return allowances [_owner][_spender];
259   }
260 
261   /**
262    * Mapping from addresses of token holders to the numbers of tokens belonging
263    * to these token holders.
264    */
265   mapping (address => uint256) accounts;
266 
267   /**
268    * Mapping from addresses of token holders to the mapping of addresses of
269    * spenders to the allowances set by these token holders to these spenders.
270    */
271   mapping (address => mapping (address => uint256)) private allowances;
272 
273   /**
274    * Mapping from addresses of token holds which cannot be spent until released.
275    */
276   mapping (address =>  uint256) internal holds;
277 }
278 /**
279  * Ponder token smart contract.
280  */
281 
282 
283 contract PonderAirdropToken is AbstractToken {
284   /**
285    * Address of the owner of this smart contract.
286    */
287   mapping (address => bool) private owners;
288   
289   /**
290    * Address of the account which holds the supply
291    */
292   address private supplyOwner;
293   
294   /**
295    * True if tokens transfers are currently frozen, false otherwise.
296    */
297   bool frozen = false;
298 
299   /**
300    * Create new Ponder token smart contract, with given number of tokens issued
301    * and given to msg.sender, and make msg.sender the owner of this smart
302    * contract.
303    */
304   constructor () public {
305     supplyOwner = msg.sender;
306     owners[supplyOwner] = true;
307     accounts [supplyOwner] = totalSupply();
308   }
309 
310   /**
311    * Get total number of tokens in circulation.
312    *
313    * @return total number of tokens in circulation
314    */
315   function totalSupply () public constant returns (uint256 supply) {
316     return 480000000 * (uint256(10) ** decimals());
317   }
318 
319   /**
320    * Get name of this token.
321    *
322    * @return name of this token
323    */
324   function name () public pure returns (string result) {
325     return "Ponder Airdrop Token";
326   }
327 
328   /**
329    * Get symbol of this token.
330    *
331    * @return symbol of this token
332    */
333   function symbol () public pure returns (string result) {
334     return "PONAIR";
335   }
336 
337   /**
338    * Get number of decimals for this token.
339    *
340    * @return number of decimals for this token
341    */
342   function decimals () public pure returns (uint8 result) {
343     return 18;
344   }
345 
346   /**
347    * Transfer given number of tokens from message sender to given recipient.
348    *
349    * @param _to address to transfer tokens to the owner of
350    * @param _value number of tokens to transfer to the owner of given address
351    * @return true if tokens were transferred successfully, false otherwise
352    */
353   function transfer (address _to, uint256 _value) public returns (bool success) {
354     if (frozen) return false;
355     else return AbstractToken.transfer (_to, _value);
356   }
357 
358   /**
359    * Transfer given number of tokens from given owner to given recipient.
360    *
361    * @param _from address to transfer tokens from the owner of
362    * @param _to address to transfer tokens to the owner of
363    * @param _value number of tokens to transfer from given owner to given
364    *        recipient
365    * @return true if tokens were transferred successfully, false otherwise
366    */
367   function transferFrom (address _from, address _to, uint256 _value)
368     public returns (bool success) {
369     if (frozen) return false;
370     else return AbstractToken.transferFrom (_from, _to, _value);
371   }
372 
373   /**
374    * Change how many tokens given spender is allowed to transfer from message
375    * spender.  In order to prevent double spending of allowance, this method
376    * receives assumed current allowance value as an argument.  If actual
377    * allowance differs from an assumed one, this method just returns false.
378    *
379    * @param _spender address to allow the owner of to transfer tokens from
380    *        message sender
381    * @param _currentValue assumed number of tokens currently allowed to be
382    *        transferred
383    * @param _newValue number of tokens to allow to transfer
384    * @return true if token transfer was successfully approved, false otherwise
385    */
386   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
387     public returns (bool success) {
388     if (allowance (msg.sender, _spender) == _currentValue)
389       return approve (_spender, _newValue);
390     else return false;
391   }
392 
393   /**
394    * Set new owner for the smart contract.
395    * May only be called by smart contract owner.
396    *
397    * @param _address of new or existing owner of the smart contract
398    * @param _value boolean stating if the _address should be an owner or not
399    */
400   function setOwner (address _address, bool _value) public {
401     require (owners[msg.sender]);
402     // if removing the _address from owners list, make sure owner is not 
403     // removing himself (which could lead to an ownerless contract).
404     require (_value == true || _address != msg.sender);
405 
406     owners[_address] = _value;
407   }
408 
409   /**
410    * Initialize the token holders by contract owner
411    *
412    * @param _to addresses to allocate token for
413    * @param _value number of tokens to be allocated
414    */  
415   function initAccounts (address [] _to, uint256 [] _value) public {
416       require (owners[msg.sender]);
417       require (_to.length == _value.length);
418       for (uint256 i=0; i < _to.length; i++){
419           uint256 amountToAdd;
420           uint256 amountToSub;
421           if (_value[i] > accounts[_to[i]]){
422             amountToAdd = safeSub(_value[i], accounts[_to[i]]);
423           }else{
424             amountToSub = safeSub(accounts[_to[i]], _value[i]);
425           }
426           accounts [supplyOwner] = safeAdd (accounts [supplyOwner], amountToSub);
427           accounts [supplyOwner] = safeSub (accounts [supplyOwner], amountToAdd);
428           accounts [_to[i]] = _value[i];
429           if (amountToAdd > 0){
430             emit Transfer (supplyOwner, _to[i], amountToAdd);
431           }
432       }
433   }
434 
435   /**
436    * Initialize the token holders and hold amounts by contract owner
437    *
438    * @param _to addresses to allocate token for
439    * @param _value number of tokens to be allocated
440    * @param _holds number of tokens to hold from transferring
441    */  
442   function initAccountsWithHolds (address [] _to, uint256 [] _value, uint256 [] _holds) public {
443     setHolds(_to, _holds);
444     initAccounts(_to, _value);
445   }
446   
447   /**
448    * Set the number of tokens to hold from transferring for a list of 
449    * token holders.
450    * 
451    * @param _account list of account holders
452    * @param _value list of token amounts to hold
453    */
454   function setHolds (address [] _account, uint256 [] _value) public {
455     require (owners[msg.sender]);
456     require (_account.length == _value.length);
457     for (uint256 i=0; i < _account.length; i++){
458         holds[_account[i]] = _value[i];
459     }
460   }
461   
462 
463   /**
464    * Freeze token transfers.
465    * May only be called by smart contract owner.
466    */
467   function freezeTransfers () public {
468     require (owners[msg.sender]);
469 
470     if (!frozen) {
471       frozen = true;
472       emit Freeze ();
473     }
474   }
475 
476   /**
477    * Unfreeze token transfers.
478    * May only be called by smart contract owner.
479    */
480   function unfreezeTransfers () public {
481     require (owners[msg.sender]);
482 
483     if (frozen) {
484       frozen = false;
485       emit Unfreeze ();
486     }
487   }
488 
489   /**
490    * Logged when token transfers were frozen.
491    */
492   event Freeze ();
493 
494   /**
495    * Logged when token transfers were unfrozen.
496    */
497   event Unfreeze ();
498 
499   /**
500    * Kill the token.
501    */
502   function kill() public { 
503     require (owners[msg.sender]);
504     selfdestruct(msg.sender);
505   }
506 }