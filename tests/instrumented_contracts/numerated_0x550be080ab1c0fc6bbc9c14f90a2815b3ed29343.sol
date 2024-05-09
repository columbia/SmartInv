1 pragma solidity ^0.4.24;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function assert(bool assertion) internal {
32     if (!assertion) {
33       throw;
34     }
35   }
36 }
37 
38 
39 contract TokenERC20 is SafeMath {
40     // Public variables of the token
41     string public name;
42     string public symbol;
43     uint8 public decimals = 18;
44     // 18 decimals is the strongly suggested default, avoid changing it
45     uint256 public totalSupply;
46 
47     // This creates an array with all balances
48     mapping (address => uint256) public balanceOf;
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51     // This generates a public event on the blockchain that will notify clients
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     // This notifies clients about the amount burnt
55     event Burn(address indexed from, uint256 value);
56 
57     /**
58      * Constructor function
59      *
60      * Initializes contract with initial supply tokens to the creator of the contract
61      */
62     function TokenERC20(
63         uint256 initialSupply,
64         string tokenName,
65         string tokenSymbol
66     ) public {
67         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
68         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
69         name = tokenName;                                   // Set the name for display purposes
70         symbol = tokenSymbol;                               // Set the symbol for display purposes
71     }
72 
73     /**
74      * Internal transfer, only can be called by this contract
75      */
76     function _transfer(address _from, address _to, uint _value) internal {
77         if (_to == 0x0) throw;
78         if (_value <= 0) throw; 
79         if (balanceOf[_from] < _value) throw;
80         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
81         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
82         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
83         Transfer(_from, _to, _value);
84     }
85 
86     /**
87      * Transfer tokens
88      *
89      * Send `_value` tokens to `_to` from your account
90      *
91      * @param _to The address of the recipient
92      * @param _value the amount to send
93      */
94     function transfer(address _to, uint256 _value) public {
95         _transfer(msg.sender, _to, _value);
96     }
97 
98     /**
99      * Transfer tokens from other address
100      *
101      * Send `_value` tokens to `_to` on behalf of `_from`
102      *
103      * @param _from The address of the sender
104      * @param _to The address of the recipient
105      * @param _value the amount to send
106      */
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
108         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
109         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
110         _transfer(_from, _to, _value);
111         return true;
112     }
113 
114     /**
115      * Set allowance for other address
116      *
117      * Allows `_spender` to spend no more than `_value` tokens on your behalf
118      *
119      * @param _spender The address authorized to spend
120      * @param _value the max amount they can spend
121      */
122     function approve(address _spender, uint256 _value) public
123         returns (bool success) {
124         if (_value <= 0) throw;
125         allowance[msg.sender][_spender] = _value;
126         return true;
127     }
128 
129     /**
130      * Destroy tokens
131      *
132      * Remove `_value` tokens from the system irreversibly
133      *
134      * @param _value the amount of money to burn
135      */
136     function burn(uint256 _value) public returns (bool success) {
137         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
138 		if (_value <= 0) throw; 
139         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);  // Subtract from the sender
140         totalSupply = SafeMath.safeSub(totalSupply,_value);  // Updates totalSupply
141         Burn(msg.sender, _value);
142         return true;
143     }
144 }