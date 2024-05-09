1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balances;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
51         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != 0x0);
62         // Check if the sender has enough
63         
64 
65         require(balances[_from] >= _value);
66         // Check for overflows
67         require(balances[_to] + _value > balances[_to]);
68         // Save this for an assertion in the future
69         uint previousBalances = balances[_from] + balances[_to];
70         // Subtract from the sender
71         balances[_from] -= _value;
72         // Add the same to the recipient
73         balances[_to] += _value;
74         Transfer(_from, _to, _value);
75         // Asserts are used to use static analysis to find bugs in your code. They should never fail
76         assert(balances[_from] + balances[_to] == previousBalances);
77     }
78 
79     /**
80      * Transfer tokens
81      *
82      * Send `_value` tokens to `_to` from your account
83      *
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transfer(address _to, uint256 _value) public {
88         _transfer(msg.sender, _to, _value);
89     }
90 
91     /**
92      * Transfer tokens from other address
93      *
94      * Send `_value` tokens to `_to` in behalf of `_from`
95      *
96      * @param _from The address of the sender
97      * @param _to The address of the recipient
98      * @param _value the amount to send
99      */
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         require(_value <= allowance[_from][msg.sender]);     // Check allowance
102         allowance[_from][msg.sender] -= _value;
103         _transfer(_from, _to, _value);
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address
109      *
110      * Allows `_spender` to spend no more than `_value` tokens in your behalf
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      */
115     function approve(address _spender, uint256 _value) public
116         returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, this, _extraData);
136             return true;
137         }
138     }
139 
140     /**
141      * Destroy tokens
142      *
143      * Remove `_value` tokens from the system irreversibly
144      *
145      * @param _value the amount of money to burn
146      */
147     function burn(uint256 _value) public returns (bool success) {
148         require(balances[msg.sender] >= _value);   // Check if the sender has enough
149         balances[msg.sender] -= _value;            // Subtract from the sender
150         totalSupply -= _value;                      // Updates totalSupply
151         Burn(msg.sender, _value);
152         return true;
153     }
154 
155 
156 }
157 
158 /******************************************/
159 /*       ADVANCED TOKEN STARTS HERE       */
160 /******************************************/
161 
162 contract MyAdvancedToken is owned, TokenERC20 {
163 
164     uint256 public sellPrice          = 5;
165     uint256 public buyPrice           = 500;
166     uint256 public currentTotalSupply = 0;
167 	uint256 public airdrop;
168     uint256 public startBalance;
169     
170     mapping(address => bool) touched; //是否空投
171     mapping (address => bool) public frozenAccount;
172 
173     /* This generates a public event on the blockchain that will notify clients */
174     event FrozenFunds(address target, bool frozen);
175 
176     /* Initializes contract with initial supply tokens to the creator of the contract */
177     function MyAdvancedToken(
178         uint256 initialSupply,
179         string tokenName,
180         string tokenSymbol
181     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
182 
183     /* Internal transfer, only can be called by this contract */
184     function _transfer(address _from, address _to, uint _value) internal {
185         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
186         if( !touched[msg.sender] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop ){
187             balances[msg.sender] +=  startBalance ;
188             touched[msg.sender] = true;
189             currentTotalSupply +=  startBalance ;
190         }
191         require (balances[_from] >= _value);               // Check if the sender has enough
192         require (balances[_to] + _value >= balances[_to]); // Check for overflows
193         require(!frozenAccount[_from]);                     // Check if sender is frozen
194         require(!frozenAccount[_to]);                       // Check if recipient is frozen
195         balances[_from] -= _value;                         // Subtract from the sender
196         balances[_to] += _value;                           // Add the same to the recipient
197         Transfer(_from, _to, _value);
198     }
199 
200     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
201     /// @param target Address to be frozen
202     /// @param freeze either to freeze it or not
203     function freezeAccount(address target, bool freeze) onlyOwner public {
204         frozenAccount[target] = freeze;
205         FrozenFunds(target, freeze);
206     }
207 
208     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
209     /// @param newSellPrice Price the users can sell to the contract
210     /// @param newBuyPrice Price users can buy from the contract
211     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
212         sellPrice = newSellPrice;
213         buyPrice = newBuyPrice;
214     }
215 
216 
217 
218    
219     function sell(uint256 amount) public {
220         require(this.balance >= amount / sellPrice);      // checks if the contract has enough ether to buy
221         _transfer(msg.sender, this, amount);              // makes the transfers
222         msg.sender.transfer(amount / sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
223     }
224 	
225     function () payable public {
226     	uint amount = msg.value * buyPrice;               
227     	balances[msg.sender] += amount;                  
228         balances[owner] -= amount;                        
229         Transfer(owner, msg.sender, amount);    
230     }
231 	
232  
233     function getEth(uint num) payable public onlyOwner {
234     	owner.transfer(num);
235     }
236 	
237 	 
238 	function modifyairdrop(uint256 _airdrop,uint256 _startBalance ) public onlyOwner {
239 		airdrop = _airdrop;
240 		startBalance = _startBalance;
241 	}
242 	
243 	
244 	function getBalance(address _a) internal constant returns(uint256) {
245         if( currentTotalSupply < totalSupply ){
246             if( touched[_a] )
247                 return balances[_a];
248             else
249                 return balances[_a] += startBalance ;
250         } else {
251             return balances[_a];
252         }
253     }
254     
255     function balanceOf(address _owner) public view returns (uint256 balance) {
256         return getBalance( _owner );
257     }
258     
259     
260     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
261         require(balances[_from] >= _value);                // Check if the targeted balance is enough
262          balances[_from] -= _value;                         // Subtract from the targeted balance
263          totalSupply -= _value;                              // Update totalSupply
264         Burn(_from, _value);
265         return true;
266     }
267 	
268 }