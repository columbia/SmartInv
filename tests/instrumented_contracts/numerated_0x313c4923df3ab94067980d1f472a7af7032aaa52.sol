1 pragma solidity ^0.8.10;
2 
3 // SPDX-License-Identifier: MIT
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function decimals() external view returns (uint8);
9 
10     function symbol() external view returns (string memory);
11 
12     function name() external view returns (string memory);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount)
17         external
18         returns (bool);
19 
20     function allowance(address _owner, address spender)
21         external
22         view
23         returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40 
41 contract ADAMSTAKE {
42     using SafeMath for uint256;
43 
44     //Variables
45     IERC20 public stakeToken;
46     IERC20 public rewardToken;
47     address payable public owner;
48     uint256 public totalUniqueStakers;
49     uint256 public totalStaked;
50     uint256 public minStake;
51     uint256 public constant percentDivider = 100000;
52 
53     //arrays
54     uint256[4] public percentages = [0, 0, 0, 0];
55     uint256[4] public APY = [8000,9000,10000,11000];
56     uint256[4] public durations = [15 days, 30 days, 60 days, 90 days];
57 
58     
59     //structures
60     struct Stake {
61         uint256 stakeTime;
62         uint256 withdrawTime;
63         uint256 amount;
64         uint256 bonus;
65         uint256 plan;
66         bool withdrawan;
67     }
68 
69     struct User {
70         uint256 totalstakeduser;
71         uint256 stakecount;
72         uint256 claimedstakeTokens;
73         mapping(uint256 => Stake) stakerecord;
74     }
75 
76     //mappings
77     mapping(address => User) public users;
78     mapping(address => bool) public uniqueStaker;
79 
80     //modifiers
81     modifier onlyOwner() {
82         require(msg.sender == owner, "Ownable: Not an owner");
83         _;
84     }
85 
86     //events
87     event Staked(
88         address indexed _user,
89         uint256 indexed _amount,
90         uint256 indexed _Time
91     );
92 
93     
94 
95     event Withdrawn(
96         address indexed _user,
97         uint256 indexed _amount,
98         uint256 indexed _Time
99     );
100 
101     event UNIQUESTAKERS(address indexed _user);
102 
103     // constructor
104     constructor() {
105         owner = payable(msg.sender);
106         stakeToken = IERC20(0xca7b3ba66556C4Da2E2A9AFeF9C64F909A59430a);
107         rewardToken = IERC20(0x5dD17EAaeeCE9f5E6CC27aF42861B8769C82E447);
108         minStake = 7500000000000;
109         minStake = minStake.mul(10**stakeToken.decimals());
110         for(uint256 i ; i < percentages.length;i++){
111             percentages[i] = APYtoPercentage(APY[i], durations[i].div(1 days));
112         }
113 
114     }
115 
116     // functions
117 
118 
119     //writeable
120     function stake(uint256 amount, uint256 plan) public {
121         require(plan >= 0 && plan < 5, "put valid plan details");
122         require(
123             amount >= minStake,
124             "cant deposit need to stake more than minimum amount"
125         );
126         if (!uniqueStaker[msg.sender]) {
127             uniqueStaker[msg.sender] = true;
128             totalUniqueStakers++;
129             emit UNIQUESTAKERS(msg.sender);
130         }
131         User storage user = users[msg.sender];
132         stakeToken.transferFrom(msg.sender, owner, amount);
133         user.totalstakeduser += amount;
134         user.stakerecord[user.stakecount].plan = plan;
135         user.stakerecord[user.stakecount].stakeTime = block.timestamp;
136         user.stakerecord[user.stakecount].amount = amount;
137         user.stakerecord[user.stakecount].withdrawTime = block.timestamp.add(durations[plan]);
138         user.stakerecord[user.stakecount].bonus = amount.mul(percentages[plan]).div(percentDivider);
139         user.stakecount++;
140         totalStaked += amount;
141         emit Staked(msg.sender, amount, block.timestamp);
142     }
143 
144     function withdraw(uint256 count) public {
145         User storage user = users[msg.sender];
146         require(user.stakecount >= count, "Invalid Stake index");
147         require(
148             !user.stakerecord[count].withdrawan,
149             " withdraw completed "
150         );
151         stakeToken.transferFrom(
152             owner,
153             msg.sender,
154             user.stakerecord[count].amount
155         );
156         rewardToken.transferFrom(
157             owner,
158             msg.sender,
159             user.stakerecord[count].bonus
160         );
161         user.claimedstakeTokens += user.stakerecord[count].amount;
162         user.claimedstakeTokens += user.stakerecord[count].bonus;
163         user.stakerecord[count].withdrawan = true;
164         emit Withdrawn(
165             msg.sender,
166             user.stakerecord[count].amount,
167             block.timestamp);
168     }
169 
170     function changeOwner(address payable _newOwner) external onlyOwner {
171         owner = _newOwner;
172     }
173 
174     function migrateStuckFunds() external onlyOwner {
175         owner.transfer(address(this).balance);
176     }
177 
178     function migratelostToken(address lostToken) external onlyOwner {
179         IERC20(lostToken).transfer(
180             owner,
181             IERC20(lostToken).balanceOf(address(this))
182         );
183     }
184     function setminimumtokens(uint256 amount) external onlyOwner {
185         minStake = amount;
186     }
187     function setStakeToken(IERC20 token) external onlyOwner {
188         stakeToken = token;
189     }
190     function setRewardtoken(IERC20 token) external onlyOwner {
191         rewardToken = token;
192     }
193     function setpercentages(uint256 amount1,uint256 amount2,uint256 amount3,uint256 amount4) external onlyOwner {
194         percentages[0] = amount1;
195         percentages[1] = amount2;
196         percentages[2] = amount3;
197         percentages[3] = amount4;
198     }
199 
200     //readable
201     function APYtoPercentage(uint256 apy, uint256 duration) public pure returns(uint256){
202         return apy.mul(duration).div(365);
203     }
204     function stakedetails(address add, uint256 count)
205         public
206         view
207         returns (
208         // uint256 stakeTime,
209         uint256 withdrawTime,
210         uint256 amount,
211         uint256 bonus,
212         uint256 plan,
213         bool withdrawan
214         )
215     {
216         return (
217             // users[add].stakerecord[count].stakeTime,
218             users[add].stakerecord[count].withdrawTime,
219             users[add].stakerecord[count].amount,
220             users[add].stakerecord[count].bonus,
221             users[add].stakerecord[count].plan,
222             users[add].stakerecord[count].withdrawan
223         );
224     }
225 
226     function calculateRewards(uint256 amount, uint256 plan)
227         external
228         view
229         returns (uint256)
230     {
231         return amount.mul(percentages[plan]).div(percentDivider);
232     }
233 
234     function currentStaked(address add) external view returns (uint256) {
235         uint256 currentstaked;
236         for (uint256 i; i < users[add].stakecount; i++) {
237             if (!users[add].stakerecord[i].withdrawan) {
238                 currentstaked += users[add].stakerecord[i].amount;
239             }
240         }
241         return currentstaked;
242     }
243 
244     function getContractBalance() external view returns (uint256) {
245         return address(this).balance;
246     }
247 
248     function getContractstakeTokenBalance() external view returns (uint256) {
249         return stakeToken.allowance(owner, address(this));
250     }
251 
252     function getCurrentwithdrawTime() external view returns (uint256) {
253         return block.timestamp;
254     }
255 }
256 
257 //library
258 library SafeMath {
259     function add(uint256 a, uint256 b) internal pure returns (uint256) {
260         uint256 c = a + b;
261         require(c >= a, "SafeMath: addition overflow");
262 
263         return c;
264     }
265 
266     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
267         return sub(a, b, "SafeMath: subtraction overflow");
268     }
269 
270     function sub(
271         uint256 a,
272         uint256 b,
273         string memory errorMessage
274     ) internal pure returns (uint256) {
275         require(b <= a, errorMessage);
276         uint256 c = a - b;
277 
278         return c;
279     }
280 
281     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
282         if (a == 0) {
283             return 0;
284         }
285 
286         uint256 c = a * b;
287         require(c / a == b, "SafeMath: multiplication overflow");
288 
289         return c;
290     }
291 
292     function div(uint256 a, uint256 b) internal pure returns (uint256) {
293         return div(a, b, "SafeMath: division by zero");
294     }
295 
296     function div(
297         uint256 a,
298         uint256 b,
299         string memory errorMessage
300     ) internal pure returns (uint256) {
301         require(b > 0, errorMessage);
302         uint256 c = a / b;
303         return c;
304     }
305 
306     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
307         return mod(a, b, "SafeMath: modulo by zero");
308     }
309 
310     function mod(
311         uint256 a,
312         uint256 b,
313         string memory errorMessage
314     ) internal pure returns (uint256) {
315         require(b != 0, errorMessage);
316         return a % b;
317     }
318 }