1 pragma solidity 0.5.8;
2 
3 /**
4  * Trickle is a decentralized program allowing people to create
5  * secure fixed hourly rate agreements leveraging the power of blockchain technology.
6  * Trickle works with any ERC20-compatible tokens on top of Ethereum, including stablecoins.
7  *
8  * Brought to you by DreamTeam <https://token.dreamteam.gg>.
9  * Learn more about Trickle <https://github.com/dreamteam-gg/trickle-dapp>.
10  * Access this DApp at <https://trickle.gg> or <http://zitros.github.io/trickle-dapp>.
11  */
12 contract Trickle {
13 
14     using SafeMath for uint256;
15 
16     event AgreementCreated(
17         uint256 indexed agreementId,
18         address token,
19         address indexed recipient,
20         address indexed sender,
21         uint256 start,
22         uint256 duration,
23         uint256 totalAmount,
24         uint256 createdAt
25     );
26     event AgreementCanceled(
27         uint256 indexed agreementId,
28         address token,
29         address indexed recipient,
30         address indexed sender,
31         uint256 start,
32         uint256 duration,
33         uint256 amountReleased,
34         uint256 amountCanceled,
35         uint256 canceledAt
36     );
37     event Withdraw(
38         uint256 indexed agreementId,
39         address token,
40         address indexed recipient,
41         address indexed sender,
42         uint256 amountReleased,
43         uint256 releasedAt
44     );
45 
46     uint256 private lastAgreementId;
47 
48     struct Agreement {
49         uint256 meta; // Metadata packs 3 values to save on storage:
50                       // + uint48 start;    // Timestamp with agreement start. Up to year 999999+.
51                       // + uint48 duration; // Agreement duration. Up to year 999999+.
52                       // + uint160 token;   // Token address converted to uint.
53         uint256 totalAmount;
54         uint256 releasedAmount;
55         address recipient;
56         address sender;
57     }
58 
59     mapping (uint256 => Agreement) private agreements;
60 
61     modifier agreementPartiesOnly(uint256 agreementId) {
62         require (
63             msg.sender == agreements[agreementId].sender ||
64             msg.sender == agreements[agreementId].recipient,
65             "Allowed only for agreement's sender or recipient"
66         );
67         _;
68     }
69 
70     modifier validAgreement(uint256 agreementId) {
71         require(agreements[agreementId].releasedAmount < agreements[agreementId].totalAmount, "Agreement is completed or does not exists");
72         _;
73     }
74 
75     function createAgreement(IERC20 token, address recipient, uint256 totalAmount, uint48 duration, uint48 start) external {
76         require(duration > 0, "Duration must be greater than zero");
77         require(totalAmount > 0, "Total Amount must be greater than zero");
78         require(start > 0, "Start must be greater than zero");
79         require(token != IERC20(0x0), "Token must be a valid Ethereum address");
80         require(recipient != address(0x0), "Recipient must be a valid Ethereum address");
81 
82         uint256 agreementId = ++lastAgreementId;
83 
84         agreements[agreementId] = Agreement({
85             meta: encodeMeta(start, duration, uint256(address(token))),
86             recipient: recipient,
87             totalAmount: totalAmount,
88             sender: msg.sender,
89             releasedAmount: 0
90         });
91 
92         token.transferFrom(agreements[agreementId].sender, address(this), agreements[agreementId].totalAmount);
93 
94         emit AgreementCreated(
95             agreementId,
96             address(token),
97             recipient,
98             msg.sender,
99             start,
100             duration,
101             totalAmount,
102             block.timestamp
103         );
104     }
105 
106     function getAgreement(uint256 agreementId) external view returns (
107         address token,
108         address recipient,
109         address sender,
110         uint256 start,
111         uint256 duration,
112         uint256 totalAmount,
113         uint256 releasedAmount
114     ) {
115         (start, duration, token) = decodeMeta(agreements[agreementId].meta);
116         sender = agreements[agreementId].sender;
117         totalAmount = agreements[agreementId].totalAmount;
118         releasedAmount = agreements[agreementId].releasedAmount;
119         recipient = agreements[agreementId].recipient;
120     }
121 
122     function withdrawTokens(uint256 agreementId) public validAgreement(agreementId) {
123         uint256 unreleased = withdrawableAmount(agreementId);
124         require(unreleased > 0, "Nothing to withdraw");
125 
126         agreements[agreementId].releasedAmount = agreements[agreementId].releasedAmount.add(unreleased);
127         (, , address token) = decodeMeta(agreements[agreementId].meta);
128         IERC20(token).transfer(agreements[agreementId].recipient, unreleased);
129 
130         emit Withdraw(
131             agreementId,
132             token,
133             agreements[agreementId].recipient,
134             agreements[agreementId].sender,
135             unreleased,
136             block.timestamp
137         );
138     }
139 
140     function cancelAgreement(uint256 agreementId) external validAgreement(agreementId) agreementPartiesOnly(agreementId) {
141         if (withdrawableAmount(agreementId) > 0) {
142             withdrawTokens(agreementId);
143         }
144 
145         uint256 releasedAmount = agreements[agreementId].releasedAmount;
146         uint256 canceledAmount = agreements[agreementId].totalAmount.sub(releasedAmount);
147 
148         (uint256 start, uint256 duration, address token) = decodeMeta(agreements[agreementId].meta);
149 
150         agreements[agreementId].releasedAmount = agreements[agreementId].totalAmount;
151         if (canceledAmount > 0) {
152             IERC20(token).transfer(agreements[agreementId].sender, canceledAmount);
153         }
154 
155         emit AgreementCanceled(
156             agreementId,
157             token,
158             agreements[agreementId].recipient,
159             agreements[agreementId].sender,
160             start,
161             duration,
162             releasedAmount,
163             canceledAmount,
164             block.timestamp
165         );
166     }
167 
168     function withdrawableAmount(uint256 agreementId) public view returns (uint256) {
169         return proportionalAmount(agreementId).sub(agreements[agreementId].releasedAmount);
170     }
171 
172     function proportionalAmount(uint256 agreementId) private view returns (uint256) {
173         (uint256 start, uint256 duration, ) = decodeMeta(agreements[agreementId].meta);
174         if (block.timestamp >= start.add(duration)) {
175             return agreements[agreementId].totalAmount;
176         } else if (block.timestamp <= start) {
177             return 0;
178         } else {
179             return agreements[agreementId].totalAmount.mul(
180                 block.timestamp.sub(start)
181             ).div(duration);
182         }
183     }
184 
185     function encodeMeta(uint256 start, uint256 duration, uint256 token) private pure returns(uint256 result) {
186         require(
187             start < 2 ** 48 &&
188             duration < 2 ** 48 &&
189             token < 2 ** 160,
190             "Start, Duration or Token Address provided have invalid values"
191         );
192 
193         result = start;
194         result |= duration << (48);
195         result |= token << (48 + 48);
196 
197         return result;
198     }
199 
200     function decodeMeta(uint256 meta) private pure returns(uint256 start, uint256 duration, address token) {
201         start = uint48(meta);
202         duration = uint48(meta >> (48));
203         token = address(meta >> (48 + 48));
204     }
205 
206 }
207 
208 /**
209  * @title SafeMath
210  * @dev Unsigned math operations with safety checks that revert on error.
211  */
212 library SafeMath {
213 
214     /**
215      * @dev Multiplies two unsigned integers, reverts on overflow.
216      */
217     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
219         // benefit is lost if 'b' is also tested.
220         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
221         if (a == 0) {
222             return 0;
223         }
224 
225         uint256 c = a * b;
226         require(c / a == b, "SafeMath: multiplication overflow");
227 
228         return c;
229     }
230 
231     /**
232      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
233      */
234     function div(uint256 a, uint256 b) internal pure returns (uint256) {
235         // Solidity only automatically asserts when dividing by 0
236         require(b > 0, "SafeMath: division by zero");
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
245      */
246     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
247         require(b <= a, "SafeMath: subtraction overflow");
248         uint256 c = a - b;
249 
250         return c;
251     }
252 
253     /**
254      * @dev Adds two unsigned integers, reverts on overflow.
255      */
256     function add(uint256 a, uint256 b) internal pure returns (uint256) {
257         uint256 c = a + b;
258         require(c >= a, "SafeMath: addition overflow");
259 
260         return c;
261     }
262 
263     /**
264      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
265      * reverts when dividing by zero.
266      */
267     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
268         require(b != 0, "SafeMath: modulo by zero");
269         return a % b;
270     }
271 
272 }
273 
274 /**
275  * @title ERC20 interface
276  * @dev see https://eips.ethereum.org/EIPS/eip-20
277  */
278 interface IERC20 {
279     function transfer(address to, uint256 value) external returns (bool);
280     function approve(address spender, uint256 value) external returns (bool);
281     function transferFrom(address from, address to, uint256 value) external returns (bool);
282     function totalSupply() external view returns (uint256);
283     function balanceOf(address who) external view returns (uint256);
284     function allowance(address owner, address spender) external view returns (uint256);
285     event Transfer(address indexed from, address indexed to, uint256 value);
286     event Approval(address indexed owner, address indexed spender, uint256 value);
287 }