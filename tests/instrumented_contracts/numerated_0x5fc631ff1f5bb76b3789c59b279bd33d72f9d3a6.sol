1 /**
2 *所發行數字牡丹（即BitPeony），其最終解釋權為Bitcaps.club所有，並保留所有修改權利。
3 *本專項衍生之營運政策、交易模式等資訊，其最新修訂版本，詳見官網（http://www.bitcaps.club/）正式公告。官網擁有上述公告之最終解釋權，並保留所有修改權利。
4 */
5 
6 /**
7 *Abstract contract for the full ERC 20 Token standard
8 *https://github.com/ethereum/EIPs/issues/20
9 */
10 pragma solidity ^0.4.13;
11 
12 /**
13 * @title ERC20Basic
14 * @dev Simpler version of ERC20 interface
15 * @dev see https://github.com/ethereum/EIPs/issues/20
16 */
17 contract ERC20Basic {
18   uint256 public totalSupply;
19   function balanceOf(address who) public constant returns (uint256);
20   function transfer(address to, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) public constant returns (uint256);
26   function transferFrom(address from, address to, uint256 value) public returns (bool);
27   function approve(address spender, uint256 value) public returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 /**
32 * @dev simple own functions
33 * @dev see https://github.com/ethereum/EIPs/issues/20
34 */
35 contract Ownable {
36   address public owner;
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner {
59     if (newOwner != address(0)) {
60       owner = newOwner;
61     }
62   }
63 }
64 
65 /**
66 * @title Basic token
67 * @dev Basic version of ERC20 Standard
68 * @dev see https://github.com/ethereum/EIPs/issues/20
69 */
70 contract PeonyToken is Ownable, ERC20 {
71   using SafeMath for uint256;
72   string public version;
73   string public name;
74   string public symbol;
75   uint256 public decimals;
76   address public peony;
77   mapping(address => mapping (address => uint256)) allowed;
78   mapping(address => uint256) balances;
79   uint256 public totalSupply;
80   uint256 public totalSupplyLimit;
81 
82   /**
83   * @dev Basic version of ERC20 Standard
84   * @dev see https://github.com/ethereum/EIPs/issues/20
85   * This function is executed once in the initial stage.
86   */
87   function PeonyToken(
88     string _version,
89     uint256 initialSupply,
90     uint256 totalSupplyLimit_,
91     string tokenName,
92     uint8 decimalUnits,
93     string tokenSymbol
94     ) {
95     require(totalSupplyLimit_ == 0 || totalSupplyLimit_ >= initialSupply);
96     version = _version;
97     balances[msg.sender] = initialSupply;
98     totalSupply = initialSupply;
99     totalSupplyLimit = totalSupplyLimit_;
100     name = tokenName;
101     symbol = tokenSymbol;
102     decimals = decimalUnits;
103   }
104 
105   /**
106   * This contract only defines a modifier but does not use it
107   * it will be used in derived contracts.
108   * The function body is inserted where the special symbol
109   * "_;" in the definition of a modifier appears.
110   * This means that if the owner calls this function, the
111   * function is executed and otherwise, an exception is  thrown.
112   */
113   modifier isPeonyContract() {
114     require(peony != 0x0);
115     require(msg.sender == peony);
116     _;
117   }
118 
119   /**
120   * This contract only defines a modifier but does not use it
121   * it will be used in derived contracts.
122   * The function body is inserted where the special symbol
123   * "_;" in the definition of a modifier appears.
124   * This means that if the owner calls this function, the
125   * function is executed and otherwise, an exception is  thrown.
126   */
127   modifier isOwnerOrPeonyContract() {
128     require(msg.sender != address(0) && (msg.sender == peony || msg.sender == owner));
129     _;
130   }
131 
132   /**
133   * @notice produce `amount` of tokens to `_owner`
134   * @param amount The amount of tokens to produce
135   * @return Whether or not producing was successful
136   */
137   function produce(uint256 amount) isPeonyContract returns (bool) {
138     require(totalSupplyLimit == 0 || totalSupply.add(amount) <= totalSupplyLimit);
139 
140     balances[owner] = balances[owner].add(amount);
141     totalSupply = totalSupply.add(amount);
142 
143     return true;
144   }
145 
146   /**
147   * @notice consume digital artwork tokens for changing physical artwork
148   * @param amount consume token amount
149   */
150   function consume(uint256 amount) isPeonyContract returns (bool) {
151     require(balances[owner].sub(amount) >= 0);
152     require(totalSupply.sub(amount) >= 0);
153     balances[owner] = balances[owner].sub(amount);
154     totalSupply = totalSupply.sub(amount);
155 
156     return true;
157   }
158 
159   /**
160   * @notice Set address of Peony contract.
161   * @param _address the address of Peony contract
162   */
163   function setPeonyAddress(address _address) onlyOwner returns (bool) {
164     require(_address != 0x0);
165 
166     peony = _address;
167     return true;
168   }
169 
170   /**
171   * Implements ERC 20 Token standard:https://github.com/ethereum/EIPs/issues/20
172   * @notice send `_value` token to `_to`
173   * @param _to The address of the recipient
174   * @param _value The amount of token to be transferred
175   * @return Whether the transfer was successful or not
176   */
177   function transfer(address _to, uint256 _value) returns (bool) {
178     require(_to != address(0));
179 
180     balances[msg.sender] = balances[msg.sender].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182 
183     Transfer(msg.sender, _to, _value);
184     return true;
185   }
186 
187   /**
188   * @dev Transfer tokens from one address to another
189   * @param _from address The address which you want to send tokens from
190   * @param _to address The address which you want to transfer to
191   * @param _value uint256 the amount of tokens to be transferred
192   */
193   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
194     require(_to != address(0));
195 
196     balances[_from] = balances[_from].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199     Transfer(_from, _to, _value);
200     return true;
201   }
202 
203   /**
204   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205   * Beware that changing an allowance with this method brings the risk that someone may use both the old
206   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209   * @param _spender The address which will spend the funds.
210   * @param _value The amount of tokens to be spent.
211   */
212   function approve(address _spender, uint256 _value) public returns (bool) {
213     allowed[msg.sender][_spender] = _value;
214     Approval(msg.sender, _spender, _value);
215     return true;
216   }
217 
218   /**
219   * @dev Function to check the amount of tokens that an owner allowed to a spender.
220   * @param _owner address The address which owns the funds.
221   * @param _spender address The address which will spend the funds.
222   * @return A uint256 specifying the amount of tokens still available for the spender.
223   */
224   function allowance(address _owner, address _spender) public constant returns (uint256) {
225     return allowed[_owner][_spender];
226   }
227 
228   /**
229   * @notice return total amount of tokens uint256 public totalSupply;
230   * @param _owner The address from which the balance will be retrieved
231   * @return The balance
232   */
233   function balanceOf(address _owner) constant returns (uint256 balance) {
234     return balances[_owner];
235   }
236 }
237 
238 /**
239 *Math operations with safety checks
240 */
241 library SafeMath {
242   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
243     uint256 c = a * b;
244     assert(a == 0 || c / a == b);
245     return c;
246   }
247 
248   function div(uint256 a, uint256 b) internal constant returns (uint256) {
249     uint256 c = a / b;
250     return c;
251   }
252 
253   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
254     assert(b <= a);
255     return a - b;
256   }
257 
258   function add(uint256 a, uint256 b) internal constant returns (uint256) {
259     uint256 c = a + b;
260     assert(c >= a);
261     return c;
262   }
263 }