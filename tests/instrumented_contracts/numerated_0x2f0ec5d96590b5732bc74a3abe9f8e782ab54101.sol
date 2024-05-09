1 pragma solidity ^0.4.16;
2 contract owned {
3 
4     address public owner;
5 
6     function owned() public {
7     owner = msg.sender;
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
23     string public name;             //
24     string public symbol;           //
25     uint8 public decimals = 18;     //
26 
27     uint256 public totalSupply;     //
28 
29     mapping (address => uint256) public balanceOf;
30 
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     event Burn(address indexed from, uint256 value);
36 
37     function TokenERC20(
38         uint256 initialSupply,
39         string tokenName,
40         string tokenSymbol
41     ) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);  // 
43         balanceOf[msg.sender] = totalSupply;                    // 
44         name = tokenName;                                       //
45         symbol = tokenSymbol;                                   // 
46     }
47 
48     function _transfer(address _from, address _to, uint _value) internal {
49         require(_to != 0x0);
50         require(balanceOf[_from] >= _value);
51         require(balanceOf[_to] + _value > balanceOf[_to]);
52         uint previousBalances = balanceOf[_from] + balanceOf[_to];
53         balanceOf[_from] -= _value;
54         balanceOf[_to] += _value;
55         Transfer(_from, _to, _value);
56         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
57     }
58 
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
64         require(_value <= allowance[_from][msg.sender]);     // Check allowance
65         allowance[_from][msg.sender] -= _value;
66         _transfer(_from, _to, _value);
67         return true;
68     }
69 
70     function approve(address _spender, uint256 _value) public
71         returns (bool success) {
72         allowance[msg.sender][_spender] = _value;
73         return true;
74     }
75 
76 
77     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
78         public
79         returns (bool success) {
80         tokenRecipient spender = tokenRecipient(_spender);
81         if (approve(_spender, _value)) {
82             spender.receiveApproval(msg.sender, _value, this, _extraData);
83             return true;
84         }
85     }
86 
87     function burn(uint256 _value) public returns (bool success) {
88         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
89         balanceOf[msg.sender] -= _value;            // Subtract from the sender
90         totalSupply -= _value;                      // Updates totalSupply
91         Burn(msg.sender, _value);
92         return true;
93     }
94 
95     function burnFrom(address _from, uint256 _value) public returns (bool success) {
96         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
97         require(_value <= allowance[_from][msg.sender]);    // Check allowance
98         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
99         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
100         totalSupply -= _value;                              // Update totalSupply
101         Burn(_from, _value);
102         return true;
103     }
104 }
105 
106 /******************************************/
107 /*       ADVANCED TOKEN STARTS HERE       */
108 /******************************************/
109 
110 contract MyAdvancedToken is owned, TokenERC20 {
111 
112     uint256 public sellPrice;
113     uint256 public buyPrice;
114 
115     mapping (address => bool) public frozenAccount;
116 
117     /* This generates a public event on the blockchain that will notify clients */
118     event FrozenFunds(address target, bool frozen);
119 
120     function MyAdvancedToken(
121         uint256 initialSupply,
122         string tokenName,
123         string tokenSymbol
124     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
125 
126     function _transfer(address _from, address _to, uint _value) internal {
127         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
128         require (balanceOf[_from] >= _value);               // Check if the sender has enough
129         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
130         require(!frozenAccount[_from]);                     // Check if sender is frozen
131         require(!frozenAccount[_to]);                       // Check if recipient is frozen
132         balanceOf[_from] -= _value;                         // Subtract from the sender
133         balanceOf[_to] += _value;                           // Add the same to the recipient
134         Transfer(_from, _to, _value);
135     }
136 
137     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
138         balanceOf[target] += mintedAmount;
139         totalSupply += mintedAmount;
140         Transfer(0, this, mintedAmount);
141         Transfer(this, target, mintedAmount);
142 
143     }
144 
145 
146     function freezeAccount(address target, bool freeze) onlyOwner public {
147         frozenAccount[target] = freeze;
148         FrozenFunds(target, freeze);
149     }
150 
151     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
152         sellPrice = newSellPrice;
153         buyPrice = newBuyPrice;
154     }
155 
156     /// @notice Buy tokens from contract by sending ether
157     function buy() payable public {
158         uint amount = msg.value / buyPrice;               // calculates the amount
159         _transfer(this, msg.sender, amount);              // makes the transfers
160     }
161 
162     function sell(uint256 amount) public {
163         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
164         _transfer(msg.sender, this, amount);              // makes the transfers
165         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
166     }
167 }