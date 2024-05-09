1 pragma solidity ^0.4.18;
2 
3 /// @title Kinguin Krowns [KRS]
4 
5  /* ERC223 additions to ERC20 */
6 
7  /*
8   ERC223 additions to ERC20
9 
10   Interface wise is ERC20 + data parameter to transfer and transferFrom.
11  */
12 
13 /*
14  * ERC20 interface
15  * see https://github.com/ethereum/EIPs/issues/20
16  */
17 contract ERC20 {
18   uint public totalSupply;
19   function balanceOf(address who) constant returns (uint);
20   function allowance(address owner, address spender) constant returns (uint);
21 
22   function transfer(address to, uint value) returns (bool ok);
23   function transferFrom(address from, address to, uint value) returns (bool ok);
24   function approve(address spender, uint value) returns (bool ok);
25   event Transfer(address indexed from, address indexed to, uint value);
26   event Approval(address indexed owner, address indexed spender, uint value);
27 }
28 
29 
30 contract ERC223 is ERC20 {
31   function transfer(address to, uint value, bytes data) returns (bool ok);
32   function transferFrom(address from, address to, uint value, bytes data) returns (bool ok);
33 }
34 
35 contract ERC223Receiver {
36   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok);
37 }
38 
39 
40 /**
41  * Math operations with safety checks
42  */
43 contract SafeMath {
44   function safeMul(uint a, uint b) internal returns (uint) {
45     uint c = a * b;
46     assert(a == 0 || c / a == b);
47     return c;
48   }
49 
50   function safeDiv(uint a, uint b) internal returns (uint) {
51     assert(b > 0);
52     uint c = a / b;
53     assert(a == b * c + a % b);
54     return c;
55   }
56 
57   function safeSub(uint a, uint b) internal returns (uint) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function safeAdd(uint a, uint b) internal returns (uint) {
63     uint c = a + b;
64     assert(c>=a && c>=b);
65     return c;
66   }
67 
68   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
69     return a >= b ? a : b;
70   }
71 
72   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
73     return a < b ? a : b;
74   }
75 
76   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
77     return a >= b ? a : b;
78   }
79 
80   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
81     return a < b ? a : b;
82   }
83 
84   /*function assert(bool assertion) internal {
85     if (!assertion) {
86       throw;
87     }
88   }*/
89 }
90 
91 
92 /**
93  * Standard ERC20 token
94  *
95  * https://github.com/ethereum/EIPs/issues/20
96  * Based on code by FirstBlood:
97  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, SafeMath {
100   mapping(address => uint) balances;
101   mapping (address => mapping (address => uint)) allowed;
102   function transfer(address _to, uint _value) returns (bool success) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105     balances[msg.sender] = safeSub(balances[msg.sender], _value);
106     balances[_to] = safeAdd(balances[_to], _value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
111     var _allowance = allowed[_from][msg.sender];
112     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
113     // if (_value > _allowance) throw;
114     balances[_to] = safeAdd(balances[_to], _value);
115     balances[_from] = safeSub(balances[_from], _value);
116     allowed[_from][msg.sender] = safeSub(_allowance, _value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120   function balanceOf(address _owner) constant returns (uint balance) {
121     return balances[_owner];
122   }
123   function approve(address _spender, uint _value) returns (bool success) {
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128   function allowance(address _owner, address _spender) constant returns (uint remaining) {
129     return allowed[_owner][_spender];
130   }
131 }
132 
133 contract KinguinKrowns is ERC223, StandardToken {
134   address public owner;  // token owner adddres
135   string public constant name = "Kinguin Krowns";
136   string public constant symbol = "KRS";
137   uint8 public constant decimals = 18;
138   // uint256 public totalSupply; // defined in ERC20 contract
139 		
140   function KinguinKrowns() {
141 	owner = msg.sender;
142     totalSupply = 100000000 * (10**18); // 100 mln
143     balances[msg.sender] = totalSupply;
144   } 
145   
146   /*
147   //only do if call is from owner modifier
148   modifier onlyOwner() {
149     if (msg.sender != owner) throw;
150     _;
151   }*/
152   
153   //function that is called when a user or another contract wants to transfer funds
154   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
155     //filtering if the target is a contract with bytecode inside it
156     if (!super.transfer(_to, _value)) throw; // do a normal token transfer
157     if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
158     return true;
159   }
160 
161   function transferFrom(address _from, address _to, uint _value, bytes _data) returns (bool success) {
162     if (!super.transferFrom(_from, _to, _value)) throw; // do a normal token transfer
163     if (isContract(_to)) return contractFallback(_from, _to, _value, _data);
164     return true;
165   }
166 
167   function transfer(address _to, uint _value) returns (bool success) {
168     return transfer(_to, _value, new bytes(0));
169   }
170 
171   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
172     return transferFrom(_from, _to, _value, new bytes(0));
173   }
174 
175   //function that is called when transaction target is a contract
176   function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {
177     ERC223Receiver receiver = ERC223Receiver(_to);
178     return receiver.tokenFallback(msg.sender, _origin, _value, _data);
179   }
180 
181   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
182   function isContract(address _addr) private returns (bool is_contract) {
183     // retrieve the size of the code on target address, this needs assembly
184     uint length;
185     assembly { length := extcodesize(_addr) }
186     return length > 0;
187   }
188   
189   // returns krown balance of given address 	
190   function balanceOf(address _owner) constant returns (uint balance) {
191     return balances[_owner];
192   }
193 	
194 }