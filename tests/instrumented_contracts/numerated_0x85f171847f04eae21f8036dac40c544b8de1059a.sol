1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 pragma solidity ^0.4.18;
45 
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 pragma solidity ^0.4.18;
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     Transfer(msg.sender, _to, _value);
91     return true;
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint256 representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) public view returns (uint256 balance) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 pragma solidity ^0.4.18;
106 
107 
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 pragma solidity ^0.4.18;
120 
121 contract Electrominer is ERC20, BasicToken, Ownable {
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126     string public name = "Electrominer";
127     string public symbol = "ELM";
128     
129     uint public decimals = 8;
130 function Electrominer(
131     ) public {
132         
133         balances[msg.sender] = 10000000000000000;
134         totalSupply_ = 10000000000000000;
135 }
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint256 the amount of tokens to be transferred
141    */
142   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[_from]);
145     require(_value <= allowed[_from][msg.sender]);
146 
147     balances[_from] = balances[_from].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150     Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    *
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) public returns (bool) {
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) public view returns (uint256) {
177     return allowed[_owner][_spender];
178   }
179 
180   /**
181    * @dev Increase the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To increment
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _addedValue The amount of tokens to increase the allowance by.
189    */
190   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
191     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196   /**
197    * @dev Decrease the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To decrement
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _subtractedValue The amount of tokens to decrease the allowance by.
205    */
206   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212     }
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217 }
218 pragma solidity ^0.4.18;
219 
220 
221 /**
222  * @title SafeMath
223  * @dev Math operations with safety checks that throw on error
224  */
225 library SafeMath {
226 
227   /**
228   * @dev Multiplies two numbers, throws on overflow.
229   */
230   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
231     if (a == 0) {
232       return 0;
233     }
234     uint256 c = a * b;
235     assert(c / a == b);
236     return c;
237   }
238 
239   /**
240   * @dev Integer division of two numbers, truncating the quotient.
241   */
242   function div(uint256 a, uint256 b) internal pure returns (uint256) {
243     // assert(b > 0); // Solidity automatically throws when dividing by 0
244     // uint256 c = a / b;
245     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
246     return a / b;
247   }
248 
249   /**
250   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
251   */
252   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
253     assert(b <= a);
254     return a - b;
255   }
256 
257   /**
258   * @dev Adds two numbers, throws on overflow.
259   */
260   function add(uint256 a, uint256 b) internal pure returns (uint256) {
261     uint256 c = a + b;
262     assert(c >= a);
263     return c;
264   }
265 }
266 pragma solidity ^0.4.18;
267 
268 /**
269  * @title SafeERC20
270  * @dev Wrappers around ERC20 operations that throw on failure.
271  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
272  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
273  */
274 library SafeERC20 {
275   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
276     assert(token.transfer(to, value));
277   }
278 
279   function safeTransferFrom(
280     ERC20 token,
281     address from,
282     address to,
283     uint256 value
284   )
285     internal
286   {
287     assert(token.transferFrom(from, to, value));
288   }
289 
290   function safeApprove(ERC20 token, address spender, uint256 value) internal {
291     assert(token.approve(spender, value));
292   }
293 }
294 
295 pragma solidity ^0.4.18;
296 
297 contract DetailedERC20 is ERC20 {
298   string public name;
299   string public symbol;
300   uint8 public decimals;
301 
302   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
303     name = _name;
304     symbol = _symbol;
305     decimals = _decimals;
306   }
307 }