1 pragma solidity ^0.5.2;
2 
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
23      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
24      */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Solidity only automatically asserts when dividing by 0
27         require(b > 0);
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30 
31         return c;
32     }
33 
34     /**
35      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36      */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b <= a);
39         uint256 c = a - b;
40 
41         return c;
42     }
43 
44     /**
45      * @dev Adds two unsigned integers, reverts on overflow.
46      */
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a);
50 
51         return c;
52     }
53 
54     /**
55      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
56      * reverts when dividing by zero.
57      */
58     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b != 0);
60         return a % b;
61     }
62 }
63 
64 
65 
66 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
67 
68 contract TokenERC20 {
69     // Public variables of the token
70     string public name;
71     string public symbol;
72     uint8 public decimals=18;
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
83     // This notifies clients about the amount burnt
84     event Burn(address indexed from, uint256 value);
85 
86     /**
87      * Constructor function
88      *
89      * Initializes contract with initial supply tokens to the creator of the contract
90      */
91     constructor() public
92     {
93         uint256 initialSupply =5500000000;
94         string memory tokenName ="GOLDS eXchange Coin";
95         string memory tokenSymbol="GOLDSX";
96    
97         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
98         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
99         name = tokenName;                                   // Set the name for display purposes
100         symbol = tokenSymbol;                               // Set the symbol for display purposes
101     }
102 
103     /**
104      * Internal transfer, only can be called by this contract
105      */
106     function _transfer(address _from, address _to, uint _value) internal {
107         // Prevent transfer to 0x0 address. Use burn() instead
108         require(_to != address(0));
109         // Check if the sender has enough
110         require(balanceOf[_from] >= _value);
111         // Check for overflows
112         require(balanceOf[_to] + _value >= balanceOf[_to]);
113         // Save this for an assertion in the future
114         uint previousBalances = balanceOf[_from] + balanceOf[_to];
115         // Subtract from the sender
116         balanceOf[_from] -= _value;
117         // Add the same to the recipient
118         balanceOf[_to] += _value;
119         emit Transfer(_from, _to, _value);
120         // Asserts are used to use static analysis to find bugs in your code. They should never fail
121         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
122     }
123 
124     /**
125      * Transfer tokens
126      *
127      * Send `_value` tokens to `_to` from your account
128      *
129      * @param _to The address of the recipient
130      * @param _value the amount to send
131      */
132     function transfer(address _to, uint256 _value) public {
133         _transfer(msg.sender, _to, _value);
134     }
135 
136     /**
137      * Transfer tokens from other address
138      *
139      * Send `_value` tokens to `_to` on behalf of `_from`
140      *
141      * @param _from The address of the sender
142      * @param _to The address of the recipient
143      * @param _value the amount to send
144      */
145     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
146         require(_value <= allowance[_from][msg.sender]);     // Check allowance
147         allowance[_from][msg.sender] -= _value;
148         _transfer(_from, _to, _value);
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address
154      *
155      * Allows `_spender` to spend no more than `_value` tokens on your behalf
156      *
157      * @param _spender The address authorized to spend
158      * @param _value the max amount they can spend
159      */
160     function approve(address _spender, uint256 _value) public
161         returns (bool success) {
162         allowance[msg.sender][_spender] = _value;
163         return true;
164     }
165 
166     /**
167      * Set allowance for other address and notify
168      *
169      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
170      *
171      * @param _spender The address authorized to spend
172      * @param _value the max amount they can spend
173      * @param _extraData some extra information to send to the approved contract
174      */
175     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
176         public
177         returns (bool success) {
178         tokenRecipient spender = tokenRecipient(_spender);
179         if (approve(_spender, _value)) {
180             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
181             return true;
182         }
183     }
184 
185     /**
186      * Destroy tokens
187      *
188      * Remove `_value` tokens from the system irreversibly
189      *
190      * @param _value the amount of money to burn
191      */
192     function burn(uint256 _value) public returns (bool success) {
193         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
194         balanceOf[msg.sender] -= _value;            // Subtract from the sender
195         totalSupply -= _value;                      // Updates totalSupply
196         emit Burn(msg.sender, _value);
197         return true;
198     }
199 
200     /**
201      * Destroy tokens from other account
202      *
203      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
204      *
205      * @param _from the address of the sender
206      * @param _value the amount of money to burn
207      */
208     function burnFrom(address _from, uint256 _value) public returns (bool success) {
209         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
210         require(_value <= allowance[_from][msg.sender]);    // Check allowance
211         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
212         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
213         totalSupply -= _value;                              // Update totalSupply
214         emit Burn(_from, _value);
215         return true;
216     }
217 }