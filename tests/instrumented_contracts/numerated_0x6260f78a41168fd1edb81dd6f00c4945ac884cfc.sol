1 /**
2  * Investors relations: partners@arbitraging.co
3 **/
4 
5 pragma solidity ^0.4.18;
6 
7 /**
8  * @title Crowdsale
9  * @dev Crowdsale is a base contract for managing a token crowdsale.
10  * Crowdsales have a start and end timestamps, where investors can make
11  * token purchases and the crowdsale will assign them tokens based
12  * on a token per ETH rate. Funds collected are forwarded to a wallet
13  * as they arrive.
14  */
15  
16  
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24  function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) onlyOwner public {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 /**
81  * @title ERC20Standard
82  * @dev Simpler version of ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/179
84  */
85 contract ERC20Interface {
86      function totalSupply() public constant returns (uint);
87      function balanceOf(address tokenOwner) public constant returns (uint balance);
88      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
89      function transfer(address to, uint tokens) public returns (bool success);
90      function approve(address spender, uint tokens) public returns (bool success);
91      function transferFrom(address from, address to, uint tokens) public returns (bool success);
92      event Transfer(address indexed from, address indexed to, uint tokens);
93      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
94 }
95 
96 interface OldXRPCToken {
97     function transfer(address receiver, uint amount) external;
98     function balanceOf(address _owner) external returns (uint256 balance);
99     function mint(address wallet, address buyer, uint256 tokenAmount) external;
100     function showMyTokenBalance(address addr) external;
101 }
102 contract ARBITRAGEToken is ERC20Interface,Ownable {
103 
104    using SafeMath for uint256;
105     uint256 public totalSupply;
106     mapping(address => uint256) tokenBalances;
107    
108    string public constant name = "ARBITRAGE";
109    string public constant symbol = "ARB";
110    uint256 public constant decimals = 18;
111 
112    uint256 public constant INITIAL_SUPPLY = 10000000;
113     address ownerWallet;
114    // Owner of account approves the transfer of an amount to another account
115    mapping (address => mapping (address => uint256)) allowed;
116    event Debug(string message, address addr, uint256 number);
117 
118     function ARBITRAGEToken(address wallet) public {
119         owner = msg.sender;
120         ownerWallet=wallet;
121         totalSupply = INITIAL_SUPPLY * 10 ** 18;
122         tokenBalances[wallet] = INITIAL_SUPPLY * 10 ** 18;   //Since we divided the token into 10^18 parts
123     }
124  /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) public returns (bool) {
130     require(tokenBalances[msg.sender]>=_value);
131     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
132     tokenBalances[_to] = tokenBalances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136   
137   
138      /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= tokenBalances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     tokenBalances[_from] = tokenBalances[_from].sub(_value);
150     tokenBalances[_to] = tokenBalances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155   
156      /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172      // ------------------------------------------------------------------------
173      // Total supply
174      // ------------------------------------------------------------------------
175      function totalSupply() public constant returns (uint) {
176          return totalSupply  - tokenBalances[address(0)];
177      }
178      
179     
180      
181      // ------------------------------------------------------------------------
182      // Returns the amount of tokens approved by the owner that can be
183      // transferred to the spender's account
184      // ------------------------------------------------------------------------
185      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
186          return allowed[tokenOwner][spender];
187      }
188      
189      /**
190    * @dev Increase the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To increment
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _addedValue The amount of tokens to increase the allowance by.
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   /**
206    * @dev Decrease the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To decrement
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _subtractedValue The amount of tokens to decrease the allowance by.
214    */
215   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
216     uint oldValue = allowed[msg.sender][_spender];
217     if (_subtractedValue > oldValue) {
218       allowed[msg.sender][_spender] = 0;
219     } else {
220       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221     }
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226      
227      // ------------------------------------------------------------------------
228      // Don't accept ETH
229      // ------------------------------------------------------------------------
230      function () public payable {
231          revert();
232      }
233  
234 
235   /**
236   * @dev Gets the balance of the specified address.
237   * @param _owner The address to query the the balance of.
238   * @return An uint256 representing the amount owned by the passed address.
239   */
240   function balanceOf(address _owner) constant public returns (uint256 balance) {
241     return tokenBalances[_owner];
242   }
243 
244     function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
245       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
246       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
247       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
248       Transfer(wallet, buyer, tokenAmount); 
249       totalSupply=totalSupply.sub(tokenAmount);
250     }
251     function pullBack(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
252         require(tokenBalances[buyer]>=tokenAmount);
253         tokenBalances[buyer] = tokenBalances[buyer].sub(tokenAmount);
254         tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);
255         Transfer(buyer, wallet, tokenAmount);
256         totalSupply=totalSupply.add(tokenAmount);
257      }
258     function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
259         tokenBalance = tokenBalances[addr];
260     }
261 }
262 contract ARBITRAGECrowdsale {
263     
264     struct Stakeholder
265     {
266         address stakeholderAddress;
267         uint stakeholderPerc;
268     }
269   using SafeMath for uint256;
270  
271   // The token being sold
272   ARBITRAGEToken public token;
273   OldXRPCToken public prevXRPCToken;
274   
275   // start and end timestamps where investments are allowed (both inclusive)
276   uint256 public startTime;
277   Stakeholder[] ownersList;
278   
279   // address where funds are collected
280   // address where tokens are deposited and from where we send tokens to buyers
281   address public walletOwner;
282   Stakeholder stakeholderObj;
283   
284 
285   uint256 public coinPercentage = 5;
286 
287     // how many token units a buyer gets per wei
288     uint256 public ratePerWei = 1657;
289     uint256 public maxBuyLimit=2000;
290     uint256 public tokensSoldInThisRound=0;
291     uint256 public totalTokensSold = 0;
292 
293     // amount of raised money in wei
294     uint256 public weiRaised;
295 
296 
297     bool public isCrowdsalePaused = false;
298     address partnerHandler;
299   
300   /**
301    * event for token purchase logging
302    * @param purchaser who paid for the tokens
303    * @param beneficiary who got the tokens
304    * @param value weis paid for purchase
305    * @param amount amount of tokens purchased
306    */
307   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
308 
309 
310   function ARBITRAGECrowdsale(address _walletOwner, address _partnerHandler) public {
311       
312         prevXRPCToken = OldXRPCToken(0xAdb41FCD3DF9FF681680203A074271D3b3Dae526); 
313         
314         startTime = now;
315         
316         require(_walletOwner != 0x0);
317         walletOwner=_walletOwner;
318 
319          stakeholderObj = Stakeholder({
320          stakeholderAddress: walletOwner,
321          stakeholderPerc : 100});
322          
323          ownersList.push(stakeholderObj);
324         partnerHandler = _partnerHandler;
325         token = createTokenContract(_walletOwner);
326   }
327 
328   // creates the token to be sold.
329   function createTokenContract(address wall) internal returns (ARBITRAGEToken) {
330     return new ARBITRAGEToken(wall);
331   }
332 
333 
334   // fallback function can be used to buy tokens
335   function () public payable {
336     buyTokens(msg.sender);
337   }
338 
339   
340   // low level token purchase function
341 
342   function buyTokens(address beneficiary) public payable {
343     require (isCrowdsalePaused != true);
344         
345     require(beneficiary != 0x0);
346     require(validPurchase());
347     uint256 weiAmount = msg.value;
348     // calculate token amount to be created
349 
350     uint256 tokens = weiAmount.mul(ratePerWei);
351     require(tokensSoldInThisRound.add(tokens)<=maxBuyLimit);
352     // update state
353     weiRaised = weiRaised.add(weiAmount);
354 
355     token.mint(walletOwner, beneficiary, tokens); 
356     tokensSoldInThisRound=tokensSoldInThisRound+tokens;
357     TokenPurchase(walletOwner, beneficiary, weiAmount, tokens);
358     totalTokensSold = totalTokensSold.add(tokens);
359     uint partnerCoins = tokens.mul(coinPercentage);
360     partnerCoins = partnerCoins.div(100);
361     forwardFunds(partnerCoins);
362   }
363 
364    // send ether to the fund collection wallet(s)
365     function forwardFunds(uint256 partnerTokenAmount) internal {
366       for (uint i=0;i<ownersList.length;i++)
367       {
368          uint percent = ownersList[i].stakeholderPerc;
369          uint amountToBeSent = msg.value.mul(percent);
370          amountToBeSent = amountToBeSent.div(100);
371          ownersList[i].stakeholderAddress.transfer(amountToBeSent);
372          
373          if (ownersList[i].stakeholderAddress!=walletOwner &&  ownersList[i].stakeholderPerc>0)
374          {
375              token.mint(walletOwner,ownersList[i].stakeholderAddress,partnerTokenAmount);
376          }
377       }
378     }
379     
380     function updateOwnerShares(address[] partnersAddresses, uint[] partnersPercentages) public{
381         require(msg.sender==partnerHandler);
382         require(partnersAddresses.length==partnersPercentages.length);
383         
384         uint sumPerc=0;
385         for(uint i=0; i<partnersPercentages.length;i++)
386         {
387             sumPerc+=partnersPercentages[i];
388         }
389         require(sumPerc==100);
390         
391         delete ownersList;
392         
393         for(uint j=0; j<partnersAddresses.length;j++)
394         {
395             delete stakeholderObj;
396              stakeholderObj = Stakeholder({
397              stakeholderAddress: partnersAddresses[j],
398              stakeholderPerc : partnersPercentages[j]});
399              ownersList.push(stakeholderObj);
400         }
401     }
402 
403 
404   // @return true if the transaction can buy tokens
405   function validPurchase() internal constant returns (bool) {
406     bool nonZeroPurchase = msg.value != 0;
407     return nonZeroPurchase;
408   }
409 
410   
411    function showMyTokenBalance() public view returns (uint256 tokenBalance) {
412         tokenBalance = token.showMyTokenBalance(msg.sender);
413     }
414     
415     /**
416      * The function to pull back tokens from a  notorious user
417      * Can only be called from owner wallet
418      **/
419     function pullBack(address buyer) public {
420         require(msg.sender==walletOwner);
421         uint bal = token.balanceOf(buyer);
422         token.pullBack(walletOwner,buyer,bal);
423     }
424     
425 
426     /**
427      * function to set the new price 
428      * can only be called from owner wallet
429      **/ 
430     function setPriceRate(uint256 newPrice) public returns (bool) {
431         require(msg.sender==walletOwner);
432         ratePerWei = newPrice;
433     }
434     
435     /**
436      * function to set the max buy limit in 1 transaction 
437      * can only be called from owner wallet
438      **/ 
439     
440       function setMaxBuyLimit(uint256 maxlimit) public returns (bool) {
441         require(msg.sender==walletOwner);
442         maxBuyLimit = maxlimit *10 ** 18;
443     }
444     
445       /**
446      * function to start new ICO round 
447      * can only be called from owner wallet
448      **/ 
449     
450       function startNewICORound(uint256 maxlimit, uint256 newPrice) public returns (bool) {
451         require(msg.sender==walletOwner);
452         setMaxBuyLimit(maxlimit);
453         setPriceRate(newPrice);
454         tokensSoldInThisRound=0;
455     }
456     
457       /**
458      * function to get this round information 
459      * can only be called from owner wallet
460      **/ 
461     
462       function getCurrentICORoundInfo() public view returns 
463       (uint256 maxlimit, uint256 newPrice, uint tokensSold) {
464        return(maxBuyLimit,ratePerWei,tokensSoldInThisRound);
465     }
466     
467     /**
468      * function to pause the crowdsale 
469      * can only be called from owner wallet
470      **/
471      
472     function pauseCrowdsale() public returns(bool) {
473         require(msg.sender==walletOwner);
474         isCrowdsalePaused = true;
475     }
476 
477     /**
478      * function to resume the crowdsale if it is paused
479      * can only be called from owner wallet
480      * if the crowdsale has been stopped, this function would not resume it
481      **/ 
482     function resumeCrowdsale() public returns (bool) {
483         require(msg.sender==walletOwner);
484         isCrowdsalePaused = false;
485     }
486     
487     /**
488      * Shows the remaining tokens in the contract i.e. tokens remaining for sale
489      **/ 
490     function tokensRemainingForSale() public view returns (uint256 balance) {
491         balance = token.balanceOf(walletOwner);
492     }
493     
494     /**
495      * function to show the equity percentage of an owner - major or minor
496      * can only be called from the owner wallet
497      **/
498     function checkOwnerShare (address owner) public constant returns (uint share) {
499         require(msg.sender==walletOwner);
500         
501         for(uint i=0;i<ownersList.length;i++)
502         {
503             if(ownersList[i].stakeholderAddress==owner)
504             {
505                 return ownersList[i].stakeholderPerc;
506             }
507         }
508         return 0;
509     }
510 
511     /**
512      * function to change the coin percentage awarded to the partners
513      * can only be called from the owner wallet
514      **/
515     function changePartnerCoinPercentage(uint percentage) public {
516         require(msg.sender==walletOwner);
517         coinPercentage = percentage;
518     }
519     
520     /**
521      * airdrop to old token holders
522      **/ 
523     function airDropToOldTokenHolders(address[] oldTokenHolders) public {
524         require(msg.sender==walletOwner);
525         for(uint i = 0; i<oldTokenHolders.length; i++){
526             if(prevXRPCToken.balanceOf(oldTokenHolders[i])>0)
527             {
528                 token.mint(walletOwner,oldTokenHolders[i],prevXRPCToken.balanceOf(oldTokenHolders[i]));
529             }
530         }
531     }
532     
533     function changeWalletOwner(address newWallet) public {
534         require(msg.sender==walletOwner);
535         walletOwner = newWallet;
536     }
537 }