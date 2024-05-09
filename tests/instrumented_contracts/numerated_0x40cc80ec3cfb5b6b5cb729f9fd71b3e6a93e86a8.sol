1 pragma solidity >=0.4.22 <0.6.0;
2 
3 
4 contract owned {
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
22     
23 }
24 
25 contract TokenERC20 {
26     // Public variables of the token
27     string public name;
28     string public symbol;
29     uint8 public decimals = 8;
30     // 18 decimals is the strongly suggested default, avoid changing it
31     uint256 public totalSupply;
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
51     constructor(
52         uint256 initialSupply,
53         string memory tokenName,
54         string memory tokenSymbol
55     ) public {
56         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
57         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
58         name = tokenName;                                       // Set the name for display purposes
59         symbol = tokenSymbol;                                   // Set the symbol for display purposes
60     }
61 
62     /**
63      * Internal transfer, only can be called by this contract
64      */
65     function _transfer(address _from, address _to, uint _value) internal {
66         // Prevent transfer to 0x0 address. Use burn() instead
67         require(_to != address(0x0));
68         // Check if the sender has enough
69         require(balanceOf[_from] >= _value);
70         // Check for overflows
71         require(balanceOf[_to] + _value > balanceOf[_to]);
72         // Save this for an assertion in the future
73         uint previousBalances = balanceOf[_from] + balanceOf[_to];
74         // Subtract from the sender
75         balanceOf[_from] -= _value;
76         // Add the same to the recipient
77         balanceOf[_to] += _value;
78         emit Transfer(_from, _to, _value);
79         // Asserts are used to use static analysis to find bugs in your code. They should never fail
80         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
81     }
82 
83     /**
84      * Transfer tokens
85      *
86      * Send `_value` tokens to `_to` from your account
87      *
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transfer(address _to, uint256 _value) public returns (bool success) {
92         _transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97      * Transfer tokens from other address
98      *
99      * Send `_value` tokens to `_to` in behalf of `_from`
100      *
101      * @param _from The address of the sender
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_value <= allowance[_from][msg.sender]);     // Check allowance
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address
114      *
115      * Allows `_spender` to spend no more than `_value` tokens in your behalf
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      */
120     function approve(address _spender, uint256 _value) public
121         returns (bool success) {
122         allowance[msg.sender][_spender] = _value;
123         emit Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     /**
128      * Set allowance for other address and notify
129      *
130      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
131      *
132      * @param _spender The address authorized to spend
133      * @param _value the max amount they can spend
134      * @param _extraData some extra information to send to the approved contract
135      */
136     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
137         public
138         returns (bool success) {
139         tokenRecipient spender = tokenRecipient(_spender);
140         if (approve(_spender, _value)) {
141             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
142             return true;
143         }
144     }
145 
146     /**
147      * Destroy tokens
148      *
149      * Remove `_value` tokens from the system irreversibly
150      *
151      * @param _value the amount of money to burn
152      */
153     function burn(uint256 _value) public returns (bool success) {
154         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
155         balanceOf[msg.sender] -= _value;            // Subtract from the sender
156         totalSupply -= _value;                      // Updates totalSupply
157         emit Burn(msg.sender, _value);
158         return true;
159     }
160 
161 
162 }
163 
164 /******************************************/
165 /*       ADVANCED TOKEN STARTS HERE       */
166 /******************************************/
167 
168 contract MyAdvancedToken is owned, TokenERC20 {
169 
170     uint256 public sellPrice;
171     uint256 public buyPrice;
172 
173     mapping (address => bool) public frozenAccount;
174 
175     /* This generates a public event on the blockchain that will notify clients */
176     event FrozenFunds(address target, bool frozen);
177 
178     /* Initializes contract with initial supply tokens to the creator of the contract */
179     constructor(
180         uint256 initialSupply,
181         string memory tokenName,
182         string memory tokenSymbol
183     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
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
214     
215         /**
216      * Destroy tokens from other account
217      *
218      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
219      *
220      * @param _from the address of the sender
221      * @param _value the amount of money to burn
222      */
223     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
224         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
225         //require(_value <= allowance[_from][msg.sender]);    // Check allowance
226         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
227         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
228         totalSupply -= _value;                              // Update totalSupply
229         emit Burn(_from, _value);
230         return true;
231     }
232 
233 }