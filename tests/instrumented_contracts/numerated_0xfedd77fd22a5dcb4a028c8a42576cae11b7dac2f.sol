1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 /**
29  * @title Basic token
30  * @dev Basic version of StandardToken, with no allowances.
31  */
32 contract BasicToken is ERC20Basic {
33   using SafeMath for uint256;
34 
35   mapping(address => uint256) balances;
36 
37   uint256 totalSupply_;
38 
39   /**
40   * @dev total number of tokens in existence
41   */
42   function totalSupply() public view returns (uint256) {
43     return totalSupply_;
44   }
45 
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value <= balances[msg.sender]);
54 
55     // SafeMath.sub will throw if there is not enough balance.
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     emit Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62   /**
63   * @dev Gets the balance of the specified address.
64   * @param _owner The address to query the the balance of.
65   * @return An uint256 representing the amount owned by the passed address.
66   */
67   function balanceOf(address _owner) public view returns (uint256 balance) {
68     return balances[_owner];
69   }
70 
71 }
72 
73 /**
74  * @title Standard ERC20 token
75  *
76  * @dev Implementation of the basic standard token.
77  * @dev https://github.com/ethereum/EIPs/issues/20
78  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
79  */
80 contract StandardToken is ERC20, BasicToken {
81 
82   mapping (address => mapping (address => uint256)) internal allowed;
83 
84 
85   /**
86    * @dev Transfer tokens from one address to another
87    * @param _from address The address which you want to send tokens from
88    * @param _to address The address which you want to transfer to
89    * @param _value uint256 the amount of tokens to be transferred
90    */
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[_from]);
94     require(_value <= allowed[_from][msg.sender]);
95 
96     balances[_from] = balances[_from].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99     emit Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   /**
104    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
105    *
106    * Beware that changing an allowance with this method brings the risk that someone may use both the old
107    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
108    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
109    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110    * @param _spender The address which will spend the funds.
111    * @param _value The amount of tokens to be spent.
112    */
113   function approve(address _spender, uint256 _value) public returns (bool) {
114     allowed[msg.sender][_spender] = _value;
115     emit Approval(msg.sender, _spender, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Function to check the amount of tokens that an owner allowed to a spender.
121    * @param _owner address The address which owns the funds.
122    * @param _spender address The address which will spend the funds.
123    * @return A uint256 specifying the amount of tokens still available for the spender.
124    */
125   function allowance(address _owner, address _spender) public view returns (uint256) {
126     return allowed[_owner][_spender];
127   }
128 
129   /**
130    * @dev Increase the amount of tokens that an owner allowed to a spender.
131    *
132    * approve should be called when allowed[_spender] == 0. To increment
133    * allowed value is better to use this function to avoid 2 calls (and wait until
134    * the first transaction is mined)
135    * From MonolithDAO Token.sol
136    * @param _spender The address which will spend the funds.
137    * @param _addedValue The amount of tokens to increase the allowance by.
138    */
139   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
140     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
141     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142     return true;
143   }
144 
145   /**
146    * @dev Decrease the amount of tokens that an owner allowed to a spender.
147    *
148    * approve should be called when allowed[_spender] == 0. To decrement
149    * allowed value is better to use this function to avoid 2 calls (and wait until
150    * the first transaction is mined)
151    * From MonolithDAO Token.sol
152    * @param _spender The address which will spend the funds.
153    * @param _subtractedValue The amount of tokens to decrease the allowance by.
154    */
155   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
156     uint oldValue = allowed[msg.sender][_spender];
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166 }
167 
168 /**
169  * @title SafeMath
170  * @dev Math operations with safety checks that throw on error
171  */
172 library SafeMath {
173 
174   /**
175   * @dev Multiplies two numbers, throws on overflow.
176   */
177   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178     if (a == 0) {
179       return 0;
180     }
181     uint256 c = a * b;
182     assert(c / a == b);
183     return c;
184   }
185 
186   /**
187   * @dev Integer division of two numbers, truncating the quotient.
188   */
189   function div(uint256 a, uint256 b) internal pure returns (uint256) {
190     // assert(b > 0); // Solidity automatically throws when dividing by 0
191     uint256 c = a / b;
192     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193     return c;
194   }
195 
196   /**
197   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
198   */
199   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200     assert(b <= a);
201     return a - b;
202   }
203 
204   /**
205   * @dev Adds two numbers, throws on overflow.
206   */
207   function add(uint256 a, uint256 b) internal pure returns (uint256) {
208     uint256 c = a + b;
209     assert(c >= a);
210     return c;
211   }
212 }
213 
214 /**
215  * @title Ownable
216  * @dev The Ownable contract has an owner address, and provides basic authorization control
217  * functions, this simplifies the implementation of "user permissions".
218  */
219 contract Ownable {
220   address public owner;
221 
222 
223   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225 
226   /**
227    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
228    * account.
229    */
230   function Ownable() public {
231     owner = msg.sender;
232   }
233 
234   /**
235    * @dev Throws if called by any account other than the owner.
236    */
237   modifier onlyOwner() {
238     require(msg.sender == owner);
239     _;
240   }
241 
242   /**
243    * @dev Allows the current owner to transfer control of the contract to a newOwner.
244    * @param newOwner The address to transfer ownership to.
245    */
246   function transferOwnership(address newOwner) public onlyOwner {
247     require(newOwner != address(0));
248     emit OwnershipTransferred(owner, newOwner);
249     owner = newOwner;
250   }
251 
252 }
253 
254 
255 contract ExchangeRate is Ownable {
256 
257   event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
258 
259   mapping(bytes32 => uint) public rates;
260 
261   /**
262    * @dev Allows the current owner to update a single rate.
263    * @param _symbol The symbol to be updated. 
264    * @param _rate the rate for the symbol. 
265    */
266   function updateRate(string _symbol, uint _rate) public onlyOwner {
267     rates[keccak256(_symbol)] = _rate;
268     emit RateUpdated(now, keccak256(_symbol), _rate);
269   }
270 
271   /**
272    * @dev Allows the current owner to update multiple rates.
273    * @param data an array that alternates sha3 hashes of the symbol and the corresponding rate . 
274    */
275   function updateRates(uint[] data) public onlyOwner {
276     
277     require(data.length % 2 <= 0);      
278     uint i = 0;
279     while (i < data.length / 2) {
280       bytes32 symbol = bytes32(data[i * 2]);
281       uint rate = data[i * 2 + 1];
282       rates[symbol] = rate;
283       emit RateUpdated(now, symbol, rate);
284       i++;
285     }
286   }
287 
288   /**
289    * @dev Allows the anyone to read the current rate.
290    * @param _symbol the symbol to be retrieved. 
291    */
292   function getRate(string _symbol) public constant returns(uint) {
293     return rates[keccak256(_symbol)];
294   }
295 
296 }
297 
298 
299 /**
300  * @title Mintable token
301  * @dev Simple ERC20 Token example, with mintable token creation
302  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
303  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
304  */
305 contract MintableToken is StandardToken, Ownable {
306   event Mint(address indexed to, uint256 amount);
307   event MintFinished();
308 
309   bool public mintingFinished = false;
310 
311 
312   modifier canMint() {
313     require(!mintingFinished);
314     _;
315   }
316 
317   /**
318    * @dev Function to mint tokens
319    * @param _to The address that will receive the minted tokens.
320    * @param _amount The amount of tokens to mint.
321    * @return A boolean that indicates if the operation was successful.
322    */
323   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
324     totalSupply_ = totalSupply_.add(_amount);
325     balances[_to] = balances[_to].add(_amount);
326     emit Mint(_to, _amount);
327     emit Transfer(address(0), _to, _amount);
328     return true;
329   }
330 
331   /**
332    * @dev Function to stop minting new tokens.
333    * @return True if the operation was successful.
334    */
335   function finishMinting() onlyOwner canMint public returns (bool) {
336     mintingFinished = true;
337     emit MintFinished();
338     return true;
339   }
340 }
341 
342 
343 
344 
345 contract SmartCoinFerma is MintableToken {
346     
347   string public constant name = "Smart Coin Ferma";
348    
349   string public constant symbol = "SCF";
350     
351   uint32 public constant decimals = 8;
352 
353   HoldersList public list = new HoldersList();
354  
355   bool public tradingStarted = true;
356 
357  
358    /**
359    * @dev modifier that throws if trading has not started yet
360    */
361   modifier hasStartedTrading() {
362     require(tradingStarted);
363     _;
364   } 
365 
366   /**
367    * @dev Allows the owner to enable the trading. This can not be undone
368    */
369   function startTrading() public onlyOwner {
370     tradingStarted = true;
371   }
372 
373    /**
374    * @dev Allows anyone to transfer the PAY tokens once trading has started
375    * @param _to the recipient address of the tokens. 
376    * @param _value number of tokens to be transfered. 
377    */
378   function transfer(address _to, uint _value) hasStartedTrading  public returns (bool) {
379     
380     
381     require(super.transfer(_to, _value) == true);
382     list.changeBalance( msg.sender, balances[msg.sender]);
383     list.changeBalance( _to, balances[_to]);
384     
385     return true;
386   }
387 
388      /**
389    * @dev Allows anyone to transfer the PAY tokens once trading has started
390    * @param _from address The address which you want to send tokens from
391    * @param _to address The address which you want to transfer to
392    * @param _value uint the amout of tokens to be transfered
393    */
394   function transferFrom(address _from, address _to, uint _value)  public returns (bool) {
395    
396     
397     require (super.transferFrom(_from, _to, _value) == true);
398     list.changeBalance( _from, balances[_from]);
399     list.changeBalance( _to, balances[_to]);
400     
401     return true;
402   }
403   function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
404      require(super.mint(_to, _amount) == true); 
405      list.changeBalance( _to, balances[_to]);
406      list.setTotal(totalSupply_);
407      return true;
408   }
409   
410   
411   
412 }
413 
414 contract HoldersList is Ownable{
415    uint256 public _totalTokens;
416    
417    struct TokenHolder {
418         uint256 balance;
419         uint       regTime;
420         bool isValue;
421     }
422     
423     mapping(address => TokenHolder) holders;
424     address[] public payees;
425     
426     function changeBalance(address _who, uint _amount)  public onlyOwner {
427         
428             holders[_who].balance = _amount;
429             if (notInArray(_who)){
430                 payees.push(_who);
431                 holders[_who].regTime = now;
432                 holders[_who].isValue = true;
433             }
434             
435         //}
436     }
437     function notInArray(address _who) internal view returns (bool) {
438         if (holders[_who].isValue) {
439             return false;
440         }
441         return true;
442     }
443     
444   /**
445    * @dev Defines number of issued tokens. 
446    */
447   
448     function setTotal(uint _amount) public onlyOwner {
449       _totalTokens = _amount;
450   }
451   
452   /**
453    * @dev Returnes number of issued tokens.
454    */
455   
456    function getTotal() public constant returns (uint)  {
457      return  _totalTokens;
458   }
459   
460   /**
461    * @dev Returnes holders balance.
462    
463    */
464   function returnBalance (address _who) public constant returns (uint){
465       uint _balance;
466       
467       _balance= holders[_who].balance;
468       return _balance;
469   }
470   
471   
472   /**
473    * @dev Returnes number of holders in array.
474    
475    */
476   function returnPayees () public constant returns (uint){
477       uint _ammount;
478       
479       _ammount= payees.length;
480       return _ammount;
481   }
482   
483   
484   /**
485    * @dev Returnes holders address.
486    
487    */
488   function returnHolder (uint _num) public constant returns (address){
489       address _addr;
490       
491       _addr= payees[_num];
492       return _addr;
493   }
494   
495   /**
496    * @dev Returnes registration date of holder.
497    
498    */
499   function returnRegDate (address _who) public constant returns (uint){
500       uint _redData;
501       
502       _redData= holders[_who].regTime;
503       return _redData;
504   }
505     
506 }
507 
508 
509 contract Crowdsale is Ownable {
510   using SafeMath for uint;
511   event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
512   event AuthorizedCreate(address recipient, uint pay_amount);
513   
514 
515   SmartCoinFerma public token = new SmartCoinFerma();
516 
517 
518      
519   //prod
520   address multisigVaultFirst = 0xAD7C50cfeb60B6345cb428c5820eD073f35283e7;
521   address multisigVaultSecond = 0xA9B04eF1901A0d720De14759bC286eABC344b3BA;
522   address multisigVaultThird = 0xF1678Cc0727b354a9B0612dd40D275a3BBdE5979;
523   
524   uint restrictedPercent = 50;
525   
526  
527   bool pause = false;
528   
529   
530   
531   //prod
532   address restricted = 0x217d44b5c4bffC5421bd4bb9CC85fBf61d3fbdb6;
533   address restrictedAdditional = 0xF1678Cc0727b354a9B0612dd40D275a3BBdE5979;
534   
535   ExchangeRate exchangeRate;
536 
537   
538   uint public start = 1523491200; 
539   uint period = 365;
540   uint _rate;
541 
542   /**
543    * @dev modifier to allow token creation only when the sale IS ON
544    */
545   modifier saleIsOn() {
546     require(now >= start && now < start + period * 1 days);
547     require(pause!=true);
548     _;
549   }
550     
551     /**
552    * @dev Allows owner to pause the crowdsale
553    */
554     function setPause( bool _newPause ) onlyOwner public {
555         pause = _newPause;
556     }
557 
558 
559    /**
560    * @dev Allows anyone to create tokens by depositing ether.
561    * @param recipient the recipient to receive tokens. 
562    */
563   function createTokens(address recipient) saleIsOn payable {
564     uint256 sum;
565     uint256 halfSum;  
566     uint256 quatSum; 
567     uint256 rate;
568     uint256 tokens;
569     uint256 restrictedTokens;
570    
571     uint256 tok1;
572     uint256 tok2;
573     
574     
575     
576     require( msg.value > 0 );
577     sum = msg.value;
578     halfSum = sum.div(2);
579     quatSum = halfSum.div(2);
580     rate = exchangeRate.getRate("ETH"); 
581     tokens = rate.mul(sum).div(1 ether);
582     require( tokens > 0 );
583     
584     token.mint(recipient, tokens);
585     
586     
587     multisigVaultFirst.transfer(halfSum);
588     multisigVaultSecond.transfer(quatSum);
589     multisigVaultThird.transfer(quatSum);
590     /*
591     * "dev Create restricted tokens
592     */
593     restrictedTokens = tokens.mul(restrictedPercent).div(100 - restrictedPercent);
594     tok1 = restrictedTokens.mul(60).div(100);
595     tok2 = restrictedTokens.mul(40).div(100);
596     require (tok1 + tok2==restrictedTokens );
597     
598     token.mint(restricted, tok1);
599     token.mint(restrictedAdditional, tok2);
600     
601     
602     emit TokenSold(recipient, msg.value, tokens, rate);
603   }
604 
605     /**
606    * @dev Allows the owner to set the starting time.
607    * @param _start the new _start
608    */
609   function setStart(uint _start) public onlyOwner {
610     start = _start;
611   }
612 
613     /**
614    * @dev Allows the owner to set the exchangerate contract.
615    * @param _exchangeRate the exchangerate address
616    */
617   function setExchangeRate(address _exchangeRate) public onlyOwner {
618     exchangeRate = ExchangeRate(_exchangeRate);
619   }
620 
621 
622   /**
623    * @dev Allows the owner to finish the minting. This will create the 
624    * restricted tokens and then close the minting.
625    * Then the ownership of the PAY token contract is transfered 
626    * to this owner.
627    */
628   function finishMinting() public onlyOwner {
629     //uint issuedTokenSupply = token.totalSupply();
630     //uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
631     //token.mint(multisigVault, restrictedTokens);
632     token.finishMinting();
633     token.transferOwnership(owner);
634     }
635 
636   /**
637    * @dev Fallback function which receives ether and created the appropriate number of tokens for the 
638    * msg.sender.
639    */
640   function() external payable {
641       createTokens(msg.sender);
642   }
643 
644 }