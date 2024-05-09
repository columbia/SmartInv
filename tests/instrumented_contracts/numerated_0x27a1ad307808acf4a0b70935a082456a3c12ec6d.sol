1 pragma solidity ^0.4.20;
2 /*
3  * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
4  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
5  */
6 
7 /*
8  * EIP-20 Standard Token Smart Contract Interface.
9  * Copyright © 2016–2018 by ABDK Consulting.
10  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
11  */
12 
13 /**
14  * ERC-20 standard token interface, as defined
15  * <a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md">here</a>.
16  */
17 contract Token {
18   /**
19    * Get total number of tokens in circulation.
20    *
21    * @return total number of tokens in circulation
22    */
23   function totalSupply () public view returns (uint256 supply);
24 
25   /**
26    * Get number of tokens currently belonging to given owner.
27    *
28    * @param _owner address to get number of tokens currently belonging to the
29    *        owner of
30    * @return number of tokens currently belonging to the owner of given address
31    */
32   function balanceOf (address _owner) public view returns (uint256 balance);
33 
34   /**
35    * Transfer given number of tokens from message sender to given recipient.
36    *
37    * @param _to address to transfer tokens to the owner of
38    * @param _value number of tokens to transfer to the owner of given address
39    * @return true if tokens were transferred successfully, false otherwise
40    */
41   function transfer (address _to, uint256 _value)
42   public returns (bool success);
43 
44   /**
45    * Transfer given number of tokens from given owner to given recipient.
46    *
47    * @param _from address to transfer tokens from the owner of
48    * @param _to address to transfer tokens to the owner of
49    * @param _value number of tokens to transfer from given owner to given
50    *        recipient
51    * @return true if tokens were transferred successfully, false otherwise
52    */
53   function transferFrom (address _from, address _to, uint256 _value)
54   public returns (bool success);
55 
56   /**
57    * Allow given spender to transfer given number of tokens from message sender.
58    *
59    * @param _spender address to allow the owner of to transfer tokens from
60    *        message sender
61    * @param _value number of tokens to allow to transfer
62    * @return true if token transfer was successfully approved, false otherwise
63    */
64   function approve (address _spender, uint256 _value)
65   public returns (bool success);
66 
67   /**
68    * Tell how many tokens given spender is currently allowed to transfer from
69    * given owner.
70    *
71    * @param _owner address to get number of tokens allowed to be transferred
72    *        from the owner of
73    * @param _spender address to get number of tokens allowed to be transferred
74    *        by the owner of
75    * @return number of tokens given spender is currently allowed to transfer
76    *         from given owner
77    */
78   function allowance (address _owner, address _spender)
79   public view returns (uint256 remaining);
80 
81   /**
82    * Logged when tokens were transferred from one owner to another.
83    *
84    * @param _from address of the owner, tokens were transferred from
85    * @param _to address of the owner, tokens were transferred to
86    * @param _value number of tokens transferred
87    */
88   event Transfer (address indexed _from, address indexed _to, uint256 _value);
89 
90   /**
91    * Logged when owner approved his tokens to be transferred by some spender.
92    *
93    * @param _owner owner who approved his tokens to be transferred
94    * @param _spender spender who were allowed to transfer the tokens belonging
95    *        to the owner
96    * @param _value number of tokens belonging to the owner, approved to be
97    *        transferred by the spender
98    */
99   event Approval (
100     address indexed _owner, address indexed _spender, uint256 _value);
101 }
102 /*
103  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
104  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
105  */
106 
107 /**
108  * Provides methods to safely add, subtract and multiply uint256 numbers.
109  */
110 contract SafeMath {
111   uint256 constant private MAX_UINT256 =
112     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
113 
114   /**
115    * Add two uint256 values, throw in case of overflow.
116    *
117    * @param x first value to add
118    * @param y second value to add
119    * @return x + y
120    */
121   function safeAdd (uint256 x, uint256 y)
122   pure internal
123   returns (uint256 z) {
124     assert (x <= MAX_UINT256 - y);
125     return x + y;
126   }
127 
128   /**
129    * Subtract one uint256 value from another, throw in case of underflow.
130    *
131    * @param x value to subtract from
132    * @param y value to subtract
133    * @return x - y
134    */
135   function safeSub (uint256 x, uint256 y)
136   pure internal
137   returns (uint256 z) {
138     assert (x >= y);
139     return x - y;
140   }
141 
142   /**
143    * Multiply two uint256 values, throw in case of overflow.
144    *
145    * @param x first value to multiply
146    * @param y second value to multiply
147    * @return x * y
148    */
149   function safeMul (uint256 x, uint256 y)
150   pure internal
151   returns (uint256 z) {
152     if (y == 0) return 0; // Prevent division by zero at the next line
153     assert (x <= MAX_UINT256 / y);
154     return x * y;
155   }
156 }
157 
158 
159 /**
160  * Abstract Token Smart Contract that could be used as a base contract for
161  * ERC-20 token contracts.
162  */
163 contract AbstractToken is Token, SafeMath {
164   /**
165    * Create new Abstract Token contract.
166    */
167   function AbstractToken () public {
168     // Do nothing
169   }
170 
171   /**
172    * Get number of tokens currently belonging to given owner.
173    *
174    * @param _owner address to get number of tokens currently belonging to the
175    *        owner of
176    * @return number of tokens currently belonging to the owner of given address
177    */
178   function balanceOf (address _owner) public view returns (uint256 balance) {
179     return accounts [_owner];
180   }
181 
182   /**
183    * Transfer given number of tokens from message sender to given recipient.
184    *
185    * @param _to address to transfer tokens to the owner of
186    * @param _value number of tokens to transfer to the owner of given address
187    * @return true if tokens were transferred successfully, false otherwise
188    */
189   function transfer (address _to, uint256 _value)
190   public returns (bool success) {
191     uint256 fromBalance = accounts [msg.sender];
192     if (fromBalance < _value) return false;
193     if (_value > 0 && msg.sender != _to) {
194       accounts [msg.sender] = safeSub (fromBalance, _value);
195       accounts [_to] = safeAdd (accounts [_to], _value);
196     }
197     Transfer (msg.sender, _to, _value);
198     return true;
199   }
200 
201   /**
202    * Transfer given number of tokens from given owner to given recipient.
203    *
204    * @param _from address to transfer tokens from the owner of
205    * @param _to address to transfer tokens to the owner of
206    * @param _value number of tokens to transfer from given owner to given
207    *        recipient
208    * @return true if tokens were transferred successfully, false otherwise
209    */
210   function transferFrom (address _from, address _to, uint256 _value)
211   public returns (bool success) {
212     uint256 spenderAllowance = allowances [_from][msg.sender];
213     if (spenderAllowance < _value) return false;
214     uint256 fromBalance = accounts [_from];
215     if (fromBalance < _value) return false;
216 
217     allowances [_from][msg.sender] =
218       safeSub (spenderAllowance, _value);
219 
220     if (_value > 0 && _from != _to) {
221       accounts [_from] = safeSub (fromBalance, _value);
222       accounts [_to] = safeAdd (accounts [_to], _value);
223     }
224     Transfer (_from, _to, _value);
225     return true;
226   }
227 
228   /**
229    * Allow given spender to transfer given number of tokens from message sender.
230    *
231    * @param _spender address to allow the owner of to transfer tokens from
232    *        message sender
233    * @param _value number of tokens to allow to transfer
234    * @return true if token transfer was successfully approved, false otherwise
235    */
236   function approve (address _spender, uint256 _value)
237   public returns (bool success) {
238     allowances [msg.sender][_spender] = _value;
239     Approval (msg.sender, _spender, _value);
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
255   function allowance (address _owner, address _spender)
256   public view returns (uint256 remaining) {
257     return allowances [_owner][_spender];
258   }
259 
260   /**
261    * Mapping from addresses of token holders to the numbers of tokens belonging
262    * to these token holders.
263    */
264   mapping (address => uint256) internal accounts;
265 
266   /**
267    * Mapping from addresses of token holders to the mapping of addresses of
268    * spenders to the allowances set by these token holders to these spenders.
269    */
270   mapping (address => mapping (address => uint256)) internal allowances;
271 }
272 
273 
274 /**
275  * Catena token smart contract.
276  */
277 contract CatenaToken is AbstractToken {
278   /**
279    * Address of the owner of this smart contract.
280    */
281   address private owner;
282 
283   /**
284    * Total number of tokens in circulation.
285    */
286   uint256 tokenCount;
287 
288   /**
289    * True if tokens transfers are currently frozen, false otherwise.
290    */
291   bool frozen = false;
292 
293   /**
294    * Create new Catena token smart contract, with given number of tokens issued
295    * and given to msg.sender, and make msg.sender the owner of this smart
296    * contract.
297    *
298    * @param _tokenCount number of tokens to issue and give to msg.sender
299    */
300   function CatenaToken (uint256 _tokenCount) public {
301     owner = msg.sender;
302     tokenCount = _tokenCount;
303     accounts [msg.sender] = _tokenCount;
304   }
305 
306   /**
307    * Get total number of tokens in circulation.
308    *
309    * @return total number of tokens in circulation
310    */
311   function totalSupply () public view returns (uint256 supply) {
312     return tokenCount;
313   }
314 
315   /**
316    * Get name of this token.
317    *
318    * @return name of this token
319    */
320   function name () public pure returns (string result) {
321     return "CATOKN";
322   }
323 
324   /**
325    * Get symbol of this token.
326    *
327    * @return symbol of this token
328    */
329   function symbol () public pure returns (string result) {
330     return "CATOKN";
331   }
332 
333   /**
334    * Get number of decimals for this token.
335    *
336    * @return number of decimals for this token
337    */
338   function decimals () public pure returns (uint8 result) {
339     return 18;
340   }
341 
342   /**
343    * Transfer given number of tokens from message sender to given recipient.
344    *
345    * @param _to address to transfer tokens to the owner of
346    * @param _value number of tokens to transfer to the owner of given address
347    * @return true if tokens were transferred successfully, false otherwise
348    */
349   function transfer (address _to, uint256 _value)
350     public returns (bool success) {
351     if (frozen) return false;
352     else return AbstractToken.transfer (_to, _value);
353   }
354 
355   /**
356    * Transfer given number of tokens from given owner to given recipient.
357    *
358    * @param _from address to transfer tokens from the owner of
359    * @param _to address to transfer tokens to the owner of
360    * @param _value number of tokens to transfer from given owner to given
361    *        recipient
362    * @return true if tokens were transferred successfully, false otherwise
363    */
364   function transferFrom (address _from, address _to, uint256 _value)
365     public returns (bool success) {
366     if (frozen) return false;
367     else return AbstractToken.transferFrom (_from, _to, _value);
368   }
369 
370   /**
371    * Change how many tokens given spender is allowed to transfer from message
372    * spender.  In order to prevent double spending of allowance, this method
373    * receives assumed current allowance value as an argument.  If actual
374    * allowance differs from an assumed one, this method just returns false.
375    *
376    * @param _spender address to allow the owner of to transfer tokens from
377    *        message sender
378    * @param _currentValue assumed number of tokens currently allowed to be
379    *        transferred
380    * @param _newValue number of tokens to allow to transfer
381    * @return true if token transfer was successfully approved, false otherwise
382    */
383   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
384     public returns (bool success) {
385     if (allowance (msg.sender, _spender) == _currentValue)
386       return approve (_spender, _newValue);
387     else return false;
388   }
389 
390   /**
391    * Burn given number of tokens belonging to message sender.
392    *
393    * @param _value number of tokens to burn
394    * @return true on success, false on error
395    */
396   function burnTokens (uint256 _value) public returns (bool success) {
397     if (_value > accounts [msg.sender]) return false;
398     else if (_value > 0) {
399       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
400       tokenCount = safeSub (tokenCount, _value);
401 
402       Transfer (msg.sender, address (0), _value);
403       return true;
404     } else return true;
405   }
406 
407   /**
408    * Set new owner for the smart contract.
409    * May only be called by smart contract owner.
410    *
411    * @param _newOwner address of new owner of the smart contract
412    */
413   function setOwner (address _newOwner) public {
414     require (msg.sender == owner);
415 
416     owner = _newOwner;
417   }
418 
419   /**
420    * Freeze token transfers.
421    * May only be called by smart contract owner.
422    */
423   function freezeTransfers () public {
424     require (msg.sender == owner);
425 
426     if (!frozen) {
427       frozen = true;
428       Freeze ();
429     }
430   }
431 
432   /**
433    * Unfreeze token transfers.
434    * May only be called by smart contract owner.
435    */
436   function unfreezeTransfers () public {
437     require (msg.sender == owner);
438 
439     if (frozen) {
440       frozen = false;
441       Unfreeze ();
442     }
443   }
444 
445   /**
446    * Logged when token transfers were frozen.
447    */
448   event Freeze ();
449 
450   /**
451    * Logged when token transfers were unfrozen.
452    */
453   event Unfreeze ();
454 }