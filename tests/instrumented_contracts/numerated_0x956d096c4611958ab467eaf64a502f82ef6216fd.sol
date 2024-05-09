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
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38   function Ownable() {
39     owner = msg.sender;
40   }
41 
42   /**
43   * This contract only defines a modifier but does not use it
44   * it will be used in derived contracts.
45   * The function body is inserted where the special symbol
46   * "_;" in the definition of a modifier appears.
47   * This means that if the owner calls this function, the
48   * function is executed and otherwise, an exception is  thrown.
49   */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   /**
56   * @dev Allows the current owner to transfer control of the contract to a newOwner.
57   * @param newOwner The address to transfer ownership to.
58   */
59   function transferOwnership(address newOwner) onlyOwner public {
60     require(newOwner != address(0));
61     OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 }
65 
66 /**
67 * @title Basic token
68 * @dev Basic version of ERC20 Standard
69 * @dev see https://github.com/ethereum/EIPs/issues/20
70 */
71 contract PeonyToken is Ownable, ERC20 {
72   using SafeMath for uint256;
73   string public version;
74   string public name;
75   string public symbol;
76   uint256 public decimals;
77   address public peony;
78   mapping(address => mapping (address => uint256)) allowed;
79   mapping(address => uint256) balances;
80   uint256 public totalSupply;
81   uint256 public totalSupplyLimit;
82 
83 
84   /**
85   * @dev Basic version of ERC20 Standard
86   * @dev see https://github.com/ethereum/EIPs/issues/20
87   * This function is executed once in the initial stage.
88   */
89   function PeonyToken(
90     string _version,
91     uint256 initialSupply,
92     uint256 totalSupplyLimit_,
93     string tokenName,
94     uint8 decimalUnits,
95     string tokenSymbol
96     ) {
97     require(totalSupplyLimit_ == 0 || totalSupplyLimit_ >= initialSupply);
98     version = _version;
99     balances[msg.sender] = initialSupply;
100     totalSupply = initialSupply;
101     totalSupplyLimit = totalSupplyLimit_;
102     name = tokenName;
103     symbol = tokenSymbol;
104     decimals = decimalUnits;
105   }
106 
107   /**
108   * This contract only defines a modifier but does not use it
109   * it will be used in derived contracts.
110   * The function body is inserted where the special symbol
111   * "_;" in the definition of a modifier appears.
112   * This means that if the owner calls this function, the
113   * function is executed and otherwise, an exception is  thrown.
114   */
115   modifier isPeonyContract() {
116     require(peony != 0x0);
117     require(msg.sender == peony);
118     _;
119   }
120 
121   /**
122   * This contract only defines a modifier but does not use it
123   * it will be used in derived contracts.
124   * The function body is inserted where the special symbol
125   * "_;" in the definition of a modifier appears.
126   * This means that if the owner calls this function, the
127   * function is executed and otherwise, an exception is  thrown.
128   */
129   modifier isOwnerOrPeonyContract() {
130     require(msg.sender != address(0) && (msg.sender == peony || msg.sender == owner));
131     _;
132   }
133 
134   /**
135   * @notice produce `amount` of tokens to `_owner`
136   * @param amount The amount of tokens to produce
137   * @return Whether or not producing was successful
138   */
139   function produce(uint256 amount) isPeonyContract returns (bool) {
140     require(totalSupplyLimit == 0 || totalSupply.add(amount) <= totalSupplyLimit);
141 
142     balances[owner] = balances[owner].add(amount);
143     totalSupply = totalSupply.add(amount);
144 
145     return true;
146   }
147 
148   /**
149   * @notice consume digital artwork tokens for changing physical artwork
150   * @param amount consume token amount
151   */
152   function consume(uint256 amount) isPeonyContract returns (bool) {
153     require(balances[owner].sub(amount) >= 0);
154     require(totalSupply.sub(amount) >= 0);
155     balances[owner] = balances[owner].sub(amount);
156     totalSupply = totalSupply.sub(amount);
157 
158     return true;
159   }
160 
161   /**
162   * @notice Set address of Peony contract.
163   * @param _address the address of Peony contract
164   */
165   function setPeonyAddress(address _address) onlyOwner returns (bool) {
166     require(_address != 0x0);
167 
168     peony = _address;
169     return true;
170   }
171 
172   /**
173   * Implements ERC 20 Token standard:https://github.com/ethereum/EIPs/issues/20
174   * @notice send `_value` token to `_to`
175   * @param _to The address of the recipient
176   * @param _value The amount of token to be transferred
177   * @return Whether the transfer was successful or not
178   */
179   function transfer(address _to, uint256 _value) returns (bool) {
180     require(_to != address(0));
181 
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184 
185     Transfer(msg.sender, _to, _value);
186 
187     return true;
188   }
189 
190   /**
191   * @dev Transfer tokens from one address to another
192   * @param _from address The address which you want to send tokens from
193   * @param _to address The address which you want to transfer to
194   * @param _value uint256 the amount of tokens to be transferred
195   */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198 
199     balances[_from] = balances[_from].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202     Transfer(_from, _to, _value);
203 
204     return true;
205   }
206 
207   /**
208   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209   * Beware that changing an allowance with this method brings the risk that someone may use both the old
210   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
211   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
212   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213   * @param _spender The address which will spend the funds.
214   * @param _value The amount of tokens to be spent.
215   */
216   function approve(address _spender, uint256 _value) public returns (bool) {
217     allowed[msg.sender][_spender] = _value;
218     Approval(msg.sender, _spender, _value);
219     return true;
220   }
221 
222   /**
223   * @dev Function to check the amount of tokens that an owner allowed to a spender.
224   * @param _owner address The address which owns the funds.
225   * @param _spender address The address which will spend the funds.
226   * @return A uint256 specifying the amount of tokens still available for the spender.
227   */
228   function allowance(address _owner, address _spender) public constant returns (uint256) {
229     return allowed[_owner][_spender];
230   }
231 
232   /**
233   * @notice return total amount of tokens uint256 public totalSupply;
234   * @param _owner The address from which the balance will be retrieved
235   * @return The balance
236   */
237   function balanceOf(address _owner) constant returns (uint256 balance) {
238     return balances[_owner];
239   }
240 }
241 
242 /**
243 *Math operations with safety checks
244 */
245 library SafeMath {
246   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
247     uint256 c = a * b;
248     assert(a == 0 || c / a == b);
249     return c;
250   }
251 
252   function div(uint256 a, uint256 b) internal constant returns (uint256) {
253     uint256 c = a / b;
254     return c;
255   }
256 
257   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
258     assert(b <= a);
259     return a - b;
260   }
261 
262   function add(uint256 a, uint256 b) internal constant returns (uint256) {
263     uint256 c = a + b;
264     assert(c >= a);
265     return c;
266   }
267 }