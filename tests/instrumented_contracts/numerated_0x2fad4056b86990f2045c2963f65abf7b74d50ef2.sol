1 pragma solidity >=0.4.22 <0.6.0;
2 
3 
4 
5 library SafeMath {
6     /**
7      * @dev Multiplies two unsigned integers, reverts on overflow.
8      */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11         // benefit is lost if 'b' is also tested.
12         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13         if (a == 0) {
14             return 0;
15         }
16 
17         uint256 c = a * b;
18         require(c / a == b, "SafeMath: multiplication overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
25      */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Solidity only automatically asserts when dividing by 0
28         require(b > 0, "SafeMath: division by zero");
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
39         require(b <= a, "SafeMath: subtraction overflow");
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
50         require(c >= a, "SafeMath: addition overflow");
51 
52         return c;
53     }
54 
55     /**
56      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
57      * reverts when dividing by zero.
58      */
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b != 0, "SafeMath: modulo by zero");
61         return a % b;
62     }
63 }
64 
65 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
66 
67 contract TokenERC20 {
68     using SafeMath for uint256;
69     // Public variables of the token
70     string public name;
71     string public symbol;
72     uint8 public decimals = 18;
73     // 18 decimals is the strongly suggested default, avoid changing it
74     uint256 public totalSupply;
75 
76     // This creates an array with all balances
77     mapping (address => uint256) public balanceOf;
78     mapping (address => mapping (address => uint256)) public allowance;
79 
80     // This generates a public event on the blockchain that will notify clients
81     event Transfer(address indexed from, address indexed to, uint256 value);
82     
83     // This generates a public event on the blockchain that will notify clients
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 
86     // This notifies clients about the amount burnt
87     event Burn(address indexed from, uint256 value);
88 
89     /**
90      * Constrctor function
91      *
92      * Initializes contract with initial supply tokens to the creator of the contract
93      */
94     constructor(
95         uint256 initialSupply,
96         string memory tokenName,
97         string memory tokenSymbol
98     ) public {
99         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
100         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
101         name = tokenName;                                       // Set the name for display purposes
102         symbol = tokenSymbol;                                   // Set the symbol for display purposes
103     }
104 
105     /**
106      * Internal transfer, only can be called by this contract
107      */
108     function _transfer(address _from, address _to, uint _value) internal {
109         // Prevent transfer to 0x0 address. Use burn() instead
110         require(_to != address(0x0));
111         // Check if the sender has enough
112         require(balanceOf[_from] >= _value);
113         // Check for overflows
114         require(balanceOf[_to] + _value > balanceOf[_to]);
115         // Save this for an assertion in the future
116         uint previousBalances = balanceOf[_from] + balanceOf[_to];
117         // Subtract from the sender
118         balanceOf[_from] = balanceOf[_from].sub(_value);
119         // Add the same to the recipient
120         balanceOf[_to] = balanceOf[_to].add(_value);
121         emit Transfer(_from, _to, _value);
122         // Asserts are used to use static analysis to find bugs in your code. They should never fail
123         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
124     }
125 
126     /**
127      * Transfer tokens
128      *
129      * Send `_value` tokens to `_to` from your account
130      *
131      * @param _to The address of the recipient
132      * @param _value the amount to send
133      */
134     function transfer(address _to, uint256 _value) public returns (bool success) {
135         _transfer(msg.sender, _to, _value);
136         return true;
137     }
138 
139     /**
140      * Transfer tokens from other address
141      *
142      * Send `_value` tokens to `_to` in behalf of `_from`
143      *
144      * @param _from The address of the sender
145      * @param _to The address of the recipient
146      * @param _value the amount to send
147      */
148     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
149         require(_value <= allowance[_from][msg.sender]);     // Check allowance
150         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value) ;
151         _transfer(_from, _to, _value);
152         return true;
153     }
154 
155     /**
156      * Set allowance for other address
157      *
158      * Allows `_spender` to spend no more than `_value` tokens in your behalf
159      *
160      * @param _spender The address authorized to spend
161      * @param _value the max amount they can spend
162      */
163     function approve(address _spender, uint256 _value) public
164         returns (bool success) {
165         allowance[msg.sender][_spender] = _value;
166         emit Approval(msg.sender, _spender, _value);
167         return true;
168     }
169 
170     /**
171      * Set allowance for other address and notify
172      *
173      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
174      *
175      * @param _spender The address authorized to spend
176      * @param _value the max amount they can spend
177      * @param _extraData some extra information to send to the approved contract
178      */
179     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
180         public
181         returns (bool success) {
182         tokenRecipient spender = tokenRecipient(_spender);
183         if (approve(_spender, _value)) {
184             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
185             return true;
186         }
187     }
188 
189     /**
190      * Destroy tokens
191      *
192      * Remove `_value` tokens from the system irreversibly
193      *
194      * @param _value the amount of money to burn
195      */
196     function burn(uint256 _value) public returns (bool success) {
197         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
198         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value) ;            // Subtract from the sender
199         totalSupply = totalSupply.sub(_value) ;                      // Updates totalSupply
200         emit Burn(msg.sender, _value);
201         return true;
202     }
203 
204     /**
205      * Destroy tokens from other account
206      *
207      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
208      *
209      * @param _from the address of the sender
210      * @param _value the amount of money to burn
211      */
212     function burnFrom(address _from, uint256 _value) public returns (bool success) {
213         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
214         require(_value <= allowance[_from][msg.sender]);    // Check allowance
215         balanceOf[_from] = balanceOf[_from].sub(_value) ;                         // Subtract from the targeted balance
216         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value) ;             // Subtract from the sender's allowance
217         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
218         emit Burn(_from, _value);
219         return true;
220     }
221 }