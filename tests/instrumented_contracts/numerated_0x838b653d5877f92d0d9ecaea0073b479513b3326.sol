1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
5 }
6 contract COINEIUM {
7     // Public variables of the token
8     string public name='COINEIUM';
9     string public symbol="CNM";
10     uint8 public decimals = 18;
11     // 18 decimals is the strongly suggested default, avoid changing it
12     uint256 public totalSupply = 777000000000000000000000000; 
13 
14     // This creates an array with all balances
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     // This generates a public event on the blockchain that will notify clients
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     // This notifies clients about the amount burnt
22     event Burn(address indexed from, uint256 value);
23 
24     /**
25      * Constrctor function
26      *
27      * Initializes contract with initial supply tokens to the creator of the contract
28      */
29     function COINEIUM() public {
30         totalSupply = 777000000000000000000000000;  // Update total supply with the decimal amount
31         balanceOf[msg.sender] = totalSupply;           // Give the creator all initial tokens
32         name = 'COINEIUM';                      // Set the name for display purposes
33         symbol = 'CNM';                                // Set the symbol for display purposes
34     }
35 
36     /**
37      * Internal transfer, only can be called by this contract
38      */
39     function _transfer(address _from, address _to, uint _value) internal {
40         // Prevent transfer to 0x0 address. Use burn() instead
41         require(_to != 0x0);
42         // Check if the sender has enough
43         require(balanceOf[_from] >= _value);
44         // Check for overflows
45         require(balanceOf[_to] + _value > balanceOf[_to]);
46         // Save this for an assertion in the future
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48         // Subtract from the sender
49         balanceOf[_from] -= _value;
50         // Add the same to the recipient
51         balanceOf[_to] += _value;
52         Transfer(_from, _to, _value);
53         // Asserts are used to use static analysis to find bugs in your code. They should never fail
54         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
55     }
56     
57     /**
58      * tokens balance
59      *
60      * Get `_owner` tokens
61      *
62      * @param _owner The address 
63      */
64     function balanceOf(address _owner) public view returns (uint256 balance) {
65         return balanceOf[_owner];
66     }
67 
68     /**
69      * Transfer tokens
70      *
71      * Send `_value` tokens to `_to` from your account
72      *
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transfer(address _to, uint256 _value) public {
77         _transfer(msg.sender, _to, _value);
78     }
79 
80     /**
81      * Transfer tokens from other address
82      *
83      * Send `_value` tokens to `_to` on behalf of `_from`
84      *
85      * @param _from The address of the sender
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
90         require(_value <= allowance[_from][msg.sender]);     // Check allowance
91         allowance[_from][msg.sender] -= _value;
92         _transfer(_from, _to, _value);
93         return true;
94     }
95 
96     /**
97      * Set allowance for other address
98      *
99      * Allows `_spender` to spend no more than `_value` tokens on your behalf
100      *
101      * @param _spender The address authorized to spend
102      * @param _value the max amount they can spend
103      */
104     function approve(address _spender, uint256 _value) public
105         returns (bool success) {
106         allowance[msg.sender][_spender] = _value;
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address and notify
112      *
113      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      * @param _extraData some extra information to send to the approved contract
118      */
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
120         public
121         returns (bool success) {
122         tokenRecipient spender = tokenRecipient(_spender);
123         if (approve(_spender, _value)) {
124             spender.receiveApproval(msg.sender, _value, this, _extraData);
125             return true;
126         }
127     }
128 
129     /**
130      * Destroy tokens
131      *
132      * Remove `_value` tokens from the system irreversibly
133      *
134      * @param _value the amount of money to burn
135      */
136     function burn(uint256 _value) public returns (bool success) {
137         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
138         balanceOf[msg.sender] -= _value;            // Subtract from the sender
139         totalSupply -= _value;                      // Updates totalSupply
140         Burn(msg.sender, _value);
141         return true;
142     }
143 
144     /**
145      * Destroy tokens from other account
146      *
147      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
148      *
149      * @param _from the address of the sender
150      * @param _value the amount of money to burn
151      */
152     function burnFrom(address _from, uint256 _value) public returns (bool success) {
153         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
154         require(_value <= allowance[_from][msg.sender]);    // Check allowance
155         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
156         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
157         totalSupply -= _value;                              // Update totalSupply
158         Burn(_from, _value);
159         return true;
160     }
161 }