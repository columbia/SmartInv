1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions"
31  */
32 contract Ownable {
33   address public owner;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner
55    * @param newOwner The address to transfer ownership to
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 }
63 
64 /*
65  * @title Migration Agent interface
66  */
67 contract MigrationAgent {
68   function migrateFrom(address _from, uint256 _value);
69 }
70 
71 contract ERC20 {
72     function totalSupply() constant returns (uint256);
73     function balanceOf(address who) constant returns (uint256);
74     function transfer(address to, uint256 value);
75     function transferFrom(address from, address to, uint256 value);
76     function approve(address spender, uint256 value);
77     function allowance(address owner, address spender) constant returns (uint256);
78 
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 contract Paypite is Ownable, ERC20 {
84   using SafeMath for uint256;
85 
86   uint8 private _decimals = 18;
87   uint256 private decimalMultiplier = 10**(uint256(_decimals));
88 
89   string private _name = "Paypite v2";
90   string private _symbol = "PIT";
91   uint256 private _totalSupply = 274000000 * decimalMultiplier;
92 
93   bool public tradable = true;
94 
95   // Wallet Address of Token
96   address public multisig;
97 
98   // Function to access name of token
99   function name() constant returns (string) {
100     return _name;
101   }
102 
103   // Function to access symbol of token
104   function symbol() constant returns (string) {
105     return _symbol;
106   }
107 
108   // Function to access decimals of token
109   function decimals() constant returns (uint8) {
110     return _decimals;
111   }
112 
113   // Function to access total supply of tokens
114   function totalSupply() constant returns (uint256) {
115     return _totalSupply;
116   }
117 
118   mapping(address => uint256) balances;
119   mapping(address => mapping (address => uint256)) allowed;
120   mapping(address => uint256) releaseTimes;
121   address public migrationAgent;
122   uint256 public totalMigrated;
123 
124   event Migrate(address indexed _from, address indexed _to, uint256 _value);
125 
126   // Constructor
127   // @notice Paypite Contract
128   // @return the transaction address
129   function Paypite(address _multisig) {
130     require(_multisig != 0x0);
131     multisig = _multisig;
132     balances[multisig] = _totalSupply;
133   }
134 
135   modifier canTrade() {
136     require(tradable);
137     _;
138   }
139 
140   // Standard function transfer similar to ERC20 transfer with no _data
141   // Added due to backwards compatibility reasons
142   function transfer(address to, uint256 value) canTrade {
143     require(!isLocked(msg.sender));
144     require (balances[msg.sender] >= value && value > 0);
145     balances[msg.sender] = balances[msg.sender].sub(value);
146     balances[to] = balances[to].add(value);
147     Transfer(msg.sender, to, value);
148   }
149 
150   /**
151    * @dev Gets the balance of the specified address
152    * @param who The address to query the the balance of
153    * @return An uint256 representing the amount owned by the passed address
154    */
155   function balanceOf(address who) constant returns (uint256) {
156     return balances[who];
157   }
158 
159  /**
160   * @dev Transfer tokens from one address to another
161   * @param from address The address which you want to send tokens from
162   * @param to address The address which you want to transfer to
163   * @param value uint256 the amount of tokens to be transfered
164   */
165   function transferFrom(address from, address to, uint256 value) canTrade {
166     require(to != 0x0);
167     require(!isLocked(from));
168     uint256 _allowance = allowed[from][msg.sender];
169     require(value > 0 && _allowance >= value);
170     balances[from] = balances[from].sub(value);
171     balances[to] = balances[to].add(value);
172     allowed[from][msg.sender] = _allowance.sub(value);
173     Transfer(from, to, value);
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
178    * @param spender The address which will spend the funds
179    * @param value The amount of tokens to be spent
180    */
181   function approve(address spender, uint256 value) canTrade {
182     require((value >= 0) && (allowed[msg.sender][spender] >= 0));
183     allowed[msg.sender][spender] = value;
184     Approval(msg.sender, spender, value);
185   }
186 
187   // Check the allowed value for the spender to withdraw from owner
188   // @param owner The address of the owner
189   // @param spender The address of the spender
190   // @return the amount which spender is still allowed to withdraw from owner
191   function allowance(address owner, address spender) constant returns (uint256) {
192     return allowed[owner][spender];
193   }
194 
195   /**
196    * @dev Function to update tradable status
197    * @param _newTradableState New tradable state
198    * @return A boolean that indicates if the operation was successful
199    */
200   function setTradable(bool _newTradableState) onlyOwner public {
201     tradable = _newTradableState;
202   }
203 
204   /**
205    * Function to lock a given address until the specified date
206    * @param spender Address to lock
207    * @param date A timestamp specifying when the account will be unlocked
208    * @return A boolean that indicates if the operation was successful
209    */
210   function timeLock(address spender, uint256 date) public onlyOwner returns (bool) {
211     releaseTimes[spender] = date;
212     return true;
213   }
214 
215   /**
216    * Function to check if a given address is locked or not
217    * @param _spender Address
218    * @return A boolean that indicates if the account is locked or not
219    */
220   function isLocked(address _spender) public view returns (bool) {
221     if (releaseTimes[_spender] == 0 || releaseTimes[_spender] <= block.timestamp) {
222       return false;
223     }
224     return true;
225   }
226 
227   /**
228    * @notice Set address of migration target contract and enable migration process
229    * @dev Required state: Operational Normal
230    * @dev State transition: -> Operational Migration
231    * @param _agent The address of the MigrationAgent contract
232    */
233   function setMigrationAgent(address _agent) external onlyOwner {
234     require(migrationAgent == 0x0 && totalMigrated == 0);
235     migrationAgent = _agent;
236   }
237 
238   /*
239    * @notice Migrate tokens to the new token contract.
240    * @dev Required state: Operational Migration
241    * @param _value The amount of token to be migrated
242    */
243   function migrate(uint256 value) external {
244     require(migrationAgent != 0x0);
245     require(value >= 0);
246     require(value <= balances[msg.sender]);
247 
248     balances[msg.sender] -= value;
249     _totalSupply = _totalSupply.sub(value);
250     totalMigrated = totalMigrated.add(value);
251     MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
252     Migrate(msg.sender, migrationAgent, value);
253   }
254 }