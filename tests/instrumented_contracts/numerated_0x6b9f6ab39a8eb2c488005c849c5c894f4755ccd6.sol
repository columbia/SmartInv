1 pragma solidity ^0.5.2;
2 /* version:0.5.7+commit.6da8b019.Emscripten.clang */
3 
4 library SafeMath {
5     /**
6      * @dev Multiplies two unsigned integers, reverts on overflow.
7      */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (a == 0) {
13             return 0;
14         }
15 
16         uint256 c = a * b;
17         require(c / a == b);
18 
19         return c;
20     }
21 
22     /**
23      * 
24      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
25      */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Solidity only automatically asserts when dividing by 0
28         require(b > 0);
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31 
32         return c;
33     }
34 
35     /**
36      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37      */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a);
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     /**
46      * @dev Adds two unsigned integers, reverts on overflow.
47      */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a);
51 
52         return c;
53     }
54 
55     /**
56      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
57      * reverts when dividing by zero.
58      */
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b != 0);
61         return a % b;
62     }
63 }
64 
65 
66 
67 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
68 
69 contract TokenERC20 {
70     // Public variables of the token
71     string public name;
72     string public symbol;
73     uint8 public decimals=18;
74     // 18 decimals is the strongly suggested default, avoid changing it
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
86 
87     /**
88      * Constructor function
89      *
90      * Initializes contract with initial supply tokens to the creator of the contract
91      */
92     constructor() public
93     {
94         uint256 initialSupply =6000000000;
95         string memory tokenName ="Companion Pet Coin";
96         string memory tokenSymbol="CPC";
97    
98         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
99         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
100         name = tokenName;                                   // Set the name for display purposes
101         symbol = tokenSymbol;                               // Set the symbol for display purposes
102     }
103 
104     /**
105      * Internal transfer, only can be called by this contract
106      */
107     function _transfer(address _from, address _to, uint _value) internal {
108         // Prevent transfer to 0x0 address. Use burn() instead
109         require(_to != address(0));
110         // Check if the sender has enough
111         require(balanceOf[_from] >= _value);
112         // Check for overflows
113         require(balanceOf[_to] + _value >= balanceOf[_to]);
114         // Save this for an assertion in the future
115         uint previousBalances = balanceOf[_from] + balanceOf[_to];
116         // Subtract from the sender
117         balanceOf[_from] -= _value;
118         // Add the same to the recipient
119         balanceOf[_to] += _value;
120         emit Transfer(_from, _to, _value);
121         // Asserts are used to use static analysis to find bugs in your code. They should never fail
122         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
133     function transfer(address _to, uint256 _value) public {
134         _transfer(msg.sender, _to, _value);
135     }
136 
137     /**
138      * Transfer tokens from other address
139      *
140      * Send `_value` tokens to `_to` on behalf of `_from`
141      *
142      * @param _from The address of the sender
143      * @param _to The address of the recipient
144      * @param _value the amount to send
145      */
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
147         require(_value <= allowance[_from][msg.sender]);     // Check allowance
148         allowance[_from][msg.sender] -= _value;
149         _transfer(_from, _to, _value);
150         return true;
151     }
152 
153     /**
154      * Set allowance for other address
155      *
156      * Allows `_spender` to spend no more than `_value` tokens on your behalf
157      *
158      * @param _spender The address authorized to spend
159      * @param _value the max amount they can spend
160      */
161     function approve(address _spender, uint256 _value) public
162         returns (bool success) {
163         allowance[msg.sender][_spender] = _value;
164         return true;
165     }
166 
167     /**
168      * Set allowance for other address and notify
169      *
170      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
171      *
172      * @param _spender The address authorized to spend
173      * @param _value the max amount they can spend
174      * @param _extraData some extra information to send to the approved contract
175      */
176     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
177         public
178         returns (bool success) {
179         tokenRecipient spender = tokenRecipient(_spender);
180         if (approve(_spender, _value)) {
181             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
182             return true;
183         }
184     }
185 
186     /**
187      * Destroy tokens
188      *
189      * Remove `_value` tokens from the system irreversibly
190      *
191      * @param _value the amount of money to burn
192      */
193     function burn(uint256 _value) public returns (bool success) {
194         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
195         balanceOf[msg.sender] -= _value;            // Subtract from the sender
196         totalSupply -= _value;                      // Updates totalSupply
197         emit Burn(msg.sender, _value);
198         return true;
199     }
200 
201     /**
202      * Destroy tokens from other account
203      *
204      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
205      *
206      * @param _from the address of the sender
207      * @param _value the amount of money to burn
208      */
209     function burnFrom(address _from, uint256 _value) public returns (bool success) {
210         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
211         require(_value <= allowance[_from][msg.sender]);    // Check allowance
212         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
213         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
214         totalSupply -= _value;                              // Update totalSupply
215         emit Burn(_from, _value);
216         return true;
217     }
218 }