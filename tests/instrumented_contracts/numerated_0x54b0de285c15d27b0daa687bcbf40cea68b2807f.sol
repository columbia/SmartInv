1 pragma solidity ^0.4.21;
2 
3 interface VaultInterface {
4 
5     event Deposited(address indexed user, address token, uint amount);
6     event Withdrawn(address indexed user, address token, uint amount);
7 
8     event Approved(address indexed user, address indexed spender);
9     event Unapproved(address indexed user, address indexed spender);
10 
11     event AddedSpender(address indexed spender);
12     event RemovedSpender(address indexed spender);
13 
14     function deposit(address token, uint amount) external payable;
15     function withdraw(address token, uint amount) external;
16     function transfer(address token, address from, address to, uint amount) external;
17     function approve(address spender) external;
18     function unapprove(address spender) external;
19     function isApproved(address user, address spender) external view returns (bool);
20     function addSpender(address spender) external;
21     function removeSpender(address spender) external;
22     function latestSpender() external view returns (address);
23     function isSpender(address spender) external view returns (bool);
24     function tokenFallback(address from, uint value, bytes data) public;
25     function balanceOf(address token, address user) public view returns (uint);
26 
27 }
28 
29 interface ERC820 {
30 
31     function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public;
32 
33 }
34 
35 library SafeMath {
36 
37     function mul(uint a, uint b) internal pure returns (uint) {
38         uint c = a * b;
39         assert(a == 0 || c / a == b);
40         return c;
41     }
42 
43     function div(uint a, uint b) internal pure returns (uint) {
44         assert(b > 0);
45         uint c = a / b;
46         assert(a == b * c + a % b);
47         return c;
48     }
49 
50     function sub(uint a, uint b) internal pure returns (uint) {
51         assert(b <= a);
52         return a - b;
53     }
54 
55     function add(uint a, uint b) internal pure returns (uint) {
56         uint c = a + b;
57         assert(c >= a);
58         return c;
59     }
60 
61     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
62         return a >= b ? a : b;
63     }
64 
65     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
66         return a < b ? a : b;
67     }
68 
69     function max256(uint a, uint b) internal pure returns (uint) {
70         return a >= b ? a : b;
71     }
72 
73     function min256(uint a, uint b) internal pure returns (uint) {
74         return a < b ? a : b;
75     }
76 }
77 
78 
79 contract Ownable {
80 
81     address public owner;
82 
83     modifier onlyOwner {
84         require(isOwner(msg.sender));
85         _;
86     }
87 
88     function Ownable() public {
89         owner = msg.sender;
90     }
91 
92     function transferOwnership(address _newOwner) public onlyOwner {
93         owner = _newOwner;
94     }
95 
96     function isOwner(address _address) public view returns (bool) {
97         return owner == _address;
98     }
99 }
100 
101 interface ERC20 {
102 
103     function totalSupply() public view returns (uint);
104     function balanceOf(address owner) public view returns (uint);
105     function allowance(address owner, address spender) public view returns (uint);
106     function transfer(address to, uint value) public returns (bool);
107     function transferFrom(address from, address to, uint value) public returns (bool);
108     function approve(address spender, uint value) public returns (bool);
109 
110 }
111 
112 interface ERC777 {
113     function name() public constant returns (string);
114     function symbol() public constant returns (string);
115     function totalSupply() public constant returns (uint256);
116     function granularity() public constant returns (uint256);
117     function balanceOf(address owner) public constant returns (uint256);
118 
119     function send(address to, uint256 amount) public;
120     function send(address to, uint256 amount, bytes userData) public;
121 
122     function authorizeOperator(address operator) public;
123     function revokeOperator(address operator) public;
124     function isOperatorFor(address operator, address tokenHolder) public constant returns (bool);
125     function operatorSend(address from, address to, uint256 amount, bytes userData, bytes operatorData) public;
126 
127 }
128 
129 contract Vault is Ownable, VaultInterface {
130 
131     using SafeMath for *;
132 
133     address constant public ETH = 0x0;
134 
135     mapping (address => bool) public isERC777;
136 
137     // user => spender => approved
138     mapping (address => mapping (address => bool)) private approved;
139     mapping (address => mapping (address => uint)) private balances;
140     mapping (address => uint) private accounted;
141     mapping (address => bool) private spenders;
142 
143     address private latest;
144 
145     modifier onlySpender {
146         require(spenders[msg.sender]);
147         _;
148     }
149 
150     modifier onlyApproved(address user) {
151         require(approved[user][msg.sender]);
152         _;
153     }
154 
155     function Vault(ERC820 registry) public {
156         // required by ERC777 standard.
157         registry.setInterfaceImplementer(address(this), keccak256("ERC777TokensRecipient"), address(this));
158     }
159 
160     /// @dev Deposits a specific token.
161     /// @param token Address of the token to deposit.
162     /// @param amount Amount of tokens to deposit.
163     function deposit(address token, uint amount) external payable {
164         require(token == ETH || msg.value == 0);
165 
166         uint value = amount;
167         if (token == ETH) {
168             value = msg.value;
169         } else {
170             require(ERC20(token).transferFrom(msg.sender, address(this), value));
171         }
172 
173         depositFor(msg.sender, token, value);
174     }
175 
176     /// @dev Withdraws a specific token.
177     /// @param token Address of the token to withdraw.
178     /// @param amount Amount of tokens to withdraw.
179     function withdraw(address token, uint amount) external {
180         require(balanceOf(token, msg.sender) >= amount);
181 
182         balances[token][msg.sender] = balances[token][msg.sender].sub(amount);
183         accounted[token] = accounted[token].sub(amount);
184 
185         withdrawTo(msg.sender, token, amount);
186 
187         emit Withdrawn(msg.sender, token, amount);
188     }
189 
190     /// @dev Approves an spender to trade balances of the sender.
191     /// @param spender Address of the spender to approve.
192     function approve(address spender) external {
193         require(spenders[spender]);
194         approved[msg.sender][spender] = true;
195         emit Approved(msg.sender, spender);
196     }
197 
198     /// @dev Unapproves an spender to trade balances of the sender.
199     /// @param spender Address of the spender to unapprove.
200     function unapprove(address spender) external {
201         approved[msg.sender][spender] = false;
202         emit Unapproved(msg.sender, spender);
203     }
204 
205     /// @dev Adds a spender.
206     /// @param spender Address of the spender.
207     function addSpender(address spender) external onlyOwner {
208         require(spender != 0x0);
209         spenders[spender] = true;
210         latest = spender;
211         emit AddedSpender(spender);
212     }
213 
214     /// @dev Removes a spender.
215     /// @param spender Address of the spender.
216     function removeSpender(address spender) external onlyOwner {
217         spenders[spender] = false;
218         emit RemovedSpender(spender);
219     }
220 
221     /// @dev Transfers balances of a token between users.
222     /// @param token Address of the token to transfer.
223     /// @param from Address of the user to transfer tokens from.
224     /// @param to Address of the user to transfer tokens to.
225     /// @param amount Amount of tokens to transfer.
226     function transfer(address token, address from, address to, uint amount) external onlySpender onlyApproved(from) {
227         // We do not check the balance here, as SafeMath will revert if sub / add fail. Due to over/underflows.
228         require(amount > 0);
229         balances[token][from] = balances[token][from].sub(amount);
230         balances[token][to] = balances[token][to].add(amount);
231     }
232 
233     /// @dev Returns if an spender has been approved by a user.
234     /// @param user Address of the user.
235     /// @param spender Address of the spender.
236     /// @return Boolean whether spender has been approved.
237     function isApproved(address user, address spender) external view returns (bool) {
238         return approved[user][spender];
239     }
240 
241     /// @dev Returns if an address has been approved as a spender.
242     /// @param spender Address of the spender.
243     /// @return Boolean whether spender has been approved.
244     function isSpender(address spender) external view returns (bool) {
245         return spenders[spender];
246     }
247 
248     function latestSpender() external view returns (address) {
249         return latest;
250     }
251 
252     function tokenFallback(address from, uint value, bytes) public {
253         depositFor(from, msg.sender, value);
254     }
255 
256     function tokensReceived(address, address from, address, uint amount, bytes, bytes) public {
257         if (!isERC777[msg.sender]) {
258             isERC777[msg.sender] = true;
259         }
260 
261         depositFor(from, msg.sender, amount);
262     }
263 
264     /// @dev Marks a token as an ERC777 token.
265     /// @param token Address of the token.
266     function setERC777(address token) public onlyOwner {
267         isERC777[token] = true;
268     }
269 
270     /// @dev Unmarks a token as an ERC777 token.
271     /// @param token Address of the token.
272     function unsetERC777(address token) public onlyOwner {
273         isERC777[token] = false;
274     }
275 
276     /// @dev Allows owner to withdraw tokens accidentally sent to the contract.
277     /// @param token Address of the token to withdraw.
278     function withdrawOverflow(address token) public onlyOwner {
279         withdrawTo(msg.sender, token, overflow(token));
280     }
281 
282     /// @dev Returns the balance of a user for a specified token.
283     /// @param token Address of the token.
284     /// @param user Address of the user.
285     /// @return Balance for the user.
286     function balanceOf(address token, address user) public view returns (uint) {
287         return balances[token][user];
288     }
289 
290     /// @dev Calculates how many tokens were accidentally sent to the contract.
291     /// @param token Address of the token to calculate for.
292     /// @return Amount of tokens not accounted for.
293     function overflow(address token) internal view returns (uint) {
294         if (token == ETH) {
295             return address(this).balance.sub(accounted[token]);
296         }
297 
298         return ERC20(token).balanceOf(this).sub(accounted[token]);
299     }
300 
301     /// @dev Accounts for token deposits.
302     /// @param user Address of the user who deposited.
303     /// @param token Address of the token deposited.
304     /// @param amount Amount of tokens deposited.
305     function depositFor(address user, address token, uint amount) private {
306         balances[token][user] = balances[token][user].add(amount);
307         accounted[token] = accounted[token].add(amount);
308         emit Deposited(user, token, amount);
309     }
310 
311     /// @dev Withdraws tokens to user.
312     /// @param user Address of the target user.
313     /// @param token Address of the token.
314     /// @param amount Amount of tokens.
315     function withdrawTo(address user, address token, uint amount) private {
316         if (token == ETH) {
317             user.transfer(amount);
318             return;
319         }
320 
321         if (isERC777[token]) {
322             ERC777(token).send(user, amount);
323             return;
324         }
325 
326         require(ERC20(token).transfer(user, amount));
327     }
328 }