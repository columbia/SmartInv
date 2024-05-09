1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     // uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return a / b;
27   }
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 contract ERC20Basic {
45   function totalSupply() public view returns (uint256);
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20 is ERC20Basic {
56   function allowance(address owner, address spender) public view returns (uint256);
57   function transferFrom(address from, address to, uint256 value) public returns (bool);
58   function approve(address spender, uint256 value) public returns (bool);
59   event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68   mapping(address => uint256) balances;
69   uint256 totalSupply_;
70   /**
71   * @dev total number of tokens in existence
72   */
73   function totalSupply() public view returns (uint256) {
74     return totalSupply_;
75   }
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84 
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     emit Transfer(msg.sender, _to, _value);
88     return true;
89   }
90   /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of.
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95   function balanceOf(address _owner) public view returns (uint256) {
96     return balances[_owner];
97   }
98 }
99 
100 contract StandardToken is ERC20, BasicToken {
101   mapping (address => mapping (address => uint256)) internal allowed;
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amount of tokens to be transferred
107    */
108   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[_from]);
111     require(_value <= allowed[_from][msg.sender]);
112 
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     emit Transfer(_from, _to, _value);
117     return true;
118   }
119 
120   /**
121    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    *
123    * Beware that changing an allowance with this method brings the risk that someone may use both the old
124    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
125    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
126    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint256 _value) public returns (bool) {
131     allowed[msg.sender][_spender] = _value;
132     emit Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   /**
137    * @dev Function to check the amount of tokens that an owner allowed to a spender.
138    * @param _owner address The address which owns the funds.
139    * @param _spender address The address which will spend the funds.
140    * @return A uint256 specifying the amount of tokens still available for the spender.
141    */
142   function allowance(address _owner, address _spender) public view returns (uint256) {
143     return allowed[_owner][_spender];
144   }
145 
146   /**
147    * @dev Increase the amount of tokens that an owner allowed to a spender.
148    *
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    * @param _spender The address which will spend the funds.
154    * @param _addedValue The amount of tokens to increase the allowance by.
155    */
156   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
157     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162   /**
163    * @dev Decrease the amount of tokens that an owner allowed to a spender.
164    *
165    * approve should be called when allowed[_spender] == 0. To decrement
166    * allowed value is better to use this function to avoid 2 calls (and wait until
167    * the first transaction is mined)
168    * From MonolithDAO Token.sol
169    * @param _spender The address which will spend the funds.
170    * @param _subtractedValue The amount of tokens to decrease the allowance by.
171    */
172   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
173     uint oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue > oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 }
183 
184 /**
185  * @title Ownable
186  * @dev The Ownable contract has an owner address, and provides basic authorization control
187  * functions, this simplifies the implementation of "user permissions".
188  */
189 contract Ownable {
190   address public owner;
191   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193   /**
194    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
195    * account.
196    */
197   function Ownable() public {
198     owner = msg.sender;
199   }
200 
201   /**
202    * @dev Throws if called by any account other than the owner.
203    */
204   modifier onlyOwner() {
205     require(msg.sender == owner);
206     _;
207   }
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address newOwner) public onlyOwner {
214     require(newOwner != address(0));
215     emit OwnershipTransferred(owner, newOwner);
216     owner = newOwner;
217   }
218 }
219 
220 contract Pausable is Ownable {
221   event Pause();
222   event Unpause();
223 
224   bool public paused = false;
225 
226 
227   /**
228    * @dev Modifier to make a function callable only when the contract is not paused.
229    */
230   modifier whenNotPaused() {
231     require(!paused);
232     _;
233   }
234 
235   /**
236    * @dev Modifier to make a function callable only when the contract is paused.
237    */
238   modifier whenPaused() {
239     require(paused);
240     _;
241   }
242 
243   /**
244    * @dev called by the owner to pause, triggers stopped state
245    */
246   function pause() onlyOwner whenNotPaused public {
247     paused = true;
248     emit Pause();
249   }
250 
251   /**
252    * @dev called by the owner to unpause, returns to normal state
253    */
254   function unpause() onlyOwner whenPaused public {
255     paused = false;
256     emit Unpause();
257   }
258 }
259 
260 /**
261  * @title Pausable token
262  * @dev StandardToken modified with pausable transfers.
263  **/
264 contract PausableToken is StandardToken, Pausable {
265 
266   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
267     return super.transfer(_to, _value);
268   }
269 
270   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
271     return super.transferFrom(_from, _to, _value);
272   }
273 
274   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
275     return super.approve(_spender, _value);
276   }
277 
278   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
279     return super.increaseApproval(_spender, _addedValue);
280   }
281 
282   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
283     return super.decreaseApproval(_spender, _subtractedValue);
284   }
285 }
286 
287 contract Burnable is Ownable {
288   event Burn();
289 
290   bool public burnt = false;
291 
292   /**
293    * @dev Modifier to make a function callable only when unsold tokens are burnt.
294    */
295   modifier whenBurnt() {
296     require(burnt);
297     _;
298   }
299 
300   modifier whenNotBurnt() {
301     require(!burnt);
302     _;
303   }
304 }
305 
306 contract BurnableToken is StandardToken, Burnable {
307 
308   function burn() public whenNotBurnt returns (bool) {
309     if (balances[address(this)] > 0) {
310       totalSupply_ = totalSupply_.sub(balances[address(this)]);
311       balances[address(this)] = 0;
312     }
313     burnt = true;
314     emit Burn();
315   }
316 }
317 
318 contract CrowdsaleToken is PausableToken, BurnableToken {
319   uint256 public cap = 75000000;
320   function CrowdsaleToken () public {
321     totalSupply_ = cap.mul(1 ether);
322     balances[address(this)] = cap.mul(1 ether);
323   }
324 
325   function sendSoldTokens (address _to, uint256 _value) public onlyOwner {
326     require(_value > 0);
327     _value = _value.mul(1 ether);
328     require(_value <=  balances[address(this)]);
329     balances[address(this)] = balances[address(this)].sub(_value);
330     balances[_to] = balances[_to].add(_value);
331     emit Transfer(address(this), _to, _value);
332   }
333 } 
334 
335 contract BTML is CrowdsaleToken {
336   string public constant name = "BTML";
337   string public constant symbol = "BTML";
338   uint32 public constant decimals = 18;
339 
340   function BTML () public {
341     pause();
342   }
343 
344   function () public payable {
345     owner.transfer(msg.value);
346   }
347 }