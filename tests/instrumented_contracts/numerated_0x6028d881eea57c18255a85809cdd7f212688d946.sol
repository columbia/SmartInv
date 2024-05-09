1 pragma solidity ^0.4.20;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
5 }
6 
7 /**
8  * Base Contract of ERC20
9  */
10  contract TokenOfResource {
11  	// Public variables of the token
12     string public name;
13     string public symbol;
14 
15     uint8 public decimals = 18;
16     uint256 public totalSupply;
17 
18     // This creates an array with all balances
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21 
22     // This generates a public event on the blockchain that will notify clients
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     // This notifies clients about the amount burnt
26     event Burn(address indexed from, uint256 value);
27 
28     /**
29      * Constrctor function
30      *
31      * Initializes contract with initial supply tokens to the creator of the contract
32      */
33     constructor() public {
34         totalSupply = 10000000000 * 10 ** uint256(decimals);   	// Update total supply with the decimal amount
35         balanceOf[msg.sender] = totalSupply;					// Give the creator all initial tokens
36 
37         name = 'Resource Token';								// Set the name for display purposes
38         symbol = 'RT';											// Set the symbol for display purposes
39     }
40 
41     /**
42      * Internal transfer, only can be called by this contract
43      */
44     function _transfer(address _from, address _to, uint _value) internal {
45         // Prevent transfer to 0x0 address. Use burn() instead
46         require(_to != 0x0);
47 
48         // Check if the sender has enough
49         require(balanceOf[_from] >= _value);
50 
51         // Check for overflows
52         require(balanceOf[_to] + _value > balanceOf[_to]);
53 
54         // Save this for an assertion in the future
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56 
57         // Subtract from the sender
58         balanceOf[_from] -= _value;
59 
60         // Add the same to the recipient
61         balanceOf[_to] += _value;
62 
63         emit Transfer(_from, _to, _value);
64 
65         // Asserts are used to use static analysis to find bugs in your code. They should never fail
66         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
81 
82     /**
83      * Transfer tokens from other address
84      *
85      * Send `_value` tokens to `_to` on behalf of `_from`
86      *
87      * @param _from The address of the sender
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         require(_value <= allowance[_from][msg.sender]);     // Check allowance
93 
94         allowance[_from][msg.sender] -= _value;
95 
96         _transfer(_from, _to, _value);
97 
98         return true;
99     }
100 
101     /**
102      * Set allowance for other address
103      *
104      * Allows `_spender` to spend no more than `_value` tokens on your behalf
105      *
106      * @param _spender The address authorized to spend
107      * @param _value the max amount they can spend
108      */
109     function approve(address _spender, uint256 _value) public returns (bool success) {
110         allowance[msg.sender][_spender] = _value;
111         return true;
112     }
113 
114 
115     /**
116      * Set allowance for other address and notify
117      *
118      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
119      *
120      * @param _spender The address authorized to spend
121      * @param _value the max amount they can spend
122      * @param _extraData some extra information to send to the approved contract
123      */
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
125         tokenRecipient spender = tokenRecipient(_spender);
126         if (approve(_spender, _value)) {
127             spender.receiveApproval(msg.sender, _value, this, _extraData);
128             return true;
129         }
130     }
131 
132 
133     /**
134      * Destroy tokens
135      *
136      * Remove `_value` tokens from the system irreversibly
137      *
138      * @param _value the amount of money to burn
139      */
140     function burn(uint256 _value) public returns (bool success) {
141         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
142 
143         balanceOf[msg.sender] -= _value;            // Subtract from the sender
144 
145         totalSupply -= _value;                      // Updates totalSupply
146 
147         emit Burn(msg.sender, _value);
148 
149         return true;
150     }
151 
152 
153     /**
154      * Destroy tokens from other account
155      *
156      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
157      *
158      * @param _from the address of the sender
159      * @param _value the amount of money to burn
160      */
161     function burnFrom(address _from, uint256 _value) public returns (bool success) {
162         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
163 
164         require(_value <= allowance[_from][msg.sender]);    // Check allowance
165 
166         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
167         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
168 
169         totalSupply -= _value;                              // Update totalSupply
170 
171         emit Burn(_from, _value);
172         return true;
173     }
174 
175  }