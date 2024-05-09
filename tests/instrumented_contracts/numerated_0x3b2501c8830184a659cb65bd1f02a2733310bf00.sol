1 pragma solidity 0.4.19;
2 
3 
4 contract DeusETH {
5     using SafeMath for uint256;
6 
7     struct Citizen {
8         uint8 state; // 1 - living tokens, 0 - dead tokens
9         address holder;
10         uint8 branch;
11         bool isExist;
12     }
13 
14     //max token supply
15     uint256 public cap = 50;
16 
17     //2592000 - it is 1 month
18     uint256 public timeWithoutUpdate = 2592000;
19 
20     //token price
21     uint256 public rate = 1 ether;
22 
23     // amount of raised money in wei for FundsKeeper
24     uint256 public weiRaised;
25 
26     // address where funds are collected
27     address public fundsKeeper;
28 
29     //address of Episode Manager
30     address public episodeManager;
31     bool public managerSet = false;
32 
33     address public owner;
34 
35     bool public started = false;
36     bool public gameOver = false;
37     bool public gameOverByUser = false;
38 
39     uint256 public totalSupply = 0;
40     uint256 public livingSupply = 0;
41 
42     mapping(uint256 => Citizen) public citizens;
43 
44     //using for userFinalize
45     uint256 public timestamp = 0;
46 
47     event TokenState(uint256 indexed id, uint8 state);
48     event TokenHolder(uint256 indexed id, address holder);
49     event TokenBranch(uint256 indexed id, uint8 branch);
50 
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     modifier onlyEpisodeManager() {
57         require(msg.sender == episodeManager);
58         _;
59     }
60 
61     function DeusETH(address _fundsKeeper) public {
62         require(_fundsKeeper != address(0));
63         owner = msg.sender;
64         fundsKeeper = _fundsKeeper;
65         timestamp = now;
66     }
67 
68     // fallback function not use to buy token
69     function () external payable {
70         revert();
71     }
72 
73     function setEpisodeManager(address _episodeManager) public onlyOwner {
74         require(!managerSet);
75         episodeManager = _episodeManager;
76         managerSet = true;
77     }
78 
79     function totalSupply() public view returns (uint256) {
80         return totalSupply;
81     }
82 
83     function livingSupply() public view returns (uint256) {
84         return livingSupply;
85     }
86 
87     // low level token purchase function
88     function buyTokens(uint256 _id, address _holder) public payable {
89         require(!started);
90         require(!gameOver);
91         require(!gameOverByUser);
92         require(_id > 0 && _id <= cap);
93         require(citizens[_id].isExist == false);
94         require(_holder != address(0));
95 
96         require(msg.value == rate);
97 
98         uint256 weiAmount = msg.value;
99 
100         // update weiRaised
101         weiRaised = weiRaised.add(weiAmount);
102 
103         totalSupply = totalSupply.add(1);
104         livingSupply = livingSupply.add(1);
105 
106         createCitizen(_id, _holder);
107         timestamp = now;
108         TokenHolder(_id, _holder);
109         TokenState(_id, 1);
110         TokenBranch(_id, 1);
111 
112         forwardFunds();
113     }
114 
115     function changeState(uint256 _id, uint8 _state) public onlyEpisodeManager returns (bool) {
116         require(started);
117         require(!gameOver);
118         require(!gameOverByUser);
119         require(_id > 0 && _id <= cap);
120         require(_state <= 1);
121         require(citizens[_id].state != _state);
122 
123         citizens[_id].state = _state;
124         TokenState(_id, _state);
125         timestamp = now;
126         if (_state == 0) {
127             livingSupply--;
128         } else {
129             livingSupply++;
130         }
131 
132         return true;
133     }
134 
135     function changeHolder(uint256 _id, address _newholder) public returns (bool) {
136         require(!gameOver);
137         require(!gameOverByUser);
138         require(_id > 0 && _id <= cap);
139         require(citizens[_id].holder == msg.sender);
140         require(_newholder != address(0));
141         citizens[_id].holder = _newholder;
142         TokenHolder(_id, _newholder);
143         return true;
144     }
145 
146     function changeBranch(uint256 _id, uint8 _branch) public onlyEpisodeManager returns (bool) {
147         require(started);
148         require(!gameOver);
149         require(!gameOverByUser);
150         require(_id > 0 && _id <= cap);
151         require(_branch > 0);
152         citizens[_id].branch = _branch;
153         TokenBranch(_id, _branch);
154         return true;
155     }
156 
157     function start() public onlyOwner {
158         started = true;
159     }
160 
161     function finalize() public onlyOwner {
162         require(!gameOverByUser);
163         gameOver = true;
164     }
165 
166     function userFinalize() public {
167         require(now > (timestamp + timeWithoutUpdate));
168         require(!gameOver);
169         gameOverByUser = true;
170     }
171 
172     function checkGameOver() public view returns (bool) {
173         return gameOver;
174     }
175 
176     function checkGameOverByUser() public view returns (bool) {
177         return gameOverByUser;
178     }
179 
180     function changeOwner(address _newOwner) public onlyOwner returns (bool) {
181         require(_newOwner != address(0));
182         owner = _newOwner;
183         return true;
184     }
185 
186     function getState(uint256 _id) public view returns (uint256) {
187         require(_id > 0 && _id <= cap);
188         return citizens[_id].state;
189     }
190 
191     function getHolder(uint256 _id) public view returns (address) {
192         require(_id > 0 && _id <= cap);
193         return citizens[_id].holder;
194     }
195 
196     function getNowTokenPrice() public view returns (uint256) {
197         return rate;
198     }
199 
200     function forwardFunds() internal {
201         fundsKeeper.transfer(msg.value);
202     }
203 
204     function createCitizen(uint256 _id, address _holder) internal returns (uint256) {
205         require(!started);
206         require(_id > 0 && _id <= cap);
207         require(_holder != address(0));
208         citizens[_id].state = 1;
209         citizens[_id].holder = _holder;
210         citizens[_id].branch = 1;
211         citizens[_id].isExist = true;
212         return _id;
213     }
214 }
215 
216 
217 library SafeMath {
218     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
219         uint256 c = a * b;
220         assert(a == 0 || c / a == b);
221         return c;
222     }
223 
224     function div(uint256 a, uint256 b) internal pure returns (uint256) {
225         uint256 c = a / b;
226         return c;
227     }
228 
229     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
230         assert(b <= a);
231         return a - b;
232     }
233 
234     function add(uint256 a, uint256 b) internal pure returns (uint256) {
235         uint256 c = a + b;
236         assert(c >= a);
237         return c;
238     }
239 }