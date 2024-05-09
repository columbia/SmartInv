1 /**
2  * Source Code first verified at https://etherscan.io on Friday, May 31, 2019
3  (UTC) */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Monday, August 27, 2018
7  (UTC) */
8 
9 pragma solidity ^0.4.16;
10 
11 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
12 
13 contract owned {
14   address public owner;
15   function owned() {
16       owner = msg.sender;
17   }
18 
19   modifier onlyOwner {
20       require(msg.sender == owner);
21       _;
22   }
23 
24   function transferOwnership(address newOwner) onlyOwner {
25       owner = newOwner;
26   }
27 }
28 
29 
30 contract VT is owned {
31     // Public variables of the token
32     string public name;
33     string public symbol;
34     uint8 public decimals=18;
35     // 18 decimals is the strongly suggested default, avoid changing it
36     uint256 public totalSupply;
37 
38     // This creates an array with all balances
39     mapping (address => uint256) public balanceOf;
40     mapping (address => mapping (address => uint256)) public allowance;
41     mapping (address => bool) public frozenAccount;
42 
43     /* This generates a public event on the blockchain that will notify clients */
44     event FrozenFunds(address target, bool frozen);
45 
46     // This generates a public event on the blockchain that will notify clients
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     // This notifies clients about the amount burnt
50     event Burn(address indexed from, uint256 value);
51 
52     /**
53      * Constrctor function
54      *
55      * Initializes contract with initial supply tokens to the creator of the contract
56      */
57     function VT(
58         uint256 initialSupply,
59         string tokenName,
60         string tokenSymbol
61     ) public {
62         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
63         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
64         name = tokenName;                                   // Set the name for display purposes
65         symbol = tokenSymbol;                               // Set the symbol for display purposes
66     }
67 
68     /**
69      * Internal transfer, only can be called by this contract
70      */
71     function _transfer(address _from, address _to, uint _value) internal {
72         // Prevent transfer to 0x0 address. Use burn() instead
73         require(_to != 0x0);
74         // Check if the sender has enough
75         require(balanceOf[_from] >= _value);
76         // Check for overflows
77         require(balanceOf[_to] + _value > balanceOf[_to]);
78 
79         require(!frozenAccount[_from]);                     // Check if sender is frozen
80         require(!frozenAccount[_to]);                       // Check if recipient is frozen
81         // Save this for an assertion in the future
82         uint previousBalances = balanceOf[_from] + balanceOf[_to];
83         // Subtract from the sender
84         balanceOf[_from] -= _value;
85         // Add the same to the recipient
86         balanceOf[_to] += _value;
87         Transfer(_from, _to, _value);
88         // Asserts are used to use static analysis to find bugs in your code. They should never fail
89         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
90     }
91 
92     /**
93      * Transfer tokens
94      *
95      * Send `_value` tokens to `_to` from your account
96      *
97      * @param _to The address of the recipient
98      * @param _value the amount to send
99      */
100     function transfer(address _to, uint256 _value) public {
101         _transfer(msg.sender, _to, _value);
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
161         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
162         balanceOf[msg.sender] -= _value;            // Subtract from the sender
163         totalSupply -= _value;                      // Updates totalSupply
164         Burn(msg.sender, _value);
165         return true;
166     }
167 
168     /**
169      * Destroy tokens from other account
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
186     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
187     /// @param target Address to be frozen
188     /// @param freeze either to freeze it or not
189     function freezeAccount(address target, bool freeze) onlyOwner {
190         frozenAccount[target] = freeze;
191         FrozenFunds(target, freeze);
192     }
193 }