1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal constant returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61     require(_value <= balances[msg.sender]);
62 
63     // SafeMath.sub will throw if there is not enough balance.
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   /**
71   * @dev Gets the balance of the specified address.
72   * @param _owner The address to query the the balance of.
73   * @return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) public constant returns (uint256 balance) {
76     return balances[_owner];
77   }
78 
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public constant returns (uint256);
87   function transferFrom(address from, address to, uint256 value) public returns (bool);
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    *
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    */
154   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
161     uint oldValue = allowed[msg.sender][_spender];
162     if (_subtractedValue > oldValue) {
163       allowed[msg.sender][_spender] = 0;
164     } else {
165       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166     }
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171 }
172 
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180 
181 
182   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   function Ownable() {
190     owner = msg.sender;
191   }
192 
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) onlyOwner public {
208     require(newOwner != address(0));
209     OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 
215 /////////////////////////////////////////////////////////
216 //////////////// Token contract start////////////////////
217 /////////////////////////////////////////////////////////
218 
219 contract CryptoGripInitiative is StandardToken, Ownable {
220     string  public  constant name = "Crypto Grip Initiative";
221 
222     string  public  constant symbol = "CGI";
223 
224     uint    public  constant decimals = 18;
225 
226     uint    public  saleStartTime;
227 
228     uint    public  saleEndTime;
229 
230     address public  tokenSaleContract;
231 
232     modifier onlyWhenTransferEnabled() {
233         if (now <= saleEndTime && now >= saleStartTime) {
234             require(msg.sender == tokenSaleContract || msg.sender == owner);
235         }
236         _;
237     }
238 
239     modifier validDestination(address to) {
240         require(to != address(0x0));
241         require(to != address(this));
242         _;
243     }
244 
245     function CryptoGripInitiative(uint tokenTotalAmount, uint startTime, uint endTime, address admin) {
246         // Mint all tokens. Then disable minting forever.
247         balances[msg.sender] = tokenTotalAmount;
248         totalSupply = tokenTotalAmount;
249         Transfer(address(0x0), msg.sender, tokenTotalAmount);
250 
251         saleStartTime = startTime;
252         saleEndTime = endTime;
253 
254         tokenSaleContract = msg.sender;
255         transferOwnership(admin);
256         // admin could drain tokens that were sent here by mistake
257     }
258 
259     function transfer(address _to, uint _value)
260     onlyWhenTransferEnabled
261     validDestination(_to)
262     returns (bool) {
263         return super.transfer(_to, _value);
264     }
265 
266     function transferFrom(address _from, address _to, uint _value)
267     onlyWhenTransferEnabled
268     validDestination(_to)
269     returns (bool) {
270         return super.transferFrom(_from, _to, _value);
271     }
272 
273     event Burn(address indexed _burner, uint _value);
274 
275     function burn(uint _value) onlyWhenTransferEnabled
276     returns (bool){
277         balances[msg.sender] = balances[msg.sender].sub(_value);
278         totalSupply = totalSupply.sub(_value);
279         Burn(msg.sender, _value);
280         Transfer(msg.sender, address(0x0), _value);
281         return true;
282     }
283 
284     //    // save some gas by making only one contract call
285     //    function burnFrom(address _from, uint256 _value) onlyWhenTransferEnabled
286     //    returns (bool) {
287     //        assert(transferFrom(_from, msg.sender, _value));
288     //        return burn(_value);
289     //    }
290 
291     function emergencyERC20Drain(ERC20 token, uint amount) onlyOwner {
292         token.transfer(owner, amount);
293     }
294 }
295 
296 
297 /////////////////////////////////////////////////////////
298 /////////////// Whitelist contract start/////////////////
299 /////////////////////////////////////////////////////////
300 
301 
302 contract Whitelist {
303     address public owner;
304 
305     address public sale;
306 
307     mapping (address => uint) public accepted;
308 
309     function Whitelist(address _owner, address _sale) {
310         owner = _owner;
311         sale = _sale;
312     }
313 
314     function accept(address a, uint amountInWei) {
315         assert(msg.sender == owner || msg.sender == sale);
316 
317         accepted[a] = amountInWei * 10 ** 18;
318     }
319 
320     function setSale(address sale_) {
321         assert(msg.sender == owner);
322 
323         sale = sale_;
324     }
325 
326     function getCap(address _user) constant returns (uint) {
327         uint cap = accepted[_user];
328         return cap;
329     }
330 }
331 
332 
333 /////////////////////////////////////////////////////////
334 ///////// Contributor Approver contract start////////////
335 /////////////////////////////////////////////////////////
336 
337 contract ContributorApprover {
338     Whitelist public list;
339 
340     mapping (address => uint)    public participated;
341 
342     uint public presaleStartTime;
343 
344     uint public remainingPresaleCap;
345 
346     uint public remainingPublicSaleCap;
347 
348     uint                      public openSaleStartTime;
349 
350     uint                      public openSaleEndTime;
351 
352     using SafeMath for uint;
353 
354 
355     function ContributorApprover(
356     Whitelist _whitelistContract,
357     uint preIcoCap,
358     uint IcoCap,
359     uint _presaleStartTime,
360     uint _openSaleStartTime,
361     uint _openSaleEndTime) {
362         list = _whitelistContract;
363         openSaleStartTime = _openSaleStartTime;
364         openSaleEndTime = _openSaleEndTime;
365         presaleStartTime = _presaleStartTime;
366         remainingPresaleCap = preIcoCap * 10 ** 18;
367         remainingPublicSaleCap = IcoCap * 10 ** 18;
368 
369         //    Check that presale is earlier than opensale
370         require(presaleStartTime < openSaleStartTime);
371         //    Check that open sale start is earlier than end
372         require(openSaleStartTime < openSaleEndTime);
373     }
374 
375     // this is a seperate function so user could query it before crowdsale starts
376     function contributorCap(address contributor) constant returns (uint) {
377         return list.getCap(contributor);
378     }
379 
380     function eligible(address contributor, uint amountInWei) constant returns (uint) {
381         //        Presale not started yet
382         if (now < presaleStartTime) return 0;
383         //    Both presale and public sale have ended
384         if (now >= openSaleEndTime) return 0;
385 
386         //        Presale
387         if (now < openSaleStartTime) {
388             //        Presale cap limit reached
389             if (remainingPresaleCap <= 0) {
390                 return 0;
391             }
392             //            Get initial cap
393             uint cap = contributorCap(contributor);
394             // Account for already invested amount
395             uint remainedCap = cap.sub(participated[contributor]);
396             //        Presale cap almost reached
397             if (remainedCap > remainingPresaleCap) {
398                 remainedCap = remainingPresaleCap;
399             }
400             //            Remaining cap is bigger than contribution
401             if (remainedCap > amountInWei) return amountInWei;
402             //            Remaining cap is smaller than contribution
403             else return remainedCap;
404         }
405         //        Public sale
406         else {
407             //           Public sale  cap limit reached
408             if (remainingPublicSaleCap <= 0) {
409                 return 0;
410             }
411             //            Public sale cap almost reached
412             if (amountInWei > remainingPublicSaleCap) {
413                 return remainingPublicSaleCap;
414             }
415             //            Public sale cap is bigger than contribution
416             else {
417                 return amountInWei;
418             }
419         }
420     }
421 
422     function eligibleTestAndIncrement(address contributor, uint amountInWei) internal returns (uint) {
423         uint result = eligible(contributor, amountInWei);
424         participated[contributor] = participated[contributor].add(result);
425         //    Presale
426         if (now < openSaleStartTime) {
427             //        Decrement presale cap
428             remainingPresaleCap = remainingPresaleCap.sub(result);
429         }
430         //        Publicsale
431         else {
432             //        Decrement publicsale cap
433             remainingPublicSaleCap = remainingPublicSaleCap.sub(result);
434         }
435 
436         return result;
437     }
438 
439     function saleEnded() constant returns (bool) {
440         return now > openSaleEndTime;
441     }
442 
443     function saleStarted() constant returns (bool) {
444         return now >= presaleStartTime;
445     }
446 
447     function publicSaleStarted() constant returns (bool) {
448         return now >= openSaleStartTime;
449     }
450 }
451 
452 
453 /////////////////////////////////////////////////////////
454 ///////// Token Sale contract start /////////////////////
455 /////////////////////////////////////////////////////////
456 
457 contract CryptoGripTokenSale is ContributorApprover {
458     uint    public  constant tokensPerEthPresale = 1055;
459 
460     uint    public  constant tokensPerEthPublicSale = 755;
461 
462     address             public admin;
463 
464     address             public gripWallet;
465 
466     CryptoGripInitiative public token;
467 
468     uint                public raisedWei;
469 
470     bool                public haltSale;
471 
472     function CryptoGripTokenSale(address _admin,
473     address _gripWallet,
474     Whitelist _whiteListContract,
475     uint _totalTokenSupply,
476     uint _premintedTokenSupply,
477     uint _presaleStartTime,
478     uint _publicSaleStartTime,
479     uint _publicSaleEndTime,
480     uint _presaleCap,
481     uint _publicSaleCap)
482 
483     ContributorApprover(_whiteListContract,
484     _presaleCap,
485     _publicSaleCap,
486     _presaleStartTime,
487     _publicSaleStartTime,
488     _publicSaleEndTime)
489     {
490         admin = _admin;
491         gripWallet = _gripWallet;
492 
493         token = new CryptoGripInitiative(_totalTokenSupply * 10 ** 18, _presaleStartTime, _publicSaleEndTime, _admin);
494 
495         // transfer preminted tokens to company wallet
496         token.transfer(gripWallet, _premintedTokenSupply * 10 ** 18);
497     }
498 
499     function setHaltSale(bool halt) {
500         require(msg.sender == admin);
501         haltSale = halt;
502     }
503 
504     function() payable {
505         buy(msg.sender);
506     }
507 
508     event Buy(address _buyer, uint _tokens, uint _payedWei);
509 
510     function buy(address recipient) payable returns (uint){
511         require(tx.gasprice <= 50000000000 wei);
512 
513         require(!haltSale);
514         require(saleStarted());
515         require(!saleEnded());
516 
517         uint weiPayment = eligibleTestAndIncrement(recipient, msg.value);
518 
519         require(weiPayment > 0);
520 
521         // send to msg.sender, not to recipient
522         if (msg.value > weiPayment) {
523             msg.sender.transfer(msg.value.sub(weiPayment));
524         }
525 
526         // send payment to wallet
527         sendETHToMultiSig(weiPayment);
528         raisedWei = raisedWei.add(weiPayment);
529 
530         uint recievedTokens = 0;
531 
532         if (now < openSaleStartTime) {
533             recievedTokens = weiPayment.mul(tokensPerEthPresale);
534         }
535         else {
536             recievedTokens = weiPayment.mul(tokensPerEthPublicSale);
537         }
538 
539         assert(token.transfer(recipient, recievedTokens));
540 
541 
542         Buy(recipient, recievedTokens, weiPayment);
543 
544         return weiPayment;
545     }
546 
547     function sendETHToMultiSig(uint value) internal {
548         gripWallet.transfer(value);
549     }
550 
551     event FinalizeSale();
552     // function is callable by everyone
553     function finalizeSale() {
554         require(saleEnded());
555         require(msg.sender == admin);
556 
557         // burn remaining tokens
558         token.burn(token.balanceOf(this));
559 
560         FinalizeSale();
561     }
562 
563     // ETH balance is always expected to be 0.
564     // but in case something went wrong, we use this function to extract the eth.
565     function emergencyDrain(ERC20 anyToken) returns (bool){
566         require(msg.sender == admin);
567         require(saleEnded());
568 
569         if (this.balance > 0) {
570             sendETHToMultiSig(this.balance);
571         }
572 
573         if (anyToken != address(0x0)) {
574             assert(anyToken.transfer(gripWallet, anyToken.balanceOf(this)));
575         }
576 
577         return true;
578     }
579 
580     // just to check that funds goes to the right place
581     // tokens are not given in return
582     function debugBuy() payable {
583         require(msg.value == 123);
584         sendETHToMultiSig(msg.value);
585     }
586 }