1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     if (a == 0) {
29       return 0;
30     }
31     uint256 c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers, truncating the quotient.
38   */
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   /**
47   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48   */
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   /**
55   * @dev Adds two numbers, throws on overflow.
56   */
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78   * @dev total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
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
111 
112 /**
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender) public view returns (uint256);
118   function transferFrom(address from, address to, uint256 value) public returns (bool);
119   function approve(address spender, uint256 value) public returns (bool);
120   event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 
124 
125 /**
126  * @title Ownable
127  * @dev The Ownable contract has an owner address, and provides basic authorization control
128  * functions, this simplifies the implementation of "user permissions".
129  */
130 contract Ownable {
131   address public owner;
132 
133 
134   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135 
136 
137   /**
138    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
139    * account.
140    */
141   function Ownable() public {
142     owner = msg.sender;
143   }
144 
145   /**
146    * @dev Throws if called by any account other than the owner.
147    */
148   modifier onlyOwner() {
149     require(msg.sender == owner);
150     _;
151   }
152 
153   /**
154    * @dev Allows the current owner to transfer control of the contract to a newOwner.
155    * @param newOwner The address to transfer ownership to.
156    */
157   function transferOwnership(address newOwner) public onlyOwner {
158     require(newOwner != address(0));
159     OwnershipTransferred(owner, newOwner);
160     owner = newOwner;
161   }
162 
163 }
164 
165 
166 /**
167  * @title Burnable Token
168  * @dev Token that can be irreversibly burned (destroyed).
169  */
170 contract BurnableToken is BasicToken {
171 
172   event Burn(address indexed burner, uint256 value);
173 
174   /**
175    * @dev Burns a specific amount of tokens.
176    * @param _value The amount of token to be burned.
177    */
178   function burn(uint256 _value) public {
179     require(_value <= balances[msg.sender]);
180     // no need to require value <= totalSupply, since that would imply the
181     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
182 
183     address burner = msg.sender;
184     balances[burner] = balances[burner].sub(_value);
185     totalSupply_ = totalSupply_.sub(_value);
186     Burn(burner, _value);
187     Transfer(burner, address(0), _value);
188   }
189 }
190 
191 
192 /**
193  * @title Standard ERC20 token
194  *
195  * @dev Implementation of the basic standard token.
196  * @dev https://github.com/ethereum/EIPs/issues/20
197  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
198  */
199 contract StandardToken is ERC20, BasicToken {
200 
201   mapping (address => mapping (address => uint256)) internal allowed;
202 
203 
204   /**
205    * @dev Transfer tokens from one address to another
206    * @param _from address The address which you want to send tokens from
207    * @param _to address The address which you want to transfer to
208    * @param _value uint256 the amount of tokens to be transferred
209    */
210   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
211     require(_to != address(0));
212     require(_value <= balances[_from]);
213     require(_value <= allowed[_from][msg.sender]);
214 
215     balances[_from] = balances[_from].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218     Transfer(_from, _to, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224    *
225    * Beware that changing an allowance with this method brings the risk that someone may use both the old
226    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
227    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
228    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229    * @param _spender The address which will spend the funds.
230    * @param _value The amount of tokens to be spent.
231    */
232   function approve(address _spender, uint256 _value) public returns (bool) {
233     allowed[msg.sender][_spender] = _value;
234     Approval(msg.sender, _spender, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Function to check the amount of tokens that an owner allowed to a spender.
240    * @param _owner address The address which owns the funds.
241    * @param _spender address The address which will spend the funds.
242    * @return A uint256 specifying the amount of tokens still available for the spender.
243    */
244   function allowance(address _owner, address _spender) public view returns (uint256) {
245     return allowed[_owner][_spender];
246   }
247 
248   /**
249    * @dev Increase the amount of tokens that an owner allowed to a spender.
250    *
251    * approve should be called when allowed[_spender] == 0. To increment
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _addedValue The amount of tokens to increase the allowance by.
257    */
258   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
259     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
260     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 
264   /**
265    * @dev Decrease the amount of tokens that an owner allowed to a spender.
266    *
267    * approve should be called when allowed[_spender] == 0. To decrement
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param _spender The address which will spend the funds.
272    * @param _subtractedValue The amount of tokens to decrease the allowance by.
273    */
274   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
275     uint oldValue = allowed[msg.sender][_spender];
276     if (_subtractedValue > oldValue) {
277       allowed[msg.sender][_spender] = 0;
278     } else {
279       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
280     }
281     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285 }
286 
287 
288 contract eSTATERToken is Ownable, BurnableToken, StandardToken {
289 	string public constant name = "Timeshare Estate Token";
290 	string public constant symbol = "eSTATER";
291 	uint8 public constant decimals = 18;
292 
293 	bool public paused = true;
294 	mapping(address => bool) public whitelist;
295 
296 	modifier whenNotPaused() {
297 		require(!paused || whitelist[msg.sender]);
298 		_;
299 	}
300 
301 	function eSTATERToken(address holder, address buffer) public {
302 		Transfer(address(0), holder, balances[holder] = totalSupply_ = uint256(10)**(9 + decimals));
303 		addToWhitelist(holder);
304 		addToWhitelist(buffer);
305 	}
306 
307 	function unpause() public onlyOwner {
308 		paused = false;
309 	}
310 
311 	function pause() public onlyOwner {
312 		paused = true;
313 	}
314 
315 	function addToWhitelist(address addr) public onlyOwner {
316 		whitelist[addr] = true;
317 	}
318 
319 	function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
320 		return super.transfer(to, value);
321 	}
322 
323 	function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
324 		return super.transferFrom(from, to, value);
325 	}
326 
327 }