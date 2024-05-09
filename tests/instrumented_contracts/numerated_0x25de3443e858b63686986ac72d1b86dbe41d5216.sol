1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 {
62   function totalSupply() public view returns (uint256);
63 
64   function balanceOf(address _who) public view returns (uint256);
65 
66   function allowance(address _owner, address _spender)
67     public view returns (uint256);
68 
69   function transfer(address _to, uint256 _value) public returns (bool);
70 
71   function approve(address _spender, uint256 _value)
72     public returns (bool);
73 
74   function transferFrom(address _from, address _to, uint256 _value)
75     public returns (bool);
76 
77   event Transfer(
78     address indexed from,
79     address indexed to,
80     uint256 value
81   );
82 
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * https://github.com/ethereum/EIPs/issues/20
97  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20 {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106   uint256 totalSupply_;
107 
108   /**
109   * @dev Total number of tokens in existence
110   */
111   function totalSupply() public view returns (uint256) {
112     return totalSupply_;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) public view returns (uint256) {
121     return balances[_owner];
122   }
123 
124   /**
125    * @dev Function to check the amount of tokens that an owner allowed to a spender.
126    * @param _owner address The address which owns the funds.
127    * @param _spender address The address which will spend the funds.
128    * @return A uint256 specifying the amount of tokens still available for the spender.
129    */
130   function allowance(
131     address _owner,
132     address _spender
133    )
134     public
135     view
136     returns (uint256)
137   {
138     return allowed[_owner][_spender];
139   }
140 
141   /**
142   * @dev Transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_value <= balances[msg.sender]);
148     require(_to != address(0));
149 
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     emit Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(
178     address _from,
179     address _to,
180     uint256 _value
181   )
182     public
183     returns (bool)
184   {
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187     require(_to != address(0));
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     emit Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Increase the amount of tokens that an owner allowed to a spender.
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(
206     address _spender,
207     uint256 _addedValue
208   )
209     public
210     returns (bool)
211   {
212     allowed[msg.sender][_spender] = (
213       allowed[msg.sender][_spender].add(_addedValue));
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    * approve should be called when allowed[_spender] == 0. To decrement
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _subtractedValue The amount of tokens to decrease the allowance by.
226    */
227   function decreaseApproval(
228     address _spender,
229     uint256 _subtractedValue
230   )
231     public
232     returns (bool)
233   {
234     uint256 oldValue = allowed[msg.sender][_spender];
235     if (_subtractedValue >= oldValue) {
236       allowed[msg.sender][_spender] = 0;
237     } else {
238       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239     }
240     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244 }
245 
246 
247 
248 contract CTFOCrowdsale is StandardToken {
249 
250 	using SafeMath for uint256;
251 
252 	string public constant name = "Orinoco D. F. Co-founder Token";
253 	string public constant symbol = "CTFO";
254 	uint8 public constant decimals = 18;
255 
256 	uint256 public constant INITIAL_SUPPLY = 1000000 * (10 ** uint256(decimals));
257 	uint256 public constant TEAM_TOKENS = 140000 * (10 ** uint256(decimals));
258 	uint256 public constant SALE_TOKENS = 860000 * (10 ** uint256(decimals));	
259 	uint256 public constant exchangeRate = 500;
260 
261 	bool public isFinalized = false;
262 
263 	address public constant etherAddress = 0xFC20A4238ABAfBFa29F582CbcF93e23cD3c9858b;
264 	address public constant teamWallet = 0x4c646420d8A8ae7C66de9c40FfE31c295c87272B;
265 	address public constant saleWallet = 0x9D4537094Fa30d8042A51F4F0CD29F170B28456B;
266 
267 	uint256 public constant crowdsaleStart = 1534204800;
268 	uint256 public constant crowdsaleEnd = 1536019200;
269 
270 
271 	event Mint(address indexed to, uint256 amount);
272 
273 	constructor () public {
274 
275 		totalSupply_ = INITIAL_SUPPLY;
276 
277 		balances[teamWallet] = TEAM_TOKENS;
278 		emit Mint(teamWallet, TEAM_TOKENS);
279 		emit Transfer(address(0), teamWallet, TEAM_TOKENS);
280 
281 		balances[saleWallet] = SALE_TOKENS;
282 		emit Mint(saleWallet, SALE_TOKENS);
283 		emit Transfer(address(0), saleWallet, SALE_TOKENS);
284 
285 	}
286 
287 
288 	function purchaseTokens() public payable  {
289 
290 		require( now >= crowdsaleStart );
291 		require( now <= crowdsaleEnd );
292 
293 		require( msg.value >= 1000 finney );
294 
295 		uint256 tokens = 0;
296 		tokens = msg.value.mul(exchangeRate);
297 		
298 		uint256 unsoldTokens = balances[saleWallet];
299 
300 		require( unsoldTokens >= tokens );
301 
302 		balances[saleWallet] -= tokens;
303 		balances[msg.sender] += tokens;
304 		emit Transfer(saleWallet, msg.sender, tokens);
305 		
306 		etherAddress.transfer(msg.value.mul(90).div(100));
307 		teamWallet.transfer(msg.value.mul(10).div(100));
308 
309 	}
310 
311 
312 	function() public payable {
313 
314 		purchaseTokens();
315 
316 	}
317 
318 
319 	event Burn(address indexed burner, uint256 value);
320 
321 	function burn(uint256 _value) public {
322 		require( !isFinalized );
323 		require( msg.sender == saleWallet );
324 		require( now > crowdsaleEnd || balances[msg.sender] == 0);
325 
326 		_burn(msg.sender, _value);
327 	}
328 
329 	function _burn(address _who, uint256 _value) internal {
330 		require(_value <= balances[_who]);
331 
332 		balances[_who] = balances[_who].sub(_value);
333 		totalSupply_ = totalSupply_.sub(_value);
334 		emit Burn(_who, _value);
335 		emit Transfer(_who, address(0), _value);
336 
337 		if (balances[_who] == 0) {
338 			isFinalized = true;
339 		}
340 	}
341 
342 }