1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract CCCToken {
6     // Public variables of the token
7     string public name = 'Crypto Crash Course'; // To be used to certify that students passed the Crypto Crash Course
8     string public symbol = 'CCC';
9     uint8 public decimals = 18;
10     uint256 public totalSupply = 1000000000000000000000000000;
11 
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     // This notifies clients about the amount burnt
20     event Burn(address indexed from, uint256 value);
21 
22     /**
23      * Constrctor function
24      *
25      * Initializes contract with initial supply tokens to the creator of the contract
26      */
27     function CCCToken() public {
28         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
29     }
30 
31     /**
32      * Internal transfer, only can be called by this contract
33      */
34     function _transfer(address _from, address _to, uint _value) internal {
35         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
36         require(balanceOf[_from] >= _value);                // Check if the sender has enough
37         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
38         balanceOf[_from] -= _value;                         // Subtract from the sender
39         balanceOf[_to] += _value;                           // Add the same to the recipient
40         Transfer(_from, _to, _value);
41     }
42 
43     /**
44      * Transfer tokens
45      *
46      * Send `_value` tokens to `_to` from your account
47      *
48      * @param _to The address of the recipient
49      * @param _value the amount to send
50      */
51     function transfer(address _to, uint256 _value) public {
52         _transfer(msg.sender, _to, _value);
53     }
54 
55     /**
56      * Transfer tokens from other address
57      *
58      * Send `_value` tokens to `_to` in behalf of `_from`
59      *
60      * @param _from The address of the sender
61      * @param _to The address of the recipient
62      * @param _value the amount to send
63      */
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65         require(_value <= allowance[_from][msg.sender]);     // Check allowance
66         allowance[_from][msg.sender] -= _value;
67         _transfer(_from, _to, _value);
68         return true;
69     }
70 
71     /**
72      * Set allowance for other address
73      *
74      * Allows `_spender` to spend no more than `_value` tokens in your behalf
75      *
76      * @param _spender The address authorized to spend
77      * @param _value the max amount they can spend
78      */
79     function approve(address _spender, uint256 _value) public
80         returns (bool success) {
81         allowance[msg.sender][_spender] = _value;
82         return true;
83     }
84 
85     /**
86      * Set allowance for other address and notify
87      *
88      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
89      *
90      * @param _spender The address authorized to spend
91      * @param _value the max amount they can spend
92      * @param _extraData some extra information to send to the approved contract
93      */
94     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public
95         returns (bool success) {
96         tokenRecipient spender = tokenRecipient(_spender);
97         if (approve(_spender, _value)) {
98             spender.receiveApproval(msg.sender, _value, this, _extraData);
99             return true;
100         }
101     }
102 
103     /**
104      * Destroy tokens
105      *
106      * Remove `_value` tokens from the system irreversibly
107      *
108      * @param _value the amount of money to burn
109      */
110     function burn(uint256 _value) public returns (bool success) {
111         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
112         balanceOf[msg.sender] -= _value;            // Subtract from the sender
113         totalSupply -= _value;                      // Updates totalSupply
114         Burn(msg.sender, _value);
115         return true;
116     }
117 
118     /**
119      * Destroy tokens from other account
120      *
121      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
122      *
123      * @param _from the address of the sender
124      * @param _value the amount of money to burn
125      */
126     function burnFrom(address _from, uint256 _value) public returns (bool success) {
127         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
128         require(_value <= allowance[_from][msg.sender]);    // Check allowance
129         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
130         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
131         totalSupply -= _value;                              // Update totalSupply
132         Burn(_from, _value);
133         return true;
134     }
135 }