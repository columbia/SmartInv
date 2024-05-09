1 contract owned {
2     address public owner;
3 
4     function owned() public {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner public {
14         owner = newOwner;
15     }
16 }
17 
18 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
19 
20 contract SocialPolis {
21     // Public variables of the token
22     string public name;
23     string public symbol;
24     uint8 public decimals = 18;
25     // 18 decimals is the strongly suggested default, avoid changing it
26     uint256 public totalSupply;
27 
28     // This creates an array with all balances
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     // This generates a public event on the blockchain that will notify clients
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     // This notifies clients about the amount burnt
36     event Burn(address indexed from, uint256 value);
37 
38     /**
39      * Constrctor function
40      *
41      * Initializes contract with initial supply tokens to the creator of the contract
42      */
43     function SocialPolis() public {
44         totalSupply = 200000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
45         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
46         name = "SocialPolis";                                   // Set the name for display purposes
47         symbol = "SPL";                               // Set the symbol for display purposes
48     }
49 
50     /**
51      * Internal transfer, only can be called by this contract
52      */
53     function _transfer(address _from, address _to, uint _value) internal {
54         // Prevent transfer to 0x0 address. Use burn() instead
55         require(_to != 0x0);
56         // Check if the sender has enough
57         require(balanceOf[_from] >= _value);
58         // Check for overflows
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60         // Save this for an assertion in the future
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         // Subtract from the sender
63         balanceOf[_from] -= _value;
64         // Add the same to the recipient
65         balanceOf[_to] += _value;
66         Transfer(_from, _to, _value);
67         // Asserts are used to use static analysis to find bugs in your code. They should never fail
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
69     }
70 
71     /**
72      * Transfer tokens
73      *
74      * Send `_value` tokens to `_to` from your account
75      *
76      * @param _to The address of the recipient
77      * @param _value the amount to send
78      */
79     function transfer(address _to, uint256 _value) public {
80         _transfer(msg.sender, _to, _value);
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
110         return true;
111     }
112 
113     /**
114      * Set allowance for other address and notify
115      *
116      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
117      *
118      * @param _spender The address authorized to spend
119      * @param _value the max amount they can spend
120      * @param _extraData some extra information to send to the approved contract
121      */
122     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
123         public
124         returns (bool success) {
125         tokenRecipient spender = tokenRecipient(_spender);
126         if (approve(_spender, _value)) {
127             spender.receiveApproval(msg.sender, _value, this, _extraData);
128             return true;
129         }
130     }
131 
132     /**
133      * Destroy tokens
134      *
135      * Remove `_value` tokens from the system irreversibly
136      *
137      * @param _value the amount of money to burn
138      */
139     function burn(uint256 _value) public returns (bool success) {
140         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
141         balanceOf[msg.sender] -= _value;            // Subtract from the sender
142         totalSupply -= _value;                      // Updates totalSupply
143         Burn(msg.sender, _value);
144         return true;
145     }
146 
147     /**
148      * Destroy tokens from other account
149      *
150      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
151      *
152      * @param _from the address of the sender
153      * @param _value the amount of money to burn
154      */
155     function burnFrom(address _from, uint256 _value) public returns (bool success) {
156         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
157         require(_value <= allowance[_from][msg.sender]);    // Check allowance
158         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
159         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
160         totalSupply -= _value;                              // Update totalSupply
161         Burn(_from, _value);
162         return true;
163     }
164 }
165 
166 /******************************************/
167 /*       ADVANCED TOKEN STARTS HERE       */
168 /******************************************/
169 
170 contract MyAdvancedToken is owned, SocialPolis {
171 
172     
173 
174     mapping (address => bool) public frozenAccount;
175     
176         /* This generates a public event on the blockchain that will notify clients */
177     event FrozenFunds(address target, bool frozen);
178 
179     
180 
181     /* Internal transfer, only can be called by this contract */
182     function _transfer(address _from, address _to, uint _value) internal {
183         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
184         require (balanceOf[_from] >= _value);               // Check if the sender has enough
185         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
186         require(!frozenAccount[_from]);                     // Check if sender is frozen
187         require(!frozenAccount[_to]);                       // Check if recipient is frozen
188         balanceOf[_from] -= _value;                         // Subtract from the sender
189         balanceOf[_to] += _value;                           // Add the same to the recipient
190         Transfer(_from, _to, _value);
191     }
192 
193 
194     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
195     /// @param target Address to be frozen
196     /// @param freeze either to freeze it or not
197     function freezeAccount(address target, bool freeze) {
198         require(msg.sender==owner);
199         frozenAccount[target] = freeze;
200         FrozenFunds(target, freeze);
201     }
202     
203     function transferContractFunds (){
204         require(msg.sender==owner);
205         owner.transfer(this.balance);
206     }
207 
208     
209 
210     
211 }