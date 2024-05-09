1 pragma solidity ^0.4.11;
2 
3   /**
4    * Provides methods to safely add, subtract and multiply uint256 numbers.
5    */
6   contract SafeMath {
7     uint256 constant private MAX_UINT256 =
8       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
9 
10     /**
11      * Add two uint256 values, revert in case of overflow.
12      *
13      * @param x first value to add
14      * @param y second value to add
15      * @return x + y
16      */
17     function safeAdd (uint256 x, uint256 y)
18     constant internal
19     returns (uint256 z) {
20       require (x <= MAX_UINT256 - y);
21       return x + y;
22     }
23 
24     /**
25      * Subtract one uint256 value from another, throw in case of underflow.
26      *
27      * @param x value to subtract from
28      * @param y value to subtract
29      * @return x - y
30      */
31     function safeSub (uint256 x, uint256 y)
32     constant internal
33     returns (uint256 z) {
34       require(x >= y);
35       return x - y;
36     }
37 
38     /**
39      * Multiply two uint256 values, throw in case of overflow.
40      *
41      * @param x first value to multiply
42      * @param y second value to multiply
43      * @return x * y
44      */
45     function safeMul (uint256 x, uint256 y)
46     constant internal
47     returns (uint256 z) {
48       if (y == 0) return 0; // Prevent division by zero at the next line
49       require (x <= MAX_UINT256 / y);
50       return x * y;
51     }
52   }
53 
54   /**
55    * ERC-20 standard token interface, as defined
56    * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
57    */
58   contract Token {
59     /**
60      * Get total number of tokens in circulation.
61      *
62      * @return total number of tokens in circulation
63      */
64     function totalSupply () constant returns (uint256 supply);
65 
66     /**
67      * Get number of tokens currently belonging to given owner.
68      *
69      * @param _owner address to get number of tokens currently belonging to the
70      *        owner of
71      * @return number of tokens currently belonging to the owner of given address
72      */
73     function balanceOf (address _owner) constant returns (uint256 balance);
74 
75     /**
76      * Transfer given number of tokens from message sender to given recipient.
77      *
78      * @param _to address to transfer tokens to the owner of
79      * @param _value number of tokens to transfer to the owner of given address
80      * @return true if tokens were transferred successfully, false otherwise
81      */
82     function transfer (address _to, uint256 _value) returns (bool success);
83 
84     /**
85      * Transfer given number of tokens from given owner to given recipient.
86      *
87      * @param _from address to transfer tokens from the owner of
88      * @param _to address to transfer tokens to the owner of
89      * @param _value number of tokens to transfer from given owner to given
90      *        recipient
91      * @return true if tokens were transferred successfully, false otherwise
92      */
93     function transferFrom (address _from, address _to, uint256 _value)
94     returns (bool success);
95 
96     /**
97      * Allow given spender to transfer given number of tokens from message sender.
98      *
99      * @param _spender address to allow the owner of to transfer tokens from
100      *        message sender
101      * @param _value number of tokens to allow to transfer
102      * @return true if token transfer was successfully approved, false otherwise
103      */
104     function approve (address _spender, uint256 _value) returns (bool success);
105 
106     /**
107      * Tell how many tokens given spender is currently allowed to transfer from
108      * given owner.
109      *
110      * @param _owner address to get number of tokens allowed to be transferred
111      *        from the owner of
112      * @param _spender address to get number of tokens allowed to be transferred
113      *        by the owner of
114      * @return number of tokens given spender is currently allowed to transfer
115      *         from given owner
116      */
117     function allowance (address _owner, address _spender) constant
118     returns (uint256 remaining);
119 
120     /**
121      * Logged when tokens were transferred from one owner to another.
122      *
123      * @param _from address of the owner, tokens were transferred from
124      * @param _to address of the owner, tokens were transferred to
125      * @param _value number of tokens transferred
126      */
127     event Transfer (address indexed _from, address indexed _to, uint256 _value);
128 
129     /**
130      * Logged when owner approved his tokens to be transferred by some spender.
131      *
132      * @param _owner owner who approved his tokens to be transferred
133      * @param _spender spender who were allowed to transfer the tokens belonging
134      *        to the owner
135      * @param _value number of tokens belonging to the owner, approved to be
136      *        transferred by the spender
137      */
138     event Approval (
139       address indexed _owner, address indexed _spender, uint256 _value);
140   }
141 
142   /**
143    * Abstract Token Smart Contract that could be used as a base contract for
144    * ERC-20 token contracts.
145    */
146   contract AbstractToken is Token, SafeMath {
147 
148     /**
149      * Address of the fund of this smart contract.
150      */
151     address fund;
152 
153     /**
154      * Create new Abstract Token contract.
155      */
156     function AbstractToken () {
157       // Do nothing
158     }
159 
160 
161     /**
162      * Get number of tokens currently belonging to given owner.
163      *
164      * @param _owner address to get number of tokens currently belonging to the
165      *        owner of
166      * @return number of tokens currently belonging to the owner of given address
167      */
168      function balanceOf (address _owner) constant returns (uint256 balance) {
169       return accounts [_owner];
170     }
171 
172     /**
173      * Transfer given number of tokens from message sender to given recipient.
174      *
175      * @param _to address to transfer tokens to the owner of
176      * @param _value number of tokens to transfer to the owner of given address
177      * @return true if tokens were transferred successfully, false otherwise
178      */
179     function transfer (address _to, uint256 _value) returns (bool success) {
180       uint256 feeTotal = fee();
181 
182       if (accounts [msg.sender] < _value) return false;
183       if (_value > feeTotal && msg.sender != _to) {
184         accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
185         
186         accounts [_to] = safeAdd (accounts [_to], safeSub(_value, feeTotal));
187 
188         processFee(feeTotal);
189 
190         Transfer (msg.sender, _to, safeSub(_value, feeTotal));
191         
192       }
193       return true;
194     }
195 
196     /**
197      * Transfer given number of tokens from given owner to given recipient.
198      *
199      * @param _from address to transfer tokens from the owner of
200      * @param _to address to transfer tokens to the owner of
201      * @param _value number of tokens to transfer from given owner to given
202      *        recipient
203      * @return true if tokens were transferred successfully, false otherwise
204      */
205     function transferFrom (address _from, address _to, uint256 _value)
206     returns (bool success) {
207       uint256 feeTotal = fee();
208 
209       if (allowances [_from][msg.sender] < _value) return false;
210       if (accounts [_from] < _value) return false;
211 
212       allowances [_from][msg.sender] =
213         safeSub (allowances [_from][msg.sender], _value);
214 
215       if (_value > feeTotal && _from != _to) {
216         accounts [_from] = safeSub (accounts [_from], _value);
217 
218         
219         accounts [_to] = safeAdd (accounts [_to], safeSub(_value, feeTotal));
220 
221         processFee(feeTotal);
222 
223         Transfer (_from, _to, safeSub(_value, feeTotal));
224       }
225 
226       return true;
227     }
228 
229     function fee () constant returns (uint256);
230 
231     function processFee(uint256 feeTotal) internal returns (bool);
232 
233     /**
234      * Allow given spender to transfer given number of tokens from message sender.
235      *
236      * @param _spender address to allow the owner of to transfer tokens from
237      *        message sender
238      * @param _value number of tokens to allow to transfer
239      * @return true if token transfer was successfully approved, false otherwise
240      */
241     function approve (address _spender, uint256 _value) returns (bool success) {
242       allowances [msg.sender][_spender] = _value;
243       Approval (msg.sender, _spender, _value);
244 
245       return true;
246     }
247 
248     /**
249      * Tell how many tokens given spender is currently allowed to transfer from
250      * given owner.
251      *
252      * @param _owner address to get number of tokens allowed to be transferred
253      *        from the owner of
254      * @param _spender address to get number of tokens allowed to be transferred
255      *        by the owner of
256      * @return number of tokens given spender is currently allowed to transfer
257      *         from given owner
258      */
259     function allowance (address _owner, address _spender) constant
260     returns (uint256 remaining) {
261       return allowances [_owner][_spender];
262     }
263 
264     /**
265      * Mapping from addresses of token holders to the numbers of tokens belonging
266      * to these token holders.
267      */
268     mapping (address => uint256) accounts;
269 
270     /**
271      * Mapping from addresses of token holders to the mapping of addresses of
272      * spenders to the allowances set by these token holders to these spenders.
273      */
274     mapping (address => mapping (address => uint256)) allowances;
275   }
276 
277   contract ParagonCoinToken is AbstractToken {
278     /**
279      * Initial number of tokens.
280      */
281     uint256 constant INITIAL_TOKENS_COUNT = 200000000e6;
282 
283     /**
284      * Address of the owner of this smart contract.
285      */
286     address owner;
287 
288    
289 
290     /**
291      * Total number of tokens ins circulation.
292      */
293     uint256 tokensCount;
294 
295     /**
296      * Create new ParagonCoin Token Smart Contract, make message sender to be the
297      * owner of smart contract, issue given number of tokens and give them to
298      * message sender.
299      */
300     function ParagonCoinToken (address fundAddress) {
301       tokensCount = INITIAL_TOKENS_COUNT;
302       accounts [msg.sender] = INITIAL_TOKENS_COUNT;
303       owner = msg.sender;
304       fund = fundAddress;
305     }
306 
307     /**
308      * Get name of this token.
309      *
310      * @return name of this token
311      */
312     function name () constant returns (string name) {
313       return "PRG";
314     }
315 
316     /**
317      * Get symbol of this token.
318      *
319      * @return symbol of this token
320      */
321     function symbol () constant returns (string symbol) {
322       return "PRG";
323     }
324 
325 
326     /**
327      * Get number of decimals for this token.
328      *
329      * @return number of decimals for this token
330      */
331     function decimals () constant returns (uint8 decimals) {
332       return 6;
333     }
334 
335     /**
336      * Get total number of tokens in circulation.
337      *
338      * @return total number of tokens in circulation
339      */
340     function totalSupply () constant returns (uint256 supply) {
341       return tokensCount;
342     }
343 
344     
345 
346     /**
347      * Transfer given number of tokens from message sender to given recipient.
348      *
349      * @param _to address to transfer tokens to the owner of
350      * @param _value number of tokens to transfer to the owner of given address
351      * @return true if tokens were transferred successfully, false otherwise
352      */
353     function transfer (address _to, uint256 _value) returns (bool success) {
354       return AbstractToken.transfer (_to, _value);
355     }
356 
357     /**
358      * Transfer given number of tokens from given owner to given recipient.
359      *
360      * @param _from address to transfer tokens from the owner of
361      * @param _to address to transfer tokens to the owner of
362      * @param _value number of tokens to transfer from given owner to given
363      *        recipient
364      * @return true if tokens were transferred successfully, false otherwise
365      */
366     function transferFrom (address _from, address _to, uint256 _value)
367     returns (bool success) {
368       return AbstractToken.transferFrom (_from, _to, _value);
369     }
370 
371     function fee () constant returns (uint256) {
372       return safeAdd(safeMul(tokensCount, 5)/1e11, 25000);
373     }
374 
375     function processFee(uint256 feeTotal) internal returns (bool) {
376         uint256 burnFee = feeTotal/2;
377         uint256 fundFee = safeSub(feeTotal, burnFee);
378 
379         accounts [fund] = safeAdd (accounts [fund], fundFee);
380         tokensCount = safeSub (tokensCount, burnFee); // ledger burned toke
381 
382         Transfer (msg.sender, fund, fundFee);
383 
384         return true;
385     }
386 
387     /**
388      * Change how many tokens given spender is allowed to transfer from message
389      * spender.  In order to prevent double spending of allowance, this method
390      * receives assumed current allowance value as an argument.  If actual
391      * allowance differs from an assumed one, this method just returns false.
392      *
393      * @param _spender address to allow the owner of to transfer tokens from
394      *        message sender
395      * @param _currentValue assumed number of tokens currently allowed to be
396      *        transferred
397      * @param _newValue number of tokens to allow to transfer
398      * @return true if token transfer was successfully approved, false otherwise
399      */
400     function approve (address _spender, uint256 _currentValue, uint256 _newValue)
401     returns (bool success) {
402       if (allowance (msg.sender, _spender) == _currentValue)
403         return approve (_spender, _newValue);
404       else return false;
405     }
406 
407     /**
408      * Burn given number of tokens belonging to message sender.
409      *
410      * @param _value number of tokens to burn
411      * @return true on success, false on error
412      */
413     function burnTokens (uint256 _value) returns (bool success) {
414       if (_value > accounts [msg.sender]) return false;
415       else if (_value > 0) {
416         accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
417         tokensCount = safeSub (tokensCount, _value);
418         return true;
419       } else return true;
420     }
421 
422     /**
423      * Set new owner for the smart contract.
424      * May only be called by smart contract owner.
425      *
426      * @param _newOwner address of new owner of the smart contract
427      */
428     function setOwner (address _newOwner) {
429       require (msg.sender == owner);
430 
431       owner = _newOwner;
432     }
433 
434     
435     /**
436      * Set new fund address for the smart contract.
437      * May only be called by smart contract owner.
438      *
439      * @param _newFund new fund address of the smart contract
440      */
441     function setFundAddress (address _newFund) {
442       require (msg.sender == owner);
443 
444       fund = _newFund;
445     }
446 
447   }