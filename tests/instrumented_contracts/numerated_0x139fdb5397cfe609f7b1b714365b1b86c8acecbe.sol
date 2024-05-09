1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) public constant returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public constant returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances. 
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     emit Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of. 
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) public constant returns (uint256 balance) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amout of tokens to be transfered
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     uint256 _allowance;
120     _allowance = allowed[_from][msg.sender];
121 
122     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
123     // require (_value <= _allowance);
124 
125     balances[_to] = balances[_to].add(_value);
126     balances[_from] = balances[_from].sub(_value);
127     allowed[_from][msg.sender] = _allowance.sub(_value);
128     emit Transfer(_from, _to, _value);
129     return true;
130   }
131 
132   /**
133    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138 
139     // To change the approve amount you first have to reduce the addresses`
140     //  allowance to zero by calling `approve(_spender, 0)` if it is not
141     //  already 0 to mitigate the race condition described here:
142     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
144 
145     allowed[msg.sender][_spender] = _value;
146     emit Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifing the amount of tokens still avaible for the spender.
155    */
156   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
157     return allowed[_owner][_spender];
158   }
159 
160 }
161 
162 /**
163  * @title Ownable
164  * @dev The Ownable contract has an owner address, and provides basic authorization control
165  * functions, this simplifies the implementation of "user permissions".
166  */
167 contract Ownable {
168   address public owner;
169 
170 
171   /**
172    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
173    * account.
174    */
175   function Ownable() public {
176     owner = msg.sender;
177   }
178 
179 
180   /**
181    * @dev Throws if called by any account other than the owner.
182    */
183   modifier onlyOwner() {
184     require(msg.sender == owner);
185     _;
186   }
187 
188 
189   /**
190    * @dev Allows the current owner to transfer control of the contract to a newOwner.
191    * @param newOwner The address to transfer ownership to.
192    */
193   function transferOwnership(address newOwner) public onlyOwner {
194     if (newOwner != address(0)) {
195       owner = newOwner;
196     }
197   }
198 
199 }
200 
201 /**
202  * @title Pausable
203  * @dev Base contract which allows children to implement an emergency stop mechanism.
204  */
205 contract Pausable is Ownable {
206   event Pause();
207   event Unpause();
208 
209   bool public paused = false;
210 
211 
212   /**
213    * @dev modifier to allow actions only when the contract IS paused
214    */
215   modifier whenNotPaused() {
216     require(!paused);
217     _;
218   }
219 
220   /**
221    * @dev modifier to allow actions only when the contract IS NOT paused
222    */
223   modifier whenPaused {
224     require(paused);
225     _;
226   }
227 
228   /**
229    * @dev called by the owner to pause, triggers stopped state
230    */
231   function pause() onlyOwner whenNotPaused public returns (bool) {
232     paused = true;
233     emit Pause();
234     return true;
235   }
236 
237   /**
238    * @dev called by the owner to unpause, returns to normal state
239    */
240   function unpause() public onlyOwner whenPaused returns (bool) {
241     paused = false;
242     emit Unpause();
243     return true;
244   }
245 }
246 
247 /**
248  * @title Modern Token Plus
249  * @dev ERC20 ModernTokenPlus (MTP)
250  *
251  * MTP Tokens are divisible by 1e8 (100,000,000) base
252  * units referred to as 'Grains'.
253  *
254  * MTP are displayed using 8 decimal places of precision.
255  *
256  * 1 MTP is equivalent to:
257  *   100000000 == 1 * 10*8 == 1e8
258  *
259  * All initial MTP Grains are assigned to the creator of
260  * this contract.
261  *
262  */
263 contract ModernTokenPlus is StandardToken, Pausable {
264 
265   string public constant name = 'ModernTokenPlus';                                      // Set the token name for display
266   string public constant symbol = 'MTP';                                       // Set the token symbol for display
267   uint8 public constant decimals = 8;                                           // Set the number of decimals for display
268   uint256 public constant INITIAL_SUPPLY = 4000000 * 10**uint256(decimals);    // 10000000 MTP specified in Grains
269 
270   /**
271    * @dev ModernTokenPlus Constructor
272    * Runs only on initial contract creation.
273    */
274   function ModernTokenPlus() public {
275     totalSupply = INITIAL_SUPPLY;                               // Set the total supply
276     balances[msg.sender] = INITIAL_SUPPLY;                      // Creator address is assigned all
277   }
278 
279   /**
280    * @dev Transfer token for a specified address when not paused
281    * @param _to The address to transfer to.
282    * @param _value The amount to be transferred.
283    */
284   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
285     require(_to != address(0));
286     return super.transfer(_to, _value);
287   }
288 
289   /**
290    * @dev Transfer tokens from one address to another when not paused
291    * @param _from address The address which you want to send tokens from
292    * @param _to address The address which you want to transfer to
293    * @param _value uint256 the amount of tokens to be transferred
294    */
295   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
296     require(_to != address(0));
297     return super.transferFrom(_from, _to, _value);
298   }
299 
300   /**
301    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
302    * @param _spender The address which will spend the funds.
303    * @param _value The amount of tokens to be spent.
304    */
305   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
306     return super.approve(_spender, _value);
307   }
308 
309 }