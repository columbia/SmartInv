1 pragma solidity ^0.4.21;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Token {
6     // Public variables of the token
7     string public name = "Voxelx GRAY";
8     string public symbol = "GRAY";
9     uint8 public decimals = 18;
10     uint256 public totalSupply = 10000000000 * 10 ** uint256(decimals); // 10 billion tokens;
11 
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     // This notifies clients about the amount burnt
20     event Burn(address indexed from, uint256 value);
21 
22     /**
23      * Constructor function
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     function Token() public {
27         balanceOf[msg.sender] = totalSupply;
28     }
29 
30     /**
31      * Internal transfer, only can be called by this contract
32      */
33     function _transfer(address _from, address _to, uint _value) internal {
34         // Prevent transfer to 0x0 address. Use burn() instead
35         require(_to != 0x0);
36         // Check if the sender has enough
37         require(balanceOf[_from] >= _value);
38         // Check for overflows
39         require(balanceOf[_to] + _value > balanceOf[_to]);
40         // Save this for an assertion in the future
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];
42         // Subtract from the sender
43         balanceOf[_from] -= _value;
44         // Add the same to the recipient
45         balanceOf[_to] += _value;
46         Transfer(_from, _to, _value);
47         // Asserts are used to use static analysis to find bugs in your code. They should never fail
48         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
49     }
50 
51     /**
52      * Transfer tokens
53      *
54      * Send `_value` tokens to `_to` from your account
55      *
56      * @param _to The address of the recipient
57      * @param _value the amount to send
58      */
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
62 
63     /**
64      * Transfer tokens from other address
65      *
66      * Send `_value` tokens to `_to` on behalf of `_from`
67      *
68      * @param _from The address of the sender
69      * @param _to The address of the recipient
70      * @param _value the amount to send
71      */
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require(_value <= allowance[_from][msg.sender]);     // Check allowance
74         allowance[_from][msg.sender] -= _value;
75         _transfer(_from, _to, _value);
76         return true;
77     }
78 
79     /**
80      * Set allowance for other address
81      *
82      * Allows `_spender` to spend no more than `_value` tokens on your behalf
83      *
84      * @param _spender The address authorized to spend
85      * @param _value the max amount they can spend
86      */
87     function approve(address _spender, uint256 _value) public
88         returns (bool success) {
89         allowance[msg.sender][_spender] = _value;
90         return true;
91     }
92 
93     /**
94      * Set allowance for other address and notify
95      *
96      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
97      *
98      * @param _spender The address authorized to spend
99      * @param _value the max amount they can spend
100      * @param _extraData some extra information to send to the approved contract
101      */
102     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
103         public
104         returns (bool success) {
105         tokenRecipient spender = tokenRecipient(_spender);
106         if (approve(_spender, _value)) {
107             spender.receiveApproval(msg.sender, _value, this, _extraData);
108             return true;
109         }
110     }
111 
112     /**
113      * Destroy tokens
114      *
115      * Remove `_value` tokens from the system irreversibly
116      *
117      * @param _value the amount of money to burn
118      */
119     function burn(uint256 _value) public returns (bool success) {
120         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
121         balanceOf[msg.sender] -= _value;            // Subtract from the sender
122         totalSupply -= _value;                      // Updates totalSupply
123         Burn(msg.sender, _value);
124         return true;
125     }
126 
127     /**
128      * Destroy tokens from other account
129      *
130      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
131      *
132      * @param _from the address of the sender
133      * @param _value the amount of money to burn
134      */
135     function burnFrom(address _from, uint256 _value) public returns (bool success) {
136         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
137         require(_value <= allowance[_from][msg.sender]);    // Check allowance
138         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
139         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
140         totalSupply -= _value;                              // Update totalSupply
141         Burn(_from, _value);
142         return true;
143     }
144 }