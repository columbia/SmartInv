1 pragma solidity ^0.4.21;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
92 
93 /**
94  * @title Claimable
95  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
96  * This allows the new owner to accept the transfer.
97  */
98 contract Claimable is Ownable {
99   address public pendingOwner;
100 
101   /**
102    * @dev Modifier throws if called by any account other than the pendingOwner.
103    */
104   modifier onlyPendingOwner() {
105     require(msg.sender == pendingOwner);
106     _;
107   }
108 
109   /**
110    * @dev Allows the current owner to set the pendingOwner address.
111    * @param newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address newOwner) onlyOwner public {
114     pendingOwner = newOwner;
115   }
116 
117   /**
118    * @dev Allows the pendingOwner address to finalize the transfer.
119    */
120   function claimOwnership() onlyPendingOwner public {
121     emit OwnershipTransferred(owner, pendingOwner);
122     owner = pendingOwner;
123     pendingOwner = address(0);
124   }
125 }
126 
127 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
128 
129 /**
130  * @title SafeMath
131  * @dev Math operations with safety checks that throw on error
132  */
133 library SafeMath {
134 
135   /**
136   * @dev Multiplies two numbers, throws on overflow.
137   */
138   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
139     if (a == 0) {
140       return 0;
141     }
142     c = a * b;
143     assert(c / a == b);
144     return c;
145   }
146 
147   /**
148   * @dev Integer division of two numbers, truncating the quotient.
149   */
150   function div(uint256 a, uint256 b) internal pure returns (uint256) {
151     // assert(b > 0); // Solidity automatically throws when dividing by 0
152     // uint256 c = a / b;
153     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154     return a / b;
155   }
156 
157   /**
158   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
159   */
160   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161     assert(b <= a);
162     return a - b;
163   }
164 
165   /**
166   * @dev Adds two numbers, throws on overflow.
167   */
168   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
169     c = a + b;
170     assert(c >= a);
171     return c;
172   }
173 }
174 
175 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
176 
177 /**
178  * @title ERC20Basic
179  * @dev Simpler version of ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/179
181  */
182 contract ERC20Basic {
183   function totalSupply() public view returns (uint256);
184   function balanceOf(address who) public view returns (uint256);
185   function transfer(address to, uint256 value) public returns (bool);
186   event Transfer(address indexed from, address indexed to, uint256 value);
187 }
188 
189 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
190 
191 /**
192  * @title Basic token
193  * @dev Basic version of StandardToken, with no allowances.
194  */
195 contract BasicToken is ERC20Basic {
196   using SafeMath for uint256;
197 
198   mapping(address => uint256) balances;
199 
200   uint256 totalSupply_;
201 
202   /**
203   * @dev total number of tokens in existence
204   */
205   function totalSupply() public view returns (uint256) {
206     return totalSupply_;
207   }
208 
209   /**
210   * @dev transfer token for a specified address
211   * @param _to The address to transfer to.
212   * @param _value The amount to be transferred.
213   */
214   function transfer(address _to, uint256 _value) public returns (bool) {
215     require(_to != address(0));
216     require(_value <= balances[msg.sender]);
217 
218     balances[msg.sender] = balances[msg.sender].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     emit Transfer(msg.sender, _to, _value);
221     return true;
222   }
223 
224   /**
225   * @dev Gets the balance of the specified address.
226   * @param _owner The address to query the the balance of.
227   * @return An uint256 representing the amount owned by the passed address.
228   */
229   function balanceOf(address _owner) public view returns (uint256) {
230     return balances[_owner];
231   }
232 
233 }
234 
235 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
236 
237 /**
238  * @title ERC20 interface
239  * @dev see https://github.com/ethereum/EIPs/issues/20
240  */
241 contract ERC20 is ERC20Basic {
242   function allowance(address owner, address spender) public view returns (uint256);
243   function transferFrom(address from, address to, uint256 value) public returns (bool);
244   function approve(address spender, uint256 value) public returns (bool);
245   event Approval(address indexed owner, address indexed spender, uint256 value);
246 }
247 
248 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
249 
250 /**
251  * @title Standard ERC20 token
252  *
253  * @dev Implementation of the basic standard token.
254  * @dev https://github.com/ethereum/EIPs/issues/20
255  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
256  */
257 contract StandardToken is ERC20, BasicToken {
258 
259   mapping (address => mapping (address => uint256)) internal allowed;
260 
261 
262   /**
263    * @dev Transfer tokens from one address to another
264    * @param _from address The address which you want to send tokens from
265    * @param _to address The address which you want to transfer to
266    * @param _value uint256 the amount of tokens to be transferred
267    */
268   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
269     require(_to != address(0));
270     require(_value <= balances[_from]);
271     require(_value <= allowed[_from][msg.sender]);
272 
273     balances[_from] = balances[_from].sub(_value);
274     balances[_to] = balances[_to].add(_value);
275     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
276     emit Transfer(_from, _to, _value);
277     return true;
278   }
279 
280   /**
281    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
282    *
283    * Beware that changing an allowance with this method brings the risk that someone may use both the old
284    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
285    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
286    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287    * @param _spender The address which will spend the funds.
288    * @param _value The amount of tokens to be spent.
289    */
290   function approve(address _spender, uint256 _value) public returns (bool) {
291     allowed[msg.sender][_spender] = _value;
292     emit Approval(msg.sender, _spender, _value);
293     return true;
294   }
295 
296   /**
297    * @dev Function to check the amount of tokens that an owner allowed to a spender.
298    * @param _owner address The address which owns the funds.
299    * @param _spender address The address which will spend the funds.
300    * @return A uint256 specifying the amount of tokens still available for the spender.
301    */
302   function allowance(address _owner, address _spender) public view returns (uint256) {
303     return allowed[_owner][_spender];
304   }
305 
306   /**
307    * @dev Increase the amount of tokens that an owner allowed to a spender.
308    *
309    * approve should be called when allowed[_spender] == 0. To increment
310    * allowed value is better to use this function to avoid 2 calls (and wait until
311    * the first transaction is mined)
312    * From MonolithDAO Token.sol
313    * @param _spender The address which will spend the funds.
314    * @param _addedValue The amount of tokens to increase the allowance by.
315    */
316   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
317     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
318     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
319     return true;
320   }
321 
322   /**
323    * @dev Decrease the amount of tokens that an owner allowed to a spender.
324    *
325    * approve should be called when allowed[_spender] == 0. To decrement
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _subtractedValue The amount of tokens to decrease the allowance by.
331    */
332   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
333     uint oldValue = allowed[msg.sender][_spender];
334     if (_subtractedValue > oldValue) {
335       allowed[msg.sender][_spender] = 0;
336     } else {
337       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
338     }
339     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
340     return true;
341   }
342 
343 }
344 
345 // File: contracts/MainframeToken.sol
346 
347 contract RETA is StandardToken, Pausable, Claimable {
348   string public constant name = "RETA";
349   string public constant symbol = "RETA";
350   uint8  public constant decimals = 18;
351   address public distributor;
352 
353   modifier validDestination(address to) {
354     require(to != address(this));
355     _;
356   }
357 
358   modifier isTradeable() {
359     require(
360       !paused ||
361       msg.sender == owner ||
362       msg.sender == distributor
363     );
364     _;
365   }
366 
367   constructor() public {
368     totalSupply_ = 490904400 ether; // 10 billion, 18 decimals (ether = 10^18)
369     balances[msg.sender] = totalSupply_;
370     emit Transfer(address(0x0), msg.sender, totalSupply_);
371   }
372 
373   // ERC20 Methods
374 
375   function transfer(address to, uint256 value) public validDestination(to) isTradeable returns (bool) {
376     return super.transfer(to, value);
377   }
378 
379   function transferFrom(address from, address to, uint256 value) public validDestination(to) isTradeable returns (bool) {
380     return super.transferFrom(from, to, value);
381   }
382 
383   function approve(address spender, uint256 value) public isTradeable returns (bool) {
384     return super.approve(spender, value);
385   }
386 
387   function increaseApproval(address spender, uint addedValue) public isTradeable returns (bool) {
388     return super.increaseApproval(spender, addedValue);
389   }
390 
391   function decreaseApproval(address spender, uint subtractedValue) public isTradeable returns (bool) {
392     return super.decreaseApproval(spender, subtractedValue);
393   }
394 
395   // Setters
396 
397   function setDistributor(address newDistributor) external onlyOwner {
398     distributor = newDistributor;
399   }
400 
401   // Token Drain
402 
403   function emergencyERC20Drain(ERC20 token, uint256 amount) external onlyOwner {
404     // owner can drain tokens that are sent here by mistake
405     token.transfer(owner, amount);
406   }
407 }