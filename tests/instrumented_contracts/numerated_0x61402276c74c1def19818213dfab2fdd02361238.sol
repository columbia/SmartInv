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
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 8;
27     uint256 public totalSupply;
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     // This notifies clients about the amount burnt
37     event Burn(address indexed from, uint256 value);
38 
39     /**
40      * Constrctor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     function TokenERC20(
45         uint256 initialSupply,
46         string tokenName,
47         string tokenSymbol
48     ) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
50         balanceOf[msg.sender] = totalSupply;              
51         name = tokenName;                                   // Set the name for display purposes
52         symbol = tokenSymbol;                               // Set the symbol for display purposes
53     }
54 
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         // Prevent transfer to 0x0 address. Use burn() instead
60         require(_to != 0x0);
61         // Check if the sender has enough
62         require(balanceOf[_from] >= _value);
63         // Check for overflows
64         require(balanceOf[_to] + _value > balanceOf[_to]);
65         // Save this for an assertion in the future
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         Transfer(_from, _to, _value);
72         // Asserts are used to use static analysis to find bugs in your code. They should never fail
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
86     }
87 
88     /**
89      * Transfer tokens from other address
90      *
91      * Send `_value` tokens to `_to` in behalf of `_from`
92      *
93      * @param _from The address of the sender
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98         require(_value <= allowance[_from][msg.sender]);     // Check allowance
99         allowance[_from][msg.sender] -= _value;
100         _transfer(_from, _to, _value);
101         return true;
102     }
103 
104 
105     function approve(address _spender, uint256 _value) public
106         returns (bool success) {
107         allowance[msg.sender][_spender] = _value;
108         return true;
109     }
110 
111 
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
113         public
114         returns (bool success) {
115         tokenRecipient spender = tokenRecipient(_spender);
116         if (approve(_spender, _value)) {
117             spender.receiveApproval(msg.sender, _value, this, _extraData);
118             return true;
119         }
120     }
121 
122     function burn(uint256 _value) public returns (bool success) {
123         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
124         balanceOf[msg.sender] -= _value;            // Subtract from the sender
125         totalSupply -= _value;                      // Updates totalSupply
126         Burn(msg.sender, _value);
127         return true;
128     }
129 
130 
131     function burnFrom(address _from, uint256 _value) public returns (bool success) {
132         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
133         require(_value <= allowance[_from][msg.sender]);    // Check allowance
134         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
135         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
136         totalSupply -= _value;                              // Update totalSupply
137         Burn(_from, _value);
138         return true;
139     }
140 }
141 
142 
143 contract Spacoin is owned, TokenERC20 {
144 
145     uint256 public sellPrice;
146     uint256 public buyPrice;
147 
148     mapping (address => bool) public frozenAccount;
149 
150     /* This generates a public event on the blockchain that will notify clients */
151     event FrozenFunds(address target, bool frozen);
152 
153     /* Initializes contract with initial supply tokens to the creator of the contract */
154     function Spacoin(
155         uint256 initialSupply,
156         string tokenName,
157         string tokenSymbol
158     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
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