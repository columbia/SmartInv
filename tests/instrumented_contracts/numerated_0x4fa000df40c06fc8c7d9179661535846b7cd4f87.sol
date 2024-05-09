1 pragma solidity ^0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract ZenswapNetworkToken {
6     // Public variables of the token
7     string public name = "Zenswap Network Token";
8     string public symbol = "ZNT";
9     uint8 public decimals = 18;
10     uint256 public initialSupply = 20000000000 * 10 ** uint256(decimals);
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     
20     // This generates a public event on the blockchain that will notify clients
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 
23     // This notifies clients about the amount burnt
24     event Burn(address indexed from, uint256 value);
25 
26     /**
27      * Constructor function
28      *
29      * Initializes contract with initial supply tokens to the creator of the contract
30      */
31     constructor() public {
32         
33         totalSupply = initialSupply;  // Update total supply with the decimal amount
34         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
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
53         emit Transfer(_from, _to, _value);
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
66     function transfer(address _to, uint256 _value) public returns (bool success) {
67         _transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     /**
72      * Transfer tokens from other address
73      *
74      * Send `_value` tokens to `_to` in behalf of `_from`
75      *
76      * @param _from The address of the sender
77      * @param _to The address of the recipient
78      * @param _value the amount to send
79      */
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
81         require(_value <= allowance[_from][msg.sender]);     // Check allowance
82         allowance[_from][msg.sender] -= _value;
83         _transfer(_from, _to, _value);
84         return true;
85     }
86 
87     /**
88      * Set allowance for other address
89      *
90      * Allows `_spender` to spend no more than `_value` tokens in your behalf
91      *
92      * @param _spender The address authorized to spend
93      * @param _value the max amount they can spend
94      */
95     function approve(address _spender, uint256 _value) public
96         returns (bool success) {
97         allowance[msg.sender][_spender] = _value;
98         emit Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     /**
103      * Set allowance for other address and notify
104      *
105      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
106      *
107      * @param _spender The address authorized to spend
108      * @param _value the max amount they can spend
109      * @param _extraData some extra information to send to the approved contract
110      */
111     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
112         public
113         returns (bool success) {
114         tokenRecipient spender = tokenRecipient(_spender);
115         if (approve(_spender, _value)) {
116             spender.receiveApproval(msg.sender, _value, this, _extraData);
117             return true;
118         }
119     }
120 
121     /**
122      * Destroy tokens
123      *
124      * Remove `_value` tokens from the system irreversibly
125      *
126      * @param _value the amount of money to burn
127      */
128     function burn(uint256 _value) public returns (bool success) {
129         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
130         balanceOf[msg.sender] -= _value;            // Subtract from the sender
131         totalSupply -= _value;                      // Updates totalSupply
132         emit Burn(msg.sender, _value);
133         return true;
134     }
135 
136     /**
137      * Destroy tokens from other account
138      *
139      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
140      *
141      * @param _from the address of the sender
142      * @param _value the amount of money to burn
143      */
144     function burnFrom(address _from, uint256 _value) public returns (bool success) {
145         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
146         require(_value <= allowance[_from][msg.sender]);    // Check allowance
147         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
148         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
149         totalSupply -= _value;                              // Update totalSupply
150         emit Burn(_from, _value);
151         return true;
152     }
153 }