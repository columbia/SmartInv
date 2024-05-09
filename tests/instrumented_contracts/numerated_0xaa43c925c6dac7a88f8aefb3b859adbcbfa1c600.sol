1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         assert(c / a == b);
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // assert(b > 0); // Solidity automatically throws when dividing by 0
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         assert(b <= a);
69         return a - b;
70     }
71 
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         assert(c >= a);
75         return c;
76     }
77 }
78 
79 
80 /**
81  * @title Destructible
82  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
83  */
84 contract Destructible is Ownable {
85 
86   function Destructible() public payable { }
87 
88   /**
89    * @dev Transfers the current balance to the owner and terminates the contract.
90    */
91   function destroy() onlyOwner public {
92     selfdestruct(owner);
93   }
94 
95   function destroyAndSend(address _recipient) onlyOwner public {
96     selfdestruct(_recipient);
97   }
98 }
99 
100 
101 /**
102  * @title ERC20Basic
103  * @dev Simpler version of ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/179
105  */
106 contract ERC20Basic {
107     uint256 public totalSupply;
108     function balanceOf(address who) public view returns (uint256);
109     function transfer(address to, uint256 value) public returns (bool);
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120     function allowance(address owner, address spender) public view returns (uint256);
121     function transferFrom(address from, address to, uint256 value) public returns (bool);
122     function approve(address spender, uint256 value) public returns (bool);
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is ERC20Basic {
133     using SafeMath for uint256;
134 
135     mapping(address => uint256) public balances;
136 
137     /**
138     * @dev transfer token for a specified address
139     * @param _to The address to transfer to.
140     * @param _value The amount to be transferred.
141     */
142     function transfer(address _to, uint256 _value) public returns (bool) {
143         require(_to != address(0));
144         require(_value <= balances[msg.sender]);
145 
146         // SafeMath.sub will throw if there is not enough balance.
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         Transfer(msg.sender, _to, _value);
150         return true;
151     }
152 
153     /**
154     * @dev Gets the balance of the specified address.
155     * @param _owner The address to query the the balance of.
156     * @return An uint256 representing the amount owned by the passed address.
157     */
158     function balanceOf(address _owner) public view returns (uint256 balance) {
159         return balances[_owner];
160     }
161 
162 }
163 
164 
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * @dev https://github.com/ethereum/EIPs/issues/20
171  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175     mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178     /**
179      * @dev Transfer tokens from one address to another
180      * @param _from address The address which you want to send tokens from
181      * @param _to address The address which you want to transfer to
182      * @param _value uint256 the amount of tokens to be transferred
183      */
184     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185         require(_to != address(0));
186         require(_value <= balances[_from]);
187         require(_value <= allowed[_from][msg.sender]);
188 
189         balances[_from] = balances[_from].sub(_value);
190         balances[_to] = balances[_to].add(_value);
191         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192         Transfer(_from, _to, _value);
193         return true;
194     }
195 
196     /**
197      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198      *
199      * Beware that changing an allowance with this method brings the risk that someone may use both the old
200      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      * @param _spender The address which will spend the funds.
204      * @param _value The amount of tokens to be spent.
205      */
206     function approve(address _spender, uint256 _value) public returns (bool) {
207         allowed[msg.sender][_spender] = _value;
208         Approval(msg.sender, _spender, _value);
209         return true;
210     }
211 
212     /**
213      * @dev Function to check the amount of tokens that an owner allowed to a spender.
214      * @param _owner address The address which owns the funds.
215      * @param _spender address The address which will spend the funds.
216      * @return A uint256 specifying the amount of tokens still available for the spender.
217      */
218     function allowance(address _owner, address _spender) public view returns (uint256) {
219         return allowed[_owner][_spender];
220     }
221 
222     /**
223      * approve should be called when allowed[_spender] == 0. To increment
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      */
228     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
229         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
230         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231         return true;
232     }
233 
234     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
235         uint oldValue = allowed[msg.sender][_spender];
236         if (_subtractedValue > oldValue) {
237             allowed[msg.sender][_spender] = 0;
238         } else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245 }
246 
247 
248 
249 /**
250  * @title Mintable token
251  * @dev Simple ERC20 Token example, with mintable token creation
252  */
253 contract MintableToken is StandardToken, Ownable {
254 
255     uint256 public hardCap;
256 
257     event Mint(address indexed to, uint256 amount);
258     event MintFinished();
259 
260     bool public mintingFinished = false;
261 
262 
263     modifier canMint() {
264         require(!mintingFinished);
265         _;
266     }
267 
268     /**
269      * @dev Function to mint tokens
270      * @param _to The address that will receive the minted tokens.
271      * @param _amount The amount of tokens to mint.
272      * @return A boolean that indicates if the operation was successful.
273      */
274     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
275         totalSupply = totalSupply.add(_amount);
276         balances[_to] = balances[_to].add(_amount);
277         Mint(_to, _amount);
278         Transfer(address(0), _to, _amount);
279         return true;
280     }
281 
282     /**
283      * @dev Function to stop minting new tokens.
284      * @return True if the operation was successful.
285      */
286     function finishMinting() onlyOwner canMint public returns (bool) {
287         mintingFinished = true;
288         MintFinished();
289         return true;
290     }
291 }
292 
293 
294 
295 /**
296  * @title CABoxToken
297  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
298  * Note they can later distribute these tokens as they wish using `transfer` and other
299  * `StandardToken` functions.
300  */
301 contract CABoxToken is MintableToken, Destructible {
302 
303     string public constant name = "CABox";
304     string public constant symbol = "CAB";
305     uint8 public constant decimals = 18;
306 
307     /**
308      * @dev Constructor that gives msg.sender all of existing tokens.
309      */
310     function CABoxToken() public {
311         hardCap = 500 * 1000000 * (10 ** uint256(decimals));
312     }
313 
314 
315     /**
316      * @dev Function to mint tokens
317      * @param _to The address that will receive the minted tokens.
318      * @param _amount The amount of tokens to mint.
319      * @return A boolean that indicates if the operation was successful.
320      */
321     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
322         require(totalSupply.add(_amount) <= hardCap);
323 
324         return super.mint(_to, _amount);
325     }
326 }
327 
328 
329 /**
330  * @title CABoxCrowdsale
331  * @dev CABoxCrowdsale is a completed contract for managing a token crowdsale.
332  * CABoxCrowdsale have a start and end timestamps, where investors can make
333  * token purchases and the CABoxCrowdsale will assign them tokens based
334  * on a token per ETH rate. Funds collected are forwarded to a wallet
335  * as they arrive.
336  */
337 contract CABoxCrowdsale is Ownable{
338   using SafeMath for uint256;
339 
340   // The token being sold
341   CABoxToken public token;
342 
343   // start and end timestamps where investments are allowed (both inclusive)
344   uint256 public startTime;
345   uint256 public endTime;
346     
347   // address where funds are collected
348   address public wallet;
349     
350   // address where development funds are collected
351   address public devWallet;
352 
353   // amount of raised money in wei
354   uint256 public weiRaised;
355 
356   /**
357    * event for token purchase logging
358    * @param purchaser who paid for the tokens
359    * @param beneficiary who got the tokens
360    * @param value weis paid for purchase
361    * @param amount amount of tokens purchased
362    */
363   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
364 
365   event TokenContractUpdated(bool state);
366 
367   event WalletAddressUpdated(bool state);
368 
369   function CABoxCrowdsale() public {
370     token = createTokenContract();
371     startTime = 1535155200;
372     endTime = 1540771200;
373     wallet = 0x9BeAbD0aeB08d18612d41210aFEafD08fb84E9E8;
374     devWallet = 0x13dF1d8F51324a237552E87cebC3f501baE2e972;
375   }
376 
377   // creates the token to be sold.
378   // override this method to have crowdsale of a specific mintable token.
379   function createTokenContract() internal returns (CABoxToken) {
380     return new CABoxToken();
381   }
382 
383 
384   // fallback function can be used to buy tokens
385   function () external payable {
386     buyTokens(msg.sender);
387   }
388 
389   // low level token purchase function
390   function buyTokens(address beneficiary) public payable {
391     require(beneficiary != address(0));
392     require(validPurchase());
393 
394     uint256 weiAmount = msg.value;
395 
396     // calculate token amount to be created
397     uint256 bonusRate = getBonusRate();
398     uint256 tokens = weiAmount.mul(bonusRate);
399 
400     // update state
401     weiRaised = weiRaised.add(weiAmount);
402 
403     token.mint(beneficiary, tokens);
404     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
405 
406     forwardFunds();
407   }
408   
409   function getBonusRate() internal view returns (uint256) {
410         uint64[5] memory tokenRates = [uint64(24000),uint64(20000),uint64(16000),uint64(12000),uint64(8000)];
411     
412         // apply bonus for time
413         uint64[5] memory timeStartsBoundaries = [uint64(1535155200),uint64(1538352000),uint64(1538956800),uint64(1539561600),uint64(1540166400)];
414         uint64[5] memory timeEndsBoundaries = [uint64(1538352000),uint64(1538956800),uint64(1539561600),uint64(1540166400),uint64(1540771200)];
415         uint[5] memory timeRates = [uint(500),uint(250),uint(200),uint(150),uint(100)];
416     
417         uint256 bonusRate = tokenRates[0];
418     
419         for (uint i = 0; i < 5; i++) {
420             bool timeInBound = (timeStartsBoundaries[i] <= now) && (now < timeEndsBoundaries[i]);
421             if (timeInBound) {
422                 bonusRate = tokenRates[i] + tokenRates[i] * timeRates[i] / 1000;
423             }
424         }
425         
426         return bonusRate;
427   }
428 
429   // send ether to the fund collection wallet
430   // override to create custom fund forwarding mechanisms
431   function forwardFunds() internal {
432     wallet.transfer(msg.value * 750 / 1000);
433     devWallet.transfer(msg.value * 250 / 1000);
434   }
435 
436   // @return true if the transaction can buy tokens
437   function validPurchase() internal view returns (bool) {
438     bool nonZeroPurchase = msg.value != 0;
439     bool withinPeriod = now >= startTime && now <= endTime;
440     
441     return nonZeroPurchase && withinPeriod;
442   }
443   
444   // @return true if crowdsale event has ended
445   function hasEnded() public view returns (bool) {
446       bool timeEnded = now > endTime;
447 
448       return timeEnded;
449   }
450   
451   // update token contract
452    function updateCABoxToken(address _tokenAddress) onlyOwner{
453       require(_tokenAddress != address(0));
454       token.transferOwnership(_tokenAddress);
455 
456       TokenContractUpdated(true);
457   }
458 }