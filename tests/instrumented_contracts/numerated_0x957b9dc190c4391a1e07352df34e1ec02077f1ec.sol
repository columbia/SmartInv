1 pragma solidity 0.4.19;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 library SafeMath {
21     
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 
46 
47   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
48     return a >= b ? a : b;
49   }
50 
51   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
52     return a < b ? a : b;
53   }
54 
55   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
56     return a >= b ? a : b;
57   }
58 
59   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
60     return a < b ? a : b;
61   }
62 
63 }
64 
65 
66 
67 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes32 _extraData) public; }
68 
69 contract Ferrum is owned{
70     
71     // Public variables of the token
72     bytes32 public name;
73     bytes32 public symbol;
74     uint8 public decimals = 5;
75     uint256 public totalSupply;
76     bool public stopped = false;
77 
78 
79     // This creates an array with all balances
80     mapping (address => uint256) public balanceOf;
81     mapping (address => mapping (address => uint256)) public allowance;
82 
83 
84     modifier isOwner {
85         assert(owner == msg.sender);
86         _;
87     }
88 
89     modifier isRunning {
90         assert (!stopped);
91         _;
92     }
93 
94     modifier validAddress {
95         assert(0x0 != msg.sender);
96         _;
97     }
98 
99 
100 
101     // This generates a public event on the blockchain that will notify clients
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     // This notifies clients about the amount burnt
105 
106     /**
107      * Constrctor function
108      *
109      * Initializes contract with initial supply tokens to the creator of the contract
110      */
111 
112     function Ferrum (
113     
114     ) public {
115         
116         totalSupply = 15800000000000;                       // Update total supply with the decimal amount
117         balanceOf[msg.sender] = 15800000000000;             // Give the creator all initial tokens
118         name = "Ferrum";                                    // Set the name for display purposes
119         symbol = "FRM";                                     // Set the symbol for display purposes
120         
121     }
122     
123 
124     /**
125      * Internal transfer, only can be called by this contract
126      */
127     function _transfer(address _from, address _to, uint _value) internal {
128         // Prevent transfer to 0x0 address. Use burn() instead
129         require(_to != 0x0);
130         // Check if the sender has enough
131         require(balanceOf[_from] >= _value);
132         // Check for overflows
133         require(balanceOf[_to] + _value > balanceOf[_to]);
134         // Save this for an assertion in the future
135         uint previousBalances = balanceOf[_from] + balanceOf[_to];
136         // Subtract from the sender
137         balanceOf[_from] -= _value;
138         // Add the same to the recipient
139         balanceOf[_to] += _value;
140         Transfer(_from, _to, _value);
141         // Asserts are used to use static analysis to find bugs in your code. They should never fail
142         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
143     }
144     
145         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
146 
147        /**
148      * Transfer tokens
149      *
150      * Send `_value` tokens to `_to` from your account
151      *
152      * @param _to The address of the recipient
153      * @param _value the amount to send
154      */
155 
156     function transferTEST(address _to, uint256 _value) public {
157         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
158         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
159         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
160         balanceOf[_to] += _value;                           // Add the same to the recipient
161     }
162 
163 
164     /**
165      * Transfer tokens from other address
166      *
167      * Send `_value` tokens to `_to` on behalf of `_from`
168      *
169      * @param _from The address of the sender
170      * @param _to The address of the recipient
171      * @param _value the amount to send
172      */
173     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
174         require(_value <= allowance[_from][msg.sender]);     // Check allowance
175         allowance[_from][msg.sender] -= _value;
176         _transfer(_from, _to, _value);
177         return true;
178     }
179     
180     /**
181      * Set allowance for other address
182      *
183      * Allows `_spender` to spend no more than `_value` tokens on your behalf
184      *
185      * @param _spender The address authorized to spend
186      * @param _value the max amount they can spend
187      */
188     function approve(address _spender, uint256 _value) isRunning validAddress public returns (bool success) {
189         require(_value == 0 || allowance[msg.sender][_spender] == 0);
190         allowance[msg.sender][_spender] = _value;
191         Approval(msg.sender, _spender, _value);
192         return true;
193     }
194     
195 }