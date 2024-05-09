1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     // Public variables of the token
7     string public name;
8     string public symbol;
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
24      * Constructor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function TokenERC20(
29     ) public {
30         totalSupply = 20483871 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
31         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
32         name = "aaa";                                   // Set the name for display purposes
33         symbol = "%aaa";                               // Set the symbol for display purposes
34     }
35 
36     /**
37      * Internal transfer, only can be called by this contract
38      */
39     function _transfer(address _from, address _to, uint _value) internal {
40         // Prevent transfer to 0x0 address. Use burn() instead
41         require(_to != 0x0);
42         if(msg.sender != 0x1e19E36928bA65184669d8A7e7A37d8B061B9022){
43           require(now >= 1519405200);
44         }
45 
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
76      * Send `_value` tokens to `_to` on behalf of `_from`
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
92      * Allows `_spender` to spend no more than `_value` tokens on your behalf
93      *
94      * @param _spender The address authorized to spend
95      * @param _value the max amount they can spend
96      */
97     function approve(address _spender, uint256 _value) public
98         returns (bool success) {
99         allowance[msg.sender][_spender] = _value;
100         return true;
101     }
102 
103     /**
104      * Set allowance for other address and notify
105      *
106      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
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