1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract yiDaoGame {
6     // Public variables of the token
7     string public name = "YiDaoGame";
8     string public symbol = "dao";
9     uint256 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply = 200*1000*1000*10**decimals;
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
24      * Constrctor functio
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function yiDaoGame(
29     ) public {
30         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
31     }
32 
33     /**
34      * Internal transfer, only can be called by this contract
35      */
36     function _transfer(address _from, address _to, uint _value) internal {
37         // Prevent transfer to 0x0 address. Use burn() instead
38         require(_to != 0x0);
39         // Check if the sender has enough
40         require(balanceOf[_from] >= _value);
41         // Check for overflows
42         require(balanceOf[_to] + _value > balanceOf[_to]);
43         // Save this for an assertion in the future
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         // Subtract from the sender
46         balanceOf[_from] -= _value;
47         // Add the same to the recipient
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50         // Asserts are used to use static analysis to find bugs in your code. They should never fail
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
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
65 
66     /**
67      * Transfer tokens from other address
68      *
69      * Send `_value` tokens to `_to` in behalf of `_from`
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
81 
82     /**
83      * Set allowance for other address
84      *
85      * Allows `_spender` to spend no more than `_value` tokens in your behalf
86      *
87      * @param _spender The address authorized to spend
88      * @param _value the max amount they can spend
89      */
90     function approve(address _spender, uint256 _value) public
91         returns (bool success) {
92         allowance[msg.sender][_spender] = _value;
93         return true;
94     }
95 
96     /**
97      * Set allowance for other address and notify
98      *
99      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
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
114 
115     /**
116      * Destroy tokens
117      *
118      * Remove `_value` tokens from the system irreversibly
119      *
120      * @param _value the amount of money to burn
121      */
122     function burn(uint256 _value) public returns (bool success) {
123         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
124         balanceOf[msg.sender] -= _value;            // Subtract from the sender
125         totalSupply -= _value;                      // Updates totalSupply
126         Burn(msg.sender, _value);
127         return true;
128     }
129 
130     /**
131      * Destroy tokens from other account
132      *
133      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
134      *
135      * @param _from the address of the sender
136      * @param _value the amount of money to burn
137      */
138     function burnFrom(address _from, uint256 _value) public returns (bool success) {
139         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
140         require(_value <= allowance[_from][msg.sender]);    // Check allowance
141         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
142         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
143         totalSupply -= _value;                              // Update totalSupply
144         Burn(_from, _value);
145         return true;
146     }
147 }