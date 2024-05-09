1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract owned {
6     address public owner;
7 
8     constructor() public {
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
23 contract TokenERC20 {
24     // Public variables of the token
25     string public name;
26     string public symbol;
27     uint8 public decimals = 8;
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
40 
41     constructor(
42         uint256 initialSupply,
43         string tokenName,
44         string tokenSymbol
45     ) public {
46         totalSupply = initialSupply * 10 ** uint256(decimals);  
47         balanceOf[msg.sender] = totalSupply;                
48         name = tokenName;                                  
49         symbol = tokenSymbol;                              
50     }
51 
52     function _transfer(address _from, address _to, uint _value) internal {
53         // Prevent transfer to 0x0 address. Use burn() instead
54         require(_to != 0x0);
55         // Check if the sender has enough
56         require(balanceOf[_from] >= _value);
57         // Check for overflows
58         require(balanceOf[_to] + _value > balanceOf[_to]);
59         // Save this for an assertion in the future
60         uint previousBalances = balanceOf[_from] + balanceOf[_to];
61         // Subtract from the sender
62         balanceOf[_from] -= _value;
63         // Add the same to the recipient
64         balanceOf[_to] += _value;
65         emit Transfer(_from, _to, _value);
66         // Asserts are used to use static analysis to find bugs in your code. They should never fail
67         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
68     }
69 
70     function transfer(address _to, uint256 _value) public {
71         _transfer(msg.sender, _to, _value);
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         require(_value <= allowance[_from][msg.sender]);     // Check allowance
76         allowance[_from][msg.sender] -= _value;
77         _transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function approve(address _spender, uint256 _value) public
82         returns (bool success) {
83         allowance[msg.sender][_spender] = _value;
84         return true;
85     }
86 
87     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
88         public
89         returns (bool success) {
90         tokenRecipient spender = tokenRecipient(_spender);
91         if (approve(_spender, _value)) {
92             spender.receiveApproval(msg.sender, _value, this, _extraData);
93             return true;
94         }
95     }
96 
97     function burn(uint256 _value) public returns (bool success) {
98         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
99         balanceOf[msg.sender] -= _value;            // Subtract from the sender
100         totalSupply -= _value;                      // Updates totalSupply
101         emit Burn(msg.sender, _value);
102         return true;
103     }
104 
105 
106     function burnFrom(address _from, uint256 _value) public returns (bool success) {
107         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
108         require(_value <= allowance[_from][msg.sender]);    // Check allowance
109         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
110         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
111         totalSupply -= _value;                              // Update totalSupply
112         emit Burn(_from, _value);
113         return true;
114     }
115 }
116 
117 
118 contract AL is owned, TokenERC20 {
119 
120     mapping (address => bool) public frozenAccount;
121 
122     /* This generates a public event on the blockchain that will notify clients */
123     event FrozenFunds(address target, bool frozen);
124 
125     /* Initializes contract with initial supply tokens to the creator of the contract */
126     constructor(
127         uint256 initialSupply,
128         string tokenName,
129         string tokenSymbol
130     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
131 
132     /* Internal transfer, only can be called by this contract */
133     function _transfer(address _from, address _to, uint _value) internal {
134         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
135         require (balanceOf[_from] >= _value);               // Check if the sender has enough
136         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
137         require(!frozenAccount[_from]);                     // Check if sender is frozen
138         require(!frozenAccount[_to]);                       // Check if recipient is frozen
139         balanceOf[_from] -= _value;                         // Subtract from the sender
140         balanceOf[_to] += _value;                           // Add the same to the recipient
141         emit Transfer(_from, _to, _value);
142     }
143 
144     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
145         balanceOf[target] += mintedAmount;
146         totalSupply += mintedAmount;
147         emit Transfer(0, this, mintedAmount);
148         emit Transfer(this, target, mintedAmount);
149     }
150 
151     function freezeAccount(address target, bool freeze) onlyOwner public {
152         frozenAccount[target] = freeze;
153         emit FrozenFunds(target, freeze);
154     }
155 
156 }