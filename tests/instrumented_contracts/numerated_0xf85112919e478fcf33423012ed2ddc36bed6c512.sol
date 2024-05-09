1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
5 }
6 
7 contract TokenERC20 {
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
30     function TokenERC20() public {
31         totalSupply = 1000000 * 10 ** uint256(18);  // Update total supply with the decimal amount
32         balanceOf[msg.sender] = totalSupply;           // Give the creator all initial tokens
33         name = 'Global Gold Coin';                      // Set the name for display purposes
34         symbol = 'GGC';                                // Set the symbol for display purposes
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
59      * tokens balance
60      *
61      * Get `_owner` tokens
62      *
63      * @param _owner The address 
64      */
65     function balanceOf(address _owner) public view returns (uint256 balance) {
66         return balanceOf[_owner];
67     }
68 
69     /**
70      * Transfer tokens
71      *
72      * Send `_value` tokens to `_to` from your account
73      *
74      * @param _to The address of the recipient
75      * @param _value the amount to send
76      */
77     function transfer(address _to, uint256 _value) public {
78         _transfer(msg.sender, _to, _value);
79     }
80 
81     /**
82      * Transfer tokens from other address
83      *
84      * Send `_value` tokens to `_to` on behalf of `_from`
85      *
86      * @param _from The address of the sender
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(_value <= allowance[_from][msg.sender]);     // Check allowance
92         allowance[_from][msg.sender] -= _value;
93         _transfer(_from, _to, _value);
94         return true;
95     }
96 
97     /**
98      * Set allowance for other address
99      *
100      * Allows `_spender` to spend no more than `_value` tokens on your behalf
101      *
102      * @param _spender The address authorized to spend
103      * @param _value the max amount they can spend
104      */
105     function approve(address _spender, uint256 _value) public
106         returns (bool success) {
107         allowance[msg.sender][_spender] = _value;
108         return true;
109     }
110 
111     /**
112      * Set allowance for other address and notify
113      *
114      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      * @param _extraData some extra information to send to the approved contract
119      */
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
121         public
122         returns (bool success) {
123         tokenRecipient spender = tokenRecipient(_spender);
124         if (approve(_spender, _value)) {
125             spender.receiveApproval(msg.sender, _value, this, _extraData);
126             return true;
127         }
128     }
129 
130     /**
131      * Destroy tokens
132      *
133      * Remove `_value` tokens from the system irreversibly
134      *
135      * @param _value the amount of money to burn
136      */
137     function burn(uint256 _value) public returns (bool success) {
138         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
139         balanceOf[msg.sender] -= _value;            // Subtract from the sender
140         totalSupply -= _value;                      // Updates totalSupply
141         Burn(msg.sender, _value);
142         return true;
143     }
144 
145     /**
146      * Destroy tokens from other account
147      *
148      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
149      *
150      * @param _from the address of the sender
151      * @param _value the amount of money to burn
152      */
153     function burnFrom(address _from, uint256 _value) public returns (bool success) {
154         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
155         require(_value <= allowance[_from][msg.sender]);    // Check allowance
156         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
157         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
158         totalSupply -= _value;                              // Update totalSupply
159         Burn(_from, _value);
160         return true;
161     }
162 }