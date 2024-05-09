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
66 contract PeonyRecord {
67     function record(address from, address to) public returns (bool);
68 }
69 
70 /**
71 * @title Basic token
72 * @dev Basic version of ERC20 Standard
73 * @dev see https://github.com/ethereum/EIPs/issues/20
74 */
75 contract PeonyToken is Ownable, ERC20 {
76   using SafeMath for uint256;
77   string public version;
78   string public name;
79   string public symbol;
80   uint256 public decimals;
81   address public peony;
82   mapping(address => mapping (address => uint256)) allowed;
83   mapping(address => uint256) balances;
84   uint256 public totalSupply;
85   uint256 public totalSupplyLimit;
86 
87   address public recordAddress;
88   PeonyRecord record;
89   bool enabledRecord = false;
90 
91   /**
92   * @dev Basic version of ERC20 Standard
93   * @dev see https://github.com/ethereum/EIPs/issues/20
94   * This function is executed once in the initial stage.
95   */
96   function PeonyToken(
97     string _version,
98     uint256 initialSupply,
99     uint256 totalSupplyLimit_,
100     string tokenName,
101     uint8 decimalUnits,
102     string tokenSymbol
103     ) {
104     require(totalSupplyLimit_ == 0 || totalSupplyLimit_ >= initialSupply);
105     version = _version;
106     balances[msg.sender] = initialSupply;
107     totalSupply = initialSupply;
108     totalSupplyLimit = totalSupplyLimit_;
109     name = tokenName;
110     symbol = tokenSymbol;
111     decimals = decimalUnits;
112   }
113 
114   /**
115   * This contract only defines a modifier but does not use it
116   * it will be used in derived contracts.
117   * The function body is inserted where the special symbol
118   * "_;" in the definition of a modifier appears.
119   * This means that if the owner calls this function, the
120   * function is executed and otherwise, an exception is  thrown.
121   */
122   modifier isPeonyContract() {
123     require(peony != 0x0);
124     require(msg.sender == peony);
125     _;
126   }
127 
128   /**
129   * This contract only defines a modifier but does not use it
130   * it will be used in derived contracts.
131   * The function body is inserted where the special symbol
132   * "_;" in the definition of a modifier appears.
133   * This means that if the owner calls this function, the
134   * function is executed and otherwise, an exception is  thrown.
135   */
136   modifier isOwnerOrPeonyContract() {
137     require(msg.sender != address(0) && (msg.sender == peony || msg.sender == owner));
138     _;
139   }
140 
141   /**
142   * @notice produce `amount` of tokens to `_owner`
143   * @param amount The amount of tokens to produce
144   * @return Whether or not producing was successful
145   */
146   function produce(uint256 amount) isPeonyContract returns (bool) {
147     require(totalSupplyLimit == 0 || totalSupply.add(amount) <= totalSupplyLimit);
148 
149     balances[owner] = balances[owner].add(amount);
150     totalSupply = totalSupply.add(amount);
151 
152     return true;
153   }
154 
155   /**
156   * @notice consume digital artwork tokens for changing physical artwork
157   * @param amount consume token amount
158   */
159   function consume(uint256 amount) isPeonyContract returns (bool) {
160     require(balances[owner].sub(amount) >= 0);
161     require(totalSupply.sub(amount) >= 0);
162     balances[owner] = balances[owner].sub(amount);
163     totalSupply = totalSupply.sub(amount);
164 
165     return true;
166   }
167 
168   /**
169   * @notice Set address of Peony contract.
170   * @param _address the address of Peony contract
171   */
172   function setPeonyAddress(address _address) onlyOwner returns (bool) {
173     require(_address != 0x0);
174 
175     peony = _address;
176     return true;
177   }
178 
179   /**
180   * Implements ERC 20 Token standard:https://github.com/ethereum/EIPs/issues/20
181   * @notice send `_value` token to `_to`
182   * @param _to The address of the recipient
183   * @param _value The amount of token to be transferred
184   * @return Whether the transfer was successful or not
185   */
186   function transfer(address _to, uint256 _value) returns (bool) {
187     require(_to != address(0));
188 
189     balances[msg.sender] = balances[msg.sender].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191 
192     Transfer(msg.sender, _to, _value);
193     toRecord(msg.sender, _to, _value);
194 
195     return true;
196   }
197 
198   /**
199   * @dev Transfer tokens from one address to another
200   * @param _from address The address which you want to send tokens from
201   * @param _to address The address which you want to transfer to
202   * @param _value uint256 the amount of tokens to be transferred
203   */
204   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     toRecord(_from, _to, _value);
212 
213     return true;
214   }
215 
216   /**
217   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218   * Beware that changing an allowance with this method brings the risk that someone may use both the old
219   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222   * @param _spender The address which will spend the funds.
223   * @param _value The amount of tokens to be spent.
224   */
225   function approve(address _spender, uint256 _value) public returns (bool) {
226     allowed[msg.sender][_spender] = _value;
227     Approval(msg.sender, _spender, _value);
228     return true;
229   }
230 
231   /**
232   * @dev Function to check the amount of tokens that an owner allowed to a spender.
233   * @param _owner address The address which owns the funds.
234   * @param _spender address The address which will spend the funds.
235   * @return A uint256 specifying the amount of tokens still available for the spender.
236   */
237   function allowance(address _owner, address _spender) public constant returns (uint256) {
238     return allowed[_owner][_spender];
239   }
240 
241   /**
242   * @notice return total amount of tokens uint256 public totalSupply;
243   * @param _owner The address from which the balance will be retrieved
244   * @return The balance
245   */
246   function balanceOf(address _owner) constant returns (uint256 balance) {
247     return balances[_owner];
248   }
249 
250   function setRecordAddress(address _address) onlyOwner returns (bool) {
251     require(_address != 0x0);
252 
253     record = PeonyRecord(_address);
254     recordAddress = _address;
255 
256     return true;
257   }
258 
259   function setEnableRecord(bool _enable) onlyOwner returns (bool) {
260     enabledRecord = _enable;
261 
262     return _enable;
263   }
264 
265   function toRecord(address _from, address _to, uint256 _value) internal {
266     if (enabledRecord != true || recordAddress == 0x0) {
267       return;
268     }
269 
270     uint256 count = _value.div(10**decimals);
271     for (uint256 i = 0; i < count; i++) {
272       record.record(_from, _to);
273     }
274   }
275 }
276 
277 /**
278 *Math operations with safety checks
279 */
280 library SafeMath {
281   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
282     uint256 c = a * b;
283     assert(a == 0 || c / a == b);
284     return c;
285   }
286 
287   function div(uint256 a, uint256 b) internal constant returns (uint256) {
288     uint256 c = a / b;
289     return c;
290   }
291 
292   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
293     assert(b <= a);
294     return a - b;
295   }
296 
297   function add(uint256 a, uint256 b) internal constant returns (uint256) {
298     uint256 c = a + b;
299     assert(c >= a);
300     return c;
301   }
302 }