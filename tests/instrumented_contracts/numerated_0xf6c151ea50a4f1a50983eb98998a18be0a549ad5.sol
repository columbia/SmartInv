1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 constructor() public {
6         owner = msg.sender;
7     }
8 modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 function transferOwnership(address newOwner) onlyOwner public {
13         owner = newOwner;
14     }
15 }
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
17 contract TokenERC20 {
18     string public name;
19     string public symbol;
20     uint8 public decimals = 18;
21     uint256 public totalSupply;
22 // This creates an array with all balances
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25 // This generates a public event on the blockchain that will notify clients
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     
28     // This generates a public event on the blockchain that will notify clients
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 // This notifies clients about the amount burnt
31     event Burn(address indexed from, uint256 value);
32     
33     constructor(
34         uint256 initialSupply,
35         string tokenName,
36         string tokenSymbol
37     ) public {
38         totalSupply = initialSupply * 10 ** uint256(decimals);  
39         balanceOf[msg.sender] = totalSupply;               
40         name = tokenName;                                  
41         symbol = tokenSymbol;                               
42     }
43 /**
44      
45      */
46     function _transfer(address _from, address _to, uint _value) internal {
47         //Use burn() instead
48         require(_to != 0x0);
49         // Check if the sender has enough
50         require(balanceOf[_from] >= _value);
51         // Check for overflows
52         require(balanceOf[_to] + _value > balanceOf[_to]);
53        
54         uint previousBalances = balanceOf[_from] + balanceOf[_to];
55         // Subtract from the sender
56         balanceOf[_from] -= _value;
57         // Add the same to the recipient
58         balanceOf[_to] += _value;
59         emit Transfer(_from, _to, _value);
60      
61         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
62     }
63 /**
64      *
65      
66      */
67     function transfer(address _to, uint256 _value) public returns (bool success) {
68         _transfer(msg.sender, _to, _value);
69         return true;
70     }
71 /**
72 
73      * @param _value the amount to send
74      */
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76         require(_value <= allowance[_from][msg.sender]);     // Check 
77         allowance[_from][msg.sender] -= _value;
78         _transfer(_from, _to, _value);
79         return true;
80     }
81 /**
82      *
83      * @param _value the max amount they can spend
84      */
85     function approve(address _spender, uint256 _value) public
86         returns (bool success) {
87         allowance[msg.sender][_spender] = _value;
88         emit Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 /**
92     
93      * @param _extraData some extra information to send to the approved contract
94      */
95     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
96         public
97         returns (bool success) {
98         tokenRecipient spender = tokenRecipient(_spender);
99         if (approve(_spender, _value)) {
100             spender.receiveApproval(msg.sender, _value, this, _extraData);
101             return true;
102         }
103     }
104 /**
105      * Destroy tokens
106      
107      */
108     function burn(uint256 _value) public returns (bool success) {
109         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
110         balanceOf[msg.sender] -= _value;            // Subtract from the sender
111         totalSupply -= _value;                      // Updates totalSupply
112         emit Burn(msg.sender, _value);
113         return true;
114     }
115 /**
116      * Destroy tokens from other account
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
128 }
129 
130 /******************************************/
131 contract YFI2 is owned, TokenERC20 {
132 uint256 public sellPrice;
133     uint256 public buyPrice;
134 mapping (address => bool) public frozenAccount;
135 
136     event FrozenFunds(address target, bool frozen);
137 
138     constructor(
139         uint256 initialSupply,
140         string tokenName,
141         string tokenSymbol
142     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
143 /* Internal transfer, only can be called by this contract */
144     function _transfer(address _from, address _to, uint _value) internal {
145         require (_to != 0x0);                               //  Use burn() instead
146         require (balanceOf[_from] >= _value);               // Check if the sender has enough
147         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
148         require(!frozenAccount[_from]);                     // Check if sender is frozen
149         require(!frozenAccount[_to]);                       // Check if recipient is frozen
150         balanceOf[_from] -= _value;                         // Subtract from the sender
151         balanceOf[_to] += _value;                           // Add the same to the recipient
152         emit Transfer(_from, _to, _value);
153     }
154 
155     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
156         sellPrice = newSellPrice;
157         buyPrice = newBuyPrice;
158     }
159 /// @notice Buy tokens from contract by sending ether
160     function buy() payable public {
161         uint amount = msg.value / buyPrice;               // calculates the amount
162         _transfer(this, msg.sender, amount);              // makes the transfers
163     }
164 /// @notice Sell `amount` tokens to contract
165     /// @param amount amount of tokens to be sold
166     function sell(uint256 amount) public {
167         address myAddress = this;
168         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
169         _transfer(msg.sender, this, amount);              // makes the transfers
170         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
171     }
172 }