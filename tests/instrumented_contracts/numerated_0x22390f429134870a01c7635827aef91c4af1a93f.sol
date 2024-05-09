1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   function totalSupply() public view returns (uint256);
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 
14 
15 
16 
17 /**
18  * @title Basic token
19  * @dev Basic version of StandardToken, with no allowances.
20  */
21 contract BasicToken is ERC20Basic {
22   using SafeMath for uint256;
23 
24   mapping(address => uint256) balances;
25 
26   uint256 totalSupply_;
27 
28   /**
29   * @dev total number of tokens in existence
30   */
31   function totalSupply() public view returns (uint256) {
32     return totalSupply_;
33   }
34 
35   /**
36   * @dev transfer token for a specified address
37   * @param _to The address to transfer to.
38   * @param _value The amount to be transferred.
39   */
40   function transfer(address _to, uint256 _value) public returns (bool) {
41     require(_to != address(0));
42     require(_value <= balances[msg.sender]);
43 
44     balances[msg.sender] = balances[msg.sender].sub(_value);
45     balances[_to] = balances[_to].add(_value);
46     emit Transfer(msg.sender, _to, _value);
47     return true;
48   }
49 
50   /**
51   * @dev Gets the balance of the specified address.
52   * @param _owner The address to query the the balance of.
53   * @return An uint256 representing the amount owned by the passed address.
54   */
55   function balanceOf(address _owner) public view returns (uint256) {
56     return balances[_owner];
57   }
58 
59 }
60 
61 
62 
63 
64 
65 
66 
67 /**
68  * @title Burnable Token
69  * @dev Token that can be irreversibly burned (destroyed).
70  */
71 contract BurnableToken is BasicToken {
72 
73   event Burn(address indexed burner, uint256 value);
74 
75   /**
76    * @dev Burns a specific amount of tokens.
77    * @param _value The amount of token to be burned.
78    */
79   function burn(uint256 _value) public {
80     _burn(msg.sender, _value);
81   }
82 
83   function _burn(address _who, uint256 _value) internal {
84     require(_value <= balances[_who]);
85     // no need to require value <= totalSupply, since that would imply the
86     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
87 
88     balances[_who] = balances[_who].sub(_value);
89     totalSupply_ = totalSupply_.sub(_value);
90     emit Burn(_who, _value);
91     emit Transfer(_who, address(0), _value);
92   }
93 }
94 
95 
96 
97 
98 
99 
100 /**
101  * @title SafeMath
102  * @dev Math operations with safety checks that throw on error
103  */
104 library SafeMath {
105 
106   /**
107   * @dev Multiplies two numbers, throws on overflow.
108   */
109   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     if (a == 0) {
111       return 0;
112     }
113     c = a * b;
114     assert(c / a == b);
115     return c;
116   }
117 
118   /**
119   * @dev Integer division of two numbers, truncating the quotient.
120   */
121   function div(uint256 a, uint256 b) internal pure returns (uint256) {
122     // assert(b > 0); // Solidity automatically throws when dividing by 0
123     // uint256 c = a / b;
124     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125     return a / b;
126   }
127 
128   /**
129   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
130   */
131   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132     assert(b <= a);
133     return a - b;
134   }
135 
136   /**
137   * @dev Adds two numbers, throws on overflow.
138   */
139   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
140     c = a + b;
141     assert(c >= a);
142     return c;
143   }
144 }
145 
146 
147 
148 
149 
150 
151 
152 
153 
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 
167 
168 
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) internal allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
189     require(_to != address(0));
190     require(_value <= balances[_from]);
191     require(_value <= allowed[_from][msg.sender]);
192 
193     balances[_from] = balances[_from].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196     emit Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    *
203    * Beware that changing an allowance with this method brings the risk that someone may use both the old
204    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210   function approve(address _spender, uint256 _value) public returns (bool) {
211     allowed[msg.sender][_spender] = _value;
212     emit Approval(msg.sender, _spender, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param _owner address The address which owns the funds.
219    * @param _spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222   function allowance(address _owner, address _spender) public view returns (uint256) {
223     return allowed[_owner][_spender];
224   }
225 
226   /**
227    * @dev Increase the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   /**
243    * @dev Decrease the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To decrement
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _subtractedValue The amount of tokens to decrease the allowance by.
251    */
252   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 
266 
267 
268 
269 /**
270  * @title Standard Burnable Token
271  * @dev Adds burnFrom method to ERC20 implementations
272  */
273 contract StandardBurnableToken is BurnableToken, StandardToken {
274 
275   /**
276    * @dev Burns a specific amount of tokens from the target address and decrements allowance
277    * @param _from address The address which you want to send tokens from
278    * @param _value uint256 The amount of token to be burned
279    */
280   function burnFrom(address _from, uint256 _value) public {
281     require(_value <= allowed[_from][msg.sender]);
282     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
283     // this function needs to emit an event with the updated approval.
284     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
285     _burn(_from, _value);
286   }
287 }
288 
289 
290 
291 
292 
293 
294 
295 /**
296  * @title OslikToken
297  * @dev ERC20 Token, where all tokens are pre-assigned to the creator.
298  * Note they can later distribute these tokens as they wish using `transfer` and other
299  * `StandardToken` functions.
300  */
301 contract OslikToken is StandardBurnableToken {
302 
303   string public constant name = 'Osliki Token'; // solium-disable-line uppercase
304   string public constant symbol = 'OSLIK'; // solium-disable-line uppercase
305   uint8 public constant decimals = 18; // solium-disable-line uppercase
306 
307   uint public constant INITIAL_SUPPLY = 10**8 * (10 ** uint(decimals));
308 
309   address public founder;
310 
311   /**
312    * @dev Constructor that gives msg.sender all of existing tokens.
313    */
314   constructor(address _oslikiFoundation) public {
315     require(_oslikiFoundation != address(0), "_oslikiFoundation is not assigned.");
316 
317     totalSupply_ = INITIAL_SUPPLY;
318     founder = _oslikiFoundation;
319     balances[founder] = INITIAL_SUPPLY;
320     emit Transfer(0x0, founder, INITIAL_SUPPLY);
321   }
322 
323 }