1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 contract SafeMath {
8   function safeMul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 
57 /*
58  * ERC20 interface
59  * see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 {
62   uint public totalSupply;
63   function balanceOf(address who) constant returns (uint);
64   function allowance(address owner, address spender) constant returns (uint);
65 
66   function transfer(address to, uint value) returns (bool ok);
67   function transferFrom(address from, address to, uint value) returns (bool ok);
68   function approve(address spender, uint value) returns (bool ok);
69   event Transfer(address indexed from, address indexed to, uint value);
70   event Approval(address indexed owner, address indexed spender, uint value);
71 }
72 
73 
74 
75 
76 
77 
78 
79 
80 
81 /**
82  * Standard ERC20 token
83  *
84  * https://github.com/ethereum/EIPs/issues/20
85  * Based on code by FirstBlood:
86  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
87  */
88 contract StandardToken is ERC20, SafeMath {
89 
90   mapping(address => uint) balances;
91   mapping (address => mapping (address => uint)) allowed;
92 
93   function transfer(address _to, uint _value) returns (bool success) {
94     balances[msg.sender] = safeSub(balances[msg.sender], _value);
95     balances[_to] = safeAdd(balances[_to], _value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
101     var _allowance = allowed[_from][msg.sender];
102 
103     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
104     // if (_value > _allowance) throw;
105 
106     balances[_to] = safeAdd(balances[_to], _value);
107     balances[_from] = safeSub(balances[_from], _value);
108     allowed[_from][msg.sender] = safeSub(_allowance, _value);
109     Transfer(_from, _to, _value);
110     return true;
111   }
112 
113   function balanceOf(address _owner) constant returns (uint balance) {
114     return balances[_owner];
115   }
116 
117   function approve(address _spender, uint _value) returns (bool success) {
118     allowed[msg.sender][_spender] = _value;
119     Approval(msg.sender, _spender, _value);
120     return true;
121   }
122 
123   function allowance(address _owner, address _spender) constant returns (uint remaining) {
124     return allowed[_owner][_spender];
125   }
126 
127 }
128 
129 
130 contract XNR is StandardToken {
131   
132   modifier onlyOwner() {
133     require(msg.sender == owner);
134     _;
135   }
136 
137   // Requires that before a function executes either:
138   // The global isThawed value is set true
139   // The sender is in a whitelisted thawedAddress
140   // It has been a year since contract deployment
141   modifier requireThawed() {
142     require(isThawed == true || thawedAddresses[msg.sender] == true || now > thawTime);
143     _;
144   }
145 
146   // Applies to thaw functions. Only the designated manager is allowed when this modifier is present
147   modifier onlyManager() {
148     require(msg.sender == owner || msg.sender == manager);
149     _;
150   }
151 
152   address owner;
153   address manager;
154   uint initialBalance;
155   string public name;
156   string public symbol;
157   uint public decimals;
158   mapping (uint=>string) public metadata;
159   mapping (uint=>string) public publicMetadata;
160   bool isThawed = false;
161   mapping (address=>bool) public thawedAddresses;
162   uint256 thawTime;
163 
164   constructor() public {
165     address bountyMgrAddress = address(0x03De5f75915DC5382C5dF82538F8D5e124A7ebB8);
166     
167     initialBalance = 18666666667 * 1e8;
168     uint256 bountyMgrBalance = 933333333 * 1e8;
169     totalSupply = initialBalance;
170 
171     balances[msg.sender] = safeSub(initialBalance, bountyMgrBalance);
172     balances[bountyMgrAddress] = bountyMgrBalance;
173 
174     Transfer(address(0x0), address(msg.sender), balances[msg.sender]);
175     Transfer(address(0x0), address(bountyMgrAddress), balances[bountyMgrAddress]);
176 
177     name = "Neuroneum";
178     symbol = "XNR";
179     decimals = 8;
180     owner = msg.sender;
181     thawedAddresses[msg.sender] = true;
182     thawedAddresses[bountyMgrAddress] = true;
183     thawTime = now + 1 years;
184   }
185 
186   // **
187   // ** Manager functions **
188   // **
189   // Thaw a specific address, allowing it to send tokens
190   function thawAddress(address _address) onlyManager {
191     thawedAddresses[_address] = true;
192   }
193   // Thaw all addresses. This is irreversible
194   function thawAllAddresses() onlyManager {
195     isThawed = true;
196   }
197   // Freeze all addresses except for those whitelisted in thawedAddresses. This is irreversible
198   // This only applies if the thawTime has not yet past.
199   function freezeAllAddresses() onlyManager {
200     isThawed = false;
201   }
202 
203   // **
204   // ** Owner functions **
205   // **
206   // Set a new owner
207   function setOwner(address _newOwner) onlyOwner {
208     owner = _newOwner;
209   }
210 
211   // Set a manager, who can unfreeze wallets as needed
212   function setManager(address _address) onlyOwner {
213     manager = _address;
214   }
215 
216   // Change the ticker symbol of the token
217   function changeSymbol(string newSymbol) onlyOwner {
218     symbol = newSymbol;
219   }
220 
221   // Change the long-form name of the token
222   function changeName(string newName) onlyOwner {
223     name = newName;
224   }
225 
226   // Set any admin level metadata needed for XNR mainnet purposes
227   function setMetadata(uint key, string value) onlyOwner {
228     metadata[key] = value;
229   }
230 
231   // Standard ERC20 transfer commands, with additional requireThawed modifier
232   function transfer(address _to, uint _value) requireThawed returns (bool success) {
233     return super.transfer(_to, _value);
234   }
235   function transferFrom(address _from, address _to, uint _value) requireThawed returns (bool success) {
236     return super.transferFrom(_from, _to, _value);
237   }
238 
239 }