1 // (C) 2017 TokenMarket Ltd. (https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt) Commit: d9e308ff22556a8f40909b1f89ec0f759d1337e0
2 /**
3  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
4  *
5  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
6  */
7 
8 
9 /**
10  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
11  *
12  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
13  */
14 
15 
16 
17 
18 
19 
20 
21 /**
22  * @title ERC20Basic
23  * @dev Simpler version of ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/179
25  */
26 contract ERC20Basic {
27   uint256 public totalSupply;
28   function balanceOf(address who) constant returns (uint256);
29   function transfer(address to, uint256 value) returns (bool);
30   event Transfer(address indexed from, address indexed to, uint256 value);
31 }
32 
33 
34 
35 /**
36  * @title ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/20
38  */
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) constant returns (uint256);
41   function transferFrom(address from, address to, uint256 value) returns (bool);
42   function approve(address spender, uint256 value) returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
47 
48 
49 
50 /**
51  * Math operations with safety checks
52  */
53 contract SafeMath {
54   function safeMul(uint a, uint b) internal returns (uint) {
55     uint c = a * b;
56     assert(a == 0 || c / a == b);
57     return c;
58   }
59 
60   function safeDiv(uint a, uint b) internal returns (uint) {
61     assert(b > 0);
62     uint c = a / b;
63     assert(a == b * c + a % b);
64     return c;
65   }
66 
67   function safeSub(uint a, uint b) internal returns (uint) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function safeAdd(uint a, uint b) internal returns (uint) {
73     uint c = a + b;
74     assert(c>=a && c>=b);
75     return c;
76   }
77 
78   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
79     return a >= b ? a : b;
80   }
81 
82   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
83     return a < b ? a : b;
84   }
85 
86   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
87     return a >= b ? a : b;
88   }
89 
90   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
91     return a < b ? a : b;
92   }
93 
94 }
95 
96 
97 
98 /**
99  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
100  *
101  * Based on code by FirstBlood:
102  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, SafeMath {
105 
106   /* Token supply got increased and a new owner received these tokens */
107   event Minted(address receiver, uint amount);
108 
109   /* Actual balances of token holders */
110   mapping(address => uint) balances;
111 
112   /* approve() allowances */
113   mapping (address => mapping (address => uint)) allowed;
114 
115   /* Interface declaration */
116   function isToken() public constant returns (bool weAre) {
117     return true;
118   }
119 
120   function transfer(address _to, uint _value) returns (bool success) {
121     balances[msg.sender] = safeSub(balances[msg.sender], _value);
122     balances[_to] = safeAdd(balances[_to], _value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
128     uint _allowance = allowed[_from][msg.sender];
129 
130     balances[_to] = safeAdd(balances[_to], _value);
131     balances[_from] = safeSub(balances[_from], _value);
132     allowed[_from][msg.sender] = safeSub(_allowance, _value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   function balanceOf(address _owner) constant returns (uint balance) {
138     return balances[_owner];
139   }
140 
141   function approve(address _spender, uint _value) returns (bool success) {
142 
143     // To change the approve amount you first have to reduce the addresses`
144     //  allowance to zero by calling `approve(_spender, 0)` if it is not
145     //  already 0 to mitigate the race condition described here:
146     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
148 
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   function allowance(address _owner, address _spender) constant returns (uint remaining) {
155     return allowed[_owner][_spender];
156   }
157 
158 }
159 
160 
161 
162 /**
163  * @title Ownable
164  * @dev The Ownable contract has an owner address, and provides basic authorization control
165  * functions, this simplifies the implementation of "user permissions".
166  */
167 contract Ownable {
168   address public owner;
169 
170 
171   /**
172    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
173    * account.
174    */
175   function Ownable() {
176     owner = msg.sender;
177   }
178 
179 
180   /**
181    * @dev Throws if called by any account other than the owner.
182    */
183   modifier onlyOwner() {
184     require(msg.sender == owner);
185     _;
186   }
187 
188 
189   /**
190    * @dev Allows the current owner to transfer control of the contract to a newOwner.
191    * @param newOwner The address to transfer ownership to.
192    */
193   function transferOwnership(address newOwner) onlyOwner {
194     require(newOwner != address(0));      
195     owner = newOwner;
196   }
197 
198 }
199 
200 
201 /**
202  * Issuer manages token distribution after the crowdsale.
203  *
204  * This contract is fed a CSV file with Ethereum addresses and their
205  * issued token balances.
206  *
207  * Issuer act as a gate keeper to ensure there is no double issuance
208  * per address, in the case we need to do several issuance batches,
209  * there is a race condition or there is a fat finger error.
210  *
211  * Issuer contract gets allowance from the team multisig to distribute tokens.
212  *
213  */
214 contract Issuer is Ownable {
215 
216   /** Map addresses whose tokens we have already issued. */
217   mapping(address => bool) public issued;
218 
219   /** Centrally issued token we are distributing to our contributors */
220   StandardToken public token;
221 
222   /** Party (team multisig) who is in the control of the token pool. Note that this will be different from the owner address (scripted) that calls this contract. */
223   address public allower;
224 
225   /** How many addresses have received their tokens. */
226   uint public issuedCount;
227 
228   function Issuer(address _owner, address _allower, StandardToken _token) {
229     owner = _owner;
230     allower = _allower;
231     token = _token;
232   }
233 
234   function issue(address benefactor, uint amount) onlyOwner {
235     if(issued[benefactor]) throw;
236     token.transferFrom(allower, benefactor, amount);
237     issued[benefactor] = true;
238     issuedCount += amount;
239   }
240 
241 }