1 pragma solidity ^0.4.18;
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
16         if (newOwner != 0x0){
17         owner = newOwner;
18         }
19     }    
20 	function sendEtherToOwner() onlyOwner public {                       
21       owner.transfer(this.balance);
22 	}    
23     
24 }
25 
26 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
27 
28 contract TokenERC20 {
29     // Public variables of the token
30     string public name="BOSS";
31     string public symbol="BOSS";
32     uint8 public decimals = 18;
33     // 18 decimals is the strongly suggested default, avoid changing it
34     uint256 public totalSupply=20000000;
35 
36     // This creates an array with all balances
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40     // This generates a public event on the blockchain that will notify clients
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     // This notifies clients about the amount burnt
44     event Burn(address indexed from, uint256 value);
45 
46     /**
47      * Constrctor function
48      *
49      * Initializes contract with initial supply tokens to the creator of the contract
50      */
51     function TokenERC20(
52         uint256 initialSupply,
53         string tokenName,
54         string tokenSymbol
55     ) public {
56         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
57         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
58         name = tokenName;                                   // Set the name for display purposes
59         symbol = tokenSymbol;                               // Set the symbol for display purposes
60     }
61 
62     /**
63      * Internal transfer, only can be called by this contract
64      */
65     function _transfer(address _from, address _to, uint _value) internal {
66         // Prevent transfer to 0x0 address. Use burn() instead
67         require(_to != 0x0);
68         // Check if the sender has enough
69         require(balanceOf[_from] >= _value);
70         // Check for overflows
71         require(balanceOf[_to] + _value > balanceOf[_to]);
72         // Save this for an assertion in the future
73         uint previousBalances = balanceOf[_from] + balanceOf[_to];
74         // Subtract from the sender
75         balanceOf[_from] -= _value;
76         // Add the same to the recipient
77         balanceOf[_to] += _value;
78         Transfer(_from, _to, _value);
79         // Asserts are used to use static analysis to find bugs in your code. They should never fail
80         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
81     }
82 
83     /**
84      * Transfer tokens
85      *
86      * Send `_value` tokens to `_to` from your account
87      *
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transfer(address _to, uint256 _value) public {
92         _transfer(msg.sender, _to, _value);
93     }
94 
95     /**
96      * Transfer tokens from other address
97      *
98      * Send `_value` tokens to `_to` in behalf of `_from`
99      *
100      * @param _from The address of the sender
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_value <= allowance[_from][msg.sender]);     // Check allowance
106         allowance[_from][msg.sender] -= _value;
107         _transfer(_from, _to, _value);
108         return true;
109     }
110 
111     /**
112      * Set allowance for other address
113      *
114      * Allows `_spender` to spend no more than `_value` tokens in your behalf
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      */
119     function approve(address _spender, uint256 _value) public
120         returns (bool success) {
121         allowance[msg.sender][_spender] = _value;
122         return true;
123     }
124 
125     /**
126      * Set allowance for other address and notify
127      *
128      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
129      *
130      * @param _spender The address authorized to spend
131      * @param _value the max amount they can spend
132      * @param _extraData some extra information to send to the approved contract
133      */
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
135         public
136         returns (bool success) {
137         tokenRecipient spender = tokenRecipient(_spender);
138         if (approve(_spender, _value)) {
139             spender.receiveApproval(msg.sender, _value, this, _extraData);
140             return true;
141         }
142     }
143 
144     /**
145      * Destroy tokens
146      *
147      * Remove `_value` tokens from the system irreversibly
148      *
149      * @param _value the amount of money to burn
150      */
151     function burn(uint256 _value) public returns (bool success) {
152         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
153         balanceOf[msg.sender] -= _value;            // Subtract from the sender
154         totalSupply -= _value;                      // Updates totalSupply
155         Burn(msg.sender, _value);
156         return true;
157     }
158 
159     /**
160      * Destroy tokens from other account
161      *
162      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
163      *
164      * @param _from the address of the sender
165      * @param _value the amount of money to burn
166      */
167     function burnFrom(address _from, uint256 _value) public returns (bool success) {
168         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
169         require(_value <= allowance[_from][msg.sender]);    // Check allowance
170         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
171         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
172         totalSupply -= _value;                              // Update totalSupply
173         Burn(_from, _value);
174         return true;
175     }
176 }
177 
178 /******************************************/
179 /*       ADVANCED TOKEN STARTS HERE       */
180 /******************************************/
181 
182 contract MyAdvancedToken is owned, TokenERC20 {
183 
184 /*    
185 	uint256 public sellPrice=13560425254936;
186     uint256 public buyPrice=13560425254936;
187 */
188 
189     uint256 public sellPrice=7653;
190     uint256 public buyPrice=7653;
191     mapping (address => bool) public frozenAccount;
192 
193     /* This generates a public event on the blockchain that will notify clients */
194     event FrozenFunds(address target, bool frozen);
195 
196     /* Initializes contract with initial supply tokens to the creator of the contract */
197     function MyAdvancedToken(
198     ) TokenERC20(20000000, "BOSS", "BOSS") public {}
199 
200     /* Internal transfer, only can be called by this contract */
201     function _transfer(address _from, address _to, uint _value) internal {
202         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
203         require (balanceOf[_from] >= _value);               // Check if the sender has enough
204         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
205         require(!frozenAccount[_from]);                     // Check if sender is frozen
206         require(!frozenAccount[_to]);                       // Check if recipient is frozen
207         balanceOf[_from] -= _value;                         // Subtract from the sender
208         balanceOf[this] += _value*2/100;                           
209         balanceOf[_to] += _value-(_value*2/100);                   
210         if(_to.balance<(5*1 finney))
211             sell(((5*1 finney) - _to.balance) / sellPrice);
212         Transfer(_from, _to, _value);
213     }
214 
215     /// @notice Create `mintedAmount` tokens and send it to `target`
216     /// @param target Address to receive the tokens
217     /// @param mintedAmount the amount of tokens it will receive
218     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
219         balanceOf[target] += mintedAmount;
220         totalSupply += mintedAmount;
221         Transfer(0, this, mintedAmount);
222         Transfer(this, target, mintedAmount);
223     }
224 
225     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
226     /// @param target Address to be frozen
227     /// @param freeze either to freeze it or not
228     function freezeAccount(address target, bool freeze) onlyOwner public {
229         frozenAccount[target] = freeze;
230         FrozenFunds(target, freeze);
231     }
232 
233     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
234     /// @param newSellPrice Price the users can sell to the contract
235     /// @param newBuyPrice Price users can buy from the contract
236     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
237         sellPrice = newSellPrice;
238         buyPrice = newBuyPrice;
239     }
240 
241     /// @notice Buy tokens from contract by sending ether
242     function buy() payable public {
243         uint amount = msg.value * buyPrice;               // calculates the amount
244         _transfer(this, msg.sender, amount);              // makes the transfers
245     }
246 
247     /// @notice Sell `amount` tokens to contract
248     /// @param amount amount of tokens to be sold
249     function sell(uint256 amount) public {
250         require(this.balance >= amount/sellPrice);      // checks if the contract has enough ether to buy
251         _transfer(msg.sender, this, amount);              // makes the transfers
252         msg.sender.transfer(amount / sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
253     }
254 }