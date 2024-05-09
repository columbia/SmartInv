1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * This contract is modified by Jinlicoin Team. 
5  */
6 
7 
8 interface tokenRecipient {
9     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
10 }
11 /**
12  * @title SafeMath
13  * @dev Unsigned math operations with safety checks that revert on error
14  */
15 library SafeMath {
16     /**
17      * @dev Multiplies two unsigned integers, reverts on overflow.
18      */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
21         // benefit is lost if 'b' is also tested.
22         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b);
29 
30         return c;
31     }
32 
33     /**
34      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
35      */
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Solidity only automatically asserts when dividing by 0
38         require(b > 0);
39         uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 
42         return c;
43     }
44 
45     /**
46      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         require(b <= a);
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     /**
56      * @dev Adds two unsigned integers, reverts on overflow.
57      */
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a);
61 
62         return c;
63     }
64 
65     /**
66      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
67      * reverts when dividing by zero.
68      */
69     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b != 0);
71         return a % b;
72     }
73 }
74 contract Jinlicoin {
75     // Public variables of the token
76     string public name;
77     string public symbol;
78     uint8 public decimals = 18;
79     // 18 decimals is the strongly suggested default, avoid changing it
80     uint256 public totalSupply;
81     
82     using SafeMath for uint256; // using safemath to protect the contract 
83 
84     // This creates an array with all balances
85     mapping (address => uint256) public balanceOf;
86     mapping (address => mapping (address => uint256)) public allowance;
87 
88     // This generates a public event on the blockchain that will notify clients
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     // This generates a public event on the blockchain that will notify clients
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 
94     // This notifies clients about the amount burnt
95     event Burn(address indexed from, uint256 value);
96 
97     /**
98      * Constructor function
99      *
100      * Initializes contract with initial supply tokens to the creator of the contract
101      */
102     constructor(
103         uint256 initialSupply,
104         string memory tokenName,
105         string memory tokenSymbol
106     ) public {
107         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
108         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
109         name = tokenName;                                   // Set the name for display purposes
110         symbol = tokenSymbol;                               // Set the symbol for display purposes
111     }
112 
113     /**
114      * Internal transfer, only can be called by this contract
115      */
116     function _transfer(address _from, address _to, uint _value) internal {
117         // Prevent transfer to 0x0 address. Use burn() instead
118         require(_to != address(0x0));
119         // Check if the sender has enough
120         require(balanceOf[_from] >= _value);
121         // Check for overflows
122         require(balanceOf[_to] + _value >= balanceOf[_to]);
123         // Save this for an assertion in the future
124         uint previousBalances = balanceOf[_from] + balanceOf[_to];
125         // Subtract from the sender
126         balanceOf[_from] -= _value;
127         // Add the same to the recipient
128         balanceOf[_to] += _value;
129         emit Transfer(_from, _to, _value);
130         // Asserts are used to use static analysis to find bugs in your code. They should never fail
131         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
132     }
133 
134     /**
135      * Transfer tokens
136      *
137      * Send `_value` tokens to `_to` from your account
138      *
139      * @param _to The address of the recipient
140      * @param _value the amount to send
141      */
142     function transfer(address _to, uint256 _value) public returns (bool success) {
143         _transfer(msg.sender, _to, _value);
144         return true;
145     }
146 
147     /**
148      * Transfer tokens from other address
149      *
150      * Send `_value` tokens to `_to` on behalf of `_from`
151      *
152      * @param _from The address of the sender
153      * @param _to The address of the recipient
154      * @param _value the amount to send
155      */
156     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
157         require(_value <= allowance[_from][msg.sender]);     // Check allowance
158         allowance[_from][msg.sender] -= _value;
159         _transfer(_from, _to, _value);
160         return true;
161     }
162 
163     /**
164      * Set allowance for other address
165      *
166      * Allows `_spender` to spend no more than `_value` tokens on your behalf
167      *
168      * @param _spender The address authorized to spend
169      * @param _value the max amount they can spend
170      */
171     function approve(address _spender, uint256 _value) public
172         returns (bool success) {
173         allowance[msg.sender][_spender] = _value;
174         emit Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /**
179      * Set allowance for other address and notify
180      *
181      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
182      *
183      * @param _spender The address authorized to spend
184      * @param _value the max amount they can spend
185      * @param _extraData some extra information to send to the approved contract
186      */
187     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
188         public
189         returns (bool success) {
190         tokenRecipient spender = tokenRecipient(_spender);
191         if (approve(_spender, _value)) {
192             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
193             return true;
194         }
195     }
196 
197     /**
198      * Destroy tokens
199      *
200      * Remove `_value` tokens from the system irreversibly
201      *
202      * @param _value the amount of money to burn
203      */
204     function burn(uint256 _value) public returns (bool success) {
205         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
206         balanceOf[msg.sender] -= _value;            // Subtract from the sender
207         totalSupply -= _value;                      // Updates totalSupply
208         emit Burn(msg.sender, _value);
209         return true;
210     }
211 
212     /**
213      * Destroy tokens from other account
214      *
215      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
216      *
217      * @param _from the address of the sender
218      * @param _value the amount of money to burn
219      */
220     function burnFrom(address _from, uint256 _value) public returns (bool success) {
221         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
222         require(_value <= allowance[_from][msg.sender]);    // Check allowance
223         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
224         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
225         totalSupply -= _value;                              // Update totalSupply
226         emit Burn(_from, _value);
227         return true;
228     }
229 }