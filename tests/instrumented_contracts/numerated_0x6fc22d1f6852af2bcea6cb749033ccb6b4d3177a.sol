1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 }
6 
7 contract TokenERC20 {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     // 18 decimals is the strongly suggested default, avoid changing it
12     uint8 public decimals = 18;
13     uint256 public totalSupply;
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 }
19 
20 contract BitSTDShares is owned, TokenERC20 {
21 
22     uint256 public sellPrice;
23     uint256 public buyPrice;
24 
25     mapping (address => bool) public frozenAccount;
26 }
27 
28 contract BitSTDData {
29     // Used to control data migration
30     bool public data_migration_control = true;
31     address public owner;
32     // Public variables of the token
33     string public name;
34     string public symbol;
35     uint8 public decimals;
36     uint256 public totalSupply;
37 
38     // An array of all balances
39     mapping (address => uint256) public balanceOf;
40     mapping (address => mapping (address => uint256)) public allowance;
41     uint256 public sellPrice;
42     uint256 public buyPrice;
43     // The allowed address zhi value wei value is true
44     mapping (address => bool) public owners;
45     // Freeze address
46     mapping (address => bool) public frozenAccount;
47     BitSTDShares private bit;
48 
49     constructor(address contractAddress) public {
50         bit = BitSTDShares(contractAddress);
51         owner = msg.sender;
52         name = bit.name();
53         symbol = bit.symbol();
54         decimals = bit.decimals();
55         sellPrice = bit.sellPrice();
56         buyPrice = bit.buyPrice();
57         totalSupply = bit.totalSupply();
58         balanceOf[msg.sender] = totalSupply;
59     }
60 
61     modifier qualification {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     // Move the super administrator
67     function transferAuthority(address newOwner) public {
68         require(msg.sender == owner);
69         owner = newOwner;
70     }
71 
72     function setBalanceOfAddr(address addr, uint256 value) qualification public {
73         balanceOf[addr] = value;
74     }
75 
76     function setAllowance(address authorizer, address sender, uint256 value) qualification public {
77         allowance[authorizer][sender] = value;
78     }
79 
80 
81     function setFrozenAccount(address addr, bool value) qualification public {
82         frozenAccount[addr] = value;
83     }
84 
85     function addTotalSupply(uint256 value) qualification public {
86         totalSupply = value;
87     }
88 
89     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public {
90         require(msg.sender == owner);
91         sellPrice = newSellPrice;
92         buyPrice = newBuyPrice;
93     }
94 
95     // Old contract data
96     function getOldBalanceOf(address addr) constant  public returns(uint256) {
97        return bit.balanceOf(addr);
98     }
99    
100     
101     function getOldAllowance(address authorizer, address sender) constant  public returns(uint256) {
102         return bit.allowance(authorizer, sender);
103     }
104 
105     function getOldFrozenAccount(address addr) constant public returns(bool) {
106         return bit.frozenAccount(addr);
107     }
108    
109 }
110 
111 
112 
113 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
114 
115 contract BitSTDLogic {
116     address public owner;
117     // data layer
118 	BitSTDData private data;
119 
120     constructor(address dataAddress) {
121         data = BitSTDData(dataAddress);
122         owner = msg.sender;
123     }
124     
125     // Transfer logical layer authority
126     function transferAuthority(address newOwner) onlyOwner public {
127         owner = newOwner;
128     }
129 	modifier onlyOwner(){
130 		require(msg.sender == owner);
131         _;
132 	}
133 	
134 	// Transfer data layer authority
135     function transferDataAuthority(address newOwner) onlyOwner public {
136         data.transferAuthority(newOwner);
137     }
138     function setData(address dataAddress)onlyOwner public {
139         data = BitSTDData(dataAddress);
140     }
141 
142     // Old contract data
143     function getOldBalanceOf(address addr) constant public returns (uint256) {
144         return data.getOldBalanceOf(addr);
145     }
146 
147 	/**
148 	 * Internal transfers can only be invoked through this contract
149 	*/
150     function _transfer(address _from, address _to, uint _value) internal {
151         uint256 f_value = balanceOf(_from);
152         uint256 t_value = balanceOf(_to);
153         // Prevents transmission to 0x0 address.Call to Burn ()
154         require(_to != 0x0);
155         // Check that the sender is adequate
156         require(f_value >= _value);
157         // Check the overflow
158         require(t_value + _value > t_value);
159         // Save it as a future assertion
160         uint previousBalances = f_value + t_value;
161         // Minus from the sender
162         setBalanceOf(_from, f_value - _value);
163         // Add to receiver
164         setBalanceOf(_to, t_value + _value);
165 
166         // Assertions are used to use static analysis to detect errors in code.They should not fail
167         assert(balanceOf(_from) + balanceOf(_to) == previousBalances);
168 
169     }
170     // data migration
171     function migration(address sender, address receiver) onlyOwner public returns (bool) {
172         require(sender != receiver);
173         bool result= false;
174         // Start data migration
175         // uint256 t_value = balanceOf(receiver);
176         uint256 _value = data.getOldBalanceOf(receiver);
177         //Transfer balance
178         if (data.balanceOf(receiver) == 0) {
179             if (_value > 0) {
180                 _transfer(sender, receiver, _value);
181                 result = true;
182             }
183         }
184         //Frozen account migration
185         if (data.getOldFrozenAccount(receiver)== true) {
186             if (data.frozenAccount(receiver)!= true) {
187                 data.setFrozenAccount(receiver, true);
188             }
189         }
190         //End data migration
191         return result;
192     }
193 
194     // Check the contract token
195     function balanceOf(address addr) constant public returns (uint256) {
196         return data.balanceOf(addr);
197     }
198 
199     function name() constant public returns (string) {
200   	   return data.name();
201   	}
202 
203   	function symbol() constant public returns(string) {
204   	   return data.symbol();
205   	}
206 
207   	function decimals() constant public returns(uint8) {
208   	   return data.decimals();
209   	}
210 
211   	function totalSupply() constant public returns(uint256) {
212   	   return data.totalSupply();
213   	}
214 
215   	function allowance(address authorizer, address sender) constant public returns(uint256) {
216   	   return data.allowance(authorizer, sender);
217   	}
218 
219   	function sellPrice() constant public returns (uint256) {
220   	   return data.sellPrice();
221   	}
222 
223   	function buyPrice() constant public returns (uint256) {
224   	   return data.buyPrice();
225   	}
226 
227   	function frozenAccount(address addr) constant public returns(bool) {
228   	   return data.frozenAccount(addr);
229   	}
230 
231     //Modify the contract
232     function setBalanceOf(address addr, uint256 value) onlyOwner public {
233         data.setBalanceOfAddr(addr, value);
234     }
235 
236     /**
237      * Pass the token
238      * send a value token to your account
239     */
240     function transfer(address sender, address _to, uint256 _value) onlyOwner public returns (bool) {
241         _transfer(sender, _to, _value);
242         return true;
243     }
244 
245     /**
246      *Passing tokens from other addresses
247       *
248       * sends the value token to "to", representing "from"
249       *
250       * @param _from sender's address
251       * @param _to recipient's address
252       * @param _value number sent
253      */
254     function transferFrom(address _from, address sender, address _to, uint256 _value) onlyOwner public returns (bool success) {
255         uint256 a_value = data.allowance(_from, sender);
256         require(_value <=_value ); // Check allowance
257         data.setAllowance(_from, sender, a_value - _value);
258         _transfer(_from, _to, _value);
259         return true;
260     }
261 
262      /**
263 * set allowances for other addresses
264 *
265 * allow the "spender" to spend only the "value" card in your name
266 *
267 * @param _spender authorized address
268 * @param _value they can spend the most money
269      */
270     function approve(address _spender, address sender, uint256 _value) onlyOwner public returns (bool success) {
271         data.setAllowance(sender, _spender, _value);
272         return true;
273     }
274 
275     /**
276      * Grant and notify other addresses
277        *
278        * allow "spender" to only mark "value" in your name and then write the contract on it.
279        *
280        * @param _spender authorized address
281        * @param _value they can spend the most money
282        * @param _extraData sends some additional information to the approved contract
283      */
284     function approveAndCall(address _spender, address sender, address _contract, uint256 _value, bytes _extraData) onlyOwner public returns (bool success) {
285         tokenRecipient spender = tokenRecipient(_spender);
286         if (approve(_spender, sender, _value)) {
287             spender.receiveApproval(sender, _value, _contract, _extraData);
288             return true;
289         }
290     }
291 
292      /**
293      * Destroy the tokens,
294        *
295        * delete "value" tokens from the system
296        *
297        * param _value the amount of money to burn
298      */
299     function burn(address sender, uint256 _value) onlyOwner public returns (bool success) {
300         uint256 f_value = balanceOf(sender);
301         require(f_value >= _value);                 // Check that the sender is adequate
302         setBalanceOf(sender, f_value - _value);    // Minus from the sender
303         data.addTotalSupply(totalSupply() - _value);                      // Renewal aggregate supply
304         return true;
305     }
306 
307     /**
308      * Destroy tokens from other accounts
309        *
310        * delete "value" tokens from "from" in the system.
311        *
312        * @param _from the address of the sender
313        * param _value the amount of money to burn
314      */
315     function burnFrom(address _from, address sender, uint256 _value) onlyOwner public returns (bool success) {
316         uint256 f_value = balanceOf(sender);
317         uint256 a_value = data.allowance(_from, sender);
318         require(f_value >= _value);                             // Check that the target balance is adequate
319         require(_value <= a_value);                             // Check the allowance
320         setBalanceOf(_from, f_value - _value);                // Subtract from the goal balance
321         data.setAllowance(_from, sender, f_value - _value);  // Minus the sender's allowance
322         data.addTotalSupply(totalSupply() - _value);         // update totalSupply
323 
324         return true;
325     }
326 
327     //@ notifies you to create the mintedAmount token and send it to the target
328       // @param target address receiving token
329       // @param mintedAmount will receive the number of tokens
330     function mintToken(address target, address _contract, uint256 mintedAmount) onlyOwner public {
331         uint256 f_value = balanceOf(target);
332         setBalanceOf(target, f_value + mintedAmount);
333         data.addTotalSupply(totalSupply() + mintedAmount);
334 
335     }
336 
337     //Notice freezes the account to prevent "target" from sending and receiving tokens
338       // @param target address is frozen
339       // @param freezes or does not freeze
340     function freezeAccount(address target, bool freeze) onlyOwner public returns (bool) {
341         data.setFrozenAccount(target, freeze);
342         return true;
343 
344     }
345 
346     // Notice of purchase of tokens by sending ether
347     function buy(address _contract, address sender, uint256 value) payable public {
348         require(false);
349         uint amount = value / data.buyPrice();        // Calculate the purchase amount
350         _transfer(_contract, sender, amount);              // makes the transfers
351     }
352     // @notice to sell the amount token
353     // @param amount
354     function sell(address _contract, address sender, uint256 amount) public {
355         require(false);
356         require(address(_contract).balance >= amount * data.sellPrice());      // Check if there is enough ether in the contract
357         _transfer(sender, _contract, amount);              // makes the transfers
358         sender.transfer(amount * data.sellPrice());          // Shipping ether to the seller.This is important to avoid recursive attacks
359     }
360 
361 }
362 
363 
364 
365 contract BitSTDView {
366 
367 	BitSTDLogic private logic;
368 	address public owner;
369 
370     // This creates a public event on the blockchain that notifies the customer
371     event Transfer(address indexed from, address indexed to, uint256 value);
372     event FrozenFunds(address target, bool frozen);
373 
374     // This tells the customer how much money is being burned
375     event Burn(address indexed from, uint256 value);
376 
377 	//start Query data interface
378     function balanceOf(address add)constant  public returns (uint256) {
379 	    return logic.balanceOf(add);
380 	}
381 
382 	function name() constant  public returns (string) {
383 	    return logic.name();
384 	}
385 
386 	function symbol() constant  public returns (string) {
387 	    return logic.symbol();
388 	}
389 
390 	function decimals() constant  public returns (uint8) {
391 	    return logic.decimals();
392 	}
393 
394 	function totalSupply() constant  public returns (uint256) {
395 	    return logic.totalSupply();
396 	}
397 
398 	function allowance(address authorizer, address sender) constant  public returns (uint256) {
399 	    return logic.allowance(authorizer, sender);
400 	}
401 
402 	function sellPrice() constant  public returns (uint256) {
403 	    return logic.sellPrice();
404 	}
405 
406 	function buyPrice() constant  public returns (uint256) {
407 	    return logic.buyPrice();
408 	}
409 
410 	function frozenAccount(address addr) constant  public returns (bool) {
411 	    return logic.frozenAccount(addr);
412 	}
413 
414 	//End Query data interface
415 
416 	//initialize
417     constructor(address logicAddressr) public {
418         logic=BitSTDLogic(logicAddressr);
419         owner=msg.sender;
420     }
421 
422     //start Authority and control
423     modifier onlyOwner(){
424 		require(msg.sender == owner);
425         _;
426 	}
427 
428 	//Update the address of the data and logic layer
429     function setBitSTD(address dataAddress,address logicAddressr) onlyOwner public{
430         logic=BitSTDLogic(logicAddressr);
431         logic.setData(dataAddress);
432     }
433 
434     //Hand over the logical layer authority
435     function transferLogicAuthority(address newOwner) onlyOwner public{
436         logic.transferAuthority(newOwner);
437     }
438 
439     //Hand over the data layer authority
440     function transferDataAuthority(address newOwner) onlyOwner public{
441         logic.transferDataAuthority(newOwner);
442     }
443 
444     //Hand over the view layer authority
445     function transferAuthority(address newOwner) onlyOwner public{
446         owner=newOwner;
447     }
448     //End Authority and control
449 
450     //data migration
451     function migration(address addr) public {
452         if (logic.migration(msg.sender, addr) == true) {
453             emit Transfer(msg.sender, addr,logic.getOldBalanceOf(addr));
454         }
455     }
456 
457     /**
458      * Transfer tokens
459      *
460      * Send `_value` tokens to `_to` from your account
461      *
462      * @param _to The address of the recipient
463      * @param _value the amount to send
464      */
465 	function transfer(address _to, uint256 _value) public {
466 	    if (logic.transfer(msg.sender, _to, _value) == true) {
467 	        emit Transfer(msg.sender, _to, _value);
468 	    }
469 	}
470 
471 	/**
472      * Transfer tokens from other address
473      *
474      * Send `_value` tokens to `_to` in behalf of `_from`
475      *
476      * @param _from The address of the sender
477      * @param _to The address of the recipient
478      * @param _value the amount to send
479      */
480 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
481 	    if (logic.transferFrom(_from, msg.sender, _to, _value) == true) {
482 	        emit Transfer(_from, _to, _value);
483 	        return true;
484 	    }
485 	}
486 
487 	/**
488      * Set allowance for other address
489      *
490      * Allows `_spender` to spend no more than `_value` tokens in your behalf
491      *
492      * @param _spender The address authorized to spend
493      * @param _value the max amount they can spend
494      */
495 	function approve(address _spender, uint256 _value) public returns (bool success) {
496 	    return logic.approve( _spender, msg.sender,  _value);
497 	}
498 
499 	/**
500      * Set allowance for other address and notify
501      *
502      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
503      *
504      * @param _spender The address authorized to spend
505      * @param _value the max amount they can spend
506      * @param _extraData some extra information to send to the approved contract
507      */
508 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
509 	    return logic.approveAndCall(_spender, msg.sender, this, _value, _extraData);
510 	}
511 
512 	/**
513      * Destroy tokens
514      *
515      * Remove `_value` tokens from the system irreversibly
516      *
517      * @param _value the amount of money to burn
518      */
519 	function burn(uint256 _value) public returns (bool success) {
520 	    if (logic.burn(msg.sender, _value) == true) {
521 	        emit Burn(msg.sender, _value);
522 	        return true;
523 	    }
524 	}
525 
526 	/**
527      * Destroy tokens from other account
528      *
529      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
530      *
531      * @param _from the address of the sender
532      * @param _value the amount of money to burn
533      */
534 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
535 	    if (logic.burnFrom( _from, msg.sender, _value) == true) {
536 	        emit Burn(_from, _value);
537 	        return true;
538 	    }
539 	}
540 
541 	/// @notice Create `mintedAmount` tokens and send it to `target`
542     /// @param target Address to receive the tokens
543     /// @param mintedAmount the amount of tokens it will receive
544 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
545 	    logic.mintToken(target, this,  mintedAmount);
546 	    emit Transfer(0, this, mintedAmount);
547         emit Transfer(this, target, mintedAmount);
548 	}
549 
550 	/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
551     /// @param target Address to be frozen
552     /// @param freeze either to freeze it or not
553 	function freezeAccount(address target, bool freeze) onlyOwner public {
554 	    if (logic.freezeAccount(target,  freeze) == true) {
555 	        emit FrozenFunds(target, freeze);
556 	    }
557 	}
558 
559 	//The next two are buying and selling tokens
560 	function buy() payable public {
561 	    logic.buy(this, msg.sender, msg.value);
562 	}
563 
564 	function sell(uint256 amount) public {
565 	    logic.sell(this,msg.sender, amount);
566 	}
567 }