1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract FUC {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     // 18 decimals is the strongly suggested default, avoid changing it
10     uint8 public decimals = 18;
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
28     function FUC(
29         uint256 initialSupply,
30         string tokenName,
31         string tokenSymbol
32     ) public {
33         // Update total supply with the decimal amount
34         totalSupply = initialSupply * 10 ** uint256(decimals); 
35         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
36         name = tokenName;                                              // Set the name for display purposes
37         symbol = tokenSymbol;                                        // Set the symbol for display purposes
38     }
39 
40     /**
41      * Internal transfer, only can be called by this contract
42      */
43     function _transfer(address _from, address _to, uint _value) internal {
44         // Prevent transfer to 0x0 address. Use burn() instead
45         require(_to != 0x0);
46         // Check if the sender has enough
47         require(balanceOf[_from] >= _value);
48         // Check for overflows
49         require(balanceOf[_to] + _value > balanceOf[_to]);
50         // Save this for an assertion in the future
51         uint previousBalances = balanceOf[_from] + balanceOf[_to];
52         // Subtract from the sender
53         balanceOf[_from] -= _value;
54         // Add the same to the recipient
55         balanceOf[_to] += _value;
56         Transfer(_from, _to, _value);
57         // Asserts are used to use static analysis to find bugs in your code. They should never fail
58         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59     }
60 
61     /**
62      * Transfer tokens
63      *
64      * Send `_value` tokens to `_to` from your account
65      *
66      * @param _to The address of the recipient
67      * @param _value the amount to send
68      */
69     function transfer(address _to, uint256 _value) public {
70         _transfer(msg.sender, _to, _value);
71     }
72 
73     /**
74      * Transfer tokens from other address
75      *
76      * Send `_value` tokens to `_to` in behalf of `_from`
77      *
78      * @param _from The address of the sender
79      * @param _to The address of the recipient
80      * @param _value the amount to send
81      */
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         require(_value <= allowance[_from][msg.sender]);     // Check allowance
84         allowance[_from][msg.sender] -= _value;
85         _transfer(_from, _to, _value);
86         return true;
87     }
88 
89     /**
90      * Set allowance for other address
91      *
92      * Allows `_spender` to spend no more than `_value` tokens in your behalf
93      *
94      * @param _spender The address authorized to spend
95      * @param _value the max amount they can spend
96      */
97     function approve(address _spender, uint256 _value) public returns (bool success) {
98         allowance[msg.sender][_spender] = _value;
99         return true;
100     }
101 
102     /**
103      * Set allowance for other address and notify
104      *
105      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
106      *
107      * @param _spender The address authorized to spend
108      * @param _value the max amount they can spend
109      * @param _extraData some extra information to send to the approved contract
110      */
111     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
112         tokenRecipient spender = tokenRecipient(_spender);
113         if (approve(_spender, _value)) {
114             spender.receiveApproval(msg.sender, _value, this, _extraData);
115             return true;
116         }
117     }
118 
119     /**
120      * Destroy tokens
121      *
122      * Remove `_value` tokens from the system irreversibly
123      *
124      * @param _value the amount of money to burn
125      */
126     function burn(uint256 _value) public returns (bool success) {
127         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
128         balanceOf[msg.sender] -= _value;            // Subtract from the sender
129         totalSupply -= _value;                      // Updates totalSupply
130         Burn(msg.sender, _value);
131         return true;
132     }
133 
134     /**
135      * Destroy tokens from other account
136      *
137      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
138      *
139      * @param _from the address of the sender
140      * @param _value the amount of money to burn
141      */
142     function burnFrom(address _from, uint256 _value) public returns (bool success) {
143         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
144         require(_value <= allowance[_from][msg.sender]);    // Check allowance
145         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
146         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
147         totalSupply -= _value;                              // Update totalSupply
148         Burn(_from, _value);
149         return true;
150     }
151 }