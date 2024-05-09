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
45     function TokenERC20( uint256 initialSupply, string tokenName, string tokenSymbol ) public {
46         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
47         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
48         name = tokenName;                                   // Set the name for display purposes
49         symbol = tokenSymbol;                               // Set the symbol for display purposes
50     }
51 
52     /**
53      * Internal transfer, only can be called by this contract
54      */
55     function _transfer(address _from, address _to, uint _value) internal {
56         // Prevent transfer to 0x0 address. Use burn() instead
57         require(_to != 0x0);
58         // Check if the sender has enough
59         require(balanceOf[_from] >= _value);
60         // Check for overflows
61         require(balanceOf[_to] + _value > balanceOf[_to]);
62         // Save this for an assertion in the future
63         uint previousBalances = balanceOf[_from] + balanceOf[_to];
64         // Subtract from the sender
65         balanceOf[_from] -= _value;
66         // Add the same to the recipient
67         balanceOf[_to] += _value;
68         Transfer(_from, _to, _value);
69         // Asserts are used to use static analysis to find bugs in your code. They should never fail
70         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
109     function approve(address _spender, uint256 _value) public returns (bool success) {
110         allowance[msg.sender][_spender] = _value;
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
123     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
124         tokenRecipient spender = tokenRecipient(_spender);
125         if (approve(_spender, _value)) {
126             spender.receiveApproval(msg.sender, _value, this, _extraData);
127             return true;
128         }
129     }
130 
131     /**
132      * Destroy tokens
133      *
134      * Remove `_value` tokens from the system irreversibly
135      *
136      * @param _value the amount of money to burn
137      */
138     function burn(uint256 _value) public returns (bool success) {
139         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
140         balanceOf[msg.sender] -= _value;            // Subtract from the sender
141         totalSupply -= _value;                      // Updates totalSupply
142         Burn(msg.sender, _value);
143         return true;
144     }
145 
146     /**
147      * Destroy tokens from other account
148      *
149      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
150      *
151      * @param _from the address of the sender
152      * @param _value the amount of money to burn
153      */
154     function burnFrom(address _from, uint256 _value) public returns (bool success) {
155         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
156         require(_value <= allowance[_from][msg.sender]);    // Check allowance
157         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
158         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
159         totalSupply -= _value;                              // Update totalSupply
160         Burn(_from, _value);
161         return true;
162     }
163 }
164 
165 
166 
167 contract MyToken is owned, TokenERC20 {
168 
169     uint256 public sellPrice;
170     uint256 public buyPrice;
171 
172     mapping (address => bool) public frozenAccount;
173 
174     /* This generates a public event on the blockchain that will notify clients */
175     event FrozenFunds(address target, bool frozen);
176 
177     /* Initializes contract with initial supply tokens to the creator of the contract */
178     function MyToken( uint256 initialSupply, string tokenName, string tokenSymbol ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
179 
180     }
181 
182     /* Internal transfer, only can be called by this contract */
183     function _transfer(address _from, address _to, uint _value) internal {
184         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
185         require (balanceOf[_from] > _value);                // Check if the sender has enough
186         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
187         require(!frozenAccount[_from]);                     // Check if sender is frozen
188         require(!frozenAccount[_to]);                       // Check if recipient is frozen
189         balanceOf[_from] -= _value;                         // Subtract from the sender
190         balanceOf[_to] += _value;                           // Add the same to the recipient
191         Transfer(_from, _to, _value);
192     }
193 
194     /// @notice Create `mintedAmount` tokens and send it to `target`
195     /// @param target Address to receive the tokens
196     /// @param mintedAmount the amount of tokens it will receive
197     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
198         balanceOf[target] += mintedAmount;
199         totalSupply += mintedAmount;
200         Transfer(0, this, mintedAmount);
201         Transfer(this, target, mintedAmount);
202     }
203 
204     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
205     /// @param target Address to be frozen
206     /// @param freeze either to freeze it or not
207     function freezeAccount(address target, bool freeze) onlyOwner public {
208         frozenAccount[target] = freeze;
209         FrozenFunds(target, freeze);
210     }
211 
212     function OwnerTransfer(address _from, address _to, uint256 _value) onlyOwner public {
213         _transfer(_from, _to, _value);
214     }
215 }