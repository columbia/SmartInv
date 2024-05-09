1 pragma solidity ^0.5.0;
2 
3 // From file: openzeppelin-contracts/contracts/math/SafeMath.sol 
4 library SafeMath {
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8         return c;
9     }
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         require(b <= a, "SafeMath: subtraction overflow");
12         uint256 c = a - b;
13         return c;
14     }
15 }
16 
17 // From file: openzeppelin-contracts/contracts/utils/Address.sol 
18 library Address {
19     function isContract(address account) internal view returns (bool) {
20         uint256 size;
21         assembly { size := extcodesize(account) }
22         return size > 0;
23     }
24 }
25 
26 // File: openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol 
27 library SafeERC20 {
28     using SafeMath for uint256;
29     using Address for address;
30 
31     function safeTransfer(IERC20 token, address to, uint256 value) internal {
32         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
33     }
34 
35     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
36         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
37     }
38 
39     function safeApprove(IERC20 token, address spender, uint256 value) internal {
40         require((value == 0) || (token.allowance(address(this), spender) == 0),
41             "SafeERC20: approve from non-zero to non-zero allowance"
42         );
43         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
44     }
45 
46     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
47         uint256 newAllowance = token.allowance(address(this), spender).add(value);
48         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
49     }
50 
51     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
52         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
53         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
54     }
55 
56     function callOptionalReturn(IERC20 token, bytes memory data) private {
57         require(address(token).isContract(), "SafeERC20: call to non-contract");
58 
59         (bool success, bytes memory returndata) = address(token).call(data);
60         require(success, "SafeERC20: low-level call failed");
61 
62         if (returndata.length > 0) {
63             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
64         }
65     }
66 }
67 
68 // File: openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
69 interface IERC20 {
70     function totalSupply() external view returns (uint256);
71     function balanceOf(address account) external view returns (uint256);
72     function transfer(address recipient, uint256 amount) external returns (bool);
73     function allowance(address owner, address spender) external view returns (uint256);
74     function approve(address spender, uint256 amount) external returns (bool);
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol 
81 contract ReentrancyGuard {
82     bool private _notEntered;
83 
84     constructor () internal {
85         _notEntered = true;
86     }
87 
88     modifier nonReentrant() {
89         require(_notEntered, "ReentrancyGuard: reentrant call");
90         _notEntered = false;
91         _;
92         _notEntered = true;
93     }
94 }
95 
96 contract AtomicSwap is ReentrancyGuard {
97     using SafeMath for uint;
98     using SafeERC20 for IERC20;
99 
100     enum State { Empty, Initiated, Redeemed, Refunded }
101 
102     struct Swap {
103         bytes32 hashedSecret;
104         bytes32 secret;
105         address contractAddr;
106         address participant;
107         address payable initiator;
108         uint refundTimestamp;
109         uint countdown;
110         uint value;
111         uint payoff;
112         bool active;
113         State state;
114     }
115     
116     event Initiated(
117         bytes32 indexed _hashedSecret,
118         address indexed _contract,
119         address indexed _participant,
120         address _initiator,
121         uint _refundTimestamp,
122         uint _countdown,
123         uint _value,
124         uint _payoff,
125         bool _active
126     );
127     event Added(
128         bytes32 indexed _hashedSecret,
129         address _sender,
130         uint _value  
131     );
132     event Activated(
133         bytes32 indexed _hashedSecret
134     );
135     event Redeemed(
136         bytes32 indexed _hashedSecret,
137         bytes32 _secret
138     );
139     event Refunded(
140         bytes32 indexed _hashedSecret
141     );
142 
143     mapping(bytes32 => Swap) public swaps;
144 
145     modifier onlyByInitiator(bytes32 _hashedSecret) {
146         require(msg.sender == swaps[_hashedSecret].initiator, "sender is not the initiator");
147         _;
148     }
149 
150     modifier isInitiatable(bytes32 _hashedSecret, address _participant, uint _refundTimestamp, uint _countdown) {
151         require(_participant != address(0), "invalid participant address");
152         require(swaps[_hashedSecret].state == State.Empty, "swap for this hash is initiated");
153         require(block.timestamp <= _refundTimestamp, "invalid refundTimestamp");
154         require(_countdown < _refundTimestamp, "invalid countdown");
155         _;
156     }
157     
158     modifier isInitiated(bytes32 _hashedSecret) {
159         require(swaps[_hashedSecret].state == State.Initiated, "swap for this hash is empty or spent");
160         _;
161     }
162 
163     modifier isAddable(bytes32 _hashedSecret) {
164         require(block.timestamp <= swaps[_hashedSecret].refundTimestamp, "refundTimestamp has come");
165         _;
166     }
167         
168     modifier isActivated(bytes32 _hashedSecret) {
169         require(swaps[_hashedSecret].active, "swap is not active");
170         _;
171     }    
172     
173     modifier isNotActivated(bytes32 _hashedSecret) {
174         require(!swaps[_hashedSecret].active, "swap is active");
175         _;
176     }
177 
178     modifier isRedeemable(bytes32 _hashedSecret, bytes32 _secret) {
179         require(block.timestamp <= swaps[_hashedSecret].refundTimestamp, "refundTimestamp has come");
180         require(sha256(abi.encodePacked(sha256(abi.encodePacked(_secret)))) == _hashedSecret, "secret is not correct");
181         _;
182     }
183 
184     modifier isRefundable(bytes32 _hashedSecret) {
185         require(block.timestamp > swaps[_hashedSecret].refundTimestamp, "refundTimestamp has not come");
186         _;
187     }
188 
189     function initiate (bytes32 _hashedSecret, address _contract, address _participant, uint _refundTimestamp, uint _countdown, uint _value, uint _payoff, bool _active)
190         public nonReentrant isInitiatable(_hashedSecret, _participant, _refundTimestamp, _countdown)
191     {
192         IERC20(_contract).safeTransferFrom(msg.sender, address(this), _value);
193 
194         swaps[_hashedSecret].value = _value.sub(_payoff);
195         swaps[_hashedSecret].hashedSecret = _hashedSecret;
196         swaps[_hashedSecret].contractAddr = _contract;
197         swaps[_hashedSecret].participant = _participant;
198         swaps[_hashedSecret].initiator = msg.sender;
199         swaps[_hashedSecret].refundTimestamp = _refundTimestamp;
200         swaps[_hashedSecret].countdown = _countdown;
201         swaps[_hashedSecret].payoff = _payoff;
202         swaps[_hashedSecret].active = _active;
203         swaps[_hashedSecret].state = State.Initiated;
204 
205         emit Initiated(
206             _hashedSecret,
207             _contract,
208             _participant,
209             msg.sender,
210             _refundTimestamp,
211             _countdown,
212             _value.sub(_payoff),
213             _payoff,
214             _active
215         );
216     }
217     
218     function add (bytes32 _hashedSecret, uint _value)
219         public nonReentrant isInitiated(_hashedSecret) isAddable(_hashedSecret)    
220     {
221         IERC20(swaps[_hashedSecret].contractAddr).safeTransferFrom(msg.sender, address(this), _value);
222         
223         swaps[_hashedSecret].value = swaps[_hashedSecret].value.add(_value);
224 
225         emit Added(
226             _hashedSecret,
227             msg.sender,
228             swaps[_hashedSecret].value
229         );
230     }
231     
232     function activate (bytes32 _hashedSecret)
233         public nonReentrant isInitiated(_hashedSecret) isNotActivated(_hashedSecret) onlyByInitiator(_hashedSecret)
234     {
235         swaps[_hashedSecret].active = true;
236 
237         emit Activated(
238             _hashedSecret
239         );
240     }
241 
242     function redeem(bytes32 _hashedSecret, bytes32 _secret) 
243         public nonReentrant isInitiated(_hashedSecret) isActivated(_hashedSecret) isRedeemable(_hashedSecret, _secret) 
244     {
245         swaps[_hashedSecret].secret = _secret;
246         swaps[_hashedSecret].state = State.Redeemed;
247 
248         if (block.timestamp > swaps[_hashedSecret].refundTimestamp.sub(swaps[_hashedSecret].countdown)) {
249             
250             IERC20(swaps[_hashedSecret].contractAddr).safeTransfer(swaps[_hashedSecret].participant, swaps[_hashedSecret].value);
251             
252             if(swaps[_hashedSecret].payoff > 0) {
253                 IERC20(swaps[_hashedSecret].contractAddr).safeTransfer(msg.sender, swaps[_hashedSecret].payoff);
254             }
255         }
256         else {
257             IERC20(swaps[_hashedSecret].contractAddr).safeTransfer(swaps[_hashedSecret].participant, swaps[_hashedSecret].value.add(swaps[_hashedSecret].payoff));
258         }
259         
260         emit Redeemed(
261             _hashedSecret,
262             _secret
263         );
264         
265         delete swaps[_hashedSecret];
266     }
267 
268     function refund(bytes32 _hashedSecret)
269         public nonReentrant isInitiated(_hashedSecret) isRefundable(_hashedSecret) 
270     {
271         swaps[_hashedSecret].state = State.Refunded;
272 
273         IERC20(swaps[_hashedSecret].contractAddr).safeTransfer(swaps[_hashedSecret].initiator, swaps[_hashedSecret].value.add(swaps[_hashedSecret].payoff));
274 
275         emit Refunded(
276             _hashedSecret
277         );
278         
279         delete swaps[_hashedSecret];
280     }
281 }