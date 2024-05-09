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
22 contract TokenERC20 {
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
45     function TokenERC20(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
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
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         emit Transfer(_from, _to, _value);
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     /**
78      * Transfer tokens
79      *
80      * Send `_value` tokens to `_to` from your account
81      *
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transfer(address _to, uint256 _value) public {
86         _transfer(msg.sender, _to, _value);
87     }
88 
89     /**
90      * Transfer tokens from other address
91      *
92      * Send `_value` tokens to `_to` in behalf of `_from`
93      *
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);     // Check allowance
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * Set allowance for other address
107      *
108      * Allows `_spender` to spend no more than `_value` tokens in your behalf
109      *
110      * @param _spender The address authorized to spend
111      * @param _value the max amount they can spend
112      */
113     function approve(address _spender, uint256 _value) public
114         returns (bool success) {
115         allowance[msg.sender][_spender] = _value;
116         return true;
117     }
118 
119     /**
120      * Set allowance for other address and notify
121      *
122      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
123      *
124      * @param _spender The address authorized to spend
125      * @param _value the max amount they can spend
126      * @param _extraData some extra information to send to the approved contract
127      */
128     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
129         public
130         returns (bool success) {
131         tokenRecipient spender = tokenRecipient(_spender);
132         if (approve(_spender, _value)) {
133             spender.receiveApproval(msg.sender, _value, this, _extraData);
134             return true;
135         }
136     }
137 
138 }
139 
140 /******************************************/
141 /*       ADVANCED TOKEN STARTS HERE       */
142 /******************************************/
143 
144 contract CoinstocksToken is owned, TokenERC20 {
145 
146     uint256 public sellPrice;
147     uint256 public buyPrice;
148 
149     mapping (address => bool) public frozenAccount;
150 
151     /* This generates a public event on the blockchain that will notify clients */
152     event FrozenFunds(address target, bool frozen);
153 
154     /* Initializes contract with initial supply tokens to the creator of the contract */
155     function CoinstocksToken(
156         uint256 initialSupply,
157         string tokenName,
158         string tokenSymbol
159     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
160 
161     /* Internal transfer, only can be called by this contract */
162     function _transfer(address _from, address _to, uint _value) internal {
163         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
164         require (balanceOf[_from] >= _value);               // Check if the sender has enough
165         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
166         require(!frozenAccount[_from]);                     // Check if sender is frozen
167         require(!frozenAccount[_to]);                       // Check if recipient is frozen
168         balanceOf[_from] -= _value;                         // Subtract from the sender
169         balanceOf[_to] += _value;                           // Add the same to the recipient
170         emit Transfer(_from, _to, _value);
171     }
172 
173     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
174     /// @param target Address to be frozen
175     /// @param freeze either to freeze it or not
176     function freezeAccount(address target, bool freeze) onlyOwner public {
177         frozenAccount[target] = freeze;
178         emit FrozenFunds(target, freeze);
179     }
180 
181     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
182     /// @param newSellPrice Price the users can sell to the contract
183     /// @param newBuyPrice Price users can buy from the contract
184     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
185         sellPrice = newSellPrice;
186         buyPrice = newBuyPrice;
187     }
188 
189     /// @notice Buy tokens from contract by sending ether
190     function buy() payable public {
191         uint amount = msg.value / buyPrice;               // calculates the amount
192         _transfer(this, msg.sender, amount);              // makes the transfers
193     }
194 
195     /// @notice Sell `amount` tokens to contract
196     /// @param amount amount of tokens to be sold
197     function sell(uint256 amount) public {
198         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
199         _transfer(msg.sender, this, amount);              // makes the transfers
200         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
201     }
202 }