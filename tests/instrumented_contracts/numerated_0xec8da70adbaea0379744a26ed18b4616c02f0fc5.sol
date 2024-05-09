1 pragma solidity ^0.4.23;
2 
3 contract ERC223 {
4     uint public totalSupply;
5     function balanceOf(address who) public constant returns (uint);
6 
7     function name() public constant returns (string _name);
8     function symbol() public constant returns (string _symbol);
9     function decimals() public constant returns (uint8 _decimals);
10     function totalSupply() public constant returns (uint256 _supply);
11 
12     function transfer(address to, uint value) public returns (bool _success);
13     function transfer(address to, uint value, bytes data) public returns (bool _success);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
17     event Burn(address indexed _burner, uint256 _value);
18 }
19 
20 /**
21  * https://peeke.io
22  * - Peeke Private Coupon -  
23  * These tokens form a binding receipt for the initial private sale and can be redeemed onchain 1:1 with the PKE token once deployed.
24  * Unsold tokens will be burnt at the end of the private campaign.
25  **/
26  
27 contract PeekePrivateTokenCoupon is ERC223 {
28     using SafeMath for uint;
29 
30     mapping(address => uint) balances;
31 
32     string public name    = "Peeke Private Coupon";
33     string public symbol  = "PPC-PKE";
34     uint8 public decimals = 18;
35     uint256 public totalSupply = 155000000 * (10**18);
36 
37     constructor(PeekePrivateTokenCoupon) public {
38         balances[msg.sender] = totalSupply;
39     }
40 
41     // Function to access name of token.
42     function name() constant public returns (string _name) {
43         return name;
44     }
45 
46     // Function to access symbol of token.
47     function symbol() constant public returns (string _symbol) {
48         return symbol;
49     }
50 
51     // Function to access decimals of token.
52     function decimals() constant public returns (uint8 _decimals) {
53         return decimals;
54     }
55 
56     // Function to access total supply of tokens.
57     function totalSupply() constant public returns (uint256 _totalSupply) {
58         return totalSupply;
59     }
60 
61     // Function that is called when a user or another contract wants to transfer funds.
62     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
63         if(isContract(_to)) {
64             return transferToContract(_to, _value, _data);
65         }
66         else {
67             return transferToAddress(_to, _value, _data);
68         }
69     }
70 
71     // Standard function transfer similar to ERC20 transfer with no _data.
72     // Added due to backwards compatibility reasons .
73     function transfer(address _to, uint _value) public returns (bool success) {
74         // Standard function transfer similar to ERC20 transfer with no _data
75         // Added due to backwards compatibility reasons
76         bytes memory empty;
77         if(isContract(_to)) {
78             return transferToContract(_to, _value, empty);
79         } else {
80             return transferToAddress(_to, _value, empty);
81         }
82     }
83 
84     // Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
85     function isContract(address _addr) private constant returns (bool is_contract) {
86       uint length;
87       assembly {
88             // Retrieve the size of the code on target address, this needs assembly.
89             length := extcodesize(_addr)
90         }
91         return (length > 0);
92     }
93 
94     // Function that is called when transaction target is an address
95     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
96         if (balanceOf(msg.sender) < _value) revert();
97         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
98         balances[_to] = balanceOf(_to).add(_value);
99         emit Transfer(msg.sender, _to, _value);
100         emit ERC223Transfer(msg.sender, _to, _value, _data);
101         return true;
102     }
103 
104     // Function that is called when transaction target is a contract
105     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
106         if (balanceOf(msg.sender) < _value) revert();
107         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
108         balances[_to] = balanceOf(_to).add(_value);
109         ContractReceiver reciever = ContractReceiver(_to);
110         reciever.tokenFallback(msg.sender, _value, _data);
111         emit Transfer(msg.sender, _to, _value);
112         emit ERC223Transfer(msg.sender, _to, _value, _data);
113         return true;
114     }
115 
116     // Function to burn unsold tokens at the end of the private contribution.
117     function burn() public {
118         uint256 tokens = balances[msg.sender];
119         balances[msg.sender] = 0;
120         totalSupply = totalSupply.sub(tokens);
121         emit Burn(msg.sender, tokens);
122     }
123 
124     function balanceOf(address _owner) public constant returns (uint balance) {
125         return balances[_owner];
126     }
127 }
128 
129 
130 contract ContractReceiver {
131     function tokenFallback(address _from, uint _value, bytes _data) public;
132 }
133 
134 
135 library SafeMath {
136   /**
137   * @dev Multiplies two numbers, throws on overflow.
138   */
139   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140     if (a == 0) {
141       return 0;
142     }
143     uint256 c = a * b;
144     assert(c / a == b);
145     return c;
146   }
147 
148   /**
149   * @dev Integer division of two numbers, truncating the quotient.
150   */
151   function div(uint256 a, uint256 b) internal pure returns (uint256) {
152     // assert(b > 0); // Solidity automatically throws when dividing by 0
153     uint256 c = a / b;
154     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
155     return c;
156   }
157 
158   /**
159   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
160   */
161   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162     assert(b <= a);
163     return a - b;
164   }
165 
166   /**
167   * @dev Adds two numbers, throws on overflow.
168   */
169   function add(uint256 a, uint256 b) internal pure returns (uint256) {
170     uint256 c = a + b;
171     assert(c >= a);
172     return c;
173   }
174 }