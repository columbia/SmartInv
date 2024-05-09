1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
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
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() public {
63     owner = msg.sender;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 }
84 
85 /**
86  * @title Pausable
87  * @dev Base contract which allows children to implement an emergency stop mechanism.
88  */
89 contract Pausable is Ownable {
90   event Pause();
91   event Unpause();
92 
93   bool public paused = false;
94 
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is not paused.
98    */
99   modifier whenNotPaused() {
100     require(!paused);
101     _;
102   }
103 
104   /**
105    * @dev Modifier to make a function callable only when the contract is paused.
106    */
107   modifier whenPaused() {
108     require(paused);
109     _;
110   }
111 
112   /**
113    * @dev called by the owner to pause, triggers stopped state
114    */
115   function pause() onlyOwner whenNotPaused public {
116     paused = true;
117     Pause();
118   }
119 
120   /**
121    * @dev called by the owner to unpause, returns to normal state
122    */
123   function unpause() onlyOwner whenPaused public {
124     paused = false;
125     Unpause();
126   }
127 }
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 {
134   function totalSupply() public view returns (uint256);
135   function balanceOf(address who) public view returns (uint256);
136   function transfer(address to, uint256 value) public returns (bool);
137   function allowance(address owner, address spender) public view returns (uint256);
138   function transferFrom(address from, address to, uint256 value) public returns (bool);
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141   event Transfer(address indexed from, address indexed to, uint256 value);
142 }
143 
144 
145 /**
146  * @title SIGM ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract SigmaIOToken is ERC20, Pausable {
153 
154   using SafeMath for uint256;
155 
156   string public name;
157   string public symbol;
158   uint8 public decimals;
159   mapping(address => uint256) balances;
160   mapping (address => mapping (address => uint256)) internal allowed;
161 
162   uint256 totalSupply_;
163 
164   function SigmaIOToken() public {
165     totalSupply_ = 1000000000000000000;
166     name = "SigmaIO Token";
167     symbol = "SIGM";
168     decimals = 8;
169     balances[msg.sender] = totalSupply_;
170   }
171   /**
172   * @dev total number of tokens in existence
173   */
174   function totalSupply() public view returns (uint256) {
175     return totalSupply_;
176   }
177 
178   /**
179   * @dev transfer token for a specified address
180   * @param _to The address to transfer to.
181   * @param _value The amount to be transferred.
182   */
183   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
184     require(_to != address(0));
185     require(_value <= balances[msg.sender]);
186 
187     // SafeMath.sub will throw if there is not enough balance.
188     balances[msg.sender] = balances[msg.sender].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     Transfer(msg.sender, _to, _value);
191     return true;
192   }
193 
194   /**
195   * @dev Gets the balance of the specified address.
196   * @param _owner The address to query the the balance of.
197   * @return An uint256 representing the amount owned by the passed address.
198   */
199   function balanceOf(address _owner) public view returns (uint256 balance) {
200     return balances[_owner];
201   }
202 
203   /**
204    * @dev Transfer tokens from one address to another
205    * @param _from address The address which you want to send tokens from
206    * @param _to address The address which you want to transfer to
207    * @param _value uint256 the amount of tokens to be transferred
208    */
209   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
210     require(_to != address(0));
211     require(_value <= balances[_from]);
212     require(_value <= allowed[_from][msg.sender]);
213 
214     balances[_from] = balances[_from].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217     Transfer(_from, _to, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    *
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param _owner address The address which owns the funds.
240    * @param _spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(address _owner, address _spender) public view returns (uint256) {
244     return allowed[_owner][_spender];
245   }
246 
247   /**
248    * @dev Increase the amount of tokens that an owner allowed to a spender.
249    *
250    * approve should be called when allowed[_spender] == 0. To increment
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _addedValue The amount of tokens to increase the allowance by.
256    */
257   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
258     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Decrease the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To decrement
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _subtractedValue The amount of tokens to decrease the allowance by.
272    */
273   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
274     uint oldValue = allowed[msg.sender][_spender];
275     if (_subtractedValue > oldValue) {
276       allowed[msg.sender][_spender] = 0;
277     } else {
278       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
279     }
280     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 }