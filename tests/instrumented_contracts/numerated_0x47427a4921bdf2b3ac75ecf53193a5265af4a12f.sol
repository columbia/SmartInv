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
20 contract TokenERC20 {
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
43     function TokenERC20(
44         uint256 initialSupply,
45         string tokenName,
46         string tokenSymbol
47     ) public {
48         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
49         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
50         name = tokenName;                                   // Set the name for display purposes
51         symbol = tokenSymbol;                               // Set the symbol for display purposes
52     }
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
118      * Destroy tokens
119      *
120      * Remove `_value` tokens from the system irreversibly
121      *
122      * @param _value the amount of money to burn
123      */
124     function burn(uint256 _value) public returns (bool success) {
125         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
126         balanceOf[msg.sender] -= _value;            // Subtract from the sender
127         totalSupply -= _value;                      // Updates totalSupply
128         Burn(msg.sender, _value);
129         return true;
130     }
131 
132     /**
133      * Destroy tokens from other account
134      *
135      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
136      *
137      * @param _from the address of the sender
138      * @param _value the amount of money to burn
139      */
140     function burnFrom(address _from, uint256 _value) public returns (bool success) {
141         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
142         require(_value <= allowance[_from][msg.sender]);    // Check allowance
143         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
144         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
145         totalSupply -= _value;                              // Update totalSupply
146         Burn(_from, _value);
147         return true;
148     }
149 }
150 
151 
152 
153 contract WMCToken is owned, TokenERC20 {
154 
155     mapping (address => bool) public frozenAccount;
156 
157     /* This generates a public event on the blockchain that will notify clients */
158     event FrozenFunds(address target, bool frozen);
159 
160     /* Initializes contract with initial supply tokens to the creator of the contract */
161     function WMCToken(
162         uint256 initialSupply,
163         string tokenName,
164         string tokenSymbol
165     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
166 
167     /* Internal transfer, only can be called by this contract */
168     function _transfer(address _from, address _to, uint _value) internal {
169         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
170         require (balanceOf[_from] >= _value);               // Check if the sender has enough
171         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
172         require(!frozenAccount[_from]);                     // Check if sender is frozen
173         require(!frozenAccount[_to]);                       // Check if recipient is frozen
174         balanceOf[_from] -= _value;                         // Subtract from the sender
175         balanceOf[_to] += _value;                           // Add the same to the recipient
176         Transfer(_from, _to, _value);
177     }
178 
179     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
180     /// @param target Address to be frozen
181     /// @param freeze either to freeze it or not
182     function freezeAccount(address target, bool freeze) onlyOwner public {
183         frozenAccount[target] = freeze;
184         FrozenFunds(target, freeze);
185     }
186     
187     function batchTransfer(address[] _receivers, uint256 _value) public {
188     uint cnt = _receivers.length;
189     uint256 amount = uint256(cnt) * _value;
190     require(cnt > 0 && cnt <= 10);
191     require(_value > 0 && balanceOf[msg.sender] >= amount);
192     require(!frozenAccount[msg.sender]);                     
193 
194     balanceOf[msg.sender] -= amount;
195     for (uint i = 0; i < cnt; i++) {
196         balanceOf[_receivers[i]] += _value;
197         Transfer(msg.sender, _receivers[i], _value);
198     }
199   }
200 }