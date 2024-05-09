1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient {
4   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5 }
6 
7 contract OST {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256 public totalSupply;
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     // This notifies clients about the amount burnt
23     event Burn(address indexed from, uint256 value);
24 
25     /**
26      * Constrctor function
27      *
28      * Initializes contract with initial supply tokens to the creator of the contract
29      */
30     function OST(uint256 initialSupply, string tokenName, string tokenSymbol) public {
31         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
32         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
33         name = tokenName;                                   // Set the name for display purposes
34         symbol = tokenSymbol;                               // Set the symbol for display purposes
35     }
36 
37     /**
38      * Internal transfer, only can be called by this contract
39      */
40     function _transfer(address _from, address _to, uint _value) internal {
41         // Prevent transfer to 0x0 address. Use burn() instead
42         require(_to != 0x0);
43         // Check if the sender has enough
44         require(balanceOf[_from] >= _value);
45         // Check for overflows
46         require(balanceOf[_to] + _value > balanceOf[_to]);
47         // Save this for an assertion in the future
48         uint previousBalances = balanceOf[_from] + balanceOf[_to];
49         // Subtract from the sender
50         balanceOf[_from] -= _value;
51         // Add the same to the recipient
52         balanceOf[_to] += _value;
53         Transfer(_from, _to, _value);
54         // Asserts are used to use static analysis to find bugs in your code. They should never fail
55         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57 
58     /**
59      * Transfer tokens
60      *
61      * Send `_value` tokens to `_to` from your account
62      *
63      * @param _to The address of the recipient
64      * @param _value the amount to send
65      */
66     function transfer(address _to, uint256 _value) public {
67         _transfer(msg.sender, _to, _value);
68     }
69 
70     /**
71      * Transfer tokens from other address
72      *
73      * Send `_value` tokens to `_to` in behalf of `_from`
74      *
75      * @param _from The address of the sender
76      * @param _to The address of the recipient
77      * @param _value the amount to send
78      */
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         require(_value <= allowance[_from][msg.sender]);     // Check allowance
81         allowance[_from][msg.sender] -= _value;
82         _transfer(_from, _to, _value);
83         return true;
84     }
85 
86     /*******************
87      * Extra functions *
88      *******************/
89 
90     /**
91      * Set allowance for other address
92      *
93      * Allows `_spender` to spend no more than `_value` tokens in your behalf
94      *
95      * @param _spender The address authorized to spend
96      * @param _value the max amount they can spend
97      */
98     function approve(address _spender, uint256 _value) public
99         returns (bool success) {
100         allowance[msg.sender][_spender] = _value;
101         return true;
102     }
103 
104     /**
105      * Set allowance for other address and notify
106      *
107      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
108      *
109      * @param _spender The address authorized to spend
110      * @param _value the max amount they can spend
111      * @param _extraData some extra information to send to the approved contract
112      */
113     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
114         public
115         returns (bool success) {
116         tokenRecipient spender = tokenRecipient(_spender);
117         if (approve(_spender, _value)) {
118             spender.receiveApproval(msg.sender, _value, this, _extraData);
119             return true;
120         }
121     }
122 
123     /**
124      * Destroy tokens
125      *
126      * Remove `_value` tokens from the system irreversibly
127      *
128      * @param _value the amount of money to burn
129      */
130     function burn(uint256 _value) public returns (bool success) {
131         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
132         balanceOf[msg.sender] -= _value;            // Subtract from the sender
133         totalSupply -= _value;                      // Updates totalSupply
134         Burn(msg.sender, _value);
135         return true;
136     }
137 
138     /**
139      * Destroy tokens from other account
140      *
141      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
142      *
143      * @param _from the address of the sender
144      * @param _value the amount of money to burn
145      */
146     function burnFrom(address _from, uint256 _value) public returns (bool success) {
147         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
148         require(_value <= allowance[_from][msg.sender]);    // Check allowance
149         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
150         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
151         totalSupply -= _value;                              // Update totalSupply
152         Burn(_from, _value);
153         return true;
154     }
155 }