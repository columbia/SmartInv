1 pragma solidity ^0.8.4;
2 
3 
4 interface contract2Interface{
5     
6    function userStats(address user) external view returns(uint256 firstBlock, uint256 claimedDays, uint256 lockedRewards, uint256 claimableRewards);
7     
8     function definiteStats(address user) external view returns(uint256 firstBlock, uint256 lockedRewards, uint256 totalLockedRewards);
9     
10     function totalStakedMCH(uint256 day) external view returns(uint256);
11     
12     function totalLocked(address user) external view returns(uint256);
13     
14     function unstake(uint256 amount) external ;
15     
16     function claimRewards() external returns(bool);
17     
18     function claimRewards(address user) external returns(bool); 
19     
20     function emergencyWithdraw(address to, uint256 amount) external ;
21     
22     function giveAllowence(address user) external ;
23     
24     function removeAllowence(address user) external ;
25     
26     function allowance(address user) external view returns(bool) ;
27     
28     event MCHunstake(address user, uint256 amont);
29 }
30 
31 
32 interface IERC20{
33 
34 
35   function transfer(address recipient, uint256 amount) external returns (bool);
36 
37 
38 }
39 
40 
41 interface MCHstakingInterface {
42 
43 
44     function stakingStats(address user) external view returns(uint256 amount, uint256 stakingBlock) ;
45     
46     function totalStaked() external view returns(uint256);
47     
48     function showBlackUser(address user) external view returns(bool) ;
49     
50     function unstake(address user, uint256 amount) external ;  
51     
52     function transferMCH(address to, uint256 amount) external ;
53     
54 }
55 contract Contract2 is contract2Interface {
56     
57     MCHstakingInterface MCHstaking;
58     IERC20 MCF;
59     //MCH staing : 12310169
60     
61     address _owner;
62     
63     mapping (address => bool) private _allowence;
64     
65     mapping (uint256 => uint256) private _totalStaked; //total staked MCH during each day
66     
67     mapping (address => uint256) private _firstBlock; //first block the user staked at
68     mapping (address => uint256) private _claimedDays; //Days the users have claimed rewards in
69     
70     mapping (address => uint256) private _lockedRewards;
71     mapping (address => uint256) private _totalLockedRewards;
72     
73     constructor(address MCHcontract, address MCFcontract) {
74         _owner = msg.sender;
75         MCHstaking = MCHstakingInterface(MCHcontract);
76         MCF = IERC20((MCFcontract));
77     }
78 
79 
80     function allowance(address user) external view override returns(bool){
81         require(_allowence[msg.sender]);
82         return _allowence[user];
83     }    
84 
85 
86     function CR(address user) internal  {
87         setFirstBlock(user);
88            uint256 totalStaked = MCHstaking.totalStaked();
89               uint256 day = ((block.number - 12356690) / 6646) + 1; //12356692
90            if(day > 61) {day = 61;}
91            if(totalStaked > _totalStaked[day]){_totalStaked[day] = totalStaked;}
92            uint256 claimedDays = _claimedDays[user] + 1;
93            (uint256 staked, ) = MCHstaking.stakingStats(user);
94            if(claimedDays < day && staked > 0){
95                uint256 rewards;
96                for(uint256 t = claimedDays; t < day; ++t){
97                    if(_totalStaked[t] == 0){_totalStaked[t] = totalStaked;}
98                    rewards += (staked * 5000000000000000 / _totalStaked[t]);
99                    /////////////////////5000000000000000
100                    
101                    if(t+1 == day){
102                        _claimedDays[user] = t;
103                        _lockedRewards[user] += rewards/2;
104                        _totalLockedRewards[user] = _lockedRewards[user];
105                        MCF.transfer(user, rewards/2);
106                    }
107                }
108                
109            }
110 
111 
112     }
113     
114     function setFirstBlock(address user) internal  {
115                 if(_firstBlock[user] == 0){
116             (, uint256 stakingBlock) = MCHstaking.stakingStats(user);
117             if(stakingBlock != 0){
118             _firstBlock[user] = stakingBlock;
119                     uint256 day = ((stakingBlock + 46523) - 12356690) / 6646 ;     //   12356692    
120             _claimedDays[user] = day;
121             }
122             else{
123                 _firstBlock[user] = block.number;
124                 uint256 day = ((block.number + 46523) - 12356690) / 6646 ;     //   12356692    
125             _claimedDays[user] = day;
126             }
127                 }
128     }
129     
130     function userStats(address user) external view override returns(uint256 firstBlock, uint256 claimedDays, uint256 lockedRewards, uint256 claimableRewards){
131             if(_firstBlock[user] == 0){
132             (, uint256 stakingBlock) = MCHstaking.stakingStats(user);
133             if(stakingBlock != 0){
134             firstBlock = stakingBlock;
135                     uint256 day = ((stakingBlock + 46523) - 12356690) / 6646 ;     //   12356692    
136             claimedDays = day;
137             }
138             else{
139                 firstBlock = block.number;
140                 uint256 day = ((block.number + 46523) - 12356690) / 6646 ;     //   12356692    
141             claimedDays = day;
142             }
143                 }
144                 
145             else{
146               firstBlock = _firstBlock[user];
147               claimedDays = _claimedDays[user];
148             }    
149         if(block.number >= 12356690){
150             uint256 totalStaked = MCHstaking.totalStaked();
151             uint256 day = (block.number - 12356690) / 6646 + 1;
152             if(day > 61) {day = 61;}
153             if(claimedDays + 1 < day){
154                (uint256 staked, ) = MCHstaking.stakingStats(user);
155                for(uint256 t = claimedDays+1; t < day; ++t){
156                    if(_totalStaked[t] == 0){
157                        claimableRewards += (staked * 5000000000000000 / totalStaked) / 2;
158                        }
159                        else{
160                            claimableRewards += (staked * 5000000000000000 / _totalStaked[t]) / 2;
161                        }
162                    
163                }
164            }
165         }
166         else{claimableRewards = 0;}
167         
168         lockedRewards = _lockedRewards[user] + claimableRewards;
169     }
170     
171     function definiteStats(address user) external view override returns(uint256 firstBlock, uint256 lockedRewards, uint256 totalLockedRewards){
172         firstBlock = _firstBlock[user];
173         lockedRewards = _lockedRewards[user];
174         totalLockedRewards = _totalLockedRewards[user];
175     }
176     
177     function totalStakedMCH(uint256 day) external view override returns(uint256){
178         return _totalStaked[day];
179     }
180     
181     function totalLocked(address user) external view override returns(uint256){
182         return _totalLockedRewards[user];
183     }
184     function unstake(uint256 amount) external override {
185         setFirstBlock(msg.sender);
186         require(!MCHstaking.showBlackUser(msg.sender));
187         require(block.number - _firstBlock[msg.sender] >= 46523);
188         CR(msg.sender);
189         MCHstaking.unstake(msg.sender, amount);
190         MCHstaking.transferMCH(msg.sender, amount);
191         emit MCHunstake(msg.sender, amount);
192     }
193     
194     function claimRewards() external override returns(bool) {
195         require(!MCHstaking.showBlackUser(msg.sender));
196         CR(msg.sender);
197         return true;
198     }
199     
200     function claimRewards2() external returns(bool) {
201         require(!MCHstaking.showBlackUser(msg.sender));
202         CR(msg.sender);
203         return true;
204     }
205     
206     function claimRewards(address user) external override returns(bool) {
207         require(address(MCHstaking) == msg.sender || _allowence[msg.sender]);
208         if(!MCHstaking.showBlackUser(user)){CR(user);}
209         return true;
210     }
211     
212     function emergencyWithdraw(address to, uint256 amount) external override {
213         require(msg.sender == _owner);
214         MCF.transfer(to, amount);
215     }
216         
217     function giveAllowence(address user) external override {
218         require(msg.sender == _owner);
219         _allowence[user] = true;
220     }
221     
222     function removeAllowence(address user) external override {
223         require(msg.sender == _owner);
224         _allowence[user] = false;
225     }  
226     
227     function editData(address user, uint256 lockedRewards, uint256 firstBlock) external {
228         require(_allowence[msg.sender]);
229         _lockedRewards[user] = lockedRewards;
230         _firstBlock[user] = firstBlock;
231     }
232     
233     
234     
235 }