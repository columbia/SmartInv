1 pragma solidity ^0.4.11;
2 
3 
4 
5 contract owned {
6     address public owner;
7 
8     function owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner {
18         owner = newOwner;
19     }
20 }
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
53 
54 contract ParentToken {
55 
56      /* library used for calculations */
57     using SafeMath for uint256; 
58 
59     /* Public variables of the token */
60     string public name;
61     string public symbol;
62     uint8 public decimals;
63     uint256 public totalSupply;
64 
65     mapping(address => uint) balances;
66     mapping(address => mapping(address=>uint)) allowance;        
67 
68 
69 
70     /* Initializes contract with initial supply tokens to the creator of the contract */
71     function ParentToken(uint256 currentSupply,
72         string tokenName,
73         uint8 decimalUnits,
74         string tokenSymbol){
75             
76        balances[msg.sender] =  currentSupply;    // Give the creator all initial tokens  
77        totalSupply = currentSupply;              // Update total supply 
78        name = tokenName;                         // Set the name for display purposes
79        decimals = decimalUnits;                  // Decimals for the tokens
80        symbol = tokenSymbol;					// Set the symbol for display purposes	
81     }
82     
83     
84 
85    ///@notice Transfer tokens to the beneficiary account
86    ///@param  to The beneficiary account
87    ///@param  value The amount of tokens to be transfered  
88        function transfer(address to, uint value) returns (bool success){
89         require(
90             balances[msg.sender] >= value 
91             && value > 0 
92             );
93             balances[msg.sender] = balances[msg.sender].sub(value);    
94             balances[to] = balances[to].add(value);
95             return true;
96     }
97     
98 	///@notice Allow another contract to spend some tokens in your behalf
99 	///@param  spender The address authorized to spend 
100 	///@param  value The amount to be approved 
101     function approve(address spender, uint256 value)
102         returns (bool success) {
103         allowance[msg.sender][spender] = value;
104         return true;
105     }
106 
107     ///@notice Approve and then communicate the approved contract in a single tx
108 	///@param  spender The address authorized to spend 
109 	///@param  value The amount to be approved 
110     function approveAndCall(address spender, uint256 value, bytes extraData)
111         returns (bool success) {    
112         tokenRecipient recSpender = tokenRecipient(spender);
113         if (approve(spender, value)) {
114             recSpender.receiveApproval(msg.sender, value, this, extraData);
115             return true;
116         }
117     }
118 
119 
120 
121    ///@notice Transfer tokens between accounts
122    ///@param  from The benefactor/sender account.
123    ///@param  to The beneficiary account
124    ///@param  value The amount to be transfered  
125     function transferFrom(address from, address to, uint value) returns (bool success){
126         
127         require(
128             allowance[from][msg.sender] >= value
129             &&balances[from] >= value
130             && value > 0
131             );
132             
133             balances[from] = balances[from].sub(value);
134             balances[to] =  balances[to].add(value);
135             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
136             return true;
137         }
138         
139 }
140 
141 
142 contract Mitrav is owned,ParentToken{
143 
144      /* library used for calculations */
145     using SafeMath for uint256; 
146 
147      /* Public variables of the token */
148     string public standard = 'Token 0.1';  
149     uint256 public currentSupply= 10000000000000000;
150     string public constant symbol = "MTR";
151     string public constant tokenName = "Mitrav";
152     uint8 public constant decimals = 8;
153 
154     
155 
156     mapping (address => bool) public frozenAccount;
157 
158 
159   ///@notice Default function used for any payments made.
160     function () payable {
161         acceptPayment();    
162     }
163    
164 
165    ///@notice Accept payment and transfer to owner account. 
166     function acceptPayment() payable {
167         require(msg.value>0);
168         
169         owner.transfer(msg.value);
170     }
171 
172 
173 
174     function Mitrav()ParentToken(currentSupply,tokenName,decimals,symbol){}
175 
176 
177    ///@notice Provides balance of the account requested 
178    ///@param  add Address of the account for which balance is being enquired
179     function balanceOf(address add) constant returns (uint balance){
180        return balances[add];
181     }
182     
183     
184     
185    ///@notice Transfer tokens to the beneficiary account
186    ///@param  to The beneficiary account
187    ///@param  value The amount of tokens to be transfered 
188         function transfer(address to, uint value) returns (bool success){
189         require(
190             balances[msg.sender] >= value 
191             && value > 0 
192             && (!frozenAccount[msg.sender]) 										// Allow transfer only if account is not frozen
193             );
194             balances[msg.sender] = balances[msg.sender].sub(value);                 
195             balances[to] = balances[to].add(value);                               // Update the balance of beneficiary account
196 			Transfer(msg.sender,to,value);
197             return true;
198     }
199     
200     
201 
202    ///@notice Transfer tokens between accounts
203    ///@param  from The benefactor/sender account.
204    ///@param  to The beneficiary account
205    ///@param  value The amount to be transfered  
206         function transferFrom(address from, address to, uint value) returns (bool success){
207         
208             require(
209             allowance[from][msg.sender] >= value
210             &&balances[from] >= value                                                 //Check if the benefactor has sufficient balance
211             && value > 0 
212             && (!frozenAccount[msg.sender])                                           // Allow transfer only if account is not frozen
213             );
214             
215             balances[from] = balances[from].sub(value);                               // Deduct from the benefactor account
216             balances[to] =  balances[to].add(value);                                  // Update the balance of beneficiary account
217             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
218             Transfer(from,to,value);
219             return true;
220         }
221         
222     
223 
224    ///@notice Increase the number of coins
225    ///@param  target The address of the account where the coins would be added.
226    ///@param  mintedAmount The amount of coins to be added
227         function mintToken(address target, uint256 mintedAmount) onlyOwner {
228         balances[target] = balances[target].add(mintedAmount);      //Add the amount of coins to be increased to the balance
229         currentSupply = currentSupply.add(mintedAmount);            //Add the amount of coins to be increased to the supply
230         Transfer(0, this, mintedAmount);
231         Transfer(this, target, mintedAmount);
232     }
233 
234    ///@notice Freeze the account at the target address
235    ///@param  target The address of the account to be frozen
236     function freezeAccount(address target, bool freeze) onlyOwner {
237         require(freeze);                                             //Check if account has to be freezed
238         frozenAccount[target] = freeze;                              //Freeze the account  
239         FrozenFunds(target, freeze);
240     }
241 
242 
243    /// @notice Remove tokens from the system irreversibly
244     /// @param value The amount of money to burn
245     function burn(uint256 value) returns (bool success) {
246         require (balances[msg.sender] > value && value>0);            // Check if the sender has enough balance
247         balances[msg.sender] = balances[msg.sender].sub(value);       // Deduct from the sender
248         currentSupply = currentSupply.sub(value);                     // Update currentSupply
249         Burn(msg.sender, value);
250         return true;
251     }
252 
253     function burnFrom(address from, uint256 value) returns (bool success) {
254         require(balances[from] >= value);                                         // Check if the targeted balance is enough
255         require(value <= allowance[from][msg.sender]);                            // Check allowance
256         balances[from] = balances[from].sub(value);                               // Deduct from the targeted balance
257         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);     // Deduct from the sender's allowance
258         currentSupply = currentSupply.sub(value);                                 // Update currentSupply
259         Burn(from, value);
260         return true;
261     }
262 
263 
264 
265   /* This notifies clients about the amount transfered */
266 	event Transfer(address indexed _from, address indexed _to,uint256 _value);     
267 
268   /* This notifies clients about the amount approved */
269 	event Approval(address indexed _owner, address indexed _spender,uint256 _value);
270 
271   /* This notifies clients about the account freeze */
272 	event FrozenFunds(address target, bool frozen);
273     
274   /* This notifies clients about the amount burnt */
275    event Burn(address indexed from, uint256 value);
276 
277 }