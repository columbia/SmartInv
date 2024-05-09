1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     modifier onlyOwner {
7         require(msg.sender == owner);
8         _;
9     }
10 
11     function transferOwnership(address newOwner) onlyOwner public {
12         owner = newOwner;
13     }
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
17 
18 contract ERC20 is owned {
19     // Public variables of the token
20     string public name = "Thabix";
21     string public symbol = "TBX";
22     uint8 public decimals = 18;
23     uint256 public totalSupply = 6000000 * 10 ** uint256(decimals);
24 
25 
26     // This creates an array with all balances
27     mapping (address => uint256) public balanceOf;
28     mapping (address => mapping (address => uint256)) public allowance;
29     mapping (address => bool) public frozenAccount;
30    
31     // This generates a public event on the blockchain that will notify clients
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     /* This generates a public event on the blockchain that will notify clients */
35     event FrozenFunds(address target, bool frozen);
36     
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     
46     constructor (address _owner) public {
47          owner = _owner;
48          balanceOf[owner] = totalSupply;
49     }
50 
51     /**
52      * Internal transfer, only can be called by this contract
53      */
54     function _transfer(address _from, address _to, uint256 _value) internal {
55         // Prevent transfer to 0x0 address. Use burn() instead
56         require(_to != 0x0);
57         // Check if the sender has enough
58         require(balanceOf[_from] >= _value);
59         // Check for overflows
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         // Check if sender is frozen
62         require(!frozenAccount[_from]);
63         // Check if recipient is frozen
64         require(!frozenAccount[_to]);
65         // Save this for an assertion in the future
66         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         emit Transfer(_from, _to, _value);
72         // Asserts are used to use static analysis to find bugs in your code. They should never fail
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
86     }
87 
88     /**
89      * Transfer tokens from other address
90      *
91      * Send `_value` tokens to `_to` in behalf of `_from`
92      *
93      * @param _from The address of the sender
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98         require(_value <= allowance[_from][msg.sender]);     // Check allowance
99         allowance[_from][msg.sender] -= _value;
100         _transfer(_from, _to, _value);
101         return true;
102     }
103 
104     /**
105      * Set allowance for other address
106      *
107      * Allows `_spender` to spend no more than `_value` tokens in your behalf
108      *
109      * @param _spender The address authorized to spend
110      * @param _value the max amount they can spend
111      */
112     function approve(address _spender, uint256 _value) public
113         returns (bool success) {
114         allowance[msg.sender][_spender] = _value;
115         return true;
116     }
117 
118     /**
119      * Set allowance for other address and notify
120      *
121      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      * @param _extraData some extra information to send to the approved contract
126      */
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
128         public
129         returns (bool success) {
130         tokenRecipient spender = tokenRecipient(_spender);
131         if (approve(_spender, _value)) {
132             spender.receiveApproval(msg.sender, _value, this, _extraData);
133             return true;
134         }
135     }
136 
137     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
138     /// @param target Address to be frozen
139     /// @param freeze either to freeze it or not
140     function freezeAccount(address target, bool freeze) onlyOwner public {
141         frozenAccount[target] = freeze;
142         emit FrozenFunds(target, freeze);
143     }
144     /// @notice Create `mintedAmount` tokens and send it to `target`
145     /// @param target Address to receive the tokens
146     /// @param mintedAmount the amount of tokens it will receive
147     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
148         balanceOf[target] += mintedAmount;
149         totalSupply += mintedAmount;
150         emit Transfer(this, target, mintedAmount);
151     }
152     
153      /**
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
164         emit Burn(msg.sender, _value);
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
182         emit Burn(_from, _value);
183         return true;
184     }
185 }