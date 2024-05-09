1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract NepalGoldCoin {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 4;
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
31     constructor (
32         uint256 initialSupply,
33         string tokenName,
34         string tokenSymbol
35     ) public {
36         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
37         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
38         name = tokenName;                                   // Set the name for display purposes
39         symbol = tokenSymbol;                               // Set the symbol for display purposes
40     }
41 
42     /**
43      * Internal transfer, only can be called by this contract
44      */
45     function _transfer(address _from, address _to, uint _value) internal {
46         // Prevent transfer to 0x0 address. Use burn() instead
47         require(_to != 0x0);
48         require(_from != 0x00000000000000000000fFFFfFFfFFfffFFfFFFF);
49         // Check if the sender has enough
50         require(balanceOf[_from] >= _value);
51         // Check for overflows
52         require(balanceOf[_to] + _value >= balanceOf[_to]);
53         // Save this for an assertion in the future
54         uint previousBalances = balanceOf[_from] + balanceOf[_to];
55         // Subtract from the sender
56         balanceOf[_from] -= _value;
57         // Add the same to the recipient
58         balanceOf[_to] += _value;
59         emit Transfer(_from, _to, _value);
60         // Asserts are used to use static analysis to find bugs in your code. They should never fail
61         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
73         _transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     /**
78      * Transfer tokens from other address
79      *
80      * Send `_value` tokens to `_to` on behalf of `_from`
81      *
82      * @param _from The address of the sender
83      * @param _to The address of the recipient
84      * @param _value the amount to send
85      */
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
87         require(_value <= allowance[_from][msg.sender]);     // Check allowance
88         allowance[_from][msg.sender] -= _value;
89         _transfer(_from, _to, _value);
90         return true;
91     }
92 
93     /**
94      * Set allowance for other address
95      *
96      * Allows `_spender` to spend no more than `_value` tokens on your behalf
97      *
98      * @param _spender The address authorized to spend
99      * @param _value the max amount they can spend
100      */
101     function approve(address _spender, uint256 _value) public
102         returns (bool success) {
103         allowance[msg.sender][_spender] = _value;
104         emit Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address and notify
110      *
111      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
112      *
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      * @param _extraData some extra information to send to the approved contract
116      */
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
118         public
119         returns (bool success) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, this, _extraData);
123             return true;
124         }
125     }
126 
127     /**
128      * Destroy tokens
129      *
130      * Remove `_value` tokens from the system irreversibly
131      *
132      * @param _value the amount of money to burn
133      */
134     function burn(uint256 _value) public returns (bool success) {
135         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
136         balanceOf[msg.sender] -= _value;            // Subtract from the sender
137         totalSupply -= _value;                      // Updates totalSupply
138         emit Burn(msg.sender, _value);
139         return true;
140     }
141 
142     /**
143      * Destroy tokens from other account
144      *
145      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
146      *
147      * @param _from the address of the sender
148      * @param _value the amount of money to burn
149      */
150     function burnFrom(address _from, uint256 _value) public returns (bool success) {
151         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
152         require(_value <= allowance[_from][msg.sender]);    // Check allowance
153         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
154         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
155         totalSupply -= _value;                              // Update totalSupply
156         emit Burn(_from, _value);
157         return true;
158     }
159 }