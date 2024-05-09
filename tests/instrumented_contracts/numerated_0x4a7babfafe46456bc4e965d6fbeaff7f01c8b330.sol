1 pragma solidity ^0.4.16;
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
38 
39 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
40 
41  
42 
43 contract TokenERC20 {
44 
45     // Public variables of the token
46 
47     string public name;
48 
49     string public symbol;
50 
51     uint8 public decimals = 8;
52 
53     // 18 decimals is the strongly suggested default, avoid changing it
54 
55     uint256 public totalSupply;
56 
57  
58 
59     // This creates an array with all balances
60 
61     mapping (address => uint256) public balanceOf;
62 
63     mapping (address => mapping (address => uint256)) public allowance;
64 
65  
66 
67     // This generates a public event on the blockchain that will notify clients
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71  
72 
73     // This notifies clients about the amount burnt
74 
75     event Burn(address indexed from, uint256 value);
76 
77  
78 
79     /**
80 
81      * Constrctor function
82 
83      *
84 
85      * Initializes contract with initial supply tokens to the creator of the contract
86 
87      */
88 
89     function TokenERC20(
90 
91         uint256 initialSupply,
92 
93         string tokenName,
94 
95         string tokenSymbol
96 
97     ) public {
98 
99         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
100 
101         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
102 
103         name = tokenName;                                   // Set the name for display purposes
104 
105         symbol = tokenSymbol;                               // Set the symbol for display purposes
106 
107     }
108 
109  
110 
111     /**
112 
113      * Internal transfer, only can be called by this contract
114 
115      */
116 
117     function _transfer(address _from, address _to, uint _value) internal {
118 
119         // Prevent transfer to 0x0 address. Use burn() instead
120 
121         require(_to != 0x0);
122 
123         // Check if the sender has enough
124 
125         require(balanceOf[_from] >= _value);
126 
127         // Check for overflows
128 
129         require(balanceOf[_to] + _value > balanceOf[_to]);
130 
131         // Save this for an assertion in the future
132 
133         uint previousBalances = balanceOf[_from] + balanceOf[_to];
134 
135         // Subtract from the sender
136 
137         balanceOf[_from] -= _value;
138 
139         // Add the same to the recipient
140 
141         balanceOf[_to] += _value;
142 
143         Transfer(_from, _to, _value);
144 
145         // Asserts are used to use static analysis to find bugs in your code. They should never fail
146 
147         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
148 
149     }
150 
151  
152 
153     /**
154 
155      * Transfer tokens
156 
157      *
158 
159      * Send `_value` tokens to `_to` from your account
160 
161      *
162 
163      * @param _to The address of the recipient
164 
165      * @param _value the amount to send
166 
167      */
168 
169     function transfer(address _to, uint256 _value) public {
170 
171         _transfer(msg.sender, _to, _value);
172 
173     }
174 
175  
176 
177     /**
178 
179      * Transfer tokens from other address
180 
181      *
182 
183      * Send `_value` tokens to `_to` in behalf of `_from`
184 
185      *
186 
187      * @param _from The address of the sender
188 
189      * @param _to The address of the recipient
190 
191      * @param _value the amount to send
192 
193      */
194 
195     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
196 
197         require(_value <= allowance[_from][msg.sender]);     // Check allowance
198 
199         allowance[_from][msg.sender] -= _value;
200 
201         _transfer(_from, _to, _value);
202 
203         return true;
204 
205     }
206 
207  
208 
209     /**
210 
211      * Set allowance for other address
212 
213      *
214 
215      * Allows `_spender` to spend no more than `_value` tokens in your behalf
216 
217      *
218 
219      * @param _spender The address authorized to spend
220 
221      * @param _value the max amount they can spend
222 
223      */
224 
225     function approve(address _spender, uint256 _value) public
226 
227         returns (bool success) {
228 
229         allowance[msg.sender][_spender] = _value;
230 
231         return true;
232 
233     }
234 
235  
236 
237     /**
238 
239      * Set allowance for other address and notify
240 
241      *
242 
243      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
244 
245      *
246 
247      * @param _spender The address authorized to spend
248 
249      * @param _value the max amount they can spend
250 
251      * @param _extraData some extra information to send to the approved contract
252 
253      */
254 
255     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
256 
257         public
258 
259         returns (bool success) {
260 
261         tokenRecipient spender = tokenRecipient(_spender);
262 
263         if (approve(_spender, _value)) {
264 
265             spender.receiveApproval(msg.sender, _value, this, _extraData);
266 
267             return true;
268 
269         }
270 
271     }
272 
273  
274 
275     /**
276 
277      * Destroy tokens
278 
279      *
280 
281      * Remove `_value` tokens from the system irreversibly
282 
283      *
284 
285      * @param _value the amount of money to burn
286 
287      */
288 
289     function burn(uint256 _value) public returns (bool success) {
290 
291         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
292 
293         balanceOf[msg.sender] -= _value;            // Subtract from the sender
294 
295         totalSupply -= _value;                      // Updates totalSupply
296 
297         Burn(msg.sender, _value);
298 
299         return true;
300 
301     }
302 
303  
304 
305     /**
306 
307      * Destroy tokens from other account
308 
309      *
310 
311      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
312 
313      *
314 
315      * @param _from the address of the sender
316 
317      * @param _value the amount of money to burn
318 
319      */
320 
321     function burnFrom(address _from, uint256 _value) public returns (bool success) {
322 
323         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
324 
325         require(_value <= allowance[_from][msg.sender]);    // Check allowance
326 
327         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
328 
329         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
330 
331         totalSupply -= _value;                              // Update totalSupply
332 
333         Burn(_from, _value);
334 
335         return true;
336 
337     }
338 
339 }
340 
341  
342 
343 /******************************************/
344 
345 /*       ADVANCED TOKEN STARTS HERE       */
346 
347 /******************************************/
348 
349  
350 
351 contract MyAdvancedToken is owned, TokenERC20 {
352 
353  
354 
355     uint256 public sellPrice;
356 
357     uint256 public buyPrice;
358 
359  
360 
361     mapping (address => bool) public frozenAccount;
362 
363  
364 
365     /* This generates a public event on the blockchain that will notify clients */
366 
367     event FrozenFunds(address target, bool frozen);
368 
369  
370 
371     /* Initializes contract with initial supply tokens to the creator of the contract */
372 
373     function MyAdvancedToken(
374 
375         uint256 initialSupply,
376 
377         string tokenName,
378 
379         string tokenSymbol
380 
381     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
382 
383  
384 
385     /* Internal transfer, only can be called by this contract */
386 
387     function _transfer(address _from, address _to, uint _value) internal {
388 
389         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
390 
391         require (balanceOf[_from] >= _value);               // Check if the sender has enough
392 
393         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
394 
395         require(!frozenAccount[_from]);                     // Check if sender is frozen
396 
397         require(!frozenAccount[_to]);                       // Check if recipient is frozen
398 
399         balanceOf[_from] -= _value;                         // Subtract from the sender
400 
401         balanceOf[_to] += _value;                           // Add the same to the recipient
402 
403         Transfer(_from, _to, _value);
404 
405     }
406 
407  
408 
409     /// @notice Create `mintedAmount` tokens and send it to `target`
410 
411     /// @param target Address to receive the tokens
412 
413     /// @param mintedAmount the amount of tokens it will receive
414 
415     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
416 
417         balanceOf[target] += mintedAmount;
418 
419         totalSupply += mintedAmount;
420 
421         Transfer(0, this, mintedAmount);
422 
423         Transfer(this, target, mintedAmount);
424 
425     }
426 
427  
428 
429     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
430 
431     /// @param target Address to be frozen
432 
433     /// @param freeze either to freeze it or not
434 
435     function freezeAccount(address target, bool freeze) onlyOwner public {
436 
437         frozenAccount[target] = freeze;
438 
439         FrozenFunds(target, freeze);
440 
441     }
442 
443  
444 
445     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
446 
447     /// @param newSellPrice Price the users can sell to the contract
448 
449     /// @param newBuyPrice Price users can buy from the contract
450 
451     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
452 
453         sellPrice = newSellPrice;
454 
455         buyPrice = newBuyPrice;
456 
457     }
458 
459  
460 
461     /// @notice Buy tokens from contract by sending ether
462 
463     function buy() payable public {
464 
465         uint amount = msg.value / buyPrice;               // calculates the amount
466 
467         _transfer(this, msg.sender, amount);              // makes the transfers
468 
469     }
470 
471  
472 
473     /// @notice Sell `amount` tokens to contract
474 
475     /// @param amount amount of tokens to be sold
476 
477     function sell(uint256 amount) public {
478 
479         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
480 
481         _transfer(msg.sender, this, amount);              // makes the transfers
482 
483         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
484 
485     }
486 
487 }