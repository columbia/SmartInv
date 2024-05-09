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
79  * Standard ERC20 token
80  *
81  * https://github.com/ethereum/EIPs/issues/20
82  * Based on code by FirstBlood:
83  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
84  */
85 contract StandardToken is ERC20, SafeMath {
86 
87   mapping(address => uint) balances;
88   mapping (address => mapping (address => uint)) allowed;
89 
90   function transfer(address _to, uint _value) returns (bool success) {
91     balances[msg.sender] = safeSub(balances[msg.sender], _value);
92     balances[_to] = safeAdd(balances[_to], _value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
98     var _allowance = allowed[_from][msg.sender];
99 
100     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
101     // if (_value > _allowance) throw;
102 
103     balances[_to] = safeAdd(balances[_to], _value);
104     balances[_from] = safeSub(balances[_from], _value);
105     allowed[_from][msg.sender] = safeSub(_allowance, _value);
106     Transfer(_from, _to, _value);
107     return true;
108   }
109 
110   function balanceOf(address _owner) constant returns (uint balance) {
111     return balances[_owner];
112   }
113 
114   function approve(address _spender, uint _value) returns (bool success) {
115     allowed[msg.sender][_spender] = _value;
116     Approval(msg.sender, _spender, _value);
117     return true;
118   }
119 
120   function allowance(address _owner, address _spender) constant returns (uint remaining) {
121     return allowed[_owner][_spender];
122   }
123 
124 }
125 
126 
127 
128 /*
129  * Ownable
130  *
131  * Base contract with an owner.
132  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
133  */
134 contract Ownable {
135   address public owner;
136 
137   function Ownable() {
138     owner = msg.sender;
139   }
140 
141   modifier onlyOwner() {
142     if (msg.sender != owner) {
143       throw;
144     }
145     _;
146   }
147 
148   function transferOwnership(address newOwner) onlyOwner {
149     if (newOwner != address(0)) {
150       owner = newOwner;
151     }
152   }
153 
154 }
155 
156 
157 /**
158  * Issuer manages token distribution after the crowdsale.
159  *
160  * This contract is fed a CSV file with Ethereum addresses and their
161  * issued token balances.
162  *
163  * Issuer act as a gate keeper to ensure there is no double issuance
164  * per address, in the case we need to do several issuance batches,
165  * there is a race condition or there is a fat finger error.
166  *
167  * Issuer contract gets allowance from the team multisig to distribute tokens.
168  *
169  */
170 contract Issuer is Ownable {
171 
172   /** Map addresses whose tokens we have already issued. */
173   mapping(address => bool) public issued;
174 
175   /** Centrally issued token we are distributing to our contributors */
176   StandardToken public token;
177 
178   /** Party (team multisig) who is in the control of the token pool. Note that this will be different from the owner address (scripted) that calls this contract. */
179   address public allower;
180 
181   /** How many addresses have received their tokens. */
182   uint public issuedCount;
183 
184   function Issuer(address _owner, address _allower, StandardToken _token) {
185     owner = _owner;
186     allower = _allower;
187     token = _token;
188   }
189 
190   function issue(address benefactor, uint amount) onlyOwner {
191     if(issued[benefactor]) throw;
192     token.transferFrom(allower, benefactor, amount);
193     issued[benefactor] = true;
194     issuedCount += amount;
195   }
196 
197 }