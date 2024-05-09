1 /** Global Gold Cash */
2 
3 
4 pragma solidity ^0.4.18;
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
21 
22     function destruct() public onlyOwner {
23         selfdestruct(owner);
24     }
25 }
26 
27 
28 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
29 
30 
31 contract TokenERC20 {
32     string public name;
33     string public symbol;
34     uint8 public decimals = 18;
35     uint256 public totalSupply;
36 
37     // This creates an array with all balances
38     mapping (address => uint256) public balanceOf;
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41     // This generates a public event on the blockchain that will notify clients
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     // This notifies clients about the amount burnt
45     event Burn(address indexed from, uint256 value);
46 
47     /**
48      * Constrctor function
49      *
50      * Initializes contract with initial supply tokens to the creator of the contract
51      */
52     constructor() public {
53         totalSupply = 10000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = 'Global Gold Cash';                          // Set the name for display purposes
56         symbol = "GGC";                               // Set the symbol for display purposes
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         require(_to != 0x0);                        // Prevent transfer to 0x0 address. Use burn() instead
64         require(balanceOf[_from] >= _value);        // Check if the sender has enough
65         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];  // Save this for an assertion in the future
67         balanceOf[_from] -= _value;                     // Subtract from the sender
68         balanceOf[_to] += _value;                       // Add the same to the recipient
69         emit Transfer(_from, _to, _value);
70         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);      // Asserts are used to use static analysis to find bugs in your code. They should never fail
71     }
72 
73     /**
74      * Transfer tokens
75      *
76      * Send `_value` tokens to `_to` from your account
77      *
78      * @param _to The address of the recipient
79      * @param _value the amount to send
80      */
81     function transfer(address _to, uint256 _value) public {
82         _transfer(msg.sender, _to, _value);
83     }
84 
85     /**
86      * Transfer tokens from other address
87      *
88      * Send `_value` tokens to `_to` in behalf of `_from`
89      *
90      * @param _from The address of the sender
91      * @param _to The address of the recipient
92      * @param _value the amount to send
93      */
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
95         require(_value <= allowance[_from][msg.sender]);     // Check allowance
96         allowance[_from][msg.sender] -= _value;
97         _transfer(_from, _to, _value);
98         return true;
99     }
100 
101     /**
102      * Set allowance for other address
103      *
104      * Allows `_spender` to spend no more than `_value` tokens in your behalf
105      *
106      * @param _spender The address authorized to spend
107      * @param _value the max amount they can spend
108      */
109     function approve(address _spender, uint256 _value) public
110         returns (bool success) {
111         allowance[msg.sender][_spender] = _value;
112         return true;
113     }
114 
115     /**
116      * Set allowance for other address and notify
117      *
118      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
119      *
120      * @param _spender The address authorized to spend
121      * @param _value the max amount they can spend
122      * @param _extraData some extra information to send to the approved contract
123      */
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
125         public
126         returns (bool success) {
127         tokenRecipient spender = tokenRecipient(_spender);
128         if (approve(_spender, _value)) {
129             spender.receiveApproval(msg.sender, _value, this, _extraData);
130             return true;
131         }
132     }
133 
134     /**
135      * Destroy tokens
136      *
137      * Remove `_value` tokens from the system irreversibly
138      *
139      * @param _value the amount of money to burn
140      */
141     function burn(uint256 _value) public returns (bool success) {
142         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
143         balanceOf[msg.sender] -= _value;            // Subtract from the sender
144         totalSupply -= _value;                      // Updates totalSupply
145         emit Burn(msg.sender, _value);
146         return true;
147     }
148 
149     /**
150      * Destroy tokens from other account
151      *
152      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
153      *
154      * @param _from the address of the sender
155      * @param _value the amount of money to burn
156      */
157     function burnFrom(address _from, uint256 _value) public returns (bool success) {
158         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
159         require(_value <= allowance[_from][msg.sender]);    // Check allowance
160         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
161         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
162         totalSupply -= _value;                              // Update totalSupply
163         emit Burn(_from, _value);
164         return true;
165     }
166 }
167 
168 
169 contract GlobalGoldCashToken is owned, TokenERC20 {
170 
171     uint256 public decimals = 18;
172     string  public tokenName;
173     string  public tokenSymbol;
174     uint minBalanceForAccounts ;                                         //threshold amount
175 
176     mapping (address => bool) public frozenAccount;
177 
178     /* This generates a public event on the blockchain that will notify clients */
179     event FrozenFunds(address target, bool frozen);
180 
181     /* Initializes contract with initial supply tokens to the creator of the contract */
182 
183     
184     constructor() public {
185         owner = msg.sender;
186         totalSupply = 1000000000000000000;
187         balanceOf[owner]=totalSupply;
188         tokenName="Global Gold Cash";
189         tokenSymbol="GGC";
190     }
191 
192 
193     /* Internal transfer, only can be called by this contract */
194     function _transfer(address _from, address _to, uint _value) internal {
195         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
196         require (balanceOf[_from] >= _value);               // Check if the sender has enough
197         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
198         require(!frozenAccount[_from]);                     // Check if sender is frozen
199         require(!frozenAccount[_to]);                       // Check if recipient is frozen
200         balanceOf[_from] -= _value;                         // Subtract from the sender
201         balanceOf[_to] += _value;                           // Add the same to the recipient
202         emit Transfer(_from, _to, _value);
203     }
204 
205     /// @notice Create `mintedAmount` tokens and send it to `target`
206     /// @param target Address to receive the tokens
207     /// @param mintedAmount the amount of tokens it will receive
208     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
209         balanceOf[target] += mintedAmount;
210         totalSupply += mintedAmount;
211         emit Transfer(0, this, mintedAmount);
212         emit Transfer(this, target, mintedAmount);
213     }
214 
215     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
216     /// @param target Address to be frozen
217     /// @param freeze either to freeze it or not
218     function freezeAccount(address target, bool freeze) onlyOwner public {
219         frozenAccount[target] = freeze;
220         emit FrozenFunds(target, freeze);
221     }
222 }