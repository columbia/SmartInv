1 pragma solidity 0.4.19;
2 
3 contract DeusETH {
4     using SafeMath for uint256;
5 
6     struct Citizen {
7         uint8 state; // 1 - living tokens, 0 - dead tokens
8         address holder;
9         uint8 branch;
10         bool isExist;
11     }
12 
13     //max token supply
14     uint256 public cap = 50;
15 
16     //2592000 - it is 1 month
17     uint256 public timeWithoutUpdate = 2592000;
18 
19     //token price
20     uint256 public rate = 0.3 ether;
21 
22     // amount of raised money in wei for FundsKeeper
23     uint256 public weiRaised;
24 
25     // address where funds are collected
26     address public fundsKeeper;
27 
28     //address of Episode Manager
29     address public episodeManager;
30     bool public managerSet = false;
31 
32     //address of StockExchange
33     address stock;
34     bool public stockSet = false;
35 
36     address public owner;
37 
38     bool public started = false;
39     bool public gameOver = false;
40     bool public gameOverByUser = false;
41 
42     uint256 public totalSupply = 0;
43     uint256 public livingSupply = 0;
44 
45     mapping(uint256 => Citizen) public citizens;
46 
47     //using for userFinalize
48     uint256 public timestamp = 0;
49 
50     event TokenState(uint256 indexed id, uint8 state);
51     event TokenHolder(uint256 indexed id, address holder);
52     event TokenBranch(uint256 indexed id, uint8 branch);
53 
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     modifier onlyEpisodeManager() {
60         require(msg.sender == episodeManager);
61         _;
62     }
63 
64     function DeusETH(address _fundsKeeper) public {
65         require(_fundsKeeper != address(0));
66         owner = msg.sender;
67         fundsKeeper = _fundsKeeper;
68         timestamp = now;
69     }
70 
71     // fallback function not use to buy token
72     function () external payable {
73         revert();
74     }
75 
76     function setEpisodeManager(address _episodeManager) public onlyOwner {
77         require(!managerSet);
78         episodeManager = _episodeManager;
79         managerSet = true;
80     }
81 
82     function setStock(address _stock) public onlyOwner {
83         require(!stockSet);
84         stock = _stock;
85         stockSet = true;
86     }
87 
88     function totalSupply() public view returns (uint256) {
89         return totalSupply;
90     }
91 
92     function livingSupply() public view returns (uint256) {
93         return livingSupply;
94     }
95 
96     // low level token purchase function
97     function buyTokens(uint256 _id) public payable {
98         require(!started);
99         require(!gameOver);
100         require(!gameOverByUser);
101         require(_id > 0 && _id <= cap);
102         require(citizens[_id].isExist == false);
103 
104         require(msg.value == rate);
105         uint256 weiAmount = msg.value;
106 
107         // update weiRaised
108         weiRaised = weiRaised.add(weiAmount);
109 
110         totalSupply = totalSupply.add(1);
111         livingSupply = livingSupply.add(1);
112 
113         createCitizen(_id, msg.sender);
114         timestamp = now;
115         TokenHolder(_id, msg.sender);
116         TokenState(_id, 1);
117         TokenBranch(_id, 1);
118         forwardFunds();
119     }
120 
121     function changeState(uint256 _id, uint8 _state) public onlyEpisodeManager returns (bool) {
122         require(started);
123         require(!gameOver);
124         require(!gameOverByUser);
125         require(_id > 0 && _id <= cap);
126         require(_state <= 1);
127         require(citizens[_id].state != _state);
128 
129         citizens[_id].state = _state;
130         TokenState(_id, _state);
131         timestamp = now;
132         if (_state == 0) {
133             livingSupply--;
134         } else {
135             livingSupply++;
136         }
137 
138         return true;
139     }
140 
141     function changeHolder(uint256 _id, address _newholder) public returns (bool) {
142         require(!gameOver);
143         require(!gameOverByUser);
144         require(_id > 0 && _id <= cap);
145         require((citizens[_id].holder == msg.sender) || (stock == msg.sender));
146         require(_newholder != address(0));
147         citizens[_id].holder = _newholder;
148         TokenHolder(_id, _newholder);
149         return true;
150     }
151 
152     function changeBranch(uint256 _id, uint8 _branch) public onlyEpisodeManager returns (bool) {
153         require(started);
154         require(!gameOver);
155         require(!gameOverByUser);
156         require(_id > 0 && _id <= cap);
157         require(_branch > 0);
158         citizens[_id].branch = _branch;
159         TokenBranch(_id, _branch);
160         return true;
161     }
162 
163     function start() public onlyOwner {
164         require(!started);
165         started = true;
166     }
167 
168     function finalize() public onlyOwner {
169         require(!gameOverByUser);
170         gameOver = true;
171     }
172 
173     function userFinalize() public {
174         require(now > (timestamp + timeWithoutUpdate));
175         require(!gameOver);
176         gameOverByUser = true;
177     }
178 
179     function checkGameOver() public view returns (bool) {
180         return gameOver;
181     }
182 
183     function checkGameOverByUser() public view returns (bool) {
184         return gameOverByUser;
185     }
186 
187     function changeOwner(address _newOwner) public onlyOwner returns (bool) {
188         require(_newOwner != address(0));
189         owner = _newOwner;
190         return true;
191     }
192 
193     function getState(uint256 _id) public view returns (uint256) {
194         require(_id > 0 && _id <= cap);
195         return citizens[_id].state;
196     }
197 
198     function getHolder(uint256 _id) public view returns (address) {
199         require(_id > 0 && _id <= cap);
200         return citizens[_id].holder;
201     }
202 
203     function getNowTokenPrice() public view returns (uint256) {
204         return rate;
205     }
206 
207     function allStates() public view returns (uint256[], address[], uint256[]) {
208         uint256[] memory a = new uint256[](50);
209         address[] memory b = new address[](50);
210         uint256[] memory c = new uint256[](50);
211 
212         for (uint i = 0; i < a.length; i++) {
213             a[i] = citizens[i+1].state;
214             b[i] = citizens[i+1].holder;
215             c[i] = citizens[i+1].branch;
216         }
217 
218         return (a, b, c);
219     }
220 
221     // send ether to the fund collection wallet
222     // override to create custom fund forwarding mechanisms
223     function forwardFunds() internal {
224         fundsKeeper.transfer(msg.value);
225     }
226 
227     function createCitizen(uint256 _id, address _holder) internal returns (uint256) {
228         require(!started);
229         require(_id > 0 && _id <= cap);
230         require(_holder != address(0));
231         citizens[_id].state = 1;
232         citizens[_id].holder = _holder;
233         citizens[_id].branch = 1;
234         citizens[_id].isExist = true;
235         return _id;
236     }
237 }
238 
239 
240 library SafeMath {
241     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
242         uint256 c = a * b;
243         assert(a == 0 || c / a == b);
244         return c;
245     }
246 
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         uint256 c = a / b;
249         return c;
250     }
251 
252     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
253         assert(b <= a);
254         return a - b;
255     }
256 
257     function add(uint256 a, uint256 b) internal pure returns (uint256) {
258         uint256 c = a + b;
259         assert(c >= a);
260         return c;
261     }
262 }