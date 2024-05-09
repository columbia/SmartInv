1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 
37 }
38 
39 library SafeMath {
40 
41   /**
42   * @dev Multiplies two numbers, throws on overflow.
43   */
44   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     if (a == 0) {
46       return 0;
47     }
48     uint256 c = a * b;
49     assert(c / a == b);
50     return c;
51   }
52 
53   /**
54   * @dev Integer division of two numbers, truncating the quotient.
55   */
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   /**
64   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65   */
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   /**
72   * @dev Adds two numbers, throws on overflow.
73   */
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 contract ERC20Basic {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 contract BasicToken is ERC20Basic {
96   using SafeMath for uint256;
97 
98   mapping(address => uint256) balances;
99 
100   uint256 totalSupply_;
101 
102   /**
103   * @dev total number of tokens in existence
104   */
105   function totalSupply() public view returns (uint256) {
106     return totalSupply_;
107   }
108 
109   /**
110   * @dev transfer token for a specified address
111   * @param _to The address to transfer to.
112   * @param _value The amount to be transferred.
113   */
114   function transfer(address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value <= balances[msg.sender]);
117 
118     // SafeMath.sub will throw if there is not enough balance.
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public view returns (uint256 balance) {
131     return balances[_owner];
132   }
133 
134 }
135 
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) internal allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[_from]);
150     require(_value <= allowed[_from][msg.sender]);
151 
152     balances[_from] = balances[_from].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
155     Transfer(_from, _to, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    *
162    * Beware that changing an allowance with this method brings the risk that someone may use both the old
163    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166    * @param _spender The address which will spend the funds.
167    * @param _value The amount of tokens to be spent.
168    */
169   function approve(address _spender, uint256 _value) public returns (bool) {
170     allowed[msg.sender][_spender] = _value;
171     Approval(msg.sender, _spender, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Function to check the amount of tokens that an owner allowed to a spender.
177    * @param _owner address The address which owns the funds.
178    * @param _spender address The address which will spend the funds.
179    * @return A uint256 specifying the amount of tokens still available for the spender.
180    */
181   function allowance(address _owner, address _spender) public view returns (uint256) {
182     return allowed[_owner][_spender];
183   }
184 
185   /**
186    * @dev Increase the amount of tokens that an owner allowed to a spender.
187    *
188    * approve should be called when allowed[_spender] == 0. To increment
189    * allowed value is better to use this function to avoid 2 calls (and wait until
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    * @param _spender The address which will spend the funds.
193    * @param _addedValue The amount of tokens to increase the allowance by.
194    */
195   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
196     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201   /**
202    * @dev Decrease the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To decrement
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _subtractedValue The amount of tokens to decrease the allowance by.
210    */
211   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
212     uint oldValue = allowed[msg.sender][_spender];
213     if (_subtractedValue > oldValue) {
214       allowed[msg.sender][_spender] = 0;
215     } else {
216       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217     }
218     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222 }
223 
224 contract MintableToken is StandardToken, Ownable {
225   event Mint(address indexed to, uint256 amount);
226   event MintFinished();
227 
228   bool public mintingFinished = false;
229 
230 
231   modifier canMint() {
232     require(!mintingFinished);
233     _;
234   }
235 
236   /**
237    * @dev Function to mint tokens
238    * @param _to The address that will receive the minted tokens.
239    * @param _amount The amount of tokens to mint.
240    * @return A boolean that indicates if the operation was successful.
241    */
242   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
243     totalSupply_ = totalSupply_.add(_amount);
244     balances[_to] = balances[_to].add(_amount);
245     Mint(_to, _amount);
246     Transfer(address(0), _to, _amount);
247     return true;
248   }
249 
250   /**
251    * @dev Function to stop minting new tokens.
252    * @return True if the operation was successful.
253    */
254   function finishMinting() onlyOwner canMint public returns (bool) {
255     mintingFinished = true;
256     MintFinished();
257     return true;
258   }
259 }
260 
261 contract OSNToken is MintableToken {
262 
263   string public constant name = "OSN Token"; // solium-disable-line uppercase
264   string public constant symbol = "OSN"; // solium-disable-line uppercase
265   uint8 public constant decimals = 18; // solium-disable-line uppercase
266 
267   uint256 public constant INITIAL_SUPPLY = 93000000 * 1 ether;
268 
269   /**
270    * @dev Constructor that gives msg.sender all of existing tokens.
271    */
272   function OSNToken() public {
273     totalSupply_ = INITIAL_SUPPLY;
274     balances[msg.sender] = INITIAL_SUPPLY;
275     
276     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
277   }
278 
279 }