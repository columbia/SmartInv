1 pragma solidity ^0.5.1;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18     // benefit is lost if 'b' is also tested.
19     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20     if (a == 0) {
21       return 0;
22     }
23 
24     c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     // uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return a / b;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51     c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 contract SOContract {
58     // Public variables of the token
59     string public name;
60     string public symbol;
61     uint8 public decimals = 18;
62     // 18 decimals is the strongly suggested default, avoid changing it
63     uint256 public totalSupply;
64 
65     // This creates an array with all balances
66     mapping (address => uint256) public balanceOf;
67     mapping (address => mapping (address => uint256)) public allowed;
68 
69     // This generates a public event on the blockchain that will notify clients
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
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
92     function _transfer(address _from, address _to, uint256 _value) internal {
93         // Prevent transfer to 0x0 address. Use burn() instead
94         require(_to != address(0x0));
95         // Check if the sender has enough
96         require(balanceOf[_from] >= _value);
97         // Check for overflows
98         require(balanceOf[_to] + _value >= balanceOf[_to]);
99         // Save this for an assertion in the future
100         uint previousBalances = balanceOf[_from] + balanceOf[_to];
101         // Subtract from the sender
102         balanceOf[_from] -= _value;
103         // Add the same to the recipient
104         balanceOf[_to] += _value;
105         emit Transfer(_from, _to, _value);
106         // Asserts are used to use static analysis to find bugs in your code. They should never fail
107         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
133         require(_value <= allowed[_from][msg.sender]);     // Check allowance
134         allowed[_from][msg.sender] -= _value;
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
147     function approve(address _spender, uint256 _value) public returns (bool success) {
148         allowed[msg.sender][_spender] = _value;
149         emit Approval(msg.sender, _spender, _value); 
150         return true;
151     }
152 
153     /**
154      * IncreaseApproval
155      *
156      * @param _spender The address authorized to spend
157      * @param _addedValue the added amount
158      */
159     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender],_addedValue);
161         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163     }
164 
165     /**
166      * DecreaseApproval
167      *
168      * @param _spender The address authorized to spend
169      * @param _subtractedValue the subtracted amount
170      */
171     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
172         uint oldValue = allowed[msg.sender][_spender];
173         if (_subtractedValue > oldValue) {
174             allowed[msg.sender][_spender] = 0;
175         } else {
176             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
177         }
178         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179         return true;
180     }
181 
182     /**
183      * Get allowance 
184      *
185      */
186     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
187         return allowed[_owner][_spender];
188     }
189 
190     /**
191      * Set allowance for other address and notify
192      *
193      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
194      *
195      * @param _spender The address authorized to spend
196      * @param _value the max amount they can spend
197      * @param _extraData some extra information to send to the approved contract
198      */
199     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
200         tokenRecipient spender = tokenRecipient(_spender);
201         if (approve(_spender, _value)) {
202             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
203             return true;
204         }
205     }
206 }