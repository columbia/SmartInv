1 contract owned {
2     address public owner;
3 
4     /* This notifies the owner transfer */
5     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7     function owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         require(newOwner != address(0));
18         OwnershipTransferred(owner, newOwner);
19         owner = newOwner;
20     }
21 }
22 
23 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
24 
25 contract TokenERC20 {
26     // Public variables of the token
27     string public name;
28     string public symbol;
29     uint8 public decimals = 18;
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
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     function TokenERC20(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = tokenName;                                   // Set the name for display purposes
56         symbol = tokenSymbol;                               // Set the symbol for display purposes
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75         Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80     /**
81      * Transfer tokens
82      *
83      * Send `_value` tokens to `_to` from your account
84      *
85      * @param _to The address of the recipient
86      * @param _value the amount to send
87      */
88     function transfer(address _to, uint256 _value) public {
89         _transfer(msg.sender, _to, _value);
90     }
91 
92     /**
93      * Transfer tokens from other address
94      *
95      * Send `_value` tokens to `_to` in behalf of `_from`
96      *
97      * @param _from The address of the sender
98      * @param _to The address of the recipient
99      * @param _value the amount to send
100      */
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
102         require(_value <= allowance[_from][msg.sender]);     // Check allowance
103         allowance[_from][msg.sender] -= _value;
104         _transfer(_from, _to, _value);
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address
110      *
111      * Allows `_spender` to spend no more than `_value` tokens in your behalf
112      *
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      */
116     function approve(address _spender, uint256 _value) public
117         returns (bool success) {
118         allowance[msg.sender][_spender] = _value;
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
152         Burn(msg.sender, _value);
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
164     function burnFrom(address _from, uint256 _value) public returns (bool success) {
165         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
166         require(_value <= allowance[_from][msg.sender]);    // Check allowance
167         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
168         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
169         totalSupply -= _value;                              // Update totalSupply
170         Burn(_from, _value);
171         return true;
172     }
173 }
174 
175 /******************************************/
176 /*      Copyright 2018 TaskBeep           */
177 /*   TaskBeep specific token definition   */
178 /*         Do not distribute              */
179 /******************************************/
180 
181 contract TaskBeep is owned, TokenERC20 {
182 
183     bool public mintingDone = false;
184 
185     mapping (address => bool) public frozenAccount;
186 
187     /* This generates a public event on the blockchain that will notify clients */
188     event FrozenFunds(address target, bool frozen);
189 
190     /* Initializes contract with initial supply tokens to the creator of the contract */
191     function TaskBeep(
192         uint256 initialSupply,
193         string tokenName,
194         string tokenSymbol
195     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
196 
197     /* Internal transfer, only can be called by this contract */
198     function _transfer(address _from, address _to, uint _value) internal {
199         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
200         require (balanceOf[_from] >= _value);               // Check if the sender has enough
201         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
202         require(!frozenAccount[_from]);                     // Check if sender is frozen
203         require(!frozenAccount[_to]);                       // Check if recipient is frozen
204         balanceOf[_from] -= _value;                         // Subtract from the sender
205         balanceOf[_to] += _value;                           // Add the same to the recipient
206         Transfer(_from, _to, _value);
207     }
208 
209     /// @notice Create `mintedAmount` tokens and send it to `target`
210     /// @param target Address to receive the tokens
211     /// @param mintedAmount the amount of tokens it will receive
212     function mint(address target, uint256 mintedAmount) onlyOwner public {
213         require(!mintingDone);
214         balanceOf[target] += mintedAmount;
215         totalSupply += mintedAmount;
216         Transfer(0, this, mintedAmount);
217         Transfer(this, target, mintedAmount);
218     }
219 
220     function rename(string newName, string newSymbol) onlyOwner public {
221         name = newName;
222         symbol = newSymbol;
223     }
224 
225     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
226     /// @param target Address to be frozen
227     /// @param freeze either to freeze it or not
228     function freezeAccount(address target, bool freeze) onlyOwner public {
229         frozenAccount[target] = freeze;
230         FrozenFunds(target, freeze);
231     }
232 
233     /// @notice Complete minting of the token. There will be no more token can be created.
234     function completeMinting() onlyOwner public {
235         mintingDone = true;
236     }
237 }