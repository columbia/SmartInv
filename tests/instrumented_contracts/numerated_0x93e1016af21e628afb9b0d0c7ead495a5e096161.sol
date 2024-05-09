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
100   function transfer(address _to, uint _value) returns (bool success) {
101     balances[msg.sender] = safeSub(balances[msg.sender], _value);
102     balances[_to] = safeAdd(balances[_to], _value);
103     Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
108     uint _allowance = allowed[_from][msg.sender];
109 
110     balances[_to] = safeAdd(balances[_to], _value);
111     balances[_from] = safeSub(balances[_from], _value);
112     allowed[_from][msg.sender] = safeSub(_allowance, _value);
113     Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   function balanceOf(address _owner) constant returns (uint balance) {
118     return balances[_owner];
119   }
120 
121   function approve(address _spender, uint _value) returns (bool success) {
122 
123     // To change the approve amount you first have to reduce the addresses`
124     //  allowance to zero by calling `approve(_spender, 0)` if it is not
125     //  already 0 to mitigate the race condition described here:
126     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
128 
129     allowed[msg.sender][_spender] = _value;
130     Approval(msg.sender, _spender, _value);
131     return true;
132   }
133 
134   function allowance(address _owner, address _spender) constant returns (uint remaining) {
135     return allowed[_owner][_spender];
136   }
137 
138 }
139 
140 
141 
142 /*
143  * Ownable
144  *
145  * Base contract with an owner.
146  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
147  */
148 contract Ownable {
149   address public owner;
150 
151   function Ownable() {
152     owner = msg.sender;
153   }
154 
155   modifier onlyOwner() {
156     if (msg.sender != owner) {
157       throw;
158     }
159     _;
160   }
161 
162   function transferOwnership(address newOwner) onlyOwner {
163     if (newOwner != address(0)) {
164       owner = newOwner;
165     }
166   }
167 
168 }
169 
170 
171 /**
172  * Issuer manages token distribution after the crowdsale.
173  *
174  * This contract is fed a CSV file with Ethereum addresses and their
175  * issued token balances.
176  *
177  * Issuer act as a gate keeper to ensure there is no double issuance
178  * per address, in the case we need to do several issuance batches,
179  * there is a race condition or there is a fat finger error.
180  *
181  * Issuer contract gets allowance from the team multisig to distribute tokens.
182  *
183  */
184 contract Issuer is Ownable {
185 
186   /** Map addresses whose tokens we have already issued. */
187   mapping(address => bool) public issued;
188 
189   /** Centrally issued token we are distributing to our contributors */
190   StandardToken public token;
191 
192   /** Party (team multisig) who is in the control of the token pool. Note that this will be different from the owner address (scripted) that calls this contract. */
193   address public allower;
194 
195   /** How many addresses have received their tokens. */
196   uint public issuedCount;
197 
198   function Issuer(address _owner, address _allower, StandardToken _token) {
199     owner = _owner;
200     allower = _allower;
201     token = _token;
202   }
203 
204   function issue(address benefactor, uint amount) onlyOwner {
205     if(issued[benefactor]) throw;
206     token.transferFrom(allower, benefactor, amount);
207     issued[benefactor] = true;
208     issuedCount += amount;
209   }
210 
211 }