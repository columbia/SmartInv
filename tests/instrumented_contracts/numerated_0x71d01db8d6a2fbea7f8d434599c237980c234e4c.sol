1 pragma solidity ^0.4.15;
2 
3 contract InputValidator {
4 
5 
6     /**
7      * ERC20 Short Address Attack fix
8      */
9     modifier safe_arguments(uint _numArgs) {
10         assert(msg.data.length == _numArgs * 32 + 4);
11         _;
12     }
13 }
14 
15 contract Owned {
16 
17     // The address of the account that is the current owner 
18     address internal owner;
19 
20 
21     /**
22      * The publisher is the inital owner
23      */
24     function Owned() {
25         owner = msg.sender;
26     }
27 
28 
29     /**
30      * Access is restricted to the current owner
31      */
32     modifier only_owner() {
33         require(msg.sender == owner);
34 
35         _;
36     }
37 }
38 
39 contract IOwnership {
40 
41     /**
42      * Returns true if `_account` is the current owner
43      *
44      * @param _account The address to test against
45      */
46     function isOwner(address _account) constant returns (bool);
47 
48 
49     /**
50      * Gets the current owner
51      *
52      * @return address The current owner
53      */
54     function getOwner() constant returns (address);
55 }
56 
57 contract Ownership is IOwnership, Owned {
58 
59 
60     /**
61      * Returns true if `_account` is the current owner
62      *
63      * @param _account The address to test against
64      */
65     function isOwner(address _account) public constant returns (bool) {
66         return _account == owner;
67     }
68 
69 
70     /**
71      * Gets the current owner
72      *
73      * @return address The current owner
74      */
75     function getOwner() public constant returns (address) {
76         return owner;
77     }
78 }
79 
80 contract ITransferableOwnership {
81 
82     /**
83      * Transfer ownership to `_newOwner`
84      *
85      * @param _newOwner The address of the account that will become the new owner 
86      */
87     function transferOwnership(address _newOwner);
88 }
89 
90 contract TransferableOwnership is ITransferableOwnership, Ownership {
91 
92 
93     /**
94      * Transfer ownership to `_newOwner`
95      *
96      * @param _newOwner The address of the account that will become the new owner 
97      */
98     function transferOwnership(address _newOwner) public only_owner {
99         owner = _newOwner;
100     }
101 }
102 
103 
104 /**
105  * @title ERC20 compatible token interface
106  *
107  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
108  * - Short address attack fix
109  *
110  * #created 29/09/2017
111  * #author Frank Bonnet
112  */
113 contract IToken { 
114 
115     /** 
116      * Get the total supply of tokens
117      * 
118      * @return The total supply
119      */
120     function totalSupply() constant returns (uint);
121 
122 
123     /** 
124      * Get balance of `_owner` 
125      * 
126      * @param _owner The address from which the balance will be retrieved
127      * @return The balance
128      */
129     function balanceOf(address _owner) constant returns (uint);
130 
131 
132     /** 
133      * Send `_value` token to `_to` from `msg.sender`
134      * 
135      * @param _to The address of the recipient
136      * @param _value The amount of token to be transferred
137      * @return Whether the transfer was successful or not
138      */
139     function transfer(address _to, uint _value) returns (bool);
140 
141 
142     /** 
143      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
144      * 
145      * @param _from The address of the sender
146      * @param _to The address of the recipient
147      * @param _value The amount of token to be transferred
148      * @return Whether the transfer was successful or not
149      */
150     function transferFrom(address _from, address _to, uint _value) returns (bool);
151 
152 
153     /** 
154      * `msg.sender` approves `_spender` to spend `_value` tokens
155      * 
156      * @param _spender The address of the account able to transfer the tokens
157      * @param _value The amount of tokens to be approved for transfer
158      * @return Whether the approval was successful or not
159      */
160     function approve(address _spender, uint _value) returns (bool);
161 
162 
163     /** 
164      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
165      * 
166      * @param _owner The address of the account owning tokens
167      * @param _spender The address of the account able to transfer the tokens
168      * @return Amount of remaining tokens allowed to spent
169      */
170     function allowance(address _owner, address _spender) constant returns (uint);
171 }
172 
173 
174 /**
175  * @title ERC20 compatible token
176  *
177  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
178  * - Short address attack fix
179  *
180  * #created 29/09/2017
181  * #author Frank Bonnet
182  */
183 contract Token is IToken, InputValidator {
184 
185     // Ethereum token standard
186     string public standard = "Token 0.3";
187     string public name;        
188     string public symbol;
189     uint8 public decimals = 8;
190 
191     // Token state
192     uint internal totalTokenSupply;
193 
194     // Token balances
195     mapping (address => uint) internal balances;
196 
197     // Token allowances
198     mapping (address => mapping (address => uint)) internal allowed;
199 
200 
201     // Events
202     event Transfer(address indexed _from, address indexed _to, uint _value);
203     event Approval(address indexed _owner, address indexed _spender, uint _value);
204 
205     /** 
206      * Construct 
207      * 
208      * @param _name The full token name
209      * @param _symbol The token symbol (aberration)
210      */
211     function Token(string _name, string _symbol) {
212         name = _name;
213         symbol = _symbol;
214         balances[msg.sender] = 0;
215         totalTokenSupply = 0;
216     }
217 
218 
219     /** 
220      * Get the total token supply
221      * 
222      * @return The total supply
223      */
224     function totalSupply() public constant returns (uint) {
225         return totalTokenSupply;
226     }
227 
228 
229     /** 
230      * Get balance of `_owner` 
231      * 
232      * @param _owner The address from which the balance will be retrieved
233      * @return The balance
234      */
235     function balanceOf(address _owner) public constant returns (uint) {
236         return balances[_owner];
237     }
238 
239 
240     /** 
241      * Send `_value` token to `_to` from `msg.sender`
242      * 
243      * @param _to The address of the recipient
244      * @param _value The amount of token to be transferred
245      * @return Whether the transfer was successful or not
246      */
247     function transfer(address _to, uint _value) public safe_arguments(2) returns (bool) {
248 
249         // Check if the sender has enough tokens
250         require(balances[msg.sender] >= _value);   
251 
252         // Check for overflows
253         require(balances[_to] + _value >= balances[_to]);
254 
255         // Transfer tokens
256         balances[msg.sender] -= _value;
257         balances[_to] += _value;
258 
259         // Notify listeners
260         Transfer(msg.sender, _to, _value);
261         return true;
262     }
263 
264 
265     /** 
266      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
267      * 
268      * @param _from The address of the sender
269      * @param _to The address of the recipient
270      * @param _value The amount of token to be transferred
271      * @return Whether the transfer was successful or not 
272      */
273     function transferFrom(address _from, address _to, uint _value) public safe_arguments(3) returns (bool) {
274 
275         // Check if the sender has enough
276         require(balances[_from] >= _value);
277 
278         // Check for overflows
279         require(balances[_to] + _value >= balances[_to]);
280 
281         // Check allowance
282         require(_value <= allowed[_from][msg.sender]);
283 
284         // Transfer tokens
285         balances[_to] += _value;
286         balances[_from] -= _value;
287 
288         // Update allowance
289         allowed[_from][msg.sender] -= _value;
290 
291         // Notify listeners
292         Transfer(_from, _to, _value);
293         return true;
294     }
295 
296 
297     /** 
298      * `msg.sender` approves `_spender` to spend `_value` tokens
299      * 
300      * @param _spender The address of the account able to transfer the tokens
301      * @param _value The amount of tokens to be approved for transfer
302      * @return Whether the approval was successful or not
303      */
304     function approve(address _spender, uint _value) public safe_arguments(2) returns (bool) {
305 
306         // Update allowance
307         allowed[msg.sender][_spender] = _value;
308 
309         // Notify listeners
310         Approval(msg.sender, _spender, _value);
311         return true;
312     }
313 
314 
315     /** 
316      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
317      * 
318      * @param _owner The address of the account owning tokens
319      * @param _spender The address of the account able to transfer the tokens
320      * @return Amount of remaining tokens allowed to spent
321      */
322     function allowance(address _owner, address _spender) public constant returns (uint) {
323       return allowed[_owner][_spender];
324     }
325 }
326 
327 
328 /**
329  * @title ManagedToken interface
330  *
331  * Adds the following functionallity to the basic ERC20 token
332  * - Locking
333  * - Issuing
334  *
335  * #created 29/09/2017
336  * #author Frank Bonnet
337  */
338 contract IManagedToken is IToken { 
339 
340     /** 
341      * Returns true if the token is locked
342      * 
343      * @return Whether the token is locked
344      */
345     function isLocked() constant returns (bool);
346 
347 
348     /**
349      * Unlocks the token so that the transferring of value is enabled 
350      *
351      * @return Whether the unlocking was successful or not
352      */
353     function unlock() returns (bool);
354 
355 
356     /**
357      * Issues `_value` new tokens to `_to`
358      *
359      * @param _to The address to which the tokens will be issued
360      * @param _value The amount of new tokens to issue
361      * @return Whether the tokens where sucessfully issued or not
362      */
363     function issue(address _to, uint _value) returns (bool);
364 }
365 
366 
367 /**
368  * @title ManagedToken
369  *
370  * Adds the following functionallity to the basic ERC20 token
371  * - Locking
372  * - Issuing
373  *
374  * #created 29/09/2017
375  * #author Frank Bonnet
376  */
377 contract ManagedToken is IManagedToken, Token, TransferableOwnership {
378 
379     // Token state
380     bool internal locked;
381 
382 
383     /**
384      * Allow access only when not locked
385      */
386     modifier only_when_unlocked() {
387         require(!locked);
388 
389         _;
390     }
391 
392 
393     /** 
394      * Construct 
395      * 
396      * @param _name The full token name
397      * @param _symbol The token symbol (aberration)
398      * @param _locked Whether the token should be locked initially
399      */
400     function ManagedToken(string _name, string _symbol, bool _locked) Token(_name, _symbol) {
401         locked = _locked;
402     }
403 
404 
405     /** 
406      * Send `_value` token to `_to` from `msg.sender`
407      * 
408      * @param _to The address of the recipient
409      * @param _value The amount of token to be transferred
410      * @return Whether the transfer was successful or not
411      */
412     function transfer(address _to, uint _value) public only_when_unlocked returns (bool) {
413         return super.transfer(_to, _value);
414     }
415 
416 
417     /** 
418      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
419      * 
420      * @param _from The address of the sender
421      * @param _to The address of the recipient
422      * @param _value The amount of token to be transferred
423      * @return Whether the transfer was successful or not
424      */
425     function transferFrom(address _from, address _to, uint _value) public only_when_unlocked returns (bool) {
426         return super.transferFrom(_from, _to, _value);
427     }
428 
429 
430     /** 
431      * `msg.sender` approves `_spender` to spend `_value` tokens
432      * 
433      * @param _spender The address of the account able to transfer the tokens
434      * @param _value The amount of tokens to be approved for transfer
435      * @return Whether the approval was successful or not
436      */
437     function approve(address _spender, uint _value) public returns (bool) {
438         return super.approve(_spender, _value);
439     }
440 
441 
442     /** 
443      * Returns true if the token is locked
444      * 
445      * @return Wheter the token is locked
446      */
447     function isLocked() public constant returns (bool) {
448         return locked;
449     }
450 
451 
452     /**
453      * Unlocks the token so that the transferring of value is enabled 
454      *
455      * @return Whether the unlocking was successful or not
456      */
457     function unlock() public only_owner returns (bool)  {
458         locked = false;
459         return !locked;
460     }
461 
462 
463     /**
464      * Issues `_value` new tokens to `_to`
465      *
466      * @param _to The address to which the tokens will be issued
467      * @param _value The amount of new tokens to issue
468      * @return Whether the approval was successful or not
469      */
470     function issue(address _to, uint _value) public only_owner safe_arguments(2) returns (bool) {
471         
472         // Check for overflows
473         require(balances[_to] + _value >= balances[_to]);
474 
475         // Create tokens
476         balances[_to] += _value;
477         totalTokenSupply += _value;
478 
479         // Notify listeners 
480         Transfer(0, this, _value);
481         Transfer(this, _to, _value);
482 
483         return true;
484     }
485 }
486 
487 
488 /**
489  * @title Token retrieve interface
490  *
491  * Allows tokens to be retrieved from a contract
492  *
493  * #created 29/09/2017
494  * #author Frank Bonnet
495  */
496 contract ITokenRetreiver {
497 
498     /**
499      * Extracts tokens from the contract
500      *
501      * @param _tokenContract The address of ERC20 compatible token
502      */
503     function retreiveTokens(address _tokenContract);
504 }
505 
506 /**
507  * @title GLA (Gladius) token
508  *
509  * #created 26/09/2017
510  * #author Frank Bonnet
511  */
512 contract GLAToken is ManagedToken, ITokenRetreiver {
513 
514 
515     /**
516      * Starts with a total supply of zero and the creator starts with 
517      * zero tokens (just like everyone else)
518      */
519     function GLAToken() ManagedToken("Gladius Token", "GLA", true) {}
520 
521 
522     /**
523      * Failsafe mechanism
524      * 
525      * Allows owner to retreive tokens from the contract
526      *
527      * @param _tokenContract The address of ERC20 compatible token
528      */
529     function retreiveTokens(address _tokenContract) public only_owner {
530         IToken tokenInstance = IToken(_tokenContract);
531         uint tokenBalance = tokenInstance.balanceOf(this);
532         if (tokenBalance > 0) {
533             tokenInstance.transfer(owner, tokenBalance);
534         }
535     }
536 
537 
538     /**
539      * Prevents accidental sending of ether
540      */
541     function () payable {
542         revert();
543     }
544 }