1 pragma solidity ^0.4.11;
2 
3 
4 /*
5  * ERC20 interface
6  * see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   uint public totalSupply;
10   function balanceOf(address who) constant returns (uint);
11   function allowance(address owner, address spender) constant returns (uint);
12 
13   function transfer(address to, uint value) returns (bool ok);
14   function transferFrom(address from, address to, uint value) returns (bool ok);
15   function approve(address spender, uint value) returns (bool ok);
16   event Transfer(address indexed from, address indexed to, uint value);
17   event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 
21 
22 /**
23  * Math operations with safety checks
24  */
25 contract SafeMath {
26   function safeMul(uint a, uint b) internal returns (uint) {
27     uint c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function safeDiv(uint a, uint b) internal returns (uint) {
33     assert(b > 0);
34     uint c = a / b;
35     assert(a == b * c + a % b);
36     return c;
37   }
38 
39   function safeSub(uint a, uint b) internal returns (uint) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint a, uint b) internal returns (uint) {
45     uint c = a + b;
46     assert(c>=a && c>=b);
47     return c;
48   }
49 
50   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a >= b ? a : b;
52   }
53 
54   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
55     return a < b ? a : b;
56   }
57 
58   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a >= b ? a : b;
60   }
61 
62   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
63     return a < b ? a : b;
64   }
65 
66 }
67 
68 
69 
70 
71 /**
72  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
73  *
74  * Based on code by FirstBlood:
75  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
76  */
77 
78 contract StandardToken is ERC20, SafeMath {
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
93      if(msg.data.length != size + 4) {
94        revert();
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
106   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
107     uint _allowance = allowed[_from][msg.sender];
108 
109     balances[_to] = safeAdd(balances[_to], _value);
110     balances[_from] = safeSub(balances[_from], _value);
111     allowed[_from][msg.sender] = safeSub(_allowance, _value);
112     Transfer(_from, _to, _value);
113     return true;
114   }
115 
116   function balanceOf(address _owner) constant returns (uint balance) {
117     return balances[_owner];
118   }
119 
120   function approve(address _spender, uint _value) returns (bool success) {
121 
122     // To change the approve amount you first have to reduce the addresses`
123     //  allowance to zero by calling `approve(_spender, 0)` if it is not
124     //  already 0 to mitigate the race condition described here:
125     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
127 
128     allowed[msg.sender][_spender] = _value;
129     Approval(msg.sender, _spender, _value);
130     return true;
131   }
132 
133   function allowance(address _owner, address _spender) constant returns (uint remaining) {
134     return allowed[_owner][_spender];
135   }
136   }
137 
138 
139 
140 contract Test20 is StandardToken {
141   string public constant name = "Test20";
142   string public constant symbol = "TST";
143   uint public constant decimals = 18;
144   string public version = "1.0";
145   uint public totalSupply = 10000; 
146 
147   // Constructor
148 
149   function Test20() {
150       balances[msg.sender] = totalSupply; // Send all tokens to owner
151   }
152 
153 
154     /* Approves and then calls the receiving contract */
155     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
156         allowed[msg.sender][_spender] = _value;
157         Approval(msg.sender, _spender, _value);
158 
159         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
160         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
161         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
162         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
163         return true;
164     }
165 
166   }