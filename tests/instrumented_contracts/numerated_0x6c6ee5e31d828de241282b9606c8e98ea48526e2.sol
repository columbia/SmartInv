1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a + b;
73     assert(c >= a);
74     return c;
75   }
76 }
77 
78 // This is an ERC-20 token contract based on Open Zepplin's StandardToken
79 // and MintableToken plus the ability to burn tokens.
80 //
81 // We had to copy over the code instead of inheriting because of changes
82 // to the modifier lists of some functions:
83 //   * transfer(), transferFrom() and approve() are not callable during
84 //     the minting period, only after MintingFinished()
85 //   * mint() can only be called by the minter who is not the owner
86 //     but the HoloTokenSale contract.
87 //
88 // Token can be burned by a special 'destroyer' role that can only
89 // burn its tokens.
90 contract HoloToken is Ownable {
91   string public constant name = "HoloToken";
92   string public constant symbol = "HOT";
93   uint8 public constant decimals = 18;
94 
95   event Transfer(address indexed from, address indexed to, uint256 value);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97   event Mint(address indexed to, uint256 amount);
98   event MintingFinished();
99   event Burn(uint256 amount);
100 
101   uint256 public totalSupply;
102 
103 
104   //==================================================================================
105   // Zeppelin BasicToken (plus modifier to not allow transfers during minting period):
106   //==================================================================================
107 
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) public balances;
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public whenMintingFinished returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120 
121     // SafeMath.sub will throw if there is not enough balance.
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137 
138   //=====================================================================================
139   // Zeppelin StandardToken (plus modifier to not allow transfers during minting period):
140   //=====================================================================================
141   mapping (address => mapping (address => uint256)) public allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amout of tokens to be transfered
149    */
150   function transferFrom(address _from, address _to, uint256 _value) public whenMintingFinished returns (bool) {
151     require(_to != address(0));
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158     Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    *
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public whenMintingFinished returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(address _owner, address _spender) public view returns (uint256) {
185     return allowed[_owner][_spender];
186   }
187 
188   /**
189    * approve should be called when allowed[_spender] == 0. To increment
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201     uint oldValue = allowed[msg.sender][_spender];
202     if (_subtractedValue > oldValue) {
203       allowed[msg.sender][_spender] = 0;
204     } else {
205       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206     }
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211 
212   //=====================================================================================
213   // Minting:
214   //=====================================================================================
215 
216   bool public mintingFinished = false;
217   address public destroyer;
218   address public minter;
219 
220   modifier canMint() {
221     require(!mintingFinished);
222     _;
223   }
224 
225   modifier whenMintingFinished() {
226     require(mintingFinished);
227     _;
228   }
229 
230   modifier onlyMinter() {
231     require(msg.sender == minter);
232     _;
233   }
234 
235   function setMinter(address _minter) external onlyOwner {
236     minter = _minter;
237   }
238 
239   function mint(address _to, uint256 _amount) external onlyMinter canMint  returns (bool) {
240     require(balances[_to] + _amount > balances[_to]); // Guard against overflow
241     require(totalSupply + _amount > totalSupply);     // Guard against overflow  (this should never happen)
242     totalSupply = totalSupply.add(_amount);
243     balances[_to] = balances[_to].add(_amount);
244     Mint(_to, _amount);
245     return true;
246   }
247 
248   function finishMinting() external onlyMinter returns (bool) {
249     mintingFinished = true;
250     MintingFinished();
251     return true;
252   }
253 
254 
255   //=====================================================================================
256   // Burning:
257   //=====================================================================================
258 
259 
260   modifier onlyDestroyer() {
261      require(msg.sender == destroyer);
262      _;
263   }
264 
265   function setDestroyer(address _destroyer) external onlyOwner {
266     destroyer = _destroyer;
267   }
268 
269   function burn(uint256 _amount) external onlyDestroyer {
270     require(balances[destroyer] >= _amount && _amount > 0);
271     balances[destroyer] = balances[destroyer].sub(_amount);
272     totalSupply = totalSupply.sub(_amount);
273     Burn(_amount);
274   }
275 }