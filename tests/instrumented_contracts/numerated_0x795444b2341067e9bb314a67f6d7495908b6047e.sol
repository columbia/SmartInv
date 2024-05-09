1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev Throws if called by any account other than the owner.
15      */
16     modifier onlyOwner() {
17         require(msg.sender == owner);
18         _;
19     }
20 
21      /**
22       * @dev Allows the current owner to transfer control of the contract to a newOwner.
23       * @param newOwner The address to transfer ownership to.
24       */
25     function transferOwnership(address newOwner) public onlyOwner {
26       _transferOwnership(newOwner);
27     }
28 
29      /**
30       * @dev Transfers control of the contract to a newOwner.
31       * @param newOwner The address to transfer ownership to.
32       */
33     function _transferOwnership(address newOwner) internal {
34       require(newOwner != address(0));
35       emit OwnershipTransferred(owner, newOwner);
36       owner = newOwner;
37   }
38 
39 }
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45  library SafeMath {
46      function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47          uint256 c = a * b;
48          assert(a == 0 || c / a == b);
49          return c;
50      }
51 
52      function div(uint256 a, uint256 b) internal pure returns (uint256) {
53          // assert(b > 0); // Solidity automatically throws when dividing by 0
54          uint256 c = a / b;
55          // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56          return c;
57      }
58 
59      function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60          assert(b <= a);
61          return a - b;
62      }
63 
64      function add(uint256 a, uint256 b) internal pure returns (uint256) {
65          uint256 c = a + b;
66          assert(c >= a);
67          return c;
68      }
69 
70      function max64(uint64 a, uint64 b) internal pure returns (uint64) {
71          return a >= b ? a : b;
72      }
73 
74      function min64(uint64 a, uint64 b) internal pure returns (uint64) {
75          return a < b ? a : b;
76      }
77 
78      function max256(uint256 a, uint256 b) internal pure returns (uint256) {
79          return a >= b ? a : b;
80      }
81 
82      function min256(uint256 a, uint256 b) internal pure returns (uint256) {
83          return a < b ? a : b;
84      }
85  }
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92  contract ERC20Basic {
93      uint256 public totalSupply;
94 
95      function balanceOf(address who) public view returns (uint256);
96      function transfer(address to, uint256 value) public returns (bool);
97 
98      event Transfer(address indexed from, address indexed to, uint256 value);
99  }
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105  contract ERC20 {
106      uint256 public totalSupply;
107 
108      function balanceOf(address _owner) public constant returns (uint256 balance);
109      function transfer(address _to, uint256 _value) public returns (bool success);
110      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
111      function approve(address _spender, uint256 _value) public returns (bool success);
112      function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
113 
114      event Transfer(address indexed _from, address indexed _to, uint256 _value);
115      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
116 }
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122  contract BasicToken is ERC20Basic {
123      using SafeMath for uint256;
124 
125      mapping (address => uint256) balances;
126 
127      // 2018-09-24 00:00:00 AST - start time for pre sale
128      uint256 public presaleStartTime = 1537736400;
129 
130      // 2018-10-24 23:59:59 AST - end time for pre sale
131      uint256 public presaleEndTime = 1540414799;
132 
133      // 2018-11-04 00:00:00 AST - start time for main sale
134      uint256 public mainsaleStartTime = 1541278800;
135 
136      // 2019-01-04 23:59:59 AST - end time for main sale
137      uint256 public mainsaleEndTime = 1546635599;
138 
139      address public constant investor1 = 0x8013e8F85C9bE7baA19B9Fd9a5Bc5C6C8D617446;
140      address public constant investor2 = 0xf034E5dB3ed5Cb26282d2DC5802B21DB3205B882;
141      address public constant investor3 = 0x1A7dD28A461D7e0D75b89b214d5188E0304E5726;
142 
143      /**
144      * @dev transfer token for a specified address
145      * @param _to The address to transfer to.
146      * @param _value The amount to be transferred.
147      */
148      function transfer(address _to, uint256 _value) public returns (bool) {
149          require(_to != address(0));
150          require(_value <= balances[msg.sender]);
151          if (( (msg.sender == investor1) || (msg.sender == investor2) || (msg.sender == investor3)) && (now < (presaleStartTime + 300 days))) {
152            revert();
153          }
154          // SafeMath.sub will throw if there is not enough balance.
155          balances[msg.sender] = balances[msg.sender].sub(_value);
156          balances[_to] = balances[_to].add(_value);
157          emit Transfer(msg.sender, _to, _value);
158          return true;
159      }
160 
161      /**
162      * @dev Gets the balance of the specified address.
163      * @param _owner The address to query the the balance of.
164      * @return An uint256 representing the amount owned by the passed address.
165      */
166      function balanceOf(address _owner) public constant returns (uint256 balance) {
167          return balances[_owner];
168      }
169 
170  }
171 
172 /**
173  * @title Standard ERC20 token
174  *
175  * @dev Implementation of the basic standard token.
176  * @dev https://github.com/ethereum/EIPs/issues/20
177  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
178  */
179  contract StandardToken is ERC20, BasicToken {
180 
181      mapping (address => mapping (address => uint256)) internal allowed;
182 
183      /**
184       * @dev Transfer tokens from one address to another
185       * @param _from address The address which you want to send tokens from
186       * @param _to address The address which you want to transfer to
187       * @param _value uint256 the amount of tokens to be transferred
188       */
189      function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
190          require(_to != address(0));
191          require(_value <= balances[_from]);
192          require(_value <= allowed[_from][msg.sender]);
193          if (( (_from == investor1) || (_from == investor2) || (_from == investor3)) && (now < (presaleStartTime + 300 days))) {
194            revert();
195          }
196 
197          balances[_from] = balances[_from].sub(_value);
198          balances[_to] = balances[_to].add(_value);
199          allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200          emit Transfer(_from, _to, _value);
201          return true;
202      }
203 
204      /**
205       * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206       *
207       * Beware that changing an allowance with this method brings the risk that someone may use both the old
208       * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209       * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210       * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211       * @param _spender The address which will spend the funds.
212       * @param _value The amount of tokens to be spent.
213       */
214      function approve(address _spender, uint256 _value) public returns (bool) {
215          allowed[msg.sender][_spender] = _value;
216          emit Approval(msg.sender, _spender, _value);
217          return true;
218      }
219 
220      /**
221       * @dev Function to check the amount of tokens that an owner allowed to a spender.
222       * @param _owner address The address which owns the funds.
223       * @param _spender address The address which will spend the funds.
224       * @return A uint256 specifying the amount of tokens still available for the spender.
225       */
226      function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
227          return allowed[_owner][_spender];
228      }
229 
230      /**
231       * approve should be called when allowed[_spender] == 0. To increment
232       * allowed value is better to use this function to avoid 2 calls (and wait until
233       * the first transaction is mined)
234       * From MonolithDAO Token.sol
235       */
236      function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
237          allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238          emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239          return true;
240      }
241 
242      function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
243          uint oldValue = allowed[msg.sender][_spender];
244          if (_subtractedValue > oldValue) {
245              allowed[msg.sender][_spender] = 0;
246          }
247          else {
248              allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249          }
250          emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251          return true;
252      }
253 
254  }
255 
256 /**
257  * @title Mintable token
258  * @dev Simple ERC20 Token example, with mintable token creation
259  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
260  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
261  */
262 
263 contract MintableToken is StandardToken, Ownable {
264     string public constant name = "Kartblock";
265     string public constant symbol = "KBT";
266     uint8 public constant decimals = 18;
267 
268     event Mint(address indexed to, uint256 amount);
269     event MintFinished();
270 
271     bool public mintingFinished;
272 
273     modifier canMint() {
274         require(!mintingFinished);
275         _;
276     }
277 
278     /**
279      * @dev Function to mint tokens
280      * @param _to The address that will receive the minted tokens.
281      * @param _amount The amount of tokens to mint.
282      * @return A boolean that indicates if the operation was successful.
283      */
284     function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {
285         balances[_to] = balances[_to].add(_amount);
286         balances[_owner] = balances[_owner].sub(_amount);
287         emit Mint(_to, _amount);
288         emit Transfer(_owner, _to, _amount);
289         return true;
290     }
291 
292     /**
293      * @dev Function to stop minting new tokens.
294      * @return True if the operation was successful.
295      */
296     function finishMinting() onlyOwner canMint internal returns (bool) {
297         mintingFinished = true;
298         emit MintFinished();
299         return true;
300     }
301 }
302 
303 contract Whitelist is Ownable {
304 
305     mapping (address => bool) verifiedAddresses;
306 
307     function isAddressWhitelist(address _address) public view returns (bool) {
308         return verifiedAddresses[_address];
309     }
310 
311     function whitelistAddress(address _newAddress) external onlyOwner {
312         verifiedAddresses[_newAddress] = true;
313     }
314 
315     function removeWhitelistAddress(address _oldAddress) external onlyOwner {
316         require(verifiedAddresses[_oldAddress]);
317         verifiedAddresses[_oldAddress] = false;
318     }
319 
320     function batchWhitelistAddresses(address[] _addresses) external onlyOwner {
321         for (uint cnt = 0; cnt < _addresses.length; cnt++) {
322             assert(!verifiedAddresses[_addresses[cnt]]);
323             verifiedAddresses[_addresses[cnt]] = true;
324         }
325     }
326 }
327 
328 /**
329  * @title Crowdsale
330  * @dev Crowdsale is a base contract for managing a token crowdsale.
331  * Crowdsales have a start and end timestamps, where investors can make
332  * token purchases. Funds collected are forwarded to a wallet
333  * as they arrive.
334  */
335 contract Crowdsale is Ownable {
336     using SafeMath for uint256;
337     // address where funds are collected
338     address public wallet;
339 
340     // amount of raised money in wei
341     uint256 public PresaleWeiRaised;
342     uint256 public mainsaleWeiRaised;
343     uint256 public tokenAllocated;
344 
345     event WalletChanged(address indexed previousWallet, address indexed newWallet);
346 
347     constructor(address _wallet) public {
348         require(_wallet != address(0));
349         wallet = _wallet;
350     }
351 
352     function transferWallet(address newWallet) public onlyOwner {
353       _transferOwnership(newWallet);
354     }
355 
356     function _transferWallet(address newWallet) internal {
357       require(newWallet != address(0));
358       emit WalletChanged(owner, newWallet);
359       wallet = newWallet;
360     }
361 }
362 
363 contract KartblockCrowdsale is Ownable, Crowdsale, Whitelist, MintableToken {
364     using SafeMath for uint256;
365 
366 
367     // ===== Cap & Goal Management =====
368     uint256 public constant presaleCap = 10000 * (10 ** uint256(decimals));
369     uint256 public constant mainsaleCap = 175375 * (10 ** uint256(decimals));
370     uint256 public constant mainsaleGoal = 11700 * (10 ** uint256(decimals));
371 
372     // ============= Token Distribution ================
373     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
374     uint256 public constant totalTokensForSale = 195500000 * (10 ** uint256(decimals));
375     uint256 public constant tokensForFuture = 760000000 * (10 ** uint256(decimals));
376     uint256 public constant tokensForswap = 4500000 * (10 ** uint256(decimals));
377     uint256 public constant tokensForInvester1 = 16000000 * (10 ** uint256(decimals));
378     uint256 public constant tokensForInvester2 = 16000000 * (10 ** uint256(decimals));
379     uint256 public constant tokensForInvester3 = 8000000 * (10 ** uint256(decimals));
380 
381     // how many token units a buyer gets per wei
382     uint256 public rate;
383     mapping (address => uint256) public deposited;
384     address[] investors;
385 
386     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
387     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
388     event Finalized();
389 
390     constructor(
391       address _owner,
392       address _wallet
393       ) public Crowdsale(_wallet) {
394 
395         require(_wallet != address(0));
396         require(_owner != address(0));
397         owner = _owner;
398         mintingFinished = false;
399         totalSupply = INITIAL_SUPPLY;
400         rate = 1140;
401         bool resultMintForOwner = mintForOwner(owner);
402         require(resultMintForOwner);
403         balances[0x9AF6043d1B74a7c9EC7e3805Bc10e41230537A8B] = balances[0x9AF6043d1B74a7c9EC7e3805Bc10e41230537A8B].add(tokensForswap);
404         mainsaleWeiRaised.add(tokensForswap);
405         balances[investor1] = balances[investor1].add(tokensForInvester1);
406         balances[investor2] = balances[investor1].add(tokensForInvester2);
407         balances[investor3] = balances[investor1].add(tokensForInvester3);
408     }
409 
410     // fallback function can be used to buy tokens
411     function() payable public {
412         buyTokens(msg.sender);
413     }
414 
415     // low level token purchase function
416     function buyTokens(address _investor) public  payable returns (uint256){
417         require(_investor != address(0));
418         require(validPurchase());
419         uint256 weiAmount = msg.value;
420         uint256 tokens = _getTokenAmount(weiAmount);
421         if (tokens == 0) {revert();}
422 
423         // update state
424         if (isPresalePeriod())  {
425           PresaleWeiRaised = PresaleWeiRaised.add(weiAmount);
426         } else if (isMainsalePeriod()) {
427           mainsaleWeiRaised = mainsaleWeiRaised.add(weiAmount);
428         }
429         tokenAllocated = tokenAllocated.add(tokens);
430         if (verifiedAddresses[_investor]) {
431            mint(_investor, tokens, owner);
432         }else {
433           investors.push(_investor);
434           deposited[_investor] = deposited[_investor].add(tokens);
435         }
436         emit TokenPurchase(_investor, weiAmount, tokens);
437         wallet.transfer(weiAmount);
438         return tokens;
439     }
440 
441     function _getTokenAmount(uint256 _weiAmount) internal view returns(uint256) {
442       return _weiAmount.mul(rate);
443     }
444 
445     // ====================== Price Management =================
446     function setPrice() public onlyOwner {
447       if (isPresalePeriod()) {
448         rate = 1140;
449       } else if (isMainsalePeriod()) {
450         rate = 1597;
451       }
452     }
453 
454     function isPresalePeriod() public view returns (bool) {
455       if (now >= presaleStartTime && now < presaleEndTime) {
456         return true;
457       }
458       return false;
459     }
460 
461     function isMainsalePeriod() public view returns (bool) {
462       if (now >= mainsaleStartTime && now < mainsaleEndTime) {
463         return true;
464       }
465       return false;
466     }
467 
468     function mintForOwner(address _wallet) internal returns (bool result) {
469         result = false;
470         require(_wallet != address(0));
471         balances[_wallet] = balances[_wallet].add(INITIAL_SUPPLY);
472         result = true;
473     }
474 
475     function getDeposited(address _investor) public view returns (uint256){
476         return deposited[_investor];
477     }
478 
479     // @return true if the transaction can buy tokens
480     function validPurchase() internal view returns (bool) {
481       bool withinCap =  true;
482       if (isPresalePeriod()) {
483         withinCap = PresaleWeiRaised.add(msg.value) <= presaleCap;
484       } else if (isMainsalePeriod()) {
485         withinCap = mainsaleWeiRaised.add(msg.value) <= mainsaleCap;
486       }
487       bool withinPeriod = isPresalePeriod() || isMainsalePeriod();
488       bool minimumContribution = msg.value >= 0.5 ether;
489       return withinPeriod && minimumContribution && withinCap;
490     }
491 
492     function readyForFinish() internal view returns(bool) {
493       bool endPeriod = now < mainsaleEndTime;
494       bool reachCap = tokenAllocated <= mainsaleCap;
495       return endPeriod || reachCap;
496     }
497 
498 
499     // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
500     function finalize(
501       address _tokensForFuture
502       ) public onlyOwner returns (bool result) {
503         require(_tokensForFuture != address(0));
504         require(readyForFinish());
505         result = false;
506         mint(_tokensForFuture, tokensForFuture, owner);
507         address contractBalance = this;
508         wallet.transfer(contractBalance.balance);
509         finishMinting();
510         emit Finalized();
511         result = true;
512     }
513 
514     function transferToInvester() public onlyOwner returns (bool result) {
515         require( now >= 1548363600);
516         for (uint cnt = 0; cnt < investors.length; cnt++) {
517             mint(investors[cnt], deposited[investors[cnt]], owner);
518         }
519         result = true;
520     }
521 
522 }