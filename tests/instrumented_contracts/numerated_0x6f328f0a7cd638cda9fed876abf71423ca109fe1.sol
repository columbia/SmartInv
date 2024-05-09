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
22 contract TokenERC20 is owned {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 0;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33     mapping (address => bool) public frozenAccount;
34 
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     // This notifies clients about the amount burnt
39     event Burn(address indexed from, uint256 value);
40 
41     /* This generates a public event on the blockchain that will notify clients */
42     event FrozenFunds(address target, bool frozen);
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     function TokenERC20(
50         uint256 initialSupply,
51         string tokenName,
52         string tokenSymbol
53     ) public {
54         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
55         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
56         name = tokenName;                                   // Set the name for display purposes
57         symbol = tokenSymbol;                               // Set the symbol for display purposes
58     }
59 
60     /**
61      * Internal transfer, only can be called by this contract
62      */
63     function _transfer(address _from, address _to, uint _value) internal {
64         // Prevent transfer to 0x0 address. Use burn() instead
65         require(_to != 0x0);
66         // Check if the sender has enough
67         require(balanceOf[_from] >= _value);
68         // Check for overflows
69         require(balanceOf[_to] + _value > balanceOf[_to]);
70         // Save this for an assertion in the future
71         uint previousBalances = balanceOf[_from] + balanceOf[_to];
72         // Subtract from the sender
73         balanceOf[_from] -= _value;
74         // Add the same to the recipient
75         balanceOf[_to] += _value;
76         Transfer(_from, _to, _value);
77         // Asserts are used to use static analysis to find bugs in your code. They should never fail
78         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
79     }
80 
81     /**
82      * Transfer tokens
83      *
84      * Send `_value` tokens to `_to` from your account
85      *
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transfer(address _to, uint256 _value) public {
90         internaltransfer(msg.sender, _to, _value);
91     }
92 
93     function internaltransfer(address _from, address _to, uint _value) internal {
94         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
95         require (balanceOf[_from] >= _value);               // Check if the sender has enough
96         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
97         require(!frozenAccount[_from]);                     // Check if sender is frozen
98         require(!frozenAccount[_to]);                       // Check if recipient is frozen
99         balanceOf[_from] -= _value;                         // Subtract from the sender
100         balanceOf[_to] += _value;                           // Add the same to the recipient
101         Transfer(_from, _to, _value);
102     }
103 
104     /**
105      * Transfer tokens from other address
106      *
107      * Send `_value` tokens to `_to` in behalf of `_from`
108      *
109      * @param _from The address of the sender
110      * @param _to The address of the recipient
111      * @param _value the amount to send
112      */
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
114         require(_value <= allowance[_from][msg.sender]);     // Check allowance
115         allowance[_from][msg.sender] -= _value;
116         _transfer(_from, _to, _value);
117         return true;
118     }
119 
120     /**
121      * Set allowance for other address
122      *
123      * Allows `_spender` to spend no more than `_value` tokens in your behalf
124      *
125      * @param _spender The address authorized to spend
126      * @param _value the max amount they can spend
127      */
128     function approve(address _spender, uint256 _value) public
129         returns (bool success) {
130         allowance[msg.sender][_spender] = _value;
131         return true;
132     }
133 
134     /**
135      * Set allowance for other address and notify
136      *
137      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
138      *
139      * @param _spender The address authorized to spend
140      * @param _value the max amount they can spend
141      * @param _extraData some extra information to send to the approved contract
142      */
143     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
144         public
145         returns (bool success) {
146         tokenRecipient spender = tokenRecipient(_spender);
147         if (approve(_spender, _value)) {
148             spender.receiveApproval(msg.sender, _value, this, _extraData);
149             return true;
150         }
151     }
152 
153     /**
154      * Destroy tokens
155      *
156      * Remove `_value` tokens from the system irreversibly
157      *
158      * @param _value the amount of money to burn
159      */
160     function burn(uint256 _value) public returns (bool success) {
161         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
162         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
163         totalSupply -= _value;                              // Updates totalSupply
164         Burn(msg.sender, _value);
165         return true;
166     }
167 
168     /**
169      * Destroy tokens from other ccount
170      *
171      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
172      *
173      * @param _from the address of the sender
174      * @param _value the amount of money to burn
175      */
176     function burnFrom(address _from, uint256 _value) public returns (bool success) {
177         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
178         require(_value <= allowance[_from][msg.sender]);    // Check allowance
179         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
180         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
181         totalSupply -= _value;                              // Update totalSupply
182         Burn(_from, _value);
183         return true;
184     }
185 
186     /// @notice Create `mintedAmount` tokens and send it to `target`
187     /// @param target Address to receive the tokens
188     /// @param mintedAmount the amount of tokens it will receive
189     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
190         balanceOf[target] += mintedAmount;
191         totalSupply += mintedAmount;
192         Transfer(0, this, mintedAmount);
193         Transfer(this, target, mintedAmount);
194     }
195 
196     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
197     /// @param target Address to be frozen
198     /// @param freeze either to freeze it or not
199     function freezeAccount(address target, bool freeze) onlyOwner public {
200         frozenAccount[target] = freeze;
201         FrozenFunds(target, freeze);
202     }
203 }