1 pragma solidity >=0.4.22 <0.6.0;
2 
3 // Current version:0.5.3+commit.10d17f24.Emscripten.clang
4 // Optinization: YES
5 
6 contract owned {
7     address public owner;
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) onlyOwner public {
19         owner = newOwner;
20     }
21 }
22 
23 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
24 
25 contract TokenERC20 {
26     // Public variables of the token
27     string public name = "NIX10";
28     string public symbol = "NIX10";
29     uint8 public decimals = 18;
30     // 18 decimals is the strongly suggested default, avoid changing it
31     uint256 public totalSupply = 99;
32 
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     
40     // This generates a public event on the blockchain that will notify clients
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 
43     // This notifies clients about the amount burnt
44     event Burn(address indexed from, uint256 value);
45 
46     /**
47      * Constrctor function
48      *
49      * Initializes contract with initial supply tokens to the creator of the contract
50      */
51     constructor() public {
52         totalSupply = 100 ** uint256(decimals);  // Update total supply with the decimal amount
53         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
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
91      * Transfer tokens from other address
92      *
93      * Send `_value` tokens to `_to` in behalf of `_from`
94      *
95      * @param _from The address of the sender
96      * @param _to The address of the recipient
97      * @param _value the amount to send
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         require(_value <= allowance[_from][msg.sender]);     // Check allowance
101         allowance[_from][msg.sender] -= _value;
102         _transfer(_from, _to, _value);
103         return true;
104     }
105 
106     /**
107      * Set allowance for other address
108      *
109      * Allows `_spender` to spend no more than `_value` tokens in your behalf
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      */
114     function approve(address _spender, uint256 _value) public
115         returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
136             return true;
137         }
138     }
139 
140     /**
141      * Destroy tokens
142      *
143      * Remove `_value` tokens from the system irreversibly
144      *
145      * @param _value the amount of money to burn
146      */
147     function burn(uint256 _value) public returns (bool success) {
148         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
149         balanceOf[msg.sender] -= _value;            // Subtract from the sender
150         totalSupply -= _value;                      // Updates totalSupply
151         emit Burn(msg.sender, _value);
152         return true;
153     }
154 
155     /**
156      * Destroy tokens from other account
157      *
158      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
159      *
160      * @param _from the address of the sender
161      * @param _value the amount of money to burn
162      */
163     function burnFrom(address _from, uint256 _value) public returns (bool success) {
164         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
165         require(_value <= allowance[_from][msg.sender]);    // Check allowance
166         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
167         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
168         totalSupply -= _value;                              // Update totalSupply
169         emit Burn(_from, _value);
170         return true;
171     }
172 }
173 
174 /******************************************/
175 /*       ADVANCED TOKEN STARTS HERE       */
176 /******************************************/
177 
178 contract MyAdvancedToken is owned, TokenERC20 {
179 
180     mapping (address => bool) public frozenAccount;
181 
182     /* This generates a public event on the blockchain that will notify clients */
183     event FrozenFunds(address target, bool frozen);
184 
185     /* Initializes contract with initial supply tokens to the creator of the contract */
186     constructor() TokenERC20() public {}
187 
188     /* Internal transfer, only can be called by this contract */
189     function _transfer(address _from, address _to, uint _value) internal {
190         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
191         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
192         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
193         require(!frozenAccount[_from]);                         // Check if sender is frozen
194         require(!frozenAccount[_to]);                           // Check if recipient is frozen
195         balanceOf[_from] -= _value;                             // Subtract from the sender
196         balanceOf[_to] += _value;                               // Add the same to the recipient
197         emit Transfer(_from, _to, _value);
198     }
199 
200     /// @notice Create `mintedAmount` tokens and send it to `target`
201     /// @param target Address to receive the tokens
202     /// @param mintedAmount the amount of tokens it will receive
203     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
204         balanceOf[target] += mintedAmount;
205         totalSupply += mintedAmount;
206         emit Transfer(address(0), address(this), mintedAmount);
207         emit Transfer(address(this), target, mintedAmount);
208     }
209 
210     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
211     /// @param target Address to be frozen
212     /// @param freeze either to freeze it or not
213     function freezeAccount(address target, bool freeze) onlyOwner public {
214         frozenAccount[target] = freeze;
215         emit FrozenFunds(target, freeze);
216     }
217 
218 }