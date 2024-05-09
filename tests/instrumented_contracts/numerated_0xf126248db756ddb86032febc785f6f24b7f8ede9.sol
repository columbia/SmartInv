1 pragma solidity ^0.4.18;
2 
3 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
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
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: contracts/XdacToken.sol
265 
266 contract XdacToken is StandardToken, Ownable {
267     string public name = "XDAC COIN";
268     string public symbol = "XDAC";
269     uint8 public decimals = 18;
270     /**
271      * @dev Constructor that gives msg.sender all of existing tokens.
272      */
273     function XdacToken(uint256 _initial_supply) public {
274         totalSupply_ = _initial_supply;
275         balances[msg.sender] = _initial_supply;
276         Transfer(0x0, msg.sender, _initial_supply);
277     }
278 }
279 
280 // File: contracts/XdacTokenCrowdsale.sol
281 
282 /**
283  * @title XdacTokenCrowdsale
284  */
285 contract XdacTokenCrowdsale is Ownable {
286 
287     using SafeMath for uint256;
288     uint256[] roundGoals;
289     uint256[] roundRates;
290     uint256 minContribution;
291 
292     // The token being sold
293     ERC20 public token;
294 
295     // Address where funds are collected
296     address public wallet;
297 
298     mapping(address => Contributor) public contributors;
299     //Array of the addresses who participated
300     address[] addresses;
301 
302     // Amount of wei raised
303     uint256 public weiDelivered;
304 
305 
306     event TokenRefund(address indexed purchaser, uint256 amount);
307     event TokenPurchase(address indexed purchaser, address indexed contributor, uint256 value, uint256 amount);
308 
309     struct Contributor {
310         uint256 eth;
311         bool whitelisted;
312         bool created;
313     }
314 
315 
316     function XdacTokenCrowdsale(
317         address _wallet,
318         uint256[] _roundGoals,
319         uint256[] _roundRates,
320         uint256 _minContribution,
321         uint256 _initial_supply
322     ) public {
323         require(_wallet != address(0));
324         require(_roundRates.length == 5);
325         require(_roundGoals.length == 5);
326         roundGoals = _roundGoals;
327         roundRates = _roundRates;
328         minContribution = _minContribution;
329         token = new XdacToken(_initial_supply);
330         wallet = _wallet;
331     }
332 
333     // -----------------------------------------
334     // Crowdsale external interface
335     // -----------------------------------------
336 
337     /**
338      * @dev fallback function
339      */
340     function () external payable {
341         buyTokens(msg.sender);
342     }
343 
344     /**
345      * @dev token purchase
346      * @param _contributor Address performing the token purchase
347      */
348     function buyTokens(address _contributor) public payable {
349         require(_contributor != address(0));
350         require(msg.value != 0);
351         require(msg.value >= minContribution);
352         require(weiDelivered.add(msg.value) <= roundGoals[4]);
353 
354         // calculate token amount to be created
355         uint256 tokens = _getTokenAmount(msg.value);
356 
357         TokenPurchase(msg.sender, _contributor, msg.value, tokens);
358         _forwardFunds();
359     }
360 
361     /**********internal***********/
362     function _getCurrentRound() internal view returns (uint) {
363         for (uint i = 0; i < 5; i++) {
364             if (weiDelivered < roundGoals[i]) {
365                 return i;
366             }
367         }
368     }
369 
370     /**
371      * @dev the way in which ether is converted to tokens.
372      * @param _weiAmount Value in wei to be converted into tokens
373      * @return Number of tokens that can be purchased with the specified _weiAmount
374      */
375     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
376         uint curRound = _getCurrentRound();
377         uint256 calculatedTokenAmount = 0;
378         uint256 roundWei = 0;
379         uint256 weiRaisedIntermediate = weiDelivered;
380         uint256 weiAmount = _weiAmount;
381 
382         for (curRound; curRound < 5; curRound++) {
383             if (weiRaisedIntermediate.add(weiAmount) > roundGoals[curRound]) {
384                 roundWei = roundGoals[curRound].sub(weiRaisedIntermediate);
385                 weiRaisedIntermediate = weiRaisedIntermediate.add(roundWei);
386                 weiAmount = weiAmount.sub(roundWei);
387                 calculatedTokenAmount = calculatedTokenAmount.add(roundWei.mul(roundRates[curRound]));
388             }
389             else {
390                 calculatedTokenAmount = calculatedTokenAmount.add(weiAmount.mul(roundRates[curRound]));
391                 break;
392             }
393         }
394         return calculatedTokenAmount;
395     }
396 
397 
398     /**
399      * @dev the way in which tokens is converted to ether.
400      * @param _tokenAmount Value in token to be converted into wei
401      * @return Number of ether that required to purchase with the specified _tokenAmount
402      */
403     function _getEthAmount(uint256 _tokenAmount) internal view returns (uint256) {
404         uint curRound = _getCurrentRound();
405         uint256 calculatedWeiAmount = 0;
406         uint256 roundWei = 0;
407         uint256 weiRaisedIntermediate = weiDelivered;
408         uint256 tokenAmount = _tokenAmount;
409 
410         for (curRound; curRound < 5; curRound++) {
411             if(weiRaisedIntermediate.add(tokenAmount.div(roundRates[curRound])) > roundGoals[curRound]) {
412                 roundWei = roundGoals[curRound].sub(weiRaisedIntermediate);
413                 weiRaisedIntermediate = weiRaisedIntermediate.add(roundWei);
414                 tokenAmount = tokenAmount.sub(roundWei.div(roundRates[curRound]));
415                 calculatedWeiAmount = calculatedWeiAmount.add(tokenAmount.div(roundRates[curRound]));
416             }
417             else {
418                 calculatedWeiAmount = calculatedWeiAmount.add(tokenAmount.div(roundRates[curRound]));
419                 break;
420             }
421         }
422 
423         return calculatedWeiAmount;
424     }
425 
426     function _forwardFunds() internal {
427         Contributor storage contributor = contributors[msg.sender];
428         contributor.eth = contributor.eth.add(msg.value);
429         if (contributor.created == false) {
430             contributor.created = true;
431             addresses.push(msg.sender);
432         }
433         if (contributor.whitelisted) {
434             _deliverTokens(msg.sender);
435         }
436     }
437 
438     function _deliverTokens(address _contributor) internal {
439         Contributor storage contributor = contributors[_contributor];
440         uint256 amountEth = contributor.eth;
441         uint256 amountToken = _getTokenAmount(amountEth);
442         require(amountToken > 0);
443         require(amountEth > 0);
444         require(contributor.whitelisted);
445         contributor.eth = 0;
446         weiDelivered = weiDelivered.add(amountEth);
447         wallet.transfer(amountEth);
448         token.transfer(_contributor, amountToken);
449     }
450 
451     function _refundTokens(address _contributor) internal {
452         Contributor storage contributor = contributors[_contributor];
453         uint256 ethAmount = contributor.eth;
454         require(ethAmount > 0);
455         contributor.eth = 0;
456         TokenRefund(_contributor, ethAmount);
457         _contributor.transfer(ethAmount);
458     }
459 
460     function _whitelistAddress(address _contributor) internal {
461         Contributor storage contributor = contributors[_contributor];
462         contributor.whitelisted = true;
463         if (contributor.created == false) {
464             contributor.created = true;
465             addresses.push(_contributor);
466         }
467         //Auto deliver tokens
468         if (contributor.eth > 0) {
469             _deliverTokens(_contributor);
470         }
471     }
472 
473     function _sendToken(address _address, uint256 _amountTokens) internal{
474         XdacToken _token = XdacToken(token);
475         require(_token.balanceOf(_token.owner()) >= _amountTokens);
476         _token.transfer(_address, _amountTokens);
477     }
478 
479     /**********************owner*************************/
480 
481     function whitelistAddresses(address[] _contributors) public onlyOwner {
482         for (uint256 i = 0; i < _contributors.length; i++) {
483             _whitelistAddress(_contributors[i]);
484         }
485     }
486 
487 
488     function whitelistAddress(address _contributor) public onlyOwner {
489         _whitelistAddress(_contributor);
490     }
491 
492     function transferTokenOwnership(address _newOwner) public onlyOwner returns(bool success) {
493         XdacToken _token = XdacToken(token);
494         _token.transfer(_newOwner, _token.balanceOf(_token.owner()));
495         _token.transferOwnership(_newOwner);
496         return true;
497     }
498 
499     function sendToken(address _address, uint256 _amountTokens) public onlyOwner returns(bool success) {
500         _sendToken(_address, _amountTokens);
501         return true;
502     }
503 
504     function sendTokens(address[] _addresses, uint256[] _amountTokens) public onlyOwner returns(bool success) {
505         require(_addresses.length > 0);
506         require(_amountTokens.length > 0);
507         require(_addresses.length  == _amountTokens.length);
508         for (uint256 i = 0; i < _addresses.length; i++) {
509             _sendToken(_addresses[i], _amountTokens[i]);
510         }
511         return true;
512     }
513     /**
514      * @dev Refound tokens. For owner
515      */
516     function refundTokensForAddress(address _contributor) public onlyOwner {
517         _refundTokens(_contributor);
518     }
519 
520 
521     /**********************contributor*************************/
522 
523     function getAddresses() public onlyOwner view returns (address[] )  {
524         return addresses;
525     }
526 
527     /**
528     * @dev Refound tokens. For contributors
529     */
530     function refundTokens() public {
531         _refundTokens(msg.sender);
532     }
533     /**
534      * @dev Returns tokens according to rate
535      */
536     function getTokenAmount(uint256 _weiAmount) public view returns (uint256) {
537         return _getTokenAmount(_weiAmount);
538     }
539 
540     /**
541      * @dev Returns ether according to rate
542      */
543     function getEthAmount(uint256 _tokenAmount) public view returns (uint256) {
544         return _getEthAmount(_tokenAmount);
545     }
546 
547     function getCurrentRate() public view returns (uint256) {
548         return roundRates[_getCurrentRound()];
549     }
550 }