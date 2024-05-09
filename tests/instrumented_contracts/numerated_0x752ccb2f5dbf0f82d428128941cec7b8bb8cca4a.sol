1 pragma solidity ^0.4.8;
2 
3 
4 
5 
6 
7 /*
8  * ERC20 interface
9  * see https://github.com/ethereum/EIPs/issues/20
10  */
11 contract ERC20 {
12   uint public totalSupply;
13   function balanceOf(address who) constant returns (uint);
14   function allowance(address owner, address spender) constant returns (uint);
15 
16   function transfer(address to, uint value) returns (bool ok);
17   function transferFrom(address from, address to, uint value) returns (bool ok);
18   function approve(address spender, uint value) returns (bool ok);
19   event Transfer(address indexed from, address indexed to, uint value);
20   event Approval(address indexed owner, address indexed spender, uint value);
21 }
22 
23 
24 
25 /**
26  * Math operations with safety checks
27  */
28 contract SafeMath {
29   function safeMul(uint a, uint b) internal returns (uint) {
30     uint c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33   }
34 
35   function safeDiv(uint a, uint b) internal returns (uint) {
36     assert(b > 0);
37     uint c = a / b;
38     assert(a == b * c + a % b);
39     return c;
40   }
41 
42   function safeSub(uint a, uint b) internal returns (uint) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function safeAdd(uint a, uint b) internal returns (uint) {
48     uint c = a + b;
49     assert(c>=a && c>=b);
50     return c;
51   }
52 
53   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
54     return a >= b ? a : b;
55   }
56 
57   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
58     return a < b ? a : b;
59   }
60 
61   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
62     return a >= b ? a : b;
63   }
64 
65   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
66     return a < b ? a : b;
67   }
68 
69   function assert(bool assertion) internal {
70     if (!assertion) {
71       throw;
72     }
73   }
74 }
75 
76 
77 
78 /**
79  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
80  *
81  * Based on code by FirstBlood:
82  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
83  */
84 contract StandardToken is ERC20, SafeMath {
85 
86   /* Token supply got increased and a new owner received these tokens */
87   event Minted(address receiver, uint amount);
88 
89   /* Actual balances of token holders */
90   mapping(address => uint) balances;
91 
92   /* approve() allowances */
93   mapping (address => mapping (address => uint)) allowed;
94 
95   /* Interface declaration */
96   function isToken() public constant returns (bool weAre) {
97     return true;
98   }
99 
100   /**
101    *
102    * Fix for the ERC20 short address attack
103    *
104    * http://vessenes.com/the-erc20-short-address-attack-explained/
105    */
106   modifier onlyPayloadSize(uint size) {
107      if(msg.data.length < size + 4) {
108        throw;
109      }
110      _;
111   }
112 
113   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
114     balances[msg.sender] = safeSub(balances[msg.sender], _value);
115     balances[_to] = safeAdd(balances[_to], _value);
116     Transfer(msg.sender, _to, _value);
117     return true;
118   }
119 
120   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
121     uint _allowance = allowed[_from][msg.sender];
122 
123     balances[_to] = safeAdd(balances[_to], _value);
124     balances[_from] = safeSub(balances[_from], _value);
125     allowed[_from][msg.sender] = safeSub(_allowance, _value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   function balanceOf(address _owner) constant returns (uint balance) {
131     return balances[_owner];
132   }
133 
134   function approve(address _spender, uint _value) returns (bool success) {
135 
136     // To change the approve amount you first have to reduce the addresses`
137     //  allowance to zero by calling `approve(_spender, 0)` if it is not
138     //  already 0 to mitigate the race condition described here:
139     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
141 
142     allowed[msg.sender][_spender] = _value;
143     Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   function allowance(address _owner, address _spender) constant returns (uint remaining) {
148     return allowed[_owner][_spender];
149   }
150 
151 }
152 
153 
154 
155 /*
156  * Ownable
157  *
158  * Base contract with an owner.
159  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
160  */
161 contract Ownable {
162   address public owner;
163 
164   function Ownable() {
165     owner = msg.sender;
166   }
167 
168   modifier onlyOwner() {
169     if (msg.sender != owner) {
170       throw;
171     }
172     _;
173   }
174 
175   function transferOwnership(address newOwner) onlyOwner {
176     if (newOwner != address(0)) {
177       owner = newOwner;
178     }
179   }
180 
181 }
182 
183 
184 /**
185  * Issuer manages token distribution after the crowdsale.
186  *
187  * This contract is fed a CSV file with Ethereum addresses and their
188  * issued token balances.
189  *
190  * Issuer act as a gate keeper to ensure there is no double issuance
191  * per address, in the case we need to do several issuance batches,
192  * there is a race condition or there is a fat finger error.
193  *
194  * Issuer contract gets allowance from the team multisig to distribute tokens.
195  *
196  */
197 contract Issuer is Ownable {
198 
199   /** Map addresses whose tokens we have already issued. */
200   mapping(address => bool) public issued;
201 
202   /** Centrally issued token we are distributing to our contributors */
203   StandardToken public token;
204 
205   /** Party (team multisig) who is in the control of the token pool. Note that this will be different from the owner address (scripted) that calls this contract. */
206   address public allower;
207 
208   /** How many addresses have received their tokens. */
209   uint public issuedCount;
210 
211   function Issuer(address _owner, address _allower, StandardToken _token) {
212     owner = _owner;
213     allower = _allower;
214     token = _token;
215   }
216 
217   function issue(address benefactor, uint amount) onlyOwner {
218     if(issued[benefactor]) throw;
219     token.transferFrom(allower, benefactor, amount);
220     issued[benefactor] = true;
221     issuedCount += amount;
222   }
223 
224 }