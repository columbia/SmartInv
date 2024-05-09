1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18     function TokenERC20(
19         uint256 initialSupply,
20         string tokenName,
21         string tokenSymbol
22     ) public {
23         totalSupply = initialSupply * 10 ** uint256(decimals);  
24         balanceOf[msg.sender] = totalSupply;              
25         name = tokenName;                                   
26         symbol = tokenSymbol;                              
27     }
28 
29     /**
30      * Internal transfer, only can be called by this contract
31      */
32     function _transfer(address _from, address _to, uint _value) internal {
33         // Prevent transfer to 0x0 address. Use burn() instead
34         require(_to != 0x0);
35         // Check if the sender has enough
36         require(balanceOf[_from] >= _value);
37         // Check for overflows
38         require(balanceOf[_to] + _value > balanceOf[_to]);
39         // Save this for an assertion in the future
40         uint previousBalances = balanceOf[_from] + balanceOf[_to];
41         // Subtract from the sender
42         balanceOf[_from] -= _value;
43         // Add the same to the recipient
44         balanceOf[_to] += _value;
45         Transfer(_from, _to, _value);
46         // Asserts are used to use static analysis to find bugs in your code. They should never fail
47         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
48     }
49 
50     /**
51      * Transfer tokens
52      *
53      * Send `_value` tokens to `_to` from your account
54      *
55      * @param _to The address of the recipient
56      * @param _value the amount to send
57      */
58     function transfer(address _to, uint256 _value) public {
59         _transfer(msg.sender, _to, _value);
60     }
61 
62     /**
63      * Transfer tokens from other address
64      *
65      * Send `_value` tokens to `_to` in behalf of `_from`
66      *
67      * @param _from The address of the sender
68      * @param _to The address of the recipient
69      * @param _value the amount to send
70      */
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
72         require(_value <= allowance[_from][msg.sender]);     // Check allowance
73         allowance[_from][msg.sender] -= _value;
74         _transfer(_from, _to, _value);
75         return true;
76     }
77 
78     /**
79      * Set allowance for other address
80      *
81      * Allows `_spender` to spend no more than `_value` tokens in your behalf
82      *
83      * @param _spender The address authorized to spend
84      * @param _value the max amount they can spend
85      */
86     function approve(address _spender, uint256 _value) public
87         returns (bool success) {
88         allowance[msg.sender][_spender] = _value;
89         return true;
90     }
91 
92     /**
93      * Set allowance for other address and notify
94      *
95      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
96      *
97      * @param _spender The address authorized to spend
98      * @param _value the max amount they can spend
99      * @param _extraData some extra information to send to the approved contract
100      */
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
102         public
103         returns (bool success) {
104         tokenRecipient spender = tokenRecipient(_spender);
105         if (approve(_spender, _value)) {
106             spender.receiveApproval(msg.sender, _value, this, _extraData);
107             return true;
108         }
109     }
110 
111     /**
112      * Destroy tokens
113      *
114      * Remove `_value` tokens from the system irreversibly
115      *
116      * @param _value the amount of money to burn
117      */
118     function burn(uint256 _value) public returns (bool success) {
119         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
120         balanceOf[msg.sender] -= _value;            // Subtract from the sender
121         totalSupply -= _value;                      // Updates totalSupply
122         Burn(msg.sender, _value);
123         return true;
124     }
125 
126     /**
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