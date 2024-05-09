1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract PONTEM {
6     // Public variables of the token
7     string public name  ;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24      * Constrctor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     constructor (uint256 initialSupply , string tokenName , string tokenSymbol) public {
29 
30         totalSupply  = 250000000  * 10 ** uint256(18) ; // Update total supply with the decimal amount
31         balanceOf[msg.sender]  = totalSupply;                // Give the creator all initial tokens
32         name  = "PONTEM";                                   // Set the name for display purposes
33         symbol  = "PXM";                               // Set the symbol for display purposes
34     }
35 
36     /**
37      * Internal transfer, only can be called by this contract
38      */
39         /**
40      * Internal transfer, only can be called by this contract
41      */
42     function _transfer(address _from, address _to, uint _value) internal {
43         // Prevent transfer to 0x0 address. Use burn() instead
44         require(_to != 0x0);
45         // Check if the sender has enough
46         require(balanceOf[_from] >= _value);
47         // Check for overflows
48         require(balanceOf[_to] + _value > balanceOf[_to]);
49         // Save this for an assertion in the future
50         uint previousBalances = balanceOf[_from] + balanceOf[_to];
51         // Subtract from the sender
52         require(!frozenAccount[_from]);                     // Check if sender is frozen
53         require(!frozenAccount[_to]);                       // Check if recipient is frozen
54         balanceOf[_from] -= _value;
55         // Add the same to the recipient
56         balanceOf[_to] += _value;
57        emit Transfer(_from, _to, _value);
58         // Asserts are used to use static analysis to find bugs in your code. They should never fail
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     /**
63      * Transfer tokens
64      *
65      * Send `_value` tokens to `_to` from your account
66      *
67      * @param _to The address of the recipient
68      * @param _value the amount to send
69      */
70     function transfer(address _to, uint256 _value) public {
71         _transfer(msg.sender, _to, _value);
72         require(!frozenAccount[msg.sender]);
73 
74     }    
75         
76     /**
77      * Transfer tokens from other address
78      *
79      * Send `_value` tokens to `_to` in behalf of `_from`
80      *
81      * @param _from The address of the sender
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         require(_value <= allowance[_from][msg.sender]);     // Check allowance
87         allowance[_from][msg.sender] -= _value;
88         _transfer(_from, _to, _value);
89         return true;
90     }
91 
92     /**
93      * Set allowance for other address
94      *
95      * Allows `_spender` to spend no more than `_value` tokens in your behalf
96      *
97      * @param _spender The address authorized to spend
98      * @param _value the max amount they can spend
99      */
100     function approve(address _spender, uint256 _value) public
101         returns (bool success) {
102         allowance[msg.sender][_spender] = _value;
103         return true;
104     }
105 
106     /**
107      * Set allowance for other address and notify
108      *
109      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      * @param _extraData some extra information to send to the approved contract
114      */
115     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
116         public
117         returns (bool success) {
118         tokenRecipient spender = tokenRecipient(_spender);
119         if (approve(_spender, _value)) {
120             spender.receiveApproval(msg.sender, _value, this, _extraData);
121             return true;
122         }
123     }
124 
125     /**
126      * Destroy tokens
127      *
128      * Remove `_value` tokens from the system irreversibly
129      *
130      * @param _value the amount of money to burn
131      */
132     function burn(uint256 _value) public returns (bool success) {
133         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
134         balanceOf[msg.sender] -= _value;            // Subtract from the sender
135         totalSupply -= _value;                      // Updates totalSupply
136       emit  Burn(msg.sender, _value);
137         return true;
138     }
139 
140     /**
141      * Destroy tokens from other account
142      *
143      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
144      *
145      * @param _from the address of the sender
146      * @param _value the amount of money to burn
147      */
148     function burnFrom(address _from, uint256 _value) public returns (bool success) {
149         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
150         require(_value <= allowance[_from][msg.sender]);    // Check allowance
151         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
152         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
153         totalSupply -= _value;                              // Update totalSupply
154        emit Burn(_from, _value);
155         return true;
156         
157     } mapping (address => bool) public frozenAccount;
158     event FrozenFunds(address target, bool frozen);
159 
160     function freezeAccount(address target, bool freeze) public {
161         frozenAccount[target] = freeze;
162       emit  FrozenFunds(target, freeze);
163         
164     }    uint256 public sellPrice;
165     uint256 public buyPrice;
166 
167     function setPrices(uint256 newSellPrice, uint256 newBuyPrice)  public {
168         sellPrice = newSellPrice;
169         buyPrice = newBuyPrice;
170         
171     }/// @notice Buy tokens from contract by sending ether
172     function buy() payable public returns(uint amount) {
173         amount = msg.value / buyPrice;               // calculates the amount
174         require(balanceOf[this] >= amount);               // checks if it has enough to sell
175         require(balanceOf[msg.sender] >= amount * buyPrice); // checks if sender  has enough ether to buy
176         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
177         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
178         _transfer(this, msg.sender, amount);              // makes the transfers
179         return amount;
180     }
181 
182     /// @notice Sell `amount` tokens to contract
183     /// @param amount amount of tokens to be sold
184     function sell(uint256 amount) public returns(uint revenue) {
185         require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
186         require(balanceOf[msg.sender] >= amount);         // checks if it has enough to sell
187         balanceOf[this] += amount;                  // adds the amount to buyer's balance
188         balanceOf[msg.sender] -= amount;                        // subtracts amount from seller's balance
189         revenue = amount * sellPrice;
190         _transfer(msg.sender, this, amount);              // makes the transfers
191         require(msg.sender.send(revenue));                // sends ether to the seller: it's important to do this last to prevent recursion attacks
192        return revenue;
193     }
194 
195 
196 }