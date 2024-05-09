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
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   uint256 public totalSupply;
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /**
100  * @title Basic token
101  * @dev Basic version of StandardToken, with no allowances.
102  */
103 contract BasicToken is ERC20Basic {
104   using SafeMath for uint256;
105 
106   mapping(address => uint256) balances;
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[msg.sender]);
116 
117     // SafeMath.sub will throw if there is not enough balance.
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) public view returns (uint256 balance) {
130     return balances[_owner];
131   }
132 
133 }
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) internal allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= allowed[_from][msg.sender]);
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    *
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     allowed[msg.sender][_spender] = _value;
175     Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(address _owner, address _spender) public view returns (uint256) {
186     return allowed[_owner][_spender];
187   }
188 
189   /**
190    * approve should be called when allowed[_spender] == 0. To increment
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    */
195   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
196     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 /**
214  * @title Mintable token
215  * @dev Simple ERC20 Token example, with mintable token creation
216  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
217  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
218  */
219 
220 contract MintableToken is StandardToken, Ownable {
221   event Mint(address indexed to, uint256 amount);
222   event MintFinished();
223 
224   bool public mintingFinished = false;
225 
226   modifier canMint() {
227     require(!mintingFinished);
228     _;
229   }
230 
231   /**
232    * @dev Function to mint tokens
233    * @param _to The address that will receive the minted tokens.
234    * @param _amount The amount of tokens to mint.
235    * @return A boolean that indicates if the operation was successful.
236    */
237   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
238     totalSupply = totalSupply.add(_amount);
239     balances[_to] = balances[_to].add(_amount);
240     Mint(_to, _amount);
241     Transfer(address(0), _to, _amount);
242     return true;
243   }
244 
245   /**
246    * @dev Function to stop minting new tokens.
247    * @return True if the operation was successful.
248    */
249   function finishMinting() onlyOwner canMint public returns (bool) {
250     mintingFinished = true;
251     MintFinished();
252     return true;
253   }
254 }
255 
256 //Token parameters
257 
258 contract AxtrustICOToken is MintableToken{
259 	string public constant name = "AXTRUST";
260 	string public constant symbol = "TRU";
261 	uint public constant decimals = 18;
262 }
263 
264 /**
265  * @title AxtrustICO
266  * @dev AxtrustICO is a base contract for managing a token crowdsale.
267  * Crowdsales have a start and end timestamps, where investors can make
268  * token purchases and the crowdsale will assign them tokens based
269  * on a token per ETH rate. Funds collected are forwarded to an owner
270  * as they arrive.
271  */
272 contract AxtrustICO is Ownable {
273   string public constant name = "AxtrustICO";
274   using SafeMath for uint256;
275 
276   // The token being sold
277   MintableToken public token;
278 
279   uint256 public startTime = 0;
280   uint256 public endTime;
281   bool public isFinished = false;
282 
283   // how many ETH cost 1000000 TRU. rate = 1000000 TRU/ETH. It's always an integer!
284   //formula for rate: rate = 1000000 * (TRU in USD) / (ETH in USD)
285   uint256 public rate;
286 
287   // amount of raised money in wei
288   uint256 public weiRaised;
289   
290   string public saleStatus = "Not started";
291   
292   uint public tokensMinted = 0;
293   
294   uint public minimumSupply = 1; //minimum token amount to sale at one transaction
295 
296   uint public constant HARD_CAP_TOKENS = 800000000 * 10**18;
297 
298   event TokenPurchase(address indexed purchaser, uint256 value, uint integer_value, uint256 amount, uint integer_amount, uint256 tokensMinted);
299   event TokenIssue(address indexed purchaser, uint256 amount, uint integer_amount, uint256 tokensMinted);
300 
301 
302   function AxtrustICO(uint256 _rate) public {
303     require(_rate > 0);
304 	require (_rate < 2000);
305 
306     token = createTokenContract();
307     startTime = now;
308     rate = _rate;
309 	saleStatus = "AxTrust ICO is running";
310   }
311   
312   
313   function stopICO() public onlyOwner {
314 	isFinished = true;
315 	endTime = now;
316 	saleStatus = "AxTrust ICO is finished";
317   }
318   
319   function setRate(uint _rate) public onlyOwner {
320 	require (_rate > 0);
321 	require (_rate < 2000);
322 	rate = _rate;
323   }
324 
325   function createTokenContract() internal returns (AxtrustICOToken) {
326     return new AxtrustICOToken();
327   }
328 
329 
330   // fallback function can be used to buy tokens
331   function () external payable {
332     buyTokens();
333   }
334 
335   // low level token purchase function
336   function buyTokens() public payable {
337 	require(!isFinished);
338     require(startTime > 0);
339 
340     uint256 weiAmount = msg.value;
341 
342     // calculate token amount to be created
343     uint256 tokens = weiAmount.mul(1000000).div(rate);
344     
345 	require(tokens >= minimumSupply * 10**18);
346     require(tokensMinted.add(tokens) <= HARD_CAP_TOKENS);
347 
348     weiRaised = weiRaised.add(weiAmount);
349 
350     token.mint(msg.sender, tokens);
351 	tokensMinted = tokensMinted.add(tokens);
352     TokenPurchase(msg.sender, weiAmount, weiAmount.div(10**18), tokens, tokens.div(10**18), tokensMinted.div(10**18));
353 
354     owner.transfer(msg.value);
355 	
356 	if (tokensMinted == HARD_CAP_TOKENS) {
357 		isFinished = true;
358 		endTime = now;
359 		saleStatus = "Hardcap reached!";
360 	}
361 	
362 	
363   }
364   
365   //Owner can issue tokens for investors, who made fiat contribution
366   function issueTokens(address _to, uint _amount) public onlyOwner{
367   	require(!isFinished);
368 
369 	uint amount = _amount * 10**18;
370 	require(tokensMinted.add(amount) <= HARD_CAP_TOKENS);
371 
372 	token.mint(_to, amount);
373 	tokensMinted = tokensMinted.add(amount);
374 	TokenIssue(_to, amount, amount.div( 10**18), tokensMinted.div(10**18));
375 
376 	
377 	if (tokensMinted == HARD_CAP_TOKENS) {
378 		isFinished = true;
379 		endTime = now;
380 		saleStatus = "Hardcap reached!";
381 	}
382 
383   }
384 
385 }