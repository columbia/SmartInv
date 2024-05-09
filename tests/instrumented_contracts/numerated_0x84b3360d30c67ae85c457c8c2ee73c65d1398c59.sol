1 /**
2  * Source Code first verified at https://etherscan.io on Monday, August 27, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.16;
6 
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
8 
9 contract owned {
10   address public owner;
11   function owned() {
12       owner = msg.sender;
13   }
14 
15   modifier onlyOwner {
16       require(msg.sender == owner);
17       _;
18   }
19 
20   function transferOwnership(address newOwner) onlyOwner {
21       owner = newOwner;
22   }
23 }
24 
25 
26 contract VT is owned {
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals=18;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37     mapping (address => bool) public frozenAccount;
38 
39     /* This generates a public event on the blockchain that will notify clients */
40     event FrozenFunds(address target, bool frozen);
41 
42     // This generates a public event on the blockchain that will notify clients
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     // This notifies clients about the amount burnt
46     event Burn(address indexed from, uint256 value);
47 
48     /**
49      * Constrctor function
50      *
51      * Initializes contract with initial supply tokens to the creator of the contract
52      */
53     function VT(
54         uint256 initialSupply,
55         string tokenName,
56         string tokenSymbol
57     ) public {
58         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
59         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
60         name = tokenName;                                   // Set the name for display purposes
61         symbol = tokenSymbol;                               // Set the symbol for display purposes
62     }
63 
64     /**
65      * Internal transfer, only can be called by this contract
66      */
67     function _transfer(address _from, address _to, uint _value) internal {
68         // Prevent transfer to 0x0 address. Use burn() instead
69         require(_to != 0x0);
70         // Check if the sender has enough
71         require(balanceOf[_from] >= _value);
72         // Check for overflows
73         require(balanceOf[_to] + _value > balanceOf[_to]);
74 
75         require(!frozenAccount[_from]);                     // Check if sender is frozen
76         require(!frozenAccount[_to]);                       // Check if recipient is frozen
77         // Save this for an assertion in the future
78         uint previousBalances = balanceOf[_from] + balanceOf[_to];
79         // Subtract from the sender
80         balanceOf[_from] -= _value;
81         // Add the same to the recipient
82         balanceOf[_to] += _value;
83         Transfer(_from, _to, _value);
84         // Asserts are used to use static analysis to find bugs in your code. They should never fail
85         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
86     }
87 
88     /**
89      * Transfer tokens
90      *
91      * Send `_value` tokens to `_to` from your account
92      *
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transfer(address _to, uint256 _value) public {
97         _transfer(msg.sender, _to, _value);
98     }
99 
100     /**
101      * Transfer tokens from other address
102      *
103      * Send `_value` tokens to `_to` in behalf of `_from`
104      *
105      * @param _from The address of the sender
106      * @param _to The address of the recipient
107      * @param _value the amount to send
108      */
109     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
110         require(_value <= allowance[_from][msg.sender]);     // Check allowance
111         allowance[_from][msg.sender] -= _value;
112         _transfer(_from, _to, _value);
113         return true;
114     }
115 
116     /**
117      * Set allowance for other address
118      *
119      * Allows `_spender` to spend no more than `_value` tokens in your behalf
120      *
121      * @param _spender The address authorized to spend
122      * @param _value the max amount they can spend
123      */
124     function approve(address _spender, uint256 _value) public
125         returns (bool success) {
126         allowance[msg.sender][_spender] = _value;
127         return true;
128     }
129 
130     /**
131      * Set allowance for other address and notify
132      *
133      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
134      *
135      * @param _spender The address authorized to spend
136      * @param _value the max amount they can spend
137      * @param _extraData some extra information to send to the approved contract
138      */
139     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
140         public
141         returns (bool success) {
142         tokenRecipient spender = tokenRecipient(_spender);
143         if (approve(_spender, _value)) {
144             spender.receiveApproval(msg.sender, _value, this, _extraData);
145             return true;
146         }
147     }
148 
149     /**
150      * Destroy tokens
151      *
152      * Remove `_value` tokens from the system irreversibly
153      *
154      * @param _value the amount of money to burn
155      */
156     function burn(uint256 _value) public returns (bool success) {
157         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
158         balanceOf[msg.sender] -= _value;            // Subtract from the sender
159         totalSupply -= _value;                      // Updates totalSupply
160         Burn(msg.sender, _value);
161         return true;
162     }
163 
164     /**
165      * Destroy tokens from other account
166      *
167      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
168      *
169      * @param _from the address of the sender
170      * @param _value the amount of money to burn
171      */
172     function burnFrom(address _from, uint256 _value) public returns (bool success) {
173         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
174         require(_value <= allowance[_from][msg.sender]);    // Check allowance
175         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
176         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
177         totalSupply -= _value;                              // Update totalSupply
178         Burn(_from, _value);
179         return true;
180     }
181 
182     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
183     /// @param target Address to be frozen
184     /// @param freeze either to freeze it or not
185     function freezeAccount(address target, bool freeze) onlyOwner {
186         frozenAccount[target] = freeze;
187         FrozenFunds(target, freeze);
188     }
189 }