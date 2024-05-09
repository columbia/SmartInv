1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract SafePost {
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
28     constructor (
29         uint256 initialSupply,
30         string tokenName,
31         string tokenSymbol
32     ) public {
33         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
34         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
35         name = tokenName;                                   // Set the name for display purposes
36         symbol = tokenSymbol;                               // Set the symbol for display purposes
37         emit Transfer (address(0), msg.sender, totalSupply);
38     }
39 
40     /**
41      * Internal transfer, only can be called by this contract
42      */
43     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
44         // Prevent transfer to 0x0 address. Use burn() instead
45         require(_to != 0x0);
46         // Prevent transfer to this address.
47         require( _to != address(this) );
48         // Check if the sender has enough
49         require(balanceOf[_from] >= _value);
50         // Check for overflows
51         require(balanceOf[_to] + _value >= balanceOf[_to]);
52         // Save this for an assertion in the future
53         uint previousBalances = balanceOf[_from] + balanceOf[_to];
54         // Subtract from the sender
55         balanceOf[_from] -= _value;
56         // Add the same to the recipient
57         balanceOf[_to] += _value;
58         emit Transfer (_from, _to, _value);
59         // Asserts are used to use static analysis to find bugs in your code. They should never fail
60         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
61         return true;
62     }
63 
64     /**
65      * Transfer tokens
66      *
67      * Send `_value` tokens to `_to` from your account
68      *
69      * @param _to The address of the recipient
70      * @param _value the amount to send
71      */
72     function transfer(address _to, uint256 _value) public returns (bool success) {
73         return _transfer(msg.sender, _to, _value);
74     }
75 
76     /**
77      * Transfer tokens from other address
78      *
79      * Send `_value` tokens to `_to` on behalf of `_from`
80      *
81      * @param _from The address of the sender
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         require(_value <= allowance[_from][msg.sender]);     // Check allowance
87         allowance[_from][msg.sender] -= _value;
88         _transfer(_from, _to, _value);
89         return true;
90     }
91 
92     /**
93      * Set allowance for other address
94      *
95      * Allows `_spender` to spend no more than `_value` tokens on your behalf
96      *
97      * @param _spender The address authorized to spend
98      * @param _value the max amount they can spend
99      *
100      * NOTE: To prevent attack vectors like the one described here https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit, 
101      * clients SHOULD make sure to create user interfaces in such a way that they set the allowance first to 0 before setting it to another value for the same spender.
102      */
103     function approve(address _spender, uint256 _value) public
104         returns (bool success) {
105         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
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
140         emit Burn(msg.sender, _value);
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
158         emit Burn(_from, _value);
159         return true;
160     }
161 }