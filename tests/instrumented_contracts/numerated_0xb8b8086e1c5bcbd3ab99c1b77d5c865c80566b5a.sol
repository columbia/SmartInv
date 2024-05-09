1 /**
2 * From Ethereum Gold initial
3 * copyleft 2019
4 *
5 */
6 
7 pragma solidity >=0.4.22 <0.6.0;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   /**
38   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 /**
56  * The owned contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of user permissions.
58  */
59 contract owned {
60     address public owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     /**
69      * Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77      * Allows the current owner to transfer control of the contract to a newOwner.
78      * NewOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) onlyOwner public {
81         require(newOwner != address(0));
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84     }
85 }
86 
87 /**
88 * Interface provided to external calls.
89 */
90 interface tokenRecipient {
91     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
92 }
93 
94 contract TokenERC20 {
95 
96    //Multi-trans need to be added
97 
98 	using SafeMath for uint256;
99 		
100     // Public variables of the token
101     string public name;
102     string public symbol;
103     uint8 public decimals = 8;
104     // 18 decimals is the strongly suggested default, avoid changing it
105     
106     uint256 public totalSupply;
107 
108     // Contract generation time
109     uint public timeBegin;
110 
111     // This creates an array with all balances
112     mapping (address => uint256) public balanceOf;
113     mapping (address => mapping (address => uint256)) public allowance;
114 
115     // This generates a public event on the blockchain that will notify clients
116     event Transfer(address indexed from, address indexed to, uint256 value);
117     
118     // This generates a public event on the blockchain that will notify clients
119     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
120 
121     /**
122      * Initializes contract with initial supply tokens to the creator of the contract.
123      */
124     constructor(
125         uint256 initialSupply,
126         string memory tokenName,
127         string memory tokenSymbol
128     ) public {
129         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
130         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
131         name = tokenName;                                       // Set the name for display purposes
132         symbol = tokenSymbol;                                   // Set the symbol for display purposes
133     }
134 
135     /**
136      * Internal transfer, only can be called by this contract.
137      */
138     function _transfer(address _from, address _to, uint256 _value) internal {
139         // Prevent transfer to 0x0 address. Use burn() instead
140         require(_to != address(0x0));
141         // Check if the sender has enough
142         require(balanceOf[_from] >= _value);
143         // Check for overflows
144         require(balanceOf[_to] + _value > balanceOf[_to]);
145         // Save this for an assertion in the future
146         uint previousBalances = balanceOf[_from] + balanceOf[_to];
147         // Subtract from the sender
148         balanceOf[_from] -= _value;
149         // Add the same to the recipient
150         balanceOf[_to] += _value;
151         emit Transfer(_from, _to, _value);
152         // Asserts are used to use static analysis to find bugs in your code. They should never fail
153         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
154     }
155 
156     /**
157      * Transfer tokens
158      * Send `_value` tokens to `_to` from your account.
159      */
160     function transfer(address _to, uint256 _value) public returns (bool success) {
161         _transfer(msg.sender, _to, _value);
162         return true;
163     }
164 
165     /**
166      * Transfer tokens from other address
167      * Send `_value` tokens to `_to` in behalf of `_from`.
168      */
169     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
170         require(_value <= allowance[_from][msg.sender]);     // Check allowance
171         allowance[_from][msg.sender] -= _value;
172         _transfer(_from, _to, _value);
173         return true;
174     }
175 
176     /**
177      * Set allowance for other address
178      * Allows `_spender` to spend no more than `_value` tokens in your behalf.
179      */
180     function approve(address _spender, uint256 _value) public
181         returns (bool success) {
182         allowance[msg.sender][_spender] = _value;
183         emit Approval(msg.sender, _spender, _value);
184         return true;
185     }
186 
187     /**
188      * Set allowance for other address and notify
189      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it.
190      */
191     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
192         public
193         returns (bool success) {
194         tokenRecipient spender = tokenRecipient(_spender);
195         if (approve(_spender, _value)) {
196             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
197             return true;
198         }
199     }
200 
201     /**
202      * Allows callers to bulk transfer tokens.
203      */
204     function batch(address []toAddr, uint256 []value) public returns (bool){
205         require(toAddr.length == value.length && toAddr.length >= 1);
206         for(uint256 i = 0 ; i < toAddr.length; i++){
207             transfer(toAddr[i], value[i]);
208         }
209     }
210 
211 }