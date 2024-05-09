1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-19
3 */
4 
5 pragma solidity ^0.5.7;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address who) external view returns (uint256);
10     function allowance(address owner, address spender) external view returns (uint256);
11 
12     function transfer(address to, uint256 value) external returns (bool);
13     function approve(address spender, uint256 value) external returns (bool);
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 interface IERC223 {
21     function name() external view returns (string memory);
22     function symbol() external view returns (string memory);
23     function decimals() external view returns (uint8);
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address who) external view returns (uint);
27 
28     function transfer(address to, uint value) external returns (bool);
29     function transfer(address to, uint value, bytes calldata data) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
32 }
33 
34 contract ContractReceiver {
35     function tokenFallback(address _from, uint _value, bytes memory _data) public {
36         
37     }
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Unsigned math operations with safety checks that revert on error.
43  */
44 library SafeMath {
45     /**
46       * @dev Multiplies two unsigned integers, reverts on overflow.
47       */
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50         // benefit is lost if 'b' is also tested.
51         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b);
58 
59         return c;
60     }
61 
62     /**
63       * @dev Integer division of two unsigned integers truncating the quotient,
64       * reverts on division by zero.
65       */
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Solidity only automatically asserts when dividing by 0
68         require(b > 0);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74 
75     /**
76       * @dev Subtracts two unsigned integers, reverts on overflow
77       * (i.e. if subtrahend is greater than minuend).
78       */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b <= a);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87       * @dev Adds two unsigned integers, reverts on overflow.
88       */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a);
92 
93         return c;
94     }
95 
96     /**
97       * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
98       * reverts when dividing by zero.
99       */
100     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
101         require(b != 0);
102         return a % b;
103     }
104 }
105 
106 
107 contract StandardToken is IERC20, IERC223 {
108     uint256 public totalSupply;
109 
110     using SafeMath for uint;
111 
112     mapping (address => uint256) internal balances;
113     mapping (address => mapping (address => uint256)) internal allowed;
114 
115     function balanceOf(address _owner) public view returns (uint256 balance) {
116         return balances[_owner];
117     }
118 
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120         require(_to != address(0));
121         require(_value <= balances[_from]);
122         require(_value <= allowed[_from][msg.sender]);
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         emit Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     function approve(address _spender, uint256 _value) public returns (bool) {
131         //require(_value == 0 || allowed[msg.sender][_spender] == 0);
132         allowed[msg.sender][_spender] = _value;
133         emit Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) public view returns (uint256) {
138         return allowed[_owner][_spender];
139     }
140 
141     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
142         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
143         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144         return true;
145     }
146 
147     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
148         uint oldValue = allowed[msg.sender][_spender];
149         if (_subtractedValue > oldValue) {
150             allowed[msg.sender][_spender] = 0;
151         } else {
152             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
153         }
154         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155         return true;
156     }
157 
158     // Function that is called when a user or another contract wants to transfer funds.
159     function transfer(address _to, uint _value, bytes memory _data) public returns (bool success) {
160         if (isContract(_to)) {
161             return transferToContract(_to, _value, _data);
162         } else {
163             return transferToAddress(_to, _value, _data);
164         }
165     }
166 
167     // Standard function transfer similar to ERC20 transfer with no _data.
168     // Added due to backwards compatibility reasons.
169     function transfer(address _to, uint _value) public returns (bool success) {
170         bytes memory empty;
171         if (isContract(_to)) {
172             return transferToContract(_to, _value, empty);
173         } else {
174             return transferToAddress(_to, _value, empty);
175         }
176     }
177 
178     // Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
179     function isContract(address _addr) private view returns (bool is_contract) {
180         uint length;
181         require(_addr != address(0));
182         assembly {
183             //retrieve the size of the code on target address, this needs assembly
184             length := extcodesize(_addr)
185         }
186         return (length > 0);
187     }
188 
189     // Function that is called when transaction target is an address.
190     function transferToAddress(address _to, uint _value, bytes memory _data) private returns (bool success) {
191         require(balances[msg.sender] >= _value);
192         balances[msg.sender] = balances[msg.sender].sub(_value);
193         balances[_to] = balances[_to].add(_value);
194         emit Transfer(msg.sender, _to, _value);
195         emit Transfer(msg.sender, _to, _value, _data);
196         return true;
197     }
198 
199     // Function that is called when transaction target is a contract.
200     function transferToContract(address _to, uint _value, bytes memory _data) private returns (bool success) {
201         require(balances[msg.sender] >= _value);
202         balances[msg.sender] = balances[msg.sender].sub(_value);
203         balances[_to] = balances[_to].add(_value);
204         ContractReceiver receiver = ContractReceiver(_to);
205         receiver.tokenFallback(msg.sender, _value, _data);
206         emit Transfer(msg.sender, _to, _value);
207         emit Transfer(msg.sender, _to, _value, _data);
208         return true;
209     }
210 }
211 
212 contract AITBotToken  is StandardToken {
213     string public constant name = "AITBot Token ";
214     string public constant symbol = "AITBOT";
215     uint8 public constant decimals = 18;
216     uint256 public constant initialSupply = 1000000000 * 10 ** uint256(decimals);
217 
218     constructor () public {
219         totalSupply = initialSupply;
220         balances[msg.sender] = initialSupply;
221     }
222 }