1 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
2 pragma solidity ^0.4.24;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 //File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
18 pragma solidity ^0.4.24;
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
31     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
32     // benefit is lost if 'b' is also tested.
33     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34     if (_a == 0) {
35       return 0;
36     }
37 
38     c = _a * _b;
39     assert(c / _a == _b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
47     // assert(_b > 0); // Solidity automatically throws when dividing by 0
48     // uint256 c = _a / _b;
49     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
50     return _a / _b;
51   }
52 
53   /**
54   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
57     assert(_b <= _a);
58     return _a - _b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
65     c = _a + _b;
66     assert(c >= _a);
67     return c;
68   }
69 }
70 
71 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
72 pragma solidity ^0.4.24;
73 
74 
75 
76 
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) internal balances;
87 
88   uint256 internal totalSupply_;
89 
90   /**
91   * @dev Total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev Transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_value <= balances[msg.sender]);
104     require(_to != address(0));
105 
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     emit Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
124 pragma solidity ^0.4.24;
125 
126 
127 
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 is ERC20Basic {
134   function allowance(address _owner, address _spender)
135     public view returns (uint256);
136 
137   function transferFrom(address _from, address _to, uint256 _value)
138     public returns (bool);
139 
140   function approve(address _spender, uint256 _value) public returns (bool);
141   event Approval(
142     address indexed owner,
143     address indexed spender,
144     uint256 value
145   );
146 }
147 
148 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
149 pragma solidity ^0.4.24;
150 
151 
152 
153 
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * https://github.com/ethereum/EIPs/issues/20
160  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) internal allowed;
165 
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param _from address The address which you want to send tokens from
170    * @param _to address The address which you want to transfer to
171    * @param _value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(
174     address _from,
175     address _to,
176     uint256 _value
177   )
178     public
179     returns (bool)
180   {
181     require(_value <= balances[_from]);
182     require(_value <= allowed[_from][msg.sender]);
183     require(_to != address(0));
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     emit Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     emit Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(
214     address _owner,
215     address _spender
216    )
217     public
218     view
219     returns (uint256)
220   {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    * approve should be called when allowed[_spender] == 0. To increment
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _addedValue The amount of tokens to increase the allowance by.
232    */
233   function increaseApproval(
234     address _spender,
235     uint256 _addedValue
236   )
237     public
238     returns (bool)
239   {
240     allowed[msg.sender][_spender] = (
241       allowed[msg.sender][_spender].add(_addedValue));
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246   /**
247    * @dev Decrease the amount of tokens that an owner allowed to a spender.
248    * approve should be called when allowed[_spender] == 0. To decrement
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param _spender The address which will spend the funds.
253    * @param _subtractedValue The amount of tokens to decrease the allowance by.
254    */
255   function decreaseApproval(
256     address _spender,
257     uint256 _subtractedValue
258   )
259     public
260     returns (bool)
261   {
262     uint256 oldValue = allowed[msg.sender][_spender];
263     if (_subtractedValue >= oldValue) {
264       allowed[msg.sender][_spender] = 0;
265     } else {
266       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
267     }
268     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272 }
273 
274 //File: contracts\ico\TileToken.sol
275 /**
276 * @title TILE Token - LOOMIA
277 * @author Pactum IO <dev@pactum.io>
278 */
279 pragma solidity ^0.4.24;
280 
281 
282 
283 
284 
285 contract TileToken is StandardToken {
286     string public constant NAME = "LOOMIA TILE";
287     string public constant SYMBOL = "TILE";
288     uint8 public constant DECIMALS = 18;
289 
290     uint256 public totalSupply = 109021227 * 1e18; // Supply is 109,021,227 plus the conversion to wei
291 
292     constructor() public {
293         balances[msg.sender] = totalSupply;
294     }
295 }