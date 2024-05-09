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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract CikkaCoin is owned {
23    
24     // Public variables of the token
25     string public name;
26     string public symbol;
27     uint8 public decimals=5;
28     // 18 decimals is the strongly suggested default, avoid changing it
29     uint256 public totalSupply;
30 
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     // This notifies clients about the amount burnt
39     event Burn(address indexed from, uint256 value);
40 
41     /**
42      * Constrctor function
43      *
44      * Initializes contract with initial supply tokens to the creator of the contract
45      */
46     function CikkaCoin() public {
47   
48         totalSupply = 500000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
49         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
50         name = 'Cikka Coin';                                   // Set the name for display purposes
51         symbol = 'CiC';                               // Set the symbol for display purposes
52    }
53    
54     /**
55      * Internal transfer, only can be called by this contract
56      */
57     function _transfer(address _from, address _to, uint _value) internal {
58         // Prevent transfer to 0x0 address. Use burn() instead
59         require(_to != 0x0);
60         // Check if the sender has enough
61         require(balanceOf[_from] >= _value);
62         // Check for overflows
63         require(balanceOf[_to] + _value > balanceOf[_to]);
64         // Save this for an assertion in the future
65         uint previousBalances = balanceOf[_from] + balanceOf[_to];
66         // Subtract from the sender
67         balanceOf[_from] -= _value;
68         // Add the same to the recipient
69         balanceOf[_to] += _value;
70         Transfer(_from, _to, _value);
71         // Asserts are used to use static analysis to find bugs in your code. They should never fail
72         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
73     }
74 
75     /**
76      * Transfer tokens
77      *
78      * Send `_value` tokens to `_to` from your account
79      *
80      * @param _to The address of the recipient
81      * @param _value the amount to send
82      */
83     function transfer(address _to, uint256 _value) public {
84         _transfer(msg.sender, _to, _value);
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
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address and notify
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      * @param _extraData some extra information to send to the approved contract
125      */
126     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
127         public
128         returns (bool success) {
129         tokenRecipient spender = tokenRecipient(_spender);
130         if (approve(_spender, _value)) {
131             spender.receiveApproval(msg.sender, _value, this, _extraData);
132             return true;
133         }
134     }
135 
136     /**
137      * Destroy tokens
138      *
139      * Remove `_value` tokens from the system irreversibly
140      *
141      * @param _value the amount of money to burn
142      */
143     function burn(uint256 _value) public returns (bool success) {
144         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
145         balanceOf[msg.sender] -= _value;            // Subtract from the sender
146         totalSupply -= _value;                      // Updates totalSupply
147         Burn(msg.sender, _value);
148         return true;
149     }
150 
151     /**
152      * Destroy tokens from other account
153      *
154      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
155      *
156      * @param _from the address of the sender
157      * @param _value the amount of money to burn
158      */
159     function burnFrom(address _from, uint256 _value) public returns (bool success) {
160         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
161         require(_value <= allowance[_from][msg.sender]);    // Check allowance
162         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
163         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
164         totalSupply -= _value;                              // Update totalSupply
165         Burn(_from, _value);
166         return true;
167     }
168     
169      mapping (address => bool) public frozenAccount;
170      
171      /// @notice Create `mintedAmount` tokens and send it to `target`
172     /// @param target Address to receive the tokens
173     /// @param mintedAmount the amount of tokens it will receive
174     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
175         balanceOf[target] += mintedAmount;
176         totalSupply += mintedAmount;
177         Transfer(0, this, mintedAmount);
178         Transfer(this, target, mintedAmount);
179     }
180 
181 
182     /* This generates a public event on the blockchain that will notify clients */
183     event FrozenFunds(address target, bool frozen);
184     
185     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
186     /// @param target Address to be frozen
187     /// @param freeze either to freeze it or not
188     function freezeAccount(address target, bool freeze) onlyOwner public {
189         frozenAccount[target] = freeze;
190         FrozenFunds(target, freeze);
191     }
192  
193 }