1 pragma solidity ^0.4.22;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
5 }
6 
7 contract CONUNToken2 {
8 
9     // Public variables of the token
10     string public name;
11     string public symbol;
12     uint8 public decimals = 18;
13     uint256 public totalSupply;
14 
15      // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     
22     // This generates a public event on the blockchain that will notify clients
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 
25     // This notifies clients about the amount burnt.
26     event Burn(address indexed from, uint256 value);
27 
28     /**
29      * Constructor function
30      *
31      * Initializes contract with initial supply tokens to the creator of the contract
32      */
33     constructor(
34 		uint256 initialSupply,
35         string tokenName,
36         string tokenSymbol
37 	) public {
38         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
39         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
40         name = tokenName;                                   // Set the name for display purposes
41         symbol = tokenSymbol;                               // Set the symbol for display purposes
42     }
43     
44     /**
45      * Internal transfer, only can be called by this contract
46      */
47     function _transfer(address _from, address _to, uint _value) internal {
48         // Prevent transfer to 0x0 address. Use burn() instead
49         require(_to != 0x0);
50         // Check if the sender has enough
51         require(balanceOf[_from] >= _value);
52         // Check for overflows
53         require(balanceOf[_to] + _value >= balanceOf[_to]);
54         // Save this for an assertion in the future
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         // Subtract from the sender
57         balanceOf[_from] -= _value;
58         // Add the same to the recipient
59         balanceOf[_to] += _value;
60         emit Transfer(_from, _to, _value);
61 		// This should never fail
62         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
63     }
64 
65     /**
66      * Transfer tokens
67      *
68      * Send `_value` tokens to `_to` from your account
69      *
70      * @param _to The address of the recipient
71      * @param _value The amount to send
72      */
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         _transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     /**
79      * Transfer tokens from other account
80      *
81      * Send `_value` tokens to `_to` on behalf of `_from`
82      *
83      * @param _from The address of the sender
84      * @param _to The address of the recipient
85      * @param _value The amount to send
86      */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(_value <= allowance[_from][msg.sender]); // Check allowance
89         allowance[_from][msg.sender] -= _value;
90         _transfer(_from, _to, _value);
91         return true;
92     }
93 
94     /**
95      * Set allowance for other address
96      *
97      * Allow `_spender` to spend no more than `_value` tokens on your behalf
98      *
99      * @param _spender The address authorized to spend
100      * @param _value The max amount they can spend
101      */
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103         allowance[msg.sender][_spender] = _value;
104         emit Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address and notify
110      *
111      * Allow `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
112      *
113      * @param _spender The address authorized to spend
114      * @param _value The max amount they can spend
115      * @param _extraData Some extra information to send to the approved contract
116      */
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
118         tokenRecipient spender = tokenRecipient(_spender);
119         if (approve(_spender, _value)) {
120             spender.receiveApproval(msg.sender, _value, this, _extraData);
121             return true;
122         }
123     }
124 
125     /**
126      * Internal burn, only can be called by this contract
127      */
128     function _burn(address _from, uint256 _value) internal {
129         balanceOf[_from] -= _value; // Subtract from
130         totalSupply -= _value; // Update totalSupply
131     }
132     
133     /**
134      * Destroy tokens
135      *
136      * Remove `_value` tokens from the system irreversibly
137      *
138      * @param _value The amount of money to burn
139      */
140     function burn(uint256 _value) public returns (bool success) {
141         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
142         _burn(msg.sender, _value);
143         emit Burn(msg.sender, _value);
144         return true;
145     }
146 
147     /**
148      * Destroy tokens from other account
149      *
150      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
151      *
152      * @param _from The address of the sender
153      * @param _value The amount of money to burn
154      */
155     function burnFrom(address _from, uint256 _value) public returns (bool success) {
156         require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
157         require(_value <= allowance[_from][msg.sender]); // Check allowance
158         allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
159         _burn(_from, _value);
160         emit Burn(_from, _value);
161         return true;
162     }
163 }