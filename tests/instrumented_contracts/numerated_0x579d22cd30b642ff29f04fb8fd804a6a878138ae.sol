1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   function Ownable() {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) onlyOwner {
17     if (newOwner != address(0)) {
18       owner = newOwner;
19     }
20   }
21 }
22 
23 contract ERC20Basic {
24   uint256 public totalSupply;
25   function balanceOf(address who) constant returns (uint256);
26   function transfer(address to, uint256 value) returns (bool);
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 
30 contract ERC20 is ERC20Basic {
31   function allowance(address owner, address spender) constant returns (uint256);
32   function transferFrom(address from, address to, uint256 value) returns (bool);
33   function approve(address spender, uint256 value) returns (bool);
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 
38 contract Peony is Ownable {
39 
40   string public version;
41   string public unit = "piece";
42   uint256 public total;
43   struct Bullion {
44     string index;
45     string unit;
46     uint256 amount;
47     string ipfs;
48   }
49   bytes32[] public storehouseIndex;
50   mapping (bytes32 => Bullion) public storehouse;
51   address public tokenAddress;
52   uint256 public rate = 10;
53   PeonyToken token;
54 
55 
56 
57 
58 
59   function Peony(string _version) {
60     version = _version;
61   }
62 
63 
64 
65 
66   event Stock (
67     string index,
68     string unit,
69     uint256 amount,
70     string ipfs,
71     uint256 total
72   );
73 
74   event Ship (
75     string index,
76     uint256 total
77   );
78 
79   event Mint (
80     uint256 amount,
81     uint256 total
82   );
83 
84   event Reduce (
85     uint256 amount,
86     uint256 total
87   );
88 
89 
90 
91 
92 
93   function stock(string _index, string _unit, uint256 _amount, string _ipfs) onlyOwner returns (bool);
94 
95   function ship(string _index) onlyOwner returns (bool);
96 
97   function mint(uint256 _ptAmount) onlyOwner returns (bool);
98 
99   function reduce(uint256 _tokenAmount) onlyOwner returns (bool);
100 
101   function setRate(uint256 _rate) onlyOwner returns (bool);
102 
103   function setTokenAddress(address _address) onlyOwner returns (bool);
104 
105 
106 
107   function convert2Peony(uint256 _amount) constant returns (uint256);
108 
109   function convert2PeonyToken(uint256 _amount) constant returns (uint256);
110 
111   function info(string _index) constant returns (string, string, uint256, string);
112 
113   function suicide() onlyOwner returns (bool);
114 }
115 
116 contract PeonyToken is Ownable, ERC20 {
117   using SafeMath for uint256;
118 
119   string public version;
120   string public name;
121   string public symbol;
122   uint256 public decimals;
123   address public peony;
124 
125   mapping(address => mapping (address => uint256)) allowed;
126   mapping(address => uint256) balances;
127   uint256 public totalSupply;
128   uint256 public totalSupplyLimit;
129   mapping(address => uint256) public transferLimits;
130 
131   function PeonyToken(
132     string _version,
133     uint256 initialSupply,
134     uint256 totalSupplyLimit_,
135     string tokenName,
136     uint8 decimalUnits,
137     string tokenSymbol
138     ) {
139     require(totalSupplyLimit_ == 0 || totalSupplyLimit_ >= initialSupply);
140     version = _version;
141     balances[msg.sender] = initialSupply;
142     totalSupply = initialSupply;
143     totalSupplyLimit = totalSupplyLimit_;
144     name = tokenName;
145     symbol = tokenSymbol;
146     decimals = decimalUnits;
147   }
148 
149   modifier isPeonyContract() {
150     require(peony != 0x0);
151     require(msg.sender == peony);
152     _;
153   }
154 
155   modifier isOwnerOrPeonyContract() {
156     require(msg.sender != address(0) && (msg.sender == peony || msg.sender == owner));
157     _;
158   }
159 
160   /**
161    * @notice produce `amount` of tokens to `_owner`
162    * @param amount The amount of tokens to produce
163    * @return Whether or not producing was successful
164    */
165   function produce(uint256 amount) isPeonyContract returns (bool) {
166     require(totalSupplyLimit == 0 || totalSupply.add(amount) <= totalSupplyLimit);
167 
168     balances[owner] = balances[owner].add(amount);
169     totalSupply = totalSupply.add(amount);
170 
171     return true;
172   }
173 
174   /**
175    * @notice Reduce digital artwork tokens for changing physical artwork
176    * @param amount Reduce token amount
177    */
178   function reduce(uint256 amount) isPeonyContract returns (bool) {
179     require(balances[owner].sub(amount) >= 0);
180     require(totalSupply.sub(amount) >= 0);
181 
182     balances[owner] = balances[owner].sub(amount);
183     totalSupply = totalSupply.sub(amount);
184 
185     return true;
186   }
187 
188   /**
189    * @notice Set address of Peony contract.
190    * @param _address the address of Peony contract
191    */
192   function setPeonyAddress(address _address) onlyOwner returns (bool) {
193     require(_address != 0x0);
194 
195     peony = _address;
196     return true;
197   }
198 
199   /**
200    * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
201    * @notice send `_value` token to `_to`
202    * @param _to The address of the recipient
203    * @param _value The amount of token to be transferred
204    * @return Whether the transfer was successful or not
205    */
206   function transfer(address _to, uint256 _value) returns (bool) {
207     require(_to != address(0));
208     require(transferLimits[msg.sender] == 0 || transferLimits[msg.sender] >= _value);
209 
210     balances[msg.sender] = balances[msg.sender].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212 
213     Transfer(msg.sender, _to, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Transfer tokens from one address to another
219    * @param _from address The address which you want to send tokens from
220    * @param _to address The address which you want to transfer to
221    * @param _value uint256 the amount of tokens to be transferred
222    */
223   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
224     require(_to != address(0));
225 
226     balances[_from] = balances[_from].sub(_value);
227     balances[_to] = balances[_to].add(_value);
228     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229     Transfer(_from, _to, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235    *
236    * Beware that changing an allowance with this method brings the risk that someone may use both the old
237    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240    * @param _spender The address which will spend the funds.
241    * @param _value The amount of tokens to be spent.
242    */
243   function approve(address _spender, uint256 _value) public returns (bool) {
244     allowed[msg.sender][_spender] = _value;
245     Approval(msg.sender, _spender, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Function to check the amount of tokens that an owner allowed to a spender.
251    * @param _owner address The address which owns the funds.
252    * @param _spender address The address which will spend the funds.
253    * @return A uint256 specifying the amount of tokens still available for the spender.
254    */
255   function allowance(address _owner, address _spender) public constant returns (uint256) {
256     return allowed[_owner][_spender];
257   }
258 
259   /**
260    * @notice return total amount of tokens uint256 public totalSupply;
261    * @param _owner The address from which the balance will be retrieved
262    * @return The balance
263    */
264   function balanceOf(address _owner) constant returns (uint256 balance) {
265     return balances[_owner];
266   }
267 
268   /**
269    * @notice Set transfer upper limit
270    * @param transferLimit Transfer upper limit
271    * @return Whether the operation was successful or not
272    */
273   function setTransferLimit(uint256 transferLimit) returns (bool) {
274     transferLimits[msg.sender] = transferLimit;
275   }
276 
277   /**
278    * @notice Delete the contract
279    */
280   function suicide() onlyOwner returns (bool) {
281     selfdestruct(owner);
282     return true;
283   }
284 }
285 
286 library ConvertStringByte {
287   function bytes32ToString(bytes32 x) constant returns (string) {
288     bytes memory bytesString = new bytes(32);
289     uint charCount = 0;
290     for (uint j = 0; j < 32; j++) {
291       byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
292       if (char != 0) {
293           bytesString[charCount] = char;
294           charCount++;
295       }
296     }
297     bytes memory bytesStringTrimmed = new bytes(charCount);
298     for (j = 0; j < charCount; j++) {
299       bytesStringTrimmed[j] = bytesString[j];
300     }
301     return string(bytesStringTrimmed);
302   }
303 
304   function stringToBytes32(string memory source) returns (bytes32 result) {
305     assembly {
306       result := mload(add(source, 32))
307     }
308   }
309 }
310 
311 library SafeMath {
312   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
313     uint256 c = a * b;
314     assert(a == 0 || c / a == b);
315     return c;
316   }
317 
318   function div(uint256 a, uint256 b) internal constant returns (uint256) {
319     // assert(b > 0); // Solidity automatically throws when dividing by 0
320     uint256 c = a / b;
321     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
322     return c;
323   }
324 
325   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
326     assert(b <= a);
327     return a - b;
328   }
329 
330   function add(uint256 a, uint256 b) internal constant returns (uint256) {
331     uint256 c = a + b;
332     assert(c >= a);
333     return c;
334   }
335 }