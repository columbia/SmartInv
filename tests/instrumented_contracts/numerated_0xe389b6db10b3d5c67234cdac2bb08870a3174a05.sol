1 pragma solidity ^0.4.12;
2 
3 /*
4  * ERC20 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   uint public totalSupply;
9   function balanceOf(address who) constant returns (uint);
10   function allowance(address owner, address spender) constant returns (uint);
11 
12   function transfer(address to, uint value) returns (bool ok);
13   function transferFrom(address from, address to, uint value) returns (bool ok);
14   function approve(address spender, uint value) returns (bool ok);
15   event Transfer(address indexed from, address indexed to, uint value);
16   event Approval(address indexed owner, address indexed spender, uint value);
17 }
18 
19 
20 /**
21  * Math operations with safety checks
22  */
23 contract SafeMath {
24   function safeMul(uint a, uint b) internal returns (uint) {
25     uint c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function safeDiv(uint a, uint b) internal returns (uint) {
31     assert(b > 0);
32     uint c = a / b;
33     assert(a == b * c + a % b);
34     return c;
35   }
36 
37   function safeSub(uint a, uint b) internal returns (uint) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function safeAdd(uint a, uint b) internal returns (uint) {
43     uint c = a + b;
44     assert(c>=a && c>=b);
45     return c;
46   }
47 
48   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
49     return a >= b ? a : b;
50   }
51 
52   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
53     return a < b ? a : b;
54   }
55 
56   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
57     return a >= b ? a : b;
58   }
59 
60   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
61     return a < b ? a : b;
62   }
63 
64  
65 }
66 
67 
68 
69 /**
70  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
71  *
72  * Based on code by FirstBlood:
73  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
74  */
75 contract StandardToken is ERC20, SafeMath {
76 
77   /* Token supply got increased and a new owner received these tokens */
78   event Minted(address receiver, uint amount);
79 
80   /* Actual balances of token holders */
81   mapping(address => uint) balances;
82 
83   /* approve() allowances */
84   mapping (address => mapping (address => uint)) allowed;
85 
86   /**
87    *
88    * Fix for the ERC20 short address attack
89    *
90    * http://vessenes.com/the-erc20-short-address-attack-explained/
91    */
92   modifier onlyPayloadSize(uint size) {
93      require(msg.data.length == size + 4);
94      _;
95   }
96 
97   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
98     balances[msg.sender] = safeSub(balances[msg.sender], _value);
99     balances[_to] = safeAdd(balances[_to], _value);
100     Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
105     uint _allowance = allowed[_from][msg.sender];
106 
107     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
108     // if (_value > _allowance) throw;
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
127     require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
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
138   /**
139    * Atomic increment of approved spending
140    *
141    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142    *
143    */
144   function addApproval(address _spender, uint _addedValue)
145   onlyPayloadSize(2 * 32)
146   returns (bool success) {
147       uint oldValue = allowed[msg.sender][_spender];
148       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
149       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150       return true;
151   }
152 
153   /**
154    * Atomic decrement of approved spending.
155    *
156    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    */
158   function subApproval(address _spender, uint _subtractedValue)
159   onlyPayloadSize(2 * 32)
160   returns (bool success) {
161 
162       uint oldVal = allowed[msg.sender][_spender];
163 
164       if (_subtractedValue > oldVal) {
165           allowed[msg.sender][_spender] = 0;
166       } else {
167           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
168       }
169       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170       return true;
171   }
172 
173 }
174 
175 contract GIFTToken is StandardToken {
176 
177   string public name;
178   string public symbol;
179   uint public decimals;
180   address public owner;
181 
182   mapping(address => uint) previligedBalances;
183 
184   function GIFTToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals) {
185     name = _name;
186     symbol = _symbol;
187     totalSupply = _totalSupply;
188     decimals = _decimals;
189 
190     // Allocate initial balance to the owner
191     balances[_owner] = _totalSupply;
192 
193     // save the owner
194     owner = _owner;
195   }
196 
197 
198   // privileged transfer
199   function transferPrivileged(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
200     require(msg.sender == owner);
201     balances[msg.sender] = safeSub(balances[msg.sender], _value);
202     balances[_to] = safeAdd(balances[_to], _value);
203     previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);
204     Transfer(msg.sender, _to, _value);
205     return true;
206   }
207 
208   // get priveleged balance
209   function getPrivilegedBalance(address _owner) constant returns (uint balance) {
210     return previligedBalances[_owner];
211   }
212 
213   // admin only can transfer from the privileged accounts
214   function transferFromPrivileged(address _from, address _to, uint _value) returns (bool success) {
215     require(msg.sender == owner);
216 
217     uint availablePrevilegedBalance = previligedBalances[_from];
218 
219     balances[_from] = safeSub(balances[_from], _value);
220     balances[_to] = safeAdd(balances[_to], _value);
221     previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);
222     Transfer(_from, _to, _value);
223     return true;
224   }
225 }