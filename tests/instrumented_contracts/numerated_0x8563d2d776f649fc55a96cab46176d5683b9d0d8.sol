1 // File: contracts/Ownable.sol
2 
3 pragma solidity 0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11 
12     address private _owner;
13     address private _pendingOwner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16     
17     /**
18      * @dev The constructor sets the original owner of the contract to the sender account.
19      */
20     constructor() public {
21         setOwner(msg.sender);
22     }
23 
24     /**
25      * @dev Modifier throws if called by any account other than the pendingOwner.
26      */
27     modifier onlyPendingOwner() {
28         require(msg.sender == _pendingOwner, "msg.sender should be onlyPendingOwner");
29         _;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(msg.sender == _owner, "msg.sender should be owner");
37         _;
38     }
39 
40     /**
41      * @dev Tells the address of the pendingOwner
42      * @return The address of the pendingOwner
43      */
44     function pendingOwner() public view returns (address) {
45         return _pendingOwner;
46     }
47     
48     /**
49      * @dev Tells the address of the owner
50      * @return the address of the owner
51      */
52     function owner() public view returns (address ) {
53         return _owner;
54     }
55     
56     /**
57     * @dev Sets a new owner address
58     * @param _newOwner The newOwner to set
59     */
60     function setOwner(address _newOwner) internal {
61         _owner = _newOwner;
62     }
63 
64     /**
65      * @dev Allows the current owner to set the pendingOwner address.
66      * @param _newOwner The address to transfer ownership to.
67      */
68     function transferOwnership(address _newOwner) public onlyOwner {
69         _pendingOwner = _newOwner;
70     }
71 
72     /**
73      * @dev Allows the pendingOwner address to finalize the transfer.
74      */
75     function claimOwnership() public onlyPendingOwner {
76         emit OwnershipTransferred(_owner, _pendingOwner);
77         _owner = _pendingOwner;
78         _pendingOwner = address(0); 
79     }
80     
81 }
82 
83 // File: contracts/Operable.sol
84 
85 pragma solidity 0.5.0;
86 
87 
88 contract Operable is Ownable {
89 
90     address private _operator; 
91 
92     event OperatorChanged(address indexed previousOperator, address indexed newOperator);
93 
94     /**
95      * @dev Tells the address of the operator
96      * @return the address of the operator
97      */
98     function operator() external view returns (address) {
99         return _operator;
100     }
101     
102     /**
103      * @dev Only the operator can operate store
104      */
105     modifier onlyOperator() {
106         require(msg.sender == _operator, "msg.sender should be operator");
107         _;
108     }
109 
110     /**
111      * @dev update the storgeOperator
112      * @param _newOperator The newOperator to update  
113      */
114     function updateOperator(address _newOperator) public onlyOwner {
115         require(_newOperator != address(0), "Cannot change the newOperator to the zero address");
116         emit OperatorChanged(_operator, _newOperator);
117         _operator = _newOperator;
118     }
119 
120 }
121 
122 // File: contracts/utils/SafeMath.sol
123 
124 pragma solidity 0.5.0;
125 
126 /**
127  * @title SafeMath
128  * @dev Unsigned math operations with safety checks that revert on error
129  */
130 library SafeMath {
131     /**
132      * @dev Multiplies two unsigned integers, reverts on overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b);
144 
145         return c;
146     }
147 
148     /**
149      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
150      */
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Solidity only automatically asserts when dividing by 0
153         require(b > 0);
154         uint256 c = a / b;
155         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156 
157         return c;
158     }
159 
160     /**
161      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
162      */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b <= a);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Adds two unsigned integers, reverts on overflow.
172      */
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         uint256 c = a + b;
175         require(c >= a);
176 
177         return c;
178     }
179 
180     /**
181      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
182      * reverts when dividing by zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0);
186         return a % b;
187     }
188 }
189 
190 // File: contracts/TokenStore.sol
191 
192 pragma solidity 0.5.0;
193 
194 
195 
196 contract TokenStore is Operable {
197 
198     using SafeMath for uint256;
199 
200     uint256 public totalSupply;
201     
202     string  public name = "PingAnToken";
203     string  public symbol = "PAT";
204     uint8 public decimals = 18;
205 
206     mapping (address => uint256) public balances;
207     mapping (address => mapping (address => uint256)) public allowed;
208 
209     function changeTokenName(string memory _name, string memory _symbol) public onlyOperator {
210         name = _name;
211         symbol = _symbol;
212     }
213 
214     function addBalance(address _holder, uint256 _value) public onlyOperator {
215         balances[_holder] = balances[_holder].add(_value);
216     }
217 
218     function subBalance(address _holder, uint256 _value) public onlyOperator {
219         balances[_holder] = balances[_holder].sub(_value);
220     }
221 
222     function setBalance(address _holder, uint256 _value) public onlyOperator {
223         balances[_holder] = _value;
224     }
225 
226     function addAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
227         allowed[_holder][_spender] = allowed[_holder][_spender].add(_value);
228     }
229 
230     function subAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
231         allowed[_holder][_spender] = allowed[_holder][_spender].sub(_value);
232     }
233 
234     function setAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
235         allowed[_holder][_spender] = _value;
236     }
237 
238     function addTotalSupply(uint256 _value) public onlyOperator {
239         totalSupply = totalSupply.add(_value);
240     }
241 
242     function subTotalSupply(uint256 _value) public onlyOperator {
243         totalSupply = totalSupply.sub(_value);
244     }
245 
246     function setTotalSupply(uint256 _value) public onlyOperator {
247         totalSupply = _value;
248     }
249 
250 }