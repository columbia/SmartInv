1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5 
6     constructor(address _owner) public {
7         owner = _owner;
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
20 
21 contract GOMIERC20 {
22     // Public variables of the token
23     string public name;
24     string public symbol;
25     uint8 public decimals = 0;
26     // 18 decimals is the strongly suggested default, avoid changing it
27     uint256 public totalSupply;
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31    
32     // This generates a public event on the blockchain that will notify clients
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     
35 
36     // This notifies clients about the amount burnt
37     event Burn(address indexed from, uint256 value);
38 
39     /**
40      * Constrctor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     constructor(
45         uint256 initialSupply,
46         string memory tokenName,
47         string memory tokenSymbol,
48         address _owner
49     ) public {
50         totalSupply = initialSupply;  // Update total supply with the decimal amount
51         balanceOf[_owner] = totalSupply;                    // Give the creator all initial tokens
52         name = tokenName;                                       // Set the name for display purposes
53         symbol = tokenSymbol;                                   // Set the symbol for display purposes
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != address(0x0));
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
72         emit Transfer(_from, _to, _value);
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
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         _transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     /**
91      * Destroy tokens
92      *
93      * Remove `_value` tokens from the system irreversibly
94      *
95      * @param _value the amount of money to burn
96      */
97     function burn(uint256 _value) public returns (bool success) {
98         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
99         balanceOf[msg.sender] -= _value;            // Subtract from the sender
100         totalSupply -= _value;                      // Updates totalSupply
101         emit Burn(msg.sender, _value);
102         return true;
103     }
104 
105   
106 }
107 
108 /******************************************/
109 /*       ADVANCED TOKEN STARTS HERE       */
110 /******************************************/
111 
112 contract GOMIToken is owned, GOMIERC20 {
113 
114   
115     mapping (address => bool) public frozenAccount;
116 
117     /* This generates a public event on the blockchain that will notify clients */
118     event FrozenFunds(address target, bool frozen);
119 
120     /* Initializes contract with initial supply tokens to the creator of the contract */
121     constructor(
122         uint256 initialSupply,
123         string memory tokenName,
124         string memory tokenSymbol,
125         address _owner
126      ) owned(_owner) GOMIERC20(initialSupply, tokenName, tokenSymbol,_owner) public {}
127 
128     /* Internal transfer, only can be called by this contract */
129     function _transfer(address _from, address _to, uint _value) internal {
130         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
131         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
132         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
133         require(!frozenAccount[_from]);                         // Check if sender is frozen
134         require(!frozenAccount[_to]);                           // Check if recipient is frozen
135         balanceOf[_from] -= _value;                             // Subtract from the sender
136         balanceOf[_to] += _value;                               // Add the same to the recipient
137         emit Transfer(_from, _to, _value);
138     }
139 
140     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
141     /// @param target Address to be frozen 
142     /// @param freeze either to freeze it or not
143     function freezeAccount(address target, bool freeze) onlyOwner public {
144         frozenAccount[target] = freeze;
145         emit FrozenFunds(target, freeze);
146     }
147 
148 }