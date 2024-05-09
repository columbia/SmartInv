1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Unsigned math operations with safety checks that revert on error.
9  */
10 library SafeMath {
11     /**
12      * @dev Adds two unsigned integers, reverts on overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         c = a + b;
16         assert(c >= a);
17         return c;
18     }
19 
20     /**
21      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
22      */
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     /**
29      * @dev Multiplies two unsigned integers, reverts on overflow.
30      */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
32         if (a == 0) {
33             return 0;
34         }
35         c = a * b;
36         assert(c / a == b);
37         return c;
38     }
39 
40     /**
41      * @dev Integer division of two unsigned integers truncating the quotient,
42      * reverts on division by zero.
43      */
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b > 0);
46         uint256 c = a / b;
47         assert(a == b * c + a % b);
48         return a / b;
49     }
50 
51     /**
52      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
53      * reverts when dividing by zero.
54      */
55     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b != 0);
57         return a % b;
58     }
59 }
60 
61 contract EtherDiamond {
62     using SafeMath for uint256;
63     // Public variables of the token
64     string public name;
65     string public symbol;
66     uint8 public decimals = 8;
67     // 8 decimals is the strongly suggested default, avoid changing it
68     uint256 public totalSupply;
69 
70     // This creates an array with all balances
71     mapping (address => uint256) public balanceOf;
72     mapping (address => mapping (address => uint256)) public allowance;
73 
74     // This generates a public event on the blockchain that will notify clients
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     // This notifies clients about the amount burnt
78     event Burn(address indexed from, uint256 value);
79 
80     /**
81      * Constructor function
82      *
83      * Initializes contract with initial supply tokens to the creator of the contract
84      */
85     constructor (
86         uint256 initialSupply,
87         string tokenName,
88         string tokenSymbol
89     ) public {
90         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
91         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
92         name = tokenName;                                   // Set the name for display purposes
93         symbol = tokenSymbol;                               // Set the symbol for display purposes
94     }
95 
96     /**
97      * Internal transfer, only can be called by this contract
98      */
99     function _transfer(address _from, address _to, uint _value) internal {
100         // Prevent transfer to 0x0 address. Use burn() instead
101         require(_to != 0x0);
102         // Check if the sender has enough
103         require(balanceOf[_from] >= _value);
104         // Check for overflows
105         require(balanceOf[_to] + _value >= balanceOf[_to]);
106         // Save this for an assertion in the future
107         uint previousBalances = balanceOf[_from] + balanceOf[_to];
108         // Subtract from the sender
109         balanceOf[_from] -= _value;
110         // Add the same to the recipient
111         balanceOf[_to] += _value;
112         emit Transfer(_from, _to, _value);
113         // Asserts are used to use static analysis to find bugs in your code. They should never fail
114         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
115     }
116 
117     /**
118      * Transfer tokens
119      *
120      * Send `_value` tokens to `_to` from your account
121      *
122      * @param _to The address of the recipient
123      * @param _value the amount to send
124      */
125     function transfer(address _to, uint256 _value) public {
126         _transfer(msg.sender, _to, _value);
127     }
128 
129     /**
130      * Transfer tokens from other address
131      *
132      * Send `_value` tokens to `_to` on behalf of `_from`
133      *
134      * @param _from The address of the sender
135      * @param _to The address of the recipient
136      * @param _value the amount to send
137      */
138     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
139         require(_value <= allowance[_from][msg.sender]);     // Check allowance
140         allowance[_from][msg.sender] -= _value;
141         _transfer(_from, _to, _value);
142         return true;
143     }
144 
145     /**
146      * Set allowance for other address
147      *
148      * Allows `_spender` to spend no more than `_value` tokens on your behalf
149      *
150      * @param _spender The address authorized to spend
151      * @param _value the max amount they can spend
152      */
153     function approve(address _spender, uint256 _value) public
154         returns (bool success) {
155         allowance[msg.sender][_spender] = _value;
156         return true;
157     }
158 
159     /**
160      * Set allowance for other address and notify
161      *
162      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
163      *
164      * @param _spender The address authorized to spend
165      * @param _value the max amount they can spend
166      * @param _extraData some extra information to send to the approved contract
167      */
168     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
169         public
170         returns (bool success) {
171         tokenRecipient spender = tokenRecipient(_spender);
172         if (approve(_spender, _value)) {
173             spender.receiveApproval(msg.sender, _value, this, _extraData);
174             return true;
175         }
176     }
177 
178     /**
179      * Destroy tokens
180      *
181      * Remove `_value` tokens from the system irreversibly
182      *
183      * @param _value the amount of money to burn
184      */
185     function burn(uint256 _value) public returns (bool success) {
186         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
187         balanceOf[msg.sender] -= _value;            // Subtract from the sender
188         totalSupply -= _value;                      // Updates totalSupply
189         emit Burn(msg.sender, _value);
190         return true;
191     }
192 
193     /**
194      * Destroy tokens from other account
195      *
196      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
197      *
198      * @param _from the address of the sender
199      * @param _value the amount of money to burn
200      */
201     function burnFrom(address _from, uint256 _value) public returns (bool success) {
202         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
203         require(_value <= allowance[_from][msg.sender]);    // Check allowance
204         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
205         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
206         totalSupply -= _value;                              // Update totalSupply
207         emit Burn(_from, _value);
208         return true;
209     }
210 }