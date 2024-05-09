1 pragma solidity ^0.4.16;
2 
3 
4 //Melon Wallet $NGR(Natural Root Growth token mining event ICO contract - melon.business & melonwallet.network 
5 
6 
7 contract SafeMath {
8   function safeMul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 
57 
58 contract ERC20 {
59   uint public totalSupply;
60   function balanceOf(address who) constant returns (uint);
61   function allowance(address owner, address spender) constant returns (uint);
62 
63   function transfer(address to, uint value) returns (bool ok);
64   function transferFrom(address from, address to, uint value) returns (bool ok);
65   function approve(address spender, uint value) returns (bool ok);
66   event Transfer(address indexed from, address indexed to, uint value);
67   event Approval(address indexed owner, address indexed spender, uint value);
68 }
69 
70 
71 
72 
73 contract StandardToken is ERC20, SafeMath {
74 
75   /* Token supply got increased and a new owner received these tokens */
76   event Minted(address receiver, uint amount);
77 
78   /* Actual balances of token holders */
79   mapping(address => uint) balances;
80 
81   /* approve() allowances */
82   mapping (address => mapping (address => uint)) allowed;
83 
84   /* Interface declaration */
85   function isToken() public constant returns (bool weAre) {
86     return true;
87   }
88 
89   function transfer(address _to, uint _value) returns (bool success) {
90       
91       if (_value < 1) {
92           revert();
93       }
94       
95     balances[msg.sender] = safeSub(balances[msg.sender], _value);
96     balances[_to] = safeAdd(balances[_to], _value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
102       
103       if (_value < 1) {
104           revert();
105       }
106       
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
126     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
127 
128     allowed[msg.sender][_spender] = _value;
129     Approval(msg.sender, _spender, _value);
130     return true;
131   }
132 
133   function allowance(address _owner, address _spender) constant returns (uint remaining) {
134     return allowed[_owner][_spender];
135   }
136 
137 }
138 
139 
140 
141 
142 
143 //Melon Wallet NGR token buying contract - melon.business & melonwallet.network 
144 
145 contract MelonWallet is StandardToken {
146   
147     
148     uint256 public rate = 100000000000000000000000;	 //Each ETH will get you 100K NGR Melon Wallet Tokens
149     address public owner = msg.sender;		 //Record the owner of the contract
150 	uint256 public tokenAmount = 210000000000000000000000;
151   
152     function name() constant returns (string) { return "Melon Wallet"; }
153     function symbol() constant returns (string) { return "NGR"; }
154     function decimals() constant returns (uint8) { return 18; }
155 	
156 
157 
158   function mint(address receiver, uint amount) public {
159       
160      tokenAmount = ((msg.value*rate)/(1 ether));		//calculate the amount of tokens to give
161       
162     if (totalSupply > 6000000000000000000000000) {        //Make sure that no more than 6 million NGR can be made.
163         revert();
164     }
165     
166     if (balances[msg.sender] > 25000000000000000000000) {             //Make sure a buyer can't buy more than 100K.
167         revert();
168     }
169     
170     if (balances[msg.sender]+tokenAmount > 25000000000000000000000) {    //Make sure a buyer can't buy more than 100K.
171         revert();
172     }
173     
174     if (tokenAmount > 25000000000000000000000) {          //Make sure a buyer can't buy more than 100K.
175         revert();
176     }
177     
178 	if ((tokenAmount+totalSupply) > 6000000000000000000000000) {      //Make sure that no more than 6 million NGR can be made.
179         revert();
180     }
181 
182       if (amount != ((msg.value*rate)/1 ether)) {       //prevent minting tokens by calling this function directly.
183           revert();
184       }
185       
186       if (msg.value <= 0) {                 //Extra precaution to contract attack
187           revert();
188       }
189       
190       if (amount < 1) {                     //Extra precaution to contract attack
191           revert();
192       }
193 
194     totalSupply = safeAdd(totalSupply, amount);
195     balances[receiver] = safeAdd(balances[receiver], amount);
196 
197     // This will make the mint transaction apper in EtherScan.io
198     // We can remove this after there is a standardized minting event
199     Transfer(0, receiver, amount);
200   }
201 
202   
203   
204 	//This function is called when Ether is sent to the Melon Wallet contract address
205 	//Even if 0 ether is sent.
206 function () payable {
207     
208     if (balances[msg.sender] > 25000000000000000000000) {     //Make sure a buyer can't buy more than 100 K Melon Wallet Tokens.
209         revert();
210     }
211     
212     if (totalSupply > 6000000000000000000000000) {        //Make sure that no more than 6 million NGR can be made.
213         revert();
214     }
215     
216 
217 	if (msg.value <= 0) {		//If zero or less ether is sent, refund user. 
218 		revert();
219 	}
220 	
221 
222 	tokenAmount = 210000000000000000000000;						//set the 'amount' var back to zero
223 	tokenAmount = ((msg.value*rate)/(1 ether));		//calculate the amount of tokens to give
224 	
225     if (balances[msg.sender]+tokenAmount > 25000000000000000000000) {     //Make sure a buyer can't buy more than 100 K Melon Wallet Tokens.
226         revert();
227     }
228 	
229     if (tokenAmount > 25000000000000000000000) {          //Make sure a buyer can't buy more than 100K Melon Wallet Tokens.
230         revert();
231     }
232 	
233 	if (tokenAmount < 1) {
234         revert();
235     }
236     
237 	if ((tokenAmount+totalSupply) > 6000000000000000000000000) {      //Make sure that no more than 6 million NGR can be made.
238         revert();
239     }
240       
241 	mint(msg.sender, tokenAmount);
242 
243 		
244 	owner.transfer(msg.value);					//Send the ETH
245 
246 }  
247   
248      function MelonWallet() {
249         balances[msg.sender] = 210000000000000000000000; 
250      }
251   
252 }