1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20
5  * @dev   ERC20 Contract interface(s)
6  */
7 contract ERC20
8 {
9     function balanceOf    (address _owner) public constant returns (uint256 balance);
10     function transfer     (               address _to, uint256 _value) public returns (bool success);
11     function transferFrom (address _from, address _to, uint256 _value) public returns (bool success);
12     function approve      (address _spender, uint256 _value) public returns (bool success);
13     function allowance    (address _owner, address _spender) public constant returns (uint256 remaining);
14     function totalSupply  () public constant returns (uint);
15 
16     event Transfer (address indexed _from,  address indexed _to,      uint _value);
17     event Approval (address indexed _owner, address indexed _spender, uint _value);
18 }
19 
20 /**
21  * @title TokenRecipient 
22  */
23 interface TokenRecipient
24 {
25     /* fundtion definitions */
26     function receiveApproval (address _from, uint256 _value, address _token, bytes _extraData) external;
27 }
28 
29 /**
30  * @title SafeMath math library
31  * @dev   Math operations with safety checks that throw on error
32  */
33 library SafeMath
34 {
35     /**
36      * @dev 'a + b', Adds two numbers, throws on overflow
37      */
38     function add (uint256 a, uint256 b) internal pure returns (uint256 c)
39     {
40         c = a + b;
41         require (c >= a); return c;
42     }
43 
44     /**
45      * @dev 'a - b', Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend)
46      */
47     function sub (uint256 a, uint256 b) internal pure returns (uint256 c)
48     {
49         require (a >= b);
50         c = a - b; return c;
51     }
52 
53     /**
54      * @dev 'a * b', multiplies two numbers, throws on overflow
55      */
56     function mul (uint256 a, uint256 b) internal pure returns (uint256 c)
57     {
58         c = a * b;
59         require (a == 0 || c / a == b); return c;
60     }
61 
62     /**
63      * @dev 'a / b', Integer division of two numbers, truncating the quotient
64      */
65     function div (uint256 a, uint256 b) internal pure returns (uint256 c)
66     {
67         require (b > 0);
68         c = a / b; return c;
69     }
70 }
71 
72 /**
73  * @title ERC20Token
74  * @dev   Implementation of the ERC20 Token
75  */
76 contract ERC20Token is ERC20
77 {
78     using SafeMath for uint256;
79 
80     /* balance of each account */
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83 
84     string  public name;
85     string  public symbol;
86     uint8   public decimals;
87     uint256 public totalSupply;
88 
89     /**
90      * @dev   Creates a ERC20 Contract with its name, symbol, decimals, and total supply of token
91      * @param _name name of token
92      * @param _symbol name of symbol
93      * @param _decimals decimals
94      * @param _initSupply total supply of tokens
95      */
96     constructor (string _name, string _symbol, uint8 _decimals, uint256 _initSupply) public
97     {
98         name        = _name;                                    // set the name   for display purpose
99         symbol      = _symbol;                                  // set the symbol for display purpose
100         decimals    = _decimals;                                // 18 decimals is the strongly suggested 
101         totalSupply = _initSupply * (10 ** uint256 (decimals)); // update total supply with the decimal amount
102         balances[msg.sender] = totalSupply;                     // give the creator all initial tokens
103 
104         emit Transfer (address(0), msg.sender, totalSupply);
105     }
106 
107     /**
108      * @dev Get the token balance for account `_owner`
109      */
110     function balanceOf (address _owner) public view returns (uint256 balance)
111     {
112         return balances[_owner];
113     }
114 
115     /* function to access name, symbol, decimals, total-supply of token. */
116     function name        () public view returns (string  _name    ) { return name;        } 
117     function symbol      () public view returns (string  _symbol  ) { return symbol;      } 
118     function decimals    () public view returns (uint8   _decimals) { return decimals;    }
119     function totalSupply () public view returns (uint256 _supply  ) { return totalSupply; }
120 
121     /**
122      * @dev Internal transfer, only can be called by this contract
123      */
124     function _transfer (address _from, address _to, uint256 _value) internal
125     {
126         require (_to != 0x0);                               // prevent transfer to 0x0 address
127         require (balances[_from] >= _value);                // check if the sender has enough
128         require (balances[_to  ] +  _value > balances[_to]);// check for overflows
129 
130         uint256 previous = balances[_from] + balances[_to]; // save this for an assertion in the future
131 
132         balances[_from] = balances[_from].sub (_value);     // subtract from the sender
133         balances[_to  ] = balances[_to  ].add (_value);     // add the same to the recipient
134         emit Transfer (_from, _to, _value);
135 
136         /* Asserts are used to use static analysis to find bugs in your code. They should never fail */
137         assert (balances[_from] + balances[_to] == previous);
138     }
139 
140     /**
141      * @dev    Transfer the balance from owner's account to another account "_to" 
142      *         owner's account must have sufficient balance to transfer
143      *         0 value transfers are allowed
144      * @param  _to The address of the recipient
145      * @param  _value The amount to send
146      * @return true if the operation was successful.
147      */
148     function transfer (address _to, uint256 _value) public returns (bool success)
149     {
150         _transfer (msg.sender, _to, _value); return true;
151     }
152 
153     /**
154      * @dev    Send `_value` amount of tokens from `_from` account to `_to` account
155      *         The calling account must already have sufficient tokens approved for
156      *         spending from the `_from` account
157      * @param  _from The address of the sender
158      * @param  _to The address of the recipient
159      * @param  _value The amount to send
160      * @return true if the operation was successful.
161      */
162     function transferFrom (address _from, address _to, uint256 _value) public returns (bool success)
163     {
164         require (allowed[_from][msg.sender] >= _value); // check allowance 
165         allowed [_from][msg.sender] = allowed [_from][msg.sender].sub (_value);
166 
167         _transfer (_from, _to, _value); return true;
168     }
169 
170     /**
171      * @dev    Get the amount of tokens approved by the owner that can be transferred
172      *         to the spender's account
173      * @param  _owner The address owner
174      * @param  _spender The address authorized to spend
175      * @return The amount of tokens remained for the approved by the owner that can
176      *         be transferred
177      */
178     function allowance (address _owner, address _spender) public constant returns (uint remaining)
179     {
180         return allowed[_owner][_spender];
181     }
182 
183     /**
184      * @dev    Set allowance for other address
185      *         Allow `_spender` to withdraw from your account, multiple times,
186      *         up to the `_value` amount. If this function is called again it
187      *         overwrites the current allowance with _value.
188      *         Token owner can approve for `spender` to transferFrom (...) `tokens`
189      *         from the token owner's account
190      * @param  _spender The address authorized to spend
191      * @param  _value the max amount they can spend
192      * @return true if the operation was successful.
193      */
194     function approve (address _spender, uint256 _value) public returns (bool success)
195     {
196         allowed[msg.sender][_spender] = _value;
197         emit Approval (msg.sender, _spender, _value);
198         return true;
199     }
200 
201     /**
202      * @dev    Set allowance for other address and notify
203      *         Allows `_spender` to spend no more than `_value` tokens in your behalf,
204      *         and then ping the contract about it
205      * @param  _spender   the address authorized to spend
206      * @param  _value     the max amount they can spend
207      * @param  _extraData some extra information to send to the approved contract
208      * @return true if the operation was successful.
209      */
210     function approveAndCall (address _spender, uint256 _value, bytes _extraData) public returns (bool success)
211     {
212         TokenRecipient spender = TokenRecipient (_spender);
213 
214         if (approve (_spender, _value))
215         {
216             spender.receiveApproval (msg.sender, _value, address (this), _extraData);
217             return true;
218         }
219     }
220 }
221 
222 /**
223  * @title  Ownable
224  * @notice For user and inter-contract ownership and safe ownership transfers.
225  * @dev    The Ownable contract has an owner address, and provides basic
226  *         authorization control functions
227  */
228 contract Ownable
229 {
230     address public owner;   /* the address of the contract's owner  */
231 
232     /* logged on change & renounce of owner */
233     event OwnershipTransferred (address indexed _owner, address indexed _to);
234     event OwnershipRenounced   (address indexed _owner);
235 
236     /**
237      * @dev Sets the original 'owner' of the contract to the sender account
238      */
239     constructor () public 
240     {
241         owner = msg.sender;
242     }
243 
244     /**
245      * @dev Throws if called by any account other than the owner
246      */
247     modifier onlyOwner 
248     {
249         require (msg.sender == owner);
250         _;
251     }
252 
253     /**
254      * @dev   Allows the current owner to transfer control of the contract to a '_to'
255      * @param _to The address to transfer ownership to
256      */
257     function transferOwnership (address _to) public onlyOwner
258     {
259         require (_to != address(0));
260         emit OwnershipTransferred (owner, _to);
261         owner = _to;
262     }
263 
264     /**
265      * @dev   Allows the current owner to relinquish control of the contract.
266      *        This will remove all ownership of the contract, _safePhrase must
267      *        be equal to "This contract is to be disowned"
268      * @param _safePhrase Input string to prevent one's mistake
269      */
270     function renounceOwnership (bytes32 _safePhrase) public onlyOwner
271     {
272         require (_safePhrase == "This contract is to be disowned.");
273         emit OwnershipRenounced (owner);
274         owner = address(0);
275     }
276 }
277 
278 /**
279  * @title ExpERC20Token
280  */
281 contract ExpERC20Token is ERC20Token, Ownable
282 {
283     /**
284      * @dev   Creates a ERC20 Contract with its name, symbol, decimals, and total supply of token
285      * @param _name name of token
286      * @param _symbol name of symbol
287      * @param _decimals decimals
288      * @param _initSupply total supply of tokens
289      */
290     constructor (
291         string   _name,     // name of token
292         string   _symbol,   // name of symbol
293         uint8    _decimals, // decimals
294         uint256 _initSupply // total supply of tokens
295     ) ERC20Token (_name, _symbol, _decimals, _initSupply) public {}
296 
297     /**
298      * @notice Only the creator can alter the name & symbol
299      * @param  _name   newer token name   to be changed
300      * @param  _symbol newer token symbol to be changed
301      */
302     function changeName (string _name, string _symbol) onlyOwner public
303     {
304         name   = _name;
305         symbol = _symbol;
306     }
307 
308     /* ======================================================================
309      * Burnable functions
310      */
311 
312     /* This notifies clients about the amount burnt */
313     event Burn (address indexed from, uint256 value);
314 
315     /**
316      * Internal burn, only can be called by this contract
317      */
318     function _burn (address _from, uint256 _value) internal
319     {
320         require (balances[_from] >= _value);            // check if the sender has enough
321 
322         balances[_from] = balances[_from].sub (_value); // subtract from the sender
323         totalSupply = totalSupply.sub (_value);         // updates totalSupply
324         emit Burn (_from, _value);
325     }
326 
327     /**
328      * @dev    remove `_value` tokens from the system irreversibly
329      * @param  _value the amount of money to burn
330      * @return true if the operation was successful.
331      */
332     function burn (uint256 _value) public returns (bool success)
333     {
334         _burn (msg.sender, _value); return true;
335     }
336 
337     /**
338      * @dev    remove `_value` tokens from the system irreversibly on behalf of `_from`
339      * @param  _from the address of the sender
340      * @param  _value the amount of money to burn
341      * @return true if the operation was successful.
342      */
343     function burnFrom (address _from, uint256 _value) public returns (bool success)
344     {
345         require (allowed [_from][msg.sender] >= _value);
346         allowed [_from][msg.sender] = allowed [_from][msg.sender].sub (_value);
347         _burn (_from, _value); return true;
348     }
349 
350 
351     /* ======================================================================
352      * Mintable functions
353      */
354 
355     /* event for mint's */
356     event Mint (address indexed _to, uint256 _amount);
357     event MintFinished ();
358 
359     bool public mintingFinished = false;
360 
361     /* Throws if it is not mintable status */
362     modifier canMint ()
363     {
364         require (!mintingFinished);
365         _;
366     }
367 
368     /* Throws if called by any account other than the owner */
369     modifier hasMintPermission ()
370     {
371         require (msg.sender == owner);
372         _;
373     }
374 
375     /**
376      * @dev    Function to mint tokens
377      * @param  _to The address that will receive the minted tokens.
378      * @param  _amount The amount of tokens to mint.
379      * @return A boolean that indicates if the operation was successful.
380      */
381     function mint (address _to, uint256 _amount) hasMintPermission canMint public returns (bool)
382     {
383         totalSupply   = totalSupply.add  (_amount);
384         balances[_to] = balances[_to].add (_amount);
385 
386         emit Mint (_to, _amount);
387         emit Transfer (address (0), this, _amount);
388         emit Transfer (       this,  _to, _amount);
389         return true;
390     }
391 
392     /**
393      * @dev    Function to stop minting new tokens.
394      * @return True if the operation was successful.
395      */
396     function finishMinting () onlyOwner canMint public returns (bool)
397     {
398         mintingFinished = true;
399         emit MintFinished ();
400         return true;
401     }
402 
403 
404     /* ======================================================================
405      * Lockable Token
406      */
407 
408     bool public tokenLocked = false;
409 
410     /* event for Token's lock or unlock */
411     event Lock (address indexed _target, bool _locked);
412 
413     mapping (address => bool) public frozenAccount;
414 
415     /* This generates a public event on the blockchain that will notify clients */
416     event FrozenFunds (address target, bool frozen);
417 
418     /**
419      * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
420      * @param  _target address to be frozen
421      * @param  _freeze either to freeze it or not
422      */
423     function freezeAccount (address _target, bool _freeze) onlyOwner public
424     {
425         frozenAccount[_target] = _freeze;
426         emit FrozenFunds (_target, _freeze);
427     }
428 
429     /* Throws if it is not locked status */
430     modifier whenTokenUnlocked ()
431     {
432         require (!tokenLocked);
433         _;
434     }
435 
436     /* Internal token-lock, only can be called by this contract */
437     function _lock (bool _value) internal
438     {
439         require (tokenLocked != _value);
440         tokenLocked = _value;
441         emit Lock (this, tokenLocked);
442     }
443 
444     /**
445      * @dev    function to check token is lock or not 
446      */
447     function isTokenLocked () public view returns (bool success)
448     {
449         return tokenLocked;
450     }
451 
452     /**
453      * @dev    function to lock/unlock this token
454      * @param  _value flag to be locked or not
455      */
456     function lock (bool _value) onlyOwner public returns (bool)
457     {
458         _lock (_value); return true;
459     }
460 
461     /**
462      * @dev    Transfer the balance from owner's account to another account "_to" 
463      *         owner's account must have sufficient balance to transfer
464      *         0 value transfers are allowed
465      * @param  _to The address of the recipient
466      * @param  _value The amount to send
467      * @return true if the operation was successful.
468      */
469     function transfer (address _to, uint256 _value) whenTokenUnlocked public returns (bool success)
470     {
471         require (!frozenAccount[msg.sender]);   // check if sender is frozen
472         require (!frozenAccount[_to  ]);        // check if recipient is frozen
473 
474         return super.transfer (_to, _value);
475     }
476 
477     /**
478      * @dev    Send `_value` amount of tokens from `_from` account to `_to` account
479      *         The calling account must already have sufficient tokens approved for
480      *         spending from the `_from` account
481      * @param  _from The address of the sender
482      * @param  _to The address of the recipient
483      * @param  _value The amount to send
484      * @return true if the operation was successful.
485      */
486     function transferFrom (address _from, address _to, uint256 _value) whenTokenUnlocked public returns (bool success)
487     {
488         require (!frozenAccount[msg.sender]);   // check if sender is frozen
489         require (!frozenAccount[_from]);        // check if token-owner is frozen
490         require (!frozenAccount[_to  ]);        // check if recipient is frozen
491 
492         return super.transferFrom (_from, _to, _value);
493     }
494 
495     /**
496      * @dev    Set allowance for other address
497      *         Allow `_spender` to withdraw from your account, multiple times,
498      *         up to the `_value` amount. If this function is called again it
499      *         overwrites the current allowance with _value.
500      *         Token owner can approve for `spender` to transferFrom (...) `tokens`
501      *         from the token owner's account
502      * @param  _spender The address authorized to spend
503      * @param  _value the max amount they can spend
504      * @return true if the operation was successful.
505      */
506     function approve (address _spender, uint256 _value) whenTokenUnlocked public returns (bool success)
507     {
508         require (!frozenAccount[msg.sender]);   // check if sender is frozen
509         require (!frozenAccount[_spender  ]);   // check if token-owner is frozen
510 
511         return super.approve (_spender, _value);
512     }
513 
514     /**
515      * @dev    Set allowance for other address and notify
516      *         Allows `_spender` to spend no more than `_value` tokens in your behalf,
517      *         and then ping the contract about it
518      * @param  _spender   the address authorized to spend
519      * @param  _value     the max amount they can spend
520      * @param  _extraData some extra information to send to the approved contract
521      * @return true if the operation was successful.
522      */
523     function approveAndCall (address _spender, uint256 _value, bytes _extraData) whenTokenUnlocked public returns (bool success)
524     {
525         require (!frozenAccount[msg.sender]);   // check if sender is frozen
526         require (!frozenAccount[_spender  ]);   // check if token-owner is frozen
527 
528         return super.approveAndCall (_spender, _value, _extraData);
529     }
530 
531     /* ======================================================================
532      * buy & sell functions 
533      */
534 
535     uint256 public sellPrice;
536     uint256 public buyPrice;
537 
538     /* Internal transfer, only can be called by this contract */
539     function _transfer (address _from, address _to, uint _value) internal
540     {
541         require (_to != 0x0);                                   // prevent transfer to 0x0 address
542         require (balances[_from] >= _value);                    // check if the sender has enough
543         require (balances[_to  ]  + _value >= balances[_to]);   // check for overflows
544 
545         require (!frozenAccount[_from]);                        // check if sender is frozen
546         require (!frozenAccount[_to  ]);                        // check if recipient is frozen
547 
548         balances[_from] = balances[_from].sub (_value);         // Subtract from the sender
549         balances[_to  ] = balances[_to  ].add (_value);         // Add the same to the recipient
550         emit Transfer (_from, _to, _value);
551     }
552 
553     /**
554      * @notice allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
555      * @param  _sellPrice Price the users can sell to the contract
556      * @param  _buyPrice  Price users can buy from the contract
557      */
558     function setPrices (uint256 _sellPrice, uint256 _buyPrice) onlyOwner public
559     {
560         sellPrice = _sellPrice;
561         buyPrice  = _buyPrice ;
562     }
563 
564     /**
565      * @notice Buy tokens from contract by sending ether
566      */
567     function buy () whenTokenUnlocked payable public
568     {
569         uint amount = msg.value / buyPrice;     // calculates the amount
570         _transfer (this, msg.sender, amount);   // makes the transfers
571     }
572 
573     /**
574      *  @notice sell `_amount` tokens to contract
575      *  @param  _amount amount of tokens to be sold
576      */
577     function sell (uint256 _amount) whenTokenUnlocked public
578     {
579         require (balances[this] >= _amount * sellPrice);    // checks if the contract has enough ether to buy
580         _transfer (msg.sender, this, _amount);              // makes the transfers
581         msg.sender.transfer (_amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
582     }
583 
584 
585 }