1 pragma solidity ^0.4.25;
2 
3 
4 /**
5 * @title Contract that will work with ERC223 tokens.
6 */
7 
8 contract ERC223ReceivingContract {
9   /**
10    * @dev Standard ERC223 function that will handle incoming token transfers.
11    *
12    * @param _from  Token sender address.
13    * @param _value Amount of tokens.
14    * @param _data  Transaction metadata.
15    */
16   function tokenFallback(address _from, uint _value, bytes _data) public;
17 }
18 
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, throws on overflow.
28   */
29   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
30     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
31     // benefit is lost if 'b' is also tested.
32     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33     if (_a == 0) {
34       return 0;
35     }
36 
37     c = _a * _b;
38     assert(c / _a == _b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     // assert(_b > 0); // Solidity automatically throws when dividing by 0
47     // uint256 c = _a / _b;
48     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
49     return _a / _b;
50   }
51 
52   /**
53   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
56     assert(_b <= _a);
57     return _a - _b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
64     c = _a + _b;
65     assert(c >= _a);
66     return c;
67   }
68 }
69 
70 
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * See https://github.com/ethereum/EIPs/issues/179
75  */
76 contract ERC20Basic {
77   function totalSupply() public view returns (uint256);
78   function balanceOf(address _who) public view returns (uint256);
79   function transfer(address _to, uint256 _value) public returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) internal balances;
92 
93   uint256 internal totalSupply_;
94 
95   /**
96   * @dev Total number of tokens in existence
97   */
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   /**
103   * @dev Transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(_value <= balances[msg.sender]);
109     require(_to != address(0));
110 
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     emit Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 
129 /**
130  * @title Burnable Token
131  * @dev Token that can be irreversibly burned (destroyed).
132  */
133 contract BurnableToken is BasicToken {
134 
135   event Burn(address indexed burner, uint256 value);
136 
137   /**
138    * @dev Burns a specific amount of tokens.
139    * @param _value The amount of token to be burned.
140    */
141   function burn(uint256 _value) public {
142     _burn(msg.sender, _value);
143   }
144 
145   function _burn(address _who, uint256 _value) internal {
146     require(_value <= balances[_who]);
147     // no need to require value <= totalSupply, since that would imply the
148     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
149 
150     balances[_who] = balances[_who].sub(_value);
151     totalSupply_ = totalSupply_.sub(_value);
152     emit Burn(_who, _value);
153     emit Transfer(_who, address(0), _value);
154   }
155 }
156 
157 
158 /**
159  * @title ERC223
160  * @dev Simpler version of ERC223
161  * See https://github.com/ethereum/EIPs/issues/223
162  * Recommended implementation of ERC 223: https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol
163  */
164 contract ERC223Burnable is BurnableToken {
165 
166   //Extended transfer event
167   event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
168 
169   string public name;
170   string public symbol;
171   uint8 public decimals;
172 
173 
174   /**
175     * @dev Transfer token for a specified address, ERC223
176     * @param _to The address to transfer to.
177     * @param _value The amount to be transferred.
178   */
179   // Standard function transfer similar to ERC20 transfer with no _data .
180   // Added due to backwards compatibility reasons .
181   function transfer(address _to, uint _value) public returns (bool) {
182 
183     //standard function transfer similar to ERC20 transfer with no _data
184     //added due to backwards compatibility reasons
185     bytes memory empty;
186     if (isContract(_to)) {
187       return transferToContract(_to, _value, empty);
188     } else {
189       return transferToAddress(_to, _value, empty);
190     }
191   }
192 
193 
194   /**
195   * @dev Transfer token for a specified address, ERC223
196   * @param _to The address to transfer to.
197   * @param _value The amount to be transferred.
198   * @param _data User data.
199   */
200   // Function that is called when a user or another contract wants to transfer funds .
201   function transfer(address _to, uint _value, bytes _data) public returns (bool) {
202 
203     if (isContract(_to)) {
204       return transferToContract(_to, _value, _data);
205     } else {
206       return transferToAddress(_to, _value, _data);
207     }
208   }
209 
210   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
211   function isContract(address _addr) internal view returns (bool) {
212     uint length;
213     assembly {
214     //retrieve the size of the code on target address, this needs assembly
215       length := extcodesize(_addr)
216     }
217     return (length > 0);
218   }
219 
220   //function that is called when transaction target is an address
221   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {
222     require(_value <= balances[msg.sender]);
223     require(_to != address(0));
224     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
225     balances[_to] = balanceOf(_to).add(_value);
226     emit Transfer(msg.sender, _to, _value, _data);
227     return true;
228   }
229 
230   //function that is called when transaction target is a contract
231   function transferToContract(address _to, uint _value, bytes _data) private returns (bool) {
232     require(_value <= balances[msg.sender]);
233     require(_to != address(0));
234     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
235     balances[_to] = balanceOf(_to).add(_value);
236     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
237     receiver.tokenFallback(msg.sender, _value, _data);
238     emit Transfer(msg.sender, _to, _value, _data);
239     return true;
240   }
241 }
242 
243 
244 contract UniGoldToken is ERC223Burnable {
245   address public minter;
246   string public name = "UniGoldCoin";
247   string public symbol = "UGCС";
248   uint8 public decimals = 0;
249 
250   event Mint(address indexed to, uint256 amount);
251 
252   /**
253    * @dev constructor sets the 'minter'
254    * account.
255    */
256   constructor(address _minter) public {
257     minter = _minter;
258   }
259 
260   /**
261    * @dev Throws if called by any account other than the minter.
262    */
263   modifier onlyMinter() {
264     require(msg.sender == minter);
265     _;
266   }
267 
268   /**
269    * @dev Function to mint tokens
270    * @param _to The address that will receive the minted tokens.
271    * @param _amount The amount of tokens to mint.
272    * @return A boolean that indicates if the operation was successful.
273    */
274   function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
275     totalSupply_ = totalSupply_.add(_amount);
276     balances[_to] = balances[_to].add(_amount);
277     emit Mint(_to, _amount);
278     emit Transfer(address(0), _to, _amount);
279     return true;
280   }
281 
282 }