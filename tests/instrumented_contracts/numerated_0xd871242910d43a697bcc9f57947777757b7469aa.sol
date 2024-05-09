1 pragma solidity ^0.4.15;
2 
3 // File: contracts\infrastructure\ITokenRetreiver.sol
4 
5 /**
6  * @title Token retrieve interface
7  *
8  * Allows tokens to be retrieved from a contract
9  *
10  * #created 29/09/2017
11  * #author Frank Bonnet
12  */
13 contract ITokenRetreiver {
14 
15     /**
16      * Extracts tokens from the contract
17      *
18      * @param _tokenContract The address of ERC20 compatible token
19      */
20     function retreiveTokens(address _tokenContract);
21 }
22 
23 // File: contracts\source\token\IToken.sol
24 
25 /**
26  * @title ERC20 compatible token interface
27  *
28  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
29  * - Short address attack fix
30  *
31  * #created 29/09/2017
32  * #author Frank Bonnet
33  */
34 contract IToken {
35 
36     /**
37      * Get the total supply of tokens
38      *
39      * @return The total supply
40      */
41     function totalSupply() constant returns (uint);
42 
43 
44     /**
45      * Get balance of `_owner`
46      *
47      * @param _owner The address from which the balance will be retrieved
48      * @return The balance
49      */
50     function balanceOf(address _owner) constant returns (uint);
51 
52 
53     /**
54      * Send `_value` token to `_to` from `msg.sender`
55      *
56      * @param _to The address of the recipient
57      * @param _value The amount of token to be transferred
58      * @return Whether the transfer was successful or not
59      */
60     function transfer(address _to, uint _value) returns (bool);
61 
62 
63     /**
64      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
65      *
66      * @param _from The address of the sender
67      * @param _to The address of the recipient
68      * @param _value The amount of token to be transferred
69      * @return Whether the transfer was successful or not
70      */
71     function transferFrom(address _from, address _to, uint _value) returns (bool);
72 
73 
74     /**
75      * `msg.sender` approves `_spender` to spend `_value` tokens
76      *
77      * @param _spender The address of the account able to transfer the tokens
78      * @param _value The amount of tokens to be approved for transfer
79      * @return Whether the approval was successful or not
80      */
81     function approve(address _spender, uint _value) returns (bool);
82 
83 
84     /**
85      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
86      *
87      * @param _owner The address of the account owning tokens
88      * @param _spender The address of the account able to transfer the tokens
89      * @return Amount of remaining tokens allowed to spent
90      */
91     function allowance(address _owner, address _spender) constant returns (uint);
92 }
93 
94 // File: contracts\infrastructure\ownership\ITransferableOwnership.sol
95 
96 contract ITransferableOwnership {
97 
98     /**
99      * Transfer ownership to `_newOwner`
100      *
101      * @param _newOwner The address of the account that will become the new owner
102      */
103     function transferOwnership(address _newOwner);
104 }
105 
106 // File: contracts\infrastructure\modifier\Owned.sol
107 
108 contract Owned {
109 
110     // The address of the account that is the current owner
111     address internal owner;
112 
113 
114     /**
115      * The publisher is the inital owner
116      */
117     function Owned() {
118         owner = msg.sender;
119     }
120 
121 
122     /**
123      * Access is restricted to the current owner
124      */
125     modifier only_owner() {
126         require(msg.sender == owner);
127 
128         _;
129     }
130 }
131 
132 // File: contracts\infrastructure\ownership\IOwnership.sol
133 
134 contract IOwnership {
135 
136     /**
137      * Returns true if `_account` is the current owner
138      *
139      * @param _account The address to test against
140      */
141     function isOwner(address _account) constant returns (bool);
142 
143 
144     /**
145      * Gets the current owner
146      *
147      * @return address The current owner
148      */
149     function getOwner() constant returns (address);
150 }
151 
152 // File: contracts\infrastructure\ownership\Ownership.sol
153 
154 contract Ownership is IOwnership, Owned {
155 
156 
157     /**
158      * Returns true if `_account` is the current owner
159      *
160      * @param _account The address to test against
161      */
162     function isOwner(address _account) public constant returns (bool) {
163         return _account == owner;
164     }
165 
166 
167     /**
168      * Gets the current owner
169      *
170      * @return address The current owner
171      */
172     function getOwner() public constant returns (address) {
173         return owner;
174     }
175 }
176 
177 // File: contracts\infrastructure\ownership\TransferableOwnership.sol
178 
179 contract TransferableOwnership is ITransferableOwnership, Ownership {
180 
181 
182     /**
183      * Transfer ownership to `_newOwner`
184      *
185      * @param _newOwner The address of the account that will become the new owner
186      */
187     function transferOwnership(address _newOwner) public only_owner {
188         owner = _newOwner;
189     }
190 }
191 
192 // File: contracts\source\token\IManagedToken.sol
193 
194 /**
195  * @title ManagedToken interface
196  *
197  * Adds the following functionallity to the basic ERC20 token
198  * - Locking
199  * - Issuing
200  *
201  * #created 29/09/2017
202  * #author Frank Bonnet
203  */
204 contract IManagedToken is IToken {
205 
206     /**
207      * Returns true if the token is locked
208      *
209      * @return Whether the token is locked
210      */
211     function isLocked() constant returns (bool);
212 
213 
214     /**
215      * Unlocks the token so that the transferring of value is enabled
216      *
217      * @return Whether the unlocking was successful or not
218      */
219     function unlock() returns (bool);
220 
221 
222     /**
223      * Issues `_value` new tokens to `_to`
224      *
225      * @param _to The address to which the tokens will be issued
226      * @param _value The amount of new tokens to issue
227      * @return Whether the tokens where sucessfully issued or not
228      */
229     function issue(address _to, uint _value) returns (bool);
230 }
231 
232 // File: contracts\infrastructure\modifier\InputValidator.sol
233 
234 contract InputValidator {
235 
236 
237     /**
238      * ERC20 Short Address Attack fix
239      */
240     modifier safe_arguments(uint _numArgs) {
241         assert(msg.data.length == _numArgs * 32 + 4);
242         _;
243     }
244 }
245 
246 // File: contracts\source\token\Token.sol
247 
248 /**
249  * @title ERC20 compatible token
250  *
251  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
252  * - Short address attack fix
253  *
254  * #created 29/09/2017
255  * #author Frank Bonnet
256  */
257 contract Token is IToken, InputValidator {
258 
259     // Ethereum token standard
260     string public standard = "Token 0.3";
261     string public name;
262     string public symbol;
263     uint8 public decimals = 8;
264 
265     // Token state
266     uint internal totalTokenSupply;
267 
268     // Token balances
269     mapping (address => uint) internal balances;
270 
271     // Token allowances
272     mapping (address => mapping (address => uint)) internal allowed;
273 
274 
275     // Events
276     event Transfer(address indexed _from, address indexed _to, uint _value);
277     event Approval(address indexed _owner, address indexed _spender, uint _value);
278 
279     /**
280      * Construct
281      *
282      * @param _name The full token name
283      * @param _symbol The token symbol (aberration)
284      */
285     function Token(string _name, string _symbol) {
286         name = _name;
287         symbol = _symbol;
288         balances[msg.sender] = 0;
289         totalTokenSupply = 0;
290     }
291 
292 
293     /**
294      * Get the total token supply
295      *
296      * @return The total supply
297      */
298     function totalSupply() public constant returns (uint) {
299         return totalTokenSupply;
300     }
301 
302 
303     /**
304      * Get balance of `_owner`
305      *
306      * @param _owner The address from which the balance will be retrieved
307      * @return The balance
308      */
309     function balanceOf(address _owner) public constant returns (uint) {
310         return balances[_owner];
311     }
312 
313 
314     /**
315      * Send `_value` token to `_to` from `msg.sender`
316      *
317      * @param _to The address of the recipient
318      * @param _value The amount of token to be transferred
319      * @return Whether the transfer was successful or not
320      */
321     function transfer(address _to, uint _value) public safe_arguments(2) returns (bool) {
322 
323         // Check if the sender has enough tokens
324         require(balances[msg.sender] >= _value);
325 
326         // Check for overflows
327         require(balances[_to] + _value >= balances[_to]);
328 
329         // Transfer tokens
330         balances[msg.sender] -= _value;
331         balances[_to] += _value;
332 
333         // Notify listeners
334         Transfer(msg.sender, _to, _value);
335         return true;
336     }
337 
338 
339     /**
340      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
341      *
342      * @param _from The address of the sender
343      * @param _to The address of the recipient
344      * @param _value The amount of token to be transferred
345      * @return Whether the transfer was successful or not
346      */
347     function transferFrom(address _from, address _to, uint _value) public safe_arguments(3) returns (bool) {
348 
349         // Check if the sender has enough
350         require(balances[_from] >= _value);
351 
352         // Check for overflows
353         require(balances[_to] + _value >= balances[_to]);
354 
355         // Check allowance
356         require(_value <= allowed[_from][msg.sender]);
357 
358         // Transfer tokens
359         balances[_to] += _value;
360         balances[_from] -= _value;
361 
362         // Update allowance
363         allowed[_from][msg.sender] -= _value;
364 
365         // Notify listeners
366         Transfer(_from, _to, _value);
367         return true;
368     }
369 
370 
371     /**
372      * `msg.sender` approves `_spender` to spend `_value` tokens
373      *
374      * @param _spender The address of the account able to transfer the tokens
375      * @param _value The amount of tokens to be approved for transfer
376      * @return Whether the approval was successful or not
377      */
378     function approve(address _spender, uint _value) public safe_arguments(2) returns (bool) {
379 
380         // Update allowance
381         allowed[msg.sender][_spender] = _value;
382 
383         // Notify listeners
384         Approval(msg.sender, _spender, _value);
385         return true;
386     }
387 
388 
389     /**
390      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
391      *
392      * @param _owner The address of the account owning tokens
393      * @param _spender The address of the account able to transfer the tokens
394      * @return Amount of remaining tokens allowed to spent
395      */
396     function allowance(address _owner, address _spender) public constant returns (uint) {
397       return allowed[_owner][_spender];
398     }
399 }
400 
401 // File: contracts\source\token\ManagedToken.sol
402 
403 /**
404  * @title ManagedToken
405  *
406  * Adds the following functionallity to the basic ERC20 token
407  * - Locking
408  * - Issuing
409  *
410  * #created 29/09/2017
411  * #author Frank Bonnet
412  */
413 contract ManagedToken is IManagedToken, Token, TransferableOwnership {
414 
415     // Token state
416     bool internal locked;
417 
418 
419     /**
420      * Allow access only when not locked
421      */
422     modifier only_when_unlocked() {
423         require(!locked);
424 
425         _;
426     }
427 
428 
429     /**
430      * Construct
431      *
432      * @param _name The full token name
433      * @param _symbol The token symbol (aberration)
434      * @param _locked Whether the token should be locked initially
435      */
436     function ManagedToken(string _name, string _symbol, bool _locked) Token(_name, _symbol) {
437         locked = _locked;
438     }
439 
440 
441     /**
442      * Send `_value` token to `_to` from `msg.sender`
443      *
444      * @param _to The address of the recipient
445      * @param _value The amount of token to be transferred
446      * @return Whether the transfer was successful or not
447      */
448     function transfer(address _to, uint _value) public only_when_unlocked returns (bool) {
449         return super.transfer(_to, _value);
450     }
451 
452 
453     /**
454      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
455      *
456      * @param _from The address of the sender
457      * @param _to The address of the recipient
458      * @param _value The amount of token to be transferred
459      * @return Whether the transfer was successful or not
460      */
461     function transferFrom(address _from, address _to, uint _value) public only_when_unlocked returns (bool) {
462         return super.transferFrom(_from, _to, _value);
463     }
464 
465 
466     /**
467      * `msg.sender` approves `_spender` to spend `_value` tokens
468      *
469      * @param _spender The address of the account able to transfer the tokens
470      * @param _value The amount of tokens to be approved for transfer
471      * @return Whether the approval was successful or not
472      */
473     function approve(address _spender, uint _value) public returns (bool) {
474         return super.approve(_spender, _value);
475     }
476 
477 
478     /**
479      * Returns true if the token is locked
480      *
481      * @return Wheter the token is locked
482      */
483     function isLocked() public constant returns (bool) {
484         return locked;
485     }
486 
487 
488     /**
489      * Unlocks the token so that the transferring of value is enabled
490      *
491      * @return Whether the unlocking was successful or not
492      */
493     function unlock() public only_owner returns (bool)  {
494         locked = false;
495         return !locked;
496     }
497 
498 
499     /**
500      * Issues `_value` new tokens to `_to`
501      *
502      * @param _to The address to which the tokens will be issued
503      * @param _value The amount of new tokens to issue
504      * @return Whether the approval was successful or not
505      */
506     function issue(address _to, uint _value) public only_owner safe_arguments(2) returns (bool) {
507 
508         // Check for overflows
509         require(balances[_to] + _value >= balances[_to]);
510 
511         // Create tokens
512         balances[_to] += _value;
513         totalTokenSupply += _value;
514 
515         // Notify listeners
516         Transfer(0, this, _value);
517         Transfer(this, _to, _value);
518 
519         return true;
520     }
521 }
522 
523 // File: contracts\source\NUToken.sol
524 
525 /**
526  * @title NU (NU) token
527  *
528  * #created 22/10/2017
529  * #author Frank Bonnet
530  */
531 contract NUToken is ManagedToken, ITokenRetreiver {
532 
533 
534     /**
535      * Starts with a total supply of zero and the creator starts with
536      * zero tokens (just like everyone else)
537      */
538     function NUToken() ManagedToken("NU", "NU", true) {}
539 
540 
541     /**
542      * Failsafe mechanism
543      *
544      * Allows owner to retreive tokens from the contract
545      *
546      * @param _tokenContract The address of ERC20 compatible token
547      */
548     function retreiveTokens(address _tokenContract) public only_owner {
549         IToken tokenInstance = IToken(_tokenContract);
550         uint tokenBalance = tokenInstance.balanceOf(this);
551         if (tokenBalance > 0) {
552             tokenInstance.transfer(owner, tokenBalance);
553         }
554     }
555 
556 
557     /**
558      * Prevents accidental sending of ether
559      */
560     function () payable {
561         revert();
562     }
563 }