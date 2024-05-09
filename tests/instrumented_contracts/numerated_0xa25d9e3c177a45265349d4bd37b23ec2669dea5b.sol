1 pragma solidity ^0.4.18;
2 
3 contract owned {
4 
5     address public owner;
6 
7  
8 
9     function owned() public {
10 
11         owner = msg.sender;
12 
13     }
14 
15  
16 
17     modifier onlyOwner {
18 
19         require(msg.sender == owner);
20 
21         _;
22 
23     }
24 
25  
26 
27     function transferOwnership(address newOwner) onlyOwner public {
28 
29         owner = newOwner;
30 
31     }
32 
33 }
34 
35  
36 
37 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
38 
39  
40 
41 contract TokenERC20 {
42 
43     // Public variables of the token
44 
45     string public name;
46 
47     string public symbol;
48 
49     uint8 public decimals = 8;
50 
51     // 8 decimals are used instead of 18
52 
53     uint256 public totalSupply;
54 
55  
56 
57     // This creates an array with all balances
58 
59     mapping (address => uint256) public balanceOf;
60 
61     mapping (address => mapping (address => uint256)) public allowance;
62 
63  
64 
65     // This generates a public event on the blockchain that will notify clients
66 
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69  
70 
71     // This notifies clients about the amount burnt
72 
73     event Burn(address indexed from, uint256 value);
74 
75  
76 
77     /**
78 
79      * Constrctor function
80 
81      *
82 
83      * Initializes contract with initial supply tokens to the creator of the contract
84 
85      */
86 
87     function TokenERC20(
88 
89         uint256 initialSupply,
90 
91         string tokenName,
92 
93         string tokenSymbol
94 
95     ) public {
96 
97         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
98 
99         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
100 
101         name = tokenName;                                   // Set the name for display purposes
102 
103         symbol = tokenSymbol;                               // Set the symbol for display purposes
104 
105     }
106 
107  
108 
109     /**
110 
111      * Internal transfer, only can be called by this contract
112 
113      */
114 
115     function _transfer(address _from, address _to, uint _value) internal {
116 
117         // Prevent transfer to 0x0 address. Use burn() instead
118 
119         require(_to != 0x0);
120 
121         // Check if the sender has enough
122 
123         require(balanceOf[_from] >= _value);
124 
125         // Check for overflows
126 
127         require(balanceOf[_to] + _value > balanceOf[_to]);
128 
129         // Save this for an assertion in the future
130 
131         uint previousBalances = balanceOf[_from] + balanceOf[_to];
132 
133         // Subtract from the sender
134 
135         balanceOf[_from] -= _value;
136 
137         // Add the same to the recipient
138 
139         balanceOf[_to] += _value;
140 
141         Transfer(_from, _to, _value);
142 
143         // Asserts are used to use static analysis to find bugs in your code. They should never fail
144 
145         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
146 
147     }
148 
149  
150 
151     /**
152 
153      * Transfer tokens
154 
155      *
156 
157      * Send `_value` tokens to `_to` from your account
158 
159      *
160 
161      * @param _to The address of the recipient
162 
163      * @param _value the amount to send
164 
165      */
166 
167     function transfer(address _to, uint256 _value) public {
168 
169         _transfer(msg.sender, _to, _value);
170 
171     }
172 
173  
174 
175     /**
176 
177      * Transfer tokens from other address
178 
179      *
180 
181      * Send `_value` tokens to `_to` in behalf of `_from`
182 
183      *
184 
185      * @param _from The address of the sender
186 
187      * @param _to The address of the recipient
188 
189      * @param _value the amount to send
190 
191      */
192 
193     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
194 
195         require(_value <= allowance[_from][msg.sender]);     // Check allowance
196 
197         allowance[_from][msg.sender] -= _value;
198 
199         _transfer(_from, _to, _value);
200 
201         return true;
202 
203     }
204 
205  
206 
207     /**
208 
209      * Set allowance for other address
210 
211      *
212 
213      * Allows `_spender` to spend no more than `_value` tokens in your behalf
214 
215      *
216 
217      * @param _spender The address authorized to spend
218 
219      * @param _value the max amount they can spend
220 
221      */
222 
223     function approve(address _spender, uint256 _value) public
224 
225         returns (bool success) {
226 
227         allowance[msg.sender][_spender] = _value;
228 
229         return true;
230 
231     }
232 
233  
234 
235     /**
236 
237      * Set allowance for other address and notify
238 
239      *
240 
241      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
242 
243      *
244 
245      * @param _spender The address authorized to spend
246 
247      * @param _value the max amount they can spend
248 
249      * @param _extraData some extra information to send to the approved contract
250 
251      */
252 
253     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
254 
255         public
256 
257         returns (bool success) {
258 
259         tokenRecipient spender = tokenRecipient(_spender);
260 
261         if (approve(_spender, _value)) {
262 
263             spender.receiveApproval(msg.sender, _value, this, _extraData);
264 
265             return true;
266 
267         }
268 
269     }
270 
271  
272 
273     /**
274 
275      * Destroy tokens
276 
277      *
278 
279      * Remove `_value` tokens from the system irreversibly
280 
281      *
282 
283      * @param _value the amount of money to burn
284 
285      */
286 
287     function burn(uint256 _value) public returns (bool success) {
288 
289         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
290 
291         balanceOf[msg.sender] -= _value;            // Subtract from the sender
292 
293         totalSupply -= _value;                      // Updates totalSupply
294 
295         Burn(msg.sender, _value);
296 
297         return true;
298 
299     }
300 
301  
302 
303     /**
304 
305      * Destroy tokens from other account
306 
307      *
308 
309      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
310 
311      *
312 
313      * @param _from the address of the sender
314 
315      * @param _value the amount of money to burn
316 
317      */
318 
319     function burnFrom(address _from, uint256 _value) public returns (bool success) {
320 
321         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
322 
323         require(_value <= allowance[_from][msg.sender]);    // Check allowance
324 
325         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
326 
327         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
328 
329         totalSupply -= _value;                              // Update totalSupply
330 
331         Burn(_from, _value);
332 
333         return true;
334 
335     }
336 
337 }
338 
339  
340 
341 /******************************************/
342 
343 /*       ADVANCED TOKEN STARTS HERE       */
344 
345 /******************************************/
346 
347  
348 
349 contract BMVCoin is owned, TokenERC20 {
350 
351  
352 
353     uint256 public sellPrice;
354 
355     uint256 public buyPrice;
356 
357  
358 
359     mapping (address => bool) public frozenAccount;
360 
361  
362 
363     /* This generates a public event on the blockchain that will notify clients */
364 
365     event FrozenFunds(address target, bool frozen);
366 
367  
368 
369     /* Initializes contract with initial supply tokens to the creator of the contract */
370 
371     function BMVCoin(
372 
373         uint256 initialSupply,
374 
375         string tokenName,
376 
377         string tokenSymbol
378 
379     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
380 
381  
382 
383     /* Internal transfer, only can be called by this contract */
384 
385     function _transfer(address _from, address _to, uint _value) internal {
386 
387         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
388 
389         require (balanceOf[_from] >= _value);               // Check if the sender has enough
390 
391         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
392 
393         require(!frozenAccount[_from]);                     // Check if sender is frozen
394 
395         require(!frozenAccount[_to]);                       // Check if recipient is frozen
396 
397         balanceOf[_from] -= _value;                         // Subtract from the sender
398 
399         balanceOf[_to] += _value;                           // Add the same to the recipient
400 
401         Transfer(_from, _to, _value);
402 
403     }
404 
405  
406 
407     /// @notice Create `mintedAmount` tokens and send it to `target`
408 
409     /// @param target Address to receive the tokens
410 
411     /// @param mintedAmount the amount of tokens it will receive
412 
413     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
414 
415         balanceOf[target] += mintedAmount;
416 
417         totalSupply += mintedAmount;
418 
419         Transfer(0, this, mintedAmount);
420 
421         Transfer(this, target, mintedAmount);
422 
423     }
424 
425  
426 
427     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
428 
429     /// @param target Address to be frozen
430 
431     /// @param freeze either to freeze it or not
432 
433     function freezeAccount(address target, bool freeze) onlyOwner public {
434 
435         frozenAccount[target] = freeze;
436 
437         FrozenFunds(target, freeze);
438 
439     }
440 
441  
442 
443     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
444 
445     /// @param newSellPrice Price the users can sell to the contract
446 
447     /// @param newBuyPrice Price users can buy from the contract
448 
449     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
450 
451         sellPrice = newSellPrice;
452 
453         buyPrice = newBuyPrice;
454 
455     }
456 
457  
458 
459     /// @notice Buy tokens from contract by sending ether
460 
461     function buy() public payable {
462 
463         uint amount = msg.value / buyPrice;               // calculates the amount
464 
465         _transfer(this, msg.sender, amount);              // makes the transfers
466 
467     }
468 
469  
470 
471     /// @notice Sell `amount` tokens to contract
472 
473     /// @param amount amount of tokens to be sold
474 
475     function sell(uint256 amount) public {
476 
477         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
478 
479         _transfer(msg.sender, this, amount);              // makes the transfers
480 
481         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
482 
483     }
484 
485 }