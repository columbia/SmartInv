1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 
8 library Math {
9   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
10     return a >= b ? a : b;
11   }
12 
13   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
14     return a < b ? a : b;
15   }
16 
17   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
18     return a >= b ? a : b;
19   }
20 
21   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
22     return a < b ? a : b;
23   }
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal constant returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62   uint256 public totalSupply;
63   function balanceOf(address who) public constant returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender) public constant returns (uint256);
74   function transferFrom(address from, address to, uint256 value) public returns (bool);
75   function approve(address spender, uint256 value) public returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95 
96     // SafeMath.sub will throw if there is not enough balance.
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public constant returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * @dev https://github.com/ethereum/EIPs/issues/20
119  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134 
135     uint256 _allowance = allowed[_from][msg.sender];
136 
137     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
138     // require (_value <= _allowance);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = _allowance.sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * approve should be called when allowed[_spender] == 0. To increment
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    */
179   function increaseApproval (address _spender, uint _addedValue)
180     returns (bool success) {
181     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186   function decreaseApproval (address _spender, uint _subtractedValue)
187     returns (bool success) {
188     uint oldValue = allowed[msg.sender][_spender];
189     if (_subtractedValue > oldValue) {
190       allowed[msg.sender][_spender] = 0;
191     } else {
192       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
193     }
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198 }
199 
200 contract PKT is StandardToken {
201 
202   // Constants
203   // =========
204 
205   string public constant name = "Playkey Token";
206   string public constant symbol = "PKT";
207   uint8 public constant decimals = 18;
208   uint256 public tokenLimit;
209 
210 
211   // State variables
212   // ===============
213 
214   address public ico;
215   modifier icoOnly { require(msg.sender == ico); _; }
216 
217   // Tokens are frozen until ICO ends.
218   bool public tokensAreFrozen = true;
219 
220 
221   // Constructor
222   // ===========
223 
224   function PKT(address _ico, uint256 _tokenLimit) {
225     ico = _ico;
226     tokenLimit = _tokenLimit;
227   }
228 
229 
230   // Priveleged functions
231   // ====================
232 
233   // Mint few tokens and transfer them to some address.
234   function mint(address _holder, uint256 _value) external icoOnly {
235     require(_holder != address(0));
236     require(_value != 0);
237     require(totalSupply + _value <= tokenLimit);
238 
239     balances[_holder] += _value;
240     totalSupply += _value;
241     Transfer(0x0, _holder, _value);
242   }
243 
244 
245   // Allow token transfer.
246   function defrost() external icoOnly {
247     tokensAreFrozen = false;
248   }
249 
250 
251   // Save tokens from contract
252   function withdrawToken(address _tokenContract, address where, uint256 _value) external icoOnly {
253     ERC20 _token = ERC20(_tokenContract);
254     _token.transfer(where, _value);
255   }
256 
257 
258   // ERC20 functions
259   // =========================
260 
261   function transfer(address _to, uint256 _value)  public returns (bool) {
262     require(!tokensAreFrozen);
263     return super.transfer(_to, _value);
264   }
265 
266 
267   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
268     require(!tokensAreFrozen);
269     return super.transferFrom(_from, _to, _value);
270   }
271 
272 
273   function approve(address _spender, uint256 _value) public returns (bool) {
274     require(!tokensAreFrozen);
275     return super.approve(_spender, _value);
276   }
277 }