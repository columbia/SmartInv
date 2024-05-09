1 contract owned {
2     address public owner;
3 
4     function owned() {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner {
14         owner = newOwner;
15     }
16 }
17 
18 
19 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
20 
21 contract ParentToken {
22 
23      /* library used for calculations */
24     using SafeMath for uint256; 
25 
26     /* Public variables of the token */
27     string public name;
28     string public symbol;
29     uint8 public decimals;
30     uint256 public totalSupply;
31 
32     mapping(address => uint) balances;
33     mapping(address => mapping(address=>uint)) allowance;        
34 
35 
36 
37     /* Initializes contract with initial supply tokens to the creator of the contract */
38     function ParentToken(uint256 currentSupply,
39         string tokenName,
40         uint8 decimalUnits,
41         string tokenSymbol){
42             
43        balances[msg.sender] =  currentSupply;    // Give the creator all initial tokens  
44        totalSupply = currentSupply;              // Update total supply 
45        name = tokenName;                         // Set the name for display purposes
46        decimals = decimalUnits;                  // Decimals for the tokens
47        symbol = tokenSymbol;					// Set the symbol for display purposes	
48     }
49     
50     
51 
52    ///@notice Transfer tokens to the beneficiary account
53    ///@param  to The beneficiary account
54    ///@param  value The amount of tokens to be transfered  
55        function transfer(address to, uint value) returns (bool success){
56         require(
57             balances[msg.sender] >= value 
58             && value > 0 
59             );
60             balances[msg.sender] = balances[msg.sender].sub(value);    
61             balances[to] = balances[to].add(value);
62             return true;
63     }
64     
65 	///@notice Allow another contract to spend some tokens in your behalf
66 	///@param  spender The address authorized to spend 
67 	///@param  value The amount to be approved 
68     function approve(address spender, uint256 value)
69         returns (bool success) {
70         allowance[msg.sender][spender] = value;
71         return true;
72     }
73 
74     ///@notice Approve and then communicate the approved contract in a single tx
75 	///@param  spender The address authorized to spend 
76 	///@param  value The amount to be approved 
77     function approveAndCall(address spender, uint256 value, bytes extraData)
78         returns (bool success) {    
79         tokenRecipient recSpender = tokenRecipient(spender);
80         if (approve(spender, value)) {
81             recSpender.receiveApproval(msg.sender, value, this, extraData);
82             return true;
83         }
84     }
85 
86 
87 
88    ///@notice Transfer tokens between accounts
89    ///@param  from The benefactor/sender account.
90    ///@param  to The beneficiary account
91    ///@param  value The amount to be transfered  
92     function transferFrom(address from, address to, uint value) returns (bool success){
93         
94         require(
95             allowance[from][msg.sender] >= value
96             &&balances[from] >= value
97             && value > 0
98             );
99             
100             balances[from] = balances[from].sub(value);
101             balances[to] =  balances[to].add(value);
102             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
103             return true;
104         }
105         
106 }
107 
108 
109 contract Cremit is owned,ParentToken{
110 
111      /* library used for calculations */
112     using SafeMath for uint256; 
113 
114      /* Public variables of the token */
115     string public standard = 'Token 0.1';  
116     uint256 public currentSupply= 21000000000000000;
117     string public constant symbol = "CRMT";
118     string public constant tokenName = "Cremit";
119     uint8 public constant decimals = 8;
120 
121     
122 
123     mapping (address => bool) public frozenAccount;
124 
125 
126   ///@notice Default function used for any payments made.
127     function () payable {
128         acceptPayment();    
129     }
130    
131 
132    ///@notice Accept payment and transfer to owner account. 
133     function acceptPayment() payable {
134         require(msg.value>0);
135         
136         owner.transfer(msg.value);
137     }
138 
139 
140 
141     function Cremit()ParentToken(currentSupply,tokenName,decimals,symbol){}
142 
143 
144    ///@notice Provides balance of the account requested 
145    ///@param  add Address of the account for which balance is being enquired
146     function balanceOf(address add) constant returns (uint balance){
147        return balances[add];
148     }
149     
150     
151     
152    ///@notice Transfer tokens to the beneficiary account
153    ///@param  to The beneficiary account
154    ///@param  value The amount of tokens to be transfered 
155         function transfer(address to, uint value) returns (bool success){
156         require(
157             balances[msg.sender] >= value 
158             && value > 0 
159             && (!frozenAccount[msg.sender]) 										// Allow transfer only if account is not frozen
160             );
161             balances[msg.sender] = balances[msg.sender].sub(value);                 
162             balances[to] = balances[to].add(value);                               // Update the balance of beneficiary account
163 			Transfer(msg.sender,to,value);
164             return true;
165     }
166     
167     
168 
169    ///@notice Transfer tokens between accounts
170    ///@param  from The benefactor/sender account.
171    ///@param  to The beneficiary account
172    ///@param  value The amount to be transfered  
173         function transferFrom(address from, address to, uint value) returns (bool success){
174         
175             require(
176             allowance[from][msg.sender] >= value
177             &&balances[from] >= value                                                 //Check if the benefactor has sufficient balance
178             && value > 0 
179             && (!frozenAccount[msg.sender])                                           // Allow transfer only if account is not frozen
180             );
181             
182             balances[from] = balances[from].sub(value);                               // Deduct from the benefactor account
183             balances[to] =  balances[to].add(value);                                  // Update the balance of beneficiary account
184             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
185             Transfer(from,to,value);
186             return true;
187         }
188         
189     
190 
191    ///@notice Increase the number of coins
192    ///@param  target The address of the account where the coins would be added.
193    ///@param  mintedAmount The amount of coins to be added
194         function mintToken(address target, uint256 mintedAmount) onlyOwner {
195         balances[target] = balances[target].add(mintedAmount);      //Add the amount of coins to be increased to the balance
196         currentSupply = currentSupply.add(mintedAmount);            //Add the amount of coins to be increased to the supply
197         Transfer(0, this, mintedAmount);
198         Transfer(this, target, mintedAmount);
199     }
200 
201    ///@notice Freeze the account at the target address
202    ///@param  target The address of the account to be frozen
203     function freezeAccount(address target, bool freeze) onlyOwner {
204         require(freeze);                                             //Check if account has to be freezed
205         frozenAccount[target] = freeze;                              //Freeze the account  
206         FrozenFunds(target, freeze);
207     }
208 
209 
210    /// @notice Remove tokens from the system irreversibly
211     /// @param value The amount of money to burn
212     function burn(uint256 value) onlyOwner returns (bool success)  {
213         require (balances[msg.sender] > value && value>0);            // Check if the sender has enough balance
214         balances[msg.sender] = balances[msg.sender].sub(value);       // Deduct from the sender
215         currentSupply = currentSupply.sub(value);                     // Update currentSupply
216         Burn(msg.sender, value);
217         return true;
218     }
219 
220     function burnFrom(address from, uint256 value) onlyOwner returns (bool success) {
221         require(balances[from] >= value);                                         // Check if the targeted balance is enough
222         require(value <= allowance[from][msg.sender]);                            // Check allowance
223         balances[from] = balances[from].sub(value);                               // Deduct from the targeted balance
224         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);     // Deduct from the sender's allowance
225         currentSupply = currentSupply.sub(value);                                 // Update currentSupply
226         Burn(from, value);
227         return true;
228     }
229 
230 
231 
232   /* This notifies clients about the amount transfered */
233 	event Transfer(address indexed _from, address indexed _to,uint256 _value);     
234 
235   /* This notifies clients about the amount approved */
236 	event Approval(address indexed _owner, address indexed _spender,uint256 _value);
237 
238   /* This notifies clients about the account freeze */
239 	event FrozenFunds(address target, bool frozen);
240     
241   /* This notifies clients about the amount burnt */
242    event Burn(address indexed from, uint256 value);
243 
244 }
245 
246 contract IERC20 {
247     
248     function balanceOf(address _owner) constant returns (uint256 balance);
249     function transfer(address _to, uint256 _value) returns (bool success);
250     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
251     function approve(address _spender, uint256 _value) returns (bool success);
252     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
253     
254     event Transfer(address indexed _from, address indexed _to, uint256 _value);
255     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
256 }
257 
258 
259 library SafeMath {
260   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
261     uint256 c = a * b;
262     assert(a == 0 || c / a == b);
263     return c;
264   }
265 
266   function div(uint256 a, uint256 b) internal constant returns (uint256) {
267     // assert(b > 0); // Solidity automatically throws when dividing by 0
268     uint256 c = a / b;
269     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
270     return c;
271   }
272 
273   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
274     assert(b <= a);
275     return a - b;
276   }
277 
278   function add(uint256 a, uint256 b) internal constant returns (uint256) {
279     uint256 c = a + b;
280     assert(c >= a);
281     return c;
282   }
283 }