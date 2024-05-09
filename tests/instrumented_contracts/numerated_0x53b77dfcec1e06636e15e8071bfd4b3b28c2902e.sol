1 pragma solidity >=0.4.22 <0.6.0;
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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken {
130 
131   mapping (address => mapping (address => uint256)) internal allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amount of tokens to be transferred
139    */
140   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[_from]);
143     require(_value <= allowed[_from][msg.sender]);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148     emit Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     allowed[msg.sender][_spender] = _value;
164     emit Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Function to check the amount of tokens that an owner allowed to a spender.
170    * @param _owner address The address which owns the funds.
171    * @param _spender address The address which will spend the funds.
172    * @return A uint256 specifying the amount of tokens still available for the spender.
173    */
174   function allowance(address _owner, address _spender) public view returns (uint256) {
175     return allowed[_owner][_spender];
176   }
177 
178   /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    *
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _addedValue The amount of tokens to increase the allowance by.
187    */
188   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
189     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215 }
216 
217 /**
218  * @title Ownable
219  * @dev The Ownable contract has an owner address, and provides basic authorization control
220  * functions, this simplifies the implementation of "user permissions".
221  */
222 contract Ownable {
223   address public owner;
224 
225 
226   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227 
228 
229   /**
230    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
231    * account.
232    */
233   function Ownable() public {
234     owner = msg.sender;
235   }
236 
237   /**
238    * @dev Throws if called by any account other than the owner.
239    */
240   modifier onlyOwner() {
241     require(msg.sender == owner);
242     _;
243   }
244 
245   /**
246    * @dev Allows the current owner to transfer control of the contract to a newOwner.
247    * @param newOwner The address to transfer ownership to.
248    */
249   function transferOwnership(address newOwner) public onlyOwner {
250     require(newOwner != address(0));
251     emit OwnershipTransferred(owner, newOwner);
252     owner = newOwner;
253   }
254 
255 }
256 
257 /**
258  * @title Pausable
259  * @dev Base contract which allows children to implement an emergency stop mechanism.
260  */
261 contract Pausable is Ownable {
262   event Pause();
263   event Unpause();
264 
265   bool public paused = false;
266 
267 
268   /**
269    * @dev Modifier to make a function callable only when the contract is not paused.
270    */
271   modifier whenNotPaused() {
272     require(!paused);
273     _;
274   }
275 
276   /**
277    * @dev Modifier to make a function callable only when the contract is paused.
278    */
279   modifier whenPaused() {
280     require(paused);
281     _;
282   }
283 
284   /**
285    * @dev called by the owner to pause, triggers stopped state
286    */
287   function pause() onlyOwner whenNotPaused public {
288     paused = true;
289     emit Pause();
290   }
291 
292   /**
293    * @dev called by the owner to unpause, returns to normal state
294    */
295   function unpause() onlyOwner whenPaused public {
296     paused = false;
297     emit Unpause();
298   }
299 }
300 
301 /**
302  * @title Pausable token
303  * @dev StandardToken modified with pausable transfers.
304  **/
305 contract PausableToken is StandardToken, Pausable {
306 
307   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
308     return super.transfer(_to, _value);
309   }
310 
311   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
312     return super.transferFrom(_from, _to, _value);
313   }
314 
315   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
316     return super.approve(_spender, _value);
317   }
318 
319   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
320     return super.increaseApproval(_spender, _addedValue);
321   }
322 
323   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
324     return super.decreaseApproval(_spender, _subtractedValue);
325   }
326 }
327 
328 
329 /**
330  * @title K3Token
331  */
332 contract K3Token is PausableToken {
333 
334 	function () {
335       //if ether is sent to this address, send it back.
336         revert();
337     }
338 
339     
340     string public name = "K3 TOKEN";
341     uint8 public decimals = 8;
342     string public symbol = "K3";
343     string public version = '1.0.0';
344     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
345 
346     
347     function K3Token() public {
348         balances[msg.sender] = INITIAL_SUPPLY;    // Give the creator all initial tokens
349         totalSupply_ = INITIAL_SUPPLY;
350     }
351 }