1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner {
56     if (newOwner != address(0)) {
57       owner = newOwner;
58     }
59   }
60 
61 }
62 
63 contract HasNoEther is Ownable {
64 
65   /**
66   * @dev Constructor that rejects incoming Ether
67   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
68   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
69   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
70   * we could use assembly to access msg.value.
71   */
72   function HasNoEther() payable {
73     require(msg.value == 0);
74   }
75 
76   /**
77    * @dev Disallows direct send by settings a default function without the `payable` flag.
78    */
79   function() external {
80   }
81 
82   /**
83    * @dev Transfer all Ether held by the contract to the owner.
84    */
85   function reclaimEther() external onlyOwner {
86     assert(owner.send(this.balance));
87   }
88 }
89 
90 contract HasNoTokens is Ownable {
91 
92  /**
93   * @dev Reject all ERC23 compatible tokens
94   * @param from_ address The address that is transferring the tokens
95   * @param value_ uint256 the amount of the specified token
96   * @param data_ Bytes The data passed from the caller.
97   */
98   function tokenFallback(address from_, uint256 value_, bytes data_) external {
99     revert();
100   }
101 
102   /**
103    * @dev Reclaim all ERC20Basic compatible tokens
104    * @param tokenAddr address The address of the token contract
105    */
106   function reclaimToken(address tokenAddr) external onlyOwner {
107     ERC20Basic tokenInst = ERC20Basic(tokenAddr);
108     uint256 balance = tokenInst.balanceOf(this);
109     tokenInst.transfer(owner, balance);
110   }
111 }
112 
113 contract ERC20Basic {
114   uint256 public totalSupply;
115   function balanceOf(address who) constant returns (uint256);
116   function transfer(address to, uint256 value) returns (bool);
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 contract BasicToken is ERC20Basic {
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124 
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value) returns (bool) {
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of. 
140   * @return An uint256 representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) constant returns (uint256 balance) {
143     return balances[_owner];
144   }
145 
146 }
147 
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) constant returns (uint256);
150   function transferFrom(address from, address to, uint256 value) returns (bool);
151   function approve(address spender, uint256 value) returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amout of tokens to be transfered
165    */
166   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
167     var _allowance = allowed[_from][msg.sender];
168 
169     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
170     // require (_value <= _allowance);
171 
172     balances[_to] = balances[_to].add(_value);
173     balances[_from] = balances[_from].sub(_value);
174     allowed[_from][msg.sender] = _allowance.sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) returns (bool) {
185 
186     // To change the approve amount you first have to reduce the addresses`
187     //  allowance to zero by calling `approve(_spender, 0)` if it is not
188     //  already 0 to mitigate the race condition described here:
189     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
191 
192     allowed[msg.sender][_spender] = _value;
193     Approval(msg.sender, _spender, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifing the amount of tokens still avaible for the spender.
202    */
203   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
204     return allowed[_owner][_spender];
205   }
206 
207 }
208 
209 contract BurnableToken is StandardToken {
210 
211 	event Burn(address indexed burner, uint256 value);
212 
213 	/**
214 	 * @dev Burns a specific amount of tokens.
215 	 * @param _value The amount of token to be burned.
216 	 */
217 	function burn(uint256 _value) public {
218 		require(_value > 0);
219 		require(_value <= balances[msg.sender]);
220 		// no need to require value <= totalSupply, since that would imply the
221 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
222 
223 		address burner = msg.sender;
224 		balances[burner] = balances[burner].sub(_value);
225 		totalSupply = totalSupply.sub(_value);
226 		Burn(burner, _value);
227 	}
228 }
229 
230 contract MintableToken is StandardToken, Ownable {
231   event Mint(address indexed to, uint256 amount);
232   event MintFinished();
233 
234   bool public mintingFinished = false;
235 
236 
237   modifier canMint() {
238     require(!mintingFinished);
239     _;
240   }
241 
242   /**
243    * @dev Function to mint tokens
244    * @param _to The address that will recieve the minted tokens.
245    * @param _amount The amount of tokens to mint.
246    * @return A boolean that indicates if the operation was successful.
247    */
248   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
249     totalSupply = totalSupply.add(_amount);
250     balances[_to] = balances[_to].add(_amount);
251     Mint(_to, _amount);
252     return true;
253   }
254 
255   /**
256    * @dev Function to stop minting new tokens.
257    * @return True if the operation was successful.
258    */
259   function finishMinting() onlyOwner returns (bool) {
260     mintingFinished = true;
261     MintFinished();
262     return true;
263   }
264 }
265 
266 contract onG is MintableToken, BurnableToken, HasNoEther, HasNoTokens {
267 
268 	string public name = "onG";
269 	string public symbol = "ONG";
270 	uint256 public decimals = 18;
271 
272 }