1 pragma solidity ^0.4.19;
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
26     uint8 public decimals = 8;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     /**
38      * Constrctor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     function TokenERC20(
43         uint256 initialSupply,
44         string tokenName,
45         string tokenSymbol
46     ) public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
48         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
49         name = tokenName;                                   // Set the name for display purposes
50         symbol = tokenSymbol;     
51 		if (totalSupply == 0) {
52 			totalSupply = 1000000000 * 10 ** uint256(decimals);
53 			name = "Gamers World";
54 			symbol = "GSW";
55 		}
56     }
57 
58     /**
59      * Internal transfer, only can be called by this contract
60      */
61     function _transfer(address _from, address _to, uint _value) internal {
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
139 }
140 
141 /******************************************/
142 /*       ADVANCED TOKEN STARTS HERE       */
143 /******************************************/
144 
145 contract GamersToken is owned, TokenERC20 {
146 
147     uint256 public sellPrice;
148     uint256 public buyPrice;
149 
150     mapping (address => bool) public frozenAccount;
151 
152     /* This generates a public event on the blockchain that will notify clients */
153     event FrozenFunds(address target, bool frozen);
154 
155     /* Initializes contract with initial supply tokens to the creator of the contract */
156     function GamersToken(
157         uint256 initialSupply,
158         string tokenName,
159         string tokenSymbol
160     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
161 
162     /* Internal transfer, only can be called by this contract */
163     function _transfer(address _from, address _to, uint _value) internal {
164         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
165         require (balanceOf[_from] >= _value);               // Check if the sender has enough
166         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
167         require(!frozenAccount[_from]);                     // Check if sender is frozen
168         require(!frozenAccount[_to]);                       // Check if recipient is frozen
169         balanceOf[_from] -= _value;                         // Subtract from the sender
170         balanceOf[_to] += _value;                           // Add the same to the recipient
171         Transfer(_from, _to, _value);
172     }
173 
174 
175     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
176     /// @param target Address to be frozen
177     /// @param freeze either to freeze it or not
178     function freezeAccount(address target, bool freeze) onlyOwner public {
179         frozenAccount[target] = freeze;
180         FrozenFunds(target, freeze);
181     }
182 
183     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
184     /// @param newSellPrice Price the users can sell to the contract
185     /// @param newBuyPrice Price users can buy from the contract
186     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
187         sellPrice = newSellPrice;
188         buyPrice = newBuyPrice;
189     }
190 
191     /// @notice Buy tokens from contract by sending ether
192     function buy() payable public {
193         uint amount = msg.value / buyPrice;               // calculates the amount
194         _transfer(this, msg.sender, amount);              // makes the transfers
195     }
196 
197     /// @notice Sell `amount` tokens to contract
198     /// @param amount amount of tokens to be sold
199     function sell(uint256 amount) public {
200         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
201         _transfer(msg.sender, this, amount);              // makes the transfers
202         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
203     }
204 }