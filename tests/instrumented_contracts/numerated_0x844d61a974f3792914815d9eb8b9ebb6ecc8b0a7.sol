1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public view returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 
85 
86 
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[_from]);
121     require(_value <= allowed[_from][msg.sender]);
122 
123     balances[_from] = balances[_from].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    *
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param _owner address The address which owns the funds.
149    * @param _spender address The address which will spend the funds.
150    * @return A uint256 specifying the amount of tokens still available for the spender.
151    */
152   function allowance(address _owner, address _spender) public view returns (uint256) {
153     return allowed[_owner][_spender];
154   }
155 
156   /**
157    * approve should be called when allowed[_spender] == 0. To increment
158    * allowed value is better to use this function to avoid 2 calls (and wait until
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    */
162   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
163     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 
168   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
169     uint oldValue = allowed[msg.sender][_spender];
170     if (_subtractedValue > oldValue) {
171       allowed[msg.sender][_spender] = 0;
172     } else {
173       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
174     }
175     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 
179 }
180 
181 
182 /**
183  * @title Ownable
184  * @dev The Ownable contract has an owner address, and provides basic authorization control
185  * functions, this simplifies the implementation of "user permissions".
186  */
187 contract Ownable {
188   address public owner;
189 
190 
191   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193 
194   /**
195    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
196    * account.
197    */
198   function Ownable() public {
199     owner = msg.sender;
200   }
201 
202 
203   /**
204    * @dev Throws if called by any account other than the owner.
205    */
206   modifier onlyOwner() {
207     require(msg.sender == owner);
208     _;
209   }
210 
211 
212   /**
213    * @dev Allows the current owner to transfer control of the contract to a newOwner.
214    * @param newOwner The address to transfer ownership to.
215    */
216   function transferOwnership(address newOwner) public onlyOwner {
217     require(newOwner != address(0));
218     OwnershipTransferred(owner, newOwner);
219     owner = newOwner;
220   }
221 
222 }
223 
224 
225 
226 /**
227  * @title Mintable token
228  * @dev Simple ERC20 Token example, with mintable token creation
229  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
230  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
231  */
232 
233 contract MintableToken is StandardToken, Ownable {
234   event Mint(address indexed to, uint256 amount);
235   event MintFinished();
236 
237   bool public mintingFinished = false;
238 
239 
240   modifier canMint() {
241     require(!mintingFinished);
242     _;
243   }
244 
245   /**
246    * @dev Function to mint tokens
247    * @param _to The address that will receive the minted tokens.
248    * @param _amount The amount of tokens to mint.
249    * @return A boolean that indicates if the operation was successful.
250    */
251   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
252     totalSupply = totalSupply.add(_amount);
253     balances[_to] = balances[_to].add(_amount);
254     Mint(_to, _amount);
255     Transfer(address(0), _to, _amount);
256     return true;
257   }
258 
259   /**
260    * @dev Function to stop minting new tokens.
261    * @return True if the operation was successful.
262    */
263   function finishMinting() onlyOwner canMint public returns (bool) {
264     mintingFinished = true;
265     MintFinished();
266     return true;
267   }
268 }
269 
270 /**
271  * @title Capped token
272  * @dev Mintable token with a token cap.
273  */
274 
275 contract CappedToken is MintableToken {
276 
277   uint256 public cap;
278 
279   function CappedToken(uint256 _cap) public {
280     require(_cap > 0);
281     cap = _cap;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     require(totalSupply.add(_amount) <= cap);
292 
293     return super.mint(_to, _amount);
294   }
295 
296 }
297 
298 contract CWTPToken is CappedToken {
299   string public constant name = "Pre-sale CryptoWorkPlace Token";
300   string public constant symbol = "CWT-P";
301   uint8 public constant decimals = 18;
302   uint256 public constant MAX_SUPPLY = 15000000 * (uint256(10) ** decimals); //3% of 500 000 000
303 
304   function CWTPToken() public
305     CappedToken(MAX_SUPPLY)
306   {
307   }
308 }