1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7 
8   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b > 0);
16     uint256 c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a && c >= b);
29     return c;
30   }
31 
32 }
33 
34 /**
35  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
36  *
37  * Based on code by FirstBlood:
38  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
39  */
40 contract StandardToken is SafeMath {
41 
42   uint256 public totalSupply;
43 
44   /* Actual balances of token holders */
45   mapping(address => uint) balances;
46 
47   /* approve() allowances */
48   mapping (address => mapping (address => uint)) allowed;
49   event Transfer(address indexed from, address indexed to, uint256 value);
50   event Approval(address indexed owner, address indexed spender, uint256 value);
51   /**
52    *
53    * Fix for the ERC20 short address attack
54    *
55    * http://vessenes.com/the-erc20-short-address-attack-explained/
56    */
57   modifier onlyPayloadSize(uint256 size) {
58      require(msg.data.length == size + 4);
59      _;
60   }
61 
62   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool success) {
63     require(_to != 0);
64     uint256 balanceFrom = balances[msg.sender];
65     require(_value <= balanceFrom);
66 
67     // SafeMath safeSub will throw if there is not enough balance.
68     balances[msg.sender] = safeSub(balanceFrom, _value);
69     balances[_to] = safeAdd(balances[_to], _value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75     require(_to != 0);
76     uint256 allowToTrans = allowed[_from][msg.sender];
77     uint256 balanceFrom = balances[_from];
78     require(_value <= balanceFrom);
79     require(_value <= allowToTrans);
80 
81     balances[_to] = safeAdd(balances[_to], _value);
82     balances[_from] = safeSub(balanceFrom, _value);
83     allowed[_from][msg.sender] = safeSub(allowToTrans, _value);
84     Transfer(_from, _to, _value);
85     return true;
86   }
87 
88   function balanceOf(address _owner) public view returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92   function approve(address _spender, uint256 _value) public returns (bool success) {
93 
94     // To change the approve amount you first have to reduce the addresses`
95     //  allowance to zero by calling `approve(_spender, 0)` if it is not
96     //  already 0 to mitigate the race condition described here:
97     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98 //    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
99     // require((_value == 0) || (allowed[msg.sender][_spender] == 0));
100 
101     allowed[msg.sender][_spender] = _value;
102     Approval(msg.sender, _spender, _value);
103     return true;
104   }
105 
106   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
107     return allowed[_owner][_spender];
108   }
109 
110   /**
111    * Atomic increment of approved spending
112    *
113    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114    *
115    */
116   function addApproval(address _spender, uint256 _addedValue)
117   onlyPayloadSize(2 * 32)
118   public returns (bool success) {
119       uint256 oldValue = allowed[msg.sender][_spender];
120       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
121       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122       return true;
123   }
124 
125   /**
126    * Atomic decrement of approved spending.
127    *
128    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    */
130   function subApproval(address _spender, uint256 _subtractedValue)
131   onlyPayloadSize(2 * 32)
132   public returns (bool success) {
133 
134       uint256 oldVal = allowed[msg.sender][_spender];
135 
136       if (_subtractedValue > oldVal) {
137           allowed[msg.sender][_spender] = 0;
138       } else {
139           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
140       }
141       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142       return true;
143   }
144 
145 }
146 
147 /**
148  * @title Ownable
149  * @dev The Ownable contract has an owner address, and provides basic authorization control
150  * functions, this simplifies the implementation of "user permissions".
151  */
152 contract Ownable {
153   address public owner;
154 
155   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157   /**
158    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
159    * account.
160    */
161   function Ownable() public {
162     owner = msg.sender;
163   }
164 
165   /**
166    * @dev Throws if called by any account other than the owner.
167    */
168   modifier onlyOwner() {
169     require(msg.sender == owner);
170     _;
171   }
172 
173   /**
174    * @dev Allows the current owner to transfer control of the contract to a newOwner.
175    * @param newOwner The address to transfer ownership to.
176    */
177   function transferOwnership(address newOwner) onlyOwner public {
178     require(newOwner != address(0));
179     OwnershipTransferred(owner, newOwner);
180     owner = newOwner;
181   }
182 
183 }
184 
185 contract MigrationAgent {
186   function migrateFrom(address _from, uint256 _value) public;
187 }
188 
189 contract UpgradeableToken is Ownable, StandardToken {
190   address public migrationAgent;
191 
192   /**
193    * Somebody has upgraded some of his tokens.
194    */
195   event Upgrade(address indexed from, address indexed to, uint256 value);
196 
197   /**
198    * New upgrade agent available.
199    */
200   event UpgradeAgentSet(address agent);
201 
202     // Migrate tokens to the new token contract
203     function migrate() public {
204         require(migrationAgent != 0);
205         uint value = balances[msg.sender];
206         balances[msg.sender] = safeSub(balances[msg.sender], value);
207         totalSupply = safeSub(totalSupply, value);
208         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
209         Upgrade(msg.sender, migrationAgent, value);
210     }
211 
212     function () public payable {
213       require(migrationAgent != 0);
214       require(balances[msg.sender] > 0);
215       migrate();
216       msg.sender.transfer(msg.value);
217     }
218 
219     function setMigrationAgent(address _agent) onlyOwner external {
220         migrationAgent = _agent;
221         UpgradeAgentSet(_agent);
222     }
223 
224 }
225 contract SABToken is UpgradeableToken {
226   event Mint(address indexed to, uint256 amount);
227   event MintFinished();
228 
229 
230   address public allTokenOwnerOnStart;
231   string public constant name = "SABCoin";
232   string public constant symbol = "SAB";
233   uint256 public constant decimals = 6;
234   
235 
236   function SABToken() public {
237     allTokenOwnerOnStart = msg.sender;
238     totalSupply = 100000000000000;
239     balances[allTokenOwnerOnStart] = totalSupply;
240     Mint(allTokenOwnerOnStart, totalSupply);
241     Transfer(0x0, allTokenOwnerOnStart ,totalSupply);
242     MintFinished();
243   }
244   
245 }