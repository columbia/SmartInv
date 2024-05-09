1 pragma solidity 0.5.10;
2 
3 /**
4  * @title Node assignment contract
5  */
6 contract NEST_NodeAssignment {
7     
8     using SafeMath for uint256;
9     IBMapping mappingContract;                              //  Mapping contract
10     IBNEST nestContract;                                    //  NEST contract
11     SuperMan supermanContract;                              //  NestNode contract
12     NEST_NodeSave nodeSave;                                 //  NestNode save contract
13     NEST_NodeAssignmentData nodeAssignmentData;             //  NestNode data assignment contract
14 
15     /**
16     * @dev Initialization method
17     * @param map Voting contract address
18     */
19     constructor (address map) public {
20         mappingContract = IBMapping(map); 
21         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
22         supermanContract = SuperMan(address(mappingContract.checkAddress("nestNode")));
23         nodeSave = NEST_NodeSave(address(mappingContract.checkAddress("nestNodeSave")));
24         nodeAssignmentData = NEST_NodeAssignmentData(address(mappingContract.checkAddress("nodeAssignmentData")));
25     }
26     
27     /**
28     * @dev Reset voting contract
29     * @param map Voting contract address
30     */
31     function changeMapping(address map) public onlyOwner{
32         mappingContract = IBMapping(map); 
33         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
34         supermanContract = SuperMan(address(mappingContract.checkAddress("nestNode")));
35         nodeSave = NEST_NodeSave(address(mappingContract.checkAddress("nestNodeSave")));
36         nodeAssignmentData = NEST_NodeAssignmentData(address(mappingContract.checkAddress("nodeAssignmentData")));
37     }
38     
39     /**
40     * @dev Deposit NEST token
41     * @param amount Amount of deposited NEST
42     */
43     function bookKeeping(uint256 amount) public {
44         require(amount > 0);
45         require(nestContract.transferFrom(address(msg.sender), address(nodeSave), amount));
46         nodeAssignmentData.addNest(amount);
47     }
48     
49     // NestNode receive and settlement
50     function nodeGet() public {
51         require(address(msg.sender) == address(tx.origin));
52         require(supermanContract.balanceOf(address(msg.sender)) > 0);
53         uint256 allAmount = nodeAssignmentData.checkNodeAllAmount();
54         uint256 amount = allAmount.sub(nodeAssignmentData.checkNodeLatestAmount(address(msg.sender)));
55         uint256 getAmount = amount.mul(supermanContract.balanceOf(address(msg.sender))).div(1500);
56         require(nestContract.balanceOf(address(nodeSave)) >= getAmount);
57         nodeSave.turnOut(getAmount,address(msg.sender));
58         nodeAssignmentData.addNodeLatestAmount(address(msg.sender),allAmount);
59     }
60     
61     // NestNode transfer settlement
62     function nodeCount(address fromAdd, address toAdd) public {
63         require(address(supermanContract) == address(msg.sender));
64         require(supermanContract.balanceOf(address(fromAdd)) > 0);
65         uint256 allAmount = nodeAssignmentData.checkNodeAllAmount();
66         uint256 amountFrom = allAmount.sub(nodeAssignmentData.checkNodeLatestAmount(address(fromAdd)));
67         uint256 getAmountFrom = amountFrom.mul(supermanContract.balanceOf(address(fromAdd))).div(1500);
68         if (nestContract.balanceOf(address(nodeSave)) >= getAmountFrom) {
69             nodeSave.turnOut(getAmountFrom,address(fromAdd));
70             nodeAssignmentData.addNodeLatestAmount(address(fromAdd),allAmount);
71         }
72         uint256 amountTo = allAmount.sub(nodeAssignmentData.checkNodeLatestAmount(address(toAdd)));
73         uint256 getAmountTo = amountTo.mul(supermanContract.balanceOf(address(toAdd))).div(1500);
74         if (nestContract.balanceOf(address(nodeSave)) >= getAmountTo) {
75             nodeSave.turnOut(getAmountTo,address(toAdd));
76             nodeAssignmentData.addNodeLatestAmount(address(toAdd),allAmount);
77         }
78     }
79     
80     // NestNode receivable amount
81     function checkNodeNum() public view returns (uint256) {
82          uint256 allAmount = nodeAssignmentData.checkNodeAllAmount();
83          uint256 amount = allAmount.sub(nodeAssignmentData.checkNodeLatestAmount(address(msg.sender)));
84          uint256 getAmount = amount.mul(supermanContract.balanceOf(address(msg.sender))).div(1500);
85          return getAmount; 
86     }
87     
88     // Administrator only
89     modifier onlyOwner(){
90         require(mappingContract.checkOwners(msg.sender));
91         _;
92     }
93 }
94 
95 // Mapping contract
96 contract IBMapping {
97     // Check address
98 	function checkAddress(string memory name) public view returns (address contractAddress);
99 	// Check whether an administrator
100 	function checkOwners(address man) public view returns (bool);
101 }
102 
103 // NEST node save contract
104 contract NEST_NodeSave {
105     function turnOut(uint256 amount, address to) public returns(uint256);
106 }
107 
108 // NestNode assignment data contract
109 contract NEST_NodeAssignmentData {
110     function addNest(uint256 amount) public;
111     function addNodeLatestAmount(address add ,uint256 amount) public;
112     function checkNodeAllAmount() public view returns (uint256);
113     function checkNodeLatestAmount(address add) public view returns (uint256);
114 }
115 
116 // NestNode contract
117 interface SuperMan {
118     function totalSupply() external view returns (uint256);
119     function balanceOf(address who) external view returns (uint256);
120     function allowance(address owner, address spender) external view returns (uint256);
121     function transfer(address to, uint256 value) external returns (bool);
122     function approve(address spender, uint256 value) external returns (bool);
123     function transferFrom(address from, address to, uint256 value) external returns (bool);
124     event Transfer(address indexed from, address indexed to, uint256 value);
125     event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 // NEST contract
129 contract IBNEST {
130     function totalSupply() public view returns (uint supply);
131     function balanceOf( address who ) public view returns (uint value);
132     function allowance( address owner, address spender ) public view returns (uint _allowance);
133     function transfer( address to, uint256 value) external;
134     function transferFrom( address from, address to, uint value) public returns (bool ok);
135     function approve( address spender, uint value ) public returns (bool ok);
136     event Transfer( address indexed from, address indexed to, uint value);
137     event Approval( address indexed owner, address indexed spender, uint value);
138 }
139 
140 /**
141  * @title SafeMath
142  * @dev Math operations with safety checks that revert on error
143  */
144 library SafeMath {
145     int256 constant private INT256_MIN = -2**255;
146 
147     /**
148     * @dev Multiplies two unsigned integers, reverts on overflow.
149     */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b);
160 
161         return c;
162     }
163 
164     /**
165     * @dev Multiplies two signed integers, reverts on overflow.
166     */
167     function mul(int256 a, int256 b) internal pure returns (int256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
176 
177         int256 c = a * b;
178         require(c / a == b);
179 
180         return c;
181     }
182 
183     /**
184     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
185     */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Solidity only automatically asserts when dividing by 0
188         require(b > 0);
189         uint256 c = a / b;
190         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191 
192         return c;
193     }
194 
195     /**
196     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
197     */
198     function div(int256 a, int256 b) internal pure returns (int256) {
199         require(b != 0); // Solidity only automatically asserts when dividing by 0
200         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
201 
202         int256 c = a / b;
203 
204         return c;
205     }
206 
207     /**
208     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
209     */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b <= a);
212         uint256 c = a - b;
213 
214         return c;
215     }
216 
217     /**
218     * @dev Subtracts two signed integers, reverts on overflow.
219     */
220     function sub(int256 a, int256 b) internal pure returns (int256) {
221         int256 c = a - b;
222         require((b >= 0 && c <= a) || (b < 0 && c > a));
223 
224         return c;
225     }
226 
227     /**
228     * @dev Adds two unsigned integers, reverts on overflow.
229     */
230     function add(uint256 a, uint256 b) internal pure returns (uint256) {
231         uint256 c = a + b;
232         require(c >= a);
233 
234         return c;
235     }
236 
237     /**
238     * @dev Adds two signed integers, reverts on overflow.
239     */
240     function add(int256 a, int256 b) internal pure returns (int256) {
241         int256 c = a + b;
242         require((b >= 0 && c >= a) || (b < 0 && c < a));
243 
244         return c;
245     }
246 
247     /**
248     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
249     * reverts when dividing by zero.
250     */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         require(b != 0);
253         return a % b;
254     }
255 }