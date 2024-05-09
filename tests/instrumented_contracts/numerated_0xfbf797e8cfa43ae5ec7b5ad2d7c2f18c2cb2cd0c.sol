1 pragma solidity ^0.4.18;
2 
3 // File: source\zeppelin-solidity\contracts\math\SafeMath.sol
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
51 // File: source\zeppelin-solidity\contracts\ownership\Ownable.sol
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
93 // File: source\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
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
107 // File: source\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
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
154 // File: source\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
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
167 // File: source\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
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
264 // File: source\CappedMintableToken.sol
265 
266 /**
267  * @title Mintable token with an end-of-mint date and token cap
268  * Also transfer / transferFrom is available only after end-of-mint date
269  * Based on zeppelin-solidity MintableToken & CappedToken
270  */
271 contract CappedMintableToken is StandardToken, Ownable {
272   using SafeMath for uint256;
273 
274   event Mint(address indexed to, uint256 amount);
275 
276   modifier canMint() {
277     require(now <= publicSaleEnd);
278     _;
279   }
280 
281   modifier onlyOwnerOrCrowdsale() {
282     require(msg.sender == owner || msg.sender == crowdsale);
283     _;
284   }
285 
286   uint256 public publicSaleEnd;
287   uint256 public cap;
288   address public crowdsale;
289 
290 	function setCrowdsale(address _crowdsale) public onlyOwner {
291 		crowdsale = _crowdsale;
292 	}
293 
294   
295 
296   function CappedMintableToken(uint256 _cap, uint256 _publicSaleEnd) public {
297     require(_publicSaleEnd > now);
298     require(_cap > 0);
299 
300     publicSaleEnd = _publicSaleEnd;
301     cap = _cap;
302   }
303 
304   /* StartICO integration, lockTime is ignored (ignore the warning) */
305   function send(address target, uint256 mintedAmount, uint256 lockTime) public onlyOwnerOrCrowdsale {
306     mint(target, mintedAmount);
307   }
308 
309   /**
310    * @dev Function to mint tokens
311    * @param _to The address that will receive the minted tokens.
312    * @param _amount The amount of tokens to mint.
313    * @return A boolean that indicates if the operation was successful.
314    */
315   function mint(address _to, uint256 _amount) onlyOwnerOrCrowdsale canMint public returns (bool) {
316     require(totalSupply_.add(_amount) <= cap);
317     require(_amount > 0);
318 
319     totalSupply_ = totalSupply_.add(_amount);
320     balances[_to] = balances[_to].add(_amount);
321     Mint(_to, _amount);
322     Transfer(address(0), _to, _amount);
323     return true;
324   }
325 
326   
327   function transfer(address _to, uint256 _value) public returns (bool) {
328     require(now > publicSaleEnd);
329 
330     return super.transfer(_to, _value);
331   }
332 
333   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
334     require(now > publicSaleEnd);
335 
336     return super.transferFrom(_from, _to, _value);
337   }
338   
339 }
340 
341 // File: source\zeppelin-solidity\contracts\ownership\HasNoEther.sol
342 
343 /**
344  * @title Contracts that should not own Ether
345  * @author Remco Bloemen <remco@2π.com>
346  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
347  * in the contract, it will allow the owner to reclaim this ether.
348  * @notice Ether can still be send to this contract by:
349  * calling functions labeled `payable`
350  * `selfdestruct(contract_address)`
351  * mining directly to the contract address
352 */
353 contract HasNoEther is Ownable {
354 
355   /**
356   * @dev Constructor that rejects incoming Ether
357   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
358   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
359   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
360   * we could use assembly to access msg.value.
361   */
362   function HasNoEther() public payable {
363     require(msg.value == 0);
364   }
365 
366   /**
367    * @dev Disallows direct send by settings a default function without the `payable` flag.
368    */
369   function() external {
370   }
371 
372   /**
373    * @dev Transfer all Ether held by the contract to the owner.
374    */
375   function reclaimEther() external onlyOwner {
376     assert(owner.send(this.balance));
377   }
378 }
379 
380 // File: source\GMBCToken.sol
381 
382 contract GMBCToken is HasNoEther, CappedMintableToken {
383 	using SafeMath for uint256;
384 
385 	string public constant name = "Gamblica Token";
386 	string public constant symbol = "GMBC";
387 	uint8 public constant decimals = 18;
388 
389 	uint256 public TOKEN_SALE_CAP = 600000000 * (10 ** uint256(decimals));	// 60%, 40% will be minted on finalize
390 	uint256 public END_OF_MINT_DATE = 1527811200;	// Fri, 01 Jun 2018 00:00:00 +0000 in RFC 822, 1036, 1123, 2822
391 
392 	bool public finalized = false;
393 
394 	/**
395 	 * GMBCToken
396 	 * https://gamblica.com 
397 	 * Official Gamblica Coin (Token)
398 	 */
399 	function GMBCToken() public 
400 		CappedMintableToken(TOKEN_SALE_CAP, END_OF_MINT_DATE)
401 	{}
402 
403 	/**
404 		Performs the final stage of the token sale, 
405 		mints additional 40% of token fund,
406 		transfers minted tokens to an external fund
407 		(20% game fund, 10% team, 5% advisory board, 3% bounty, 2% founders)
408 	*/
409 	function finalize(address _fund) public onlyOwner returns (bool) {
410 		require(!finalized && now > publicSaleEnd);		
411 		require(_fund != address(0));
412 
413 		uint256 amount = totalSupply_.mul(4).div(6);	// +40% 
414 
415 		totalSupply_ = totalSupply_.add(amount);
416     	balances[_fund] = balances[_fund].add(amount);
417     	Mint(_fund, amount);
418     	Transfer(address(0), _fund, amount);
419     
420 		finalized = true;
421 
422 		return true;
423 	}
424 
425 
426 	
427 }