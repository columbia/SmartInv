1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) constant returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances. 
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) returns (bool) {
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of. 
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) constant returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84   function allowance(address owner, address spender) constant returns (uint256);
85   function transferFrom(address from, address to, uint256 value) returns (bool);
86   function approve(address spender, uint256 value) returns (bool);
87   event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * @dev https://github.com/ethereum/EIPs/issues/20
95  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  */
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) allowed;
100 
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
109     var _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) returns (bool) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still avaible for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 }
149 
150 
151 // Migration Agent interface
152 contract MigrationAgent {
153     function migrateFrom(address _from, uint _value);
154 }
155 
156 contract GVToken is StandardToken {
157     
158     // Constants
159     string public constant name = "Genesis Vision Token";
160     string public constant symbol = "GVT";
161     uint   public constant decimals = 18;
162     uint   constant TOKEN_LIMIT = 44 * 1e6 * 1e18; 
163     
164     address public ico;
165 
166     // GVT transfers are blocked until ICO is finished.
167     bool public isFrozen = true;
168 
169     // Token migration variables
170     address public migrationMaster;
171     address public migrationAgent;
172     uint public totalMigrated;
173 
174     event Migrate(address indexed _from, address indexed _to, uint _value);
175 
176     // Constructor
177     function GVToken(address _ico, address _migrationMaster) {
178         require(_ico != 0);
179         require(_migrationMaster != 0);
180         ico = _ico;
181         migrationMaster = _migrationMaster;
182     }
183 
184     // Create tokens
185     function mint(address holder, uint value) {
186         require(msg.sender == ico);
187         require(value > 0);
188         require(totalSupply + value <= TOKEN_LIMIT);
189 
190         balances[holder] += value;
191         totalSupply += value;
192         Transfer(0x0, holder, value);
193     }
194 
195     // Allow token transfer.
196     function unfreeze() {
197         require(msg.sender == ico);
198         isFrozen = false;
199     }
200 
201     // ERC20 functions
202     // =========================
203 
204     function transfer(address _to, uint _value) public returns (bool) {
205         require(_to != address(0));
206         require(!isFrozen);
207         return super.transfer(_to, _value);
208     }
209 
210     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
211         require(!isFrozen);
212         return super.transferFrom(_from, _to, _value);
213     }
214 
215     function approve(address _spender, uint _value) public returns (bool) {
216         require(!isFrozen);
217         return super.approve(_spender, _value);
218     }
219 
220     // Token migration
221     function migrate(uint value) external {
222         require(migrationAgent != 0);
223         require(value > 0);
224         require(value <= balances[msg.sender]);
225 
226         balances[msg.sender] -= value;
227         totalSupply -= value;
228         totalMigrated += value;
229         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
230         Migrate(msg.sender, migrationAgent, value);
231     }
232 
233     // Set address of migration contract
234     function setMigrationAgent(address _agent) external {
235         require(migrationAgent == 0);
236         require(msg.sender == migrationMaster);
237         migrationAgent = _agent;
238     }
239 
240     function setMigrationMaster(address _master) external {
241         require(msg.sender == migrationMaster);
242         require(_master != 0);
243         migrationMaster = _master;
244     }
245 }