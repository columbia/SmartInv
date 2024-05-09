1 pragma solidity ^0.4.18;
2 //MiningRigRentals Token
3 
4 contract owned {
5     address public owner;
6 
7     //constructor
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
22 interface tokenRecipient { 
23     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
24     }
25 
26 contract TokenERC20 {
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     // This generates a public event on the blockchain that will notify clients
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
45         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
46         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
47         name = tokenName;                                   // Set the name for display purposes
48         symbol = tokenSymbol;                               // Set the symbol for display purposes
49     }
50 
51     function _transfer(address _from, address _to, uint _value) internal {
52         // Prevent transfer to 0x0 address. Use burn() instead
53         require(_to != 0x0);
54         // Check if the sender has enough
55         require(balanceOf[_from] >= _value);
56         // Check for overflows
57         require(balanceOf[_to] + _value > balanceOf[_to]);
58         // Subtract from the sender
59         balanceOf[_from] -= _value;
60         // Add the same to the recipient
61         balanceOf[_to] += _value;
62         emit Transfer(_from, _to, _value);
63     }
64 
65     function transfer(address _to, uint256 _value) public {
66         _transfer(msg.sender, _to, _value);
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70         require(_value <= allowance[_from][msg.sender]);     // Check allowance
71         allowance[_from][msg.sender] -= _value;
72         _transfer(_from, _to, _value);
73         return true;
74     }
75 
76     function approve(address _spender, uint256 _value) public returns (bool success) {
77         allowance[msg.sender][_spender] = _value;
78         return true;
79     }
80 
81     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
82         tokenRecipient spender = tokenRecipient(_spender);
83         if (approve(_spender, _value)) {
84             spender.receiveApproval(msg.sender, _value, this, _extraData);
85             return true;
86         }
87     }
88 
89     function burn(uint256 _value) public returns (bool success) {
90         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
91         balanceOf[msg.sender] -= _value;            // Subtract from the sender
92         totalSupply -= _value;                      // Updates totalSupply
93         emit Burn(msg.sender, _value);
94         return true;
95     }
96 
97     function burnFrom(address _from, uint256 _value) public returns (bool success) {
98         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
99         require(_value <= allowance[_from][msg.sender]);    // Check allowance
100         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
101         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
102         totalSupply -= _value;                              // Update totalSupply
103         emit Burn(_from, _value);
104         return true;
105     }
106 }
107 
108 /******************************************/
109 /*       ADVANCED TOKEN STARTS HERE       */
110 /******************************************/
111 
112 contract MiningRigRentalsToken is owned, TokenERC20 {
113     uint256 public buyPrice;
114     bool public canBuy;
115     bool public canMint;
116 
117     mapping (address => bool) public frozenAccount;
118 
119     /* This generates a public event on the blockchain that will notify clients */
120     event FrozenFunds(address target, bool frozen);
121 
122     /* Initializes contract with initial supply tokens to the creator of the contract */
123     function MiningRigRentalsToken() TokenERC20(uint256(3120000000), "MiningRigRentals Token", "MRR") public {
124         canBuy = true;
125         canMint = true;
126         buyPrice = uint256(10000);//Tokens per ETH per 
127     }
128 
129     /* Internal transfer, only can be called by this contract */
130     function _transfer(address _from, address _to, uint _value) internal {
131         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
132         require (balanceOf[_from] >= _value);               // Check if the sender has enough
133         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
134         require(!frozenAccount[_from]);                     // Check if sender is frozen
135         require(!frozenAccount[_to]);                       // Check if recipient is frozen
136         balanceOf[_from] -= _value;                         // Subtract from the sender
137         balanceOf[_to] += _value;                           // Add the same to the recipient
138         emit Transfer(_from, _to, _value);
139     }
140 
141     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
142         if (!canMint) {
143             return;
144         }
145         balanceOf[target] += mintedAmount;
146         totalSupply += mintedAmount;
147         emit Transfer(0, this, mintedAmount);
148         emit Transfer(this, target, mintedAmount);
149     }
150 
151     //Disable any minting forever. Likley Requirement for exchange listing.
152     function disableMintForever() onlyOwner public {
153         canMint = false;
154     }
155 
156     function freezeAccount(address target, bool freeze) onlyOwner public {
157         frozenAccount[target] = freeze;
158         emit FrozenFunds(target, freeze);
159     }
160 
161 
162     function setPrices(uint256 newBuyPrice) onlyOwner public {
163         buyPrice = newBuyPrice;
164     }
165 
166     function setCanBuy(bool cb) onlyOwner public {
167         canBuy = cb;
168     }
169 
170     //Buy tokens from the owner
171     function buy() payable public {
172         if(canBuy) {
173             uint amount = msg.value * buyPrice;               // calculates the amount
174             _transfer(owner, msg.sender, amount);              // makes the transfers
175         }
176     }
177     
178     //sending in eth will purchase these tokens, 
179     function () public payable { 
180         buy();
181     }
182 
183     //Transffers out ethereum sent to this contract.
184     function withdraw(uint256 _value)  onlyOwner public {
185         owner.transfer(_value);//Transfer to the owner of the contract
186     }
187 
188     //Transffers out ALL ethereum sent to this contract.
189     function withdrawAll()  onlyOwner public {
190         address myAddress = this;
191         owner.transfer(myAddress.balance);//Transfer to the owner of the contract
192     }
193 }