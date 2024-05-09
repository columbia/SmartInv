1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public view returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances.
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) balances;
86 
87   uint256 totalSupply_;
88 
89   /**
90   * @dev total number of tokens in existence
91   */
92   function totalSupply() public view returns (uint256) {
93     return totalSupply_;
94   }
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[msg.sender]);
104 
105     // SafeMath.sub will throw if there is not enough balance.
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256 balance) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147 
148     balances[_from] = balances[_from].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151     Transfer(_from, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(address _owner, address _spender) public view returns (uint256) {
178     return allowed[_owner][_spender];
179   }
180 
181   /**
182    * @dev Increase the amount of tokens that an owner allowed to a spender.
183    *
184    * approve should be called when allowed[_spender] == 0. To increment
185    * allowed value is better to use this function to avoid 2 calls (and wait until
186    * the first transaction is mined)
187    * From MonolithDAO Token.sol
188    * @param _spender The address which will spend the funds.
189    * @param _addedValue The amount of tokens to increase the allowance by.
190    */
191   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
192     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
193     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197   /**
198    * @dev Decrease the amount of tokens that an owner allowed to a spender.
199    *
200    * approve should be called when allowed[_spender] == 0. To decrement
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _subtractedValue The amount of tokens to decrease the allowance by.
206    */
207   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
208     uint oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue > oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218 }
219 
220 
221 /**
222  * @title Ownable
223  * @dev The Ownable contract has an owner address, and provides basic authorization control
224  * functions, this simplifies the implementation of "user permissions".
225  */
226 contract Ownable {
227   address public owner;
228 
229 
230   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232 
233   /**
234    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
235    * account.
236    */
237   function Ownable() public {
238     owner = msg.sender;
239   }
240 
241   /**
242    * @dev Throws if called by any account other than the owner.
243    */
244   modifier onlyOwner() {
245     require(msg.sender == owner);
246     _;
247   }
248 
249   /**
250    * @dev Allows the current owner to transfer control of the contract to a newOwner.
251    * @param newOwner The address to transfer ownership to.
252    */
253   function transferOwnership(address newOwner) public onlyOwner {
254     require(newOwner != address(0));
255     OwnershipTransferred(owner, newOwner);
256     owner = newOwner;
257   }
258 
259 }
260 
261 
262 /**
263  * @title Pausable
264  * @dev Base contract which allows children to implement an emergency stop mechanism.
265  */
266 contract Pausable is Ownable {
267   event Pause();
268   event Unpause();
269 
270   bool public paused = false;
271 
272 
273   /**
274    * @dev Modifier to make a function callable only when the contract is not paused.
275    */
276   modifier whenNotPaused() {
277     require(!paused);
278     _;
279   }
280 
281   /**
282    * @dev Modifier to make a function callable only when the contract is paused.
283    */
284   modifier whenPaused() {
285     require(paused);
286     _;
287   }
288 
289   /**
290    * @dev called by the owner to pause, triggers stopped state
291    */
292   function pause() onlyOwner whenNotPaused public {
293     paused = true;
294     Pause();
295   }
296 
297   /**
298    * @dev called by the owner to unpause, returns to normal state
299    */
300   function unpause() onlyOwner whenPaused public {
301     paused = false;
302     Unpause();
303   }
304 }
305 
306 
307 /**
308  * @title Pausable token
309  * @dev StandardToken modified with pausable transfers.
310  **/
311 contract PausableToken is StandardToken, Pausable {
312 
313   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
314     return super.transfer(_to, _value);
315   }
316 
317   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
318     return super.transferFrom(_from, _to, _value);
319   }
320 
321   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
322     return super.approve(_spender, _value);
323   }
324 
325   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
326     return super.increaseApproval(_spender, _addedValue);
327   }
328 
329   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
330     return super.decreaseApproval(_spender, _subtractedValue);
331   }
332 }
333 
334 
335 contract CPToken is PausableToken {
336     
337     string public name = 'Chain Partners';
338     string public symbol = 'CP';
339     uint8 public decimals = 4;
340     uint private INITIAL_SUPPLY = (10 ** 6) * (10 ** 4);
341 
342     function CPToken() public {
343         totalSupply_ = INITIAL_SUPPLY;
344         balances[msg.sender] = INITIAL_SUPPLY;
345     }
346 }