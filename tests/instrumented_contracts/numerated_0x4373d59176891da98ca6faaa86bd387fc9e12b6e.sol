1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient {
21     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
22 }
23 
24 contract ParsecTokenERC20 {
25     // Public variables of the token
26     string public constant name = "Parsec Credits";
27     string public constant symbol = "PRSC";
28     uint8 public decimals = 6;
29     uint256 public initialSupply = 30856775800;
30     uint256 public totalSupply;
31 
32     // This creates an array with all balances
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35 
36     // This generates a public event on the blockchain that will notify clients
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     // This notifies clients about the amount burnt
40     event Burn(address indexed from, uint256 value);
41 
42     /**
43      * Constrctor function
44      *
45      * Initializes contract with initial supply tokens to the creator of the contract
46      */
47     function ParsecTokenERC20() public {
48         // Update total supply with the decimal amount
49         totalSupply = initialSupply * 10 ** uint256(decimals);
50 
51         // Give the creator all initial tokens
52         balanceOf[msg.sender] = totalSupply;
53     }
54 
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         // Prevent transfer to 0x0 address. Use burn() instead
60         require(_to != 0x0);
61 
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64 
65         // Check for overflows
66         require(balanceOf[_to] + _value > balanceOf[_to]);
67 
68         // Save this for an assertion in the future
69         uint previousBalances = balanceOf[_from] + balanceOf[_to];
70 
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73 
74         // Add the same to the recipient
75         balanceOf[_to] += _value;
76         Transfer(_from, _to, _value);
77 
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82     /**
83      * Transfer tokens
84      *
85      * Send `_value` tokens to `_to` from your account
86      *
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transfer(address _to, uint256 _value) public {
91         _transfer(msg.sender, _to, _value);
92     }
93 
94     /**
95      * Transfer tokens from other address
96      *
97      * Send `_value` tokens to `_to` in behalf of `_from`
98      *
99      * @param _from The address of the sender
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         // Check allowance
105         require(_value <= allowance[_from][msg.sender]);
106 
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address
114      *
115      * Allows `_spender` to spend no more than `_value` tokens in your behalf
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      */
120     function approve(address _spender, uint256 _value) public returns (bool success) {
121         allowance[msg.sender][_spender] = _value;
122         return true;
123     }
124 
125     /**
126      * Set allowance for other address and notify
127      *
128      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
129      *
130      * @param _spender The address authorized to spend
131      * @param _value the max amount they can spend
132      * @param _extraData some extra information to send to the approved contract
133      */
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136 
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143     /**
144      * Destroy tokens
145      *
146      * Remove `_value` tokens from the system irreversibly
147      *
148      * @param _value the amount of money to burn
149      */
150     function burn(uint256 _value) public returns (bool success) {
151         // Check if the sender has enough
152         require(balanceOf[msg.sender] >= _value);
153 
154         // Subtract from the sender
155         balanceOf[msg.sender] -= _value;
156 
157         // Updates totalSupply
158         totalSupply -= _value;
159 
160         // Notify clients about burned tokens
161         Burn(msg.sender, _value);
162 
163         return true;
164     }
165 
166     /**
167      * Destroy tokens from other account
168      *
169      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
170      *
171      * @param _from the address of the sender
172      * @param _value the amount of money to burn
173      */
174     function burnFrom(address _from, uint256 _value) public returns (bool success) {
175         // Check if the targeted balance is enough
176         require(balanceOf[_from] >= _value);
177 
178         // Check allowance
179         require(_value <= allowance[_from][msg.sender]);
180 
181         // Subtract from the targeted balance
182         balanceOf[_from] -= _value;
183 
184         // Subtract from the sender's allowance
185         allowance[_from][msg.sender] -= _value;
186 
187         // Update totalSupply
188         totalSupply -= _value;
189 
190         // Notify clients about burned tokens
191         Burn(_from, _value);
192 
193         return true;
194     }
195 }