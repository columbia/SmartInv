1 pragma solidity ^0.4.15;
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
72         Transfer(_from, _to, _value);
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
85     function transfer(address _to, uint256 _value) public {
86         _transfer(msg.sender, _to, _value);
87     }
88 
89     /**
90      * Set allowance for other address
91      *
92      * Allows `_spender` to spend no more than `_value` tokens in your behalf
93      *
94      * @param _spender The address authorized to spend
95      * @param _value the max amount they can spend
96      */
97     function approve(address _spender, uint256 _value) public
98         returns (bool success) {
99         allowance[msg.sender][_spender] = _value;
100         return true;
101     }
102 
103     /**
104      * Destroy tokens
105      *
106      * Remove `_value` tokens from the system irreversibly
107      *
108      * @param _value the amount of money to burn
109      */
110     function burn(uint256 _value) public returns (bool success) {
111         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
112         balanceOf[msg.sender] -= _value;            // Subtract from the sender
113         totalSupply -= _value;                      // Updates totalSupply
114         Burn(msg.sender, _value);
115         return true;
116     }
117 }
118 
119 /******************************************/
120 /*       ADVANCED TOKEN STARTS HERE       */
121 /******************************************/
122 
123 contract RBC is owned, TokenERC20 {
124 
125     mapping (address => uint256) public frozenAccount;
126 
127     /* This generates a public event on the blockchain that will notify clients */
128     event FrozenFunds(address indexed from, uint256 _value);
129 	event UnFrozenFunds(address indexed from, uint256 _value);
130 
131     /* Initializes contract with initial supply tokens to the creator of the contract */
132     function RBC(
133         uint256 initialSupply,
134         string tokenName,
135         string tokenSymbol
136     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
137 
138     /* Internal transfer, only can be called by this contract */
139     function _transfer(address _from, address _to, uint _value) internal {
140         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
141         require (balanceOf[_from] >= _value);               // Check if the sender has enough
142         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
143         balanceOf[_from] -= _value;                         // Subtract from the sender
144         balanceOf[_to] += _value;                           // Add the same to the recipient
145         Transfer(_from, _to, _value);
146     }
147 
148     /// @param _value amount of token to be burnt by msg.sender
149 	function freezeAccount(uint256 _value) onlyOwner returns (bool success) {
150         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
151 		if (_value <= 0) throw; 
152         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
153         frozenAccount[msg.sender] += _value;                  // Updates totalSupply
154         FrozenFunds(msg.sender, _value);
155         return true;
156     }
157 	
158 	function unfreezeAccount(uint256 _value) onlyOwner returns (bool success) {
159         if (frozenAccount[msg.sender] < _value) throw;            // Check if the sender has enough
160 		if (_value <= 0) throw; 
161         frozenAccount[msg.sender] -= _value;                      // Subtract from the sender
162 		balanceOf[msg.sender] += _value;
163         UnFrozenFunds(msg.sender, _value);
164         return true;
165     }
166 }