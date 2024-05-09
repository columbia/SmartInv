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
94         // uint256 initialSupply =100000000000;   // for me
95         uint256 initialSupply =100000000000;
96         string memory tokenName ="TREESTAR";   // for me
97         string memory tokenSymbol="TIS";       // for me
98    
99         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
100         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
101         name = tokenName;                                   // Set the name for display purposes
102         symbol = tokenSymbol;                               // Set the symbol for display purposes
103     }
104 
105     /**
106      * Internal transfer, only can be called by this contract
107      */
108     function _transfer(address _from, address _to, uint _value) internal {
109         // Prevent transfer to 0x0 address. Use burn() instead
110         require(_to != address(0));
111         // Check if the sender has enough
112         require(balanceOf[_from] >= _value);
113         // Check for overflows
114         require(balanceOf[_to] + _value >= balanceOf[_to]);
115         // Save this for an assertion in the future
116         uint previousBalances = balanceOf[_from] + balanceOf[_to];
117         // Subtract from the sender
118         balanceOf[_from] -= _value;
119         // Add the same to the recipient
120         balanceOf[_to] += _value;
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
134     function transfer(address _to, uint256 _value) public {
135         _transfer(msg.sender, _to, _value);
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
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
148         require(_value <= allowance[_from][msg.sender]);     // Check allowance
149         allowance[_from][msg.sender] -= _value;
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
162     function approve(address _spender, uint256 _value) public
163         returns (bool success) {
164         allowance[msg.sender][_spender] = _value;
165         return true;
166     }
167 
168     /**
169      * Set allowance for other address and notify
170      *
171      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
172      *
173      * @param _spender The address authorized to spend
174      * @param _value the max amount they can spend
175      * @param _extraData some extra information to send to the approved contract
176      */
177     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
178         public
179         returns (bool success) {
180         tokenRecipient spender = tokenRecipient(_spender);
181         if (approve(_spender, _value)) {
182             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
183             return true;
184         }
185     }
186 
187     /**
188      * Destroy tokens
189      *
190      * Remove `_value` tokens from the system irreversibly
191      *
192      * @param _value the amount of money to burn
193      */
194     function burn(uint256 _value) public returns (bool success) {
195         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
196         balanceOf[msg.sender] -= _value;            // Subtract from the sender
197         totalSupply -= _value;                      // Updates totalSupply
198         emit Burn(msg.sender, _value);
199         return true;
200     }
201 
202     /**
203      * Destroy tokens from other account
204      *
205      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
206      *
207      * @param _from the address of the sender
208      * @param _value the amount of money to burn
209      */
210     function burnFrom(address _from, uint256 _value) public returns (bool success) {
211         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
212         require(_value <= allowance[_from][msg.sender]);    // Check allowance
213         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
214         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
215         totalSupply -= _value;                              // Update totalSupply
216         emit Burn(_from, _value);
217         return true;
218     }
219 }