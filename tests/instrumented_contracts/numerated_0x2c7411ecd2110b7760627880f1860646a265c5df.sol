1 pragma solidity 0.4.19;
2 
3 
4 contract DeusETH {
5     using SafeMath for uint256;
6 
7     enum Stages {
8         Create,
9         InitForMigrate,
10         InitForAll,
11         Start,
12         Finish
13     }
14 
15     // This is the current stage.
16     Stages public stage;
17 
18     struct Citizen {
19         uint8 state; // 1 - living tokens, 0 - dead tokens
20         address holder;
21         uint8 branch;
22         bool isExist;
23     }
24 
25     //max token supply
26     uint256 public cap = 50;
27 
28     //2592000 - it is 1 month
29     uint256 public timeWithoutUpdate = 2592000;
30 
31     //token price
32     uint256 public rate = 0;
33 
34     // amount of raised money in wei for FundsKeeper
35     uint256 public weiRaised;
36 
37     // address where funds are collected
38     address public fundsKeeper;
39 
40     //address of Episode Manager
41     address public episodeManager;
42 
43     //address of StockExchange
44     address public stock;
45     bool public stockSet = false;
46 
47     address public migrate;
48     bool public migrateSet = false;
49 
50     address public owner;
51 
52     bool public started = false;
53     bool public gameOver = false;
54     bool public gameOverByUser = false;
55 
56     uint256 public totalSupply = 0;
57     uint256 public livingSupply = 0;
58 
59     mapping(uint256 => Citizen) public citizens;
60 
61     //using for userFinalize
62     uint256 public timestamp = 0;
63 
64     event TokenState(uint256 indexed id, uint8 state);
65     event TokenHolder(uint256 indexed id, address holder);
66     event TokenBranch(uint256 indexed id, uint8 branch);
67 
68     modifier onlyOwner() {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     modifier onlyEpisodeManager() {
74         require(msg.sender == episodeManager);
75         _;
76     }
77 
78     function DeusETH(address _fundsKeeper) public {
79         require(_fundsKeeper != address(0));
80         owner = msg.sender;
81         fundsKeeper = _fundsKeeper;
82         timestamp = now;
83         stage = Stages.Create;
84     }
85 
86     // fallback function not use to buy token
87     function () external payable {
88         revert();
89     }
90 
91     function setEpisodeManager(address _episodeManager) public onlyOwner returns (bool) {
92         episodeManager = _episodeManager;
93         return true;
94     }
95 
96     function setStock(address _stock) public onlyOwner returns (bool) {
97         require(!stockSet);
98         require(_stock != address(0));
99         stock = _stock;
100         stockSet = true;
101         return true;
102     }
103 
104     //For test only
105     function changeStock(address _stock) public onlyOwner {
106         stock = _stock;
107     }
108 
109     function setMigrate(address _migrate) public onlyOwner {
110         require(!migrateSet);
111         require(_migrate != address(0));
112         migrate = _migrate;
113         migrateSet = true;
114     }
115 
116     //For test only
117     function changeMigrate(address _migrate) public onlyOwner {
118         migrate = _migrate;
119     }
120 
121     //For test only
122     function changeFundsKeeper(address _fundsKeeper) public onlyOwner {
123         fundsKeeper = _fundsKeeper;
124     }
125 
126     //For test only
127     function changeTimeWithoutUpdate(uint256 _timeWithoutUpdate) public onlyOwner {
128         timeWithoutUpdate = _timeWithoutUpdate;
129     }
130 
131     //For test only
132     function changeRate(uint256 _rate) public onlyOwner {
133         rate = _rate;
134     }
135 
136     function totalSupply() public view returns (uint256) {
137         return totalSupply;
138     }
139 
140     function livingSupply() public view returns (uint256) {
141         return livingSupply;
142     }
143 
144     // low level token purchase function
145     function buyTokens(uint256 _id) public payable returns (bool) {
146         if (stage == Stages.Create) {
147             revert();
148         }
149 
150         if (stage == Stages.InitForMigrate) {
151             require(msg.sender == migrate);
152         }
153 
154         require(!started);
155         require(!gameOver);
156         require(!gameOverByUser);
157         require(_id > 0 && _id <= cap);
158         require(citizens[_id].isExist == false);
159 
160         require(msg.value == rate);
161         uint256 weiAmount = msg.value;
162 
163         // update weiRaised
164         weiRaised = weiRaised.add(weiAmount);
165 
166         totalSupply = totalSupply.add(1);
167         livingSupply = livingSupply.add(1);
168 
169         createCitizen(_id, msg.sender);
170         timestamp = now;
171         TokenHolder(_id, msg.sender);
172         TokenState(_id, 1);
173         TokenBranch(_id, 1);
174         forwardFunds();
175 
176         return true;
177     }
178 
179     function changeState(uint256 _id, uint8 _state) public onlyEpisodeManager returns (bool) {
180         require(started);
181         require(!gameOver);
182         require(!gameOverByUser);
183         require(_id > 0 && _id <= cap);
184         require(_state <= 1);
185         require(citizens[_id].state != _state);
186 
187         citizens[_id].state = _state;
188         TokenState(_id, _state);
189         timestamp = now;
190         if (_state == 0) {
191             livingSupply--;
192         } else {
193             livingSupply++;
194         }
195 
196         return true;
197     }
198 
199     function changeHolder(uint256 _id, address _newholder) public returns (bool) {
200         require(_id > 0 && _id <= cap);
201         require((citizens[_id].holder == msg.sender) || (stock == msg.sender));
202         require(_newholder != address(0));
203         citizens[_id].holder = _newholder;
204         TokenHolder(_id, _newholder);
205         return true;
206     }
207 
208     function changeBranch(uint256 _id, uint8 _branch) public onlyEpisodeManager returns (bool) {
209         require(started);
210         require(!gameOver);
211         require(!gameOverByUser);
212         require(_id > 0 && _id <= cap);
213         require(_branch > 0);
214         citizens[_id].branch = _branch;
215         TokenBranch(_id, _branch);
216         return true;
217     }
218 
219     function start() public onlyOwner {
220         require(!started);
221         started = true;
222     }
223 
224     function finalize() public onlyOwner {
225         require(!gameOverByUser);
226         gameOver = true;
227     }
228 
229     function userFinalize() public {
230         require(now >= (timestamp + timeWithoutUpdate));
231         require(!gameOver);
232         gameOverByUser = true;
233     }
234 
235     function checkGameOver() public view returns (bool) {
236         return gameOver;
237     }
238 
239     function checkGameOverByUser() public view returns (bool) {
240         return gameOverByUser;
241     }
242 
243     function changeOwner(address _newOwner) public onlyOwner returns (bool) {
244         require(_newOwner != address(0));
245         owner = _newOwner;
246         return true;
247     }
248 
249     function getState(uint256 _id) public view returns (uint256) {
250         require(_id > 0 && _id <= cap);
251         return citizens[_id].state;
252     }
253 
254     function getHolder(uint256 _id) public view returns (address) {
255         require(_id > 0 && _id <= cap);
256         return citizens[_id].holder;
257     }
258 
259     function getBranch(uint256 _id) public view returns (uint256) {
260         require(_id > 0 && _id <= cap);
261         return citizens[_id].branch;
262     }
263 
264     function getStage() public view returns (uint256) {
265         return uint(stage);
266     }
267 
268     function getNowTokenPrice() public view returns (uint256) {
269         return rate;
270     }
271 
272     function allStates() public view returns (uint256[], address[], uint256[]) {
273         uint256[] memory a = new uint256[](50);
274         address[] memory b = new address[](50);
275         uint256[] memory c = new uint256[](50);
276 
277         for (uint i = 0; i < a.length; i++) {
278             a[i] = citizens[i+1].state;
279             b[i] = citizens[i+1].holder;
280             c[i] = citizens[i+1].branch;
281         }
282 
283         return (a, b, c);
284     }
285 
286     //for test only
287     function deleteCitizen(uint256 _id) public onlyOwner returns (uint256) {
288         require(_id > 0 && _id <= cap);
289         require(citizens[_id].isExist == true);
290         delete citizens[_id];
291         return _id;
292     }
293 
294     function nextStage() public onlyOwner returns (bool) {
295         require(stage < Stages.Finish);
296         stage = Stages(uint(stage) + 1);
297         return true;
298     }
299 
300     // send ether to the fund collection wallet
301     // override to create custom fund forwarding mechanisms
302     function forwardFunds() internal {
303         fundsKeeper.transfer(msg.value);
304     }
305 
306     function createCitizen(uint256 _id, address _holder) internal returns (uint256) {
307         require(!started);
308         require(_id > 0 && _id <= cap);
309         require(_holder != address(0));
310         citizens[_id].state = 1;
311         citizens[_id].holder = _holder;
312         citizens[_id].branch = 1;
313         citizens[_id].isExist = true;
314         return _id;
315     }
316 }
317 
318 
319 library SafeMath {
320     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
321         uint256 c = a * b;
322         assert(a == 0 || c / a == b);
323         return c;
324     }
325 
326     function div(uint256 a, uint256 b) internal pure returns (uint256) {
327         uint256 c = a / b;
328         return c;
329     }
330 
331     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
332         assert(b <= a);
333         return a - b;
334     }
335 
336     function add(uint256 a, uint256 b) internal pure returns (uint256) {
337         uint256 c = a + b;
338         assert(c >= a);
339         return c;
340     }
341 }