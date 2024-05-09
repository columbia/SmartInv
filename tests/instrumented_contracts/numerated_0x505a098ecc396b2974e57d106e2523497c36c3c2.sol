1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract QuickCoin {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
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
29     function QuickCoin() public {
30         
31         totalSupply = 200000000000000;                               // Update total supply with the decimal amount
32         balanceOf[msg.sender] = 200000000000000;                    // Give the creator all initial tokens
33         name = "QuickCoin";                           // Set the name for display purposes
34         symbol = "QUC";                                     // Set the symbol for display purposes
35         decimals = 8;                                       // Amount of decimals for display purposes
36 
37     }
38     
39 
40 
41     /**
42      * Internal transfer, only can be called by this contract
43      */
44     function _transfer(address _from, address _to, uint _value) internal {
45         // Prevent transfer to 0x0 address. Use burn() instead
46         require(_to != 0x0);
47         // Check if the sender has enough
48         require(balanceOf[_from] >= _value);
49         // Check for overflows
50         require(balanceOf[_to] + _value > balanceOf[_to]);
51         // Save this for an assertion in the future
52         uint previousBalances = balanceOf[_from] + balanceOf[_to];
53         // Subtract from the sender
54         balanceOf[_from] -= _value;
55         // Add the same to the recipient
56         balanceOf[_to] += _value;
57         Transfer(_from, _to, _value);
58         // Asserts are used to use static analysis to find bugs in your code. They should never fail
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     /**
63      * Transfer tokens
64      *
65      * Send `_value` tokens to `_to` from your account
66      *
67      * @param _to The address of the recipient
68      * @param _value the amount to send
69      */
70     function transfer(address _to, uint256 _value) public {
71         _transfer(msg.sender, _to, _value);
72     }
73 
74     /**
75      * Transfer tokens from other address
76      *
77      * Send `_value` tokens to `_to` in behalf of `_from`
78      *
79      * @param _from The address of the sender
80      * @param _to The address of the recipient
81      * @param _value the amount to send
82      */
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         require(_value <= allowance[_from][msg.sender]);     // Check allowance
85         allowance[_from][msg.sender] -= _value;
86         _transfer(_from, _to, _value);
87         return true;
88     }
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
154         
155     
156     }
157     
158 }