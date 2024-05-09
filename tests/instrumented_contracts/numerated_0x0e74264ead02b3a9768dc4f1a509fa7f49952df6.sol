1 pragma solidity ^0.4.16;
2 
3 /*
4  * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
5  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
6  */
7 pragma solidity ^0.4.20;
8 
9 /*
10  * EIP-20 Standard Token Smart Contract Interface.
11  * Copyright © 2016–2018 by ABDK Consulting.
12  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
13  */
14 pragma solidity ^0.4.20;
15 
16 /**
17  * ERC-20 standard token interface, as defined
18  * <a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md">here</a>.
19  */
20 contract Token {
21   /**
22    * Get total number of tokens in circulation.
23    *
24    * @return total number of tokens in circulation
25    */
26   function totalSupply () public view returns (uint256 supply);
27 
28   /**
29    * Get number of tokens currently belonging to given owner.
30    *
31    * @param _owner address to get number of tokens currently belonging to the
32    *        owner of
33    * @return number of tokens currently belonging to the owner of given address
34    */
35   function balanceOf (address _owner) public view returns (uint256 balance);
36 
37   /**
38    * Transfer given number of tokens from message sender to given recipient.
39    *
40    * @param _to address to transfer tokens to the owner of
41    * @param _value number of tokens to transfer to the owner of given address
42    * @return true if tokens were transferred successfully, false otherwise
43    */
44   function transfer (address _to, uint256 _value)
45   public returns (bool success);
46 
47   /**
48    * Transfer given number of tokens from given owner to given recipient.
49    *
50    * @param _from address to transfer tokens from the owner of
51    * @param _to address to transfer tokens to the owner of
52    * @param _value number of tokens to transfer from given owner to given
53    *        recipient
54    * @return true if tokens were transferred successfully, false otherwise
55    */
56   function transferFrom (address _from, address _to, uint256 _value)
57   public returns (bool success);
58 
59   /**
60    * Allow given spender to transfer given number of tokens from message sender.
61    *
62    * @param _spender address to allow the owner of to transfer tokens from
63    *        message sender
64    * @param _value number of tokens to allow to transfer
65    * @return true if token transfer was successfully approved, false otherwise
66    */
67   function approve (address _spender, uint256 _value)
68   public returns (bool success);
69 
70   /**
71    * Tell how many tokens given spender is currently allowed to transfer from
72    * given owner.
73    *
74    * @param _owner address to get number of tokens allowed to be transferred
75    *        from the owner of
76    * @param _spender address to get number of tokens allowed to be transferred
77    *        by the owner of
78    * @return number of tokens given spender is currently allowed to transfer
79    *         from given owner
80    */
81   function allowance (address _owner, address _spender)
82   public view returns (uint256 remaining);
83 
84   /**
85    * Logged when tokens were transferred from one owner to another.
86    *
87    * @param _from address of the owner, tokens were transferred from
88    * @param _to address of the owner, tokens were transferred to
89    * @param _value number of tokens transferred
90    */
91   event Transfer (address indexed _from, address indexed _to, uint256 _value);
92 
93   /**
94    * Logged when owner approved his tokens to be transferred by some spender.
95    *
96    * @param _owner owner who approved his tokens to be transferred
97    * @param _spender spender who were allowed to transfer the tokens belonging
98    *        to the owner
99    * @param _value number of tokens belonging to the owner, approved to be
100    *        transferred by the spender
101    */
102   event Approval (
103     address indexed _owner, address indexed _spender, uint256 _value);
104 }
105 /*
106  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
107  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
108  */
109 pragma solidity ^0.4.20;
110 
111 /**
112  * Provides methods to safely add, subtract and multiply uint256 numbers.
113  */
114 contract SafeMath {
115   uint256 constant private MAX_UINT256 =
116     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
117 
118   /**
119    * Add two uint256 values, throw in case of overflow.
120    *
121    * @param x first value to add
122    * @param y second value to add
123    * @return x + y
124    */
125   function safeAdd (uint256 x, uint256 y)
126   pure internal
127   returns (uint256 z) {
128     assert (x <= MAX_UINT256 - y);
129     return x + y;
130   }
131 
132   /**
133    * Subtract one uint256 value from another, throw in case of underflow.
134    *
135    * @param x value to subtract from
136    * @param y value to subtract
137    * @return x - y
138    */
139   function safeSub (uint256 x, uint256 y)
140   pure internal
141   returns (uint256 z) {
142     assert (x >= y);
143     return x - y;
144   }
145 
146   /**
147    * Multiply two uint256 values, throw in case of overflow.
148    *
149    * @param x first value to multiply
150    * @param y second value to multiply
151    * @return x * y
152    */
153   function safeMul (uint256 x, uint256 y)
154   pure internal
155   returns (uint256 z) {
156     if (y == 0) return 0; // Prevent division by zero at the next line
157     assert (x <= MAX_UINT256 / y);
158     return x * y;
159   }
160 }
161 
162 
163 /**
164  * Abstract Token Smart Contract that could be used as a base contract for
165  * ERC-20 token contracts.
166  */
167 contract AbstractToken is Token, SafeMath {
168   /**
169    * Create new Abstract Token contract.
170    */
171   function AbstractToken () public {
172     // Do nothing
173   }
174 
175   /**
176    * Get number of tokens currently belonging to given owner.
177    *
178    * @param _owner address to get number of tokens currently belonging to the
179    *        owner of
180    * @return number of tokens currently belonging to the owner of given address
181    */
182   function balanceOf (address _owner) public view returns (uint256 balance) {
183     return accounts [_owner];
184   }
185 
186   /**
187    * Transfer given number of tokens from message sender to given recipient.
188    *
189    * @param _to address to transfer tokens to the owner of
190    * @param _value number of tokens to transfer to the owner of given address
191    * @return true if tokens were transferred successfully, false otherwise
192    */
193   function transfer (address _to, uint256 _value)
194   public returns (bool success) {
195     uint256 fromBalance = accounts [msg.sender];
196     if (fromBalance < _value) return false;
197     if (_value > 0 && msg.sender != _to) {
198       accounts [msg.sender] = safeSub (fromBalance, _value);
199       accounts [_to] = safeAdd (accounts [_to], _value);
200     }
201     Transfer (msg.sender, _to, _value);
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
216     uint256 spenderAllowance = allowances [_from][msg.sender];
217     if (spenderAllowance < _value) return false;
218     uint256 fromBalance = accounts [_from];
219     if (fromBalance < _value) return false;
220 
221     allowances [_from][msg.sender] =
222       safeSub (spenderAllowance, _value);
223 
224     if (_value > 0 && _from != _to) {
225       accounts [_from] = safeSub (fromBalance, _value);
226       accounts [_to] = safeAdd (accounts [_to], _value);
227     }
228     Transfer (_from, _to, _value);
229     return true;
230   }
231 
232   /**
233    * Allow given spender to transfer given number of tokens from message sender.
234    *
235    * @param _spender address to allow the owner of to transfer tokens from
236    *        message sender
237    * @param _value number of tokens to allow to transfer
238    * @return true if token transfer was successfully approved, false otherwise
239    */
240   function approve (address _spender, uint256 _value)
241   public returns (bool success) {
242     allowances [msg.sender][_spender] = _value;
243     Approval (msg.sender, _spender, _value);
244 
245     return true;
246   }
247 
248   /**
249    * Tell how many tokens given spender is currently allowed to transfer from
250    * given owner.
251    *
252    * @param _owner address to get number of tokens allowed to be transferred
253    *        from the owner of
254    * @param _spender address to get number of tokens allowed to be transferred
255    *        by the owner of
256    * @return number of tokens given spender is currently allowed to transfer
257    *         from given owner
258    */
259   function allowance (address _owner, address _spender)
260   public view returns (uint256 remaining) {
261     return allowances [_owner][_spender];
262   }
263 
264   /**
265    * Mapping from addresses of token holders to the numbers of tokens belonging
266    * to these token holders.
267    */
268   mapping (address => uint256) internal accounts;
269 
270   /**
271    * Mapping from addresses of token holders to the mapping of addresses of
272    * spenders to the allowances set by these token holders to these spenders.
273    */
274   mapping (address => mapping (address => uint256)) internal allowances;
275 }
276 
277 
278 /**
279  * XELS Token SELS token smart contract.
280  */
281 contract XELSToken is AbstractToken {
282   /**
283    * Maximum allowed number of tokens in circulation.
284    */
285   uint256 constant MAX_TOKEN_COUNT =
286     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
287 
288   /**
289    * Address of the owner of this smart contract.
290    */
291   address private owner;
292 
293   /**
294    * Current number of tokens in circulation.
295    */
296   uint256 tokenCount = 0;
297 
298   /**
299    * True if tokens transfers are currently frozen, false otherwise.
300    */
301   bool frozen = false;
302 
303   /**
304    * Create new XELS Token SELS token smart contract and make msg.sender the
305    * owner of this smart contract.
306    */
307   function XELSToken () public {
308     owner = msg.sender;
309   }
310 
311   /**
312    * Get total number of tokens in circulation.
313    *
314    * @return total number of tokens in circulation
315    */
316   function totalSupply () public view returns (uint256 supply) {
317     return tokenCount;
318   }
319 
320   /**
321    * Get name of this token.
322    *
323    * @return name of this token
324    */
325   function name () public pure returns (string result) {
326     return "XELS Token";
327   }
328 
329   /**
330    * Get symbol of this token.
331    *
332    * @return symbol of this token
333    */
334   function symbol () public pure returns (string result) {
335     return "SELS";
336   }
337 
338   /**
339    * Get number of decimals for this token.
340    *
341    * @return number of decimals for this token
342    */
343   function decimals () public pure returns (uint8 result) {
344     return 8;
345   }
346 
347   /**
348    * Transfer given number of tokens from message sender to given recipient.
349    *
350    * @param _to address to transfer tokens to the owner of
351    * @param _value number of tokens to transfer to the owner of given address
352    * @return true if tokens were transferred successfully, false otherwise
353    */
354   function transfer (address _to, uint256 _value)
355     public returns (bool success) {
356     if (frozen) return false;
357     else return AbstractToken.transfer (_to, _value);
358   }
359 
360   /**
361    * Transfer given number of tokens from given owner to given recipient.
362    *
363    * @param _from address to transfer tokens from the owner of
364    * @param _to address to transfer tokens to the owner of
365    * @param _value number of tokens to transfer from given owner to given
366    *        recipient
367    * @return true if tokens were transferred successfully, false otherwise
368    */
369   function transferFrom (address _from, address _to, uint256 _value)
370     public returns (bool success) {
371     if (frozen) return false;
372     else return AbstractToken.transferFrom (_from, _to, _value);
373   }
374 
375   /**
376    * Change how many tokens given spender is allowed to transfer from message
377    * spender.  In order to prevent double spending of allowance, this method
378    * receives assumed current allowance value as an argument.  If actual
379    * allowance differs from an assumed one, this method just returns false.
380    *
381    * @param _spender address to allow the owner of to transfer tokens from
382    *        message sender
383    * @param _currentValue assumed number of tokens currently allowed to be
384    *        transferred
385    * @param _newValue number of tokens to allow to transfer
386    * @return true if token transfer was successfully approved, false otherwise
387    */
388   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
389     public returns (bool success) {
390     if (allowance (msg.sender, _spender) == _currentValue)
391       return approve (_spender, _newValue);
392     else return false;
393   }
394 
395   /**
396    * Burn given number of tokens belonging to message sender.
397    *
398    * @param _value number of tokens to burn
399    * @return true on success, false on error
400    */
401   function burnTokens (uint256 _value) public returns (bool success) {
402     if (_value > accounts [msg.sender]) return false;
403     else if (_value > 0) {
404       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
405       tokenCount = safeSub (tokenCount, _value);
406 
407       Transfer (msg.sender, address (0), _value);
408       return true;
409     } else return true;
410   }
411 
412   /**
413    * Create _value new tokens and give new created tokens to msg.sender.
414    * May only be called by smart contract owner.
415    *
416    * @param _value number of tokens to create
417    * @return true if tokens were created successfully, false otherwise
418    */
419   function createTokens (uint256 _value)
420     public returns (bool success) {
421     require (msg.sender == owner);
422 
423     if (_value > 0) {
424       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
425       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
426       tokenCount = safeAdd (tokenCount, _value);
427 
428       Transfer (address (0), msg.sender, _value);
429     }
430 
431     return true;
432   }
433 
434   /**
435    * Set new owner for the smart contract.
436    * May only be called by smart contract owner.
437    *
438    * @param _newOwner address of new owner of the smart contract
439    */
440   function setOwner (address _newOwner) public {
441     require (msg.sender == owner);
442 
443     owner = _newOwner;
444   }
445 
446   /**
447    * Freeze token transfers.
448    * May only be called by smart contract owner.
449    */
450   function freezeTransfers () public {
451     require (msg.sender == owner);
452 
453     if (!frozen) {
454       frozen = true;
455       Freeze ();
456     }
457   }
458 
459   /**
460    * Unfreeze token transfers.
461    * May only be called by smart contract owner.
462    */
463   function unfreezeTransfers () public {
464     require (msg.sender == owner);
465 
466     if (frozen) {
467       frozen = false;
468       Unfreeze ();
469     }
470   }
471 
472   /**
473    * Logged when token transfers were frozen.
474    */
475   event Freeze ();
476 
477   /**
478    * Logged when token transfers were unfrozen.
479    */
480   event Unfreeze ();
481 }