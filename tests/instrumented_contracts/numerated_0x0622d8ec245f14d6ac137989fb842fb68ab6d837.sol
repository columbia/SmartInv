1 /**
2  * Source Code first verified at https://etherscan.io on Saturday, April 27, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.7;
6 
7 // ----------------------------------------------------------------------------
8 // 'ACLYDCASH' token contract
9 //
10 // Deployed to : 0x2bea96F65407cF8ed5CEEB804001837dBCDF8b23
11 // Symbol      : ACLYD
12 // Name        : ACLYD CASH
13 // Total supply: 75,000,000 (75 Million)
14 // Decimals    : 18
15 //
16 // Enjoy.
17 //
18 // (c) by The ACLYD Project  
19 // ----------------------------------------------------------------------------
20 
21 
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address who) external view returns (uint256);
26     function allowance(address owner, address spender) external view returns (uint256);
27 
28     function transfer(address to, uint256 value) external returns (bool);
29     function approve(address spender, uint256 value) external returns (bool);
30     function transferFrom(address from, address to, uint256 value) external returns (bool);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 interface IERC223 {
37     function name() external view returns (string memory);
38     function symbol() external view returns (string memory);
39     function decimals() external view returns (uint8);
40     function totalSupply() external view returns (uint256);
41 
42     function balanceOf(address who) external view returns (uint);
43 
44     function transfer(address to, uint value) external returns (bool);
45     function transfer(address to, uint value, bytes calldata data) external returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
48 }
49 
50 contract ContractReceiver {
51     function tokenFallback(address _from, uint _value, bytes memory _data) public {
52         
53     }
54 }
55 
56 /**
57  * @title SafeMath
58  * @dev Unsigned math operations with safety checks that revert on error.
59  */
60 library SafeMath {
61     /**
62       * @dev Multiplies two unsigned integers, reverts on overflow.
63       */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b);
74 
75         return c;
76     }
77 
78     /**
79       * @dev Integer division of two unsigned integers truncating the quotient,
80       * reverts on division by zero.
81       */
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Solidity only automatically asserts when dividing by 0
84         require(b > 0);
85         uint256 c = a / b;
86         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87 
88         return c;
89     }
90 
91     /**
92       * @dev Subtracts two unsigned integers, reverts on overflow
93       * (i.e. if subtrahend is greater than minuend).
94       */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b <= a);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     /**
103       * @dev Adds two unsigned integers, reverts on overflow.
104       */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a);
108 
109         return c;
110     }
111 
112     /**
113       * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
114       * reverts when dividing by zero.
115       */
116     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b != 0);
118         return a % b;
119     }
120 }
121 
122 
123 contract StandardToken is IERC20, IERC223 {
124     uint256 public totalSupply;
125 
126     using SafeMath for uint;
127 
128     mapping (address => uint256) internal balances;
129     mapping (address => mapping (address => uint256)) internal allowed;
130 
131     function balanceOf(address _owner) public view returns (uint256 balance) {
132         return balances[_owner];
133     }
134 
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136         require(_to != address(0));
137         require(_value <= balances[_from]);
138         require(_value <= allowed[_from][msg.sender]);
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         //require(_value == 0 || allowed[msg.sender][_spender] == 0);
148         allowed[msg.sender][_spender] = _value;
149         emit Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     function allowance(address _owner, address _spender) public view returns (uint256) {
154         return allowed[_owner][_spender];
155     }
156 
157     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162 
163     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164         uint oldValue = allowed[msg.sender][_spender];
165         if (_subtractedValue > oldValue) {
166             allowed[msg.sender][_spender] = 0;
167         } else {
168             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169         }
170         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173 
174     // Function that is called when a user or another contract wants to transfer funds.
175     function transfer(address _to, uint _value, bytes memory _data) public returns (bool success) {
176         if (isContract(_to)) {
177             return transferToContract(_to, _value, _data);
178         } else {
179             return transferToAddress(_to, _value, _data);
180         }
181     }
182 
183     // Standard function transfer similar to ERC20 transfer with no _data.
184     // Added due to backwards compatibility reasons.
185     function transfer(address _to, uint _value) public returns (bool success) {
186         bytes memory empty;
187         if (isContract(_to)) {
188             return transferToContract(_to, _value, empty);
189         } else {
190             return transferToAddress(_to, _value, empty);
191         }
192     }
193 
194     // Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
195     function isContract(address _addr) private view returns (bool is_contract) {
196         uint length;
197         require(_addr != address(0));
198         assembly {
199             //retrieve the size of the code on target address, this needs assembly
200             length := extcodesize(_addr)
201         }
202         return (length > 0);
203     }
204 
205     // Function that is called when transaction target is an address.
206     function transferToAddress(address _to, uint _value, bytes memory _data) private returns (bool success) {
207         require(balances[msg.sender] >= _value);
208         balances[msg.sender] = balances[msg.sender].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         emit Transfer(msg.sender, _to, _value);
211         emit Transfer(msg.sender, _to, _value, _data);
212         return true;
213     }
214 
215     // Function that is called when transaction target is a contract.
216     function transferToContract(address _to, uint _value, bytes memory _data) private returns (bool success) {
217         require(balances[msg.sender] >= _value);
218         balances[msg.sender] = balances[msg.sender].sub(_value);
219         balances[_to] = balances[_to].add(_value);
220         ContractReceiver receiver = ContractReceiver(_to);
221         receiver.tokenFallback(msg.sender, _value, _data);
222         emit Transfer(msg.sender, _to, _value);
223         emit Transfer(msg.sender, _to, _value, _data);
224         return true;
225     }
226 }
227 
228 contract ACLYD is StandardToken {
229     string public constant name = "ACLYD CASH";
230     string public constant symbol = "ACLYD";
231     uint8 public constant decimals = 18;
232     uint256 public constant initialSupply = 75000000 * 10 ** uint256(decimals);
233 
234     constructor () public {
235         totalSupply = initialSupply;
236         balances[msg.sender] = initialSupply;
237     }
238 }