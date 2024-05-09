1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Gath {
6     // Public variables of the token
7     string public name="Gath";
8     string public symbol="GHC";
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply=23000000000*10**uint256(decimals);
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24      * Constrctor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function Gath() public {
29         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
30     }
31 
32     /**
33      * Internal transfer, only can be called by this contract
34      */
35     function _transfer(address _from, address _to, uint _value) internal {
36         // Prevent transfer to 0x0 address. Use burn() instead
37         require(_to != 0x0);
38         // Check if the sender has enough
39         require(balanceOf[_from] >= _value);
40         // Check for overflows
41         require(balanceOf[_to] + _value > balanceOf[_to]);
42         // Save this for an assertion in the future
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         // Subtract from the sender
45         balanceOf[_from] -= _value;
46         // Add the same to the recipient
47         balanceOf[_to] += _value;
48         Transfer(_from, _to, _value);
49         // Asserts are used to use static analysis to find bugs in your code. They should never fail
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53     /**
54      * Transfer tokens
55      *
56      * Send `_value` tokens to `_to` from your account
57      *
58      * @param _to The address of the recipient
59      * @param _value the amount to send
60      */
61     function transfer(address _to, uint256 _value) public {
62         _transfer(msg.sender, _to, _value);
63     }
64 
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
80 
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
92         return true;
93     }
94 
95     /**
96      * Set allowance for other address and notify
97      *
98      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      * @param _extraData some extra information to send to the approved contract
103      */
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
105         public
106         returns (bool success) {
107         tokenRecipient spender = tokenRecipient(_spender);
108         if (approve(_spender, _value)) {
109             spender.receiveApproval(msg.sender, _value, this, _extraData);
110             return true;
111         }
112     }
113 
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
125         Burn(msg.sender, _value);
126         return true;
127     }
128 
129     /**
130      * Destroy tokens from other account
131      *
132      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
133      *
134      * @param _from the address of the sender
135      * @param _value the amount of money to burn
136      */
137     function burnFrom(address _from, uint256 _value) public returns (bool success) {
138         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
139         require(_value <= allowance[_from][msg.sender]);    // Check allowance
140         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
141         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
142         totalSupply -= _value;                              // Update totalSupply
143         Burn(_from, _value);
144         return true;
145     }
146 }