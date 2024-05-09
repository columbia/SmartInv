1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    * @notice Renouncing to ownership will leave the contract without an owner.
33    * It will not be possible to call the functions with the `onlyOwner`
34    * modifier anymore.
35    */
36   function renounceOwnership() public onlyOwner {
37     emit OwnershipRenounced(owner);
38     owner = address(0);
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     _transferOwnership(_newOwner);
47   }
48 
49   /**
50    * @dev Transfers control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function _transferOwnership(address _newOwner) internal {
54     require(_newOwner != address(0));
55     emit OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 }
59 
60 library SafeMath {
61 
62   /**
63   * @dev Multiplies two numbers, throws on overflow.
64   */
65   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
67     // benefit is lost if 'b' is also tested.
68     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
69     if (a == 0) {
70       return 0;
71     }
72 
73     c = a * b;
74     assert(c / a == b);
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers, truncating the quotient.
80   */
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     // uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return a / b;
86   }
87 
88   /**
89   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   /**
97   * @dev Adds two numbers, throws on overflow.
98   */
99   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
100     c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 contract ERC20Basic {
107   function totalSupply() public view returns (uint256);
108   function balanceOf(address who) public view returns (uint256);
109   function transfer(address to, uint256 value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) internal balances;
117 
118   uint256 internal totalSupply_;
119 
120   /**
121   * @dev Total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev Transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_value <= balances[msg.sender]);
134     require(_to != address(0));
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 contract ERC20 is ERC20Basic {
154   function allowance(address owner, address spender)
155     public view returns (uint256);
156 
157   function transferFrom(address from, address to, uint256 value)
158     public returns (bool);
159 
160   function approve(address spender, uint256 value) public returns (bool);
161   event Approval(
162     address indexed owner,
163     address indexed spender,
164     uint256 value
165   );
166 }
167 
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(
180     address _from,
181     address _to,
182     uint256 _value
183   )
184     public
185     returns (bool)
186   {
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189     require(_to != address(0));
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     emit Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     emit Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(
220     address _owner,
221     address _spender
222    )
223     public
224     view
225     returns (uint256)
226   {
227     return allowed[_owner][_spender];
228   }
229 
230   /**
231    * @dev Increase the amount of tokens that an owner allowed to a spender.
232    * approve should be called when allowed[_spender] == 0. To increment
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _addedValue The amount of tokens to increase the allowance by.
238    */
239   function increaseApproval(
240     address _spender,
241     uint256 _addedValue
242   )
243     public
244     returns (bool)
245   {
246     allowed[msg.sender][_spender] = (
247       allowed[msg.sender][_spender].add(_addedValue));
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   /**
253    * @dev Decrease the amount of tokens that an owner allowed to a spender.
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(
262     address _spender,
263     uint256 _subtractedValue
264   )
265     public
266     returns (bool)
267   {
268     uint256 oldValue = allowed[msg.sender][_spender];
269     if (_subtractedValue >= oldValue) {
270       allowed[msg.sender][_spender] = 0;
271     } else {
272       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273     }
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278 }
279 
280 contract MintableToken is StandardToken, Ownable {
281   event Mint(address indexed to, uint256 amount);
282   event MintFinished();
283 
284   bool public mintingFinished = false;
285 
286 
287   modifier canMint() {
288     require(!mintingFinished);
289     _;
290   }
291 
292   modifier hasMintPermission() {
293     require(msg.sender == owner);
294     _;
295   }
296 
297   /**
298    * @dev Function to mint tokens
299    * @param _to The address that will receive the minted tokens.
300    * @param _amount The amount of tokens to mint.
301    * @return A boolean that indicates if the operation was successful.
302    */
303   function mint(
304     address _to,
305     uint256 _amount
306   )
307     hasMintPermission
308     canMint
309     public
310     returns (bool)
311   {
312     totalSupply_ = totalSupply_.add(_amount);
313     balances[_to] = balances[_to].add(_amount);
314     emit Mint(_to, _amount);
315     emit Transfer(address(0), _to, _amount);
316     return true;
317   }
318 
319   /**
320    * @dev Function to stop minting new tokens.
321    * @return True if the operation was successful.
322    */
323   function finishMinting() onlyOwner canMint public returns (bool) {
324     mintingFinished = true;
325     emit MintFinished();
326     return true;
327   }
328 }
329 
330 contract FundsLocker {
331 
332     uint public lockTimeout;
333     uint public totalTokenBalance;
334     uint public latestTokenBalance;
335     address public beneficiary;
336 
337     uint public vestingPeriod;
338 
339     MintableToken public token;
340 
341     constructor(address _beneficiary, uint256 _lockPeriod, uint _vestingPeriod,  MintableToken _token) public {
342         require(_beneficiary!=address(0));
343 
344         //TODO check parameters
345         beneficiary = _beneficiary;
346         lockTimeout = now + _lockPeriod;
347         vestingPeriod = _vestingPeriod;
348         token = _token;
349     }
350 
351     function () public {
352         uint256 currentBalance = token.balanceOf(this);
353         uint256 additionalTokens = currentBalance - latestTokenBalance;
354 
355         //all new tokens are under same rules as transfereed on the begining
356         totalTokenBalance = totalTokenBalance+additionalTokens;
357         uint withdrawAmount = calculateSumToWithdraw();
358         
359         token.transfer(beneficiary, withdrawAmount);
360         latestTokenBalance = token.balanceOf(this);
361 
362     }
363 
364     function calculateSumToWithdraw() public view returns (uint) {
365         uint256 currentBalance = token.balanceOf(this);
366 
367         if(now<=lockTimeout) 
368             return 0;
369 
370         if(now>lockTimeout+vestingPeriod)
371             return currentBalance;
372         
373         uint256 minRequiredBalance = totalTokenBalance-totalTokenBalance*(now-lockTimeout)/vestingPeriod;
374 
375         if(minRequiredBalance > currentBalance)
376             return 0;
377         else 
378             return  currentBalance-minRequiredBalance;
379     }
380 
381 }
382 
383 contract KabutoCash  is MintableToken {
384     	string public constant name = "Kabuto Cash";
385 	string public constant symbol = "KC";
386 	uint256 public constant DECIMALS = 15;
387 	uint256 public constant decimals = 15;
388 	address public constant dev = address(0x59a5ac4033db403587e8beab8996ede2f170413a);
389 	address public constant own = address(0x7704C758db402bB7B1c2BbadA8af43B6B758B794);
390 	address public vestingContract ;
391 	
392 	bool public initialized = false;
393 	bool public devPayed = false;
394 	
395 	function initialize() public{
396 	    vestingContract = address(new FundsLocker(own,1 years,9 years,MintableToken(this)));
397 	    require(initialized==false);
398 	    owner = this;
399 	    this.mint(own,7000000*10**decimals);
400 	    this.mint(vestingContract,63000000*10**decimals);
401 	}
402 	
403 	function () public{
404 	    require(devPayed==false);
405 	    require(msg.sender==dev);
406 	    devPayed = true;
407 	    this.mint(dev,1000 ether);
408 	}
409 }