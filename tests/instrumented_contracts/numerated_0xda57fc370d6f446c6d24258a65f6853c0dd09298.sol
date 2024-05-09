1 /*
2  * ERC20 interface
3  * see https://github.com/ethereum/EIPs/issues/20
4  */
5 contract ERC20 {
6   uint public totalSupply;
7   function balanceOf(address who) constant returns (uint);
8   function allowance(address owner, address spender) constant returns (uint);
9 
10   function transfer(address to, uint value) returns (bool ok);
11   function transferFrom(address from, address to, uint value) returns (bool ok);
12   function approve(address spender, uint value) returns (bool ok);
13   event Transfer(address indexed from, address indexed to, uint value);
14   event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 
17 
18 
19 /**
20  * Math operations with safety checks
21  */
22 contract SafeMath {
23   function safeMul(uint a, uint b) internal returns (uint) {
24     uint c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function safeDiv(uint a, uint b) internal returns (uint) {
30     assert(b > 0);
31     uint c = a / b;
32     assert(a == b * c + a % b);
33     return c;
34   }
35 
36   function safeSub(uint a, uint b) internal returns (uint) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function safeAdd(uint a, uint b) internal returns (uint) {
42     uint c = a + b;
43     assert(c>=a && c>=b);
44     return c;
45   }
46 
47   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a >= b ? a : b;
49   }
50 
51   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
52     return a < b ? a : b;
53   }
54 
55   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a >= b ? a : b;
57   }
58 
59   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
60     return a < b ? a : b;
61   }
62 
63   function assert(bool assertion) internal {
64     if (!assertion) {
65       throw;
66     }
67   }
68 }
69 
70 
71 
72 /**
73  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
74  *
75  * Based on code by FirstBlood:
76  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
77  */
78 contract StandardToken is ERC20, SafeMath {
79 
80   mapping(address => uint) balances;
81   mapping (address => mapping (address => uint)) allowed;
82 
83   // Interface marker
84   bool public constant isToken = true;
85 
86   /**
87    *
88    * Fix for the ERC20 short address attack
89    *
90    * http://vessenes.com/the-erc20-short-address-attack-explained/
91    */
92   modifier onlyPayloadSize(uint size) {
93      if(msg.data.length < size + 4) {
94        throw;
95      }
96      _;
97   }
98 
99   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
100     balances[msg.sender] = safeSub(balances[msg.sender], _value);
101     balances[_to] = safeAdd(balances[_to], _value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   function transferFrom(address _from, address _to, uint _value)  returns (bool success) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
110     // if (_value > _allowance) throw;
111 
112     balances[_to] = safeAdd(balances[_to], _value);
113     balances[_from] = safeSub(balances[_from], _value);
114     allowed[_from][msg.sender] = safeSub(_allowance, _value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   function balanceOf(address _owner) constant returns (uint balance) {
120     return balances[_owner];
121   }
122 
123   function approve(address _spender, uint _value) returns (bool success) {
124 
125     // To change the approve amount you first have to reduce the addresses`
126     //  allowance to zero by calling `approve(_spender, 0)` if it is not
127     //  already 0 to mitigate the race condition described here:
128     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
130 
131     allowed[msg.sender][_spender] = _value;
132     Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   function allowance(address _owner, address _spender) constant returns (uint remaining) {
137     return allowed[_owner][_spender];
138   }
139 
140 }
141 
142 
143 
144 /*
145  * Ownable
146  *
147  * Base contract with an owner.
148  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
149  */
150 contract Ownable {
151   address public owner;
152 
153   function Ownable() {
154     owner = msg.sender;
155   }
156 
157   modifier onlyOwner() {
158     if (msg.sender != owner) {
159       throw;
160     }
161     _;
162   }
163 
164   function transferOwnership(address newOwner) onlyOwner {
165     if (newOwner != address(0)) {
166       owner = newOwner;
167     }
168   }
169 
170 }
171 
172 
173 
174 /**
175  * Issuer manages token distribution after the crowdsale.
176  *
177  * This contract is fed a CSV file with Ethereum addresses and their
178  * issued token balances.
179  *
180  * Issuer act as a gate keeper to ensure there is no double issuance
181  * per address, in the case we need to do several issuance batches,
182  * there is a race condition or there is a fat finger error.
183  *
184  * Issuer contract gets allowance from the team multisig to distribute tokens.
185  *
186  */
187 contract Issuer is Ownable, SafeMath {
188 
189   /** Map addresses whose tokens we have already issued. */
190   mapping(address => bool) public issued;
191 
192   /** Centrally issued token we are distributing to our contributors */
193   StandardToken public token;
194 
195   /** Party (team multisig) who is in the control of the token pool. Note that this will be different from the owner address (scripted) that calls this contract. */
196   address public masterTokenBalanceHolder;
197 
198   /** How many addresses have received their tokens. */
199   uint public issuedCount;
200 
201   /**
202    *
203    * @param _issuerDeploymentAccount Ethereun account that controls the issuance process and pays the gas fee
204    * @param _token Token contract address
205    * @param _masterTokenBalanceHolder Multisig address that does StandardToken.approve() to give allowance for this contract
206    */
207   function Issuer(address _issuerDeploymentAccount, address _masterTokenBalanceHolder, StandardToken _token) {
208     owner = _issuerDeploymentAccount;
209     masterTokenBalanceHolder = _masterTokenBalanceHolder;
210     token = _token;
211   }
212 
213   function issue(address benefactor, uint amount) onlyOwner {
214     if(issued[benefactor]) throw;
215     token.transferFrom(masterTokenBalanceHolder, benefactor, amount);
216     issued[benefactor] = true;
217     issuedCount = safeAdd(amount, issuedCount);
218   }
219 
220   /**
221    * How many tokens we have left in our approval pool.
222    */
223   function getApprovedTokenCount() public constant returns(uint tokens) {
224     return token.allowance(masterTokenBalanceHolder, address(this));
225   }
226 
227 }