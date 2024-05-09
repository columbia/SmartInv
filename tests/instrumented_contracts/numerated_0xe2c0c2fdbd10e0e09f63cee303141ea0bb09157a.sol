1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   /**
16   * @dev transfer token for a specified address
17   * @param _to The address to transfer to.
18   * @param _value The amount to be transferred.
19   */
20   function transfer(address _to, uint256 _value) public returns (bool) {
21     require(_to != address(0));
22     require(_value <= balances[msg.sender]);
23 
24     // SafeMath.sub will throw if there is not enough balance.
25     balances[msg.sender] = balances[msg.sender].sub(_value);
26     balances[_to] = balances[_to].add(_value);
27     Transfer(msg.sender, _to, _value);
28     return true;
29   }
30 
31   /**
32   * @dev Gets the balance of the specified address.
33   * @param _owner The address to query the the balance of.
34   * @return An uint256 representing the amount owned by the passed address.
35   */
36   function balanceOf(address _owner) public view returns (uint256 balance) {
37     return balances[_owner];
38   }
39 
40 }
41 
42 contract ERC20 is ERC20Basic {
43   function allowance(address owner, address spender) public view returns (uint256);
44   function transferFrom(address from, address to, uint256 value) public returns (bool);
45   function approve(address spender, uint256 value) public returns (bool);
46   event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 contract StandardToken is ERC20, BasicToken {
87 
88   mapping (address => mapping (address => uint256)) internal allowed;
89 
90 
91   /**
92    * @dev Transfer tokens from one address to another
93    * @param _from address The address which you want to send tokens from
94    * @param _to address The address which you want to transfer to
95    * @param _value uint256 the amount of tokens to be transferred
96    */
97   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[_from]);
100     require(_value <= allowed[_from][msg.sender]);
101 
102     balances[_from] = balances[_from].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105     Transfer(_from, _to, _value);
106     return true;
107   }
108 
109   /**
110    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
111    *
112    * Beware that changing an allowance with this method brings the risk that someone may use both the old
113    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
114    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
115    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116    * @param _spender The address which will spend the funds.
117    * @param _value The amount of tokens to be spent.
118    */
119   function approve(address _spender, uint256 _value) public returns (bool) {
120     allowed[msg.sender][_spender] = _value;
121     Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Function to check the amount of tokens that an owner allowed to a spender.
127    * @param _owner address The address which owns the funds.
128    * @param _spender address The address which will spend the funds.
129    * @return A uint256 specifying the amount of tokens still available for the spender.
130    */
131   function allowance(address _owner, address _spender) public view returns (uint256) {
132     return allowed[_owner][_spender];
133   }
134 
135   /**
136    * @dev Increase the amount of tokens that an owner allowed to a spender.
137    *
138    * approve should be called when allowed[_spender] == 0. To increment
139    * allowed value is better to use this function to avoid 2 calls (and wait until
140    * the first transaction is mined)
141    * From MonolithDAO Token.sol
142    * @param _spender The address which will spend the funds.
143    * @param _addedValue The amount of tokens to increase the allowance by.
144    */
145   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
146     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
147     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151   /**
152    * @dev Decrease the amount of tokens that an owner allowed to a spender.
153    *
154    * approve should be called when allowed[_spender] == 0. To decrement
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    * @param _spender The address which will spend the funds.
159    * @param _subtractedValue The amount of tokens to decrease the allowance by.
160    */
161   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
162     uint oldValue = allowed[msg.sender][_spender];
163     if (_subtractedValue > oldValue) {
164       allowed[msg.sender][_spender] = 0;
165     } else {
166       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172 }
173 
174 contract MintableToken is StandardToken, Ownable {
175   event Mint(address indexed to, uint256 amount);
176   event MintFinished();
177 
178   bool public mintingFinished = false;
179 
180 
181   modifier canMint() {
182     require(!mintingFinished);
183     _;
184   }
185 
186   /**
187    * @dev Function to mint tokens
188    * @param _to The address that will receive the minted tokens.
189    * @param _amount The amount of tokens to mint.
190    * @return A boolean that indicates if the operation was successful.
191    */
192   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
193     totalSupply = totalSupply.add(_amount);
194     balances[_to] = balances[_to].add(_amount);
195     Mint(_to, _amount);
196     Transfer(address(0), _to, _amount);
197     return true;
198   }
199 
200   /**
201    * @dev Function to stop minting new tokens.
202    * @return True if the operation was successful.
203    */
204   function finishMinting() onlyOwner canMint public returns (bool) {
205     mintingFinished = true;
206     MintFinished();
207     return true;
208   }
209 }
210 
211 /**
212  *
213  * @author Michael Arbach
214  *
215 **/
216 contract OrganicFreshCoin is MintableToken {
217 
218   string public name;
219   string public symbol;
220   uint8 public constant decimals = 18;
221 
222   uint256 public constant INITIAL_SUPPLY = 350000000 * (10 ** uint256(decimals));
223 
224   /**
225    * @dev Constructor that set name and symbol. 
226    */
227   function OrganicFreshCoin() public {
228 
229 
230     totalSupply = INITIAL_SUPPLY;
231     name        = "Organic Fresh Coin";
232     symbol      = "OFC";
233     balances[msg.sender] = INITIAL_SUPPLY;
234     Transfer(address(0x0), owner, INITIAL_SUPPLY);
235   }
236 
237 }
238 
239 library SafeMath {
240   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241     if (a == 0) {
242       return 0;
243     }
244     uint256 c = a * b;
245     assert(c / a == b);
246     return c;
247   }
248 
249   function div(uint256 a, uint256 b) internal pure returns (uint256) {
250     // assert(b > 0); // Solidity automatically throws when dividing by 0
251     uint256 c = a / b;
252     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
253     return c;
254   }
255 
256   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
257     assert(b <= a);
258     return a - b;
259   }
260 
261   function add(uint256 a, uint256 b) internal pure returns (uint256) {
262     uint256 c = a + b;
263     assert(c >= a);
264     return c;
265   }
266 }