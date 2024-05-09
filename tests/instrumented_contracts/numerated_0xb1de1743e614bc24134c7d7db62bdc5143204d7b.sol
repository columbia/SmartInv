1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 }
55 
56 library SafeMath {
57 
58   /**
59   * @dev Multiplies two numbers, throws on overflow.
60   */
61   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
62     if (a == 0) {
63       return 0;
64     }
65     c = a * b;
66     assert(c / a == b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     // uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return a / b;
78   }
79 
80   /**
81   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
92     c = a + b;
93     assert(c >= a);
94     return c;
95   }
96 }
97 
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender)
100     public view returns (uint256);
101 
102   function transferFrom(address from, address to, uint256 value)
103     public returns (bool);
104 
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(
107     address indexed owner,
108     address indexed spender,
109     uint256 value
110   );
111 }
112 
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(
165     address _from,
166     address _to,
167     uint256 _value
168   )
169     public
170     returns (bool)
171   {
172     require(_to != address(0));
173     require(_value <= balances[_from]);
174     require(_value <= allowed[_from][msg.sender]);
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     emit Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    *
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     emit Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(
206     address _owner,
207     address _spender
208    )
209     public
210     view
211     returns (uint256)
212   {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217    * @dev Increase the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To increment
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _addedValue The amount of tokens to increase the allowance by.
225    */
226   function increaseApproval(
227     address _spender,
228     uint _addedValue
229   )
230     public
231     returns (bool)
232   {
233     allowed[msg.sender][_spender] = (
234       allowed[msg.sender][_spender].add(_addedValue));
235     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To decrement
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _subtractedValue The amount of tokens to decrease the allowance by.
248    */
249   function decreaseApproval(
250     address _spender,
251     uint _subtractedValue
252   )
253     public
254     returns (bool)
255   {
256     uint oldValue = allowed[msg.sender][_spender];
257     if (_subtractedValue > oldValue) {
258       allowed[msg.sender][_spender] = 0;
259     } else {
260       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261     }
262     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266 }
267 
268 contract ERC827 is ERC20 {
269   function approveAndCall(
270     address _spender,
271     uint256 _value,
272     bytes _data
273   )
274     public
275     payable
276     returns (bool);
277 
278   function transferAndCall(
279     address _to,
280     uint256 _value,
281     bytes _data
282   )
283     public
284     payable
285     returns (bool);
286 
287   function transferFromAndCall(
288     address _from,
289     address _to,
290     uint256 _value,
291     bytes _data
292   )
293     public
294     payable
295     returns (bool);
296 }
297 
298 contract ERC827Token is ERC827, StandardToken {
299 
300   /**
301    * @dev Addition to ERC20 token methods. It allows to
302    * @dev approve the transfer of value and execute a call with the sent data.
303    *
304    * @dev Beware that changing an allowance with this method brings the risk that
305    * @dev someone may use both the old and the new allowance by unfortunate
306    * @dev transaction ordering. One possible solution to mitigate this race condition
307    * @dev is to first reduce the spender's allowance to 0 and set the desired value
308    * @dev afterwards:
309    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310    *
311    * @param _spender The address that will spend the funds.
312    * @param _value The amount of tokens to be spent.
313    * @param _data ABI-encoded contract call to call `_to` address.
314    *
315    * @return true if the call function was executed successfully
316    */
317   function approveAndCall(
318     address _spender,
319     uint256 _value,
320     bytes _data
321   )
322     public
323     payable
324     returns (bool)
325   {
326     require(_spender != address(this));
327 
328     super.approve(_spender, _value);
329 
330     // solium-disable-next-line security/no-call-value
331     require(_spender.call.value(msg.value)(_data));
332 
333     return true;
334   }
335 
336   /**
337    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
338    * @dev address and execute a call with the sent data on the same transaction
339    *
340    * @param _to address The address which you want to transfer to
341    * @param _value uint256 the amout of tokens to be transfered
342    * @param _data ABI-encoded contract call to call `_to` address.
343    *
344    * @return true if the call function was executed successfully
345    */
346   function transferAndCall(
347     address _to,
348     uint256 _value,
349     bytes _data
350   )
351     public
352     payable
353     returns (bool)
354   {
355     require(_to != address(this));
356 
357     super.transfer(_to, _value);
358 
359     // solium-disable-next-line security/no-call-value
360     require(_to.call.value(msg.value)(_data));
361     return true;
362   }
363 
364   /**
365    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
366    * @dev another and make a contract call on the same transaction
367    *
368    * @param _from The address which you want to send tokens from
369    * @param _to The address which you want to transfer to
370    * @param _value The amout of tokens to be transferred
371    * @param _data ABI-encoded contract call to call `_to` address.
372    *
373    * @return true if the call function was executed successfully
374    */
375   function transferFromAndCall(
376     address _from,
377     address _to,
378     uint256 _value,
379     bytes _data
380   )
381     public payable returns (bool)
382   {
383     require(_to != address(this));
384 
385     super.transferFrom(_from, _to, _value);
386 
387     // solium-disable-next-line security/no-call-value
388     require(_to.call.value(msg.value)(_data));
389     return true;
390   }
391 
392   /**
393    * @dev Addition to StandardToken methods. Increase the amount of tokens that
394    * @dev an owner allowed to a spender and execute a call with the sent data.
395    *
396    * @dev approve should be called when allowed[_spender] == 0. To increment
397    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
398    * @dev the first transaction is mined)
399    * @dev From MonolithDAO Token.sol
400    *
401    * @param _spender The address which will spend the funds.
402    * @param _addedValue The amount of tokens to increase the allowance by.
403    * @param _data ABI-encoded contract call to call `_spender` address.
404    */
405   function increaseApprovalAndCall(
406     address _spender,
407     uint _addedValue,
408     bytes _data
409   )
410     public
411     payable
412     returns (bool)
413   {
414     require(_spender != address(this));
415 
416     super.increaseApproval(_spender, _addedValue);
417 
418     // solium-disable-next-line security/no-call-value
419     require(_spender.call.value(msg.value)(_data));
420 
421     return true;
422   }
423 
424   /**
425    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
426    * @dev an owner allowed to a spender and execute a call with the sent data.
427    *
428    * @dev approve should be called when allowed[_spender] == 0. To decrement
429    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
430    * @dev the first transaction is mined)
431    * @dev From MonolithDAO Token.sol
432    *
433    * @param _spender The address which will spend the funds.
434    * @param _subtractedValue The amount of tokens to decrease the allowance by.
435    * @param _data ABI-encoded contract call to call `_spender` address.
436    */
437   function decreaseApprovalAndCall(
438     address _spender,
439     uint _subtractedValue,
440     bytes _data
441   )
442     public
443     payable
444     returns (bool)
445   {
446     require(_spender != address(this));
447 
448     super.decreaseApproval(_spender, _subtractedValue);
449 
450     // solium-disable-next-line security/no-call-value
451     require(_spender.call.value(msg.value)(_data));
452 
453     return true;
454   }
455 
456 }
457 
458 contract TucToken is ERC827Token, Ownable {
459 
460     mapping(address => uint256) preApprovedBalances;
461     mapping(address => bool) approvedAccounts;
462 
463     address admin1;
464     address admin2;
465 
466     address public accountPubICOSale;
467     uint8 public decimals;
468 	string public name;
469 	string public symbol;
470 	
471 	uint constant pubICOStartsAt = 1541030400; // 1.11.2018 = 1541030400
472 
473     modifier onlyKycTeam {
474         require(msg.sender == admin1 || msg.sender == admin2);
475         _;
476     }
477 	
478 	modifier PubICOstarted {
479 		require(now >= pubICOStartsAt );
480 		_;
481 	}
482 
483     /**
484      * @dev Create new TUC token contract.
485      *
486      * @param _accountFounder The account for the found tokens that receives 1,024,000,000 tokens on creation.
487      * @param _accountPrivPreSale The account for the private pre-sale tokens that receives 1,326,000,000 tokens on creation.
488      * @param _accountPubPreSale The account for the public pre-sale tokens that receives 1,500,000,000 tokens on creation.
489      * @param _accountPubICOSale The account for the public pre-sale tokens that receives 4,150,000,000 tokens on creation.
490 	 * @param _accountSalesMgmt The account for the Sales Management tokens that receives 2,000,000,000 tokens on creation.
491      * @param _accountTucWorld The account for the TUC World tokens that receives 2,000.000,000 tokens on creation.
492      */
493     constructor (
494         address _admin1,
495         address _admin2,
496 		address _accountFounder,
497 		address _accountPrivPreSale,
498 		address _accountPubPreSale,
499         address _accountPubICOSale,
500 		address _accountSalesMgmt,
501 		address _accountTucWorld
502 		)
503     public 
504     payable
505     {
506         admin1 = _admin1;
507         admin2 = _admin2;
508         accountPubICOSale = _accountPubICOSale;
509         decimals = 18; // 10**decimals=1000000000000000000
510 		totalSupply_ = 12000000000000000000000000000;
511 		 
512 		balances[_accountFounder]     = 1024000000000000000000000000 ; // 1024000000 * 10**(decimals);
513         balances[_accountPrivPreSale] = 1326000000000000000000000000 ; // 1326000000 * 10**(decimals);
514         balances[_accountPubPreSale]  = 1500000000000000000000000000 ; // 1500000000 * 10**(decimals);
515 		balances[_accountPubICOSale]  = 4150000000000000000000000000 ; // 4150000000 * 10**(decimals);
516         balances[_accountSalesMgmt]   = 2000000000000000000000000000 ; // 2000000000 * 10**(decimals);
517         balances[_accountTucWorld]    = 2000000000000000000000000000 ; // 2000000000 * 10**(decimals);
518 		emit Transfer(0, _accountFounder, 		balances[_accountFounder]);
519 		emit Transfer(0, _accountPrivPreSale, 	balances[_accountPrivPreSale]);
520 		emit Transfer(0, _accountPubPreSale, 	balances[_accountPubPreSale]);
521 		emit Transfer(0, _accountPubICOSale, 	balances[_accountPubICOSale]);
522 		emit Transfer(0, _accountSalesMgmt, 	balances[_accountSalesMgmt]);
523 		emit Transfer(0, _accountTucWorld, 		balances[_accountTucWorld]);
524 		
525 		name = "TUC.World";
526 		symbol = "TUC";
527     }
528 
529     /** 
530      * @dev During the public ICO users can buy TUC tokens by sending ETH to this method.
531      * @dev The price per token is fixed to 0.00000540 ETH / TUC.
532      *
533      * @dev The buyer will receive his tokens after successful KYC approval by the TUC team. In case KYC is refused,
534      * @dev the send ETH funds are send back to the buyer and no TUC tokens will be delivered.
535      */
536     function buyToken()
537     payable
538     external
539 	PubICOstarted
540     {
541         uint256 tucAmount = (msg.value * 1000000000000000000) / 5400000000000;
542         require(balances[accountPubICOSale] >= tucAmount);
543 		
544         if (approvedAccounts[msg.sender]) {
545             // already kyc approved
546             balances[msg.sender] += tucAmount;
547 			emit Transfer(accountPubICOSale, msg.sender, tucAmount);
548         } else {
549             // not kyc approved
550             preApprovedBalances[msg.sender] += tucAmount;
551         }
552         balances[accountPubICOSale] -= tucAmount;
553     }
554 
555     /**
556      * @dev Approve KYC of a user, who contributed in ETH.
557      * @dev Deliver the tokens to the user's account and move the ETH balance to the TUC contract.
558      *
559      * @param _user The account of the user to approve KYC.
560      */
561     function kycApprove(address _user)
562     external
563     onlyKycTeam
564     {
565         // account is approved
566         approvedAccounts[_user] = true;
567         // move balance for this account to "real" balances
568         balances[_user] += preApprovedBalances[_user];
569         // account has no more "unapproved" balance
570         preApprovedBalances[_user] = 0;
571 		emit Transfer(accountPubICOSale, _user, balances[_user]);
572     }
573 
574     /**
575      * @dev Refusing KYC of a user, who contributed in ETH.
576      * @dev Send back the ETH funds and deny delivery of TUC tokens.
577      *
578      * @param _user The account of the user to refuse KYC.
579      */
580     function kycRefuse(address _user)
581     external
582     onlyKycTeam
583     {
584 		require(approvedAccounts[_user] == false);
585         uint256 tucAmount = preApprovedBalances[_user];
586         uint256 weiAmount = (tucAmount * 5400000000000) / 1000000000000000000;
587         // account is not approved now
588         approvedAccounts[_user] = false;
589         // pubPreSale gets back its tokens
590         balances[accountPubICOSale] += tucAmount;
591         // user has no more balance
592         preApprovedBalances[_user] = 0;
593         // we transfer the eth back to the user that were used to buy the tokens
594         _user.transfer(weiAmount);
595     }
596 
597     /**
598      * @dev Retrieve ETH from the contract.
599      *
600      * @dev The contract owner can use this method to transfer received ETH to another wallet.
601      *
602      * @param _safe The address of the wallet the funds should get transferred to.
603      * @param _value The amount of ETH to transfer.
604      */
605     function retrieveEth(address _safe, uint256 _value)
606     external
607     onlyOwner
608     {
609         _safe.transfer(_value);
610     }
611 }