1 pragma solidity ^0.4.16;
2 
3 /******************************************/
4 /*       ITECToken STARTS HERE       */
5 /******************************************/
6 
7 contract ITECToken {
8 
9     // Public variables of the token(TokenERC20)
10     string public name;
11     string public symbol;
12     uint256 public totalSupply;
13     uint8 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
14 
15     address public owner;
16 
17     /**
18      * Constrctor function
19      *
20      * Initializes contract with initial supply tokens to the creator of the contract
21      */
22     constructor(
23         uint256 initialSupply,
24         string tokenName,
25         string tokenSymbol
26     ) public {
27         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
28         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
29         name = tokenName;                                   // Set the name for display purposes
30         symbol = tokenSymbol;                               // Set the symbol for display purposes
31     
32         owner = msg.sender;
33     }
34     
35     // This creates an array with all balances
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38     mapping (address => bool) public frozenAccount;
39 
40     // This generates a public event on the blockchain that will notify clients
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43     event FrozenFunds(address target, bool frozen);
44     
45     // This notifies clients about the amount burnt
46     event Burn(address indexed from, uint256 value);
47     
48     //authorized parts start
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address newOwner) onlyOwner public {
55         owner = newOwner;
56     }
57     //authorized parts end
58     
59     /* Internal transfer, only can be called by this contract */
60     function _transfer(address _from, address _to, uint _value) internal {
61         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
62         require (balanceOf[_from] >= _value);               // Check if the sender has enough
63         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
64         require(!frozenAccount[_from]);                     // Check if sender is frozen
65         require(!frozenAccount[_to]);                       // Check if recipient is frozen
66         balanceOf[_from] -= _value;                         // Subtract from the sender
67         balanceOf[_to] += _value;                           // Add the same to the recipient
68         emit Transfer(_from, _to, _value);
69     }
70 
71     /**
72      * Transfer tokens
73      *
74      * Send `_value` tokens to `_to` from your account
75      *
76      * @param _to The address of the recipient
77      * @param _value the amount to send
78      */
79     function transfer(address _to, uint256 _value) public returns (bool success) {
80         _transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     /**
85      * Transfer tokens from other address
86      *
87      * Send `_value` tokens to `_to` in behalf of `_from`
88      *
89      * @param _from The address of the sender
90      * @param _to The address of the recipient
91      * @param _value the amount to send
92      */
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
94         require(_value <= allowance[_from][msg.sender]);     // Check allowance
95         allowance[_from][msg.sender] -= _value;
96         _transfer(_from, _to, _value);
97         return true;
98     }
99 
100     /**
101      * Set allowance for other address
102      *
103      * Allows `_spender` to spend no more than `_value` tokens in your behalf
104      *
105      * @param _spender The address authorized to spend
106      * @param _value the max amount they can spend
107      */
108     function approve(address _spender, uint256 _value) public
109         returns (bool success) {
110         allowance[msg.sender][_spender] = _value;
111         emit Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     /**
116      * Destroy tokens
117      *
118      * Remove `_value` tokens from the system irreversibly
119      *
120      * @param _value the amount of money to burn
121      */
122     function burn(uint256 _value) onlyOwner public returns (bool success) {
123         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
124         balanceOf[msg.sender] -= _value;            // Subtract from the sender
125         totalSupply -= _value;                      // Updates totalSupply
126         emit Burn(msg.sender, _value);
127         return true;
128     }
129 
130     /// @notice Create `mintedAmount` tokens and send it to `target`
131     /// @param target Address to receive the tokens
132     /// @param mintedAmount the amount of tokens it will receive
133     function mToken(address target, uint256 mintedAmount) onlyOwner public {
134         balanceOf[target] += mintedAmount;
135         totalSupply += mintedAmount;
136         emit Transfer(0, this, mintedAmount);
137         emit Transfer(this, target, mintedAmount);
138     }
139 
140     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
141     /// @param target Address to be frozen
142     /// @param freeze either to freeze it or not
143     function freezeAccount(address target, bool freeze) onlyOwner public {
144         frozenAccount[target] = freeze;
145         emit FrozenFunds(target, freeze);
146     }
147 }