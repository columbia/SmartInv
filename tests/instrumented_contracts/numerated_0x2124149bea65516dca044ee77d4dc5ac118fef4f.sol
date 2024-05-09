1 pragma solidity ^0.4.21;
2 
3 contract TokenERC20 {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8     // 18 decimals is the strongly suggested default, avoid changing it
9     uint256 public totalSupply;
10 
11     // This creates an array with all balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     // This generates a public event on the blockchain that will notify clients
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     // This notifies clients about the amount burnt
19     event Burn(address indexed from, uint256 value);
20 
21     /**
22      * Constrctor function
23      *
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     function TokenERC20() public {
27         totalSupply = 36000000000000000000000000;  // Update total supply with the decimal amount
28         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
29         name = "CORENETCOIN";                                   // Set the name for display purposes
30         symbol = "CNTC";                               // Set the symbol for display purposes
31     }
32 
33     /**
34      * Internal transfer, only can be called by this contract
35      */
36     function _transfer(address _from, address _to, uint _value) internal {
37         // Prevent transfer to 0x0 address. Use burn() instead
38         require(_to != 0x0);
39         // Check if the sender has enough
40         require(balanceOf[_from] >= _value);
41         // Check for overflows
42         require(balanceOf[_to] + _value > balanceOf[_to]);
43         // Save this for an assertion in the future
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         // Subtract from the sender
46         balanceOf[_from] -= _value;
47         // Add the same to the recipient
48         balanceOf[_to] += _value;
49         emit Transfer(_from, _to, _value);
50         // Asserts are used to use static analysis to find bugs in your code. They should never fail
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54     /**
55      * Transfer tokens
56      *
57      * Send `_value` tokens to `_to` from your account
58      *
59      * @param _to The address of the recipient
60      * @param _value the amount to send
61      */
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65 
66     /**
67      * Transfer tokens from other address
68      *
69      * Send `_value` tokens to `_to` in behalf of `_from`
70      *
71      * @param _from The address of the sender
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76         require(_value <= allowance[_from][msg.sender]);     // Check allowance
77         allowance[_from][msg.sender] -= _value;
78         _transfer(_from, _to, _value);
79         return true;
80     }
81 
82     /**
83      * Set allowance for other address
84      *
85      * Allows `_spender` to spend no more than `_value` tokens in your behalf
86      *
87      * @param _spender The address authorized to spend
88      * @param _value the max amount they can spend
89      */
90     function approve(address _spender, uint256 _value) public
91         returns (bool success) {
92         allowance[msg.sender][_spender] = _value;
93         return true;
94     }
95 
96     /**
97      * Destroy tokens
98      *
99      * Remove `_value` tokens from the system irreversibly
100      *
101      * @param _value the amount of money to burn
102      */
103     function burn(uint256 _value) public returns (bool success) {
104         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
105         balanceOf[msg.sender] -= _value;            // Subtract from the sender
106         totalSupply -= _value;                      // Updates totalSupply
107         emit Burn(msg.sender, _value);
108         return true;
109     }
110 
111     /**
112      * Destroy tokens from other account
113      *
114      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
115      *
116      * @param _from the address of the sender
117      * @param _value the amount of money to burn
118      */
119     function burnFrom(address _from, uint256 _value) public returns (bool success) {
120         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
121         require(_value <= allowance[_from][msg.sender]);    // Check allowance
122         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
123         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
124         totalSupply -= _value;                              // Update totalSupply
125         emit Burn(_from, _value);
126         return true;
127     }
128     
129     /// @notice Create `mintedAmount` tokens and send it to `target`
130     /// @param target Address to receive the tokens
131     /// @param mintedAmount the amount of tokens it will receive
132     function mintToken(address target, uint256 mintedAmount)  public {
133         balanceOf[target] += mintedAmount;
134         totalSupply += mintedAmount;
135         emit Transfer(0, this, mintedAmount);
136         emit Transfer(this, target, mintedAmount);
137     }
138     
139     mapping (address => bool) public frozenAccount;
140 
141     /* This generates a public event on the blockchain that will notify clients */
142     event FrozenFunds(address target, bool frozen);
143     
144     /* Internal transfer, only can be called by this contract */
145     /* function _transfer(address _from, address _to, uint _value) internal {
146         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
147         require (balanceOf[_from] >= _value);               // Check if the sender has enough
148         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
149         require(!frozenAccount[_from]);                     // Check if sender is frozen
150         require(!frozenAccount[_to]);                       // Check if recipient is frozen
151         balanceOf[_from] -= _value;                         // Subtract from the sender
152         balanceOf[_to] += _value;                           // Add the same to the recipient
153         emit Transfer(_from, _to, _value);
154     } */
155     
156     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
157     /// @param target Address to be frozen
158     /// @param freeze either to freeze it or not
159     function freezeAccount(address target, bool freeze) public {
160         frozenAccount[target] = freeze;
161         emit FrozenFunds(target, freeze);
162     }
163     
164     uint256 public sellPrice;
165     uint256 public buyPrice;
166     
167     /// @notice Buy tokens from contract by sending ether
168     function buy() payable public {
169         uint amount = msg.value / buyPrice;               // calculates the amount
170         _transfer(this, msg.sender, amount);              // makes the transfers
171     }
172 
173     /// @notice Sell `amount` tokens to contract
174     /// @param amount amount of tokens to be sold
175     function sell(uint256 amount) public {
176         address myAddress = this;
177         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
178         _transfer(msg.sender, this, amount);              // makes the transfers
179         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
180     }
181 }