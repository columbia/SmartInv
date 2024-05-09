1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     // Public variables of the token
7     string public name = "Value Promise Protocol token";
8     string public symbol = "VPP";
9     uint256 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply = 50*10**(18+8);
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
25      * Constructor function
26      *
27      * Initializes contract with initial supply tokens to the creator of the contract
28      */
29     function TokenERC20(
30     ) public {
31         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
32     }
33 
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
54 
55     /**
56      * Transfer tokens
57      *
58      * Send `_value` tokens to `_to` from your account
59      *
60      * @param _to The address of the recipient
61      * @param _value the amount to send
62      */
63     function transfer(address _to, uint256 _value) public {
64         _transfer(msg.sender, _to, _value);
65     }
66 
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
82 
83     /**
84      * Set allowance for other address
85      *
86      * Allows `_spender` to spend no more than `_value` tokens on your behalf
87      *
88      * @param _spender The address authorized to spend
89      * @param _value the max amount they can spend
90      */
91     function approve(address _spender, uint256 _value) public
92         returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         return true;
95     }
96 
97     /**
98      * Set allowance for other address and notify
99      *
100      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
101      *
102      * @param _spender The address authorized to spend
103      * @param _value the max amount they can spend
104      * @param _extraData some extra information to send to the approved contract
105      */
106     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
107         public
108         returns (bool success) {
109         tokenRecipient spender = tokenRecipient(_spender);
110         if (approve(_spender, _value)) {
111             spender.receiveApproval(msg.sender, _value, this, _extraData);
112             return true;
113         }
114     }
115 
116     /**
117      * Destroy tokens
118      *
119      * Remove `_value` tokens from the system irreversibly
120      *
121      * @param _value the amount of money to burn
122      */
123     function burn(uint256 _value) public returns (bool success) {
124         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
125         balanceOf[msg.sender] -= _value;            // Subtract from the sender
126         totalSupply -= _value;                      // Updates totalSupply
127         Burn(msg.sender, _value);
128         return true;
129     }
130 
131     /**
132      * Destroy tokens from other account
133      *
134      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
135      *
136      * @param _from the address of the sender
137      * @param _value the amount of money to burn
138      */
139     function burnFrom(address _from, uint256 _value) public returns (bool success) {
140         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
141         require(_value <= allowance[_from][msg.sender]);    // Check allowance
142         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
143         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
144         totalSupply -= _value;                              // Update totalSupply
145         Burn(_from, _value);
146         return true;
147     }
148 }