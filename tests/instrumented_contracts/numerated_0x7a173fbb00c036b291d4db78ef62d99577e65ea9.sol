1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract owned {
6   address public owner;
7   function owned() {
8       owner = msg.sender;
9   }
10 
11   modifier onlyOwner {
12       require(msg.sender == owner);
13       _;
14   }
15 
16   function transferOwnership(address newOwner) onlyOwner {
17       owner = newOwner;
18   }
19 }
20 
21 
22 contract VT is owned {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals=18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33     mapping (address => bool) public frozenAccount;
34 
35     /* This generates a public event on the blockchain that will notify clients */
36     event FrozenFunds(address target, bool frozen);
37 
38     // This generates a public event on the blockchain that will notify clients
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     function VT(
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
70 
71         require(!frozenAccount[_from]);                     // Check if sender is frozen
72         require(!frozenAccount[_to]);                       // Check if recipient is frozen
73         // Save this for an assertion in the future
74         uint previousBalances = balanceOf[_from] + balanceOf[_to];
75         // Subtract from the sender
76         balanceOf[_from] -= _value;
77         // Add the same to the recipient
78         balanceOf[_to] += _value;
79         Transfer(_from, _to, _value);
80         // Asserts are used to use static analysis to find bugs in your code. They should never fail
81         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82     }
83 
84     /**
85      * Transfer tokens
86      *
87      * Send `_value` tokens to `_to` from your account
88      *
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transfer(address _to, uint256 _value) public {
93         _transfer(msg.sender, _to, _value);
94     }
95 
96     /**
97      * Transfer tokens from other address
98      *
99      * Send `_value` tokens to `_to` in behalf of `_from`
100      *
101      * @param _from The address of the sender
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_value <= allowance[_from][msg.sender]);     // Check allowance
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address
114      *
115      * Allows `_spender` to spend no more than `_value` tokens in your behalf
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      */
120     function approve(address _spender, uint256 _value) public
121         returns (bool success) {
122         allowance[msg.sender][_spender] = _value;
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address and notify
128      *
129      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
130      *
131      * @param _spender The address authorized to spend
132      * @param _value the max amount they can spend
133      * @param _extraData some extra information to send to the approved contract
134      */
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
136         public
137         returns (bool success) {
138         tokenRecipient spender = tokenRecipient(_spender);
139         if (approve(_spender, _value)) {
140             spender.receiveApproval(msg.sender, _value, this, _extraData);
141             return true;
142         }
143     }
144 
145     /**
146      * Destroy tokens
147      *
148      * Remove `_value` tokens from the system irreversibly
149      *
150      * @param _value the amount of money to burn
151      */
152     function burn(uint256 _value) public returns (bool success) {
153         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
154         balanceOf[msg.sender] -= _value;            // Subtract from the sender
155         totalSupply -= _value;                      // Updates totalSupply
156         Burn(msg.sender, _value);
157         return true;
158     }
159 
160     /**
161      * Destroy tokens from other account
162      *
163      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
164      *
165      * @param _from the address of the sender
166      * @param _value the amount of money to burn
167      */
168     function burnFrom(address _from, uint256 _value) public returns (bool success) {
169         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
170         require(_value <= allowance[_from][msg.sender]);    // Check allowance
171         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
172         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
173         totalSupply -= _value;                              // Update totalSupply
174         Burn(_from, _value);
175         return true;
176     }
177 
178     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
179     /// @param target Address to be frozen
180     /// @param freeze either to freeze it or not
181     function freezeAccount(address target, bool freeze) onlyOwner {
182         frozenAccount[target] = freeze;
183         FrozenFunds(target, freeze);
184     }
185 }