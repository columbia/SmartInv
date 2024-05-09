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
106      * Set allowance for other address
107      *
108      * Allows `_spender` to spend no more than `_value` tokens in your behalf
109      *
110      * @param _spender The address authorized to spend
111      * @param _value the max amount they can spend
112      */
113     function approve(address _spender, uint256 _value) public
114         returns (bool success) {
115         allowance[msg.sender][_spender] = _value;
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
137 
138     /**
139      * Destroy tokens
140      *
141      * Remove `_value` tokens from the system irreversibly
142      *
143      * @param _value the amount of money to burn
144      */
145     function burn(uint256 _value) public returns (bool success) {
146         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
147         balanceOf[msg.sender] -= _value;            // Subtract from the sender
148         totalSupply -= _value;                      // Updates totalSupply
149         Burn(msg.sender, _value);
150         return true;
151     }
152 
153     /**
154      * Destroy tokens from other account
155      *
156      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
157      *
158      * @param _from the address of the sender
159      * @param _value the amount of money to burn
160      */
161     function burnFrom(address _from, uint256 _value) public returns (bool success) {
162         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
163         require(_value <= allowance[_from][msg.sender]);    // Check allowance
164         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
165         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
166         totalSupply -= _value;                              // Update totalSupply
167         Burn(_from, _value);
168         return true;
169     }
170 }
171 
172 /******************************************/
173 /*       ADVANCED TOKEN STARTS HERE       */
174 /******************************************/
175 
176 contract MyAdvancedToken is owned, TokenERC20 {
177 
178 
179     mapping (address => bool) public frozenAccount;
180 
181     /* This generates a public event on the blockchain that will notify clients */
182     event FrozenFunds(address target, bool frozen);
183 
184     /* Initializes contract with initial supply tokens to the creator of the contract */
185     function MyAdvancedToken(
186         uint256 initialSupply,
187         string tokenName,
188         string tokenSymbol
189     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
190 
191 
192     /// @notice Create `mintedAmount` tokens and send it to `target`
193     /// @param target Address to receive the tokens
194     /// @param mintedAmount the amount of tokens it will receive
195     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
196         balanceOf[target] += mintedAmount;
197         totalSupply += mintedAmount;
198         Transfer(0, this, mintedAmount);
199         Transfer(this, target, mintedAmount);
200     }
201 
202     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
203     /// @param target Address to be frozen
204     /// @param freeze either to freeze it or not
205     function freezeAccount(address target, bool freeze) onlyOwner public {
206         frozenAccount[target] = freeze;
207         FrozenFunds(target, freeze);
208     }
209 
210 }