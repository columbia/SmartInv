1 pragma solidity ^0.4.10;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10     address public owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     function Ownable() public {
19         owner = msg.sender;
20     }
21 
22     /**
23      * @dev Throws if called by any account other than the owner.
24      */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     /**
31      * @dev Allows the current owner to transfer control of the contract to a newOwner.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) onlyOwner public {
35         require(newOwner != address(0));
36         OwnershipTransferred(owner, newOwner);
37         owner = newOwner;
38     }
39 
40 }
41 
42 pragma solidity ^0.4.24;
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
56     // benefit is lost if 'b' is also tested.
57     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58     if (a == 0) {
59       return 0;
60     }
61 
62     c = a * b;
63     assert(c / a == b);
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers, truncating the quotient.
69   */
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     // uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return a / b;
75   }
76 
77   /**
78   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   /**
86   * @dev Adds two numbers, throws on overflow.
87   */
88   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
89     c = a + b;
90     assert(c >= a);
91     return c;
92   }
93 }
94 
95 pragma solidity ^0.4.21;
96 
97 /**
98  * @title ERC20Basic
99  * @dev Simpler version of ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/179
101  */
102 contract ERC20Basic is Ownable {
103   function totalSupply() public view returns (uint256);
104   function balanceOf(address who) public view returns (uint256);
105   function transfer(address to, uint256 value) public returns (bool);
106   event Transfer(address indexed from, address indexed to, uint256 value);
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances.
123  */
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint256;
126 
127   mapping(address => uint256) balances;
128 
129   uint256 totalSupply_;
130 
131   /**
132   * @dev total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return totalSupply_;
136   }
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[msg.sender]);
146 
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     emit Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) internal allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     emit Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     emit Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public view returns (uint256) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * @dev Increase the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 }
257 
258 /**
259  * @title Burnable Token
260  * @dev Token that can be irreversibly burned (destroyed).
261  */
262 contract BurnableToken is BasicToken {
263 
264   event Burn(address indexed burner, uint256 value);
265 
266   /**
267    * @dev Burns a specific amount of tokens.
268    * @param _value The amount of token to be burned.
269    */
270   function burn(uint256 _value) onlyOwner public {
271     _burn(msg.sender, _value);
272   }
273 
274   function _burn(address _who, uint256 _value) internal {
275     require(_value <= balances[_who]);
276     // no need to require value <= totalSupply, since that would imply the
277     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
278 
279     balances[_who] = balances[_who].sub(_value);
280     totalSupply_ = totalSupply_.sub(_value);
281     emit Burn(_who, _value);
282     emit Transfer(_who, address(0), _value);
283   }
284 }
285 
286 
287 contract StockusToken is BurnableToken {
288 
289     string public constant name = "Stockus Token";
290     string public constant symbol = "STT";
291     uint32 public constant decimals = 2;
292     uint256 public INITIAL_SUPPLY = 15000000 * 100;
293     bool public isSale;
294 
295     function StockusToken() public {
296         totalSupply_ = INITIAL_SUPPLY;
297         balances[msg.sender] = INITIAL_SUPPLY;
298         Transfer(address(0), msg.sender, INITIAL_SUPPLY);
299         isSale = true;
300     }
301 
302     modifier saleIsOn() {
303         require(isSale);
304         _;
305     }
306 
307     function refund(address _from, uint256 _value) onlyOwner saleIsOn public returns(bool) {
308         balances[_from] = balances[_from].sub(_value);
309         balances[owner] = balances[owner].add(_value);
310         Transfer(_from, owner, _value);
311         return true;
312     }
313 
314     function stopSale() onlyOwner saleIsOn public returns(bool) {
315         isSale = false;
316         return true;
317     }
318 
319 }
320 
321 pragma solidity ^0.4.10;
322 
323 contract Crowdsale is Ownable {
324 
325     using SafeMath for uint;
326 
327     address public multisig;
328     uint256 public rate;
329     uint256 public weiRaised;
330     uint256 public hardcap;
331     uint256 public softcap;
332     StockusToken public token; //Token contract
333     uint256 public saleSupply;
334     uint256 public bountySupply;
335     bool public saleStopped;
336     bool public sendToTeam;
337     uint256 public sendToTeamTime;
338     uint256 public endSaleTime;
339     mapping(address => uint256) public saleBalances;
340 
341     uint256 public constant RESERVED_SUPPLY = 1500000 * 100;
342 
343     function Crowdsale(address _multisig, StockusToken _token, uint256 _weiRaised, uint256 _saleSupply, uint256 _bountySupply) public {
344         multisig = _multisig;
345         weiRaised = _weiRaised;
346         hardcap = 700 ether;
347         softcap = 100 ether;
348         token = _token;
349         saleSupply = _saleSupply;
350         bountySupply = _bountySupply;
351         saleStopped = false;
352         sendToTeam = false;
353         endSaleTime = now + 4 weeks;
354     }
355 
356     modifier isOverSoftcap() {
357         require(weiRaised >= softcap);
358         _;
359     }
360 
361     modifier isUnderSoftcap() {
362         require(weiRaised <= softcap);
363         _;
364     }
365 
366     modifier isSale() {
367         require(now < endSaleTime);
368         _;
369     }
370 
371     modifier saleEnded() {
372         require(now >= endSaleTime);
373         _;
374     }
375 
376     modifier saleNoStopped() {
377         require(saleStopped == false);
378         _;
379     }
380 
381     function stopSale() onlyOwner saleEnded isOverSoftcap public returns(bool) {
382         if (saleSupply > 0) {
383             token.burn(saleSupply);
384             saleSupply = 0;
385         }
386         saleStopped = true;
387         sendToTeamTime = now + 12 weeks;
388         forwardFunds();
389         return token.stopSale();
390     }
391 
392     function createTokens() isSale saleNoStopped payable public {
393         if (now < endSaleTime - 3 weeks) {
394             rate = 12000000000000;
395         } else if (now > endSaleTime - 3 weeks && now < endSaleTime - 2 weeks) {
396             rate = 14000000000000;
397         } else if (now > endSaleTime - 2 weeks && now < endSaleTime - 1 weeks) {
398             rate = 16000000000000;
399         } else {
400             rate = 18000000000000;
401         }
402         uint256 tokens = msg.value.div(rate);
403         require(saleSupply >= tokens);
404         saleSupply = saleSupply.sub(tokens);
405         saleBalances[msg.sender] = saleBalances[msg.sender].add(msg.value);
406         token.transfer(msg.sender, tokens);
407     }
408 
409     function adminSendTokens(address _to, uint256 _value, uint256 _weiAmount) onlyOwner saleNoStopped public returns(bool) {
410         require(saleSupply >= _value);
411         saleSupply = saleSupply.sub(_value);
412         weiRaised = weiRaised.add(_weiAmount);
413         return token.transfer(_to, _value);
414     }
415 
416     function adminRefundTokens(address _from, uint256 _value, uint256 _weiAmount) onlyOwner saleNoStopped public returns(bool) {
417         saleSupply = saleSupply.add(_value);
418         weiRaised = weiRaised.sub(_weiAmount);
419         return token.refund(_from, _value);
420     }
421 
422     function bountySend(address _to, uint256 _value) onlyOwner saleNoStopped public returns(bool) {
423         require(bountySupply >= _value);
424         bountySupply = bountySupply.sub(_value);
425         return token.transfer(_to, _value);
426     }
427 
428     function bountyRefund(address _from, uint256 _value) onlyOwner saleNoStopped public returns(bool) {
429         bountySupply = bountySupply.add(_value);
430         return token.refund(_from, _value);
431     }
432 
433     function refund() saleEnded isUnderSoftcap public returns(bool) {
434         uint256 value = saleBalances[msg.sender];
435         saleBalances[msg.sender] = 0;
436         msg.sender.transfer(value);
437     }
438 
439     function refundTeamTokens() onlyOwner public returns(bool) {
440         require(sendToTeam == false);
441         require(now >= sendToTeamTime);
442         sendToTeam = true;
443         return token.transfer(msg.sender, RESERVED_SUPPLY);
444     }
445 
446     function forwardFunds() private {
447         multisig.transfer(this.balance);
448     }
449 
450     function setMultisig(address _multisig) onlyOwner public {
451         multisig = _multisig;
452     }
453 
454     function() external payable {
455         createTokens();
456     }
457 
458 }
459 
460 
461 
462 pragma solidity ^0.4.21;
463 
464 contract Presale is Ownable {
465 
466     using SafeMath for uint;
467 
468     address public multisig;
469     uint256 public rate;
470     uint256 public weiRaised;
471     uint256 public tokensBurned;
472     StockusToken public token; //Token contract
473     Crowdsale public crowdsale; // Crowdsale contract
474     uint256 public saleSupply = 12000000 * 100;
475     uint256 public presaleSupply = 2000000 * 100;
476     uint256 public bountySupply = 1500000 * 100;
477     uint256 public tokensSoftcap = 500000 * 100;
478 
479     function Presale(address _multisig) public {
480         multisig = _multisig;
481         token = new StockusToken();
482     }
483 
484     modifier isOverSoftcap() {
485         require(tokensBurned >= tokensSoftcap);
486         _;
487     }
488 
489     function startCrowdsale() onlyOwner isOverSoftcap public {
490         crowdsale = new Crowdsale(multisig, token, weiRaised, saleSupply, bountySupply);
491         token.transfer(address(crowdsale), token.balanceOf(this));
492         token.transferOwnership(address(crowdsale));
493         crowdsale.transferOwnership(owner);
494         forwardFunds();
495     }
496 
497     function createTokens() payable public {
498         uint256 weiAmount = msg.value;
499         if (tokensBurned < tokensSoftcap) {
500             rate = 5000000000000;
501         } else {
502             rate = 7000000000000;
503         }
504         uint256 tokens = weiAmount.div(rate);
505         require(presaleSupply >= tokens);
506         tokensBurned = tokensBurned.add(tokens);
507         weiRaised = weiRaised.add(weiAmount);
508         saleSupply = saleSupply.sub(tokens);
509         presaleSupply = presaleSupply.sub(tokens);
510         token.transfer(msg.sender, tokens);
511     }
512 
513     function bountySend(address _to, uint256 _value) onlyOwner public returns(bool) {
514         require(bountySupply >= _value);
515         bountySupply = bountySupply.sub(_value);
516         return token.transfer(_to, _value);
517     }
518 
519     function bountyRefund(address _from, uint256 _value) onlyOwner public returns(bool) {
520         bountySupply = bountySupply.add(_value);
521         return token.refund(_from, _value);
522     }
523 
524     function forwardFunds() private {
525         multisig.transfer(this.balance);
526     }
527 
528     function setMultisig(address _multisig) onlyOwner public {
529         multisig = _multisig;
530     }
531 
532     function() external payable {
533         createTokens();
534     }
535 
536 }