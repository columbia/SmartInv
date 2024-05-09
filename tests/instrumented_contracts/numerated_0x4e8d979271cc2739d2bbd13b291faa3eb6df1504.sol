1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     if (msg.sender != owner) {
26       throw;
27     }
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     if (newOwner != address(0)) {
38       owner = newOwner;
39     }
40   }
41 
42 }
43 
44 
45 /**
46  * @title Claimable
47  * @dev Extension for the Ownable contract, where the ownership needs to be claimed. 
48  * This allows the new owner to accept the transfer.
49  */
50 contract Claimable is Ownable {
51   address public pendingOwner;
52 
53   /**
54    * @dev Modifier throws if called by any account other than the pendingOwner. 
55    */
56   modifier onlyPendingOwner() {
57     if (msg.sender != pendingOwner) {
58       throw;
59     }
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to set the pendingOwner address. 
65    * @param newOwner The address to transfer ownership to. 
66    */
67   function transferOwnership(address newOwner) onlyOwner {
68     pendingOwner = newOwner;
69   }
70 
71   /**
72    * @dev Allows the pendingOwner address to finalize the transfer.
73    */
74   function claimOwnership() onlyPendingOwner {
75     owner = pendingOwner;
76     pendingOwner = 0x0;
77   }
78 }
79 
80 /**
81  * @title ERC20Basic
82  * @dev Simpler version of ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20Basic {
86   uint256 public totalSupply;
87   function balanceOf(address who) constant returns (uint256);
88   function transfer(address to, uint256 value);
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 /**
92  * @title SafeMath
93  * @dev Math operations with safety checks that throw on error
94  */
95 library SafeMath {
96   function mul(uint256 a, uint256 b) internal returns (uint256) {
97     uint256 c = a * b;
98     assert(a == 0 || c / a == b);
99     return c;
100   }
101 
102   function div(uint256 a, uint256 b) internal returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return c;
107   }
108 
109   function sub(uint256 a, uint256 b) internal returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   function add(uint256 a, uint256 b) internal returns (uint256) {
115     uint256 c = a + b;
116     assert(c >= a);
117     return c;
118   }
119 }
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances. 
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) {
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     Transfer(msg.sender, _to, _value);
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param _owner The address to query the the balance of. 
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address _owner) constant returns (uint256 balance) {
147     return balances[_owner];
148   }
149 }
150 
151 
152 /**
153  * @title ERC20 interface
154  * @dev see https://github.com/ethereum/EIPs/issues/20
155  */
156 contract ERC20 is ERC20Basic {
157   function allowance(address owner, address spender) constant returns (uint256);
158   function transferFrom(address from, address to, uint256 value);
159   function approve(address spender, uint256 value);
160   event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162 
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amout of tokens to be transfered
181    */
182   function transferFrom(address _from, address _to, uint256 _value) {
183     var _allowance = allowed[_from][msg.sender];
184 
185     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
186     // if (_value > _allowance) throw;
187 
188     balances[_to] = balances[_to].add(_value);
189     balances[_from] = balances[_from].sub(_value);
190     allowed[_from][msg.sender] = _allowance.sub(_value);
191     Transfer(_from, _to, _value);
192   }
193 
194   /**
195    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    * @param _spender The address which will spend the funds.
197    * @param _value The amount of tokens to be spent.
198    */
199   function approve(address _spender, uint256 _value) {
200 
201     // To change the approve amount you first have to reduce the addresses`
202     //  allowance to zero by calling `approve(_spender, 0)` if it is not
203     //  already 0 to mitigate the race condition described here:
204     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
206 
207     allowed[msg.sender][_spender] = _value;
208     Approval(msg.sender, _spender, _value);
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifing the amount of tokens still avaible for the spender.
216    */
217   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
218     return allowed[_owner][_spender];
219   }
220 
221 }
222 
223 contract ControlledSupplyToken is Claimable, StandardToken {
224     using SafeMath for uint256;
225 
226     address public minter;
227 
228     event Burn(uint amount);
229     event Mint(uint amount);
230 
231     modifier onlyMinter() {
232         if (msg.sender != minter) throw;
233         _;
234     }
235 
236     function ControlledSupplyToken(
237         uint256 initialSupply
238     ) {
239         totalSupply = initialSupply;
240         balances[msg.sender] = initialSupply;
241     }
242 
243     function changeMinter(address _minter) onlyOwner {
244         minter = _minter;
245     }
246 
247     function mintTokens(address target, uint256 mintedAmount) onlyMinter {
248         if (mintedAmount > 0) {
249             balances[target] = balances[target].add(mintedAmount);
250             totalSupply = totalSupply.add(mintedAmount);
251             Mint(mintedAmount);
252             Transfer(0, target, mintedAmount);
253         }
254     }
255 
256     function burnTokens(uint256 burnedAmount) onlyMinter {
257         if (burnedAmount > balances[msg.sender]) throw;
258         if (burnedAmount == 0) throw;
259         balances[msg.sender] = balances[msg.sender].sub(burnedAmount);
260         totalSupply = totalSupply.sub(burnedAmount);
261         Transfer(msg.sender, 0, burnedAmount);
262         Burn(burnedAmount);
263     }
264 }
265 
266 contract NokuToken is ControlledSupplyToken {
267   string public name;
268   string public symbol;
269   uint256 public decimals;
270 
271   function NokuToken(
272     uint256 _initialSupply,
273     string _tokenName,
274     uint8 _decimalUnits,
275     string _tokenSymbol
276   ) ControlledSupplyToken(_initialSupply) {
277     name = _tokenName;
278     symbol = _tokenSymbol;
279     decimals = _decimalUnits;
280   }
281 }