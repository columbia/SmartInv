1 pragma solidity ^0.4.23;
2 
3 
4   /**
5   * @title SafeMath
6   * @dev Math operations with safety checks that throw on error
7   */
8   library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14       if (a == 0) {
15         return 0;
16       }
17       c = a * b;
18       assert(c / a == b);
19       return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26       // assert(b > 0); // Solidity automatically throws when dividing by 0
27       // uint256 c = a / b;
28       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29       return a / b;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36       assert(b <= a);
37       return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44       c = a + b;
45       assert(c >= a);
46       return c;
47     }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   uint256 public totalSupply;
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     uint previousBalances = balances[msg.sender] + balances[_to];
92     // SafeMath.sub will throw if there is not enough balance.
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     assert(balances[msg.sender] + balances[_to] == previousBalances); 
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
117  */
118 contract StandardToken is ERC20, BasicToken {
119 
120   mapping (address => mapping (address => uint256)) internal allowed;
121 
122 
123   /**
124    * @dev Transfer tokens from one address to another
125    * @param _from address The address which you want to send tokens from
126    * @param _to address The address which you want to transfer to
127    * @param _value uint256 the amount of tokens to be transferred
128    */
129   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[_from]);
132     require(_value <= allowed[_from][msg.sender]);
133 
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137     emit Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    *
144    * Beware that changing an allowance with this method brings the risk that someone may use both the old
145    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148    * @param _spender The address which will spend the funds.
149    * @param _value The amount of tokens to be spent.
150    */
151   function approve(address _spender, uint256 _value) public returns (bool) {
152     allowed[msg.sender][_spender] = _value;
153     emit Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Function to check the amount of tokens that an owner allowed to a spender.
159    * @param _owner address The address which owns the funds.
160    * @param _spender address The address which will spend the funds.
161    * @return A uint256 specifying the amount of tokens still available for the spender.
162    */
163   function allowance(address _owner, address _spender) public view returns (uint256) {
164     return allowed[_owner][_spender];
165   }
166 
167   /**
168    * approve should be called when allowed[_spender] == 0. To increment
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    */
172   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
173     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
174     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
179     uint oldValue = allowed[msg.sender][_spender];
180     if (_subtractedValue > oldValue) {
181       allowed[msg.sender][_spender] = 0;
182     } else {
183       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
184     }
185     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189 }
190 
191 /**
192  * @title Ownable
193  * @dev The Ownable contract has an owner address, and provides basic authorization control
194  * functions, this simplifies the implementation of "user permissions".
195  */
196 contract Ownable {
197   address public owner;
198 
199 
200   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202 
203   /**
204    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
205    * account.
206    */
207   constructor() public{
208     owner = msg.sender;
209   }
210 
211 
212   /**
213    * @dev Throws if called by any account other than the owner.
214    */
215   modifier onlyOwner() {
216     require(msg.sender == owner);
217     _;
218   }
219 
220 
221   /**
222    * @dev Allows the current owner to transfer control of the contract to a newOwner.
223    * @param newOwner The address to transfer ownership to.
224    */
225   function transferOwnership(address newOwner) onlyOwner public {
226     require(newOwner != address(0));
227     emit OwnershipTransferred(owner, newOwner);
228     owner = newOwner;
229   }
230 
231 }
232 
233 /**
234  * @title Pausable
235  * @dev Base contract which allows children to implement an emergency stop mechanism.
236  */
237 contract Pausable is Ownable {
238   event Pause();
239   event Unpause();
240 
241   bool public paused = false;
242 
243 
244   /**
245    * @dev Modifier to make a function callable only when the contract is not paused.
246    */
247   modifier whenNotPaused() {
248     require(!paused);
249     _;
250   }
251 
252   /**
253    * @dev Modifier to make a function callable only when the contract is paused.
254    */
255   modifier whenPaused() {
256     require(paused);
257     _;
258   }
259 
260   /**
261    * @dev called by the owner to pause, triggers stopped state
262    */
263   function pause() onlyOwner whenNotPaused public {
264     paused = true;
265     emit Pause();
266   }
267 
268   /**
269    * @dev called by the owner to unpause, returns to normal state
270    */
271   function unpause() onlyOwner whenPaused public {
272     paused = false;
273     emit Unpause();
274   }
275 }
276 /**
277  * @title Pausable token
278  *
279  * @dev StandardToken modified with pausable transfers.
280  **/
281 
282 contract PausableToken is StandardToken, Pausable {
283 
284   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
285     return super.transfer(_to, _value);
286   }
287 
288   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
289     return super.transferFrom(_from, _to, _value);
290   }
291 
292   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
293     return super.approve(_spender, _value);
294   }
295 }
296 
297 /**
298  * @title TCT Token
299  *
300  * @dev Implementation of TCT Token based on the basic standard token.
301  */
302 contract ARKToken is PausableToken {
303 
304     function () public {
305       //if ether is sent to this address, send it back.
306         revert();
307     }
308 
309     /**
310     * Public variables of the token
311     * The following variables are OPTIONAL vanities. One does not have to include them.
312     * They allow one to customise the token contract & in no way influences the core functionality.
313     * Some wallets/interfaces might not even bother to look at this information.
314     */
315     string public name="Noah ARK Token";
316     uint8 public decimals=18;
317     string public symbol="ARK";
318     string public version = '1.0.0';
319     uint256 public  totalSupply = 2000000000 * 10 ** uint256(decimals);
320 
321     /**
322      * @dev Function to check the amount of tokens that an owner allowed to a spender.
323      */
324     constructor() public {
325         balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
326     }
327 }