1 pragma solidity 0.5.16; 
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7         return 0;
8     }
9     uint256 c = a * b;
10     require(c / a == b, 'SafeMath mul failed');
11     return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     require(b <= a, 'SafeMath sub failed');
23     return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     require(c >= a, 'SafeMath add failed');
29     return c;
30     }
31 }
32 
33 contract owned
34 {
35     address payable public owner;
36     address payable public  newOwner;
37     address payable public signer;
38 
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     constructor() public {
42         owner = msg.sender;
43         signer = msg.sender;
44     }
45 
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50 
51 
52     modifier onlySigner {
53         require(msg.sender == signer, 'caller must be signer');
54         _;
55     }
56 
57 
58     function changeSigner(address payable _signer) public onlyOwner {
59         signer = _signer;
60     }
61 
62     function transferOwnership(address payable _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65 
66     //the reason for this flow is to protect owners from sending ownership to unintended address due to human error
67     function acceptOwnership() public {
68         require(msg.sender == newOwner);
69         emit OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71         newOwner = address(0);
72     }
73 }
74 
75 
76 
77 interface UTOPIAInterface
78 {
79     function userStakedAmount(address _token,address user) external view returns (uint) ;
80     function totalStakedAmount(address _token) external view returns(uint);
81     function authorisedToken(address _token) external view returns(bool);
82     function updateUserData(address _token, address user, uint d_T, uint d_E, uint s_A, uint t_T, uint t_E) external returns(bool);
83     function reInvestMyToken(address _token, uint _amount) external returns(bool);
84     function blackListedUser(address _token, address _user) external returns (bool);
85 }
86 
87 interface tokenInterface
88 {
89     function transfer(address _to, uint256 _amount) external returns (bool);
90     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);
91 }
92 
93 contract UTOPIA_Dividend is owned 
94 {
95     using SafeMath for uint256;
96 
97     struct userData
98     {
99         uint distCount_T;
100         uint distCount_Direct;
101         uint distCount_E;
102         uint totalWhenWithdrawn_T;
103         uint totalWhenWithdrawn_Direct;
104         uint totalWhenWithdrawn_E;
105     }
106 
107     bool public safeGuard;
108 
109     // All first address in mapping is token 
110     //  => user 
111     mapping(address => mapping(address => userData)) public userDatas;
112 
113     mapping (address => uint) public lastDistributionTime;  // last time when distributed
114     mapping (address => uint) public distributionInterval;  // Next distribution after this seconds
115     mapping (address => bool) public accumulateDirect;  // if true direct dividend will be accumulated and distributed by admin
116 
117     mapping (address => uint) public totalDepositedDividend_T; // total deposited dividend for all time for token
118     mapping (address => uint) public totalDepositedDividend_Direct; // total direct dividend for all time for token
119     mapping (address => uint) public totalDepositedDividend_E; // total deposited dividend for all time for ether
120     mapping (address => uint) public totalWithdrawnByUser_T; // sum of all withdrawn amount withdrawn by user in current distribution
121     mapping (address => uint) public totalWithdrawnByUser_E; // sum of all withdrawn amount withdrawn by user in current distribution
122 
123     mapping (address => uint) public distributedTotalAmountTillNow_T; // total amount of contract when last distribution done
124     mapping (address => uint) public distributedTotalAmountTillNow_E; // total amount of contract when last distribution done
125     mapping (address => uint) public distributedTotalAmountTillNow_Direct;
126 
127     mapping (address => uint) public totalDistributionCount_T;
128     mapping (address => uint) public totalDistributionCount_Direct;
129     mapping (address => uint) public totalDistributionCount_E;
130 
131     mapping (address => uint) public accumulatedDirectDividend;
132 
133     uint public distributionPercent;
134 
135     address public stakingContractAddress;
136 
137     function adjustDistributionTime(address token, uint _delayInSeconds, bool _increase) public onlyOwner returns(bool)
138     {
139         require(UTOPIAInterface(stakingContractAddress).authorisedToken(token), "Invalid token");
140         if(_increase)
141         {
142             lastDistributionTime[token] += _delayInSeconds;
143         }
144         else
145         {
146             lastDistributionTime[token] -= _delayInSeconds;
147         }
148         return true;
149     }
150 
151 
152     function setdistributionInterval(address token, uint _distributionInterval ) public onlyOwner returns(bool)
153     {
154         require(UTOPIAInterface(stakingContractAddress).authorisedToken(token), "Invalid token");
155         distributionInterval[token] = _distributionInterval;
156         return true;
157     }
158 
159     function setAccumulateDirect(address token, bool _accumulateDirect) public onlyOwner returns(bool)
160     {
161         require(UTOPIAInterface(stakingContractAddress).authorisedToken(token), "Invalid token");
162         accumulateDirect[token] = _accumulateDirect;
163         return true;
164     }
165 
166     function setStakingContractAddress(address _stakingContractAddress, uint _distributionPercent ) public onlyOwner returns(bool)
167     {
168         stakingContractAddress = _stakingContractAddress;
169         distributionPercent = _distributionPercent;
170         return true;
171     }
172 
173     constructor() public
174     {
175         
176     }
177 
178     function resetUserDatas(address _token, address _user) external returns(bool)
179     {
180         require(msg.sender == stakingContractAddress, "invalid caller to reset");
181         userDatas[_token][_user].distCount_T = 0;
182         userDatas[_token][_user].distCount_Direct = 0;
183         userDatas[_token][_user].distCount_E = 0;
184         userDatas[_token][_user].totalWhenWithdrawn_T = 0;
185         userDatas[_token][_user].totalWhenWithdrawn_Direct = 0;
186         userDatas[_token][_user].totalWhenWithdrawn_E = 0;        
187         return true;
188     }
189 
190     event depositDividendEv(address token, address depositor, uint amount_E, uint amount_T);
191     function depositDividend(address token, uint tokenAmount) public payable returns(bool)
192     {
193         require(UTOPIAInterface(stakingContractAddress).authorisedToken(token), "Invalid token");
194         if(msg.value > 0) totalDepositedDividend_E[token] = totalDepositedDividend_E[token].add(msg.value);
195         if(tokenAmount > 0 ) 
196         {
197             require(tokenInterface(token).transferFrom(msg.sender, address(this), tokenAmount),"token transfer failed");
198             totalDepositedDividend_T[token] = totalDepositedDividend_T[token].add(tokenAmount);
199         }
200         emit depositDividendEv(token, msg.sender, msg.value, tokenAmount);
201         return true;
202     }
203 
204 
205     event distributeDividendEv(address token, address user, uint amount_E, uint amount_T);
206     function distributeDividend(address token) public onlySigner returns(bool)
207     {
208         require(UTOPIAInterface(stakingContractAddress).authorisedToken(token), "Invalid token");
209         require(lastDistributionTime[token] + distributionInterval[token] <= now, "please wait some more time" );
210         uint amount_E = ( totalDepositedDividend_E[token]-distributedTotalAmountTillNow_E[token]) * distributionPercent / 100000000;
211         uint amount_T = ( totalDepositedDividend_T[token]-distributedTotalAmountTillNow_T[token]) * distributionPercent / 100000000;
212         require(amount_E > 0 || amount_T > 0 , "no amount to distribute next");
213         if(amount_E > 0)
214         {
215             distributedTotalAmountTillNow_E[token] += amount_E;
216             totalDistributionCount_E[token]++;
217         }
218         if(amount_T > 0)
219         {
220             distributedTotalAmountTillNow_T[token] += amount_T;
221             totalDistributionCount_T[token]++;
222         }
223         lastDistributionTime[token] = now;
224         emit distributeDividendEv(token,msg.sender, amount_E, amount_T);
225         return true;
226     }
227 
228     function addToRegular(address _token, uint _amount) external returns(bool)
229     {
230         require(msg.sender == stakingContractAddress || msg.sender == owner, "Invalid caller");
231         require(UTOPIAInterface(stakingContractAddress).authorisedToken(_token), "Invalid token");
232         require(_amount > 0 , "invalid amount to distribute direct");
233         totalDepositedDividend_T[_token] += _amount;
234         return true;
235     }
236 
237     function directDistribute(address _token, uint _amount) external returns(bool)
238     {
239         require(msg.sender == stakingContractAddress || msg.sender == owner, "Invalid caller");
240         require(UTOPIAInterface(stakingContractAddress).authorisedToken(_token), "Invalid token");
241         require(_amount > 0 , "invalid amount to distribute direct");
242         if(userDatas[_token][tx.origin].totalWhenWithdrawn_T == 0 && userDatas[_token][tx.origin].totalWhenWithdrawn_Direct == 0 && userDatas[_token][tx.origin].totalWhenWithdrawn_E == 0)
243         {
244             userDatas[_token][tx.origin].totalWhenWithdrawn_T = distributedTotalAmountTillNow_T[_token];
245             userDatas[_token][tx.origin].totalWhenWithdrawn_Direct = distributedTotalAmountTillNow_Direct[_token];
246             userDatas[_token][tx.origin].totalWhenWithdrawn_E = distributedTotalAmountTillNow_E[_token];
247         }
248         if(accumulateDirect[_token])
249         {
250             accumulatedDirectDividend[_token] += _amount;
251             totalDepositedDividend_T[_token] += _amount;
252         }
253         else
254         {
255             distributedTotalAmountTillNow_Direct[_token] += _amount;
256             totalDepositedDividend_Direct[_token] += _amount;
257             totalDistributionCount_Direct[_token]++;
258         }
259         return true;
260     }
261 
262     event withdrawMyDividendEv(address token, address user, uint amount_E, uint amount_T);
263     // searchFrom = 0 means start searching from latest stake records of the user, and if >  0 then before latest
264     function withdrawMyDividend(address _token, bool _reInvest) public returns (bool)
265     {
266         require(!safeGuard, "Paused by admin");
267         require(UTOPIAInterface(stakingContractAddress).authorisedToken(_token), "Invalid token");
268         require(!UTOPIAInterface(stakingContractAddress).blackListedUser(_token, tx.origin), "user not allowed");
269         uint totalStaked = UTOPIAInterface(stakingContractAddress).totalStakedAmount(_token);
270         if(totalStaked == 0 && userDatas[_token][tx.origin].totalWhenWithdrawn_T == 0 && userDatas[_token][tx.origin].totalWhenWithdrawn_Direct == 0 && userDatas[_token][tx.origin].totalWhenWithdrawn_E == 0)
271         {
272             require(msg.sender == stakingContractAddress, "Invalid caller");
273             userDatas[_token][tx.origin].totalWhenWithdrawn_T = distributedTotalAmountTillNow_T[_token];
274             userDatas[_token][tx.origin].totalWhenWithdrawn_Direct = distributedTotalAmountTillNow_Direct[_token];
275             userDatas[_token][tx.origin].totalWhenWithdrawn_E = distributedTotalAmountTillNow_E[_token];
276             return true;
277         }
278         uint amount_E = distributedTotalAmountTillNow_E[_token].sub(userDatas[_token][tx.origin].totalWhenWithdrawn_E);
279         uint amount_T = distributedTotalAmountTillNow_T[_token].sub(userDatas[_token][tx.origin].totalWhenWithdrawn_T);
280         uint amount_Direct = distributedTotalAmountTillNow_Direct[_token].sub(userDatas[_token][tx.origin].totalWhenWithdrawn_Direct);
281         uint userStaked = UTOPIAInterface(stakingContractAddress).userStakedAmount(_token, tx.origin);
282 
283         if(totalStaked > 0)
284         {
285             uint gain_E = ( amount_E * (userStaked * 100000000 / totalStaked)) / 100000000;
286             uint gain_T = ( amount_T * (userStaked * 100000000 / totalStaked)) / 100000000;
287             gain_T += ( amount_Direct * (userStaked * 100000000 / totalStaked)) / 100000000;
288             userDatas[_token][tx.origin].distCount_T = totalDistributionCount_T[_token];
289             userDatas[_token][tx.origin].distCount_Direct = totalDistributionCount_Direct[_token];
290             userDatas[_token][tx.origin].distCount_E = totalDistributionCount_E[_token];
291             userDatas[_token][tx.origin].totalWhenWithdrawn_T = distributedTotalAmountTillNow_T[_token];
292             userDatas[_token][tx.origin].totalWhenWithdrawn_Direct = distributedTotalAmountTillNow_Direct[_token];
293             userDatas[_token][tx.origin].totalWhenWithdrawn_E = distributedTotalAmountTillNow_E[_token];
294 
295             if(gain_E > 0) tx.origin.transfer(gain_E);
296             if(gain_T > 0) 
297             {
298                 if(_reInvest)
299                 {
300                     require(tokenInterface(_token).transfer(stakingContractAddress, gain_T ), "token transfer failed");
301                     require(UTOPIAInterface(stakingContractAddress).reInvestMyToken(_token, gain_T), "reinvest failed");
302                 }
303                 else
304                 {
305                     require(tokenInterface(_token).transfer(tx.origin, gain_T ), "token transfer failed");
306                 }               
307             }
308             emit withdrawMyDividendEv(_token,tx.origin,gain_E, gain_T);
309         }
310         return true;
311     }
312 
313     function viewMyWithdrawable(address _token, address _user) public view returns(uint amount_E,uint amount_T, uint amount_Direct)
314     {
315         uint userStaked = UTOPIAInterface(stakingContractAddress).userStakedAmount(_token, _user);
316         amount_E = distributedTotalAmountTillNow_E[_token].sub(userDatas[_token][_user].totalWhenWithdrawn_E);
317         amount_T = distributedTotalAmountTillNow_T[_token].sub(userDatas[_token][_user].totalWhenWithdrawn_T);
318         amount_Direct= distributedTotalAmountTillNow_Direct[_token].sub(userDatas[_token][_user].totalWhenWithdrawn_Direct);
319 
320         uint totalStaked = UTOPIAInterface(stakingContractAddress).totalStakedAmount(_token);
321         amount_E = ( amount_E * (userStaked * 100000000 / totalStaked)) / 100000000;
322         amount_T = ( amount_T * (userStaked * 100000000 / totalStaked)) / 100000000;
323         amount_Direct = ( amount_Direct * (userStaked * 100000000 / totalStaked)) / 100000000;
324         return (amount_E,amount_T, amount_Direct);
325     }
326 
327     function currentDepositedAmount(address _token) public view returns(uint amount_E, uint amount_T)
328     {
329         return (totalDepositedDividend_E[_token] - distributedTotalAmountTillNow_E[_token],totalDepositedDividend_T[_token] - distributedTotalAmountTillNow_T[_token]);
330     }
331 
332     function viewDistributionAmount(address _token) public view returns (uint amount_E, uint amount_T)
333     {
334         return (distributedTotalAmountTillNow_E[_token],distributedTotalAmountTillNow_T[_token] );
335     }    
336 
337     function viewTotalDirectDeposited(address _token) public view returns (uint amount_Direct)
338     {
339         return (accumulatedDirectDividend[_token] );
340     }   
341 
342     function emergencyWithdrawEth(uint _amount) public onlyOwner returns (bool)
343     {
344         owner.transfer(_amount);
345         return true;
346     }
347 
348     function emergencyWithdrawToken(address _token, uint _amount) public onlyOwner returns (bool)
349     {
350         require(tokenInterface(_token).transfer(owner, _amount ), "token transfer failed");
351         return true;
352     }
353 
354     function changeSafeGuardStatus() public onlyOwner returns(bool)
355     {
356         safeGuard = !safeGuard;
357         return true;
358     }
359 
360 }