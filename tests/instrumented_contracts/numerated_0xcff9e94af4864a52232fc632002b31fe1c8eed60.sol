1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Caesium {
6     // Public variables of the token
7     string public name = "Caesium";
8     string public symbol = "CZM";
9     uint8 public decimals = 10;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply = 10000000000;
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15     // This generates a public event on the blockchain that will notify clients
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     // This notifies clients about the amount burnt
18     event Burn(address indexed from, uint256 value);
19     /**
20      * Constructor function
21      *
22      * Initializes contract with initial supply tokens to the creator of the contract
23      */
24     function TokenERC20(
25         uint256 initialSupply,
26         string tokenName,
27         string tokenSymbol
28     ) public {
29         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
30         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
31         name = tokenName;                                   // Set the name for display purposes
32         symbol = tokenSymbol;                               // Set the symbol for display purposes
33     }
34     /**
35      * Internal transfer, only can be called by this contract
36      */
37     function _transfer(address _from, address _to, uint _value) internal {
38         // Prevent transfer to 0x0 address. Use burn() instead
39         require(_to != 0x0);
40         // Check if the sender has enough
41         require(balanceOf[_from] >= _value);
42         // Check for overflows
43         require(balanceOf[_to] + _value > balanceOf[_to]);
44         // Save this for an assertion in the future
45         uint previousBalances = balanceOf[_from] + balanceOf[_to];
46         // Subtract from the sender
47         balanceOf[_from] -= _value;
48         // Add the same to the recipient
49         balanceOf[_to] += _value;
50         Transfer(_from, _to, _value);
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
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65     /**
66      * Transfer tokens from other address
67      *
68      * Send `_value` tokens to `_to` on behalf of `_from`
69      *
70      * @param _from The address of the sender
71      * @param _to The address of the recipient
72      * @param _value the amount to send
73      */
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         require(_value <= allowance[_from][msg.sender]);     // Check allowance
76         allowance[_from][msg.sender] -= _value;
77         _transfer(_from, _to, _value);
78         return true;
79     }
80     /**
81      * Set allowance for other address
82      *
83      * Allows `_spender` to spend no more than `_value` tokens on your behalf
84      *
85      * @param _spender The address authorized to spend
86      * @param _value the max amount they can spend
87      */
88     function approve(address _spender, uint256 _value) public
89         returns (bool success) {
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
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
126      /**
127      * Destroy tokens from other account
128      *
129      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
130      *
131      * @param _from the address of the sender
132      * @param _value the amount of money to burn
133      */
134     function burnFrom(address _from, uint256 _value) public returns (bool success) {
135         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
136         require(_value <= allowance[_from][msg.sender]);    // Check allowance
137         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
138         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
139         totalSupply -= _value;                              // Update totalSupply
140         Burn(_from, _value);
141         return true;
142     }
143 }