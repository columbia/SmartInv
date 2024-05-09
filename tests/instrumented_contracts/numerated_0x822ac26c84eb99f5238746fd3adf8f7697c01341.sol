1 pragma solidity 0.5.8;
2 
3 /**
4  * @title SafeMath 
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, revert on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, revert on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtract two unsigned integers, revert on underflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Add two unsigned integers, revert on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 contract Ownable {
59     address internal _owner;
60     address private _pendingOwner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @return The address of the owner.
66      */
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Revert if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(isOwner(), "The caller must be owner");
76         _;
77     }
78 
79     /**
80      * @return true if `msg.sender` is the owner of the contract.
81      */
82     function isOwner() public view returns (bool) {
83         return msg.sender == _owner;
84     }
85 
86     /**
87      * @dev Transfer control of the contract to a newOwner.
88      * @param newOwner The address to transfer ownership to.
89      */
90     function _transferOwnership(address newOwner) internal {
91         require(newOwner != address(0), "Cannot transfer control of the contract to the zero address");
92         _pendingOwner = newOwner;
93     }
94 
95     function receiveOwnership() public {
96         require(msg.sender == _pendingOwner);
97         emit OwnershipTransferred(_owner, _pendingOwner);
98         _owner = _pendingOwner;
99         _pendingOwner = address(0);  
100     }
101 }
102 
103 contract Operable is Ownable {
104 
105     address private _operator; 
106 
107     event OperatorChanged(address indexed oldOperator, address indexed newOperator);
108 
109     /**
110      * @dev Tells the address of the operator.
111      * @return The address of the operator.
112      */
113     function operator() external view returns (address) {
114         return _operator;
115     }
116     
117     /**
118      * @dev Only the operator can operate store.
119      */
120     modifier onlyOperator() {
121         require(msg.sender == _operator, "msg.sender should be operator");
122         _;
123     }
124 
125     function isContract(address addr) internal view returns (bool) {
126         uint size;
127         assembly { size := extcodesize(addr) }
128         return size > 0;
129     }
130 
131     /**
132      * @dev Update the storgeOperator.
133      * @param _newOperator The newOperator to update.
134      */
135     function updateOperator(address _newOperator) public onlyOwner {
136         require(_newOperator != address(0), "Cannot change the newOperator to the zero address");
137         require(isContract(_newOperator), "New operator must be contract address");
138         emit OperatorChanged(_operator, _newOperator);
139         _operator = _newOperator;
140     }
141 
142 }
143 
144 contract DUSDStorage is Operable {
145 
146     using SafeMath for uint256;
147     bool private paused = false;
148     mapping (address => uint256) private balances;
149     mapping (address => mapping (address => uint256)) private allowances;
150     mapping (address=>bool) private blackList;
151     string private constant name = "Digital USD";
152     string private constant symbol = "DUSD";
153     uint8 private constant decimals = 18;
154     uint256 private totalSupply;
155 
156     constructor() public {
157         _owner = 0xfe30e619cc2915C905Ca45C1BA8311109A3cBdB1;
158     }
159     
160     function getTokenName() public view onlyOperator returns (string memory) {
161         return name;
162     }
163     
164     function getSymbol() public view onlyOperator returns (string memory) {
165         return symbol;
166     }
167     
168     function getDecimals() public view onlyOperator returns (uint8) {
169         return decimals;
170     }
171     
172     function getTotalSupply() public view onlyOperator returns (uint256) {
173         return totalSupply;
174     }
175 
176     function getBalance(address _holder) public view onlyOperator returns (uint256) {
177         return balances[_holder];
178     }
179 
180     function addBalance(address _holder, uint256 _value) public onlyOperator {
181         balances[_holder] = balances[_holder].add(_value);
182     }
183 
184     function subBalance(address _holder, uint256 _value) public onlyOperator {
185         balances[_holder] = balances[_holder].sub(_value);
186     }
187 
188     function setBalance(address _holder, uint256 _value) public onlyOperator {
189         balances[_holder] = _value;
190     }
191     
192     function getAllowance(address _holder, address _spender) public view onlyOperator returns (uint256) {
193         return allowances[_holder][_spender];
194     }
195 
196     function addAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
197         allowances[_holder][_spender] = allowances[_holder][_spender].add(_value);
198     }
199 
200     function subAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
201         allowances[_holder][_spender] = allowances[_holder][_spender].sub(_value);
202     }
203 
204     function setAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
205         allowances[_holder][_spender] = _value;
206     }
207 
208     function addTotalSupply(uint256 _value) public onlyOperator {
209         totalSupply = totalSupply.add(_value);
210     }
211 
212     function subTotalSupply(uint256 _value) public onlyOperator {
213         totalSupply = totalSupply.sub(_value);
214     }
215 
216     function setTotalSupply(uint256 _value) public onlyOperator {
217         totalSupply = _value;
218     }
219 
220     function addBlackList(address user) public onlyOperator {
221         blackList[user] = true;
222     }
223 
224     function removeBlackList (address user) public onlyOperator {
225         blackList[user] = false;
226     }
227     
228     function isBlackList(address user) public view onlyOperator returns (bool) {
229         return blackList[user];
230     }
231 
232     function getPaused() public view onlyOperator returns (bool) {
233         return paused;
234     }
235     
236     function pause() public onlyOperator {
237         paused = true;
238     }
239     
240     function unpause() public onlyOperator {
241         paused = false;
242     }
243 
244 }