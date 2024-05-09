1 pragma solidity ^0.5.7;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address who) external view returns (uint256);
6     function allowance(address owner, address spender) external view returns (uint256);
7 
8     function transfer(address to, uint256 value) external returns (bool);
9     function approve(address spender, uint256 value) external returns (bool);
10     function transferFrom(address from, address to, uint256 value) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 interface IERC223 {
17     function name() external view returns (string memory);
18     function symbol() external view returns (string memory);
19     function decimals() external view returns (uint8);
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address who) external view returns (uint);
23 
24     function transfer(address to, uint value) external returns (bool);
25     function transfer(address to, uint value, bytes calldata data) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
28 }
29 
30 contract ContractReceiver {
31     function tokenFallback(address _from, uint _value, bytes memory _data) public {
32         
33     }
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Unsigned math operations with safety checks that revert on error.
39  */
40 library SafeMath {
41     /**
42       * @dev Multiplies two unsigned integers, reverts on overflow.
43       */
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48         if (a == 0) {
49             return 0;
50         }
51 
52         uint256 c = a * b;
53         require(c / a == b);
54 
55         return c;
56     }
57 
58     /**
59       * @dev Integer division of two unsigned integers truncating the quotient,
60       * reverts on division by zero.
61       */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Solidity only automatically asserts when dividing by 0
64         require(b > 0);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     /**
72       * @dev Subtracts two unsigned integers, reverts on overflow
73       * (i.e. if subtrahend is greater than minuend).
74       */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b <= a);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83       * @dev Adds two unsigned integers, reverts on overflow.
84       */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a);
88 
89         return c;
90     }
91 
92     /**
93       * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
94       * reverts when dividing by zero.
95       */
96     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97         require(b != 0);
98         return a % b;
99     }
100 }
101 
102 
103 contract StandardToken is IERC20, IERC223 {
104     uint256 public totalSupply;
105 
106     using SafeMath for uint;
107 
108     mapping (address => uint256) internal balances;
109     mapping (address => mapping (address => uint256)) internal allowed;
110 
111     function balanceOf(address _owner) public view returns (uint256 balance) {
112         return balances[_owner];
113     }
114 
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116         require(_to != address(0));
117         require(_value <= balances[_from]);
118         require(_value <= allowed[_from][msg.sender]);
119         balances[_from] = balances[_from].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122         emit Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     function approve(address _spender, uint256 _value) public returns (bool) {
127         //require(_value == 0 || allowed[msg.sender][_spender] == 0);
128         allowed[msg.sender][_spender] = _value;
129         emit Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133     function allowance(address _owner, address _spender) public view returns (uint256) {
134         return allowed[_owner][_spender];
135     }
136 
137     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
138         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
139         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140         return true;
141     }
142 
143     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
144         uint oldValue = allowed[msg.sender][_spender];
145         if (_subtractedValue > oldValue) {
146             allowed[msg.sender][_spender] = 0;
147         } else {
148             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
149         }
150         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151         return true;
152     }
153 
154     // Function that is called when a user or another contract wants to transfer funds.
155     function transfer(address _to, uint _value, bytes memory _data) public returns (bool success) {
156         if (isContract(_to)) {
157             return transferToContract(_to, _value, _data);
158         } else {
159             return transferToAddress(_to, _value, _data);
160         }
161     }
162 
163     // Standard function transfer similar to ERC20 transfer with no _data.
164     // Added due to backwards compatibility reasons.
165     function transfer(address _to, uint _value) public returns (bool success) {
166         bytes memory empty;
167         if (isContract(_to)) {
168             return transferToContract(_to, _value, empty);
169         } else {
170             return transferToAddress(_to, _value, empty);
171         }
172     }
173 
174     // Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
175     function isContract(address _addr) private view returns (bool is_contract) {
176         uint length;
177         require(_addr != address(0));
178         assembly {
179             //retrieve the size of the code on target address, this needs assembly
180             length := extcodesize(_addr)
181         }
182         return (length > 0);
183     }
184 
185     // Function that is called when transaction target is an address.
186     function transferToAddress(address _to, uint _value, bytes memory _data) private returns (bool success) {
187         require(balances[msg.sender] >= _value);
188         balances[msg.sender] = balances[msg.sender].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         emit Transfer(msg.sender, _to, _value);
191         emit Transfer(msg.sender, _to, _value, _data);
192         return true;
193     }
194 
195     // Function that is called when transaction target is a contract.
196     function transferToContract(address _to, uint _value, bytes memory _data) private returns (bool success) {
197         require(balances[msg.sender] >= _value);
198         balances[msg.sender] = balances[msg.sender].sub(_value);
199         balances[_to] = balances[_to].add(_value);
200         ContractReceiver receiver = ContractReceiver(_to);
201         receiver.tokenFallback(msg.sender, _value, _data);
202         emit Transfer(msg.sender, _to, _value);
203         emit Transfer(msg.sender, _to, _value, _data);
204         return true;
205     }
206 }
207 
208 contract RedBoxDappToken is StandardToken {
209     string public constant name = "Red Box Dapp Token";
210     string public constant symbol = "RBD";
211     uint8 public constant decimals = 18;
212     uint256 public constant initialSupply = 600000000 * 10 ** uint256(decimals);
213 
214     constructor () public {
215         totalSupply = initialSupply;
216         balances[msg.sender] = initialSupply;
217     }
218 }