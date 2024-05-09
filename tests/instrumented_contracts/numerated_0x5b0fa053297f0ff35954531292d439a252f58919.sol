1 pragma solidity ^ 0.4.18;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
3 contract TRCERC20 {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8     // 18 decimals is the strongly suggested default, avoid changing it
9     uint256 public totalSupply;
10     // This creates an array with all balances
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13     // This generates a public event on the blockchain that will notify clients
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     
16     // This generates a public event on the blockchain that will notify clients
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18     // This notifies clients about the amount burnt
19     event Burn(address indexed from, uint256 value);
20     /**
21      * Constructor function
22      *
23      * Initializes contract with initial supply tokens to the creator of the contract
24      */
25     function TRCERC20(
26         uint256 initialSupply,
27         string tokenName,
28         string tokenSymbol
29     ) public {
30         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
31         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
32         name = tokenName;                                   // Set the name for display purposes
33         symbol = tokenSymbol;                               // Set the symbol for display purposes
34     }
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint _value) internal {
39         // Prevent transfer to 0x0 address. Use burn() instead
40         require(_to != 0x0);
41         // Check if the sender has enough
42         require(balanceOf[_from] >= _value);
43         // Check for overflows
44         require(balanceOf[_to] + _value >= balanceOf[_to]);
45         // Save this for an assertion in the future
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         // Subtract from the sender
48         balanceOf[_from] -= _value;
49         // Add the same to the recipient
50         balanceOf[_to] += _value;
51         emit Transfer(_from, _to, _value);
52         // Asserts are used to use static analysis to find bugs in your code. They should never fail
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55     /**
56      * Transfer tokens
57      *
58      * Send `_value` tokens to `_to` from your account
59      *
60      * @param _to The address of the recipient
61      * @param _value the amount to send
62      */
63     function transfer(address _to, uint256 _value) public returns (bool success) {
64         _transfer(msg.sender, _to, _value);
65         return true;
66     }
67     /**
68      * Transfer tokens from other address
69      *
70      * Send `_value` tokens to `_to` on behalf of `_from`
71      *
72      * @param _from The address of the sender
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_value <= allowance[_from][msg.sender]);     // Check allowance
78         allowance[_from][msg.sender] -= _value;
79         _transfer(_from, _to, _value);
80         return true;
81     }
82     /**
83      * Set allowance for other address
84      *
85      * Allows `_spender` to spend no more than `_value` tokens on your behalf
86      *
87      * @param _spender The address authorized to spend
88      * @param _value the max amount they can spend
89      */
90     function approve(address _spender, uint256 _value) public
91         returns (bool success) {
92         allowance[msg.sender][_spender] = _value;
93         emit Approval(msg.sender, _spender, _value);
94         return true;
95     }
96     /**
97      * Set allowance for other address and notify
98      *
99      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
100      *
101      * @param _spender The address authorized to spend
102      * @param _value the max amount they can spend
103      * @param _extraData some extra information to send to the approved contract
104      */
105     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
106         public
107         returns (bool success) {
108         tokenRecipient spender = tokenRecipient(_spender);
109         if (approve(_spender, _value)) {
110             spender.receiveApproval(msg.sender, _value, this, _extraData);
111             return true;
112         }
113     }
114     /**
115      * Destroy tokens
116      *
117      * Remove `_value` tokens from the system irreversibly
118      *
119      * @param _value the amount of money to burn
120      */
121     function burn(uint256 _value) public returns (bool success) {
122         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
123         balanceOf[msg.sender] -= _value;            // Subtract from the sender
124         totalSupply -= _value;                      // Updates totalSupply
125         emit Burn(msg.sender, _value);
126         return true;
127     }
128     /**
129      * Destroy tokens from other account
130      *
131      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
132      *
133      * @param _from the address of the sender
134      * @param _value the amount of money to burn
135      */
136     function burnFrom(address _from, uint256 _value) public returns (bool success) {
137         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
138         require(_value <= allowance[_from][msg.sender]);    // Check allowance
139         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
140         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
141         totalSupply -= _value;                              // Update totalSupply
142         emit Burn(_from, _value);
143         return true;
144     }
145 }