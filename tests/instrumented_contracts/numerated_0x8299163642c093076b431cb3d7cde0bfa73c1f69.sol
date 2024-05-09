1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 
16 
17 
18 /*
19  * ERC20 interface
20  * see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 {
23   uint public totalSupply;
24   function balanceOf(address who) constant returns (uint);
25   function allowance(address owner, address spender) constant returns (uint);
26 
27   function transfer(address to, uint value) returns (bool ok);
28   function transferFrom(address from, address to, uint value) returns (bool ok);
29   function approve(address spender, uint value) returns (bool ok);
30   event Transfer(address indexed from, address indexed to, uint value);
31   event Approval(address indexed owner, address indexed spender, uint value);
32 }
33 
34 
35 
36 /**
37  * Math operations with safety checks
38  */
39 contract SafeMath {
40   function safeMul(uint a, uint b) internal returns (uint) {
41     uint c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function safeDiv(uint a, uint b) internal returns (uint) {
47     assert(b > 0);
48     uint c = a / b;
49     assert(a == b * c + a % b);
50     return c;
51   }
52 
53   function safeSub(uint a, uint b) internal returns (uint) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function safeAdd(uint a, uint b) internal returns (uint) {
59     uint c = a + b;
60     assert(c>=a && c>=b);
61     return c;
62   }
63 
64   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
65     return a >= b ? a : b;
66   }
67 
68   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
69     return a < b ? a : b;
70   }
71 
72   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
73     return a >= b ? a : b;
74   }
75 
76   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
77     return a < b ? a : b;
78   }
79 
80   function assert(bool assertion) internal {
81     if (!assertion) {
82       throw;
83     }
84   }
85 }
86 
87 
88 
89 /**
90  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
91  *
92  * Based on code by FirstBlood:
93  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, SafeMath {
96 
97   /* Token supply got increased and a new owner received these tokens */
98   event Minted(address receiver, uint amount);
99 
100   /* Actual balances of token holders */
101   mapping(address => uint) balances;
102 
103   /* approve() allowances */
104   mapping (address => mapping (address => uint)) allowed;
105 
106   /* Interface declaration */
107   function isToken() public constant returns (bool weAre) {
108     return true;
109   }
110 
111   function transfer(address _to, uint _value) returns (bool success) {
112     balances[msg.sender] = safeSub(balances[msg.sender], _value);
113     balances[_to] = safeAdd(balances[_to], _value);
114     Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
119     uint _allowance = allowed[_from][msg.sender];
120 
121     balances[_to] = safeAdd(balances[_to], _value);
122     balances[_from] = safeSub(balances[_from], _value);
123     allowed[_from][msg.sender] = safeSub(_allowance, _value);
124     Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   function balanceOf(address _owner) constant returns (uint balance) {
129     return balances[_owner];
130   }
131 
132   function approve(address _spender, uint _value) returns (bool success) {
133 
134     // To change the approve amount you first have to reduce the addresses`
135     //  allowance to zero by calling `approve(_spender, 0)` if it is not
136     //  already 0 to mitigate the race condition described here:
137     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
139 
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   function allowance(address _owner, address _spender) constant returns (uint remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 
152 
153 /*
154  * Ownable
155  *
156  * Base contract with an owner.
157  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
158  */
159 contract Ownable {
160   address public owner;
161 
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166   modifier onlyOwner() {
167     if (msg.sender != owner) {
168       throw;
169     }
170     _;
171   }
172 
173   function transferOwnership(address newOwner) onlyOwner {
174     if (newOwner != address(0)) {
175       owner = newOwner;
176     }
177   }
178 
179 }
180 
181 
182 /**
183  * Issuer manages token distribution after the crowdsale.
184  *
185  * This contract is fed a CSV file with Ethereum addresses and their
186  * issued token balances.
187  *
188  * Issuer act as a gate keeper to ensure there is no double issuance
189  * per address, in the case we need to do several issuance batches,
190  * there is a race condition or there is a fat finger error.
191  *
192  * Issuer contract gets allowance from the team multisig to distribute tokens.
193  *
194  */
195 contract Issuer is Ownable {
196 
197   /** Map addresses whose tokens we have already issued. */
198   mapping(address => bool) public issued;
199 
200   /** Centrally issued token we are distributing to our contributors */
201   StandardToken public token;
202 
203   /** Party (team multisig) who is in the control of the token pool. Note that this will be different from the owner address (scripted) that calls this contract. */
204   address public allower;
205 
206   /** How many addresses have received their tokens. */
207   uint public issuedCount;
208 
209   function Issuer(address _owner, address _allower, StandardToken _token) {
210     owner = _owner;
211     allower = _allower;
212     token = _token;
213   }
214 
215   function issue(address benefactor, uint amount) onlyOwner {
216     if(issued[benefactor]) throw;
217     token.transferFrom(allower, benefactor, amount);
218     issued[benefactor] = true;
219     issuedCount += amount;
220   }
221 
222 }