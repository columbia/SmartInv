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
26     uint8 public decimals = 2;
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
90      * Transfer tokens from other address
91      *
92      * Send `_value` tokens to `_to` in behalf of `_from`
93      *
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);     // Check allowance
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * Destroy tokens
107      *
108      * Remove `_value` tokens from the system irreversibly
109      *
110      * @param _value the amount of money to burn
111      */
112     function burn(uint256 _value) public returns (bool success) {
113         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
114         balanceOf[msg.sender] -= _value;            // Subtract from the sender
115         totalSupply -= _value;                      // Updates totalSupply
116         Burn(msg.sender, _value);
117         return true;
118     }
119 
120     /**
121      * Destroy tokens from other account
122      *
123      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
124      *
125      * @param _from the address of the sender
126      * @param _value the amount of money to burn
127      */
128     function burnFrom(address _from, uint256 _value) public returns (bool success) {
129         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
130         require(_value <= allowance[_from][msg.sender]);    // Check allowance
131         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
132         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
133         totalSupply -= _value;                              // Update totalSupply
134         Burn(_from, _value);
135         return true;
136     }
137 }
138 
139 /******************************************/
140 /*       ADVANCED TOKEN STARTS HERE       */
141 /******************************************/
142 
143 contract MyAdvancedToken is owned, TokenERC20 {
144 
145     /* Initializes contract with initial supply tokens to the creator of the contract */
146     function MyAdvancedToken(
147         uint256 initialSupply,
148         string tokenName,
149         string tokenSymbol
150     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
151 
152     /// @notice Create `mintedAmount` tokens and send it to `target`
153     /// @param target Address to receive the tokens
154     /// @param mintedAmount the amount of tokens it will receive
155     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
156         balanceOf[target] += mintedAmount;
157         totalSupply += mintedAmount;
158         Transfer(0, this, mintedAmount);
159         Transfer(this, target, mintedAmount);
160     }
161 }