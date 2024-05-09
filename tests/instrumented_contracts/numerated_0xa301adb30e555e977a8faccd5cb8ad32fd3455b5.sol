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
22 contract MyAdsShare {
23     string public constant _myTokeName = 'MyAdsShare';//change here
24     string public constant _mySymbol = 'MAS';//change here
25     uint public constant _myinitialSupply = 300000000;//leave it
26     uint8 public constant _myDecimal = 18;//leave it
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     // This generates a public event on the blockchain that will notify clients
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     function MyAdsShare(
50         uint256 initialSupply,
51         string tokenName,
52         string tokenSymbol
53     ) public {
54         decimals = _myDecimal;
55         totalSupply = _myinitialSupply * (10 ** uint256(_myDecimal));  // Update total supply with the decimal amount
56         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
57         name = _myTokeName;                                   // Set the name for display purposes
58         symbol = _mySymbol;                               // Set the symbol for display purposes
59     }
60 
61     /**
62      * Internal transfer, only can be called by this contract
63      */
64     function _transfer(address _from, address _to, uint _value) internal {
65         // Prevent transfer to 0x0 address. Use burn() instead
66         require(_to != 0x0);
67         // Check if the sender has enough
68         require(balanceOf[_from] >= _value);
69         // Check for overflows
70         require(balanceOf[_to] + _value > balanceOf[_to]);
71         // Save this for an assertion in the future
72         uint previousBalances = balanceOf[_from] + balanceOf[_to];
73         // Subtract from the sender
74         balanceOf[_from] -= _value;
75         // Add the same to the recipient
76         balanceOf[_to] += _value;
77         Transfer(_from, _to, _value);
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82     /**
83      * Transfer tokens
84      *
85      * Send `_value` tokens to `_to` from your account
86      *
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transfer(address _to, uint256 _value) public {
91         _transfer(msg.sender, _to, _value);
92     }
93 
94     /**
95      * Transfer tokens from other address
96      *
97      * Send `_value` tokens to `_to` in behalf of `_from`
98      *
99      * @param _from The address of the sender
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         require(_value <= allowance[_from][msg.sender]);     // Check allowance
105         allowance[_from][msg.sender] -= _value;
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address
112      *
113      * Allows `_spender` to spend no more than `_value` tokens in your behalf
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      */
118     function approve(address _spender, uint256 _value) public
119         returns (bool success) {
120         allowance[msg.sender][_spender] = _value;
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address and notify
126      *
127      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      * @param _extraData some extra information to send to the approved contract
132      */
133     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
134         public
135         returns (bool success) {
136         tokenRecipient spender = tokenRecipient(_spender);
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143     /**
144      * Destroy tokens
145      *
146      * Remove `_value` tokens from the system irreversibly
147      *
148      * @param _value the amount of money to burn
149      */
150     function burn(uint256 _value) public returns (bool success) {
151         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
152         balanceOf[msg.sender] -= _value;            // Subtract from the sender
153         totalSupply -= _value;                      // Updates totalSupply
154         Burn(msg.sender, _value);
155         return true;
156     }
157 
158     /**
159      * Destroy tokens from other account
160      *
161      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
162      *
163      * @param _from the address of the sender
164      * @param _value the amount of money to burn
165      */
166     function burnFrom(address _from, uint256 _value) public returns (bool success) {
167         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
168         require(_value <= allowance[_from][msg.sender]);    // Check allowance
169         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
170         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
171         totalSupply -= _value;                              // Update totalSupply
172         Burn(_from, _value);
173         return true;
174     }
175 }
176 
177 /******************************************/
178 /*       ADVANCED TOKEN STARTS HERE       */
179 /******************************************/
180 
181 contract MyAdvancedToken is owned, MyAdsShare {
182 
183 
184 
185     uint256 public sellPrice;
186     uint256 public buyPrice;
187 
188     mapping (address => bool) public frozenAccount;
189 
190     /* This generates a public event on the blockchain that will notify clients */
191     event FrozenFunds(address target, bool frozen);
192 
193     /* Initializes contract with initial supply tokens to the creator of the contract */
194     function MyAdvancedToken(
195         uint256 initialSupply,
196         string tokenName,
197         string tokenSymbol
198     ) MyAdsShare(initialSupply, tokenName, tokenSymbol) public {}
199 
200     /* Internal transfer, only can be called by this contract */
201     function _transfer(address _from, address _to, uint _value) internal {
202         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
203         require (balanceOf[_from] >= _value);               // Check if the sender has enough
204         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
205         require(!frozenAccount[_from]);                     // Check if sender is frozen
206         require(!frozenAccount[_to]);                       // Check if recipient is frozen
207         balanceOf[_from] -= _value;                         // Subtract from the sender
208         balanceOf[_to] += _value;                           // Add the same to the recipient
209         Transfer(_from, _to, _value);
210     }
211 
212     /// @notice Create `mintedAmount` tokens and send it to `target`
213     /// @param target Address to receive the tokens
214     /// @param mintedAmount the amount of tokens it will receive
215     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
216         balanceOf[target] += mintedAmount;
217         totalSupply += mintedAmount;
218         Transfer(0, this, mintedAmount);
219         Transfer(this, target, mintedAmount);
220     }
221 
222     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
223     /// @param target Address to be frozen
224     /// @param freeze either to freeze it or not
225     function freezeAccount(address target, bool freeze) onlyOwner public {
226         frozenAccount[target] = freeze;
227         FrozenFunds(target, freeze);
228     }
229 
230     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
231     /// @param newSellPrice Price the users can sell to the contract
232     /// @param newBuyPrice Price users can buy from the contract
233     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
234         sellPrice = newSellPrice;
235         buyPrice = newBuyPrice;
236     }
237 
238     /// @notice Buy tokens from contract by sending ether
239     function buy() payable public {
240         uint amount = msg.value / buyPrice;               // calculates the amount
241         _transfer(this, msg.sender, amount);              // makes the transfers
242     }
243 
244     /// @notice Sell `amount` tokens to contract
245     /// @param amount amount of tokens to be sold
246     function sell(uint256 amount) public {
247         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
248         _transfer(msg.sender, this, amount);              // makes the transfers
249         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
250     }
251 }