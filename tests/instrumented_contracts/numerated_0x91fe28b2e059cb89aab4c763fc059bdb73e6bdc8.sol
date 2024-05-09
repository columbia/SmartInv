1 pragma solidity ^0.4.14;
2 
3 
4 contract SafeMath {
5   function safeMul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeDiv(uint a, uint b) internal returns (uint) {
12     assert(b > 0);
13     uint c = a / b;
14     assert(a == b * c + a % b);
15     return c;
16   }
17 
18   function safeSub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function safeAdd(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c>=a && c>=b);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) {
47       throw;
48     }
49   }
50 }
51 
52 
53 
54 
55 contract ERC20 {
56   uint public totalSupply;
57   function balanceOf(address who) constant returns (uint);
58   function allowance(address owner, address spender) constant returns (uint);
59 
60   function transfer(address to, uint value) returns (bool ok);
61   function transferFrom(address from, address to, uint value) returns (bool ok);
62   function approve(address spender, uint value) returns (bool ok);
63   event Transfer(address indexed from, address indexed to, uint value);
64   event Approval(address indexed owner, address indexed spender, uint value);
65 }
66 
67 
68 
69 
70 contract StandardToken is ERC20, SafeMath {
71 
72   /* Token supply got increased and a new owner received these tokens */
73   event Minted(address receiver, uint amount);
74 
75   /* Actual balances of token holders */
76   mapping(address => uint) balances;
77 
78   /* approve() allowances */
79   mapping (address => mapping (address => uint)) allowed;
80 
81   /* Interface declaration */
82   function isToken() public constant returns (bool weAre) {
83     return true;
84   }
85 
86   function transfer(address _to, uint _value) returns (bool success) {
87     balances[msg.sender] = safeSub(balances[msg.sender], _value);
88     balances[_to] = safeAdd(balances[_to], _value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
94     uint _allowance = allowed[_from][msg.sender];
95 
96     balances[_to] = safeAdd(balances[_to], _value);
97     balances[_from] = safeSub(balances[_from], _value);
98     allowed[_from][msg.sender] = safeSub(_allowance, _value);
99     Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   function balanceOf(address _owner) constant returns (uint balance) {
104     return balances[_owner];
105   }
106 
107   function approve(address _spender, uint _value) returns (bool success) {
108 
109     // To change the approve amount you first have to reduce the addresses`
110     //  allowance to zero by calling `approve(_spender, 0)` if it is not
111     //  already 0 to mitigate the race condition described here:
112     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
114 
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
128 
129 
130 
131 contract MintableToken is StandardToken {
132   
133     
134     uint256 public rate = 5000;
135     address public owner = msg.sender;
136 	uint256 public tokenAmount;
137   
138     function name() constant returns (string) { return "kkTest104"; }
139     function symbol() constant returns (string) { return "kT104"; }
140     function decimals() constant returns (uint8) { return 0; }
141 	
142 
143 
144   function mint(address receiver, uint amount) public {
145 
146       if (amount != ((msg.value*rate)/1 ether)) {
147           revert();
148       }
149       
150       if (amount < 1) {
151           revert();
152       }
153 
154     totalSupply = safeAdd(totalSupply, amount);
155     balances[receiver] = safeAdd(balances[receiver], amount);
156 
157     // This will make the mint transaction apper in EtherScan.io
158     // We can remove this after there is a standardized minting event
159     Transfer(0, receiver, amount);
160   }
161 
162   
163   
164 	//This function is called when Ether is sent to the contract address
165 	//Even if 0 ether is sent.
166 function () payable {
167 	    
168 	if (msg.value == 0 || msg.value < 0) {		//If zero ether is sent, kill. Do nothing. 
169 		revert();
170 	}
171 		
172 	tokenAmount = 0;									//set the 'amount' var back to zero
173 	tokenAmount = ((msg.value*rate)/(1 ether));		//calculate the amount of tokens to give
174 	
175 	if (tokenAmount < 1) {
176         revert();
177     }
178       
179 	mint(msg.sender, tokenAmount);
180 	tokenAmount = 0;
181 		
182 		
183 	owner.transfer(msg.value);					//Send the ETH to founder.
184 
185 }  
186   
187   
188   
189 }