1 pragma solidity ^0.4.16;
2 
3 
4 contract owned {
5 
6     address public owner;
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 }
21 
22 
23 interface tokenRecipient { 
24     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
25     
26 }
27 
28 contract TokenERC20 {
29     // Public variables of the token
30     string public name = "Bitneur Token";
31     string public symbol= "BTN" ;
32     uint8 public decimals = 18;
33     // 18 decimals is the strongly suggested default, avoid changing it
34     uint256 public totalSupply = 500000000 * 10 ** 18 ;
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
52     ) public {
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54    }
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
72         Transfer(_from, _to, _value);
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
89 
90     /**
91      * Set allowance for other address
92      *
93      * Allows `_spender` to spend no more than `_value` tokens in your behalf
94      *
95      * @param _spender The address authorized to spend
96      * @param _value the max amount they can spend
97      */
98     function approve(address _spender, uint256 _value) public
99         returns (bool success) {
100         allowance[msg.sender][_spender] = _value;
101         return true;
102     }
103 
104     /**
105      * Set allowance for other address and notify
106      *
107      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
108      *
109      * @param _spender The address authorized to spend
110      * @param _value the max amount they can spend
111      * @param _extraData some extra information to send to the approved contract
112      */
113     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
114         public
115         returns (bool success) {
116         tokenRecipient spender = tokenRecipient(_spender);
117         if (approve(_spender, _value)) {
118             spender.receiveApproval(msg.sender, _value, this, _extraData);
119             return true;
120         }
121     }
122 
123     /**
124      * Destroy tokens
125      *
126      * Remove `_value` tokens from the system irreversibly
127      *
128      * @param _value the amount of money to burn
129      */
130     function burn(uint256 _value) public returns (bool success) {
131         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
132         balanceOf[msg.sender] -= _value;            // Subtract from the sender
133         totalSupply -= _value;                      // Updates totalSupply
134         Burn(msg.sender, _value);
135         return true;
136     }
137 
138 }
139 
140 /******************************************/
141 /*       ADVANCED TOKEN STARTS HERE       */
142 /******************************************/
143 
144 contract MyAdvancedToken is owned, TokenERC20 {
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
155 
156     /* Internal transfer, only can be called by this contract */
157     function _transfer(address _from, address _to, uint _value) internal {
158         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
159         require (balanceOf[_from] >= _value);               // Check if the sender has enough
160         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
161         require(!frozenAccount[_from]);                     // Check if sender is frozen
162         require(!frozenAccount[_to]);                       // Check if recipient is frozen
163         balanceOf[_from] -= _value;                         // Subtract from the sender
164         balanceOf[_to] += _value;                           // Add the same to the recipient
165         Transfer(_from, _to, _value);
166     }
167 
168 
169     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
170     /// @param target Address to be frozen
171     /// @param freeze either to freeze it or not
172     function freezeAccount(address target, bool freeze) onlyOwner public {
173         frozenAccount[target] = freeze;
174         FrozenFunds(target, freeze);
175     }
176 
177     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
178     /// @param newSellPrice Price the users can sell to the contract
179     /// @param newBuyPrice Price users can buy from the contract
180     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
181         sellPrice = newSellPrice;
182         buyPrice = newBuyPrice;
183     }
184 
185     /// @notice Buy tokens from contract by sending ether
186     function buy() payable public {
187         uint amount = msg.value / buyPrice;               // calculates the amount
188         _transfer(this, msg.sender, amount);              // makes the transfers
189     }
190 
191     /// @notice Sell `amount` tokens to contract
192     /// @param amount amount of tokens to be sold
193     function sell(uint256 amount) public {
194         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
195         _transfer(msg.sender, this, amount);              // makes the transfers
196         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
197     }
198 }