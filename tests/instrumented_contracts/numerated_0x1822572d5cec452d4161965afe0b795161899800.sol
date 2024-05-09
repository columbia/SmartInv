1 contract ERC20Basic {
2   uint public totalSupply;
3   function balanceOf(address who) constant returns (uint);
4   function transfer(address to, uint value);
5   event Transfer(address indexed from, address indexed to, uint value);
6 }
7 
8 contract ERC20 is ERC20Basic {
9   function allowance(address owner, address spender) constant returns (uint);
10   function transferFrom(address from, address to, uint value);
11   function approve(address spender, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 
16 contract owned {
17     address public owner;
18 
19     function owned() {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     function transferOwnership(address newOwner) onlyOwner {
29         owner = newOwner;
30     }
31 }
32 
33 
34 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
35 
36 contract ParentToken {
37 
38      /* library used for calculations */
39     using SafeMath for uint256; 
40 
41     /* Public variables of the token */
42     string public name;
43     string public symbol;
44     uint8 public decimals;
45     uint256 public totalSupply;
46 
47     mapping(address => uint) balances;
48     mapping(address => mapping(address=>uint)) allowance;        
49 
50 
51 
52     /* Initializes contract with initial supply tokens to the creator of the contract */
53     function ParentToken(uint256 currentSupply,
54         string tokenName,
55         uint8 decimalUnits,
56         string tokenSymbol){
57             
58        balances[msg.sender] =  currentSupply;    // Give the creator all initial tokens  
59        totalSupply = currentSupply;              // Update total supply 
60        name = tokenName;                         // Set the name for display purposes
61        decimals = decimalUnits;                  // Decimals for the tokens
62        symbol = tokenSymbol;					// Set the symbol for display purposes	
63     }
64     
65     
66 
67    ///@notice Transfer tokens to the beneficiary account
68    ///@param  to The beneficiary account
69    ///@param  value The amount of tokens to be transfered  
70        function transfer(address to, uint value) returns (bool success){
71         require(
72             balances[msg.sender] >= value 
73             && value > 0 
74             );
75             balances[msg.sender] = balances[msg.sender].sub(value);    
76             balances[to] = balances[to].add(value);
77             return true;
78     }
79     
80 	///@notice Allow another contract to spend some tokens in your behalf
81 	///@param  spender The address authorized to spend 
82 	///@param  value The amount to be approved 
83     function approve(address spender, uint256 value)
84         returns (bool success) {
85         allowance[msg.sender][spender] = value;
86         return true;
87     }
88 
89     ///@notice Approve and then communicate the approved contract in a single tx
90 	///@param  spender The address authorized to spend 
91 	///@param  value The amount to be approved 
92     function approveAndCall(address spender, uint256 value, bytes extraData)
93         returns (bool success) {    
94         tokenRecipient recSpender = tokenRecipient(spender);
95         if (approve(spender, value)) {
96             recSpender.receiveApproval(msg.sender, value, this, extraData);
97             return true;
98         }
99     }
100 
101 
102 
103    ///@notice Transfer tokens between accounts
104    ///@param  from The benefactor/sender account.
105    ///@param  to The beneficiary account
106    ///@param  value The amount to be transfered  
107     function transferFrom(address from, address to, uint value) returns (bool success){
108         
109         require(
110             allowance[from][msg.sender] >= value
111             &&balances[from] >= value
112             && value > 0
113             );
114             
115             balances[from] = balances[from].sub(value);
116             balances[to] =  balances[to].add(value);
117             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
118             return true;
119         }
120         
121 }
122 
123 
124 
125 library SafeMath {
126   function mul(uint a, uint b) internal returns (uint) {
127     uint c = a * b;
128     assert(a == 0 || c / a == b);
129     return c;
130   }
131   function div(uint a, uint b) internal returns (uint) {
132     assert(b > 0);
133     uint c = a / b;
134     assert(a == b * c + a % b);
135     return c;
136   }
137   function sub(uint a, uint b) internal returns (uint) {
138     assert(b <= a);
139     return a - b;
140   }
141   function add(uint a, uint b) internal returns (uint) {
142     uint c = a + b;
143     assert(c >= a);
144     return c;
145   }
146   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
147     return a >= b ? a : b;
148   }
149   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
150     return a < b ? a : b;
151   }
152   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
153     return a >= b ? a : b;
154   }
155   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
156     return a < b ? a : b;
157   }
158   function assert(bool assertion) internal {
159     if (!assertion) {
160       throw;
161     }
162   }
163 }
164 
165 
166 contract MLC is owned,ParentToken{
167 
168      /* library used for calculations */
169     using SafeMath for uint256; 
170 
171      /* Public variables of the token */
172     string public standard = 'Token 0.1';  
173     uint256 public currentSupply= 2400000000000000;
174     string public constant symbol = "MLC";
175     string public constant tokenName = "Melania";
176     uint8 public constant decimals = 8;
177 
178     
179 
180     mapping (address => bool) public frozenAccount;
181 
182 
183   ///@notice Default function used for any payments made.
184     function () payable {
185         acceptPayment();    
186     }
187    
188 
189    ///@notice Accept payment and transfer to owner account. 
190     function acceptPayment() payable {
191         require(msg.value>0);
192         
193         owner.transfer(msg.value);
194     }
195 
196 
197 
198     function MLC()ParentToken(currentSupply,tokenName,decimals,symbol){}
199 
200 
201    ///@notice Provides balance of the account requested 
202    ///@param  add Address of the account for which balance is being enquired
203     function balanceOf(address add) constant returns (uint balance){
204        return balances[add];
205     }
206     
207     
208     
209    ///@notice Transfer tokens to the beneficiary account
210    ///@param  to The beneficiary account
211    ///@param  value The amount of tokens to be transfered 
212         function transfer(address to, uint value) returns (bool success){
213         require(
214             balances[msg.sender] >= value 
215             && value > 0 
216             && (!frozenAccount[msg.sender]) 										// Allow transfer only if account is not frozen
217             );
218             balances[msg.sender] = balances[msg.sender].sub(value);                 
219             balances[to] = balances[to].add(value);                               // Update the balance of beneficiary account
220 			Transfer(msg.sender,to,value);
221             return true;
222     }
223     
224     
225 
226    ///@notice Transfer tokens between accounts
227    ///@param  from The benefactor/sender account.
228    ///@param  to The beneficiary account
229    ///@param  value The amount to be transfered  
230         function transferFrom(address from, address to, uint value) returns (bool success){
231         
232             require(
233             allowance[from][msg.sender] >= value
234             &&balances[from] >= value                                                 //Check if the benefactor has sufficient balance
235             && value > 0 
236             && (!frozenAccount[msg.sender])                                           // Allow transfer only if account is not frozen
237             );
238             
239             balances[from] = balances[from].sub(value);                               // Deduct from the benefactor account
240             balances[to] =  balances[to].add(value);                                  // Update the balance of beneficiary account
241             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
242             Transfer(from,to,value);
243             return true;
244         }
245         
246     
247 
248    ///@notice Increase the number of coins
249    ///@param  target The address of the account where the coins would be added.
250    ///@param  mintedAmount The amount of coins to be added
251         function mintToken(address target, uint256 mintedAmount) onlyOwner {
252         balances[target] = balances[target].add(mintedAmount);      //Add the amount of coins to be increased to the balance
253         currentSupply = currentSupply.add(mintedAmount);            //Add the amount of coins to be increased to the supply
254         Transfer(0, this, mintedAmount);
255         Transfer(this, target, mintedAmount);
256     }
257 
258    ///@notice Freeze the account at the target address
259    ///@param  target The address of the account to be frozen
260     function freezeAccount(address target, bool freeze) onlyOwner {
261         require(freeze);                                             //Check if account has to be freezed
262         frozenAccount[target] = freeze;                              //Freeze the account  
263         FrozenFunds(target, freeze);
264     }
265 
266 
267    /// @notice Remove tokens from the system irreversibly
268     /// @param value The amount of money to burn
269     function burn(uint256 value) returns (bool success) {
270         require (balances[msg.sender] > value && value>0);            // Check if the sender has enough balance
271         balances[msg.sender] = balances[msg.sender].sub(value);       // Deduct from the sender
272         currentSupply = currentSupply.sub(value);                     // Update currentSupply
273         Burn(msg.sender, value);
274         return true;
275     }
276 
277     function burnFrom(address from, uint256 value) returns (bool success) {
278         require(balances[from] >= value);                                         // Check if the targeted balance is enough
279         require(value <= allowance[from][msg.sender]);                            // Check allowance
280         balances[from] = balances[from].sub(value);                               // Deduct from the targeted balance
281         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);     // Deduct from the sender's allowance
282         currentSupply = currentSupply.sub(value);                                 // Update currentSupply
283         Burn(from, value);
284         return true;
285     }
286 
287 
288 
289   /* This notifies clients about the amount transfered */
290 	event Transfer(address indexed _from, address indexed _to,uint256 _value);     
291 
292   /* This notifies clients about the amount approved */
293 	event Approval(address indexed _owner, address indexed _spender,uint256 _value);
294 
295   /* This notifies clients about the account freeze */
296 	event FrozenFunds(address target, bool frozen);
297     
298   /* This notifies clients about the amount burnt */
299    event Burn(address indexed from, uint256 value);
300 
301 }