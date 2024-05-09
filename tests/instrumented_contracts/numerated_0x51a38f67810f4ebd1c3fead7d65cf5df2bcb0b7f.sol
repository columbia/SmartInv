1 pragma solidity ^0.4.11;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal constant returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
47 
48 contract ParentToken {
49 
50      /* library used for calculations */
51     using SafeMath for uint256; 
52 
53     /* Public variables of the token */
54     string public name;
55     string public symbol;
56     uint8 public decimals;
57     uint256 public totalSupply;
58 
59     mapping(address => uint) balances;
60     mapping(address => mapping(address=>uint)) allowance;        
61 
62 
63 
64     /* Initializes contract with initial supply tokens to the creator of the contract */
65     function ParentToken(uint256 currentSupply,
66         string tokenName,
67         uint8 decimalUnits,
68         string tokenSymbol){
69             
70        balances[msg.sender] =  currentSupply;    // Give the creator all initial tokens  
71        totalSupply = currentSupply;              // Update total supply 
72        name = tokenName;                         // Set the name for display purposes
73        decimals = decimalUnits;                  // Decimals for the tokens
74        symbol = tokenSymbol;					// Set the symbol for display purposes	
75     }
76     
77     
78 
79    ///@notice Transfer tokens to the beneficiary account
80    ///@param  to The beneficiary account
81    ///@param  value The amount of tokens to be transfered  
82        function transfer(address to, uint value) returns (bool success){
83         require(
84             balances[msg.sender] >= value 
85             && value > 0 
86             );
87             balances[msg.sender] = balances[msg.sender].sub(value);    
88             balances[to] = balances[to].add(value);
89             return true;
90     }
91     
92 	///@notice Allow another contract to spend some tokens in your behalf
93 	///@param  spender The address authorized to spend 
94 	///@param  value The amount to be approved 
95     function approve(address spender, uint256 value)
96         returns (bool success) {
97         allowance[msg.sender][spender] = value;
98         return true;
99     }
100 
101     ///@notice Approve and then communicate the approved contract in a single tx
102 	///@param  spender The address authorized to spend 
103 	///@param  value The amount to be approved 
104     function approveAndCall(address spender, uint256 value, bytes extraData)
105         returns (bool success) {    
106         tokenRecipient recSpender = tokenRecipient(spender);
107         if (approve(spender, value)) {
108             recSpender.receiveApproval(msg.sender, value, this, extraData);
109             return true;
110         }
111     }
112 
113 
114 
115    ///@notice Transfer tokens between accounts
116    ///@param  from The benefactor/sender account.
117    ///@param  to The beneficiary account
118    ///@param  value The amount to be transfered  
119     function transferFrom(address from, address to, uint value) returns (bool success){
120         
121         require(
122             allowance[from][msg.sender] >= value
123             &&balances[from] >= value
124             && value > 0
125             );
126             
127             balances[from] = balances[from].sub(value);
128             balances[to] =  balances[to].add(value);
129             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
130             return true;
131         }
132         
133 }
134 
135 
136 contract GlobalBTC is owned,ParentToken{
137 
138      /* library used for calculations */
139     using SafeMath for uint256; 
140 
141      /* Public variables of the token */
142     string public standard = 'Token 0.1';  
143     uint256 public currentSupply= 3000000000000000;
144     string public constant symbol = "GBTC";
145     string public constant tokenName = "GlobalBTC";
146     uint8 public constant decimals = 8;
147 
148     
149 
150     mapping (address => bool) public frozenAccount;
151 
152 
153   ///@notice Default function used for any payments made.
154     function () payable {
155         acceptPayment();    
156     }
157    
158 
159    ///@notice Accept payment and transfer to owner account. 
160     function acceptPayment() payable {
161         require(msg.value>0);
162         
163         owner.transfer(msg.value);
164     }
165 
166 
167 
168     function GlobalBTC()ParentToken(currentSupply,tokenName,decimals,symbol){}
169 
170 
171    ///@notice Provides balance of the account requested 
172    ///@param  add Address of the account for which balance is being enquired
173     function balanceOf(address add) constant returns (uint balance){
174        return balances[add];
175     }
176     
177     
178     
179    ///@notice Transfer tokens to the beneficiary account
180    ///@param  to The beneficiary account
181    ///@param  value The amount of tokens to be transfered 
182         function transfer(address to, uint value) returns (bool success){
183         require(
184             balances[msg.sender] >= value 
185             && value > 0 
186             && (!frozenAccount[msg.sender]) 										// Allow transfer only if account is not frozen
187             );
188             balances[msg.sender] = balances[msg.sender].sub(value);                 
189             balances[to] = balances[to].add(value);                               // Update the balance of beneficiary account
190 			Transfer(msg.sender,to,value);
191             return true;
192     }
193     
194     
195 
196    ///@notice Transfer tokens between accounts
197    ///@param  from The benefactor/sender account.
198    ///@param  to The beneficiary account
199    ///@param  value The amount to be transfered  
200         function transferFrom(address from, address to, uint value) returns (bool success){
201         
202             require(
203             allowance[from][msg.sender] >= value
204             &&balances[from] >= value                                                 //Check if the benefactor has sufficient balance
205             && value > 0 
206             && (!frozenAccount[msg.sender])                                           // Allow transfer only if account is not frozen
207             );
208             
209             balances[from] = balances[from].sub(value);                               // Deduct from the benefactor account
210             balances[to] =  balances[to].add(value);                                  // Update the balance of beneficiary account
211             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
212             Transfer(from,to,value);
213             return true;
214         }
215         
216     
217 
218    ///@notice Increase the number of coins
219    ///@param  target The address of the account where the coins would be added.
220    ///@param  mintedAmount The amount of coins to be added
221         function mintToken(address target, uint256 mintedAmount) onlyOwner {
222         balances[target] = balances[target].add(mintedAmount);      //Add the amount of coins to be increased to the balance
223         currentSupply = currentSupply.add(mintedAmount);            //Add the amount of coins to be increased to the supply
224         Transfer(0, this, mintedAmount);
225         Transfer(this, target, mintedAmount);
226     }
227 
228    ///@notice Freeze the account at the target address
229    ///@param  target The address of the account to be frozen
230     function freezeAccount(address target, bool freeze) onlyOwner {
231         require(freeze);                                             //Check if account has to be freezed
232         frozenAccount[target] = freeze;                              //Freeze the account  
233         FrozenFunds(target, freeze);
234     }
235 
236 
237    /// @notice Remove tokens from the system irreversibly
238     /// @param value The amount of money to burn
239     function burn(uint256 value) onlyOwner returns (bool success)  {
240         require (balances[msg.sender] > value && value>0);            // Check if the sender has enough balance
241         balances[msg.sender] = balances[msg.sender].sub(value);       // Deduct from the sender
242         currentSupply = currentSupply.sub(value);                     // Update currentSupply
243         Burn(msg.sender, value);
244         return true;
245     }
246 
247     function burnFrom(address from, uint256 value) onlyOwner returns (bool success) {
248         require(balances[from] >= value);                                         // Check if the targeted balance is enough
249         require(value <= allowance[from][msg.sender]);                            // Check allowance
250         balances[from] = balances[from].sub(value);                               // Deduct from the targeted balance
251         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);     // Deduct from the sender's allowance
252         currentSupply = currentSupply.sub(value);                                 // Update currentSupply
253         Burn(from, value);
254         return true;
255     }
256 
257 
258 
259   /* This notifies clients about the amount transfered */
260 	event Transfer(address indexed _from, address indexed _to,uint256 _value);     
261 
262   /* This notifies clients about the amount approved */
263 	event Approval(address indexed _owner, address indexed _spender,uint256 _value);
264 
265   /* This notifies clients about the account freeze */
266 	event FrozenFunds(address target, bool frozen);
267     
268   /* This notifies clients about the amount burnt */
269    event Burn(address indexed from, uint256 value);
270 
271 }