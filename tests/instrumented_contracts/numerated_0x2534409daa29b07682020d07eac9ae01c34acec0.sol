1 pragma solidity ^0.4.24;
2 
3 /**
4 
5 * Project Name : Miracle Token
6 * Platform: www.miracle.channel -> soon to be launched
7 * Ticker: MRCL
8 * Visit: www.miracletoken.org
9 
10 
11 */
12 
13 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   function Ownable() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     emit OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
56 
57 /**
58  * @title Pausable
59  * @dev Base contract which allows children to implement an emergency stop mechanism.
60  */
61 contract Pausable is Ownable {
62   event Pause();
63   event Unpause();
64 
65   bool public paused = false;
66 
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is not paused.
70    */
71   modifier whenNotPaused() {
72     require(!paused);
73     _;
74   }
75 
76   /**
77    * @dev Modifier to make a function callable only when the contract is paused.
78    */
79   modifier whenPaused() {
80     require(paused);
81     _;
82   }
83 
84   /**
85    * @dev called by the owner to pause, triggers stopped state
86    */
87   function pause() onlyOwner whenNotPaused public {
88     paused = true;
89     emit Pause();
90   }
91 
92   /**
93    * @dev called by the owner to unpause, returns to normal state
94    */
95   function unpause() onlyOwner whenPaused public {
96     paused = false;
97     emit Unpause();
98   }
99 }
100 
101 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
102 
103 /**
104  * @title Claimable
105  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
106  * This allows the new owner to accept the transfer.
107  */
108 contract Claimable is Ownable {
109   address public pendingOwner;
110 
111   /**
112    * @dev Modifier throws if called by any account other than the pendingOwner.
113    */
114   modifier onlyPendingOwner() {
115     require(msg.sender == pendingOwner);
116     _;
117   }
118 
119   /**
120    * @dev Allows the current owner to set the pendingOwner address.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) onlyOwner public {
124     pendingOwner = newOwner;
125   }
126 
127   /**
128    * @dev Allows the pendingOwner address to finalize the transfer.
129    */
130   function claimOwnership() onlyPendingOwner public {
131     emit OwnershipTransferred(owner, pendingOwner);
132     owner = pendingOwner;
133     pendingOwner = address(0);
134   }
135 }
136 
137 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
138 
139 /**
140  * @title SafeMath
141  * @dev Math operations with safety checks that throw on error
142  */
143 library SafeMath {
144 
145   /**
146   * @dev Multiplies two numbers, throws on overflow.
147   */
148   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
149     if (a == 0) {
150       return 0;
151     }
152     c = a * b;
153     assert(c / a == b);
154     return c;
155   }
156 
157   /**
158   * @dev Integer division of two numbers, truncating the quotient.
159   */
160   function div(uint256 a, uint256 b) internal pure returns (uint256) {
161     // assert(b > 0); // Solidity automatically throws when dividing by 0
162     // uint256 c = a / b;
163     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164     return a / b;
165   }
166 
167   /**
168   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
169   */
170   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171     assert(b <= a);
172     return a - b;
173   }
174 
175   /**
176   * @dev Adds two numbers, throws on overflow.
177   */
178   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
179     c = a + b;
180     assert(c >= a);
181     return c;
182   }
183 }
184 
185 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
186 
187 /**
188  * @title ERC20Basic
189  * @dev Simpler version of ERC20 interface
190  * @dev see https://github.com/ethereum/EIPs/issues/179
191  */
192 contract ERC20Basic {
193   function totalSupply() public view returns (uint256);
194   function balanceOf(address who) public view returns (uint256);
195   function transfer(address to, uint256 value) public returns (bool);
196   event Transfer(address indexed from, address indexed to, uint256 value);
197 }
198 
199 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
200 
201 /**
202  * @title Basic token
203  * @dev Basic version of StandardToken, with no allowances.
204  */
205 contract BasicToken is ERC20Basic {
206   using SafeMath for uint256;
207 
208   mapping(address => uint256) balances;
209 
210   uint256 totalSupply_;
211 
212   /**
213   * @dev total number of tokens in existence
214   */
215   function totalSupply() public view returns (uint256) {
216     return totalSupply_;
217   }
218 
219   /**
220   * @dev transfer token for a specified address
221   * @param _to The address to transfer to.
222   * @param _value The amount to be transferred.
223   */
224   function transfer(address _to, uint256 _value) public returns (bool) {
225     require(_to != address(0));
226     require(_value <= balances[msg.sender]);
227 
228     balances[msg.sender] = balances[msg.sender].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     emit Transfer(msg.sender, _to, _value);
231     return true;
232   }
233 
234   /**
235   * @dev Gets the balance of the specified address.
236   * @param _owner The address to query the the balance of.
237   * @return An uint256 representing the amount owned by the passed address.
238   */
239   function balanceOf(address _owner) public view returns (uint256) {
240     return balances[_owner];
241   }
242 
243 }
244 
245 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
246 
247 /**
248  * @title ERC20 interface
249  * @dev see https://github.com/ethereum/EIPs/issues/20
250  */
251 contract ERC20 is ERC20Basic {
252   function allowance(address owner, address spender) public view returns (uint256);
253   function transferFrom(address from, address to, uint256 value) public returns (bool);
254   function approve(address spender, uint256 value) public returns (bool);
255   event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
259 
260 /**
261  * @title Standard ERC20 token
262  *
263  * @dev Implementation of the basic standard token.
264  * @dev https://github.com/ethereum/EIPs/issues/20
265  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
266  */
267 contract StandardToken is ERC20, BasicToken {
268 
269   mapping (address => mapping (address => uint256)) internal allowed;
270 
271 
272   /**
273    * @dev Transfer tokens from one address to another
274    * @param _from address The address which you want to send tokens from
275    * @param _to address The address which you want to transfer to
276    * @param _value uint256 the amount of tokens to be transferred
277    */
278   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
279     require(_to != address(0));
280     require(_value <= balances[_from]);
281     require(_value <= allowed[_from][msg.sender]);
282 
283     balances[_from] = balances[_from].sub(_value);
284     balances[_to] = balances[_to].add(_value);
285     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
286     emit Transfer(_from, _to, _value);
287     return true;
288   }
289 
290   /**
291    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
292    *
293    * Beware that changing an allowance with this method brings the risk that someone may use both the old
294    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
295    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
296    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297    * @param _spender The address which will spend the funds.
298    * @param _value The amount of tokens to be spent.
299    */
300   function approve(address _spender, uint256 _value) public returns (bool) {
301     allowed[msg.sender][_spender] = _value;
302     emit Approval(msg.sender, _spender, _value);
303     return true;
304   }
305 
306   /**
307    * @dev Function to check the amount of tokens that an owner allowed to a spender.
308    * @param _owner address The address which owns the funds.
309    * @param _spender address The address which will spend the funds.
310    * @return A uint256 specifying the amount of tokens still available for the spender.
311    */
312   function allowance(address _owner, address _spender) public view returns (uint256) {
313     return allowed[_owner][_spender];
314   }
315 
316   /**
317    * @dev Increase the amount of tokens that an owner allowed to a spender.
318    *
319    * approve should be called when allowed[_spender] == 0. To increment
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param _spender The address which will spend the funds.
324    * @param _addedValue The amount of tokens to increase the allowance by.
325    */
326   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
327     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332   /**
333    * @dev Decrease the amount of tokens that an owner allowed to a spender.
334    *
335    * approve should be called when allowed[_spender] == 0. To decrement
336    * allowed value is better to use this function to avoid 2 calls (and wait until
337    * the first transaction is mined)
338    * From MonolithDAO Token.sol
339    * @param _spender The address which will spend the funds.
340    * @param _subtractedValue The amount of tokens to decrease the allowance by.
341    */
342   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
343     uint oldValue = allowed[msg.sender][_spender];
344     if (_subtractedValue > oldValue) {
345       allowed[msg.sender][_spender] = 0;
346     } else {
347       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
348     }
349     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353 }
354 
355 // File: contracts/MRCL.sol
356 
357 contract MRCL is StandardToken, Pausable, Claimable {
358   string public constant name = "Miracle Token";
359   string public constant symbol = "MRCL";
360   uint8  public constant decimals = 18;
361   address public distributor;
362 
363   modifier validDestination(address to) {
364     require(to != address(this));
365     _;
366   }
367 
368   modifier isTradeable() {
369     require(
370       !paused ||
371       msg.sender == owner ||
372       msg.sender == distributor
373     );
374     _;
375   }
376 
377   constructor() public {
378     totalSupply_ = 9660000000 ether; // 966 million, 18 decimals (ether = 1^9)
379     balances[msg.sender] = totalSupply_;
380     emit Transfer(address(0x0), msg.sender, totalSupply_);
381   }
382 
383   // ERC20 Methods
384 
385   function transfer(address to, uint256 value) public validDestination(to) isTradeable returns (bool) {
386     return super.transfer(to, value);
387   }
388 
389   function transferFrom(address from, address to, uint256 value) public validDestination(to) isTradeable returns (bool) {
390     return super.transferFrom(from, to, value);
391   }
392 
393   function approve(address spender, uint256 value) public isTradeable returns (bool) {
394     return super.approve(spender, value);
395   }
396 
397   function increaseApproval(address spender, uint addedValue) public isTradeable returns (bool) {
398     return super.increaseApproval(spender, addedValue);
399   }
400 
401   function decreaseApproval(address spender, uint subtractedValue) public isTradeable returns (bool) {
402     return super.decreaseApproval(spender, subtractedValue);
403   }
404 
405   // Setters
406 
407   function setDistributor(address newDistributor) external onlyOwner {
408     distributor = newDistributor;
409   }
410 
411   // Token Drain
412 
413   function emergencyERC20Drain(ERC20 token, uint256 amount) external onlyOwner {
414     // owner can drain tokens that are sent here by mistake
415     token.transfer(owner, amount);
416   }
417 }