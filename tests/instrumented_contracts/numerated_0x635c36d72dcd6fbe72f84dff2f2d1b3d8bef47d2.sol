1 pragma solidity 0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
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
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
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
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://eips.ethereum.org/EIPS/eip-20
70  */
71 interface IERC20 {
72     function transfer(address to, uint256 value) external returns (bool);
73 
74     function approve(address spender, uint256 value) external returns (bool);
75 
76     function transferFrom(address from, address to, uint256 value) external returns (bool);
77 
78     function totalSupply() external view returns (uint256);
79 
80     function balanceOf(address who) external view returns (uint256);
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 contract Trickle {
90     
91     using SafeMath for uint256;
92     
93     event AgreementCreated(uint256 indexed agreementId, address token, address indexed recipient, address indexed sender, uint256 start, uint256 duration, uint256 totalAmount, uint256 createdAt);
94     event AgreementCancelled(uint256 indexed agreementId, address token, address indexed recipient, address indexed sender, uint256 start, uint256 amountReleased, uint256 amountCancelled, uint256 endedAt);
95     event Withdraw(uint256 indexed agreementId, address token, address indexed recipient, address indexed sender, uint256 amountReleased, uint256 releasedAt);
96     
97     uint256 private lastAgreementId;
98     
99     struct Agreement {
100         IERC20 token;
101         address recipient;
102         address sender;
103         uint256 start;
104         uint256 duration;
105         uint256 totalAmount;
106         uint256 releasedAmount;
107         bool cancelled;
108     }
109     
110     mapping (uint256 => Agreement) private agreements;
111     
112     modifier senderOnly(uint256 agreementId) {
113         require (msg.sender == agreements[agreementId].sender);
114         _;
115     }
116     
117     function createAgreement(IERC20 token, address recipient, uint256 totalAmount, uint256 duration, uint256 start) external {
118         require(duration > 0);
119         require(totalAmount > 0);
120         require(start > 0);
121         require(token != IERC20(0x0));
122         require(recipient != address(0x0));
123         
124         uint256 agreementId = ++lastAgreementId;
125         
126         agreements[agreementId] = Agreement({
127             token: token,
128             recipient: recipient,
129             start: start,
130             duration: duration,
131             totalAmount: totalAmount,
132             sender: msg.sender,
133             releasedAmount: 0,
134             cancelled: false
135         });
136         
137         token.transferFrom(agreements[agreementId].sender, address(this), agreements[agreementId].totalAmount);
138         
139         Agreement memory record = agreements[agreementId];
140         emit AgreementCreated(
141             agreementId,
142             address(record.token),
143             record.recipient,
144             record.sender,
145             record.start,
146             record.duration,
147             record.totalAmount,
148             block.timestamp
149         );
150     }
151     
152     function getAgreement(uint256 agreementId) external view returns (
153         IERC20 token, 
154         address recipient, 
155         address sender, 
156         uint256 start, 
157         uint256 duration,
158         uint256 totalAmount,
159         uint256 releasedAmount,
160         bool cancelled
161     ) {
162         Agreement memory record = agreements[agreementId];
163         
164         return (record.token, record.recipient, record.sender, record.start, record.duration, record.totalAmount, record.releasedAmount, record.cancelled);
165     }
166     
167     function withdrawTokens(uint256 agreementId) public {
168         require(agreementId <= lastAgreementId && agreementId != 0, "Invalid agreement specified");
169 
170         Agreement storage record = agreements[agreementId];
171         
172         require(!record.cancelled);
173 
174         uint256 unreleased = withdrawAmount(agreementId);
175         require(unreleased > 0);
176 
177         record.releasedAmount = record.releasedAmount.add(unreleased);
178         record.token.transfer(record.recipient, unreleased);
179         
180         emit Withdraw(
181             agreementId,
182             address(record.token),
183             record.recipient,
184             record.sender,
185             unreleased,
186             block.timestamp
187         );
188     }
189     
190     function cancelAgreement(uint256 agreementId) senderOnly(agreementId) external {
191         Agreement storage record = agreements[agreementId];
192 
193         require(!record.cancelled);
194 
195         if (withdrawAmount(agreementId) > 0) {
196             withdrawTokens(agreementId);
197         }
198         
199         uint256 releasedAmount = record.releasedAmount;
200         uint256 cancelledAmount = record.totalAmount.sub(releasedAmount); 
201         
202         record.token.transfer(record.sender, cancelledAmount);
203         record.cancelled = true;
204         
205         emit AgreementCancelled(
206             agreementId,
207             address(record.token),
208             record.recipient,
209             record.sender,
210             record.start,
211             releasedAmount,
212             cancelledAmount,
213             block.timestamp
214         );
215     }
216     
217     function withdrawAmount (uint256 agreementId) private view returns (uint256) {
218         return availableAmount(agreementId).sub(agreements[agreementId].releasedAmount);
219     }
220     
221     function availableAmount(uint256 agreementId) private view returns (uint256) {
222         if (block.timestamp >= agreements[agreementId].start.add(agreements[agreementId].duration)) {
223             return agreements[agreementId].totalAmount;
224         } else if (block.timestamp <= agreements[agreementId].start) {
225             return 0;
226         } else {
227             return agreements[agreementId].totalAmount.mul(
228                 block.timestamp.sub(agreements[agreementId].start)
229             ).div(agreements[agreementId].duration);
230         }
231     }
232 }