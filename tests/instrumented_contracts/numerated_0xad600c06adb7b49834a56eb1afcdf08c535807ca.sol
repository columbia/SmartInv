1 pragma solidity ^0.4.18;
2     
3     
4     /**
5      * @title ERC20Basic
6      * @dev Simpler version of ERC20 interface
7      * @dev see https://github.com/ethereum/EIPs/issues/179
8      */
9     contract ERC20Basic {
10       function totalSupply() public view returns (uint256);
11       function balanceOf(address who) public view returns (uint256);
12       function transfer(address to, uint256 value) public returns (bool);
13       event Transfer(address indexed from, address indexed to, uint256 value);
14     }
15     
16     
17     
18     /**
19      * @title Ownable
20      * @dev The Ownable contract has an owner address, and provides basic authorization control
21      * functions, this simplifies the implementation of "user permissions".
22      */
23     contract Ownable {
24       address public owner;
25     
26     
27       event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28     
29     
30       /**
31        * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32        * account.
33        */
34       function Ownable() public {
35         owner = msg.sender;
36       }
37     
38       /**
39        * @dev Throws if called by any account other than the owner.
40        */
41       modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44       }
45     
46       /**
47        * @dev Allows the current owner to transfer control of the contract to a newOwner.
48        * @param newOwner The address to transfer ownership to.
49        */
50       function transferOwnership(address newOwner) public onlyOwner {
51         require(newOwner != address(0));
52         OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54       }
55     
56     }
57     
58     
59     
60     
61     
62     
63     
64     
65     /**
66      * @title SafeMath
67      * @dev Math operations with safety checks that throw on error
68      */
69     library SafeMath {
70     
71       /**
72       * @dev Multiplies two numbers, throws on overflow.
73       */
74       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         if (a == 0) {
76           return 0;
77         }
78         uint256 c = a * b;
79         assert(c / a == b);
80         return c;
81       }
82     
83       /**
84       * @dev Integer division of two numbers, truncating the quotient.
85       */
86       function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         // assert(b > 0); // Solidity automatically throws when dividing by 0
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90         return c;
91       }
92     
93       /**
94       * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95       */
96       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         assert(b <= a);
98         return a - b;
99       }
100     
101       /**
102       * @dev Adds two numbers, throws on overflow.
103       */
104       function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         assert(c >= a);
107         return c;
108       }
109     }
110     
111     
112     
113     /**
114      * @title Crowdsale
115      * @dev Crowdsale is a base contract for managing a token crowdsale.
116      * Crowdsales have a start and end timestamps, where investors can make
117      * token purchases and the crowdsale will assign them tokens based
118      * on a token per ETH rate. Funds collected are forwarded to a wallet
119      * as they arrive.
120      */
121     contract Crowdsale is Ownable {
122         using SafeMath for uint256;
123     
124         // The token being sold
125         MintableToken public token;
126     
127         // start and end timestamps where investments are allowed (both inclusive)
128         uint256 public preIcoStartTime;
129         uint256 public icoStartTime;
130         uint256 public preIcoEndTime;
131         uint256 public icoEndTime;
132     
133         // address where funds are collected
134         address public wallet;
135     
136         // how many token units a buyer gets per wei
137         uint256 public preIcoRate;
138         uint256 public icoRate;
139     
140         // amount of raised money in wei
141         uint256 public weiRaised;
142     
143         /**
144          * event for token purchase logging
145          * @param purchaser who paid for the tokens
146          * @param beneficiary who got the tokens
147          * @param value weis paid for purchase
148          * @param amount amount of tokens purchased
149          */
150         event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
151     
152     
153         function Crowdsale(uint256 _preIcoStartTime, uint256 _preIcoEndTime, uint256 _preIcoRate, uint256 _icoStartTime, uint256 _icoEndTime, uint256 _icoRate, address _wallet) public {
154             require(_preIcoStartTime >= now);
155             require(_preIcoEndTime >= _preIcoStartTime);
156     
157             require(_icoStartTime >= _preIcoEndTime);
158             require(_icoEndTime >= _icoStartTime);
159     
160             require(_preIcoRate > 0);
161             require(_icoRate > 0);
162     
163             require(_wallet != address(0));
164     
165             token = createTokenContract();
166             preIcoStartTime = _preIcoStartTime;
167             icoStartTime = _icoStartTime;
168     
169             preIcoEndTime = _preIcoEndTime;
170             icoEndTime = _icoEndTime;
171     
172             preIcoRate = _preIcoRate;
173             icoRate = _icoRate;
174     
175             wallet = _wallet;
176         }
177     
178         // fallback function can be used to buy tokens
179         function () external payable {
180             buyTokens(msg.sender);
181         }
182     
183         // low level token purchase function
184         function buyTokens(address beneficiary) public payable {
185             require(beneficiary != address(0));
186             require(validPurchase());
187     
188             uint256 weiAmount = msg.value;
189     
190             // calculate token amount to be created
191             uint256 tokens = getTokenAmount(weiAmount);
192     
193             // update state
194             weiRaised = weiRaised.add(weiAmount);
195     
196             //send tokens to beneficiary.
197             token.mint(beneficiary, tokens);
198     
199             //send same amount of tokens to owner.
200             token.mint(wallet, tokens);
201     
202             TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
203     
204             forwardFunds();
205         }
206     
207         // @return true if pre-ico crowdsale event has ended
208         function preIcoHasEnded() public view returns (bool) {
209             return now > preIcoEndTime;
210         }
211     
212         // @return true if ico crowdsale event has ended
213         function icoHasEnded() public view returns (bool) {
214             return now > icoEndTime;
215         }
216     
217         // creates the token to be sold.
218         // override this method to have crowdsale of a specific mintable token.
219         function createTokenContract() internal returns (MintableToken) {
220             return new MintableToken();
221         }
222     
223         // Override this method to have a way to add business logic to your crowdsale when buying
224         function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
225             if(!preIcoHasEnded()){
226                 return weiAmount.mul(preIcoRate);
227             }else{
228                 return weiAmount.mul(icoRate);
229             }
230         }
231     
232         // send ether to the fund collection wallet
233         // override to create custom fund forwarding mechanisms
234         function forwardFunds() internal {
235             wallet.transfer(msg.value);
236         }
237     
238         // @return true if the transaction can buy tokens
239         function validPurchase() internal view returns (bool) {
240             bool withinPeriod = now >= preIcoStartTime && now <= preIcoEndTime || now >= icoStartTime && now <= icoEndTime;
241             bool nonZeroPurchase = msg.value != 0;
242             return withinPeriod && nonZeroPurchase;
243         }
244     
245         // allows transfer of token to new owner
246         function transferTokenOwnership(address _newOwner) public {
247             require(msg.sender == owner); // Only the owner of the crowdsale contract should be able to call this function.
248             //Now lets reference the token that we created....
249             token.transferOwnership(_newOwner);
250         }
251     }
252     
253     
254     
255     
256     
257     
258     
259     
260     
261     
262     
263     /**
264      * @title ERC20 interface
265      * @dev see https://github.com/ethereum/EIPs/issues/20
266      */
267     contract ERC20 is ERC20Basic {
268       function allowance(address owner, address spender) public view returns (uint256);
269       function transferFrom(address from, address to, uint256 value) public returns (bool);
270       function approve(address spender, uint256 value) public returns (bool);
271       event Approval(address indexed owner, address indexed spender, uint256 value);
272     }
273     
274     /**
275      * @title Basic token
276      * @dev Basic version of StandardToken, with no allowances.
277      */
278     contract BasicToken is ERC20Basic {
279       using SafeMath for uint256;
280     
281       mapping(address => uint256) balances;
282     
283       uint256 totalSupply_;
284     
285       /**
286       * @dev total number of tokens in existence
287       */
288       function totalSupply() public view returns (uint256) {
289         return totalSupply_;
290       }
291     
292       /**
293       * @dev transfer token for a specified address
294       * @param _to The address to transfer to.
295       * @param _value The amount to be transferred.
296       */
297       function transfer(address _to, uint256 _value) public returns (bool) {
298         require(_to != address(0));
299         require(_value <= balances[msg.sender]);
300     
301         // SafeMath.sub will throw if there is not enough balance.
302         balances[msg.sender] = balances[msg.sender].sub(_value);
303         balances[_to] = balances[_to].add(_value);
304         Transfer(msg.sender, _to, _value);
305         return true;
306       }
307     
308       /**
309       * @dev Gets the balance of the specified address.
310       * @param _owner The address to query the the balance of.
311       * @return An uint256 representing the amount owned by the passed address.
312       */
313       function balanceOf(address _owner) public view returns (uint256 balance) {
314         return balances[_owner];
315       }
316     
317     }
318     
319     
320     /**
321      * @title Standard ERC20 token
322      *
323      * @dev Implementation of the basic standard token.
324      * @dev https://github.com/ethereum/EIPs/issues/20
325      * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
326      */
327     contract StandardToken is ERC20, BasicToken {
328     
329       mapping (address => mapping (address => uint256)) internal allowed;
330     
331     
332       /**
333        * @dev Transfer tokens from one address to another
334        * @param _from address The address which you want to send tokens from
335        * @param _to address The address which you want to transfer to
336        * @param _value uint256 the amount of tokens to be transferred
337        */
338       function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
339         require(_to != address(0));
340         require(_value <= balances[_from]);
341         require(_value <= allowed[_from][msg.sender]);
342     
343         balances[_from] = balances[_from].sub(_value);
344         balances[_to] = balances[_to].add(_value);
345         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
346         Transfer(_from, _to, _value);
347         return true;
348       }
349     
350       /**
351        * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
352        *
353        * Beware that changing an allowance with this method brings the risk that someone may use both the old
354        * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
355        * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
356        * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
357        * @param _spender The address which will spend the funds.
358        * @param _value The amount of tokens to be spent.
359        */
360       function approve(address _spender, uint256 _value) public returns (bool) {
361         allowed[msg.sender][_spender] = _value;
362         Approval(msg.sender, _spender, _value);
363         return true;
364       }
365     
366       /**
367        * @dev Function to check the amount of tokens that an owner allowed to a spender.
368        * @param _owner address The address which owns the funds.
369        * @param _spender address The address which will spend the funds.
370        * @return A uint256 specifying the amount of tokens still available for the spender.
371        */
372       function allowance(address _owner, address _spender) public view returns (uint256) {
373         return allowed[_owner][_spender];
374       }
375     
376       /**
377        * @dev Increase the amount of tokens that an owner allowed to a spender.
378        *
379        * approve should be called when allowed[_spender] == 0. To increment
380        * allowed value is better to use this function to avoid 2 calls (and wait until
381        * the first transaction is mined)
382        * From MonolithDAO Token.sol
383        * @param _spender The address which will spend the funds.
384        * @param _addedValue The amount of tokens to increase the allowance by.
385        */
386       function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
387         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
388         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
389         return true;
390       }
391     
392       /**
393        * @dev Decrease the amount of tokens that an owner allowed to a spender.
394        *
395        * approve should be called when allowed[_spender] == 0. To decrement
396        * allowed value is better to use this function to avoid 2 calls (and wait until
397        * the first transaction is mined)
398        * From MonolithDAO Token.sol
399        * @param _spender The address which will spend the funds.
400        * @param _subtractedValue The amount of tokens to decrease the allowance by.
401        */
402       function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
403         uint oldValue = allowed[msg.sender][_spender];
404         if (_subtractedValue > oldValue) {
405           allowed[msg.sender][_spender] = 0;
406         } else {
407           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
408         }
409         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
410         return true;
411       }
412     
413     }
414     
415     
416     
417     
418     /**
419      * @title Mintable token
420      * @dev Simple ERC20 Token example, with mintable token creation
421      * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
422      * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
423      */
424     contract MintableToken is StandardToken, Ownable {
425       event Mint(address indexed to, uint256 amount);
426       event MintFinished();
427     
428       bool public mintingFinished = false;
429     
430     
431       modifier canMint() {
432         require(!mintingFinished);
433         _;
434       }
435     
436       /**
437        * @dev Function to mint tokens
438        * @param _to The address that will receive the minted tokens.
439        * @param _amount The amount of tokens to mint.
440        * @return A boolean that indicates if the operation was successful.
441        */
442       function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
443         totalSupply_ = totalSupply_.add(_amount);
444         balances[_to] = balances[_to].add(_amount);
445         Mint(_to, _amount);
446         Transfer(address(0), _to, _amount);
447         return true;
448       }
449     
450       /**
451        * @dev Function to stop minting new tokens.
452        * @return True if the operation was successful.
453        */
454       function finishMinting() onlyOwner canMint public returns (bool) {
455         mintingFinished = true;
456         MintFinished();
457         return true;
458       }
459     }
460     
461     
462     
463     
464     
465     
466     
467     
468     
469     
470     
471     
472     /**
473      * @title Burnable Token
474      * @dev Token that can be irreversibly burned (destroyed).
475      */
476     contract BurnableToken is BasicToken {
477     
478       event Burn(address indexed burner, uint256 value);
479     
480       /**
481        * @dev Burns a specific amount of tokens.
482        * @param _value The amount of token to be burned.
483        */
484       function burn(uint256 _value) public {
485         require(_value <= balances[msg.sender]);
486         // no need to require value <= totalSupply, since that would imply the
487         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
488     
489         address burner = msg.sender;
490         balances[burner] = balances[burner].sub(_value);
491         totalSupply_ = totalSupply_.sub(_value);
492         Burn(burner, _value);
493       }
494     }
495     
496     
497     
498     /**
499      * @title SocialMediaIncomeCrowdsaleToken
500      * @dev ERC20 Token that can be minted.
501      * It is meant to be used in a crowdsale contract.
502      */
503     contract SocialMediaIncomeCrowdsaleToken is MintableToken, BurnableToken {
504     
505         string public constant name = "Social Media Income"; // solium-disable-line uppercase
506         string public constant symbol = "SMI"; // solium-disable-line uppercase
507         uint8 public constant decimals = 18; // solium-disable-line uppercase
508     
509     }
510     
511     
512     /**
513      * @title SocialMediaIncomeCrowdsale
514      * @dev This is a fully fledged crowdsale.
515      * The way to add new features to a base crowdsale is by multiple inheritance.
516      *
517      * After adding multiple features it's good practice to run integration tests
518      * to ensure that subcontracts works together as intended.
519      */
520     contract SocialMediaIncomeCrowdsale is Crowdsale {
521     
522         function SocialMediaIncomeCrowdsale(uint256 _preIcoStartTime, uint256 _preIcoEndTime, uint256 _preIcoRate, uint256 _icoStartTime, uint256 _icoEndTime, uint256 _icoRate, address _wallet) public
523         Crowdsale(_preIcoStartTime, _preIcoEndTime, _preIcoRate, _icoStartTime, _icoEndTime, _icoRate, _wallet)
524         {
525     
526         }
527     
528         function createTokenContract() internal returns (MintableToken) {
529             return new SocialMediaIncomeCrowdsaleToken();
530         }
531     }