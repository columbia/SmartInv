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
270 
271     uint256 public constant INITIAL_SUPPLY = 1000000000 ether;
272 
273     /**
274      * @dev Constructor that gives msg.sender all of existing tokens.
275      */
276     function XdacToken() public {
277         totalSupply_ = INITIAL_SUPPLY;
278         balances[msg.sender] = INITIAL_SUPPLY;
279         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
280     }
281 }
282 
283 // File: contracts/XdacTokenCrowdsale.sol
284 
285 /**
286  * @title XdacTokenCrowdsale
287  */
288 contract XdacTokenCrowdsale is Ownable {
289 
290     using SafeMath for uint256;
291     uint256[] roundGoals;
292     uint256[] roundRates;
293     uint256 minContribution;
294 
295     // The token being sold
296     ERC20 public token;
297 
298     // Address where funds are collected
299     address public wallet;
300 
301     mapping(address => Contributor) public contributors;
302     //Array of the addresses who participated
303     address[] addresses;
304 
305     // Amount of wei raised
306     uint256 public weiDelivered;
307 
308 
309     event TokenRefund(address indexed purchaser, uint256 amount);
310     event TokenPurchase(address indexed purchaser, address indexed contributor, uint256 value, uint256 amount);
311 
312     struct Contributor {
313         uint256 eth;
314         bool whitelisted;
315         bool created;
316     }
317 
318 
319     function XdacTokenCrowdsale(
320         address _wallet,
321         uint256[] _roundGoals,
322         uint256[] _roundRates,
323         uint256 _minContribution
324     ) public {
325         require(_wallet != address(0));
326         require(_roundRates.length == 5);
327         require(_roundGoals.length == 5);
328         roundGoals = _roundGoals;
329         roundRates = _roundRates;
330         minContribution = _minContribution;
331         token = new XdacToken();
332         wallet = _wallet;
333     }
334 
335     // -----------------------------------------
336     // Crowdsale external interface
337     // -----------------------------------------
338 
339     /**
340      * @dev fallback function
341      */
342     function () external payable {
343         buyTokens(msg.sender);
344     }
345 
346     /**
347      * @dev token purchase
348      * @param _contributor Address performing the token purchase
349      */
350     function buyTokens(address _contributor) public payable {
351         require(_contributor != address(0));
352         require(msg.value != 0);
353         require(msg.value >= minContribution);
354         require(weiDelivered.add(msg.value) <= roundGoals[4]);
355 
356         // calculate token amount to be created
357         uint256 tokens = _getTokenAmount(msg.value);
358 
359         TokenPurchase(msg.sender, _contributor, msg.value, tokens);
360         _forwardFunds();
361     }
362 
363     /**********internal***********/
364     function _getCurrentRound() internal view returns (uint) {
365         for (uint i = 0; i < 5; i++) {
366             if (weiDelivered < roundGoals[i]) {
367                 return i;
368             }
369         }
370     }
371 
372     /**
373      * @dev the way in which ether is converted to tokens.
374      * @param _weiAmount Value in wei to be converted into tokens
375      * @return Number of tokens that can be purchased with the specified _weiAmount
376      */
377     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
378         uint curRound = _getCurrentRound();
379         uint256 calculatedTokenAmount = 0;
380         uint256 roundWei = 0;
381         uint256 weiRaisedIntermediate = weiDelivered;
382         uint256 weiAmount = _weiAmount;
383 
384         for (curRound; curRound < 5; curRound++) {
385             if (weiRaisedIntermediate.add(weiAmount) > roundGoals[curRound]) {
386                 roundWei = roundGoals[curRound].sub(weiRaisedIntermediate);
387                 weiRaisedIntermediate = weiRaisedIntermediate.add(roundWei);
388                 weiAmount = weiAmount.sub(roundWei);
389                 calculatedTokenAmount = calculatedTokenAmount.add(roundWei.mul(roundRates[curRound]));
390             }
391             else {
392                 calculatedTokenAmount = calculatedTokenAmount.add(weiAmount.mul(roundRates[curRound]));
393                 break;
394             }
395         }
396         return calculatedTokenAmount;
397     }
398 
399 
400     /**
401      * @dev the way in which tokens is converted to ether.
402      * @param _tokenAmount Value in token to be converted into wei
403      * @return Number of ether that required to purchase with the specified _tokenAmount
404      */
405     function _getEthAmount(uint256 _tokenAmount) internal view returns (uint256) {
406         uint curRound = _getCurrentRound();
407         uint256 calculatedWeiAmount = 0;
408         uint256 roundWei = 0;
409         uint256 weiRaisedIntermediate = weiDelivered;
410         uint256 tokenAmount = _tokenAmount;
411 
412         for (curRound; curRound < 5; curRound++) {
413             if(weiRaisedIntermediate.add(tokenAmount.div(roundRates[curRound])) > roundGoals[curRound]) {
414                 roundWei = roundGoals[curRound].sub(weiRaisedIntermediate);
415                 weiRaisedIntermediate = weiRaisedIntermediate.add(roundWei);
416                 tokenAmount = tokenAmount.sub(roundWei.div(roundRates[curRound]));
417                 calculatedWeiAmount = calculatedWeiAmount.add(tokenAmount.div(roundRates[curRound]));
418             }
419             else {
420                 calculatedWeiAmount = calculatedWeiAmount.add(tokenAmount.div(roundRates[curRound]));
421                 break;
422             }
423         }
424 
425         return calculatedWeiAmount;
426     }
427 
428     function _forwardFunds() internal {
429         Contributor storage contributor = contributors[msg.sender];
430         contributor.eth = contributor.eth.add(msg.value);
431         if (contributor.created == false) {
432             contributor.created = true;
433             addresses.push(msg.sender);
434         }
435         if (contributor.whitelisted) {
436             _deliverTokens(msg.sender);
437         }
438     }
439 
440     function _deliverTokens(address _contributor) internal {
441         Contributor storage contributor = contributors[_contributor];
442         uint256 amountEth = contributor.eth;
443         uint256 amountToken = _getTokenAmount(amountEth);
444         require(amountToken > 0);
445         require(amountEth > 0);
446         require(contributor.whitelisted);
447         contributor.eth = 0;
448         weiDelivered = weiDelivered.add(amountEth);
449         wallet.transfer(amountEth);
450         token.transfer(_contributor, amountToken);
451     }
452 
453     function _refundTokens(address _contributor) internal {
454         Contributor storage contributor = contributors[_contributor];
455         uint256 ethAmount = contributor.eth;
456         require(ethAmount > 0);
457         contributor.eth = 0;
458         TokenRefund(_contributor, ethAmount);
459         _contributor.transfer(ethAmount);
460     }
461 
462     function _whitelistAddress(address _contributor) internal {
463         Contributor storage contributor = contributors[_contributor];
464         contributor.whitelisted = true;
465         if (contributor.created == false) {
466             contributor.created = true;
467             addresses.push(_contributor);
468         }
469         //Auto deliver tokens
470         if (contributor.eth > 0) {
471             _deliverTokens(_contributor);
472         }
473     }
474 
475     /**********************owner*************************/
476 
477     function whitelistAddresses(address[] _contributors) public onlyOwner {
478         for (uint256 i = 0; i < _contributors.length; i++) {
479             _whitelistAddress(_contributors[i]);
480         }
481     }
482 
483 
484     function whitelistAddress(address _contributor) public onlyOwner {
485         _whitelistAddress(_contributor);
486     }
487 
488     function transferTokenOwnership(address _newOwner) public onlyOwner returns(bool success) {
489         XdacToken _token = XdacToken(token);
490         _token.transfer(_newOwner, _token.balanceOf(_token.owner()));
491         _token.transferOwnership(_newOwner);
492         return true;
493     }
494 
495     /**
496      * @dev Refound tokens. For owner
497      */
498     function refundTokensForAddress(address _contributor) public onlyOwner {
499         _refundTokens(_contributor);
500     }
501 
502 
503     /**********************contributor*************************/
504 
505     function getAddresses() public onlyOwner view returns (address[] )  {
506         return addresses;
507     }
508 
509     /**
510     * @dev Refound tokens. For contributors
511     */
512     function refundTokens() public {
513         _refundTokens(msg.sender);
514     }
515     /**
516      * @dev Returns tokens according to rate
517      */
518     function getTokenAmount(uint256 _weiAmount) public view returns (uint256) {
519         return _getTokenAmount(_weiAmount);
520     }
521 
522     /**
523      * @dev Returns ether according to rate
524      */
525     function getEthAmount(uint256 _tokenAmount) public view returns (uint256) {
526         return _getEthAmount(_tokenAmount);
527     }
528 
529     function getCurrentRate() public view returns (uint256) {
530         return roundRates[_getCurrentRound()];
531     }
532 }