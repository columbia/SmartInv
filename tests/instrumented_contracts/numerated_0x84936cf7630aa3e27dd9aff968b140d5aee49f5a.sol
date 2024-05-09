1 pragma solidity ^0.4.16;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
3 contract TokenERC20 {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 8;
8     address public owner;
9     // 18 decimals is the strongly suggested default, avoid changing it
10     uint256 public totalSupply;
11     bool public lockIn;
12     mapping (address => bool) whitelisted;
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
19     // This notifies clients about the amount burnt
20     event Burn(address indexed from, uint256 value);
21     /**
22      * Constrctor function
23      *
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     function TokenERC20(
27         uint256 initialSupply,
28         string tokenName,
29         string tokenSymbol,
30         address crowdsaleOwner
31     ) public {
32         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
33         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
34         name = tokenName;                                   // Set the name for display purposes
35         symbol = tokenSymbol;                               // Set the symbol for display purposes
36         lockIn = true;
37         whitelisted[msg.sender] = true;
38         owner = crowdsaleOwner;
39     }
40     function toggleLockIn() public {
41         require(msg.sender == owner);
42         lockIn = !lockIn;
43     }
44     
45     function addToWhitelist(address newAddress) public {
46         require(whitelisted[msg.sender]);
47         whitelisted[newAddress] = true;
48     }
49     /**
50      * Internal transfer, only can be called by this contract
51      */
52     function _transfer(address _from, address _to, uint _value) internal {
53         if (lockIn) {
54             require(whitelisted[_from]);
55         }
56         // Prevent transfer to 0x0 address. Use burn() instead
57         require(_to != 0x0);
58         // Check if the sender has enough
59         require(balanceOf[_from] >= _value);
60         // Check for overflows
61         require(balanceOf[_to] + _value > balanceOf[_to]);
62         // Save this for an assertion in the future
63         uint previousBalances = balanceOf[_from] + balanceOf[_to];
64         // Subtract from the sender
65         balanceOf[_from] -= _value;
66         // Add the same to the recipient
67         balanceOf[_to] += _value;
68         Transfer(_from, _to, _value);
69         // Asserts are used to use static analysis to find bugs in your code. They should never fail
70         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
71     }
72     /**
73      * Transfer tokens
74      *
75      * Send `_value` tokens to `_to` from your account
76      *
77      * @param _to The address of the recipient
78      * @param _value the amount to send
79      */
80     function transfer(address _to, uint256 _value) public {
81         _transfer(msg.sender, _to, _value);
82     }
83     /**
84      * Transfer tokens from other address
85      *
86      * Send `_value` tokens to `_to` on behalf of `_from`
87      *
88      * @param _from The address of the sender
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         require(_value <= allowance[_from][msg.sender]);     // Check allowance
94         allowance[_from][msg.sender] -= _value;
95         _transfer(_from, _to, _value);
96         return true;
97     }
98     /**
99      * Set allowance for other address
100      *
101      * Allows `_spender` to spend no more than `_value` tokens on your behalf
102      *
103      * @param _spender The address authorized to spend
104      * @param _value the max amount they can spend
105      */
106     function approve(address _spender, uint256 _value) public
107         returns (bool success) {
108         allowance[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112     /**
113      * Set allowance for other address and notify
114      *
115      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      * @param _extraData some extra information to send to the approved contract
120      */
121     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
122         public
123         returns (bool success) {
124         tokenRecipient spender = tokenRecipient(_spender);
125         if (approve(_spender, _value)) {
126             spender.receiveApproval(msg.sender, _value, this, _extraData);
127             return true;
128         }
129     }
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