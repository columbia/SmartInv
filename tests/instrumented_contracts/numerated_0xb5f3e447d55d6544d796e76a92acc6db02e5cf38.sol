1 pragma solidity >=0.4.22 <0.6.0;
2 interface tokenRecipient { 
3     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
4 }
5 contract TokenERC20 {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15     // This generates a public event on the blockchain that will notify clients
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     
18     // This generates a public event on the blockchain that will notify clients
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22     /**
23      * Constructor function
24      *
25      * Initializes contract with initial supply tokens to the creator of the contract
26      */
27     constructor(
28     ) public {
29         totalSupply = 100000000000 * 10 ** 18;  // Update total supply with the decimal amount
30         balanceOf[0x0Cfe165D1C0dAb8d2b99896a4b7B923F3BB06c79] = totalSupply;                // Give the creator all initial tokens
31         name = "LeoCoin";                                   // Set the name for display purposes
32         symbol = "LCOIN";                               // Set the symbol for display purposes
33     }
34     /**
35      * Internal transfer, only can be called by this contract
36      */
37     function _transfer(address _from, address _to, uint _value) internal {
38         // Prevent transfer to 0x0 address. Use burn() instead
39         require(_to != address(0x0));
40         // Check if the sender has enough
41         require(balanceOf[_from] >= _value);
42         // Check for overflows
43         require(balanceOf[_to] + _value >= balanceOf[_to]);
44         // Save this for an assertion in the future
45         uint previousBalances = balanceOf[_from] + balanceOf[_to];
46         // Subtract from the sender
47         balanceOf[_from] -= _value;
48         // Add the same to the recipient
49         balanceOf[_to] += _value;
50         emit Transfer(_from, _to, _value);
51         // Asserts are used to use static analysis to find bugs in your code. They should never fail
52         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53     }
54     /**
55      * Transfer tokens
56      *
57      * Send `_value` tokens to `_to` from your account
58      *
59      * @param _to The address of the recipient
60      * @param _value the amount to send
61      */
62     function transfer(address _to, uint256 _value) public returns (bool success) {
63         _transfer(msg.sender, _to, _value);
64         return true;
65     }
66     /**
67      * Transfer tokens from other address
68      *
69      * Send `_value` tokens to `_to` on behalf of `_from`
70      *
71      * @param _from The address of the sender
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76         require(_value <= allowance[_from][msg.sender]);     // Check allowance
77         allowance[_from][msg.sender] -= _value;
78         _transfer(_from, _to, _value);
79         return true;
80     }
81     /**
82      * Set allowance for other address
83      *
84      * Allows `_spender` to spend no more than `_value` tokens on your behalf
85      *
86      * @param _spender The address authorized to spend
87      * @param _value the max amount they can spend
88      */
89     function approve(address _spender, uint256 _value) public
90         returns (bool success) {
91         allowance[msg.sender][_spender] = _value;
92         emit Approval(msg.sender, _spender, _value);
93         return true;
94     }
95     /**
96      * Set allowance for other address and notify
97      *
98      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      * @param _extraData some extra information to send to the approved contract
103      */
104     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
105         public
106         returns (bool success) {
107         tokenRecipient spender = tokenRecipient(_spender);
108         if (approve(_spender, _value)) {
109             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
110             return true;
111         }
112     }
113     /**
114      * Destroy tokens
115      *
116      * Remove `_value` tokens from the system irreversibly
117      *
118      * @param _value the amount of money to burn
119      */
120     function burn(uint256 _value) public returns (bool success) {
121         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
122         balanceOf[msg.sender] -= _value;            // Subtract from the sender
123         totalSupply -= _value;                      // Updates totalSupply
124         emit Burn(msg.sender, _value);
125         return true;
126     }
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
141         emit Burn(_from, _value);
142         return true;
143     }
144 }