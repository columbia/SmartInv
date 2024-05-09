1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.11;
3 
4 interface IERC20 {
5     function transfer(address to, uint256 amount) external returns (bool);
6 
7     function transferFrom(
8         address from,
9         address to,
10         uint256 amount
11     ) external returns (bool);
12 
13     function balanceOf(address account) external view returns (uint256);
14 
15     function decimals() external view returns (uint8);
16 }
17 
18 library SafeMath {
19     function tryAdd(
20         uint256 a,
21         uint256 b
22     ) internal pure returns (bool, uint256) {
23         unchecked {
24             uint256 c = a + b;
25             if (c < a) return (false, 0);
26             return (true, c);
27         }
28     }
29 
30     function trySub(
31         uint256 a,
32         uint256 b
33     ) internal pure returns (bool, uint256) {
34         unchecked {
35             if (b > a) return (false, 0);
36             return (true, a - b);
37         }
38     }
39 
40     function tryMul(
41         uint256 a,
42         uint256 b
43     ) internal pure returns (bool, uint256) {
44         unchecked {
45             if (a == 0) return (true, 0);
46             uint256 c = a * b;
47             if (c / a != b) return (false, 0);
48             return (true, c);
49         }
50     }
51 
52     function tryDiv(
53         uint256 a,
54         uint256 b
55     ) internal pure returns (bool, uint256) {
56         unchecked {
57             if (b == 0) return (false, 0);
58             return (true, a / b);
59         }
60     }
61 
62     function tryMod(
63         uint256 a,
64         uint256 b
65     ) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a % b);
69         }
70     }
71 
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         return a + b;
74     }
75 
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a - b;
78     }
79 
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         return a * b;
82     }
83 
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return a / b;
86     }
87 
88     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89         return a % b;
90     }
91 
92     function sub(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         unchecked {
98             require(b <= a, errorMessage);
99             return a - b;
100         }
101     }
102 
103     function div(
104         uint256 a,
105         uint256 b,
106         string memory errorMessage
107     ) internal pure returns (uint256) {
108         unchecked {
109             require(b > 0, errorMessage);
110             return a / b;
111         }
112     }
113 
114     function mod(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         unchecked {
120             require(b > 0, errorMessage);
121             return a % b;
122         }
123     }
124 }
125 
126 abstract contract Ownable {
127     address private _owner;
128     mapping(address => bool) public contractAccess;
129 
130     event OwnershipTransferred(address _previousOwner, address _newOwner);
131 
132     constructor() {
133         _owner = msg.sender;
134     }
135 
136     function owner() public view returns (address) {
137         return _owner;
138     }
139 
140     modifier onlyOwner() {
141         require(msg.sender == _owner);
142         _;
143     }
144 
145     function transferOwnership(address _newOwner) public virtual onlyOwner {
146         require(
147             _newOwner != address(0),
148             "Ownable: new owner is the zero address"
149         );
150         address previousOwner = _owner;
151         _owner = _newOwner;
152 
153         _afterTransferOwnership(previousOwner, _newOwner);
154 
155         emit OwnershipTransferred(previousOwner, _newOwner);
156     }
157 
158     function renounceOwnership() public virtual onlyOwner {
159         emit OwnershipTransferred(_owner, address(0));
160         _owner = address(0);
161     }
162 
163     function _afterTransferOwnership(
164         address _previousOwner,
165         address _newOwner
166     ) internal virtual {}
167 }
168 
169 contract JBMigration is Ownable {
170     using SafeMath for uint256;
171 
172     IERC20 private V1Token;
173     IERC20 private V2Token;
174     uint256 private exchangeRate;
175     bool private canClaim = false;
176     mapping(address => uint256) private depositedV1Tokens;
177     mapping(address => uint256) private claimedV2Tokens;
178 
179     event DepositV1Tokens(address _user, uint256 _v1TokenAmount);
180     event ClaimV2Tokens(address _user, uint256 _tokenAmount);
181 
182     event WithdrawTokens(
183         address _user,
184         address _tokenAddress,
185         uint256 _tokenAmount
186     );
187 
188     constructor(
189         address _v1TokenAddress,
190         address _v2TokenAddress,
191         uint256 _exchangeRate
192     ) {
193         V1Token = IERC20(_v1TokenAddress);
194         V2Token = IERC20(_v2TokenAddress);
195         exchangeRate = _exchangeRate;
196     }
197 
198     function depositV1Tokens(uint256 _v1TokenAmount) external {
199         address user = msg.sender;
200         depositedV1Tokens[user] = depositedV1Tokens[user].add(_v1TokenAmount);
201         V1Token.transferFrom(user, address(this), _v1TokenAmount);
202 
203         emit DepositV1Tokens(user, _v1TokenAmount);
204     }
205 
206     function claimV2Tokens() external {
207         require(canClaim, "Claim is paused");
208         address user = msg.sender;
209 
210         uint256 totalDepositedV1Tokens = depositedV1Tokens[user];
211         uint256 totalClaimedV2Tokens = claimedV2Tokens[user];
212 
213         uint256 claimableV2Tokens = totalDepositedV1Tokens
214             .mul(exchangeRate)
215             .sub(totalClaimedV2Tokens);
216 
217         require(claimableV2Tokens > 0, "No claimable tokens");
218 
219         claimedV2Tokens[user] = claimedV2Tokens[user].add(claimableV2Tokens);
220 
221         V2Token.transfer(user, claimableV2Tokens);
222 
223         emit ClaimV2Tokens(user, claimableV2Tokens);
224     }
225 
226     function withdrawV1Tokens() external onlyOwner {
227         address user = msg.sender;
228         uint256 v1TokenContractBalance = getV1TokenContractBalance();
229         V1Token.transfer(user, v1TokenContractBalance);
230 
231         emit WithdrawTokens(user, address(V1Token), v1TokenContractBalance);
232     }
233 
234     function withdrawV2Tokens() external onlyOwner {
235         address user = msg.sender;
236         uint256 v2TokenContractBalance = getV2TokenContractBalance();
237         V2Token.transfer(user, v2TokenContractBalance);
238 
239         emit WithdrawTokens(user, address(V2Token), v2TokenContractBalance);
240     }
241 
242     function withdrawAnyTokens(address _tokenAddress) external onlyOwner {
243         address user = msg.sender;
244         IERC20 token = IERC20(_tokenAddress);
245         uint256 tokenContractBalance = token.balanceOf(address(this));
246         token.transfer(user, tokenContractBalance);
247 
248         emit WithdrawTokens(user, _tokenAddress, tokenContractBalance);
249     }
250 
251     function setClaimStatus(bool _onoff) external onlyOwner {
252         require(canClaim != _onoff);
253         canClaim = _onoff;
254     }
255 
256     function setV2TokenAddress(address _v2TokenAddress) external onlyOwner {
257         require(address(V2Token) != _v2TokenAddress);
258         V2Token = IERC20(_v2TokenAddress);
259     }
260 
261     function getV1TokenContractBalance() public view returns (uint256) {
262         return V1Token.balanceOf(address(this));
263     }
264 
265     function getV2TokenContractBalance() public view returns (uint256) {
266         return V2Token.balanceOf(address(this));
267     }
268 
269     function getUserData(
270         address _user
271     ) external view returns (uint256, uint256, uint256, bool) {
272         uint256 totalDepositedV1Tokens = depositedV1Tokens[_user];
273         uint256 totalClaimedV2Tokens = claimedV2Tokens[_user];
274 
275         uint256 claimableV2Tokens = totalDepositedV1Tokens
276             .mul(exchangeRate)
277             .sub(totalClaimedV2Tokens);
278 
279         return (
280             totalDepositedV1Tokens,
281             totalClaimedV2Tokens,
282             claimableV2Tokens,
283             canClaim
284         );
285     }
286 }