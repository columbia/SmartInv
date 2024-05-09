1 pragma solidity ^0.4.13;
2 
3 interface MigrationAgent {
4     function migrateFrom(address _from, uint256 _value);
5 }
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   uint256 public totalSupply;
14   function balanceOf(address who) constant returns (uint256);
15   function transfer(address to, uint256 value) returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) constant returns (uint256);
25   function transferFrom(address from, address to, uint256 value) returns (bool);
26   function approve(address spender, uint256 value) returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35     
36   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a * b;
38     assert(a == 0 || c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal constant returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal constant returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59   
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances. 
65  */
66 contract BasicToken is ERC20Basic {
67     
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) returns (bool) {
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of. 
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) constant returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) allowed;
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amout of tokens to be transfered
111    */
112   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
113     var _allowance = allowed[_from][msg.sender];
114 
115     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116     // require (_value <= _allowance);
117 
118     balances[_to] = balances[_to].add(_value);
119     balances[_from] = balances[_from].sub(_value);
120     allowed[_from][msg.sender] = _allowance.sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint256 _value) returns (bool) {
131 
132     // To change the approve amount you first have to reduce the addresses`
133     //  allowance to zero by calling `approve(_spender, 0)` if it is not
134     //  already 0 to mitigate the race condition described here:
135     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
137 
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifing the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152 
153 }
154 
155 /**
156  * @title Ownable
157  * @dev The Ownable contract has an owner address, and provides basic authorization control
158  * functions, this simplifies the implementation of "user permissions".
159  */
160 contract Ownable {
161     
162   address public owner;
163 
164   /**
165    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
166    * account.
167    */
168   function Ownable() {
169     owner = msg.sender;
170   }
171 
172   /**
173    * @dev Throws if called by any account other than the owner.
174    */
175   modifier onlyOwner() {
176     require(msg.sender == owner);
177     _;
178   }
179 
180   /**
181    * @dev Allows the current owner to transfer control of the contract to a newOwner.
182    * @param newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address newOwner) onlyOwner {
185     require(newOwner != address(0));      
186     owner = newOwner;
187   }
188 
189 }
190 
191 /**
192  * @title Mintable token
193  * @dev Simple ERC20 Token example, with mintable token creation
194  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
195  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
196  */
197 
198 contract MintableToken is StandardToken, Ownable {
199     
200   event Mint(address indexed to, uint256 amount);
201   
202   event MintFinished();
203 
204   bool public mintingFinished = false;
205 
206   modifier canMint() {
207     require(!mintingFinished);
208     _;
209   }
210 
211   /**
212    * @dev Function to mint tokens
213    * @param _to The address that will recieve the minted tokens.
214    * @param _amount The amount of tokens to mint.
215    * @return A boolean that indicates if the operation was successful.
216    */
217   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
218     totalSupply = totalSupply.add(_amount);
219     balances[_to] = balances[_to].add(_amount);
220     Mint(_to, _amount);
221     return true;
222   }
223 
224   /**
225    * @dev Function to stop minting new tokens.
226    * @return True if the operation was successful.
227    */
228   function finishMinting() onlyOwner returns (bool) {
229     mintingFinished = true;
230     MintFinished();
231     return true;
232   }
233   
234 }
235 
236 contract TokenMigration is MintableToken {
237     address public migrationAgent;
238 
239     // Migrate tokens to the new token contract
240     function migrate() external {
241         require(migrationAgent != 0);
242         uint value = balances[msg.sender];
243         balances[msg.sender] -= value;
244         totalSupply -= value;
245         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
246     }
247 
248     function setMigrationAgent(address _agent) onlyOwner external {
249         require(migrationAgent == 0);
250         migrationAgent = _agent;
251     }
252     
253     function migrateFrom(address _to) onlyOwner external {
254         require(migrationAgent != 0);
255         uint value = balances[_to];
256         balances[_to] -= value;
257         totalSupply -= value;
258         MigrationAgent(migrationAgent).migrateFrom(_to, value);
259     }
260 }
261 
262 contract PreICOCryptoMindToken is TokenMigration {
263     
264     string public constant name = "CryptoMind PreICO";
265     
266     string public constant symbol = "CTMP";
267     
268     uint32 public constant decimals = 18;
269  
270 
271 }