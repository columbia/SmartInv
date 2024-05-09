1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     require(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // require(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // require(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     require(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     require(c >= a);
46     return c;
47   }
48 }
49 
50 
51 contract TokenERC20 {
52     using SafeMath for uint256;
53     // Public variables of the token
54     string public name;
55     string public symbol;
56     uint8 public decimals = 18;
57     // 18 decimals is the strongly suggested default, avoid changing it
58     uint256 public totalSupply;
59 
60     // This creates an array with all balances
61     mapping (address => uint256) public balanceOf;
62     mapping (address => mapping (address => uint256)) public allowance;
63 
64     // This generates a public event on the blockchain that will notify clients
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     
67     // This generates a public event on the blockchain that will notify clients
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 
70     // This notifies clients about the amount burnt
71     event Burn(address indexed from, uint256 value);
72 
73     /**
74      * Constructor function
75      *
76      * Initializes contract with initial supply tokens to the creator of the contract
77      */
78     constructor(
79         uint256 initialSupply,
80         string memory tokenName,
81         string memory tokenSymbol
82     ) public {
83         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
84         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
85         name = tokenName;                                   // Set the name for display purposes
86         symbol = tokenSymbol;                               // Set the symbol for display purposes
87     }
88 
89     /**
90      * Internal transfer, only can be called by this contract
91      */
92     function _transfer(address _from, address _to, uint _value) internal {
93         // Prevent transfer to 0x0 address. Use burn() instead
94         require(_to != address(0x0));
95         // Check if the sender has enough
96         require(balanceOf[_from] >= _value);
97         // Check for overflows
98         require(balanceOf[_to].add(_value) > balanceOf[_to]);
99         // Save this for an requireion in the future
100         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
101         // Subtract from the sender
102         balanceOf[_from] = balanceOf[_from].sub(_value);
103         // Add the same to the recipient
104         balanceOf[_to] = balanceOf[_to].add(_value);
105         emit Transfer(_from, _to, _value);
106         // requires are used to use static analysis to find bugs in your code. They should never fail
107         require(balanceOf[_from] + balanceOf[_to] == previousBalances);
108     }
109 
110     /**
111      * Transfer tokens
112      *
113      * Send `_value` tokens to `_to` from your account
114      *
115      * @param _to The address of the recipient
116      * @param _value the amount to send
117      */
118     function transfer(address _to, uint256 _value) public returns (bool success) {
119         _transfer(msg.sender, _to, _value);
120         return true;
121     }
122 
123     /**
124      * Transfer tokens from other address
125      *
126      * Send `_value` tokens to `_to` on behalf of `_from`
127      *
128      * @param _from The address of the sender
129      * @param _to The address of the recipient
130      * @param _value the amount to send
131      */
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
133         require(_value <= allowance[_from][msg.sender]);     // Check allowance
134         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
135         _transfer(_from, _to, _value);
136         return true;
137     }
138 
139     /**
140      * Set allowance for other address
141      *
142      * Allows `_spender` to spend no more than `_value` tokens on your behalf
143      *
144      * @param _spender The address authorized to spend
145      * @param _value the max amount they can spend
146      */
147     function approve(address _spender, uint256 _value) public
148         returns (bool success) {
149         allowance[msg.sender][_spender] = _value;
150         emit Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     /**
155      * Set allowance for other address and notify
156      *
157      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
158      *
159      * @param _spender The address authorized to spend
160      * @param _value the max amount they can spend
161      * @param _extraData some extra information to send to the approved contract
162      */
163     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
164         public
165         returns (bool success) {
166         tokenRecipient spender = tokenRecipient(_spender);
167         if (approve(_spender, _value)) {
168             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
169             return true;
170         }
171     }
172 
173     /**
174      * Destroy tokens
175      *
176      * Remove `_value` tokens from the system irreversibly
177      *
178      * @param _value the amount of money to burn
179      */
180     function burn(uint256 _value) public returns (bool success) {
181         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
182         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
183         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
184         emit Burn(msg.sender, _value);
185         return true;
186     }
187 
188     /**
189      * Destroy tokens from other account
190      *
191      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
192      *
193      * @param _from the address of the sender
194      * @param _value the amount of money to burn
195      */
196     function burnFrom(address _from, uint256 _value) public returns (bool success) {
197         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
198         require(_value <= allowance[_from][msg.sender]);    // Check allowance
199         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
200         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
201         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
202         emit Burn(_from, _value);
203         return true;
204     }
205 }