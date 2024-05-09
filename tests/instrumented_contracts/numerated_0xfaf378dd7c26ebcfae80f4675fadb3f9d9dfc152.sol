1 pragma solidity 0.4.21;
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
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
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54     }
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
90 
91     /**
92      * Destroy tokens
93      *
94      * Remove `_value` tokens from the system irreversibly
95      *
96      * @param _value the amount of money to burn
97      */
98     function burn(uint256 _value) public returns (bool success) {
99         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
100         balanceOf[msg.sender] -= _value;            // Subtract from the sender
101         totalSupply -= _value;                      // Updates totalSupply
102         emit Burn(msg.sender, _value);
103         return true;
104     }
105 
106 }
107 
108 /******************************************/
109 /*       ADVANCED TOKEN STARTS HERE       */
110 /******************************************/
111 contract ELACoin is owned, TokenERC20 {
112 
113     mapping (address => bool) public frozenAccount;
114 
115     /* This generates a public event on the blockchain that will notify clients */
116     event FrozenFunds(address target, bool frozen);
117     event TransferEnabled (bool);
118     event TransferDisabled (bool);
119 
120     /* Initializes contract with initial supply tokens to the creator of the contract */
121     function ELACoin(
122         uint256 initialSupply,
123         string tokenName,
124         string tokenSymbol
125     ) TokenERC20 (initialSupply, tokenName, tokenSymbol) public {
126         TransferAllowed = true;
127     }
128 
129     /* Internal transfer, only can be called by this contract */
130     function _transfer(address _from, address _to, uint _value) internal {
131         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
132         require (balanceOf[_from] >= _value);               // Check if the sender has enough
133         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
134         require(!frozenAccount[_from]);                     // Check if sender is frozen
135         require(!frozenAccount[_to]);                       // Check if recipient is frozen
136         require (TransferAllowed);                          // Check if transfer is enabled
137         balanceOf[_from] -= _value;                         // Subtract from the sender
138         balanceOf[_to] += _value;                           // Add the same to the recipient
139         emit Transfer(_from, _to, _value);
140     }
141 
142     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
143     /// @param target Address to be frozen
144     /// @param freeze either to freeze it or not
145     function freezeAccount(address target, bool freeze) onlyOwner public {
146         frozenAccount[target] = freeze;
147         emit FrozenFunds(target, freeze);
148     }
149 
150     /// Set whether transfer is enabled or disabled
151     
152     bool public TransferAllowed;
153 
154     function enableTokenTransfer() onlyOwner public {
155         TransferAllowed = true;
156         emit TransferEnabled (true);
157 }
158 
159     function disableTokenTransfer() onlyOwner public {
160         TransferAllowed = false;
161         emit TransferDisabled (false);
162 }
163 }