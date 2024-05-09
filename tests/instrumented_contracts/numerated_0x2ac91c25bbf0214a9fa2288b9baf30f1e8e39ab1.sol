1 pragma solidity ^0.4.15;
2 
3 contract InputValidator {
4 
5     /**
6      * ERC20 Short Address Attack fix
7      */
8     modifier safe_arguments(uint _numArgs) {
9         assert(msg.data.length == _numArgs * 32 + 4);
10         _;
11     }
12 }
13 
14 contract Owned {
15 
16     // The address of the account that is the current owner 
17     address internal owner;
18 
19 
20     /**
21      * The publisher is the inital owner
22      */
23     function Owned() {
24         owner = msg.sender;
25     }
26 
27 
28     /**
29      * Access is restricted to the current owner
30      */
31     modifier only_owner() {
32         require(msg.sender == owner);
33 
34         _;
35     }
36 }
37 
38 contract IOwnership {
39 
40     /**
41      * Returns true if `_account` is the current owner
42      *
43      * @param _account The address to test against
44      */
45     function isOwner(address _account) constant returns (bool);
46 
47 
48     /**
49      * Gets the current owner
50      *
51      * @return address The current owner
52      */
53     function getOwner() constant returns (address);
54 }
55 
56 contract Ownership is IOwnership, Owned {
57 
58 
59     /**
60      * Returns true if `_account` is the current owner
61      *
62      * @param _account The address to test against
63      */
64     function isOwner(address _account) public constant returns (bool) {
65         return _account == owner;
66     }
67 
68 
69     /**
70      * Gets the current owner
71      *
72      * @return address The current owner
73      */
74     function getOwner() public constant returns (address) {
75         return owner;
76     }
77 }
78 
79 contract ITransferableOwnership {
80 
81     /**
82      * Transfer ownership to `_newOwner`
83      *
84      * @param _newOwner The address of the account that will become the new owner 
85      */
86     function transferOwnership(address _newOwner);
87 }
88 
89 contract TransferableOwnership is ITransferableOwnership, Ownership {
90 
91 
92     /**
93      * Transfer ownership to `_newOwner`
94      *
95      * @param _newOwner The address of the account that will become the new owner 
96      */
97     function transferOwnership(address _newOwner) public only_owner {
98         owner = _newOwner;
99     }
100 }
101 
102 
103 /**
104  * @title ERC20 compatible token interface
105  *
106  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
107  * - Short address attack fix
108  *
109  * #created 29/09/2017
110  * #author Frank Bonnet
111  */
112 contract IToken { 
113 
114     /** 
115      * Get the total supply of tokens
116      * 
117      * @return The total supply
118      */
119     function totalSupply() constant returns (uint);
120 
121 
122     /** 
123      * Get balance of `_owner` 
124      * 
125      * @param _owner The address from which the balance will be retrieved
126      * @return The balance
127      */
128     function balanceOf(address _owner) constant returns (uint);
129 
130 
131     /** 
132      * Send `_value` token to `_to` from `msg.sender`
133      * 
134      * @param _to The address of the recipient
135      * @param _value The amount of token to be transferred
136      * @return Whether the transfer was successful or not
137      */
138     function transfer(address _to, uint _value) returns (bool);
139 
140 
141     /** 
142      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
143      * 
144      * @param _from The address of the sender
145      * @param _to The address of the recipient
146      * @param _value The amount of token to be transferred
147      * @return Whether the transfer was successful or not
148      */
149     function transferFrom(address _from, address _to, uint _value) returns (bool);
150 
151 
152     /** 
153      * `msg.sender` approves `_spender` to spend `_value` tokens
154      * 
155      * @param _spender The address of the account able to transfer the tokens
156      * @param _value The amount of tokens to be approved for transfer
157      * @return Whether the approval was successful or not
158      */
159     function approve(address _spender, uint _value) returns (bool);
160 
161 
162     /** 
163      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
164      * 
165      * @param _owner The address of the account owning tokens
166      * @param _spender The address of the account able to transfer the tokens
167      * @return Amount of remaining tokens allowed to spent
168      */
169     function allowance(address _owner, address _spender) constant returns (uint);
170 }
171 
172 
173 /**
174  * @title ERC20 compatible token
175  *
176  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
177  * - Short address attack fix
178  *
179  * #created 29/09/2017
180  * #author Frank Bonnet
181  */
182 contract Token is IToken, InputValidator {
183 
184     // Ethereum token standard
185     string public standard = "Token 0.3";
186     string public name;        
187     string public symbol;
188     uint8 public decimals = 8;
189 
190     // Token state
191     uint internal totalTokenSupply;
192 
193     // Token balances
194     mapping (address => uint) internal balances;
195 
196     // Token allowances
197     mapping (address => mapping (address => uint)) internal allowed;
198 
199 
200     // Events
201     event Transfer(address indexed _from, address indexed _to, uint _value);
202     event Approval(address indexed _owner, address indexed _spender, uint _value);
203 
204     /** 
205      * Construct 
206      * 
207      * @param _name The full token name
208      * @param _symbol The token symbol (aberration)
209      */
210     function Token(string _name, string _symbol) {
211         name = _name;
212         symbol = _symbol;
213         balances[msg.sender] = 0;
214         totalTokenSupply = 0;
215     }
216 
217 
218     /** 
219      * Get the total token supply
220      * 
221      * @return The total supply
222      */
223     function totalSupply() public constant returns (uint) {
224         return totalTokenSupply;
225     }
226 
227 
228     /** 
229      * Get balance of `_owner` 
230      * 
231      * @param _owner The address from which the balance will be retrieved
232      * @return The balance
233      */
234     function balanceOf(address _owner) public constant returns (uint) {
235         return balances[_owner];
236     }
237 
238 
239     /** 
240      * Send `_value` token to `_to` from `msg.sender`
241      * 
242      * @param _to The address of the recipient
243      * @param _value The amount of token to be transferred
244      * @return Whether the transfer was successful or not
245      */
246     function transfer(address _to, uint _value) public safe_arguments(2) returns (bool) {
247 
248         // Check if the sender has enough tokens
249         require(balances[msg.sender] >= _value);   
250 
251         // Check for overflows
252         require(balances[_to] + _value >= balances[_to]);
253 
254         // Transfer tokens
255         balances[msg.sender] -= _value;
256         balances[_to] += _value;
257 
258         // Notify listeners
259         Transfer(msg.sender, _to, _value);
260         return true;
261     }
262 
263 
264     /** 
265      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
266      * 
267      * @param _from The address of the sender
268      * @param _to The address of the recipient
269      * @param _value The amount of token to be transferred
270      * @return Whether the transfer was successful or not 
271      */
272     function transferFrom(address _from, address _to, uint _value) public safe_arguments(3) returns (bool) {
273 
274         // Check if the sender has enough
275         require(balances[_from] >= _value);
276 
277         // Check for overflows
278         require(balances[_to] + _value >= balances[_to]);
279 
280         // Check allowance
281         require(_value <= allowed[_from][msg.sender]);
282 
283         // Transfer tokens
284         balances[_to] += _value;
285         balances[_from] -= _value;
286 
287         // Update allowance
288         allowed[_from][msg.sender] -= _value;
289 
290         // Notify listeners
291         Transfer(_from, _to, _value);
292         return true;
293     }
294 
295 
296     /** 
297      * `msg.sender` approves `_spender` to spend `_value` tokens
298      * 
299      * @param _spender The address of the account able to transfer the tokens
300      * @param _value The amount of tokens to be approved for transfer
301      * @return Whether the approval was successful or not
302      */
303     function approve(address _spender, uint _value) public safe_arguments(2) returns (bool) {
304 
305         // Update allowance
306         allowed[msg.sender][_spender] = _value;
307 
308         // Notify listeners
309         Approval(msg.sender, _spender, _value);
310         return true;
311     }
312 
313 
314     /** 
315      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
316      * 
317      * @param _owner The address of the account owning tokens
318      * @param _spender The address of the account able to transfer the tokens
319      * @return Amount of remaining tokens allowed to spent
320      */
321     function allowance(address _owner, address _spender) public constant returns (uint) {
322       return allowed[_owner][_spender];
323     }
324 }
325 
326 
327 /**
328  * @title ManagedToken interface
329  *
330  * Adds the following functionallity to the basic ERC20 token
331  * - Locking
332  * - Issuing
333  *
334  * #created 29/09/2017
335  * #author Frank Bonnet
336  */
337 contract IManagedToken is IToken { 
338 
339     /** 
340      * Returns true if the token is locked
341      * 
342      * @return Whether the token is locked
343      */
344     function isLocked() constant returns (bool);
345 
346 
347     /**
348      * Unlocks the token so that the transferring of value is enabled 
349      *
350      * @return Whether the unlocking was successful or not
351      */
352     function unlock() returns (bool);
353 
354 
355     /**
356      * Issues `_value` new tokens to `_to`
357      *
358      * @param _to The address to which the tokens will be issued
359      * @param _value The amount of new tokens to issue
360      * @return Whether the tokens where sucessfully issued or not
361      */
362     function issue(address _to, uint _value) returns (bool);
363 }
364 
365 
366 /**
367  * @title ManagedToken
368  *
369  * Adds the following functionallity to the basic ERC20 token
370  * - Locking
371  * - Issuing
372  *
373  * #created 29/09/2017
374  * #author Frank Bonnet
375  */
376 contract ManagedToken is IManagedToken, Token, TransferableOwnership {
377 
378     // Token state
379     bool internal locked;
380 
381 
382     /**
383      * Allow access only when not locked
384      */
385     modifier only_when_unlocked() {
386         require(!locked);
387 
388         _;
389     }
390 
391 
392     /** 
393      * Construct 
394      * 
395      * @param _name The full token name
396      * @param _symbol The token symbol (aberration)
397      * @param _locked Whether the token should be locked initially
398      */
399     function ManagedToken(string _name, string _symbol, bool _locked) Token(_name, _symbol) {
400         locked = _locked;
401     }
402 
403 
404     /** 
405      * Send `_value` token to `_to` from `msg.sender`
406      * 
407      * @param _to The address of the recipient
408      * @param _value The amount of token to be transferred
409      * @return Whether the transfer was successful or not
410      */
411     function transfer(address _to, uint _value) public only_when_unlocked returns (bool) {
412         return super.transfer(_to, _value);
413     }
414 
415 
416     /** 
417      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
418      * 
419      * @param _from The address of the sender
420      * @param _to The address of the recipient
421      * @param _value The amount of token to be transferred
422      * @return Whether the transfer was successful or not
423      */
424     function transferFrom(address _from, address _to, uint _value) public only_when_unlocked returns (bool) {
425         return super.transferFrom(_from, _to, _value);
426     }
427 
428 
429     /** 
430      * `msg.sender` approves `_spender` to spend `_value` tokens
431      * 
432      * @param _spender The address of the account able to transfer the tokens
433      * @param _value The amount of tokens to be approved for transfer
434      * @return Whether the approval was successful or not
435      */
436     function approve(address _spender, uint _value) public returns (bool) {
437         return super.approve(_spender, _value);
438     }
439 
440 
441     /** 
442      * Returns true if the token is locked
443      * 
444      * @return Wheter the token is locked
445      */
446     function isLocked() public constant returns (bool) {
447         return locked;
448     }
449 
450 
451     /**
452      * Unlocks the token so that the transferring of value is enabled 
453      *
454      * @return Whether the unlocking was successful or not
455      */
456     function unlock() public only_owner returns (bool)  {
457         locked = false;
458         return !locked;
459     }
460 
461 
462     /**
463      * Issues `_value` new tokens to `_to`
464      *
465      * @param _to The address to which the tokens will be issued
466      * @param _value The amount of new tokens to issue
467      * @return Whether the approval was successful or not
468      */
469     function issue(address _to, uint _value) public only_owner safe_arguments(2) returns (bool) {
470         
471         // Check for overflows
472         require(balances[_to] + _value >= balances[_to]);
473 
474         // Create tokens
475         balances[_to] += _value;
476         totalTokenSupply += _value;
477 
478         // Notify listeners 
479         Transfer(0, this, _value);
480         Transfer(this, _to, _value);
481 
482         return true;
483     }
484 }
485 
486 
487 /**
488  * @title Token retrieve interface
489  *
490  * Allows tokens to be retrieved from a contract
491  *
492  * #created 29/09/2017
493  * #author Frank Bonnet
494  */
495 contract ITokenRetreiver {
496 
497     /**
498      * Extracts tokens from the contract
499      *
500      * @param _tokenContract The address of ERC20 compatible token
501      */
502     function retreiveTokens(address _tokenContract);
503 }
504 
505 /**
506  * @title NU (Network Units) token
507  *
508  * #created 22/10/2017
509  * #author Frank Bonnet
510  */
511 contract NUToken is ManagedToken, ITokenRetreiver {
512 
513 
514     /**
515      * Starts with a total supply of zero and the creator starts with 
516      * zero tokens (just like everyone else)
517      */
518     function NUToken() ManagedToken("Network Units Token", "NU", true) {}
519 
520 
521     /**
522      * Failsafe mechanism
523      * 
524      * Allows owner to retreive tokens from the contract
525      *
526      * @param _tokenContract The address of ERC20 compatible token
527      */
528     function retreiveTokens(address _tokenContract) public only_owner {
529         IToken tokenInstance = IToken(_tokenContract);
530         uint tokenBalance = tokenInstance.balanceOf(this);
531         if (tokenBalance > 0) {
532             tokenInstance.transfer(owner, tokenBalance);
533         }
534     }
535 
536 
537     /**
538      * Prevents accidental sending of ether
539      */
540     function () payable {
541         revert();
542     }
543 }