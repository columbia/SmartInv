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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract OllisCoin is owned {
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
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function OllisCoin(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54         }
55         
56     /**
57      * Transfer tokens
58      *
59      * Send `_value` tokens to `_to` from your account
60      *
61      * @param _to The address of the recipient
62      * @param _value the amount to send
63      */
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68     /**
69      * Transfer tokens from other address
70      *
71      * Send `_value` tokens to `_to` in behalf of `_from`
72      *
73      * @param _from The address of the sender
74      * @param _to The address of the recipient
75      * @param _value the amount to send
76      */
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         require(_value <= allowance[_from][msg.sender]);     // Check allowance
79         allowance[_from][msg.sender] -= _value;
80         _transfer(_from, _to, _value);
81         return true;
82     }
83 
84     /**
85      * Set allowance for other address
86      *
87      * Allows `_spender` to spend no more than `_value` tokens in your behalf
88      *
89      * @param _spender The address authorized to spend
90      * @param _value the max amount they can spend
91      */
92     function approve(address _spender, uint256 _value) public
93         returns (bool success) {
94         allowance[msg.sender][_spender] = _value;
95         return true;
96     }
97 
98     /**
99      * Set allowance for other address and notify
100      *
101      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
102      *
103      * @param _spender The address authorized to spend
104      * @param _value the max amount they can spend
105      * @param _extraData some extra information to send to the approved contract
106      */
107     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
108         public
109         returns (bool success) {
110         tokenRecipient spender = tokenRecipient(_spender);
111         if (approve(_spender, _value)) {
112             spender.receiveApproval(msg.sender, _value, this, _extraData);
113             return true;
114         }
115     }
116 
117     /**
118      * Destroy tokens
119      *
120      * Remove `_value` tokens from the system irreversibly
121      *
122      * @param _value the amount of money to burn
123      */
124     function burn(uint256 _value) public returns (bool success) {
125         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
126         balanceOf[msg.sender] -= _value;            // Subtract from the sender
127         totalSupply -= _value;                      // Updates totalSupply
128         Burn(msg.sender, _value);
129         return true;
130     }
131 
132     /**
133      * Destroy tokens from other account
134      *
135      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
136      *
137      * @param _from the address of the sender
138      * @param _value the amount of money to burn
139      */
140     function burnFrom(address _from, uint256 _value) public returns (bool success) {
141         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
142         require(_value <= allowance[_from][msg.sender]);    // Check allowance
143         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
144         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
145         totalSupply -= _value;                              // Update totalSupply
146         Burn(_from, _value);
147         return true;
148     }
149 
150 
151     uint256 public sellPrice;
152     uint256 public buyPrice;
153 
154     mapping (address => bool) public frozenAccount;
155 
156     /* This generates a public event on the blockchain that will notify clients */
157     event FrozenFunds(address target, bool frozen);
158 
159 
160     /* Internal transfer, only can be called by this contract */
161     function _transfer(address _from, address _to, uint _value) internal {
162         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
163         require (balanceOf[_from] >= _value);               // Check if the sender has enough
164         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
165         require(!frozenAccount[_from]);                     // Check if sender is frozen
166         require(!frozenAccount[_to]);                       // Check if recipient is frozen
167         balanceOf[_from] -= _value;                         // Subtract from the sender
168         balanceOf[_to] += _value;                           // Add the same to the recipient
169         Transfer(_from, _to, _value);
170     }
171 
172     /// @notice Create `mintedAmount` tokens and send it to `target`
173     /// @param target Address to receive the tokens
174     /// @param mintedAmount the amount of tokens it will receive
175     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
176         balanceOf[target] += mintedAmount;
177         totalSupply += mintedAmount;
178         Transfer(0, this, mintedAmount);
179         Transfer(this, target, mintedAmount);
180     }
181 
182     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
183     /// @param target Address to be frozen
184     /// @param freeze either to freeze it or not
185     function freezeAccount(address target, bool freeze) onlyOwner public {
186         frozenAccount[target] = freeze;
187         FrozenFunds(target, freeze);
188     }
189 
190     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
191     /// @param newSellPrice Price the users can sell to the contract
192     /// @param newBuyPrice Price users can buy from the contract
193     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
194         sellPrice = newSellPrice;
195         buyPrice = newBuyPrice;
196     }
197 
198     /// @notice Buy tokens from contract by sending ether
199     function buy() payable public {
200         uint amount = msg.value / buyPrice;               // calculates the amount
201         _transfer(this, msg.sender, amount);              // makes the transfers
202     }
203 
204     /// @notice Sell `amount` tokens to contract
205     /// @param amount amount of tokens to be sold
206     function sell(uint256 amount) public {
207         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
208         _transfer(msg.sender, this, amount);              // makes the transfers
209         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
210     }
211 }