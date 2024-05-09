1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     // Public variables of the token
7     string public name = "Bitcoin Zero";
8     string public symbol = "BCZ";
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24      * Constrctor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function TokenERC20(
29 
30     ) public {
31         totalSupply = 15000000000000000000000000 ;  // Update total supply with the decimal amount
32         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
33                                   // Set the name for display purposes
34 
35         
36         // Set the symbol for display purposes
37     }
38 
39     /**
40      * Internal transfer, only can be called by this contract
41      */
42     function _transfer(address _from, address _to, uint _value) internal {
43         // Prevent transfer to 0x0 address. Use burn() instead
44         require(_to != 0x0);
45         // Check if the sender has enough
46         require(balanceOf[_from] >= _value);
47         // Check for overflows
48         require(balanceOf[_to] + _value > balanceOf[_to]);
49         // Save this for an assertion in the future
50         uint previousBalances = balanceOf[_from] + balanceOf[_to];
51         // Subtract from the sender
52         balanceOf[_from] -= _value;
53         // Add the same to the recipient
54         balanceOf[_to] += _value;
55         Transfer(_from, _to, _value);
56         // Asserts are used to use static analysis to find bugs in your code. They should never fail
57         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
58     }
59 
60     /**
61      * Transfer tokens
62      *
63      * Send `_value` tokens to `_to` from your account
64      *
65      * @param _to The address of the recipient
66      * @param _value the amount to send
67      */
68     function transfer(address _to, uint256 _value) public {
69         _transfer(msg.sender, _to, _value);
70     }
71 
72     /**
73      * Transfer tokens from other address
74      *
75      * Send `_value` tokens to `_to` in behalf of `_from`
76      *
77      * @param _from The address of the sender
78      * @param _to The address of the recipient
79      * @param _value the amount to send
80      */
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
82         require(_value <= allowance[_from][msg.sender]);     // Check allowance
83         allowance[_from][msg.sender] -= _value;
84         _transfer(_from, _to, _value);
85         return true;
86     }
87 
88     /**
89      * Set allowance for other address
90      *
91      * Allows `_spender` to spend no more than `_value` tokens in your behalf
92      *
93      * @param _spender The address authorized to spend
94      * @param _value the max amount they can spend
95      */
96     function approve(address _spender, uint256 _value) public
97         returns (bool success) {
98         allowance[msg.sender][_spender] = _value;
99         return true;
100     }
101     
102 
103     /**
104      * Set allowance for other address and notify
105      *
106      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
107      *
108      * @param _spender The address authorized to spend
109      * @param _value the max amount they can spend
110      * @param _extraData some extra information to send to the approved contract
111      */
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
113         public
114         returns (bool success) {
115         tokenRecipient spender = tokenRecipient(_spender);
116         if (approve(_spender, _value)) {
117             spender.receiveApproval(msg.sender, _value, this, _extraData);
118             return true;
119         }
120     }
121 
122     /**
123      * Destroy tokens
124      *
125      * Remove `_value` tokens from the system irreversibly
126      *
127      * @param _value the amount of money to burn
128      */
129     function burn(uint256 _value) public returns (bool success) {
130         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
131         balanceOf[msg.sender] -= _value;            // Subtract from the sender
132         totalSupply -= _value;                      // Updates totalSupply
133         Burn(msg.sender, _value);
134         return true;
135     }
136 
137     /**
138      * Destroy tokens from other account
139      *
140      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
141      *
142      * @param _from the address of the sender
143      * @param _value the amount of money to burn
144      */
145     function burnFrom(address _from, uint256 _value) public returns (bool success) {
146         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
147         require(_value <= allowance[_from][msg.sender]);    // Check allowance
148         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
149         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
150         totalSupply -= _value;                              // Update totalSupply
151         Burn(_from, _value);
152         return true;
153     }
154 }