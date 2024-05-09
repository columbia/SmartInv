1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44   uint256 public totalSupply;
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67     require(_value <= balances[msg.sender]);
68 
69     // SafeMath.sub will throw if there is not enough balance.
70     balances[msg.sender] = balances[msg.sender].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     Transfer(msg.sender, _to, _value);
73     return true;
74   }
75 
76   /**
77   * @dev Gets the balance of the specified address.
78   * @param _owner The address to query the the balance of.
79   * @return An uint256 representing the amount owned by the passed address.
80   */
81   function balanceOf(address _owner) public view returns (uint256 balance) {
82     return balances[_owner];
83   }
84 
85 }
86 
87 
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender) public view returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * @dev https://github.com/ethereum/EIPs/issues/20
107  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20, BasicToken {
110 
111   mapping (address => mapping (address => uint256)) internal allowed;
112 
113 
114   /**
115    * @dev Transfer tokens from one address to another
116    * @param _from address The address which you want to send tokens from
117    * @param _to address The address which you want to transfer to
118    * @param _value uint256 the amount of tokens to be transferred
119    */
120   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121     require(_to != address(0));
122     require(_value <= balances[_from]);
123     require(_value <= allowed[_from][msg.sender]);
124 
125     balances[_from] = balances[_from].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128     Transfer(_from, _to, _value);
129     return true;
130   }
131 
132   /**
133    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134    *
135    * Beware that changing an allowance with this method brings the risk that someone may use both the old
136    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
137    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
138    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139    * @param _spender The address which will spend the funds.
140    * @param _value The amount of tokens to be spent.
141    */
142   function approve(address _spender, uint256 _value) public returns (bool) {
143     allowed[msg.sender][_spender] = _value;
144     Approval(msg.sender, _spender, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifying the amount of tokens still available for the spender.
153    */
154   function allowance(address _owner, address _spender) public view returns (uint256) {
155     return allowed[_owner][_spender];
156   }
157 
158   /**
159    * approve should be called when allowed[_spender] == 0. To increment
160    * allowed value is better to use this function to avoid 2 calls (and wait until
161    * the first transaction is mined)
162    * From MonolithDAO Token.sol
163    */
164   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
165     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
166     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
171     uint oldValue = allowed[msg.sender][_spender];
172     if (_subtractedValue > oldValue) {
173       allowed[msg.sender][_spender] = 0;
174     } else {
175       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
176     }
177     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181 }
182 
183 
184 // Migration Agent interface
185 contract MigrationAgent {
186   function migrateFrom(address _from, uint _value) public;
187 }
188 
189 /**
190  * @title Spade Token
191  */
192 contract SPXToken is StandardToken {
193 
194   string public constant name = "SP8DE Token";
195   string public constant symbol = "SPX";
196   uint8 public constant decimals = 18;
197   address public ico;
198   
199   bool public isFrozen = true;  
200   uint public constant TOKEN_LIMIT = 8888888888 * (1e18);
201 
202   // Token migration variables
203   address public migrationMaster;
204   address public migrationAgent;
205   uint public totalMigrated;
206 
207   event Migrate(address indexed _from, address indexed _to, uint _value);
208   
209   // Constructor
210   function SPXToken(address _ico, address _migrationMaster) public {
211     require(_ico != 0);
212     ico = _ico;
213     migrationMaster = _migrationMaster;
214   }
215 
216   // Create tokens
217   function mint(address holder, uint value) public {
218     require(msg.sender == ico);
219     require(value > 0);
220     require(totalSupply + value <= TOKEN_LIMIT);
221 
222     balances[holder] += value;
223     totalSupply += value;
224     Transfer(0x0, holder, value);
225   }
226 
227   // Allow token transfer.
228   function unfreeze() public {
229       require(msg.sender == ico);
230       isFrozen = false;
231   }
232 
233   // ERC20 functions
234   // =========================
235   function transfer(address _to, uint _value) public returns (bool) {
236     require(_to != address(0));
237     require(!isFrozen);
238     return super.transfer(_to, _value);
239   }
240 
241   function transferFrom(address _from, address _to, uint _value) public returns (bool) {
242     require(!isFrozen);
243     return super.transferFrom(_from, _to, _value);
244   }
245 
246   function approve(address _spender, uint _value) public returns (bool) {
247     require(!isFrozen);
248     return super.approve(_spender, _value);
249   }
250 
251   // Token migration
252   function migrate(uint value) external {
253     require(migrationAgent != 0);
254     require(value > 0);
255     require(value <= balances[msg.sender]);
256 
257     balances[msg.sender] -= value;
258     totalSupply -= value;
259     totalMigrated += value;
260     MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
261     Migrate(msg.sender, migrationAgent, value);
262   }
263 
264   // Set address of migration contract
265   function setMigrationAgent(address _agent) external {
266     require(migrationAgent == 0);
267     require(msg.sender == migrationMaster);
268     migrationAgent = _agent;
269   }
270 
271   function setMigrationMaster(address _master) external {
272     require(msg.sender == migrationMaster);
273     require(_master != 0);
274     migrationMaster = _master;
275   }
276 }