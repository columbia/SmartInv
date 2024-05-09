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
83   /**
84   * @dev Basic version of ERC20 Standard
85   * @dev see https://github.com/ethereum/EIPs/issues/20
86   * This function is executed once in the initial stage.
87   */
88   function PeonyToken(
89     string _version,
90     uint256 initialSupply,
91     uint256 totalSupplyLimit_,
92     string tokenName,
93     uint8 decimalUnits,
94     string tokenSymbol
95     ) {
96     require(totalSupplyLimit_ == 0 || totalSupplyLimit_ >= initialSupply);
97     version = _version;
98     balances[msg.sender] = initialSupply;
99     totalSupply = initialSupply;
100     totalSupplyLimit = totalSupplyLimit_;
101     name = tokenName;
102     symbol = tokenSymbol;
103     decimals = decimalUnits;
104   }
105 
106   /**
107   * This contract only defines a modifier but does not use it
108   * it will be used in derived contracts.
109   * The function body is inserted where the special symbol
110   * "_;" in the definition of a modifier appears.
111   * This means that if the owner calls this function, the
112   * function is executed and otherwise, an exception is  thrown.
113   */
114   modifier isPeonyContract() {
115     require(peony != 0x0);
116     require(msg.sender == peony);
117     _;
118   }
119 
120   /**
121   * This contract only defines a modifier but does not use it
122   * it will be used in derived contracts.
123   * The function body is inserted where the special symbol
124   * "_;" in the definition of a modifier appears.
125   * This means that if the owner calls this function, the
126   * function is executed and otherwise, an exception is  thrown.
127   */
128   modifier isOwnerOrPeonyContract() {
129     require(msg.sender != address(0) && (msg.sender == peony || msg.sender == owner));
130     _;
131   }
132 
133   /**
134   * @notice produce `amount` of tokens to `_owner`
135   * @param amount The amount of tokens to produce
136   * @return Whether or not producing was successful
137   */
138   function produce(uint256 amount) isPeonyContract returns (bool) {
139     require(totalSupplyLimit == 0 || totalSupply.add(amount) <= totalSupplyLimit);
140 
141     balances[owner] = balances[owner].add(amount);
142     totalSupply = totalSupply.add(amount);
143 
144     return true;
145   }
146 
147   /**
148   * @notice consume digital artwork tokens for changing physical artwork
149   * @param amount consume token amount
150   */
151   function consume(uint256 amount) isPeonyContract returns (bool) {
152     require(balances[owner].sub(amount) >= 0);
153     require(totalSupply.sub(amount) >= 0);
154     balances[owner] = balances[owner].sub(amount);
155     totalSupply = totalSupply.sub(amount);
156 
157     return true;
158   }
159 
160   /**
161   * @notice Set address of Peony contract.
162   * @param _address the address of Peony contract
163   */
164   function setPeonyAddress(address _address) onlyOwner returns (bool) {
165     require(_address != 0x0);
166 
167     peony = _address;
168     return true;
169   }
170 
171   /**
172   * Implements ERC 20 Token standard:https://github.com/ethereum/EIPs/issues/20
173   * @notice send `_value` token to `_to`
174   * @param _to The address of the recipient
175   * @param _value The amount of token to be transferred
176   * @return Whether the transfer was successful or not
177   */
178   function transfer(address _to, uint256 _value) returns (bool) {
179     require(_to != address(0));
180 
181     balances[msg.sender] = balances[msg.sender].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183 
184     Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Transfer tokens from one address to another
190   * @param _from address The address which you want to send tokens from
191   * @param _to address The address which you want to transfer to
192   * @param _value uint256 the amount of tokens to be transferred
193   */
194   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200     Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206   * Beware that changing an allowance with this method brings the risk that someone may use both the old
207   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210   * @param _spender The address which will spend the funds.
211   * @param _value The amount of tokens to be spent.
212   */
213   function approve(address _spender, uint256 _value) public returns (bool) {
214     allowed[msg.sender][_spender] = _value;
215     Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220   * @dev Function to check the amount of tokens that an owner allowed to a spender.
221   * @param _owner address The address which owns the funds.
222   * @param _spender address The address which will spend the funds.
223   * @return A uint256 specifying the amount of tokens still available for the spender.
224   */
225   function allowance(address _owner, address _spender) public constant returns (uint256) {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230   * @notice return total amount of tokens uint256 public totalSupply;
231   * @param _owner The address from which the balance will be retrieved
232   * @return The balance
233   */
234   function balanceOf(address _owner) constant returns (uint256 balance) {
235     return balances[_owner];
236   }
237 }
238 
239 /**
240 *Math operations with safety checks
241 */
242 library SafeMath {
243   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
244     uint256 c = a * b;
245     assert(a == 0 || c / a == b);
246     return c;
247   }
248 
249   function div(uint256 a, uint256 b) internal constant returns (uint256) {
250     uint256 c = a / b;
251     return c;
252   }
253 
254   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
255     assert(b <= a);
256     return a - b;
257   }
258 
259   function add(uint256 a, uint256 b) internal constant returns (uint256) {
260     uint256 c = a + b;
261     assert(c >= a);
262     return c;
263   }
264 }