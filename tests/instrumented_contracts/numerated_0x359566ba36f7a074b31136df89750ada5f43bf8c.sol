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
20 interface tokenRecipient { 
21 function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
22 }
23 
24 contract TokenERC20 {
25     // Public variables of the token
26     string public name;
27     string public symbol;
28     uint8 public decimals = 18;
29     // 18 decimals is the strongly suggested default, avoid changing it
30     uint256 public totalSupply;
31 
32     // This creates an array with all balances
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35 
36     // This generates a public event on the blockchain that will notify clients
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     // This notifies clients about the amount burnt
40     event Burn(address indexed from, uint256 value);
41 
42     /**
43      * Constrctor function
44      *
45      * Initializes contract with initial supply tokens to the creator of the contract
46      */
47     function TokenERC20(
48         uint256 initialSupply,
49         string tokenName,
50         string tokenSymbol
51     ) public {
52         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54         name = tokenName;                                   // Set the name for display purposes
55         symbol = tokenSymbol;                               // Set the symbol for display purposes
56     }
57 
58     /**
59      * Internal transfer, only can be called by this contract
60      */
61     function _transfer(address _from, address _to, uint _value) {
62         // Prevent transfer to 0x0 address. Use burn() instead
63         require(_to != 0x0);
64         // Check if the sender has enough
65         require(balanceOf[_from] >= _value);
66         // Check for overflows
67         require(balanceOf[_to] + _value > balanceOf[_to]);
68         // Save this for an assertion in the future
69         uint previousBalances = balanceOf[_from] + balanceOf[_to];
70         // Subtract from the sender
71         balanceOf[_from] -= _value;
72         // Add the same to the recipient
73         balanceOf[_to] += _value;
74         Transfer(_from, _to, _value);
75         // Asserts are used to use static analysis to find bugs in your code. They should never fail
76         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
87     function transfer(address _to, uint256 _value) public returns (bool success) 
88 	{
89         _transfer(msg.sender, _to, _value);
90 		return true;
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
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address and notify
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      * @param _extraData some extra information to send to the approved contract
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         public
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140     }
141 
142     
143     function burn(uint256 _value) public returns (bool success) {
144         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
145         balanceOf[msg.sender] -= _value;            // Subtract from the sender
146         totalSupply -= _value;                      // Updates totalSupply
147         Burn(msg.sender, _value);
148         return true;
149     }
150 
151     function burnFrom(address _from, uint256 _value) public returns (bool success) {
152         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
153         require(_value <= allowance[_from][msg.sender]);    // Check allowance
154         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
155         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
156         totalSupply -= _value;                              // Update totalSupply
157         Burn(_from, _value);
158         return true;
159     }
160 }
161 
162 contract WorldTrade is owned, TokenERC20 {
163 
164     uint256 public sellPrice;
165     uint256 public buyPrice;
166 
167     mapping (address => bool) public frozenAccount;
168 
169     /* This generates a public event on the blockchain that will notify clients */
170     event FrozenFunds(address target, bool frozen);
171 
172     /* Initializes contract with initial supply tokens to the creator of the contract */
173     function WorldTrade(
174         uint256 initialSupply,
175         string tokenName,
176         string tokenSymbol
177     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
178    
179 
180     /// @notice Create `mintedAmount` tokens and send it to `target`
181     /// @param target Address to receive the tokens
182     /// @param mintedAmount the amount of tokens it will receive
183     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
184         balanceOf[target] += mintedAmount;
185         totalSupply += mintedAmount;
186         Transfer(0, this, mintedAmount);
187         Transfer(this, target, mintedAmount);
188     }
189 
190     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
191     /// @param target Address to be frozen
192     /// @param freeze either to freeze it or not
193     function freezeAccount(address target, bool freeze) onlyOwner public {
194         frozenAccount[target] = freeze;
195         FrozenFunds(target, freeze);
196     }
197 
198     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
199     /// @param newSellPrice Price the users can sell to the contract
200     /// @param newBuyPrice Price users can buy from the contract
201     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
202         sellPrice = newSellPrice;
203         buyPrice = newBuyPrice;
204     }
205 
206     /// @notice Buy tokens from contract by sending ether
207     function buy() payable public {
208         uint amount = msg.value / buyPrice;               // calculates the amount
209         _transfer(this, msg.sender, amount);              // makes the transfers
210     }
211 
212     /// @notice Sell `amount` tokens to contract
213     /// @param amount amount of tokens to be sold
214     function sell(uint256 amount) public {
215         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
216         _transfer(msg.sender, this, amount);              // makes the transfers
217         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
218     }
219 }