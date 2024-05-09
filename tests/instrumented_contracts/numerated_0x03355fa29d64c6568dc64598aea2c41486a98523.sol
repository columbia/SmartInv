1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two numbers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0); // Solidity only automatically asserts when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49     * @dev Adds two numbers, reverts on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60     * reverts when dividing by zero.
61     */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 contract BTYYToken {
69     using SafeMath for uint256;
70     // Public variables of the token
71     string public name;
72     string public symbol;
73     uint8 public decimals = 6;
74     // 8 decimals is the strongly suggested default, avoid changing it
75     uint256 public totalSupply;
76 
77     // This creates an array with all balances
78     mapping (address => uint256) public balanceOf;
79     mapping (address => mapping (address => uint256)) public allowance;
80 
81     // This generates a public event on the blockchain that will notify clients
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     // This notifies clients about the amount burnt
85     event Burn(address indexed from, uint256 value);
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 
88     /**
89      * Constructor function
90      *
91      * Initializes contract with initial supply tokens to the creator of the contract
92      */
93     constructor (
94         uint256 initialSupply,
95         string tokenName,
96         string tokenSymbol
97     ) public {
98         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
99         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
100         name = tokenName;                                   // Set the name for display purposes
101         symbol = tokenSymbol;                               // Set the symbol for display purposes
102     }
103 
104     /**
105      * Internal transfer, only can be called by this contract
106      */
107     function _transfer(address _from, address _to, uint256 _value) internal {
108         // Prevent transfer to 0x0 address. Use burn() instead
109         require(_to != address(0));
110         // Check if the sender has enough
111         require(balanceOf[_from] >= _value);
112         // Check for overflows
113         require(balanceOf[_to].add(_value) >= balanceOf[_to]);
114         // Save this for an assertion in the future
115         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
116         // Subtract from the sender
117         balanceOf[_from] = balanceOf[_from].sub(_value);
118         // Add the same to the recipient
119         balanceOf[_to] = balanceOf[_to].add(_value);
120         emit Transfer(_from, _to, _value);
121         // Asserts are used to use static analysis to find bugs in your code. They should never fail
122         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
123     }
124 
125     /**
126      * Transfer tokens
127      *
128      * Send `_value` tokens to `_to` from your account
129      *
130      * @param _to The address of the recipient
131      * @param _value the amount to send
132      */
133     function transfer(address _to, uint256 _value) public returns (bool) {
134         _transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138     /**
139      * Transfer tokens from other address
140      *
141      * Send `_value` tokens to `_to` on behalf of `_from`
142      *
143      * @param _from The address of the sender
144      * @param _to The address of the recipient
145      * @param _value the amount to send
146      */
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148         require(_value <= allowance[_from][msg.sender]);     // Check allowance
149         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
150         _transfer(_from, _to, _value);
151         return true;
152     }
153 
154     /**
155      * Set allowance for other address
156      *
157      * Allows `_spender` to spend no more than `_value` tokens on your behalf
158      *
159      * @param _spender The address authorized to spend
160      * @param _value the max amount they can spend
161      */
162     function approve(address _spender, uint256 _value) public returns (bool) {
163         require(_spender != address(0));
164         allowance[msg.sender][_spender] = _value;
165         emit Approval(msg.sender, _spender, _value);
166         return true;
167     }
168 
169     /**
170      * Set allowance for other address and notify
171      *
172      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
173      *
174      * @param _spender The address authorized to spend
175      * @param _value the max amount they can spend
176      * @param _extraData some extra information to send to the approved contract
177      */
178     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
179         public
180         returns (bool) {
181         tokenRecipient spender = tokenRecipient(_spender);
182         if (approve(_spender, _value)) {
183             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
184             return true;
185         }
186     }
187 
188     /**
189      * Destroy tokens
190      *
191      * Remove `_value` tokens from the system irreversibly
192      *
193      * @param _value the amount of money to burn
194      */
195     function burn(uint256 _value) public returns (bool) {
196         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
197         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
198         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
199         emit Burn(msg.sender, _value);
200         return true;
201     }
202 
203     /**
204      * Destroy tokens from other account
205      *
206      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
207      *
208      * @param _from the address of the sender
209      * @param _value the amount of money to burn
210      */
211     function burnFrom(address _from, uint256 _value) public returns (bool) {
212         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
213         require(_value <= allowance[_from][msg.sender]);    // Check allowance
214         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
215         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
216         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
217         emit Burn(_from, _value);
218         return true;
219     }
220 }