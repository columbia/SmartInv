1 pragma solidity ^0.4.20;
2 
3 /*
4  * Abstract EIP-20 Standard Token Smart Contract Interface.
5  * Copyright © 2016–2018 by ABDK Consulting.
6  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
7  */
8  
9 /**
10  * ERC-20 standard token interface, as defined
11  * <a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md">here</a>.
12  */
13 contract Token {
14   /**
15    * Get total number of tokens in circulation.
16    *
17    * @return total number of tokens in circulation
18    */
19   function totalSupply () public view returns (uint256 supply);
20 
21   /**
22    * Get number of tokens currently belonging to given owner.
23    *
24    * @param _owner address to get number of tokens currently belonging to the
25    *        owner of
26    * @return number of tokens currently belonging to the owner of given address
27    */
28   function balanceOf (address _owner) public view returns (uint256 balance);
29 
30   /**
31    * Transfer given number of tokens from message sender to given recipient.
32    *
33    * @param _to address to transfer tokens to the owner of
34    * @param _value number of tokens to transfer to the owner of given address
35    * @return true if tokens were transferred successfully, false otherwise
36    */
37   function transfer (address _to, uint256 _value)
38   public returns (bool success);
39 
40   /**
41    * Transfer given number of tokens from given owner to given recipient.
42    *
43    * @param _from address to transfer tokens from the owner of
44    * @param _to address to transfer tokens to the owner of
45    * @param _value number of tokens to transfer from given owner to given
46    *        recipient
47    * @return true if tokens were transferred successfully, false otherwise
48    */
49   function transferFrom (address _from, address _to, uint256 _value)
50   public returns (bool success);
51 
52   /**
53    * Allow given spender to transfer given number of tokens from message sender.
54    *
55    * @param _spender address to allow the owner of to transfer tokens from
56    *        message sender
57    * @param _value number of tokens to allow to transfer
58    * @return true if token transfer was successfully approved, false otherwise
59    */
60   function approve (address _spender, uint256 _value)
61   public returns (bool success);
62 
63   /**
64    * Tell how many tokens given spender is currently allowed to transfer from
65    * given owner.
66    *
67    * @param _owner address to get number of tokens allowed to be transferred
68    *        from the owner of
69    * @param _spender address to get number of tokens allowed to be transferred
70    *        by the owner of
71    * @return number of tokens given spender is currently allowed to transfer
72    *         from given owner
73    */
74   function allowance (address _owner, address _spender)
75   public view returns (uint256 remaining);
76 
77   /**
78    * Logged when tokens were transferred from one owner to another.
79    *
80    * @param _from address of the owner, tokens were transferred from
81    * @param _to address of the owner, tokens were transferred to
82    * @param _value number of tokens transferred
83    */
84   event Transfer (address indexed _from, address indexed _to, uint256 _value);
85 
86   /**
87    * Logged when owner approved his tokens to be transferred by some spender.
88    *
89    * @param _owner owner who approved his tokens to be transferred
90    * @param _spender spender who were allowed to transfer the tokens belonging
91    *        to the owner
92    * @param _value number of tokens belonging to the owner, approved to be
93    *        transferred by the spender
94    */
95   event Approval (
96     address indexed _owner, address indexed _spender, uint256 _value);
97 }
98 /*
99  * Safe Math Smart Contract.  Copyright © 2016–2018 by ABDK Consulting.
100  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
101  */
102  
103 /**
104  * Provides methods to safely add, subtract and multiply uint256 numbers.
105  */
106 contract SafeMath {
107   uint256 constant private MAX_UINT256 =
108     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
109 
110   /**
111    * Add two uint256 values, throw in case of overflow.
112    *
113    * @param x first value to add
114    * @param y second value to add
115    * @return x + y
116    */
117   function safeAdd (uint256 x, uint256 y)
118   pure internal
119   returns (uint256 z) {
120     assert (x <= MAX_UINT256 - y);
121     return x + y;
122   }
123 
124   /**
125    * Subtract one uint256 value from another, throw in case of underflow.
126    *
127    * @param x value to subtract from
128    * @param y value to subtract
129    * @return x - y
130    */
131   function safeSub (uint256 x, uint256 y)
132   pure internal
133   returns (uint256 z) {
134     assert (x >= y);
135     return x - y;
136   }
137 
138   /**
139    * Multiply two uint256 values, throw in case of overflow.
140    *
141    * @param x first value to multiply
142    * @param y second value to multiply
143    * @return x * y
144    */
145   function safeMul (uint256 x, uint256 y)
146   pure internal
147   returns (uint256 z) {
148     if (y == 0) return 0; // Prevent division by zero at the next line
149     assert (x <= MAX_UINT256 / y);
150     return x * y;
151   }
152 }
153 
154 
155 /**
156  * Abstract Token Smart Contract that could be used as a base contract for
157  * ERC-20 token contracts.
158  */
159 contract AbstractToken is Token, SafeMath {
160   /**
161    * Create new Abstract Token contract.
162    */
163   function AbstractToken () public {
164     // Do nothing
165   }
166 
167   /**
168    * Get number of tokens currently belonging to given owner.
169    *
170    * @param _owner address to get number of tokens currently belonging to the
171    *        owner of
172    * @return number of tokens currently belonging to the owner of given address
173    */
174   function balanceOf (address _owner) public view returns (uint256 balance) {
175     return accounts [_owner];
176   }
177 
178   /**
179    * Transfer given number of tokens from message sender to given recipient.
180    *
181    * @param _to address to transfer tokens to the owner of
182    * @param _value number of tokens to transfer to the owner of given address
183    * @return true if tokens were transferred successfully, false otherwise
184    */
185   function transfer (address _to, uint256 _value)
186   public returns (bool success) {
187     uint256 fromBalance = accounts [msg.sender];
188     if (fromBalance < _value) return false;
189     if (_value > 0 && msg.sender != _to) {
190       accounts [msg.sender] = safeSub (fromBalance, _value);
191       accounts [_to] = safeAdd (accounts [_to], _value);
192     }
193     Transfer (msg.sender, _to, _value);
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
207   public returns (bool success) {
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
219     }
220     Transfer (_from, _to, _value);
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
232   function approve (address _spender, uint256 _value)
233   public returns (bool success) {
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
251   function allowance (address _owner, address _spender)
252   public view returns (uint256 remaining) {
253     return allowances [_owner][_spender];
254   }
255 
256   /**
257    * Mapping from addresses of token holders to the numbers of tokens belonging
258    * to these token holders.
259    */
260   mapping (address => uint256) internal accounts;
261 
262   /**
263    * Mapping from addresses of token holders to the mapping of addresses of
264    * spenders to the allowances set by these token holders to these spenders.
265    */
266   mapping (address => mapping (address => uint256)) internal allowances;
267 }
268 
269 
270 /**
271  * Morpheus.Network.Multiple token smart contract.
272  */
273 contract MorpheusToken is AbstractToken {
274   /**
275    * Maximum allowed number of tokens in circulation.
276    */
277   uint256 constant MAX_TOKEN_COUNT =
278     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
279 
280   /**
281    * Address of the owner of this smart contract.
282    */
283   address private owner;
284 
285   /**
286    * Current number of tokens in circulation.
287    */
288   uint256 tokenCount = 0;
289 
290   /**
291    * True if tokens transfers are currently frozen, false otherwise.
292    */
293   bool frozen = false;
294 
295   /**
296    * Create new Morpheus.Network.Multiple token smart contract and make msg.sender the
297    * owner of this smart contract.
298    */
299   function MorpheusToken () public {
300     owner = msg.sender;
301   }
302 
303   /**
304    * Get total number of tokens in circulation.
305    *
306    * @return total number of tokens in circulation
307    */
308   function totalSupply () public view returns (uint256 supply) {
309     return tokenCount;
310   }
311 
312   /**
313    * Get name of this token.
314    *
315    * @return name of this token
316    */
317   function name () public pure returns (string result) {
318     return "Morpheus.Network";
319   }
320 
321   /**
322    * Get symbol of this token.
323    *
324    * @return symbol of this token
325    */
326   function symbol () public pure returns (string result) {
327     return "MRPH";
328   }
329 
330   /**
331    * Get number of decimals for this token.
332    *
333    * @return number of decimals for this token
334    */
335   function decimals () public pure returns (uint8 result) {
336     return 4;
337   }
338 
339   /**
340    * Transfer given number of tokens from message sender to given recipient.
341    *
342    * @param _to address to transfer tokens to the owner of
343    * @param _value number of tokens to transfer to the owner of given address
344    * @return true if tokens were transferred successfully, false otherwise
345    */
346   function transfer (address _to, uint256 _value)
347     public returns (bool success) {
348     if (frozen) return false;
349     else return AbstractToken.transfer (_to, _value);
350   }
351 
352   /**
353    * Transfer given number of tokens from given owner to given recipient.
354    *
355    * @param _from address to transfer tokens from the owner of
356    * @param _to address to transfer tokens to the owner of
357    * @param _value number of tokens to transfer from given owner to given
358    *        recipient
359    * @return true if tokens were transferred successfully, false otherwise
360    */
361   function transferFrom (address _from, address _to, uint256 _value)
362     public returns (bool success) {
363     if (frozen) return false;
364     else return AbstractToken.transferFrom (_from, _to, _value);
365   }
366 
367   /**
368    * Change how many tokens given spender is allowed to transfer from message
369    * spender.  In order to prevent double spending of allowance, this method
370    * receives assumed current allowance value as an argument.  If actual
371    * allowance differs from an assumed one, this method just returns false.
372    *
373    * @param _spender address to allow the owner of to transfer tokens from
374    *        message sender
375    * @param _currentValue assumed number of tokens currently allowed to be
376    *        transferred
377    * @param _newValue number of tokens to allow to transfer
378    * @return true if token transfer was successfully approved, false otherwise
379    */
380   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
381     public returns (bool success) {
382     if (allowance (msg.sender, _spender) == _currentValue)
383       return approve (_spender, _newValue);
384     else return false;
385   }
386 
387   /**
388    * Burn given number of tokens belonging to message sender.
389    *
390    * @param _value number of tokens to burn
391    * @return true on success, false on error
392    */
393   function burnTokens (uint256 _value) public returns (bool success) {
394     if (_value > accounts [msg.sender]) return false;
395     else if (_value > 0) {
396       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
397       tokenCount = safeSub (tokenCount, _value);
398 
399       Transfer (msg.sender, address (0), _value);
400       return true;
401     } else return true;
402   }
403 
404   /**
405    * Create _value new tokens and give new created tokens to msg.sender.
406    * May only be called by smart contract owner.
407    *
408    * @param _value number of tokens to create
409    * @return true if tokens were created successfully, false otherwise
410    */
411   function createTokens (uint256 _value)
412     public returns (bool success) {
413     require (msg.sender == owner);
414 
415     if (_value > 0) {
416       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
417       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
418       tokenCount = safeAdd (tokenCount, _value);
419 
420       Transfer (address (0), msg.sender, _value);
421     }
422 
423     return true;
424   }
425 
426   /**
427    * Set new owner for the smart contract.
428    * May only be called by smart contract owner.
429    *
430    * @param _newOwner address of new owner of the smart contract
431    */
432   function setOwner (address _newOwner) public {
433     require (msg.sender == owner);
434 
435     owner = _newOwner;
436   }
437 
438   /**
439    * Freeze token transfers.
440    * May only be called by smart contract owner.
441    */
442   function freezeTransfers () public {
443     require (msg.sender == owner);
444 
445     if (!frozen) {
446       frozen = true;
447       Freeze ();
448     }
449   }
450 
451   /**
452    * Unfreeze token transfers.
453    * May only be called by smart contract owner.
454    */
455   function unfreezeTransfers () public {
456     require (msg.sender == owner);
457 
458     if (frozen) {
459       frozen = false;
460       Unfreeze ();
461     }
462   }
463 
464   /**
465    * Logged when token transfers were frozen.
466    */
467   event Freeze ();
468 
469   /**
470    * Logged when token transfers were unfrozen.
471    */
472   event Unfreeze ();
473 }