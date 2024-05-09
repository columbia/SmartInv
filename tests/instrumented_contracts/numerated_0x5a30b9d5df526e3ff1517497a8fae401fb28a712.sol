1 pragma solidity ^0.4.14;
2 
3 
4 //PoW Farm SEED token buying contract
5 //http://www.PoWFarm.io
6 
7 
8 contract SafeMath {
9   function safeMul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function safeDiv(uint a, uint b) internal returns (uint) {
16     assert(b > 0);
17     uint c = a / b;
18     assert(a == b * c + a % b);
19     return c;
20   }
21 
22   function safeSub(uint a, uint b) internal returns (uint) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function safeAdd(uint a, uint b) internal returns (uint) {
28     uint c = a + b;
29     assert(c>=a && c>=b);
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
46     return a < b ? a : b;
47   }
48 
49   function assert(bool assertion) internal {
50     if (!assertion) {
51       throw;
52     }
53   }
54 }
55 
56 
57 
58 
59 contract ERC20 {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function allowance(address owner, address spender) constant returns (uint);
63 
64   function transfer(address to, uint value) returns (bool ok);
65   function transferFrom(address from, address to, uint value) returns (bool ok);
66   function approve(address spender, uint value) returns (bool ok);
67   event Transfer(address indexed from, address indexed to, uint value);
68   event Approval(address indexed owner, address indexed spender, uint value);
69 }
70 
71 
72 
73 
74 contract StandardToken is ERC20, SafeMath {
75 
76   /* Token supply got increased and a new owner received these tokens */
77   event Minted(address receiver, uint amount);
78 
79   /* Actual balances of token holders */
80   mapping(address => uint) balances;
81 
82   /* approve() allowances */
83   mapping (address => mapping (address => uint)) allowed;
84 
85   /* Interface declaration */
86   function isToken() public constant returns (bool weAre) {
87     return true;
88   }
89 
90   function transfer(address _to, uint _value) returns (bool success) {
91       
92       if (_value < 1) {
93           revert();
94       }
95       
96     balances[msg.sender] = safeSub(balances[msg.sender], _value);
97     balances[_to] = safeAdd(balances[_to], _value);
98     Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
103       
104       if (_value < 1) {
105           revert();
106       }
107       
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
142 
143 
144 //PoW Farm SEED token buying contract
145 //http://www.PoWFarm.io
146 
147 contract MintableToken is StandardToken {
148   
149     
150     uint256 public rate = 5000;				//Each ETH will get you 5000 SEED - Minimum: 0.0002 ETH for 1 SEED
151     address public owner = msg.sender;		//Record the owner of the contract
152 	uint256 public tokenAmount;
153   
154     function name() constant returns (string) { return "SEED"; }
155     function symbol() constant returns (string) { return "SEED"; }
156     function decimals() constant returns (uint8) { return 0; }
157 	
158 
159 
160   function mint(address receiver, uint amount) public {
161 
162       if (amount != ((msg.value*rate)/1 ether)) {       //prevent minting tokens by calling this function directly.
163           revert();
164       }
165       
166       if (msg.value <= 0) {                 //Extra precaution to contract attack
167           revert();
168       }
169       
170       if (amount < 1) {                     //Extra precaution to contract attack
171           revert();
172       }
173 
174     totalSupply = safeAdd(totalSupply, amount);
175     balances[receiver] = safeAdd(balances[receiver], amount);
176 
177     // This will make the mint transaction apper in EtherScan.io
178     // We can remove this after there is a standardized minting event
179     Transfer(0, receiver, amount);
180   }
181 
182   
183   
184 	//This function is called when Ether is sent to the contract address
185 	//Even if 0 ether is sent.
186 function () payable {
187 	    
188 	if (msg.value <= 0) {		//If zero or less ether is sent, refund user. 
189 		revert();
190 	}
191 	
192 		
193 	tokenAmount = 0;								//set the 'amount' var back to zero
194 	tokenAmount = ((msg.value*rate)/(1 ether));		//calculate the amount of tokens to give
195 	
196 	if (tokenAmount < 1) {
197         revert();
198     }
199       
200 	mint(msg.sender, tokenAmount);
201 	tokenAmount = 0;							//set the 'amount' var back to zero
202 		
203 		
204 	owner.transfer(msg.value);					//Send the ETH to PoW Farm.
205 
206 }  
207   
208   
209   
210 }