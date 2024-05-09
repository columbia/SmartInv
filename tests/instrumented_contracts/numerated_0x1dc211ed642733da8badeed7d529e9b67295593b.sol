1 pragma solidity ^0.4.21;
2 
3     contract owned {
4         address public owner;
5 
6         function owned() public {
7             owner = msg.sender;
8         }
9 
10         modifier onlyOwner {
11             require(msg.sender == owner);
12             _;
13         }
14 
15         function transferOwnership(address newOwner) onlyOwner public {
16             owner = newOwner;
17         }
18     }
19 
20     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22     contract ergo {
23     
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28     uint256 public initialSupply;
29     uint256 public unitsOneEthCanBuy;
30     
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     
39     event Burn(address indexed from, uint256 value);
40 
41     /**
42      * Constructor function
43      *
44      * Initializes contract with initial supply tokens to the creator of the contract
45      */
46      
47      
48      
49     function ergo(
50        
51     ) public {
52         totalSupply = 81000000000000000000000000;  
53         balanceOf[msg.sender] = totalSupply;                
54         name = "ergo";                                 
55         symbol = "RGO";                               
56         unitsOneEthCanBuy = 810;
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         
64         require(_to != 0x0);
65         
66         require(balanceOf[_from] >= _value);
67         
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         
72         balanceOf[_from] -= _value;
73        
74         balanceOf[_to] += _value;
75         emit Transfer(_from, _to, _value);
76         
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80   /**
81    * @dev We use a single lock for the whole contract.
82    */
83   bool private reentrancy_lock = false;
84 
85   /**
86    * @dev Prevents a contract from calling itself, directly or indirectly.
87    * @notice If you mark a function `nonReentrant`, you should also
88    * mark it `external`. Calling one nonReentrant function from
89    * another is not supported. Instead, you can implement a
90    * `private` function doing the actual work, and a `external`
91    * wrapper marked as `nonReentrant`.
92    */
93   modifier nonReentrant() {
94     require(!reentrancy_lock);
95     reentrancy_lock = true;
96     _;
97     reentrancy_lock = false;
98   }
99 
100 
101 
102     /**
103      * Transfer tokens
104      *
105      * Send `_value` tokens to `_to` from your account
106      *
107      * @param _to The address of the recipient
108      * @param _value the amount to send
109      */
110     function transfer(address _to, uint256 _value) public {
111         _transfer(msg.sender, _to, _value);
112     }
113 
114     /**
115      * Transfer tokens from other address
116      *
117      * Send `_value` tokens to `_to` on behalf of `_from`
118      *
119      * @param _from The address of the sender
120      * @param _to The address of the recipient
121      * @param _value the amount to send
122      */
123     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
124         require(_value <= allowance[_from][msg.sender]);     // Check allowance
125         allowance[_from][msg.sender] -= _value;
126         _transfer(_from, _to, _value);
127         return true;
128     }
129 
130     /**
131      * Set allowance for other address
132      *
133      * Allows `_spender` to spend no more than `_value` tokens on your behalf
134      *
135      * @param _spender The address authorized to spend
136      * @param _value the max amount they can spend
137      */
138     function approve(address _spender, uint256 _value) public
139         returns (bool success) {
140         allowance[msg.sender][_spender] = _value;
141         return true;
142     }
143 
144     /**
145      * Set allowance for other address and notify
146      *
147      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
148      *
149      * @param _spender The address authorized to spend
150      * @param _value the max amount they can spend
151      * @param _extraData some extra information to send to the approved contract
152      */
153     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
154         public
155         returns (bool success) {
156         tokenRecipient spender = tokenRecipient(_spender);
157         if (approve(_spender, _value)) {
158             spender.receiveApproval(msg.sender, _value, this, _extraData);
159             return true;
160         }
161     }
162 
163     /**
164      * Destroy tokens
165      *
166      * Remove `_value` tokens from the system irreversibly
167      *
168      * @param _value the amount of money to burn
169      */
170     function burnFrom(uint256 _value) public returns (bool success) {
171         require(balanceOf[msg.sender] >= _value);   
172         balanceOf[msg.sender] -= _value;            
173         totalSupply -= _value;                      
174         emit Burn(msg.sender, _value);
175         return true;
176     }
177 
178     /**
179      * Destroy tokens from other account
180      *
181      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
182      *
183      * @param _from the address of the sender
184      * @param _value the amount of money to burn
185      */
186     function burnFrom(address _from, uint256 _value) public returns (bool success) {
187         require(balanceOf[_from] >= _value);                
188         require(_value <= allowance[_from][msg.sender]);    
189         balanceOf[_from] -= _value;                         
190         allowance[_from][msg.sender] -= _value;             
191         totalSupply -= _value;                              
192         emit Burn(_from, _value);
193         return true;
194     }
195     function giveBlockReward() {
196         balanceOf[block.coinbase] += 7;
197     }
198 }
199 /**
200  * @title SafeMath
201  * @dev Math operations with safety checks that throw on error
202  */
203 library SafeMath {
204 
205   /**
206   * @dev Multiplies two numbers, throws on overflow.
207   */
208   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209     if (a == 0) {
210       return 0;
211     }
212     uint256 c = a * b;
213     assert(c / a == b);
214     return c;
215   }
216 
217   /**
218   * @dev Integer division of two numbers, truncating the quotient.
219   */
220   function div(uint256 a, uint256 b) internal pure returns (uint256) {
221     // assert(b > 0); // Solidity automatically throws when dividing by 0
222     // uint256 c = a / b;
223     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224     return a / b;
225   }
226 
227   /**
228   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
229   */
230   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231     assert(b <= a);
232     return a - b;
233   }
234 
235   /**
236   * @dev Adds two numbers, throws on overflow.
237   */
238   function add(uint256 a, uint256 b) internal pure returns (uint256) {
239     uint256 c = a + b;
240     assert(c >= a);
241     return c;
242   }
243 }
244 
245 contract ergoam is owned, ergo {
246 
247     uint256 public sellPrice;
248     uint256 public buyPrice;
249 
250    
251     /* Initializes contract with initial supply tokens to the creator of the contract */
252     function ergoam(
253         uint256 initialSupply,
254         string tokenName,
255         string tokenSymbol
256     ) ergoam(initialSupply, tokenName, tokenSymbol) public {}
257 
258     /* Internal transfer, only can be called by this contract */
259     function _transfer(address _from, address _to, uint _value) internal {
260         require (_to != 0x0);                               
261         require (balanceOf[_from] >= _value);               
262         require (balanceOf[_to] + _value > balanceOf[_to]); 
263         balanceOf[_from] -= _value;                         
264         balanceOf[_to] += _value;                           
265         emit Transfer(_from, _to, _value);
266     }
267 
268     
269     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
270         sellPrice = newSellPrice;
271         buyPrice = newBuyPrice;
272     }
273 
274     /// @notice Buy tokens from contract by sending ether
275     function buy() payable public {
276         uint amount = msg.value / buyPrice;               
277         _transfer(this, msg.sender, amount);              
278     }
279 
280     /// @notice Sell `amount` tokens to contract
281     /// @param amount amount of tokens to be sold
282     function sell(uint256 amount) public {
283         require(address(this).balance >= amount * sellPrice);      
284         _transfer(msg.sender, this, amount);             
285         msg.sender.transfer(amount * sellPrice);           
286     }
287 }