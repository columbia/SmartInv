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
81 // Token can be burned by a special 'destroyer' role that can only
82 // burn its tokens.
83 contract ArcticCoreToken is Ownable {
84   string public constant name = "ArcticCoreToken";
85   string public constant symbol = "ARC1";
86   uint8 public constant decimals = 18;
87 
88   event Transfer(address indexed from, address indexed to, uint256 value);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90   event Mint(address indexed to, uint256 amount);
91   event MintingFinished();
92   event Burn(uint256 amount);
93 
94   uint256 public totalSupply;
95 
96 
97   //==================================================================================
98   // Zeppelin BasicToken (plus modifier to not allow transfers during minting period):
99   //==================================================================================
100 
101   using SafeMath for uint256;
102 
103   mapping(address => uint256) public balances;
104 
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint256 _value) public whenMintingFinished returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[msg.sender]);
113 
114     // SafeMath.sub will throw if there is not enough balance.
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) public view returns (uint256 balance) {
127     return balances[_owner];
128   }
129 
130 
131   //=====================================================================================
132   // Zeppelin StandardToken (plus modifier to not allow transfers during minting period):
133   //=====================================================================================
134   mapping (address => mapping (address => uint256)) public allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amout of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public whenMintingFinished returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147 
148     balances[_from] = balances[_from].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151     Transfer(_from, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public whenMintingFinished returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(address _owner, address _spender) public view returns (uint256) {
178     return allowed[_owner][_spender];
179   }
180 
181   /**
182    * approve should be called when allowed[_spender] == 0. To increment
183    * allowed value is better to use this function to avoid 2 calls (and wait until
184    * the first transaction is mined)
185    * From MonolithDAO Token.sol
186    */
187   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
194     uint oldValue = allowed[msg.sender][_spender];
195     if (_subtractedValue > oldValue) {
196       allowed[msg.sender][_spender] = 0;
197     } else {
198       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199     }
200     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204 
205   //=====================================================================================
206   // Minting:
207   //=====================================================================================
208 
209   bool public mintingFinished = false;
210   address public destroyer;
211   address public minter;
212 
213   modifier canMint() {
214     require(!mintingFinished);
215     _;
216   }
217 
218   modifier whenMintingFinished() {
219     require(mintingFinished);
220     _;
221   }
222 
223   modifier onlyMinter() {
224     require(msg.sender == minter);
225     _;
226   }
227 
228   function setMinter(address _minter) external onlyOwner {
229     minter = _minter;
230   }
231 
232   function mint(address _to, uint256 _amount) external onlyMinter canMint  returns (bool) {
233     require(balances[_to] + _amount > balances[_to]); // Guard against overflow
234     require(totalSupply + _amount > totalSupply);     // Guard against overflow  (this should never happen)
235     totalSupply = totalSupply.add(_amount);
236     balances[_to] = balances[_to].add(_amount);
237     Mint(_to, _amount);
238     return true;
239   }
240 
241   function finishMinting() external onlyMinter returns (bool) {
242     mintingFinished = true;
243     MintingFinished();
244     return true;
245   }
246 
247 
248   //=====================================================================================
249   // Burning:
250   //=====================================================================================
251 
252 
253   modifier onlyDestroyer() {
254      require(msg.sender == destroyer);
255      _;
256   }
257 
258   function setDestroyer(address _destroyer) external onlyOwner {
259     destroyer = _destroyer;
260   }
261 
262   function burn(uint256 _amount) external onlyDestroyer {
263     require(balances[destroyer] >= _amount && _amount > 0);
264     balances[destroyer] = balances[destroyer].sub(_amount);
265     totalSupply = totalSupply.sub(_amount);
266     Burn(_amount);
267   }
268 }