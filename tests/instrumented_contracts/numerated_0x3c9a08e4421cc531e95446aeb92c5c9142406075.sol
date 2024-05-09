1 pragma solidity ^0.4.21;
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
37     // This generates a public event on the blockchain that will notify clients
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
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
60         // Check if the sender has enough
61         require(balanceOf[_from] >= _value);
62         // Check for overflows
63         require(balanceOf[_to] + _value > balanceOf[_to]);
64         // Save this for an assertion in the future
65         uint previousBalances = balanceOf[_from] + balanceOf[_to];
66         // Subtract from the sender
67         balanceOf[_from] -= _value;
68         // Add the same to the recipient
69         balanceOf[_to] += _value;
70         emit Transfer(_from, _to, _value);
71         // Asserts are used to use static analysis to find bugs in your code. They should never fail
72         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
73     }
74 
75     /**
76      * Transfer tokens
77      *
78      * Send `_value` tokens to `_to` from your account
79      *
80      * @param _to The address of the recipient
81      * @param _value the amount to send
82      */
83     function transfer(address _to, uint256 _value) public returns (bool success) {
84         _transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /**
89      * Transfer tokens from other address
90      *
91      * Send `_value` tokens to `_to` in behalf of `_from`
92      *
93      * @param _from The address of the sender
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98         require(_value <= allowance[_from][msg.sender]);     // Check allowance
99         allowance[_from][msg.sender] -= _value;
100         _transfer(_from, _to, _value);
101         return true;
102     }
103 
104     /**
105      * Set allowance for other address
106      *
107      * Allows `_spender` to spend no more than `_value` tokens in your behalf
108      *
109      * @param _spender The address authorized to spend
110      * @param _value the max amount they can spend
111      */
112     function approve(address _spender, uint256 _value) public
113         returns (bool success) {
114         allowance[msg.sender][_spender] = _value;
115         emit Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     /**
120      * Set allowance for other address and notify
121      *
122      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
123      *
124      * @param _spender The address authorized to spend
125      * @param _value the max amount they can spend
126      * @param _extraData some extra information to send to the approved contract
127      */
128     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
129         public
130         returns (bool success) {
131         tokenRecipient spender = tokenRecipient(_spender);
132         if (approve(_spender, _value)) {
133             spender.receiveApproval(msg.sender, _value, this, _extraData);
134             return true;
135         }
136     }
137 }
138 
139 contract UnitedToken is owned, TokenERC20 {
140 
141     mapping (address => bool) public frozenAccount;
142 
143     /* This generates a public event on the blockchain that will notify clients */
144     event FrozenFunds(address target, bool frozen);
145 
146     /* Initializes contract with initial supply tokens to the creator of the contract */
147     function UnitedToken() TokenERC20(2000000000, "UnitedToken", "UNT") public {}
148 
149     /* Internal transfer, only can be called by this contract */
150     function _transfer(address _from, address _to, uint _value) internal {
151         require (balanceOf[_from] >= _value);               // Check if the sender has enough
152         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
153         require(!frozenAccount[_from]);                     // Check if sender is frozen
154         require(!frozenAccount[_to]);                       // Check if recipient is frozen
155         balanceOf[_from] -= _value;                         // Subtract from the sender
156         balanceOf[_to] += _value;                           // Add the same to the recipient
157         emit Transfer(_from, _to, _value);
158     }
159 
160     /// @notice Create `mintedAmount` tokens and send it to `target`
161     /// @param target Address to receive the tokens
162     /// @param mintedAmount the amount of tokens it will receive
163     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
164         balanceOf[target] += mintedAmount;
165         totalSupply += mintedAmount;
166         emit Transfer(0, this, mintedAmount);
167         emit Transfer(this, target, mintedAmount);
168     }
169 
170     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
171     /// @param target Address to be frozen
172     /// @param freeze either to freeze it or not
173     function freezeAccount(address target, bool freeze) onlyOwner public {
174         frozenAccount[target] = freeze;
175         emit FrozenFunds(target, freeze);
176     }
177 }