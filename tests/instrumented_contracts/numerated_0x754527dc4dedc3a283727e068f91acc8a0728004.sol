1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 contract WhitelistInterface {
63     function checkWhitelist(address _whiteListAddress) public view returns(bool);
64 }
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72   function totalSupply() public view returns (uint256);
73   function balanceOf(address who) public view returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that throw on error
81  */
82 library SafeMath {
83 
84   /**
85   * @dev Multiplies two numbers, throws on overflow.
86   */
87   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
88     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
89     // benefit is lost if 'b' is also tested.
90     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91     if (a == 0) {
92       return 0;
93     }
94 
95     c = a * b;
96     assert(c / a == b);
97     return c;
98   }
99 
100   /**
101   * @dev Integer division of two numbers, truncating the quotient.
102   */
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     // assert(b > 0); // Solidity automatically throws when dividing by 0
105     // uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107     return a / b;
108   }
109 
110   /**
111   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
112   */
113   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114     assert(b <= a);
115     return a - b;
116   }
117 
118   /**
119   * @dev Adds two numbers, throws on overflow.
120   */
121   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
122     c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is ERC20Basic {
133   using SafeMath for uint256;
134 
135   mapping(address => uint256) balances;
136 
137   uint256 totalSupply_;
138 
139   /**
140   * @dev total number of tokens in existence
141   */
142   function totalSupply() public view returns (uint256) {
143     return totalSupply_;
144   }
145 
146   /**
147   * @dev transfer token for a specified address
148   * @param _to The address to transfer to.
149   * @param _value The amount to be transferred.
150   */
151   function transfer(address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[msg.sender]);
154 
155     balances[msg.sender] = balances[msg.sender].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     emit Transfer(msg.sender, _to, _value);
158     return true;
159   }
160 
161   /**
162   * @dev Gets the balance of the specified address.
163   * @param _owner The address to query the the balance of.
164   * @return An uint256 representing the amount owned by the passed address.
165   */
166   function balanceOf(address _owner) public view returns (uint256) {
167     return balances[_owner];
168   }
169 
170 }
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  */
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender)
178     public view returns (uint256);
179 
180   function transferFrom(address from, address to, uint256 value)
181     public returns (bool);
182 
183   function approve(address spender, uint256 value) public returns (bool);
184   event Approval(
185     address indexed owner,
186     address indexed spender,
187     uint256 value
188   );
189 }
190 
191 /**
192  * @title Standard ERC20 token
193  *
194  * @dev Implementation of the basic standard token.
195  * @dev https://github.com/ethereum/EIPs/issues/20
196  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  */
198 contract StandardToken is ERC20, BasicToken {
199 
200   mapping (address => mapping (address => uint256)) internal allowed;
201 
202 
203   /**
204    * @dev Transfer tokens from one address to another
205    * @param _from address The address which you want to send tokens from
206    * @param _to address The address which you want to transfer to
207    * @param _value uint256 the amount of tokens to be transferred
208    */
209   function transferFrom(
210     address _from,
211     address _to,
212     uint256 _value
213   )
214     public
215     returns (bool)
216   {
217     require(_to != address(0));
218     require(_value <= balances[_from]);
219     require(_value <= allowed[_from][msg.sender]);
220 
221     balances[_from] = balances[_from].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224     emit Transfer(_from, _to, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230    *
231    * Beware that changing an allowance with this method brings the risk that someone may use both the old
232    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235    * @param _spender The address which will spend the funds.
236    * @param _value The amount of tokens to be spent.
237    */
238   function approve(address _spender, uint256 _value) public returns (bool) {
239     allowed[msg.sender][_spender] = _value;
240     emit Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Function to check the amount of tokens that an owner allowed to a spender.
246    * @param _owner address The address which owns the funds.
247    * @param _spender address The address which will spend the funds.
248    * @return A uint256 specifying the amount of tokens still available for the spender.
249    */
250   function allowance(
251     address _owner,
252     address _spender
253    )
254     public
255     view
256     returns (uint256)
257   {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(
272     address _spender,
273     uint _addedValue
274   )
275     public
276     returns (bool)
277   {
278     allowed[msg.sender][_spender] = (
279       allowed[msg.sender][_spender].add(_addedValue));
280     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284   /**
285    * @dev Decrease the amount of tokens that an owner allowed to a spender.
286    *
287    * approve should be called when allowed[_spender] == 0. To decrement
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    * @param _spender The address which will spend the funds.
292    * @param _subtractedValue The amount of tokens to decrease the allowance by.
293    */
294   function decreaseApproval(
295     address _spender,
296     uint _subtractedValue
297   )
298     public
299     returns (bool)
300   {
301     uint oldValue = allowed[msg.sender][_spender];
302     if (_subtractedValue > oldValue) {
303       allowed[msg.sender][_spender] = 0;
304     } else {
305       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
306     }
307     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308     return true;
309   }
310 
311 }
312 
313 /**
314  * @title DetailedERC20 token
315  * @dev The decimals are only for visualization purposes.
316  * All the operations are done using the smallest and indivisible token unit,
317  * just as on Ethereum all the operations are done in wei.
318  */
319 contract DetailedERC20 is ERC20 {
320   string public name;
321   string public symbol;
322   uint8 public decimals;
323 
324   constructor(string _name, string _symbol, uint8 _decimals) public {
325     name = _name;
326     symbol = _symbol;
327     decimals = _decimals;
328   }
329 }
330 
331 /**
332  * @title Math
333  * @dev Assorted math operations
334  */
335 library Math {
336   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
337     return a >= b ? a : b;
338   }
339 
340   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
341     return a < b ? a : b;
342   }
343 
344   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
345     return a >= b ? a : b;
346   }
347 
348   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
349     return a < b ? a : b;
350   }
351 }
352 
353 /**
354 * @title TuurntToken 
355 * @dev The TuurntToken contract contains the information about 
356 * Tuurnt token.
357 */
358 
359 
360 
361 
362 
363 contract TuurntToken is StandardToken, DetailedERC20 {
364 
365     using SafeMath for uint256;
366 
367     // distribution variables
368     uint256 public tokenAllocToTeam;
369     uint256 public tokenAllocToCrowdsale;
370     uint256 public tokenAllocToCompany;
371 
372     // addresses
373     address public crowdsaleAddress;
374     address public teamAddress;
375     address public companyAddress;
376     
377 
378     /**
379     * @dev The TuurntToken constructor set the orginal crowdsaleAddress,teamAddress and companyAddress and allocate the
380     * tokens to them.
381     * @param _crowdsaleAddress The address of crowsale contract
382     * @param _teamAddress The address of team
383     * @param _companyAddress The address of company 
384     */
385 
386     constructor(address _crowdsaleAddress, address _teamAddress, address _companyAddress, string _name, string _symbol, uint8 _decimals) public 
387         DetailedERC20(_name, _symbol, _decimals)
388     {
389         require(_crowdsaleAddress != address(0));
390         require(_teamAddress != address(0));
391         require(_companyAddress != address(0));
392         totalSupply_ = 500000000 * 10 ** 18;
393         tokenAllocToTeam = (totalSupply_.mul(33)).div(100);     // 33 % Allocation
394         tokenAllocToCompany = (totalSupply_.mul(33)).div(100);  // 33 % Allocation 
395         tokenAllocToCrowdsale = (totalSupply_.mul(34)).div(100);// 34 % Allocation
396 
397         // Address      
398         crowdsaleAddress = _crowdsaleAddress;
399         teamAddress = _teamAddress;
400         companyAddress = _companyAddress;
401         
402 
403         // Allocations
404         balances[crowdsaleAddress] = tokenAllocToCrowdsale;
405         balances[companyAddress] = tokenAllocToCompany;
406         balances[teamAddress] = tokenAllocToTeam; 
407        
408         //transfer event
409         emit Transfer(address(0), crowdsaleAddress, tokenAllocToCrowdsale);
410         emit Transfer(address(0), companyAddress, tokenAllocToCompany);
411         emit Transfer(address(0), teamAddress, tokenAllocToTeam);
412        
413         
414     }  
415 }
416 
417 contract TuurntAirdrop is Ownable {
418 
419     using SafeMath for uint256;
420 
421     TuurntToken public token;
422     WhitelistInterface public whitelist;
423 
424     mapping(address=>bool) public userAddress;
425 
426     uint256 public totalDropAmount;
427     uint256 public dropAmount = 100 * 10 ** 18;
428     
429     /**
430     * @dev TuurntAirdrop constructor set the whitelist contract address.
431     * @param _whitelist Whitelist contract address  
432     */
433     constructor(address _whitelist) public{
434         whitelist = WhitelistInterface(_whitelist);
435     }
436 
437     /**
438     * @dev Set the token contract address.
439     * @param _tokenAddress token contract address
440     */
441     function setTokenAddress(address _tokenAddress) onlyOwner public {
442         token = TuurntToken(_tokenAddress);
443     }
444 
445     /**
446     * @dev User can withdraw there airdrop tokens if address exist in the whitelist. 
447     */
448     function airdropToken() external{
449         require(whitelist.checkWhitelist(msg.sender));
450         require(userAddress[msg.sender] == false);
451         totalDropAmount = totalDropAmount.add(dropAmount);
452         userAddress[msg.sender] = true;
453         require(token.transfer(msg.sender,dropAmount));
454     }
455 
456     /**
457     * @dev Founder can withdraw the remaining tokens of airdrop contract.
458     * @param _addr Address where the remaining tokens will go.
459     */
460     function withdrawToken(address _addr) onlyOwner external{
461         require(_addr != address(0));
462         uint256 amount = token.balanceOf(this);
463         require(token.transfer(_addr,amount));
464     }
465 
466 }