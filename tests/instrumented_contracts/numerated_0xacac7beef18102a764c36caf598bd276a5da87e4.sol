1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'BONA' token contract
5 //
6 // Symbol      : BONA
7 // Name        : BONA Token
8 // Total supply: 1400000000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 // ----------------------------------------------------------------------------
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     if (a == 0) {
25       return 0;
26     }
27     c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers, truncating the quotient.
34   */
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     // uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return a / b;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
54     c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 /**
61  * @title ERC20Basic
62  * @dev Simpler version of ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/179
64  */
65 contract ERC20Basic {
66   function totalSupply() public view returns (uint256);
67   function balanceOf(address who) public view returns (uint256);
68   function transfer(address to, uint256 value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) public view returns (uint256);
122   function transferFrom(address from, address to, uint256 value) public returns (bool);
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     emit Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     emit Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 /**
223  * @title Ownable
224  * @dev The Ownable contract has an owner address, and provides basic authorization control
225  * functions, this simplifies the implementation of "user permissions".
226  */
227 contract Ownable {
228   address public owner;
229 
230 
231   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232 
233 
234   /**
235    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
236    * account.
237    */
238   function Ownable() public {
239     owner = msg.sender;
240   }
241 
242   /**
243    * @dev Throws if called by any account other than the owner.
244    */
245   modifier onlyOwner() {
246     require(msg.sender == owner);
247     _;
248   }
249 
250   /**
251    * @dev Allows the current owner to transfer control of the contract to a newOwner.
252    * @param newOwner The address to transfer ownership to.
253    */
254   function transferOwnership(address newOwner) public onlyOwner {
255     require(newOwner != address(0));
256     emit OwnershipTransferred(owner, newOwner);
257     owner = newOwner;
258   }
259 
260 }
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
294     emit Pause();
295   }
296 
297   /**
298    * @dev called by the owner to unpause, returns to normal state
299    */
300   function unpause() onlyOwner whenPaused public {
301     paused = false;
302     emit Unpause();
303   }
304 }
305 
306 /**
307  * @title Pausable token
308  * @dev StandardToken modified with pausable transfers.
309  **/
310 contract PausableToken is StandardToken, Pausable {
311 
312   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
313     return super.transfer(_to, _value);
314   }
315 
316   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
317     return super.transferFrom(_from, _to, _value);
318   }
319 
320   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
321     return super.approve(_spender, _value);
322   }
323 
324   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
325     return super.increaseApproval(_spender, _addedValue);
326   }
327 
328   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
329     return super.decreaseApproval(_spender, _subtractedValue);
330   }
331 }
332 
333 contract BONATOKEN is PausableToken
334 {
335     string public constant name = "BONA TOKEN";
336     string public constant symbol = "BONA";
337     uint8 public constant decimals = 18;
338     
339     // 1.4 Billion Total Supply
340     uint256 public constant INITIAL_SUPPLY = 14e8 * 10**uint256(decimals);
341     
342     constructor()  public {
343         totalSupply_ = INITIAL_SUPPLY;
344         transferOwnership(owner);
345         balances[owner] = INITIAL_SUPPLY;
346         emit Transfer(0x0, owner, INITIAL_SUPPLY);
347     }
348 }