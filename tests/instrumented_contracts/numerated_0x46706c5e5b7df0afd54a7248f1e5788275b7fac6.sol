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
24     string public name = "Slidebits Token";
25     string public symbol = "SBT";
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 initialSupply = 100000000;
29     uint256 public totalSupply = initialSupply * 10 ** uint256(decimals);
30 
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     
38     // This generates a public event on the blockchain that will notify clients
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     constructor() public {
50         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
51     }
52 
53     /**
54      * Internal transfer, only can be called by this contract
55      */
56     function _transfer(address _from, address _to, uint _value) internal {
57         // Prevent transfer to 0x0 address. Use burn() instead
58         require(_to != address(0x0));
59         // Check if the sender has enough
60         require(balanceOf[_from] >= _value);
61         // Check for overflows
62         require(balanceOf[_to] + _value > balanceOf[_to]);
63         // Save this for an assertion in the future
64         uint previousBalances = balanceOf[_from] + balanceOf[_to];
65         // Subtract from the sender
66         balanceOf[_from] -= _value;
67         // Add the same to the recipient
68         balanceOf[_to] += _value;
69         emit Transfer(_from, _to, _value);
70         // Asserts are used to use static analysis to find bugs in your code. They should never fail
71         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
72     }
73 
74     /**
75      * Transfer tokens
76      *
77      * Send `_value` tokens to `_to` from your account
78      *
79      * @param _to The address of the recipient
80      * @param _value the amount to send
81      */
82     function transfer(address _to, uint256 _value) public returns (bool success) {
83         _transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     /**
88      * Transfer tokens from other address
89      *
90      * Send `_value` tokens to `_to` in behalf of `_from`
91      *
92      * @param _from The address of the sender
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         require(_value <= allowance[_from][msg.sender]);     // Check allowance
98         allowance[_from][msg.sender] -= _value;
99         _transfer(_from, _to, _value);
100         return true;
101     }
102 
103     /**
104      * Set allowance for other address
105      *
106      * Allows `_spender` to spend no more than `_value` tokens in your behalf
107      *
108      * @param _spender The address authorized to spend
109      * @param _value the max amount they can spend
110      */
111     function approve(address _spender, uint256 _value) public
112         returns (bool success) {
113         allowance[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     /**
119      * Set allowance for other address and notify
120      *
121      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      * @param _extraData some extra information to send to the approved contract
126      */
127     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
128         public
129         returns (bool success) {
130         tokenRecipient spender = tokenRecipient(_spender);
131         if (approve(_spender, _value)) {
132             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
133             return true;
134         }
135     }
136 
137     /**
138      * Destroy tokens
139      *
140      * Remove `_value` tokens from the system irreversibly
141      *
142      * @param _value the amount of money to burn
143      */
144     function burn(uint256 _value) public returns (bool success) {
145         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
146         balanceOf[msg.sender] -= _value;            // Subtract from the sender
147         totalSupply -= _value;                      // Updates totalSupply
148         emit Burn(msg.sender, _value);
149         return true;
150     }
151 
152     /**
153      * Destroy tokens from other account
154      *
155      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
156      *
157      * @param _from the address of the sender
158      * @param _value the amount of money to burn
159      */
160     function burnFrom(address _from, uint256 _value) public returns (bool success) {
161         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
162         require(_value <= allowance[_from][msg.sender]);    // Check allowance
163         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
164         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
165         totalSupply -= _value;                              // Update totalSupply
166         emit Burn(_from, _value);
167         return true;
168     }
169 }
170 
171 /******************************************/
172 /*       ADVANCED TOKEN STARTS HERE       */
173 /******************************************/
174 
175 contract SlidebitsToken is owned, TokenERC20 {
176 
177     mapping (address => bool) public frozenAccount;
178 
179     /* This generates a public event on the blockchain that will notify clients */
180     event FrozenFunds(address target, bool frozen);
181 
182     /* Initializes contract with initial supply tokens to the creator of the contract */
183     constructor() TokenERC20() public {}
184 
185     /* Internal transfer, only can be called by this contract */
186     function _transfer(address _from, address _to, uint _value) internal {
187         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
188         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
189         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
190         require(!frozenAccount[_from]);                         // Check if sender is frozen
191         require(!frozenAccount[_to]);                           // Check if recipient is frozen
192         balanceOf[_from] -= _value;                             // Subtract from the sender
193         balanceOf[_to] += _value;                               // Add the same to the recipient
194         emit Transfer(_from, _to, _value);
195     }
196 
197     /// @notice Create `mintedAmount` tokens and send it to `target`
198     /// @param target Address to receive the tokens
199     /// @param mintedAmount the amount of tokens it will receive
200     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
201         balanceOf[target] += mintedAmount;
202         totalSupply += mintedAmount;
203         emit Transfer(address(0), address(this), mintedAmount);
204         emit Transfer(address(this), target, mintedAmount);
205     }
206 
207     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
208     /// @param target Address to be frozen
209     /// @param freeze either to freeze it or not
210     function freezeAccount(address target, bool freeze) onlyOwner public {
211         frozenAccount[target] = freeze;
212         emit FrozenFunds(target, freeze);
213     }
214 }