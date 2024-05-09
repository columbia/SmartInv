1 /*
2  * ERC-20 Standard Token Smart Contract Interface.
3  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
4  */
5 pragma solidity ^0.4.16;
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
17   function totalSupply () constant returns (uint256 supply);
18 
19   /**
20    * Get number of tokens currently belonging to given owner.
21    *
22    * @param _owner address to get number of tokens currently belonging to the
23    *        owner of
24    * @return number of tokens currently belonging to the owner of given address
25    */
26   function balanceOf (address _owner) constant returns (uint256 balance);
27 
28   /**
29    * Transfer given number of tokens from message sender to given recipient.
30    *
31    * @param _to address to transfer tokens to the owner of
32    * @param _value number of tokens to transfer to the owner of given address
33    * @return true if tokens were transferred successfully, false otherwise
34    */
35   function transfer (address _to, uint256 _value) returns (bool success);
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
47   returns (bool success);
48 
49   /**
50    * Allow given spender to transfer given number of tokens from message sender.
51    *
52    * @param _spender address to allow the owner of to transfer tokens from
53    *        message sender
54    * @param _value number of tokens to allow to transfer
55    * @return true if token transfer was successfully approved, false otherwise
56    */
57   function approve (address _spender, uint256 _value) returns (bool success);
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
71   returns (uint256 remaining);
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
94 
95 /*
96  * Safe Math Smart Contract.  
97  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
98  */
99 pragma solidity ^0.4.16;
100 
101 /**
102  * Provides methods to safely add, subtract and multiply uint256 numbers.
103  */
104 contract SafeMath {
105   uint256 constant private MAX_UINT256 =
106     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
107 
108   /**
109    * Add two uint256 values, throw in case of overflow.
110    *
111    * @param x first value to add
112    * @param y second value to add
113    * @return x + y
114    */
115   function safeAdd (uint256 x, uint256 y)
116   constant internal
117   returns (uint256 z) {
118     assert (x <= MAX_UINT256 - y);
119     return x + y;
120   }
121 
122   /**
123    * Subtract one uint256 value from another, throw in case of underflow.
124    *
125    * @param x value to subtract from
126    * @param y value to subtract
127    * @return x - y
128    */
129   function safeSub (uint256 x, uint256 y)
130   constant internal
131   returns (uint256 z) {
132     assert (x >= y);
133     return x - y;
134   }
135 
136   /**
137    * Multiply two uint256 values, throw in case of overflow.
138    *
139    * @param x first value to multiply
140    * @param y second value to multiply
141    * @return x * y
142    */
143   function safeMul (uint256 x, uint256 y)
144   constant internal
145   returns (uint256 z) {
146     if (y == 0) return 0; // Prevent division by zero at the next line
147     assert (x <= MAX_UINT256 / y);
148     return x * y;
149   }
150 }
151 
152 /*
153  * Abstract Token Smart Contract.  
154  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
155  */
156 
157 /**
158  * Abstract Token Smart Contract that could be used as a base contract for
159  * ERC-20 token contracts.
160  */
161 contract AbstractToken is Token, SafeMath {
162   /**
163    * Create new Abstract Token contract.
164    */
165   function AbstractToken () {
166     // Do nothing
167   }
168 
169   /**
170    * Get number of tokens currently belonging to given owner.
171    *
172    * @param _owner address to get number of tokens currently belonging to the
173    *        owner of
174    * @return number of tokens currently belonging to the owner of given address
175    */
176   function balanceOf (address _owner) constant returns (uint256 balance) {
177     return accounts [_owner];
178   }
179 
180   /**
181    * Transfer given number of tokens from message sender to given recipient.
182    *
183    * @param _to address to transfer tokens to the owner of
184    * @param _value number of tokens to transfer to the owner of given address
185    * @return true if tokens were transferred successfully, false otherwise
186    */
187   function transfer (address _to, uint256 _value) returns (bool success) {
188     uint256 fromBalance = accounts [msg.sender];
189     if (fromBalance < _value) return false;
190     if (_value > 0 && msg.sender != _to) {
191       accounts [msg.sender] = safeSub (fromBalance, _value);
192       accounts [_to] = safeAdd (accounts [_to], _value);
193       Transfer (msg.sender, _to, _value);
194     }
195     return true;
196   }
197 
198   /**
199    * Transfer given number of tokens from given owner to given recipient.
200    *
201    * @param _from address to transfer tokens from the owner of
202    * @param _to address to transfer tokens to the owner of
203    * @param _value number of tokens to transfer from given owner to given
204    *        recipient
205    * @return true if tokens were transferred successfully, false otherwise
206    */
207   function transferFrom (address _from, address _to, uint256 _value)
208   returns (bool success) {
209     uint256 spenderAllowance = allowances [_from][msg.sender];
210     if (spenderAllowance < _value) return false;
211     uint256 fromBalance = accounts [_from];
212     if (fromBalance < _value) return false;
213 
214     allowances [_from][msg.sender] =
215       safeSub (spenderAllowance, _value);
216 
217     if (_value > 0 && _from != _to) {
218       accounts [_from] = safeSub (fromBalance, _value);
219       accounts [_to] = safeAdd (accounts [_to], _value);
220       Transfer (_from, _to, _value);
221     }
222     return true;
223   }
224 
225   /**
226    * Allow given spender to transfer given number of tokens from message sender.
227    *
228    * @param _spender address to allow the owner of to transfer tokens from
229    *        message sender
230    * @param _value number of tokens to allow to transfer
231    * @return true if token transfer was successfully approved, false otherwise
232    */
233   function approve (address _spender, uint256 _value) returns (bool success) {
234     allowances [msg.sender][_spender] = _value;
235     Approval (msg.sender, _spender, _value);
236 
237     return true;
238   }
239 
240   /**
241    * Tell how many tokens given spender is currently allowed to transfer from
242    * given owner.
243    *
244    * @param _owner address to get number of tokens allowed to be transferred
245    *        from the owner of
246    * @param _spender address to get number of tokens allowed to be transferred
247    *        by the owner of
248    * @return number of tokens given spender is currently allowed to transfer
249    *         from given owner
250    */
251   function allowance (address _owner, address _spender) constant
252   returns (uint256 remaining) {
253     return allowances [_owner][_spender];
254   }
255 
256   /**
257    * Mapping from addresses of token holders to the numbers of tokens belonging
258    * to these token holders.
259    */
260   mapping (address => uint256) accounts;
261 
262   /**
263    * Mapping from addresses of token holders to the mapping of addresses of
264    * spenders to the allowances set by these token holders to these spenders.
265    */
266   mapping (address => mapping (address => uint256)) private allowances;
267 }
268 
269 
270 
271 /*
272  * Protos Token Smart Contract.  
273  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
274  */
275 pragma solidity ^0.4.16;
276 
277 
278 /**
279  * Protos Token Smart Contract.
280  */
281 contract ProtosToken is AbstractToken {
282   /**
283    * Maximum allowed number of tokens in circulation.
284    */
285   uint256 constant MAX_TOKEN_COUNT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // 2^256 - 1
286 
287   /**
288    * Address of the owner of this smart contract.
289    */
290   address owner;
291 
292   /**
293    * Current number of tokens in circulation
294    */
295   uint256 tokenCount = 0;
296 
297   /**
298    * True if tokens transfers are currently frozen, false otherwise.
299    */
300   bool frozen = false;
301 
302   /**
303    * Create new Protos Token smart contract and make message sender to be the
304    * owner of the smart contract.
305    */
306   function ProtosToken () AbstractToken () {
307     owner = msg.sender;
308   }
309 
310   /**
311    * Get name of this token.
312    *
313    * @return name of this token
314    */
315   function name () constant returns (string result) {
316     return "PROTOS";
317   }
318 
319   /**
320    * Get symbol of this token.
321    *
322    * @return symbol of this token
323    */
324   function symbol () constant returns (string result) {
325     return "PRTS";
326   }
327 
328   /**
329    * Get number of decimals for this token.
330    *
331    * @return number of decimals for this token
332    */
333   function decimals () constant returns (uint8 result) {
334     return 0;
335   }
336 
337   /**
338    * Get total number of tokens in circulation.
339    *
340    * @return total number of tokens in circulation
341    */
342   function totalSupply () constant returns (uint256 supply) {
343     return tokenCount;
344   }
345 
346   /**
347    * Transfer given number of tokens from message sender to given recipient.
348    *
349    * @param _to address to transfer tokens to the owner of
350    * @param _value number of tokens to transfer to the owner of given address
351    * @return true if tokens were transferred successfully, false otherwise
352    */
353   function transfer (address _to, uint256 _value) returns (bool success) {
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
368   returns (bool success) {
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
387   returns (bool success) {
388     if (allowance (msg.sender, _spender) == _currentValue)
389       return approve (_spender, _newValue);
390     else return false;
391   }
392 
393   /**
394    * Create _value new tokens and give new created tokens to msg.sender.
395    * May only be called by smart contract owner.
396    *
397    * @param _value number of tokens to create
398    * @return true if tokens were created successfully, false otherwise
399    */
400   function createTokens (uint256 _value)
401   returns (bool success) {
402     require (msg.sender == owner);
403 
404     if (_value > 0) {
405       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
406       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
407       tokenCount = safeAdd (tokenCount, _value);
408     }
409 
410     return true;
411   }
412 
413   /**
414    * Burn given number of tokens belonging to message sender.
415    *
416    * @param _value number of tokens to burn
417    * @return true on success, false on error
418    */
419   function burnTokens (uint256 _value) returns (bool success) {
420     uint256 ownerBalance = accounts [msg.sender];
421     if (_value > ownerBalance) return false;
422     else if (_value > 0) {
423       accounts [msg.sender] = safeSub (ownerBalance, _value);
424       tokenCount = safeSub (tokenCount, _value);
425       return true;
426     } else return true;
427   }
428 
429   /**
430    * Set new owner for the smart contract.
431    * May only be called by smart contract owner.
432    *
433    * @param _newOwner address of new owner of the smart contract
434    */
435   function setOwner (address _newOwner) {
436     require (msg.sender == owner);
437 
438     owner = _newOwner;
439   }
440 
441   /**
442    * Freeze token transfers.
443    * May only be called by smart contract owner.
444    */
445   function freezeTransfers () {
446     require (msg.sender == owner);
447 
448     if (!frozen) {
449       frozen = true;
450       Freeze ();
451     }
452   }
453 
454   /**
455    * Unfreeze token transfers.
456    * May only be called by smart contract owner.
457    */
458   function unfreezeTransfers () {
459     require (msg.sender == owner);
460 
461     if (frozen) {
462       frozen = false;
463       Unfreeze ();
464     }
465   }
466 
467   /**
468    * Logged when token transfers were frozen.
469    */
470   event Freeze ();
471 
472   /**
473    * Logged when token transfers were unfrozen.
474    */
475   event Unfreeze ();
476 }