1 pragma solidity ^0.4.16;
2 /***  
3  * yfiexchange.finance
4  *Token symboi: YFIE
5  * @title ERC20 interface
6  * @dev see 
7      */
8 
9 contract owned {
10     address public owner;
11 constructor() public {
12         owner = msg.sender;
13     }
14 modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 function transferOwnership(address newOwner) onlyOwner public {
19         owner = newOwner;
20     }
21 }
22 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
23 contract TokenERC20 {
24     // Public variables of the token
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;
28     // 18 decimals is the strongly suggested default, avoid changing it
29     uint256 public totalSupply;
30 // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     
36     // This generates a public event on the blockchain that will notify clients
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 // This notifies clients about the amount burnt
39     event Burn(address indexed from, uint256 value);
40     
41     constructor(
42         uint256 initialSupply,
43         string tokenName,
44         string tokenSymbol
45     ) public {
46         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
47         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
48         name = tokenName;                                   // Set the name for display purposes
49         symbol = tokenSymbol;                               // Set the symbol for display purposes
50     }
51 /**
52      
53      */
54     function _transfer(address _from, address _to, uint _value) internal {
55         // Prevent transfer to 0x0 address. Use burn() instead
56         require(_to != 0x0);
57         // Check if the sender has enough
58         require(balanceOf[_from] >= _value);
59         // Check for overflows
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         // Save this for an assertion in the future
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         // Subtract from the sender
64         balanceOf[_from] -= _value;
65         // Add the same to the recipient
66         balanceOf[_to] += _value;
67         emit Transfer(_from, _to, _value);
68         // Asserts are used to use static analysis to find bugs in your code. They should never fail
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 /**
72      *
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         _transfer(msg.sender, _to, _value);
78         return true;
79     }
80 /**
81 
82      * @param _value the amount to send
83      */
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         require(_value <= allowance[_from][msg.sender]);     // Check allowance
86         allowance[_from][msg.sender] -= _value;
87         _transfer(_from, _to, _value);
88         return true;
89     }
90 /**
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
101         emit Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 /**
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
122 /**
123      * Destroy tokens
124      *
125      * Remove `_value` tokens from the system irreversibly
126      *
127      * @param _value the amount of money to burn
128      */
129     function burn(uint256 _value) public returns (bool success) {
130         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
131         balanceOf[msg.sender] -= _value;            // Subtract from the sender
132         totalSupply -= _value;                      // Updates totalSupply
133         emit Burn(msg.sender, _value);
134         return true;
135     }
136 /**
137      * Destroy tokens from other account
138      *
139      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
140      *
141      * @param _from the address of the sender
142      * @param _value the amount of money to burn
143      */
144     function burnFrom(address _from, uint256 _value) public returns (bool success) {
145         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
146         require(_value <= allowance[_from][msg.sender]);    // Check allowance
147         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
148         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
149         totalSupply -= _value;                              // Update totalSupply
150         emit Burn(_from, _value);
151         return true;
152     }
153 }
154 /******************************************/
155 /*       Change the name of the contract from Kahawanu to your own    token name
156 */
157 /******************************************/
158 contract YFIE is owned, TokenERC20 {
159 uint256 public sellPrice;
160     uint256 public buyPrice;
161 mapping (address => bool) public frozenAccount;
162 /* This generates a public event on the blockchain that will notify clients */
163     event FrozenFunds(address target, bool frozen);
164 /* Initializes contract with initial supply tokens to the creator of the contract */
165     constructor(
166         uint256 initialSupply,
167         string tokenName,
168         string tokenSymbol
169     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
170 /* Internal transfer, only can be called by this contract */
171     function _transfer(address _from, address _to, uint _value) internal {
172         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
173         require (balanceOf[_from] >= _value);               // Check if the sender has enough
174         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
175         require(!frozenAccount[_from]);                     // Check if sender is frozen
176         require(!frozenAccount[_to]);                       // Check if recipient is frozen
177         balanceOf[_from] -= _value;                         // Subtract from the sender
178         balanceOf[_to] += _value;                           // Add the same to the recipient
179         emit Transfer(_from, _to, _value);
180     }
181 
182     function freezeAccount(address target, bool freeze) onlyOwner public {
183         frozenAccount[target] = freeze;
184         emit FrozenFunds(target, freeze);
185     }
186 /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
187     /// @param newSellPrice Price the users can sell to the contract
188     /// @param newBuyPrice Price users can buy from the contract
189     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
190         sellPrice = newSellPrice;
191         buyPrice = newBuyPrice;
192     }
193 /// @notice Buy tokens from contract by sending ether
194     function buy() payable public {
195         uint amount = msg.value / buyPrice;               // calculates the amount
196         _transfer(this, msg.sender, amount);              // makes the transfers
197     }
198 /// @notice Sell `amount` tokens to contract
199     /// @param amount amount of tokens to be sold
200     function sell(uint256 amount) public {
201         address myAddress = this;
202         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
203         _transfer(msg.sender, this, amount);              // makes the transfers
204         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
205     }
206 }