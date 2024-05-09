1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a / b;
25     return c;
26   }
27 
28   /**
29   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  */
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 /**
56  * @title ERC20 interface
57  */
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender) public view returns (uint256);
60   function transferFrom(address from, address to, uint256 value) public returns (bool);
61   function approve(address spender, uint256 value) public returns (bool);
62   event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 contract Ownable {
65   address public owner;
66   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   constructor() public {
72     owner = msg.sender;
73   }
74 
75   /**
76    * @dev Throws if called by any account other than the owner.
77    */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) public onlyOwner {
88     require(newOwner != address(0));
89     emit OwnershipTransferred(owner, newOwner);
90     owner = newOwner;
91   }
92 
93 }
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic,ERC20 {
99   using SafeMath for uint256;
100   mapping(address => uint256) balances;
101   //lock the amount of the specified address.
102   mapping(address => uint256) public lockValues;
103   //50000000*10**18 total
104   uint256 totalSupply_=50000000*10**18;
105   /**
106   * @dev total number of tokens in existence
107   */
108   function totalSupply() public view returns (uint256) {
109     return totalSupply_;
110   }
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     address addr = msg.sender;
119     require(_value <= balances[addr]);
120     uint256 transBlalance = balances[msg.sender].sub(lockValues[msg.sender]);
121     require(_value <= transBlalance);
122     // SafeMath.sub will throw if there is not enough balance.
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     emit Transfer(msg.sender, _to, _value);
126     return true;
127   }
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137 }
138 /**
139  * @title Standard ERC20 token
140  * @dev Implementation of the basic standard token.
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) internal allowed;
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[_from]);
154     require(_value <= allowed[_from][msg.sender]);
155     uint256 transBlalance = balances[_from].sub(lockValues[_from]);
156     require(_value <= transBlalance);
157     transBlalance = allowed[_from][msg.sender].sub(lockValues[msg.sender]);
158     require(_value <= transBlalance);
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     emit Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    *
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(address _owner, address _spender) public view returns (uint256) {
187     return allowed[_owner][_spender];
188   }
189   /**
190    * @dev Increase the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To increment
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _addedValue The amount of tokens to increase the allowance by.
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   /**
206    * @dev Decrease the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To decrement
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _subtractedValue The amount of tokens to decrease the allowance by.
214    */
215   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
216     uint oldValue = allowed[msg.sender][_spender];
217     if (_subtractedValue > oldValue) {
218       allowed[msg.sender][_spender] = 0;
219     } else {
220       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221     }
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 }
226 
227 /**
228  * @title Pausable
229  * @dev Base contract which allows children to implement an emergency stop mechanism.
230  */
231 contract Pausable is Ownable {
232   event Pause();
233   event Unpause();
234   bool public paused = false;
235   /**
236    * @dev Modifier to make a function callable only when the contract is not paused.
237    */
238   modifier whenNotPaused() {
239     require(!paused);
240     _;
241   }
242 
243   /**
244    * @dev Modifier to make a function callable only when the contract is paused.
245    */
246   modifier whenPaused() {
247     require(paused);
248     _;
249   }
250   /**
251    * @dev called by the owner to pause, triggers stopped state
252    */
253   function pause() onlyOwner whenNotPaused public {
254     paused = true;
255     emit Pause();
256   }
257   /**
258    * @dev called by the owner to unpause, returns to normal state
259    */
260   function unpause() onlyOwner whenPaused public {
261     paused = false;
262     emit Unpause();
263   }
264 }
265 /**
266  * @title Pausable token
267  * @dev StandardToken modified with pausable transfers.
268  **/
269 contract PausableToken is StandardToken, Pausable {
270 
271   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
272     return super.transfer(_to, _value);
273   }
274 
275   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
276     return super.transferFrom(_from, _to, _value);
277   }
278   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
279     return super.approve(_spender, _value);
280   }
281   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
282     return super.increaseApproval(_spender, _addedValue);
283   }
284   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
285     return super.decreaseApproval(_spender, _subtractedValue);
286   }
287 }
288 
289 /**
290  * @dev ANY token ERC20 contract
291  */
292 contract ANYTOKEN is  PausableToken {
293     string public constant version = "1.0";
294     string public  name = "Anonymity";
295     string public  symbol = "ANY";
296     uint8 public constant decimals = 18;
297     constructor() public {
298         balances[msg.sender] = totalSupply_; 
299     }
300      
301    function addLockValue(address addr,uint256 _value) public onlyOwner{    
302       uint256 _reqlockValues= lockValues[addr].add(_value);
303       require(_reqlockValues <= balances[addr]);    
304       require(addr != address(0));
305       lockValues[addr] = lockValues[addr].add(_value);        
306     }    
307     function subLockValue(address addr,uint256 _value) public onlyOwner{       
308        require(addr != address(0));
309        require(_value <= lockValues[addr]);
310        lockValues[addr] = lockValues[addr].sub(_value);        
311     }
312 }