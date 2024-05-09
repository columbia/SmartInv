1 pragma solidity ^0.4.16;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
26 
27 contract K5cTokens is SafeMath {
28     // Public variables of the token
29     string public   name;
30     string public   symbol;
31     uint8 public    decimals = 18;                                                  // 18 decimals is the strongly suggested default, avoid changing it
32 
33     uint256 public  totalSupply;
34 
35     // This creates an array with all balances
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38 
39     // This generates a public event on the blockchain that will notify clients
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     // This notifies clients about the amount burnt
43     event Burn(address indexed from, uint256 value);
44 
45     /**
46      * Constructor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     function K5cTokens(
51         uint256 initialSupply
52     ) public {
53         totalSupply             = initialSupply * 10 ** uint256(decimals);          // Update total supply with the decimal amount
54         balanceOf[msg.sender]   = totalSupply;                                      // Give the creator all initial tokens
55         name                    = "K5C Tokens";                                     // Set the name for display purposes
56         symbol                  = "K5C";                                            // Set the symbol for display purposes
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances   = safeAdd(balanceOf[_from], balanceOf[_to]);
71         // Subtract from the sender
72         balanceOf[_from]        = safeSub(balanceOf[_from], _value);
73         // Add the same to the recipient
74         balanceOf[_to]          = safeAdd(balanceOf[_to], _value);
75 
76         Transfer(_from, _to, _value);
77         // Asserts are used to use static analysis to find bugs in your code. They should never fail
78         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
79     }
80 
81     /**
82      * Transfer tokens
83      *
84      * Send `_value` tokens to `_to` from your account
85      *
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transfer(address _to, uint256 _value) public {
90         _transfer(msg.sender, _to, _value);
91     }
92 
93     /**
94      * Transfer tokens from other address
95      *
96      * Send `_value` tokens to `_to` on behalf of `_from`
97      *
98      * @param _from The address of the sender
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);                                // Check allowance
104 
105         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);   // Decrease allowance
106         _transfer(_from, _to, _value);                                                  // Call transfer function
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address
112      *
113      * Allows `_spender` to spend no more than `_value` tokens on your behalf
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      */
118     function approve(address _spender, uint256 _value) public returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address and notify
125      *
126      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      * @param _extraData some extra information to send to the approved contract
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, this, _extraData);
136             return true;
137         }
138     }
139 
140     /**
141      * Destroy tokens
142      *
143      * Remove `_value` tokens from the system irreversibly
144      *
145      * @param _value the amount of money to burn
146      */
147     function burn(uint256 _value) public returns (bool success) {
148         require(balanceOf[msg.sender] >= _value);                                               // Check if the sender has enough
149 
150         balanceOf[msg.sender]           = safeSub(balanceOf[msg.sender], _value);               // Subtract from the sender
151         totalSupply                     = safeSub(totalSupply, _value);                         // Updates totalSupply
152         Burn(msg.sender, _value);
153         return true;
154     }
155 
156     /**
157      * Destroy tokens from other account
158      *
159      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
160      *
161      * @param _from the address of the sender
162      * @param _value the amount of money to burn
163      */
164     function burnFrom(address _from, uint256 _value) public returns (bool success) {
165         require(balanceOf[_from] >= _value);                                                    // Check if the targeted balance is enough
166         require(_value <= allowance[_from][msg.sender]);                                        // Check allowance
167 
168         balanceOf[_from]                = safeSub(balanceOf[_from], _value);                    // Subtract from the targeted balance
169         allowance[_from][msg.sender]    = safeSub(allowance[_from][msg.sender], _value);        // Subtract from the sender's allowance
170         totalSupply                     = safeSub(totalSupply, _value);                         // Update totalSupply
171         Burn(_from, _value);
172         return true;
173     }
174 
175 
176     /**
177      * The function without name is the default function that is called whenever anyone sends funds to a contract
178      * This is called when ETH is transferred
179      */
180     function () public payable {
181         revert();
182     }
183 }