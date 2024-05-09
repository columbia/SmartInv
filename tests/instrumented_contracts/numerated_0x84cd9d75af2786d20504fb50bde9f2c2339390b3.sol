1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = 0xBEF65789F48626ceEB9af14A3895252A3b0d6E3f;
8     }
9 
10 }
11 
12 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
13 
14 contract TokenERC20 {
15     // Public variables of the token
16     string public name;
17     string public symbol;
18     uint8 public decimals = 18;
19     // 18 decimals is the strongly suggested default, avoid changing it
20     uint256 public totalSupply;
21 
22     // This creates an array with all balances
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25 
26     // This generates a public event on the blockchain that will notify clients
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     
29     // This generates a public event on the blockchain that will notify clients
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 
32     // This notifies clients about the amount burnt
33     event Burn(address indexed from, uint256 value);
34 
35     /**
36      * Constrctor function
37      *
38      * Initializes contract with initial supply tokens to the creator of the contract
39      */
40     function TokenERC20(
41         uint256 initialSupply,
42         string tokenName,
43         string tokenSymbol
44     ) public {
45         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
46         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
47         name = tokenName;                                   // Set the name for display purposes
48         symbol = tokenSymbol;                               // Set the symbol for display purposes
49     }
50 
51     /**
52      * Internal transfer, only can be called by this contract
53      */
54     function _transfer(address _from, address _to, uint _value) internal {
55         // Prevent transfer to 0x0 address. Use burn() instead
56         require(_to != 0x0);
57         // Check if the sender has enough
58         require(balanceOf[_from] >= _value);
59         // Check for overflows
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         // Save this for an assertion in the future
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         // Subtract from the sender
64         balanceOf[_from] -= _value;
65         // Add the same to the recipient
66         balanceOf[_to] += _value;
67         emit Transfer(_from, _to, _value);
68         // Asserts are used to use static analysis to find bugs in your code. They should never fail
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 
72     /**
73      * Transfer tokens
74      *
75      * Send `_value` tokens to `_to` from your account
76      *
77      * @param _to The address of the recipient
78      * @param _value the amount to send
79      */
80     function transfer(address _to, uint256 _value) public returns (bool success) {
81         _transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     /**
86      * Transfer tokens from other address
87      *
88      * Send `_value` tokens to `_to` in behalf of `_from`
89      *
90      * @param _from The address of the sender
91      * @param _to The address of the recipient
92      * @param _value the amount to send
93      */
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
95         require(_value <= allowance[_from][msg.sender]);     // Check allowance
96         allowance[_from][msg.sender] -= _value;
97         _transfer(_from, _to, _value);
98         return true;
99     }
100 
101     /**
102      * Set allowance for other address
103      *
104      * Allows `_spender` to spend no more than `_value` tokens in your behalf
105      *
106      * @param _spender The address authorized to spend
107      * @param _value the max amount they can spend
108      */
109     function approve(address _spender, uint256 _value) public
110         returns (bool success) {
111         allowance[msg.sender][_spender] = _value;
112         emit Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     /**
117      * Set allowance for other address and notify
118      *
119      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
120      *
121      * @param _spender The address authorized to spend
122      * @param _value the max amount they can spend
123      * @param _extraData some extra information to send to the approved contract
124      */
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
126         public
127         returns (bool success) {
128         tokenRecipient spender = tokenRecipient(_spender);
129         if (approve(_spender, _value)) {
130             spender.receiveApproval(msg.sender, _value, this, _extraData);
131             return true;
132         }
133     }
134 
135     /**
136      * Destroy tokens
137      *
138      * Remove `_value` tokens from the system irreversibly
139      *
140      * @param _value the amount of money to burn
141      */
142     function burn(uint256 _value) public returns (bool success) {
143         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
144         balanceOf[msg.sender] -= _value;            // Subtract from the sender
145         totalSupply -= _value;                      // Updates totalSupply
146         emit Burn(msg.sender, _value);
147         return true;
148     }
149 
150     /**
151      * Destroy tokens from other account
152      *
153      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
154      *
155      * @param _from the address of the sender
156      * @param _value the amount of money to burn
157      */
158     function burnFrom(address _from, uint256 _value) public returns (bool success) {
159         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
160         require(_value <= allowance[_from][msg.sender]);    // Check allowance
161         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
162         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
163         totalSupply -= _value;                              // Update totalSupply
164         emit Burn(_from, _value);
165         return true;
166     }
167 }
168 
169 /******************************************/
170 /*       ADVANCED TOKEN STARTS HERE       */
171 /******************************************/
172 
173 contract MyAdvancedToken is owned, TokenERC20 {
174 
175     /* Initializes contract with initial supply tokens to the creator of the contract */
176     function MyAdvancedToken(
177         uint256 initialSupply,
178         string tokenName,
179         string tokenSymbol
180     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
181 
182     /* Internal transfer, only can be called by this contract */
183     function _transfer(address _from, address _to, uint _value) internal {
184         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
185         require (balanceOf[_from] >= _value);               // Check if the sender has enough
186         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
187 
188         balanceOf[_from] -= _value;                         // Subtract from the sender
189         balanceOf[_to] += _value;                           // Add the same to the recipient
190         emit Transfer(_from, _to, _value);
191     }
192 
193 }