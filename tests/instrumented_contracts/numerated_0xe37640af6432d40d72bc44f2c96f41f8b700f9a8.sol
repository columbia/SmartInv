1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 contract Ethage {
5 
6     struct User {
7         uint128 mtx3Block;
8         uint128 mtx6Block;
9         address parent;
10     }
11 
12     uint128 public constant NO_OF_BLOCKS = 12;
13 
14     mapping(address => User) public users;
15 
16     mapping(uint256 => uint256) public blockPriceMtx3;
17     mapping(uint256 => uint256) public blockPriceMtx6;
18 
19     address owner;
20     address ai;
21     uint public aiGasCode = 0.009 ether;
22 
23     event Registration(address indexed user, address indexed referrer);
24     event Upgrade(address indexed user, uint256 matrix, uint256 blockLevel);
25 
26     constructor(address ownerAddress, address a, address b, address c, address d, address e) public {
27 
28         blockPriceMtx3[1] = 0.03 ether;
29         blockPriceMtx3[2] = 0.06 ether;
30         blockPriceMtx3[3] = 0.12 ether;
31         blockPriceMtx3[4] = 0.24 ether;
32         blockPriceMtx3[5] = 0.5 ether;
33         blockPriceMtx3[6] = 1.0 ether;
34         blockPriceMtx3[7] = 2.0 ether;
35         blockPriceMtx3[8] = 4.0 ether;
36         blockPriceMtx3[9] = 8.0 ether;
37         blockPriceMtx3[10] = 16.0 ether;
38         blockPriceMtx3[11] = 32.0 ether;
39         blockPriceMtx3[12] = 64.0 ether;
40 
41         blockPriceMtx6[1] = 0.02 ether;
42         blockPriceMtx6[2] = 0.06 ether;
43         blockPriceMtx6[3] = 0.12 ether;
44         blockPriceMtx6[4] = 0.24 ether;
45         blockPriceMtx6[5] = 0.5 ether;
46         blockPriceMtx6[6] = 1.0 ether;
47         blockPriceMtx6[7] = 2.0 ether;
48         blockPriceMtx6[8] = 4.0 ether;
49         blockPriceMtx6[9] = 8.0 ether;
50         blockPriceMtx6[10] = 16.0 ether;
51         blockPriceMtx6[11] = 32.0 ether;
52         blockPriceMtx6[12] = 64.0 ether;
53 
54 
55         ai = msg.sender;
56         owner = ownerAddress;
57 
58         User memory user = User({
59             mtx3Block : NO_OF_BLOCKS,
60             mtx6Block : NO_OF_BLOCKS,
61             parent : address(0)
62             });
63 
64         users[ownerAddress] = user;
65 
66         init(a, b, c, d, e);
67     }
68 
69     function safeAdd(uint a, uint b) private pure returns (uint) {
70         uint c = a + b;
71         assert(c >= a && c >= b);
72         return c;
73     }
74 
75     modifier onlyAiRelay {
76         require(
77             msg.sender == ai,
78             "Only Ai Relay can call this function."
79         );
80         _;
81     }
82 
83     function isUserExists(address user) public view returns (bool) {
84         return (users[user].mtx3Block != 0);
85     }
86 
87     function init(address a, address b, address c, address d, address e) private {
88         User memory userA = User({
89             mtx3Block : NO_OF_BLOCKS,
90             mtx6Block : NO_OF_BLOCKS,
91             parent : owner
92             });
93 
94         users[a] = userA;
95 
96         User memory userB = User({
97             mtx3Block : NO_OF_BLOCKS,
98             mtx6Block : NO_OF_BLOCKS,
99             parent : owner
100             });
101 
102         users[b] = userB;
103 
104         User memory userC = User({
105             mtx3Block : NO_OF_BLOCKS,
106             mtx6Block : NO_OF_BLOCKS,
107             parent : a
108             });
109 
110         users[c] = userC;
111 
112         User memory userD = User({
113             mtx3Block : NO_OF_BLOCKS,
114             mtx6Block : NO_OF_BLOCKS,
115             parent : a
116             });
117 
118         users[d] = userD;
119 
120         User memory userE = User({
121             mtx3Block : NO_OF_BLOCKS,
122             mtx6Block : NO_OF_BLOCKS,
123             parent : b
124             });
125 
126         users[e] = userE;
127     }
128 
129     function nextAvailableBlockMtx3(uint256 blockLevel) public view returns (bool){
130         uint256 nextAvailable = users[msg.sender].mtx3Block + 1;
131         return (nextAvailable == blockLevel);
132     }
133 
134     function nextAvailableBlockMtx6(uint256 blockLevel) public view returns (bool){
135         uint256 nextAvailable = users[msg.sender].mtx6Block + 1;
136         return (nextAvailable == blockLevel);
137     }
138 
139 
140     function signUp(address referrerAddress) external payable {
141         require(msg.value == safeAdd(0.05 ether, aiGasCode), "sign up cost 0.05 + AI Price");
142         require(isUserExists(referrerAddress), "referrer not exists");
143         require(!isUserExists(msg.sender), "user exists");
144 
145         User memory user = User({
146             mtx3Block : 1,
147             mtx6Block : 1,
148             parent : referrerAddress
149             });
150 
151         users[msg.sender] = user;
152         emit Registration(msg.sender, referrerAddress);
153 
154         if (!address(uint160(ai)).send(aiGasCode)) {
155             address(uint160(ai)).transfer(aiGasCode);
156         }
157 
158     }
159 
160     function purchaseMtx3(uint256 blockLevel) external payable {
161         require(isUserExists(msg.sender), "user is not exists. Sign Up first.");
162         require(msg.value == safeAdd(blockPriceMtx3[blockLevel], aiGasCode), "invalid price");
163         require(blockLevel > 1 && blockLevel <= NO_OF_BLOCKS, 'invalid block');
164         require(nextAvailableBlockMtx3(blockLevel), "invalid block");
165 
166         users[msg.sender].mtx3Block++;
167         emit Upgrade(msg.sender, 1, blockLevel);
168 
169         if (!address(uint160(ai)).send(aiGasCode)) {
170             address(uint160(ai)).transfer(aiGasCode);
171         }
172     }
173 
174     function purchaseMtx6(uint256 blockLevel) external payable {
175         require(isUserExists(msg.sender), "user is not exists. Sign Up first.");
176         uint requiredPrice = safeAdd(blockPriceMtx6[blockLevel], aiGasCode);
177         require(msg.value == requiredPrice, "invalid price");
178         require(blockLevel > 1 && blockLevel <= NO_OF_BLOCKS, 'invalid block');
179         require(nextAvailableBlockMtx6(blockLevel), "invalid block");
180 
181         users[msg.sender].mtx6Block++;
182         emit Upgrade(msg.sender, 2, blockLevel);
183 
184         if (!address(uint160(ai)).send(aiGasCode)) {
185             address(uint160(ai)).transfer(aiGasCode);
186         }
187 
188     }
189 
190     function signUpDividend(address mtx3Receiver, address mtx6Receiver, uint8 nonce) public onlyAiRelay {
191         require(isUserExists(mtx3Receiver), "mtx3Receiver does not exist.");
192         require(isUserExists(mtx6Receiver), "mtx6Receiver does not exist.");
193         require(nonce > 0, "invalid nonce");
194         if (!address(uint160(mtx3Receiver)).send(blockPriceMtx3[1])) {
195             address(uint160(mtx3Receiver)).transfer(blockPriceMtx3[1]);
196         }
197 
198         if (!address(uint160(mtx6Receiver)).send(blockPriceMtx6[1])) {
199             address(uint160(mtx6Receiver)).transfer(blockPriceMtx6[1]);
200         }
201     }
202 
203 
204     function dividend(address receiver, uint matrix, uint blockLevel, uint8 nonce) public onlyAiRelay {
205         require(isUserExists(receiver), "receiver does not exist.");
206         require(matrix == 1 || matrix == 2, "invalid matrix");
207         require(nonce > 0, "invalid nonce");
208         if (matrix == 1) {
209             sendDividendMtx3(receiver, blockLevel);
210         } else {
211             sendDividendMtx6(receiver, blockLevel);
212         }
213 
214     }
215 
216     function usersActiveX3Block(address userAddress, uint8 level) public view returns (bool) {
217         return users[userAddress].mtx3Block >= level;
218     }
219 
220     function usersActiveX6Block(address userAddress, uint8 level) public view returns (bool) {
221         return users[userAddress].mtx6Block >= level;
222     }
223 
224     function getUser(address userAddress) public view returns (uint128, uint128, address) {
225         return (users[userAddress].mtx3Block,
226         users[userAddress].mtx6Block,
227         users[userAddress].parent);
228     }
229 
230     function sendDividendMtx3(address receiver, uint blockLevel) private {
231         if (!address(uint160(receiver)).send(blockPriceMtx3[blockLevel])) {
232             address(uint160(receiver)).transfer(blockPriceMtx3[blockLevel]);
233         }
234     }
235 
236     function sendDividendMtx6(address receiver, uint blockLevel) private {
237         if (!address(uint160(receiver)).send(blockPriceMtx6[blockLevel])) {
238             address(uint160(receiver)).transfer(blockPriceMtx6[blockLevel]);
239         }
240     }
241 
242     function updateAiGasCode(uint gas) public onlyAiRelay {
243         aiGasCode = gas;
244     }
245 
246     function updateAiAggregator(address aiProvider) public onlyAiRelay {
247         ai = aiProvider;
248     }
249 }