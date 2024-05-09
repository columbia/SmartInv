1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // CompositeCoin Presale. version 1.0
5 //
6 // Enjoy. (c) Slava Brall / Begemot-Begemot Ltd 2017. The MIT Licence.
7 // ----------------------------------------------------------------------------
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75    
76   function  transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     
79     
80    emit OwnershipTransferred(owner, newOwner); 
81     
82     owner = newOwner;
83   }
84 
85 }
86 /**
87  * @title ERC20Basic
88  * @dev Simpler version of ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/179
90  */
91 contract ERC20Basic {
92   uint256 public totalSupply;
93   function balanceOf(address who) public view returns (uint256);
94   function transfer(address to, uint256 value) public returns (bool);
95   event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) public view returns (uint256);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
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
118   /**
119   * @dev transfer token for a specified address
120   * @param _to The address to transfer to.
121   * @param _value The amount to be transferred.
122   */
123   function transfer(address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[msg.sender]);
126 
127     // SafeMath.sub will throw if there is not enough balance.
128     balances[msg.sender] = balances[msg.sender].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130   emit  Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of.
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) public view returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143 }
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170    emit Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186    emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    */
206   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
207     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213     uint oldValue = allowed[msg.sender][_spender];
214     if (_subtractedValue > oldValue) {
215       allowed[msg.sender][_spender] = 0;
216     } else {
217       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218     }
219    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223 }
224 /**
225  * @title Mintable token
226  * @dev Simple ERC20 Token example, with mintable token creation
227  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
228  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
229  */
230 
231 contract MintableToken is StandardToken, Ownable {
232   event Mint(address indexed to, uint256 amount);
233   event MintFinished();
234 
235   bool public mintingFinished = false;
236 
237 
238   modifier canMint() {
239     require(!mintingFinished);
240     _;
241   }
242 
243   /**
244    * @dev Function to mint tokens
245    * @param _to The address that will receive the minted tokens.
246    * @param _amount The amount of tokens to mint.
247    * @return A boolean that indicates if the operation was successful.
248    */
249   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
250     totalSupply = totalSupply.add(_amount);
251     balances[_to] = balances[_to].add(_amount);
252    emit Mint(_to, _amount);
253    emit Transfer(address(0), _to, _amount);
254     return true;
255   }
256 
257   /**
258    * @dev Function to stop minting new tokens.
259    * @return True if the operation was successful.
260    */
261   function finishMinting() onlyOwner canMint public returns (bool) {
262     mintingFinished = true;
263    emit MintFinished();
264     return true;
265   }
266 }
267 
268 //Token parameters
269 contract CompositeCoin is MintableToken {
270 
271 	string public constant name = "CompositeCoin";
272 	string public constant symbol = "CMN";
273 	uint public constant decimals = 18;
274 
275 }
276 
277 /**
278  * @title CompositeCoinCrowdsale
279  * @dev CompositeCoinCrowdsale is a base contract for managing a token crowdsale.
280  * Crowdsales have a start and end timestamps, where investors can make
281  * token purchases and the crowdsale will assign them tokens based
282  * on a token per ETH rate. Funds collected are forwarded to an owner
283  * as they arrive.
284  */
285 contract CompositeCoinCrowdsale is Ownable {
286 
287   using SafeMath for uint256;
288 
289   // The token being sold
290   CompositeCoin public token;
291 
292   uint256 public startTime = 0;
293   uint256 public endTime;
294   bool public isFinished = false;
295 
296   // how many ETH cost 10000 CMN. rate = 10000 CMN/ETH. It's always an integer!
297   //formula for rate: rate = 10000 * (CMN in USD) / (ETH in USD)
298   uint256 public rate;
299 
300   // amount of raised money in wei
301   uint256 public weiRaised;
302 
303   //string public saleStatus = "Don't started";
304   uint public tokensMinted = 0;
305 
306   uint public minimumSupply = 1; //minimum token amount to sale through one transaction
307 
308   uint public constant HARD_CAP_TOKENS = 1000000 * 10**18;
309 
310   event TokenPurchase(address indexed purchaser, uint256 value, uint256 ether_value, uint256 amount, uint256 tokens_amount, uint256 _tokensMinted, uint256 tokensSoldAmount);
311   event PresaleFinished();
312 
313 
314   function CompositeCoinCrowdsale(uint256 _rate) public {
315     require(_rate > 0);
316 	require (_rate < 10000);
317 
318     token = createTokenContract();
319     startTime = now;
320     rate = _rate;
321     owner = address(0xc5EaE151b4c8c88e2Fc76a33595657732D65004a);
322   }
323 
324 
325   function finishPresale() public onlyOwner {
326 	  isFinished = true;
327 	  endTime = now;
328 	  token.finishMinting();
329 	 emit PresaleFinished();
330   }
331 
332   function setRate(uint _rate) public onlyOwner {
333 	  require (_rate > 0);
334 	  require (_rate <=10000);
335 	  rate = _rate;
336   }
337 
338   function createTokenContract() internal returns (CompositeCoin) {
339     return new CompositeCoin();
340   }
341 
342 
343   // fallback function can be used to buy tokens
344   function () external payable {
345     buyTokens();
346   }
347 
348   // low level token purchase function
349   function buyTokens() public payable {
350     require(validPurchase());
351 
352     uint256 weiAmount = msg.value;
353 
354     // calculate token amount to be created
355     uint256 tokens = weiAmount.mul(10000).div(rate);
356 
357     mintToken(msg.sender, tokens, weiAmount);
358 
359     forwardFunds();
360   }
361 
362 
363   function forwardFunds() internal {
364     owner.transfer(msg.value);
365   }
366 
367   // @return true if the transaction can buy tokens
368   function validPurchase() internal view returns (bool) {
369     bool withinPeriod = startTime > 0 && !isFinished;
370     bool validAmount = msg.value >= (minimumSupply * 10**18 * rate).div(10000);
371     return withinPeriod && validAmount;
372   }
373 
374   function adminMint(address _to, uint256 _amount) onlyOwner public returns(bool) {
375       require(!isFinished);
376       uint256 weiAmount = _amount.div(10000).mul(rate);
377       return mintToken(_to, _amount, weiAmount);
378   }
379 
380   function mintToken(address _to, uint256 _amount, uint256 _value) private returns(bool) {
381       require(tokensMinted.add(_amount) <= HARD_CAP_TOKENS);
382       weiRaised = weiRaised.add(_value);
383       token.mint(_to, _amount);
384       tokensMinted = tokensMinted.add(_amount);
385     emit  TokenPurchase(_to, _value, _value.div(10**18), _amount, _amount.div(10**18), tokensMinted, tokensMinted.div(10**18));
386       return true;
387   }
388 
389 }