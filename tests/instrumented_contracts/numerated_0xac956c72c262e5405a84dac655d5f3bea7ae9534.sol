1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) public view returns (uint256);
58   function transferFrom(address from, address to, uint256 value) public returns (bool);
59   function approve(address spender, uint256 value) public returns (bool);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0));
79     require(_value <= balances[msg.sender]);
80 
81     // SafeMath.sub will throw if there is not enough balance.
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of.
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93   function balanceOf(address _owner) public view returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[_from]);
121     require(_value <= allowed[_from][msg.sender]);
122 
123     balances[_from] = balances[_from].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    *
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param _owner address The address which owns the funds.
149    * @param _spender address The address which will spend the funds.
150    * @return A uint256 specifying the amount of tokens still available for the spender.
151    */
152   function allowance(address _owner, address _spender) public view returns (uint256) {
153     return allowed[_owner][_spender];
154   }
155 
156   /**
157    * @dev Increase the amount of tokens that an owner allowed to a spender.
158    *
159    * approve should be called when allowed[_spender] == 0. To increment
160    * allowed value is better to use this function to avoid 2 calls (and wait until
161    * the first transaction is mined)
162    * From MonolithDAO Token.sol
163    * @param _spender The address which will spend the funds.
164    * @param _addedValue The amount of tokens to increase the allowance by.
165    */
166   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   /**
173    * @dev Decrease the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To decrement
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _subtractedValue The amount of tokens to decrease the allowance by.
181    */
182   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
183     uint oldValue = allowed[msg.sender][_spender];
184     if (_subtractedValue > oldValue) {
185       allowed[msg.sender][_spender] = 0;
186     } else {
187       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
188     }
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193 }
194 
195 contract NodeToken is StandardToken {
196     string public name = "NodePower";
197     string public symbol = "NODE";
198     uint8 public decimals = 2;
199     bool public mintingFinished = false;
200     mapping (address => bool) owners;
201     mapping (address => bool) minters;
202 
203     event Mint(address indexed to, uint256 amount);
204     event MintFinished();
205     event OwnerAdded(address indexed newOwner);
206     event OwnerRemoved(address indexed removedOwner);
207     event MinterAdded(address indexed newMinter);
208     event MinterRemoved(address indexed removedMinter);
209     event Burn(address indexed burner, uint256 value);
210 
211     function NodeToken() public {
212         owners[msg.sender] = true;
213     }
214 
215     /**
216      * @dev Function to mint tokens
217      * @param _to The address that will receive the minted tokens.
218      * @param _amount The amount of tokens to mint.
219      * @return A boolean that indicates if the operation was successful.
220      */
221     function mint(address _to, uint256 _amount) onlyMinter public returns (bool) {
222         require(!mintingFinished);
223         totalSupply = totalSupply.add(_amount);
224         balances[_to] = balances[_to].add(_amount);
225         Mint(_to, _amount);
226         Transfer(address(0), _to, _amount);
227         return true;
228     }
229 
230     /**
231      * @dev Function to stop minting new tokens.
232      * @return True if the operation was successful.
233      */
234     function finishMinting() onlyOwner public returns (bool) {
235         require(!mintingFinished);
236         mintingFinished = true;
237         MintFinished();
238         return true;
239     }
240 
241     /**
242      * @dev Burns a specific amount of tokens.
243      * @param _value The amount of token to be burned.
244      */
245     function burn(uint256 _value) public {
246         require(_value <= balances[msg.sender]);
247         // no need to require value <= totalSupply, since that would imply the
248         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
249 
250         address burner = msg.sender;
251         balances[burner] = balances[burner].sub(_value);
252         totalSupply = totalSupply.sub(_value);
253         Burn(burner, _value);
254     }
255 
256     /**
257      * @dev Adds administrative role to address
258      * @param _address The address that will get administrative privileges
259      */
260     function addOwner(address _address) onlyOwner public {
261         owners[_address] = true;
262         OwnerAdded(_address);
263     }
264 
265     /**
266      * @dev Removes administrative role from address
267      * @param _address The address to remove administrative privileges from
268      */
269     function delOwner(address _address) onlyOwner public {
270         owners[_address] = false;
271         OwnerRemoved(_address);
272     }
273 
274     /**
275      * @dev Throws if called by any account other than the owner.
276      */
277     modifier onlyOwner() {
278         require(owners[msg.sender]);
279         _;
280     }
281 
282     /**
283      * @dev Adds minter role to address (able to create new tokens)
284      * @param _address The address that will get minter privileges
285      */
286     function addMinter(address _address) onlyOwner public {
287         minters[_address] = true;
288         MinterAdded(_address);
289     }
290 
291     /**
292      * @dev Removes minter role from address
293      * @param _address The address to remove minter privileges
294      */
295     function delMinter(address _address) onlyOwner public {
296         minters[_address] = false;
297         MinterRemoved(_address);
298     }
299 
300     /**
301      * @dev Throws if called by any account other than the minter.
302      */
303     modifier onlyMinter() {
304         require(minters[msg.sender]);
305         _;
306     }
307 }
308 
309 
310 /**
311  * @title Crowdsale
312  * @dev Crowdsale is a base contract for managing a token crowdsale.
313  * Crowdsales have a start and end timestamps, where investors can make
314  * token purchases and the crowdsale will assign them tokens based
315  * on a token per ETH rate. Funds collected are forwarded to a wallet
316  * as they arrive.
317  */
318 contract NodeCrowdsale {
319     using SafeMath for uint256;
320 
321     // The token being sold
322     NodeToken public token;
323 
324     // address where funds are collected
325     address public wallet;
326 
327     // address where funds are collected
328     address public owner;
329 
330     // USD cents per ETH exchange rate
331     uint256 public rateUSDcETH;
332 
333     // PreITO discount is 45%
334     uint public constant bonusTokensPercent = 45;
335 
336     // PreITO ends on 2018-01-31 23:59:59 UTC
337     uint256 public constant endTime = 1517443199;
338 
339     // Minimum Deposit in USD cents
340     uint256 public constant minContributionUSDc = 1000;
341 
342 
343     // amount of raised money in wei
344     uint256 public weiRaised;
345 
346     /**
347      * event for token purchase logging
348      * @param purchaser who paid for the tokens
349      * @param beneficiary who got the tokens
350      * @param value weis paid for purchase
351      * @param amount amount of tokens purchased
352      */
353     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
354     event RateUpdate(uint256 rate);
355 
356     function NodeCrowdsale(address _tokenAddress, uint256 _initialRate) public {
357         require(_tokenAddress != address(0));
358         token = NodeToken(_tokenAddress);
359         rateUSDcETH = _initialRate;
360         wallet = msg.sender;
361         owner = msg.sender;
362     }
363 
364 
365     // fallback function can be used to buy tokens
366     function () external payable {
367         buyTokens(msg.sender);
368     }
369 
370     // low level token purchase function
371     function buyTokens(address beneficiary) public payable {
372         require(beneficiary != address(0));
373         require(msg.value != 0);
374         require(now <= endTime);
375 
376         uint256 weiAmount = msg.value;
377 
378         require(calculateUSDcValue(weiAmount) >= minContributionUSDc);
379 
380         // calculate token amount to be created
381         uint256 tokens = calculateTokenAmount(weiAmount);
382 
383         // update state
384         weiRaised = weiRaised.add(weiAmount);
385 
386         token.mint(beneficiary, tokens);
387         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
388 
389         forwardFunds();
390     }
391 
392     // set rate
393     function setRate(uint256 _rateUSDcETH) public onlyOwner {
394         // don't allow to change rate more than 10%
395         assert(_rateUSDcETH < rateUSDcETH.mul(110).div(100));
396         assert(_rateUSDcETH > rateUSDcETH.mul(90).div(100));
397         rateUSDcETH = _rateUSDcETH;
398         RateUpdate(rateUSDcETH);
399     }
400 
401     /**
402      * @dev Throws if called by any account other than the owner.
403      */
404     modifier onlyOwner() {
405         require(msg.sender == owner);
406         _;
407     }
408 
409     // calculate deposit value in USD Cents
410     function calculateUSDcValue(uint256 _weiDeposit) public view returns (uint256) {
411 
412         // wei per USD cent
413         uint256 weiPerUSDc = 1 ether/rateUSDcETH;
414 
415         // Deposited value converted to USD cents
416         uint256 depositValueInUSDc = _weiDeposit.div(weiPerUSDc);
417         return depositValueInUSDc;
418     }
419 
420     // calculates how much tokens will beneficiary get
421     // for given amount of wei
422     function calculateTokenAmount(uint256 _weiDeposit) public view returns (uint256) {
423         uint256 mainTokens = calculateUSDcValue(_weiDeposit);
424         uint256 bonusTokens = mainTokens.mul(bonusTokensPercent).div(100);
425         return mainTokens.add(bonusTokens);
426     }
427 
428     // send ether to the fund collection wallet
429     // override to create custom fund forwarding mechanisms
430     function forwardFunds() internal {
431         wallet.transfer(msg.value);
432     }
433 
434 
435 
436 }