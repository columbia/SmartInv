1 pragma solidity ^0.4.24;
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
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 // File: contracts\Haltable.sol
44 
45 /*
46  * Haltable
47  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
48  * Originally envisioned in FirstBlood ICO contract.
49  */
50 contract Haltable is Ownable {
51   bool public halted;
52 
53   modifier stopInEmergency {
54     require(!halted);
55     _;
56   }
57 
58   modifier stopNonOwnersInEmergency {
59     require(!halted && msg.sender == owner);
60     _;
61   }
62 
63   modifier onlyInEmergency {
64     require(halted);
65     _;
66   }
67 
68   // called by the owner on emergency, triggers stopped state
69   function halt() external onlyOwner {
70     halted = true;
71   }
72 
73   // called by the owner on end of emergency, returns to normal state
74   function unhalt() external onlyOwner onlyInEmergency {
75     halted = false;
76   }
77 
78 }
79 
80 // File: contracts\math\SafeMath.sol
81 
82 /**
83  * @title SafeMath
84  * @dev Math operations with safety checks that throw on error
85  */
86 library SafeMath {
87 
88   /**
89   * @dev Multiplies two numbers, throws on overflow.
90   */
91   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
92     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
93     // benefit is lost if 'b' is also tested.
94     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
95     if (a == 0) {
96       return 0;
97     }
98 
99     c = a * b;
100     assert(c / a == b);
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers, truncating the quotient.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     // uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return a / b;
112   }
113 
114   /**
115   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
116   */
117   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118     assert(b <= a);
119     return a - b;
120   }
121 
122   /**
123   * @dev Adds two numbers, throws on overflow.
124   */
125   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
126     c = a + b;
127     assert(c >= a);
128     return c;
129   }
130 }
131 
132 // File: contracts\token\ERC20\ERC20Basic.sol
133 
134 /**
135  * @title ERC20Basic
136  * @dev Simpler version of ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/179
138  */
139 contract ERC20Basic {
140   function totalSupply() public view returns (uint256);
141   function balanceOf(address who) public view returns (uint256);
142   function transfer(address to, uint256 value) public returns (bool);
143   event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 // File: contracts\token\ERC20\BasicToken.sol
147 
148 /**
149  * @title Basic token
150  * @dev Basic version of StandardToken, with no allowances.
151  */
152 contract BasicToken is ERC20Basic {
153   using SafeMath for uint256;
154 
155   mapping(address => uint256) balances;
156 
157   uint256 totalSupply_;
158 
159   /**
160   * @dev total number of tokens in existence
161   */
162   function totalSupply() public view returns (uint256) {
163     return totalSupply_;
164   }
165 
166   /**
167   * @dev transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
170   */
171   function transfer(address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[msg.sender]);
174 
175     // SafeMath.sub will throw if there is not enough balance.
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     emit Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public view returns (uint256 balance) {
188     return balances[_owner];
189   }
190 
191 }
192 
193 // File: contracts\token\ERC20\ERC20.sol
194 
195 /**
196  * @title ERC20 interface
197  * @dev see https://github.com/ethereum/EIPs/issues/20
198  */
199 contract ERC20 is ERC20Basic {
200   function allowance(address owner, address spender) public view returns (uint256);
201   function transferFrom(address from, address to, uint256 value) public returns (bool);
202   function approve(address spender, uint256 value) public returns (bool);
203   event Approval(address indexed owner, address indexed spender, uint256 value);
204 }
205 
206 // File: contracts\token\ERC20\StandardToken.sol
207 
208 /**
209  * @title Standard ERC20 token
210  *
211  * @dev Implementation of the basic standard token.
212  * @dev https://github.com/ethereum/EIPs/issues/20
213  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
214  */
215 contract StandardToken is ERC20, BasicToken {
216 
217   mapping (address => mapping (address => uint256)) internal allowed;
218 
219 
220   /**
221    * @dev Transfer tokens from one address to another
222    * @param _from address The address which you want to send tokens from
223    * @param _to address The address which you want to transfer to
224    * @param _value uint256 the amount of tokens to be transferred
225    */
226   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
227     require(_to != address(0));
228     require(_value <= balances[_from]);
229     require(_value <= allowed[_from][msg.sender]);
230 
231     balances[_from] = balances[_from].sub(_value);
232     balances[_to] = balances[_to].add(_value);
233     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
234     emit Transfer(_from, _to, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240    *
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(address _owner, address _spender) public view returns (uint256) {
261     return allowed[_owner][_spender];
262   }
263 
264   /**
265    * @dev Increase the amount of tokens that an owner allowed to a spender.
266    *
267    * approve should be called when allowed[_spender] == 0. To increment
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param _spender The address which will spend the funds.
272    * @param _addedValue The amount of tokens to increase the allowance by.
273    */
274   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
275     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
291     uint oldValue = allowed[msg.sender][_spender];
292     if (_subtractedValue > oldValue) {
293       allowed[msg.sender][_spender] = 0;
294     } else {
295       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
296     }
297     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301 }
302 
303 
304 /**
305  * @title iCrowdCoin
306  */
307 
308 contract iCrowdCoin is StandardToken, Ownable, Haltable {
309 
310   //define iCrowdCoin
311   string public constant name = "iCrowdCoin";
312   string public constant symbol = "ICC";
313   uint8 public constant decimals = 18;
314 
315    /** List of agents that are allowed to distribute tokens */
316   mapping (address => bool) public distributors;
317 
318   event Distribute(address indexed to, uint256 amount);
319   event DistributeOpened();
320   event DistributeFinished();
321   event DistributorChanged(address addr, bool state);
322   event BurnToken(address addr,uint256 amount);
323   //owner can request a refund for an incorrectly sent ERC20.
324   event WithdrowErc20Token (address indexed erc20, address indexed wallet, uint value);
325 
326   bool public distributionFinished = false;
327 
328   modifier canDistribute() {
329     require(!distributionFinished);
330     _;
331   }
332   /**
333     * Only crowdsale contracts are allowed to distribute tokens
334     */
335   modifier onlyDistributor() {
336     require(distributors[msg.sender]);
337     _;
338   }
339 
340 
341   constructor (uint256 _amount) public {
342     totalSupply_ = totalSupply_.add(_amount);
343     balances[address(this)] = _amount;
344   }
345 
346   /**
347    * Owner can allow a crowdsale contract to distribute tokens.
348    */
349   function setDistributor(address addr, bool state) public onlyOwner canDistribute {
350     distributors[addr] = state;
351     emit DistributorChanged(addr, state);
352   }
353 
354 
355   /**
356    * @dev Function to distribute tokens
357    * @param _to The address that will receive the distributed tokens.
358    * @param _amount The amount of tokens to distribute.
359    */
360   function distribute(address _to, uint256 _amount) public onlyDistributor canDistribute {
361     require(balances[address(this)] >= _amount);
362 
363     balances[address(this)] = balances[address(this)].sub(_amount);
364     balances[_to] = balances[_to].add(_amount);
365     
366     emit Distribute(_to, _amount);
367     emit Transfer(address(0), _to, _amount);
368   }
369 
370 /**
371    * @dev Burns a specific amount of tokens, only can holder's own token
372    * @param _value The amount of token to be burned.
373    */
374   function burn(uint256 _value) public {
375     _burn(msg.sender, _value);
376   }
377 
378   /**
379    * @dev Function to burn down tokens
380    * @param _addr The address that will burn the tokens.
381    * @param  _amount The amount of tokens to burn.
382    */
383   function _burn(address _addr,uint256 _amount) internal  {
384     require(balances[_addr] >= _amount);
385 
386     balances[_addr] = balances[_addr].sub(_amount);
387     totalSupply_ = totalSupply_.sub(_amount);
388 
389     emit BurnToken(_addr,_amount);
390     emit Transfer(_addr, address(0), _amount);
391   }
392 
393   /**
394    * @dev Function to resume Distributing new tokens.
395    */
396   function openDistribution() public onlyOwner {
397     distributionFinished = false;
398     emit DistributeOpened();
399   }
400 
401  /**
402    * @dev Function to stop Distributing new tokens.
403    */
404   function distributionFinishing() public onlyOwner {
405     distributionFinished = true;
406     emit DistributeFinished();
407   }
408 
409   function withdrowErc20(address _tokenAddr, address _to, uint _value) public onlyOwner {
410     ERC20 erc20 = ERC20(_tokenAddr);
411     erc20.transfer(_to, _value);
412     emit WithdrowErc20Token(_tokenAddr, _to, _value);
413   }
414 
415   //overide ERC20 for Haltable
416   function transfer(address _to, uint256 _value) public stopInEmergency returns (bool) {
417     return super.transfer(_to, _value);
418   }
419 
420   function transferFrom(address _from, address _to, uint256 _value) public stopInEmergency returns (bool) {
421     return super.transferFrom(_from, _to, _value);
422   }
423 
424   function approve(address _spender, uint256 _value) public stopInEmergency returns (bool) {
425     return super.approve(_spender, _value);
426   }
427 
428   function increaseApproval(address _spender, uint _addedValue) public stopInEmergency returns (bool success) {
429     return super.increaseApproval(_spender, _addedValue);
430   }
431 
432   function decreaseApproval(address _spender, uint _subtractedValue) public stopInEmergency returns (bool success) {
433     return super.decreaseApproval(_spender, _subtractedValue);
434   }
435 
436 }