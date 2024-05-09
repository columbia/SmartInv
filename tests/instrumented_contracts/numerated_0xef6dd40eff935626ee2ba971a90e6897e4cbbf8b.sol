1 /*
2  * Blockchain Capital Token Smart Contract.  Copyright © 2017 by ABDK
3  * Consulting.  
4  */
5 
6 /*
7  * ERC-20 Standard Token Smart Contract Interface.
8  * Copyright © 2016 by ABDK Consulting.
9  */
10 pragma solidity ^0.4.1;
11 
12 /**
13  * ERC-20 standard token interface, as defined
14  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
15  */
16 contract Token {
17   /**
18    * Get total number of tokens in circulation.
19    *
20    * @return total number of tokens in circulation
21    */
22   function totalSupply () constant returns (uint256 supply);
23 
24   /**
25    * Get number of tokens currently belonging to given owner.
26    *
27    * @param _owner address to get number of tokens currently belonging to the
28             owner of
29    * @return number of tokens currently belonging to the owner of given address
30    */
31   function balanceOf (address _owner) constant returns (uint256 balance);
32 
33   /**
34    * Transfer given number of tokens from message sender to given recipient.
35    *
36    * @param _to address to transfer tokens to the owner of
37    * @param _value number of tokens to transfer to the owner of given address
38    * @return true if tokens were transferred successfully, false otherwise
39    */
40   function transfer (address _to, uint256 _value) returns (bool success);
41 
42   /**
43    * Transfer given number of tokens from given owner to given recipient.
44    *
45    * @param _from address to transfer tokens from the owner of
46    * @param _to address to transfer tokens to the owner of
47    * @param _value number of tokens to transfer from given owner to given
48             recipient
49    * @return true if tokens were transferred successfully, false otherwise
50    */
51   function transferFrom (address _from, address _to, uint256 _value)
52   returns (bool success);
53 
54   /**
55    * Allow given spender to transfer given number of tokens from message sender.
56    *
57    * @param _spender address to allow the owner of to transfer tokens from
58             message sender
59    * @param _value number of tokens to allow to transfer
60    * @return true if token transfer was successfully approved, false otherwise
61    */
62   function approve (address _spender, uint256 _value) returns (bool success);
63 
64   /**
65    * Tell how many tokens given spender is currently allowed to transfer from
66    * given owner.
67    *
68    * @param _owner address to get number of tokens allowed to be transferred
69    *        from the owner of
70    * @param _spender address to get number of tokens allowed to be transferred
71    *        by the owner of
72    * @return number of tokens given spender is currently allowed to transfer
73    *         from given owner
74    */
75   function allowance (address _owner, address _spender) constant
76   returns (uint256 remaining);
77 
78   /**
79    * Logged when tokens were transferred from one owner to another.
80    *
81    * @param _from address of the owner, tokens were transferred from
82    * @param _to address of the owner, tokens were transferred to
83    * @param _value number of tokens transferred
84    */
85   event Transfer (address indexed _from, address indexed _to, uint256 _value);
86 
87   /**
88    * Logged when owner approved his tokens to be transferred by some spender.
89    *
90    * @param _owner owner who approved his tokens to be transferred
91    * @param _spender spender who were allowed to transfer the tokens belonging
92    *        to the owner
93    * @param _value number of tokens belonging to the owner, approved to be
94    *        transferred by the spender
95    */
96   event Approval (
97     address indexed _owner, address indexed _spender, uint256 _value);
98 }
99 
100 /*
101  * Safe Math Smart Contract.  Copyright © 2016 by ABDK Consulting.
102  */
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
118   constant internal
119   returns (uint256 z) {
120     if (x > MAX_UINT256 - y) throw;
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
132   constant internal
133   returns (uint256 z) {
134     if (x < y) throw;
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
146   constant internal
147   returns (uint256 z) {
148     if (y == 0) return 0; // Prevent division by zero at the next line
149     if (x > MAX_UINT256 / y) throw;
150     return x * y;
151   }
152 }
153 
154 /*
155  * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
156  */
157 
158 /**
159  * Abstract Token Smart Contract that could be used as a base contract for
160  * ERC-20 token contracts.
161  */
162 contract AbstractToken is Token, SafeMath {
163   /**
164    * Create new Abstract Token contract.
165    */
166   function AbstractToken () {
167     // Do nothing
168   }
169 
170   /**
171    * Get number of tokens currently belonging to given owner.
172    *
173    * @param _owner address to get number of tokens currently belonging to the
174             owner of
175    * @return number of tokens currently belonging to the owner of given address
176    */
177   function balanceOf (address _owner) constant returns (uint256 balance) {
178     return accounts [_owner];
179   }
180 
181   /**
182    * Transfer given number of tokens from message sender to given recipient.
183    *
184    * @param _to address to transfer tokens to the owner of
185    * @param _value number of tokens to transfer to the owner of given address
186    * @return true if tokens were transferred successfully, false otherwise
187    */
188   function transfer (address _to, uint256 _value) returns (bool success) {
189     if (accounts [msg.sender] < _value) return false;
190     if (_value > 0 && msg.sender != _to) {
191       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
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
204             recipient
205    * @return true if tokens were transferred successfully, false otherwise
206    */
207   function transferFrom (address _from, address _to, uint256 _value)
208   returns (bool success) {
209     if (allowances [_from][msg.sender] < _value) return false;
210     if (accounts [_from] < _value) return false;
211 
212     allowances [_from][msg.sender] =
213       safeSub (allowances [_from][msg.sender], _value);
214 
215     if (_value > 0 && _from != _to) {
216       accounts [_from] = safeSub (accounts [_from], _value);
217       accounts [_to] = safeAdd (accounts [_to], _value);
218       Transfer (_from, _to, _value);
219     }
220     return true;
221   }
222 
223   /**
224    * Allow given spender to transfer given number of tokens from message sender.
225    *
226    * @param _spender address to allow the owner of to transfer tokens from
227             message sender
228    * @param _value number of tokens to allow to transfer
229    * @return true if token transfer was successfully approved, false otherwise
230    */
231   function approve (address _spender, uint256 _value) returns (bool success) {
232     allowances [msg.sender][_spender] = _value;
233     Approval (msg.sender, _spender, _value);
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
249   function allowance (address _owner, address _spender) constant
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
261    * Mapping from addresses of token holders to the mapping of addresses of
262    * spenders to the allowances set by these token holders to these spenders.
263    */
264   mapping (address => mapping (address => uint256)) private allowances;
265 }
266 
267 
268 /*
269  * Standard Token Smart Contract.  Copyright © 2016 by ABDK Consulting.
270  */
271 
272 
273 /**
274  * Standard Token Smart Contract that implements ERC-20 token with special
275  * unlimited supply "token issuer" account.
276  */
277 contract StandardToken is AbstractToken {
278   uint256 constant private MAX_UINT256 =
279     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
280 
281   /**
282    * Create new Standard Token contract with given "token issuer" account.
283    *
284    * @param _tokenIssuer address of "token issuer" account
285    */
286   function StandardToken (address _tokenIssuer) AbstractToken () {
287     tokenIssuer = _tokenIssuer;
288     accounts [_tokenIssuer] = MAX_UINT256;
289   }
290 
291   /**
292    * Get total number of tokens in circulation.
293    *
294    * @return total number of tokens in circulation
295    */
296   function totalSupply () constant returns (uint256 supply) {
297     return safeSub (MAX_UINT256, accounts [tokenIssuer]);
298   }
299 
300   /**
301    * Get number of tokens currently belonging to given owner.
302    *
303    * @param _owner address to get number of tokens currently belonging to the
304             owner of
305    * @return number of tokens currently belonging to the owner of given address
306    */
307   function balanceOf (address _owner) constant returns (uint256 balance) {
308     return _owner == tokenIssuer ? 0 : AbstractToken.balanceOf (_owner);
309   }
310 
311   /**
312    * Address of "token issuer" account.
313    */
314   address private tokenIssuer;
315 }
316 
317 /**
318  * Blockchain Capital Token Smart Contract.
319  */
320 contract BCAPToken is StandardToken {
321   /**
322    * Create new Blockchain Capital Token contract with given token issuer
323    * address.
324    *
325    * @param _tokenIssuer address of token issuer
326    */
327   function BCAPToken (address _tokenIssuer)
328     StandardToken (_tokenIssuer) {
329     owner = _tokenIssuer;
330   }
331 
332   /**
333    * Freeze token transfers.
334    */
335   function freezeTransfers () {
336     if (msg.sender != owner) throw;
337 
338     if (!transfersFrozen) {
339       transfersFrozen = true;
340       Freeze ();
341     }
342   }
343 
344   /**
345    * Unfreeze token transfers.
346    */
347   function unfreezeTransfers () {
348     if (msg.sender != owner) throw;
349 
350     if (transfersFrozen) {
351       transfersFrozen = false;
352       Unfreeze ();
353     }
354   }
355 
356   /**
357    * Transfer given number of tokens from message sender to given recipient.
358    *
359    * @param _to address to transfer tokens to the owner of
360    * @param _value number of tokens to transfer to the owner of given address
361    * @return true if tokens were transferred successfully, false otherwise
362    */
363   function transfer (address _to, uint256 _value) returns (bool success) {
364     if (transfersFrozen) return false;
365     else return AbstractToken.transfer (_to, _value);
366   }
367 
368   /**
369    * Transfer given number of tokens from given owner to given recipient.
370    *
371    * @param _from address to transfer tokens from the owner of
372    * @param _to address to transfer tokens to the owner of
373    * @param _value number of tokens to transfer from given owner to given
374             recipient
375    * @return true if tokens were transferred successfully, false otherwise
376    */
377   function transferFrom (address _from, address _to, uint256 _value)
378   returns (bool success) {
379     if (transfersFrozen) return false;
380     else return AbstractToken.transferFrom (_from, _to, _value);
381   }
382 
383   /**
384    * Logged when transfers were frozen.
385    */
386   event Freeze ();
387 
388   /**
389    * Logged when transfers were unfrozen.
390    */
391   event Unfreeze ();
392 
393   /**
394    * Address of the owner of smart contract.  Only owner is allowed to
395    * freeze/unfreeze transfers.
396    */
397   address owner;
398 
399   /**
400    * Whether transfers are currently frozen or not.
401    */
402   bool transfersFrozen = false;
403 }