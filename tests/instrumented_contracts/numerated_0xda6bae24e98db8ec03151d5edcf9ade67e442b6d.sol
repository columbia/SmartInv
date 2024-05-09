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
22 contract StealthGridToken {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37     
38     // This notifies clients about the amount burnt
39     event Burn(address indexed from, uint256 value);
40     
41     
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     function StealthGridToken(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = tokenName;                                   // Set the name for display purposes
56         symbol = tokenSymbol;                               // Set the symbol for display purposes
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75         Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78         return true;
79     }
80 
81     /**
82      * Transfer tokens
83      *
84      * Send `_value` tokens to `_to` from your account
85      *
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transfer(address _to, uint256 _value) public returns  (bool success)  {
90        return  _transfer(msg.sender, _to, _value);
91     }
92 
93     /**
94      * Transfer tokens from other address
95      *
96      * Send `_value` tokens to `_to` in behalf of `_from`
97      *
98      * @param _from The address of the sender
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);     // Check allowance
104         allowance[_from][msg.sender] -= _value;
105         _transfer(_from, _to, _value);
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      */
117     function approve(address _spender, uint256 _value) public
118         returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         Approval(msg.sender, _spender, _value);
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
142 }
143 
144 /******************************************/
145 /*       ADVANCED TOKEN STARTS HERE       */
146 /******************************************/
147 
148 contract MyAdvancedToken is owned, StealthGridToken {
149 
150     uint256 public sellPrice;
151     uint256 public buyPrice;
152 
153     mapping (address => bool) public frozenAccount;
154 
155     /* This generates a public event on the blockchain that will notify clients */
156     event FrozenFunds(address target, bool frozen);
157 
158     /* Initializes contract with initial supply tokens to the creator of the contract */
159     function MyAdvancedToken(
160         uint256 initialSupply,
161         string tokenName,
162         string tokenSymbol
163     ) StealthGridToken(initialSupply, tokenName, tokenSymbol) public {}
164 
165     /* Internal transfer, only can be called by this contract */
166     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
167         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
168         require (balanceOf[_from] > _value);                // Check if the sender has enough
169         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
170         require(!frozenAccount[_from]);                     // Check if sender is frozen
171         require(!frozenAccount[_to]);                       // Check if recipient is frozen
172         balanceOf[_from] -= _value;                         // Subtract from the sender
173         balanceOf[_to] += _value;                           // Add the same to the recipient
174         Transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /// @notice Create `mintedAmount` tokens and send it to `target`
179     /// @param target Address to receive the tokens
180     /// @param mintedAmount the amount of tokens it will receive
181     function mintToken(address target, uint256 mintedAmount) onlyOwner public returns  (bool success) {
182         balanceOf[target] += mintedAmount;
183         totalSupply += mintedAmount;
184         Transfer(0, this, mintedAmount);
185         Transfer(this, target, mintedAmount);
186         return true;
187     }
188 
189     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
190     /// @param target Address to be frozen
191     /// @param freeze either to freeze it or not
192     function freezeAccount(address target, bool freeze) onlyOwner public returns  (bool success){
193         frozenAccount[target] = freeze;
194         FrozenFunds(target, freeze);
195     }
196 
197     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
198     /// @param newSellPrice Price the users can sell to the contract
199     /// @param newBuyPrice Price users can buy from the contract
200     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
201         sellPrice = newSellPrice;
202         buyPrice = newBuyPrice;
203     }
204 
205     /// @notice Buy tokens from contract by sending ether
206     function buy() payable public {
207         uint amount = msg.value / buyPrice;               // calculates the amount
208         _transfer(this, msg.sender, amount);              // makes the transfers
209     }
210 
211     /// @notice Sell `amount` tokens to contract
212     /// @param amount amount of tokens to be sold
213     function sell(uint256 amount) public {
214         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
215         _transfer(msg.sender, this, amount);              // makes the transfers
216         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
217     }
218 }