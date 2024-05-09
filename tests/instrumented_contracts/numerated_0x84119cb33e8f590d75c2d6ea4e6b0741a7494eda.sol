1 /*
2  * Giga Watt Token Smart Contract.  Copyright © 2016 by ABDK Consulting.
3  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
4  */
5 pragma solidity ^0.4.1;
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
23             owner of
24    * @return number of tokens currently belonging to the owner of given address
25    */
26   function balanceOf (address _owner) constant returns (uint256 balance);
27 
28   /**
29    * Transfer given number of tokens from message sender to given recipient.
30    *
31    * @param _to address to transfer tokens from the owner of
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
43             recipient
44    * @return true if tokens were transferred successfully, false otherwise
45    */
46   function transferFrom (address _from, address _to, uint256 _value)
47   returns (bool success);
48 
49   /**
50    * Allow given spender to transfer given number of tokens from message sender.
51    *
52    * @param _spender address to allow the owner of to transfer tokens from
53             message sender
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
70   function allowance (address _owner, address _spender)
71   constant returns (uint256 remaining);
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
95 /**
96  * Provides methods to safely add, subtract and multiply uint256 numbers.
97  */
98 contract SafeMath {
99   uint256 constant private MAX_UINT256 =
100     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
101 
102   /**
103    * Add two uint256 values, throw in case of overflow.
104    *
105    * @param x first value to add
106    * @param y second value to add
107    * @return x + y
108    */
109   function safeAdd (uint256 x, uint256 y)
110   constant internal
111   returns (uint256 z) {
112     if (x > MAX_UINT256 - y) throw;
113     return x + y;
114   }
115 
116   /**
117    * Subtract one uint256 value from another, throw in case of underflow.
118    *
119    * @param x value to subtract from
120    * @param y value to subtract
121    * @return x - y
122    */
123   function safeSub (uint256 x, uint256 y)
124   constant internal
125   returns (uint256 z) {
126     if (x < y) throw;
127     return x - y;
128   }
129 
130   /**
131    * Multiply two uint256 values, throw in case of overflow.
132    *
133    * @param x first value to multiply
134    * @param y second value to multiply
135    * @return x * y
136    */
137   function safeMul (uint256 x, uint256 y)
138   constant internal
139   returns (uint256 z) {
140     if (y == 0) return 0; // Prevent division by zero at the next line
141     if (x > MAX_UINT256 / y) throw;
142     return x * y;
143   }
144 }
145 
146 /**
147  * Abstract base contract for contracts implementing Token interface.
148  */
149 contract AbstractToken is Token, SafeMath {
150   /**
151    * Get total number of tokens in circulation.
152    *
153    * @return total number of tokens in circulation
154    */
155   function totalSupply () constant returns (uint256 supply) {
156     return tokensCount;
157   }
158 
159   /**
160    * Get number of tokens currently belonging to given owner.
161    *
162    * @param _owner address to get number of tokens currently belonging to the
163             owner of
164    * @return number of tokens currently belonging to the owner of given address
165    */
166   function balanceOf (address _owner) constant returns (uint256 balance) {
167     return accounts [_owner];
168   }
169 
170   /**
171    * Transfer given number of tokens from message sender to given recipient.
172    *
173    * @param _to address to transfer tokens from the owner of
174    * @param _value number of tokens to transfer to the owner of given address
175    * @return true if tokens were transferred successfully, false otherwise
176    */
177   function transfer (address _to, uint256 _value) returns (bool success) {
178     return doTransfer (msg.sender, _to, _value);
179   }
180 
181   /**
182    * Transfer given number of tokens from given owner to given recipient.
183    *
184    * @param _from address to transfer tokens from the owner of
185    * @param _to address to transfer tokens to the owner of
186    * @param _value number of tokens to transfer from given owner to given
187             recipient
188    * @return true if tokens were transferred successfully, false otherwise
189    */
190   function transferFrom (address _from, address _to, uint256 _value)
191   returns (bool success)
192   {
193     if (_value > approved [_from][msg.sender]) return false;
194     if (doTransfer (_from, _to, _value)) {
195       approved [_from][msg.sender] =
196         safeSub (approved[_from][msg.sender], _value);
197       return true;
198     } else return false;
199   }
200 
201   /**
202    * Allow given spender to transfer given number of tokens from message sender.
203    *
204    * @param _spender address to allow the owner of to transfer tokens from
205             message sender
206    * @param _value number of tokens to allow to transfer
207    * @return true if token transfer was successfully approved, false otherwise
208    */
209   function approve (address _spender, uint256 _value) returns (bool success) {
210     approved [msg.sender][_spender] = _value;
211     Approval (msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * Tell how many tokens given spender is currently allowed to transfer from
217    * given owner.
218    *
219    * @param _owner address to get number of tokens allowed to be transferred
220    *        from the owner of
221    * @param _spender address to get number of tokens allowed to be transferred
222    *        by the owner of
223    * @return number of tokens given spender is currently allowed to transfer
224    *         from given owner
225    */
226   function allowance (address _owner, address _spender)
227   constant returns (uint256 remaining) {
228     return approved [_owner][_spender];
229   }
230 
231   /**
232    * Create given number of new tokens and give them to given owner.
233    *
234    * @param _owner address to given new created tokens to the owner of
235    * @param _value number of new tokens to create
236    */
237   function createTokens (address _owner, uint256 _value) internal {
238     if (_value > 0) {
239       accounts [_owner] = safeAdd (accounts [_owner], _value);
240       tokensCount = safeAdd (tokensCount, _value);
241     }
242   }
243 
244   /**
245    * Perform token transfer.
246    *
247    * @param _from address to transfer tokens from the owner of
248    * @param _to address to transfer tokens to to the owner of
249    * @param _value number of tokens to transfer
250    * @return true if tokens were transferred successfully, false otherwise
251    */
252   function doTransfer (address _from, address _to, uint256 _value)
253   private returns (bool success) {
254     if (_value > accounts [_from]) return false;
255     if (_value > 0 && _from != _to) {
256       accounts [_from] = safeSub (accounts [_from], _value);
257       accounts [_to] = safeAdd (accounts [_to], _value);
258       Transfer (_from, _to, _value);
259     }
260     return true;
261   }
262 
263   /**
264    * Total number of tokens in circulation.
265    */
266   uint256 tokensCount;
267 
268   /**
269    * Maps addresses of token owners to states of their accounts.
270    */
271   mapping (address => uint256) accounts;
272 
273   /**
274    * Maps addresses of token owners to mappings from addresses of spenders to
275    * how many tokens belonging to the owner, the spender is currently allowed to
276    * transfer.
277    */
278   mapping (address => mapping (address => uint256)) approved;
279 }
280 
281 /**
282  * Standard Token smart contract that provides the following features:
283  * <ol>
284  *   <li>Centralized creation of new tokens</li> 
285  *   <li>Freeze/unfreeze token transfers</li>
286  *   <li>Change owner</li>
287  * </ol>
288  */
289 contract StandardToken is AbstractToken {
290   /**
291    * Maximum allowed tokens in circulation (2^64 - 1).
292    */
293   uint256 constant private MAX_TOKENS = 0xFFFFFFFFFFFFFFFF;
294 
295   /**
296    * Address of the owner of the contract.
297    */
298   address owner;
299 
300   /**
301    * Whether transfers are currently frozen.
302    */
303   bool frozen;
304 
305   /**
306    * Instantiate the contract and make the message sender to be the owner.
307    */
308   function StandardToken () {
309     owner = msg.sender;
310   }
311 
312   /**
313    * Transfer given number of tokens from message sender to given recipient.
314    *
315    * @param _to address to transfer tokens from the owner of
316    * @param _value number of tokens to transfer to the owner of given address
317    * @return true if tokens were transferred successfully, false otherwise
318    */
319   function transfer (address _to, uint256 _value)
320   returns (bool success) {
321     if (frozen) return false;
322     else return AbstractToken.transfer (_to, _value);
323   }
324 
325   /**
326    * Transfer given number of tokens from given owner to given recipient.
327    *
328    * @param _from address to transfer tokens from the owner of
329    * @param _to address to transfer tokens to the owner of
330    * @param _value number of tokens to transfer from given owner to given
331             recipient
332    * @return true if tokens were transferred successfully, false otherwise
333    */
334   function transferFrom (address _from, address _to, uint256 _value)
335   returns (bool success) {
336     if (frozen) return false;
337     else return AbstractToken.transferFrom (_from, _to, _value);
338   }
339 
340   /**
341    * Create certain number of new tokens and give them to the owner of the
342    * contract.
343    * 
344    * @param _value number of new tokens to create
345    * @return true if tokens were created successfully, false otherwise
346    */
347   function createTokens (uint256 _value)
348   returns (bool success) {
349     if (msg.sender != owner) throw;
350 
351     if (_value > MAX_TOKENS - totalSupply ()) return false;
352 
353     AbstractToken.createTokens (owner, _value);
354 
355     return true;
356   }
357 
358   /**
359    * Freeze token transfers.
360    */
361   function freezeTransfers () {
362     if (msg.sender != owner) throw;
363 
364     if (!frozen)
365     {
366       frozen = true;
367       Freeze ();
368     }
369   }
370 
371   /**
372    * Unfreeze token transfers.
373    */
374   function unfreezeTransfers () {
375     if (msg.sender != owner) throw;
376 
377     if (frozen) {
378       frozen = false;
379       Unfreeze ();
380     }
381   }
382 
383   /**
384    * Set new owner address.
385    *
386    * @param _newOwner new owner address
387    */
388   function setOwner (address _newOwner) {
389     if (msg.sender != owner) throw;
390 
391     owner = _newOwner;
392   }
393 
394   /**
395    * Logged when token transfers were freezed.
396    */
397   event Freeze ();
398 
399   /**
400    * Logged when token transfers were unfreezed.
401    */
402   event Unfreeze ();
403 }
404 
405 /**
406  * Giga Watt Token Smart Contract.
407  */
408 contract GigaWattToken is StandardToken {
409   /**
410    * Constructor just calls constructor of parent contract.
411    */
412   function GigaWattToken () StandardToken () {
413     // Do nothing
414   }
415 }