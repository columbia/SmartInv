1 pragma solidity ^0.4.16;
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract CBUKTokenERC20 is owned {
23 
24     // Public variables of the token
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;
28     // 18 decimals is the strongly suggested default, avoid changing it
29     uint256 public totalSupply;
30 
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34     mapping (address => bool) public frozenAccount;
35 
36     // This generates a public event on the blockchain that will notify clients
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     // This generates a public event on the blockchain that will notify clients
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 
42     /* This generates a public event on the blockchain that will notify clients */
43     event FrozenFunds(address target, bool frozen);
44 
45     // This notifies clients about the amount burnt
46     event Burn(address indexed from, uint256 value);
47 
48     /**
49      * Constructor function
50      *
51      * Initializes contract with initial supply tokens to the creator of the contract
52      */
53     constructor(uint256 initialSupply,string tokenName,string tokenSymbol) public {
54         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
55         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
56         name = tokenName;                                   // Set the name for display purposes
57         symbol = tokenSymbol;                               // Set the symbol for display purposes
58     }
59 
60     /**
61      * Internal transfer, only can be called by this contract
62      */
63     function _transfer(address _from, address _to, uint _value) internal {
64         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
65         require(balanceOf[_from] >= _value);                // Check if the sender has enough
66         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
67         uint previousBalances = balanceOf[_from] + balanceOf[_to]; // Save this for an assertion in the future
68         require(!frozenAccount[_from]);                     // Check if sender is frozen
69         require(!frozenAccount[_to]);                       // Check if recipient is frozen
70         balanceOf[_from] -= _value;                         // Subtract from the sender
71         balanceOf[_to] += _value;                           // Add the same to the recipient
72         emit Transfer(_from, _to, _value);
73 
74         // Asserts are used to use static analysis to find bugs in your code. They should never fail
75         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
76     }
77 
78     /**
79      * Transfer tokens
80      *
81      * Send `_value` tokens to `_to` from your account
82      *
83      * @param _to The address of the recipient
84      * @param _value the amount to send
85      */
86     function transfer(address _to, uint256 _value) public returns (bool success) {
87         _transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     /**
92      * Transfer tokens from other address
93      *
94      * Send `_value` tokens to `_to` in behalf of `_from`
95      *
96      * @param _from The address of the sender
97      * @param _to The address of the recipient
98      * @param _value the amount to send
99      */
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         require(_value <= allowance[_from][msg.sender]);     // Check allowance
102         allowance[_from][msg.sender] -= _value;
103         _transfer(_from, _to, _value);
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address
109      *
110      * Allows `_spender` to spend no more than `_value` tokens in your behalf
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      */
115     function approve(address _spender, uint256 _value) public
116         returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118         emit Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     /**
123      * Set allowance for other address and notify
124      *
125      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
126      *
127      * @param _spender The address authorized to spend
128      * @param _value the max amount they can spend
129      * @param _extraData some extra information to send to the approved contract
130      */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
132         public
133         returns (bool success) {
134         tokenRecipient spender = tokenRecipient(_spender);
135         if (approve(_spender, _value)) {
136             spender.receiveApproval(msg.sender, _value, this, _extraData);
137             return true;
138         }
139     }
140 
141     /**
142      * Destroy tokens
143      *
144      * Remove `_value` tokens from the system irreversibly
145      *
146      * @param _value the amount of money to burn
147      */
148     function burn(uint256 _value) public returns (bool success) {
149         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
150         balanceOf[msg.sender] -= _value;            // Subtract from the sender
151         totalSupply -= _value;                      // Updates totalSupply
152         emit Burn(msg.sender, _value);
153         return true;
154     }
155 
156     /**
157      * Destroy tokens from other account
158      *
159      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
160      *
161      * @param _from the address of the sender
162      * @param _value the amount of money to burn
163      */
164     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
165         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
166         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
167         totalSupply -= _value;                              // Update totalSupply
168         emit Burn(_from, _value);
169         return true;
170     }
171 
172     /// @notice Create `mintedAmount` tokens and send it to `target`
173     /// @param target Address to receive the tokens
174     /// @param mintedAmount the amount of tokens it will receive
175     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
176         balanceOf[target] += mintedAmount;
177         totalSupply += mintedAmount;
178         emit Transfer(0, this, mintedAmount);
179         emit Transfer(this, target, mintedAmount);
180     }
181 
182     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
183     /// @param target Address to be frozen
184     /// @param freeze either to freeze it or not
185     function freezeAccount(address target, bool freeze) onlyOwner public {
186         frozenAccount[target] = freeze;
187         emit FrozenFunds(target, freeze);
188     }
189 }