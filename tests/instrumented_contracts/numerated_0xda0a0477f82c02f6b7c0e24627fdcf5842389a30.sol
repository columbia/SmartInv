1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 {
76   function totalSupply() public view returns (uint256);
77 
78   function balanceOf(address _who) public view returns (uint256);
79 
80   function allowance(address _owner, address _spender)
81     public view returns (uint256);
82 
83   function transfer(address _to, uint256 _value) public returns (bool);
84 
85   function approve(address _spender, uint256 _value)
86     public returns (bool);
87 
88   function transferFrom(address _from, address _to, uint256 _value)
89     public returns (bool);
90 
91   event Transfer(
92     address indexed from,
93     address indexed to,
94     uint256 value
95   );
96 
97   event Approval(
98     address indexed owner,
99     address indexed spender,
100     uint256 value
101   );
102 }
103 
104 
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://github.com/ethereum/EIPs/issues/20
111  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract StandardToken is ERC20 {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   mapping (address => mapping (address => uint256)) internal allowed;
119 
120   uint256 totalSupply_;
121 
122   /**
123   * @dev Total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return totalSupply_;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) public view returns (uint256) {
135     return balances[_owner];
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(
145     address _owner,
146     address _spender
147    )
148     public
149     view
150     returns (uint256)
151   {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156   * @dev Transfer token for a specified address
157   * @param _to The address to transfer to.
158   * @param _value The amount to be transferred.
159   */
160   function transfer(address _to, uint256 _value) public returns (bool) {
161     require(_value <= balances[msg.sender]);
162     require(_to != address(0));
163 
164     balances[msg.sender] = balances[msg.sender].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     emit Transfer(msg.sender, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Transfer tokens from one address to another
187    * @param _from address The address which you want to send tokens from
188    * @param _to address The address which you want to transfer to
189    * @param _value uint256 the amount of tokens to be transferred
190    */
191   function transferFrom(
192     address _from,
193     address _to,
194     uint256 _value
195   )
196     public
197     returns (bool)
198   {
199     require(_value <= balances[_from]);
200     require(_value <= allowed[_from][msg.sender]);
201     require(_to != address(0));
202 
203     balances[_from] = balances[_from].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
206     emit Transfer(_from, _to, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Increase the amount of tokens that an owner allowed to a spender.
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(
220     address _spender,
221     uint256 _addedValue
222   )
223     public
224     returns (bool)
225   {
226     allowed[msg.sender][_spender] = (
227       allowed[msg.sender][_spender].add(_addedValue));
228     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232   /**
233    * @dev Decrease the amount of tokens that an owner allowed to a spender.
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(
242     address _spender,
243     uint256 _subtractedValue
244   )
245     public
246     returns (bool)
247   {
248     uint256 oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue >= oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 
261 
262 contract ITFOSale is StandardToken {
263 
264 	using SafeMath for uint256;
265 
266 	string public constant name = "Orinoco D. F. Investment Token";
267 	string public constant symbol = "ITFO";
268 	uint8 public constant decimals = 18;
269 
270 	uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
271 	uint256 public constant exchangeRate = 5000;
272 
273 	address public constant etherAddress = 0xFC20A4238ABAfBFa29F582CbcF93e23cD3c9858b;
274 	address public constant operatingAddress = 0x4c646420d8A8ae7C66de9c40FfE31c295c87272B;
275 
276 	uint256 public constant saleStart = 1534204800;
277 
278 
279 	event Mint(address indexed to, uint256 amount);
280 
281 	constructor () public {
282 
283 		totalSupply_ = INITIAL_SUPPLY;
284 
285 		balances[this] = INITIAL_SUPPLY;
286 		emit Mint(this, INITIAL_SUPPLY);
287 		emit Transfer(address(0), this, INITIAL_SUPPLY);
288 
289 	}
290 
291 
292 	function sellTokens() public payable {
293 
294 		require( now >= saleStart );
295 
296 		require( msg.value > 0 );
297 
298 		uint256 tokens = 0;
299 		tokens = msg.value.mul(exchangeRate);
300 
301 		uint256 unsoldTokens = balances[this];
302 
303 		require( unsoldTokens >= tokens );
304 
305 		balances[this] -= tokens;
306 		balances[msg.sender] += tokens;
307 		emit Transfer(this, msg.sender, tokens);
308 
309 		etherAddress.transfer(msg.value.mul(90).div(100));
310 		operatingAddress.transfer(msg.value.mul(10).div(100));
311 
312 	}
313 
314 
315 	function() public payable {
316 
317 		sellTokens();
318 
319 	}
320 
321 }