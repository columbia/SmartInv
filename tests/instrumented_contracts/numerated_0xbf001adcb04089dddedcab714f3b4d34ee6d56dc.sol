1 /**
2 * SMART COIN
3 *
4 * COIN DIRECT SALE 1 ETH = 2500 SMART COINS
5 *
6 * v.0.1 Manuell Monthly Burn 0,2% from totalSupply
7 */
8 
9 pragma solidity ^0.4.16;
10 
11 contract owned {
12     address public owner;
13 
14     function owned() public {
15         owner = msg.sender;
16     }
17 
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function transferOwnership(address newOwner) onlyOwner public {
24         owner = newOwner;
25     }
26 }
27 
28 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
29 
30 contract TokenERC20 {
31     // Public variables of the token
32     string public name;
33     string public symbol;
34     uint8 public decimals = 5;
35     uint256 public totalSupply;
36 
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     event Burn(address indexed from, uint256 value);
43 
44     function TokenERC20(
45         uint256 initialSupply,
46         string tokenName,
47         string tokenSymbol
48     ) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);
50         balanceOf[msg.sender] = totalSupply;
51         name = tokenName;
52         symbol = tokenSymbol;
53     }
54 
55     function _transfer(address _from, address _to, uint _value) internal {
56         // Prevent transfer to 0x0 address. Use burn() instead
57         require(_to != 0x0);
58         // Check if the sender has enough
59         require(balanceOf[_from] >= _value);
60         // Check for overflows
61         require(balanceOf[_to] + _value > balanceOf[_to]);
62         // Save this for an assertion in the future
63         uint previousBalances = balanceOf[_from] + balanceOf[_to];
64         // Subtract from the sender
65         balanceOf[_from] -= _value;
66         // Add the same to the recipient
67         balanceOf[_to] += _value;
68         emit Transfer(_from, _to, _value);
69         // Asserts are used to use static analysis to find bugs in your code. They should never fail
70         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
71     }
72 
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         _transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
79         require(_value <= allowance[_from][msg.sender]);     // Check allowance
80         allowance[_from][msg.sender] -= _value;
81         _transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function approve(address _spender, uint256 _value) public
86         returns (bool success) {
87         allowance[msg.sender][_spender] = _value;
88         return true;
89     }
90 
91     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
92         public
93         returns (bool success) {
94         tokenRecipient spender = tokenRecipient(_spender);
95         if (approve(_spender, _value)) {
96             spender.receiveApproval(msg.sender, _value, this, _extraData);
97             return true;
98         }
99     }
100 
101     function burn(uint256 _value) public returns (bool success) {
102         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
103         balanceOf[msg.sender] -= _value;            // Subtract from the sender
104         totalSupply -= _value;                      // Updates totalSupply
105         emit Burn(msg.sender, _value);
106         return true;
107     }
108 
109     function burnFrom(address _from, uint256 _value) public returns (bool success) {
110         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
111         require(_value <= allowance[_from][msg.sender]);    // Check allowance
112         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
113         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
114         totalSupply -= _value;                              // Update totalSupply
115         emit Burn(_from, _value);
116         return true;
117     }
118 }
119 
120 contract SmartAdvancedCoin is owned, TokenERC20 {
121 
122     uint256 public sellPrice;
123     uint256 public buyPrice;
124 
125     mapping (address => bool) public frozenAccount;
126 
127     /* This generates a public event on the blockchain that will notify clients */
128     event FrozenFunds(address target, bool frozen);
129 
130     /* Initializes contract with initial supply tokens to the creator of the contract */
131     function SmartAdvancedCoin(
132         uint256 initialSupply,
133         string tokenName,
134         string tokenSymbol
135     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
136 
137     /* Internal transfer, only can be called by this contract */
138     function _transfer(address _from, address _to, uint _value) internal {
139         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
140         require (balanceOf[_from] >= _value);               // Check if the sender has enough
141         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
142         require(!frozenAccount[_from]);                     // Check if sender is frozen
143         require(!frozenAccount[_to]);                       // Check if recipient is frozen
144         balanceOf[_from] -= _value;                         // Subtract from the sender
145         balanceOf[_to] += _value;                           // Add the same to the recipient
146         emit Transfer(_from, _to, _value);
147     }
148 
149     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
150         balanceOf[target] += mintedAmount;
151         totalSupply += mintedAmount;
152         emit Transfer(0, this, mintedAmount);
153         emit Transfer(this, target, mintedAmount);
154     }
155 
156     function freezeAccount(address target, bool freeze) onlyOwner public {
157         frozenAccount[target] = freeze;
158         emit FrozenFunds(target, freeze);
159     }
160 
161     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
162         sellPrice = newSellPrice;
163         buyPrice = newBuyPrice;
164     }
165 
166     function buy() payable public {
167         uint amount = msg.value / buyPrice;               // calculates the amount
168         _transfer(this, msg.sender, amount);              // makes the transfers
169     }
170 
171     function sell(uint256 amount) public {
172         address myAddress = this;
173         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
174         _transfer(msg.sender, this, amount);              // makes the transfers
175         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
176     }
177 
178 	// transfer balance to owner
179 	function withdrawEther(uint256 amount) {
180 		if(msg.sender != owner)throw;
181 		owner.transfer(amount);
182 	}
183 	
184 	// can accept ether
185 	function() payable {
186 	 uint amount = msg.value / buyPrice;               // calculates the amount
187         _transfer(this, msg.sender, amount);              // makes the transfers
188     }
189 }