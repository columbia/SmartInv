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
174    * Transfer given number of tokens from message sender to given recipient.
175    *
176    * @param _to address to transfer tokens to the owner of
177    * @param _value number of tokens to transfer to the owner of given address
178    * @return true if tokens were transferred successfully, false otherwise
179    */
180   function transfer (address _to, uint256 _value) public returns (bool success) {
181     if (accounts [msg.sender] < _value) return false;
182     if (_value > 0 && msg.sender != _to) {
183       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
184       if (!hasAccount[_to]) {
185           hasAccount[_to] = true;
186           accountList.push(_to);
187       }
188       accounts [_to] = safeAdd (accounts [_to], _value);
189     }
190     emit Transfer (msg.sender, _to, _value);
191     return true;
192   }
193 
194   /**
195    * Transfer given number of tokens from given owner to given recipient.
196    *
197    * @param _from address to transfer tokens from the owner of
198    * @param _to address to transfer tokens to the owner of
199    * @param _value number of tokens to transfer from given owner to given
200    *        recipient
201    * @return true if tokens were transferred successfully, false otherwise
202    */
203   function transferFrom (address _from, address _to, uint256 _value)
204   public returns (bool success) {
205     if (allowances [_from][msg.sender] < _value) return false;
206     if (accounts [_from] < _value) return false;
207 
208     allowances [_from][msg.sender] =
209       safeSub (allowances [_from][msg.sender], _value);
210 
211     if (_value > 0 && _from != _to) {
212       accounts [_from] = safeSub (accounts [_from], _value);
213       if (!hasAccount[_to]) {
214           hasAccount[_to] = true;
215           accountList.push(_to);
216       }
217       accounts [_to] = safeAdd (accounts [_to], _value);
218     }
219     emit Transfer (_from, _to, _value);
220     return true;
221   }
222 
223   /**
224    * Allow given spender to transfer given number of tokens from message sender.
225    *
226    * @param _spender address to allow the owner of to transfer tokens from
227    *        message sender
228    * @param _value number of tokens to allow to transfer
229    * @return true if token transfer was successfully approved, false otherwise
230    */
231   function approve (address _spender, uint256 _value) public returns (bool success) {
232     allowances [msg.sender][_spender] = _value;
233     emit Approval (msg.sender, _spender, _value);
234 
235     return true;
236   }
237 
238   /**
239    * Tell how many tokens given spender is currently allowed to transfer from
240    * given owner.
241    *
242    * @param _owner address to get number of tokens allowed to be transferred
243    *        from the owner of
244    * @param _spender address to get number of tokens allowed to be transferred
245    *        by the owner of
246    * @return number of tokens given spender is currently allowed to transfer
247    *         from given owner
248    */
249   function allowance (address _owner, address _spender) public constant
250   returns (uint256 remaining) {
251     return allowances [_owner][_spender];
252   }
253 
254   /**
255    * Mapping from addresses of token holders to the numbers of tokens belonging
256    * to these token holders.
257    */
258   mapping (address => uint256) accounts;
259 
260   /**
261    * Mapping from address of token holders to a boolean to indicate if they have
262    * already been added to the system.
263    */
264   mapping (address => bool) internal hasAccount;
265   
266   /**
267    * List of available accounts.
268    */
269   address [] internal accountList;
270   
271   /**
272    * Mapping from addresses of token holders to the mapping of addresses of
273    * spenders to the allowances set by these token holders to these spenders.
274    */
275   mapping (address => mapping (address => uint256)) private allowances;
276 }
277 /**
278  * Ponder token smart contract.
279  */
280 
281 
282 contract PonderGoldToken is AbstractToken {
283   /**
284    * Address of the owner of this smart contract.
285    */
286   address private owner;
287 
288   /**
289    * True if tokens transfers are currently frozen, false otherwise.
290    */
291   bool frozen = false;
292 
293   /**
294    * Create new Ponder token smart contract, with given number of tokens issued
295    * and given to msg.sender, and make msg.sender the owner of this smart
296    * contract.
297    */
298   function PonderGoldToken () public {
299     owner = msg.sender;
300     accounts [msg.sender] = totalSupply();
301     hasAccount [msg.sender] = true;
302     accountList.push(msg.sender);
303   }
304 
305   /**
306    * Get total number of tokens in circulation.
307    *
308    * @return total number of tokens in circulation
309    */
310   function totalSupply () public constant returns (uint256 supply) {
311     return 480000000 * (uint256(10) ** decimals());
312   }
313 
314   /**
315    * Get name of this token.
316    *
317    * @return name of this token
318    */
319   function name () public pure returns (string result) {
320     return "Ponder Gold Token";
321   }
322 
323   /**
324    * Get symbol of this token.
325    *
326    * @return symbol of this token
327    */
328   function symbol () public pure returns (string result) {
329     return "PON";
330   }
331 
332   /**
333    * Get number of decimals for this token.
334    *
335    * @return number of decimals for this token
336    */
337   function decimals () public pure returns (uint8 result) {
338     return 18;
339   }
340 
341   /**
342    * Transfer given number of tokens from message sender to given recipient.
343    *
344    * @param _to address to transfer tokens to the owner of
345    * @param _value number of tokens to transfer to the owner of given address
346    * @return true if tokens were transferred successfully, false otherwise
347    */
348   function transfer (address _to, uint256 _value) public returns (bool success) {
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
363     public returns (bool success) {
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
382     public returns (bool success) {
383     if (allowance (msg.sender, _spender) == _currentValue)
384       return approve (_spender, _newValue);
385     else return false;
386   }
387 
388   /**
389    * Set new owner for the smart contract.
390    * May only be called by smart contract owner.
391    *
392    * @param _newOwner address of new owner of the smart contract
393    */
394   function setOwner (address _newOwner) public {
395     require (msg.sender == owner);
396 
397     owner = _newOwner;
398   }
399 
400   /**
401    * Freeze token transfers.
402    * May only be called by smart contract owner.
403    */
404   function freezeTransfers () public {
405     require (msg.sender == owner);
406 
407     if (!frozen) {
408       frozen = true;
409       emit Freeze ();
410     }
411   }
412 
413   /**
414    * Unfreeze token transfers.
415    * May only be called by smart contract owner.
416    */
417   function unfreezeTransfers () public {
418     require (msg.sender == owner);
419 
420     if (frozen) {
421       frozen = false;
422       emit Unfreeze ();
423     }
424   }
425 
426   /**
427    * Logged when token transfers were frozen.
428    */
429   event Freeze ();
430 
431   /**
432    * Logged when token transfers were unfrozen.
433    */
434   event Unfreeze ();
435 
436   /**
437    * Initialize the token holders by contract owner
438    *
439    * @param _to addresses to allocate token for
440    * @param _value number of tokens to be allocated
441    */  
442   function initAccounts (address [] _to, uint256 [] _value) public {
443       require (msg.sender == owner);
444       require (_to.length == _value.length);
445       for (uint256 i=0; i < _to.length; i++){
446           accounts [msg.sender] = safeSub (accounts [msg.sender], _value[i]);
447           if (!hasAccount[_to[i]]) {
448               hasAccount[_to[i]] = true;
449               accountList.push(_to[i]);
450           }
451           accounts [_to[i]] = safeAdd (accounts [_to[i]], _value[i]);
452           emit Transfer (msg.sender, _to[i], _value[i]);
453       }
454   }
455   
456   /**
457    * Get the number of account holders (for owner use)
458    *
459    * @return uint256
460    */  
461   function getNumAccounts () public constant returns (uint256 count) {
462       require (msg.sender == owner);
463       return accountList.length;
464   }
465   
466   /**
467    * Get a list of account holder eth addresses (for owner use)
468    *
469    * @param _start index of the account holder list
470    * @param _count of items to return
471    * @return array of addresses
472    */  
473   function getAccounts (uint256 _start, uint256 _count) public constant returns (address [] addresses){
474       require (msg.sender == owner);
475       require (_start >= 0 && _count >= 1);
476       if (_start == 0 && _count >= accountList.length) {
477           return accountList;
478       }
479       address [] memory _slice = new address[](_count);
480       for (uint256 i=0; i < _count; i++){
481           _slice[i] = accountList[i + _start];
482       }
483       return _slice;
484   }
485 }