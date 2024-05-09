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
61 contract SpecialDrawingRight {
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
79 	event Approval(address indexed owner, address indexed spender, uint256 value);
80 
81     /**
82      * Constructor function
83      *
84      * Initializes contract with initial supply tokens to the creator of the contract
85      */
86     constructor (
87         uint256 initialSupply,
88         string tokenName,
89         string tokenSymbol
90     ) public {
91         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
92         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
93         name = tokenName;                                   // Set the name for display purposes
94         symbol = tokenSymbol;                               // Set the symbol for display purposes
95     }
96 
97     /**
98      * Internal transfer, only can be called by this contract
99      */
100     function _transfer(address _from, address _to, uint _value) internal {
101         // Prevent transfer to 0x0 address. Use burn() instead
102         require(_to != 0x0);
103         // Check if the sender has enough
104         require(balanceOf[_from] >= _value);
105         // Check for overflows
106         require(balanceOf[_to] + _value >= balanceOf[_to]);
107         // Save this for an assertion in the future
108         uint previousBalances = balanceOf[_from] + balanceOf[_to];
109         // Subtract from the sender
110         balanceOf[_from] -= _value;
111         // Add the same to the recipient
112         balanceOf[_to] += _value;
113         emit Transfer(_from, _to, _value);
114         // Asserts are used to use static analysis to find bugs in your code. They should never fail
115         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
116     }
117 
118     /**
119      * Transfer tokens
120      *
121      * Send `_value` tokens to `_to` from your account
122      *
123      * @param _to The address of the recipient
124      * @param _value the amount to send
125      */
126     function transfer(address _to, uint256 _value) public {
127         _transfer(msg.sender, _to, _value);
128     }
129 
130     /**
131      * Transfer tokens from other address
132      *
133      * Send `_value` tokens to `_to` on behalf of `_from`
134      *
135      * @param _from The address of the sender
136      * @param _to The address of the recipient
137      * @param _value the amount to send
138      */
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
140         require(_value <= allowance[_from][msg.sender]);     // Check allowance
141         allowance[_from][msg.sender] -= _value;
142         _transfer(_from, _to, _value);
143         return true;
144     }
145 
146     /**
147      * Set allowance for other address
148      *
149      * Allows `_spender` to spend no more than `_value` tokens on your behalf
150      *
151      * @param _spender The address authorized to spend
152      * @param _value the max amount they can spend
153      */
154     function approve(address _spender, uint256 _value) public
155         returns (bool success) {
156         allowance[msg.sender][_spender] = _value;
157 		emit Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     /**
162      * Set allowance for other address and notify
163      *
164      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
165      *
166      * @param _spender The address authorized to spend
167      * @param _value the max amount they can spend
168      * @param _extraData some extra information to send to the approved contract
169      */
170     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
171         public
172         returns (bool success) {
173         tokenRecipient spender = tokenRecipient(_spender);
174         if (approve(_spender, _value)) {
175             spender.receiveApproval(msg.sender, _value, this, _extraData);
176             return true;
177         }
178     }
179 
180     /**
181      * Destroy tokens
182      *
183      * Remove `_value` tokens from the system irreversibly
184      *
185      * @param _value the amount of money to burn
186      */
187     function burn(uint256 _value) public returns (bool success) {
188         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
189         balanceOf[msg.sender] -= _value;            // Subtract from the sender
190         totalSupply -= _value;                      // Updates totalSupply
191         emit Burn(msg.sender, _value);
192         return true;
193     }
194 
195     /**
196      * Destroy tokens from other account
197      *
198      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
199      *
200      * @param _from the address of the sender
201      * @param _value the amount of money to burn
202      */
203     function burnFrom(address _from, uint256 _value) public returns (bool success) {
204         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
205         require(_value <= allowance[_from][msg.sender]);    // Check allowance
206         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
207         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
208         totalSupply -= _value;                              // Update totalSupply
209         emit Burn(_from, _value);
210         return true;
211     }
212 }