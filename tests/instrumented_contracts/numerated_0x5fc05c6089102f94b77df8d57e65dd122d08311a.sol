1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name = "m365 coin";
25     string public symbol = "TSF";
26     uint8 public decimals = 8;
27     uint256 public totalSupply = 1000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
28     uint256 public maxSupply = 1000000000 * 10 ** uint256(decimals);    // maximum supply = 1000000000e8
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
45     constructor() public {
46         balanceOf[msg.sender] = totalSupply;                    // Set the symbol for display purposes
47     }
48 
49     /**
50      * Internal transfer, only can be called by this contract
51      */
52     function _transfer(address _from, address _to, uint _value) internal {
53         // Prevent transfer to 0x0 address
54         require(_to != address(0x0));
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
70     /**
71      * Transfer tokens
72      *
73      * Send `_value` tokens to `_to` from your account
74      *
75      * @param _to The address of the recipient
76      * @param _value the amount to send
77      */
78     function transfer(address _to, uint256 _value) public returns (bool success) {
79         _transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     /**
84      * Transfer tokens from other address
85      *
86      * Send `_value` tokens to `_to` in behalf of `_from`
87      *
88      * @param _from The address of the sender
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         require(_value <= allowance[_from][msg.sender]);     // Check allowance
94         allowance[_from][msg.sender] -= _value;
95         _transfer(_from, _to, _value);
96         return true;
97     }
98 
99     /**
100      * Set allowance for other address
101      *
102      * Allows `_spender` to spend no more than `_value` tokens in your behalf
103      *
104      * @param _spender The address authorized to spend
105      * @param _value the max amount they can spend
106      */
107     function approve(address _spender, uint256 _value) public
108         returns (bool success) {
109         allowance[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     /**
115      * Set allowance for other address and notify
116      *
117      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
118      *
119      * @param _spender The address authorized to spend
120      * @param _value the max amount they can spend
121      * @param _extraData some extra information to send to the approved contract
122      */
123     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
124         public
125         returns (bool success) {
126         tokenRecipient spender = tokenRecipient(_spender);
127         if (approve(_spender, _value)) {
128             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
129             return true;
130         }
131     }
132 }
133 
134 /******************************************/
135 /*       ADVANCED TOKEN STARTS HERE       */
136 /******************************************/
137 
138 contract m365coin is owned, TokenERC20 {
139 
140     mapping (address => bool) public frozenAccount;
141 
142     /* This generates a public event on the blockchain that will notify clients */
143     event FrozenFunds(address target, bool frozen);
144 
145     /* Initializes contract with initial supply tokens to the creator of the contract */
146     constructor() TokenERC20() public {}
147 
148     /* Internal transfer, only can be called by this contract */
149     function _transfer(address _from, address _to, uint _value) internal {
150         require (_to != address(0x0));                          // Prevent transfer to 0x0 address
151         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
152         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
153         require(!frozenAccount[_from]);                         // Check if sender is frozen
154         require(!frozenAccount[_to]);                           // Check if recipient is frozen
155         balanceOf[_from] -= _value;                             // Subtract from the sender
156         balanceOf[_to] += _value;                               // Add the same to the recipient
157         emit Transfer(_from, _to, _value);
158     }
159 
160     /// @notice Create `mintedAmount` tokens and send it to `target`
161     /// @param target Address to receive the tokens
162     /// @param mintedAmount the amount of tokens it will receive
163     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
164         uint256 amount = totalSupply + mintedAmount;
165         if (amount <= maxSupply) {
166             balanceOf[target] += mintedAmount;
167             totalSupply = amount;
168             emit Transfer(address(0), address(this), mintedAmount);
169             emit Transfer(address(this), target, mintedAmount);
170         }
171     }
172 
173     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
174     /// @param target Address to be frozen
175     /// @param freeze either to freeze it or not
176     function freezeAccount(address target, bool freeze) onlyOwner public {
177         frozenAccount[target] = freeze;
178         emit FrozenFunds(target, freeze);
179     }
180 }