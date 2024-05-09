1 pragma solidity ^0.4.24;
2 
3  
4 
5 contract owned {
6 
7     address public owner;
8 
9  
10 
11     function owned() public {
12 
13         owner = msg.sender;
14 
15     }
16 
17  
18 
19     modifier onlyOwner {
20 
21         require(msg.sender == owner);
22 
23         _;
24 
25     }
26 
27  
28 
29     function transferOwnership(address newOwner) onlyOwner public {
30 
31         owner = newOwner;
32 
33     }
34 
35 }
36 
37  
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, throws on overflow.
46   */
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     if (a == 0) {
49       return 0;
50     }
51     uint256 c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   /**
57   * @dev Integer division of two numbers, truncating the quotient.
58   */
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   /**
75   * @dev Adds two numbers, throws on overflow.
76   */
77   function add(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
85 
86  
87 
88 contract TokenERC20 {
89 
90     // Public variables of the token
91 
92     string public name;
93 
94     string public symbol;
95 
96     uint8 public decimals = 18;
97 
98     // 18 decimals is the strongly suggested default, avoid changing it
99 
100     uint256 public totalSupply;
101 
102  
103 
104     // This creates an array with all balances
105 
106     mapping (address => uint256) public balanceOf;
107 
108     mapping (address => mapping (address => uint256)) public allowance;
109 
110  
111 
112     // This generates a public event on the blockchain that will notify clients
113 
114     event Transfer(address indexed from, address indexed to, uint256 value);
115 
116  
117 
118     // This notifies clients about the amount burnt
119 
120     event Burn(address indexed from, uint256 value);
121 
122  
123 
124     /**
125 
126      * Constrctor function
127 
128      *
129 
130      * Initializes contract with initial supply tokens to the creator of the contract
131 
132      */
133 
134     function TokenERC20(
135 
136         uint256 initialSupply,
137 
138         string tokenName,
139 
140         string tokenSymbol
141 
142     ) public {
143 
144         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
145 
146         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
147 
148         name = tokenName;                                   // Set the name for display purposes
149 
150         symbol = tokenSymbol;                               // Set the symbol for display purposes
151 
152     }
153 
154  
155 
156     /**
157 
158      * Internal transfer, only can be called by this contract
159 
160      */
161 
162     function _transfer(address _from, address _to, uint _value) internal {
163 
164         // Prevent transfer to 0x0 address. Use burn() instead
165 
166         require(_to != 0x0);
167 
168         // Check if the sender has enough
169 
170         require(balanceOf[_from] >= _value);
171 
172         // Check for overflows
173 
174         require(balanceOf[_to] + _value > balanceOf[_to]);
175 
176         // Save this for an assertion in the future
177 
178         uint previousBalances = balanceOf[_from] + balanceOf[_to];
179 
180         // Subtract from the sender
181 
182         balanceOf[_from] -= _value;
183 
184         // Add the same to the recipient
185 
186         balanceOf[_to] += _value;
187 
188         Transfer(_from, _to, _value);
189 
190         // Asserts are used to use static analysis to find bugs in your code. They should never fail
191 
192         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
193 
194     }
195 
196  
197 
198     /**
199 
200      * Transfer tokens
201 
202      *
203 
204      * Send `_value` tokens to `_to` from your account
205 
206      *
207 
208      * @param _to The address of the recipient
209 
210      * @param _value the amount to send
211 
212      */
213 
214     function transfer(address _to, uint256 _value) public {
215 
216         _transfer(msg.sender, _to, _value);
217 
218     }
219 
220  
221 
222     /**
223 
224      * Transfer tokens from other address
225 
226      *
227 
228      * Send `_value` tokens to `_to` in behalf of `_from`
229 
230      *
231 
232      * @param _from The address of the sender
233 
234      * @param _to The address of the recipient
235 
236      * @param _value the amount to send
237 
238      */
239 
240     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
241 
242         require(_value <= allowance[_from][msg.sender]);     // Check allowance
243 
244         allowance[_from][msg.sender] -= _value;
245 
246         _transfer(_from, _to, _value);
247 
248         return true;
249 
250     }
251 
252  
253 
254     /**
255 
256      * Set allowance for other address
257 
258      *
259 
260      * Allows `_spender` to spend no more than `_value` tokens in your behalf
261 
262      *
263 
264      * @param _spender The address authorized to spend
265 
266      * @param _value the max amount they can spend
267 
268      */
269 
270     function approve(address _spender, uint256 _value) public
271 
272         returns (bool success) {
273 
274         allowance[msg.sender][_spender] = _value;
275 
276         return true;
277 
278     }
279 
280  
281 
282     /**
283 
284      * Set allowance for other address and notify
285 
286      *
287 
288      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
289 
290      *
291 
292      * @param _spender The address authorized to spend
293 
294      * @param _value the max amount they can spend
295 
296      * @param _extraData some extra information to send to the approved contract
297 
298      */
299 
300     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
301 
302         public
303 
304         returns (bool success) {
305 
306         tokenRecipient spender = tokenRecipient(_spender);
307 
308         if (approve(_spender, _value)) {
309 
310             spender.receiveApproval(msg.sender, _value, this, _extraData);
311 
312             return true;
313 
314         }
315 
316     }
317 
318  
319 
320     /**
321 
322      * Destroy tokens
323 
324      *
325 
326      * Remove `_value` tokens from the system irreversibly
327 
328      *
329 
330      * @param _value the amount of money to burn
331 
332      */
333 
334     function burn(uint256 _value) public returns (bool success) {
335 
336         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
337 
338         balanceOf[msg.sender] -= _value;            // Subtract from the sender
339 
340         totalSupply -= _value;                      // Updates totalSupply
341 
342         Burn(msg.sender, _value);
343 
344         return true;
345 
346     }
347 
348  
349 
350     /**
351 
352      * Destroy tokens from other account
353 
354      *
355 
356      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
357 
358      *
359 
360      * @param _from the address of the sender
361 
362      * @param _value the amount of money to burn
363 
364      */
365 
366     function burnFrom(address _from, uint256 _value) public returns (bool success) {
367 
368         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
369 
370         require(_value <= allowance[_from][msg.sender]);    // Check allowance
371 
372         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
373 
374         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
375 
376         totalSupply -= _value;                              // Update totalSupply
377 
378         Burn(_from, _value);
379 
380         return true;
381 
382     }
383 
384 }
385 
386  
387 
388 /******************************************/
389 
390 /*       ADVANCED TOKEN STARTS HERE       */
391 
392 /******************************************/
393 
394  
395 
396 contract PACOIN is owned, TokenERC20 {
397 
398  
399 
400     uint256 public sellPrice;
401 
402     uint256 public buyPrice;
403 
404  
405 
406     mapping (address => bool) public frozenAccount;
407 
408  
409 
410     /* This generates a public event on the blockchain that will notify clients */
411 
412     event FrozenFunds(address target, bool frozen);
413     
414     using SafeMath for uint256;
415  
416 
417     /* Initializes contract with initial supply tokens to the creator of the contract */
418 
419     function PACOIN(
420 
421         uint256 initialSupply,
422 
423         string tokenName,
424 
425         string tokenSymbol
426 
427     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
428 
429  
430 
431     /* Internal transfer, only can be called by this contract */
432 
433     function _transfer(address _from, address _to, uint _value) internal {
434 
435         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
436 
437         require (balanceOf[_from] >= _value);               // Check if the sender has enough
438 
439         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
440 
441         require(!frozenAccount[_from]);                     // Check if sender is frozen
442 
443         require(!frozenAccount[_to]);                       // Check if recipient is frozen
444 
445         balanceOf[_from] -= _value;                         // Subtract from the sender
446 
447         balanceOf[_to] += _value;                           // Add the same to the recipient
448 
449         Transfer(_from, _to, _value);
450 
451     }
452     
453     function batchTransfer(address[] _tos, uint256[] _amount) onlyOwner public returns (bool success) {
454         require(_tos.length == _amount.length); 
455         uint256 i;
456         uint256 sum = 0;
457         for(i = 0; i < _amount.length; i++) { 
458             sum = sum.add(_amount[i]); 
459             require(_tos[i] != address(0));
460         }
461         require(balanceOf[msg.sender] >= sum);
462         for(i = 0; i < _tos.length; i++){
463             transfer(_tos[i], _amount[i]);
464             return true; 
465         }
466     }
467 
468  
469 
470     /// @notice Create `mintedAmount` tokens and send it to `target`
471 
472     /// @param target Address to receive the tokens
473 
474     /// @param mintedAmount the amount of tokens it will receive
475 
476     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
477 
478         balanceOf[target] += mintedAmount;
479 
480         totalSupply += mintedAmount;
481 
482         Transfer(0, this, mintedAmount);
483 
484         Transfer(this, target, mintedAmount);
485 
486     }
487 
488  
489 
490     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
491 
492     /// @param target Address to be frozen
493 
494     /// @param freeze either to freeze it or not
495 
496     function freezeAccount(address target, bool freeze) onlyOwner public {
497 
498         frozenAccount[target] = freeze;
499 
500         FrozenFunds(target, freeze);
501 
502     }
503 
504  
505 
506     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
507 
508     /// @param newSellPrice Price the users can sell to the contract
509 
510     /// @param newBuyPrice Price users can buy from the contract
511 
512     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
513 
514         sellPrice = newSellPrice;
515 
516         buyPrice = newBuyPrice;
517 
518     }
519 
520  
521 
522     /// @notice Buy tokens from contract by sending ether
523 
524     function buy() payable public {
525 
526         uint amount = msg.value / buyPrice;               // calculates the amount
527 
528         _transfer(this, msg.sender, amount);              // makes the transfers
529 
530     }
531 
532  
533 
534     /// @notice Sell `amount` tokens to contract
535 
536     /// @param amount amount of tokens to be sold
537 
538     function sell(uint256 amount) public {
539 
540         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
541 
542         _transfer(msg.sender, this, amount);              // makes the transfers
543 
544         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
545 
546     }
547 
548 }