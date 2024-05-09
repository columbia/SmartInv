1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.4.0 <0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor () {
22         address msgSender = _msgSender();
23         _owner = msgSender;
24         emit OwnershipTransferred(address(0), msgSender);
25     }
26 
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyOwner() {
32         require(_owner == _msgSender(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     function renounceOwnership() public virtual onlyOwner {
37         emit OwnershipTransferred(_owner, address(0));
38         _owner = address(0);
39     }
40 
41     /**
42      * @dev Transfers ownership of the contract to a new account (`newOwner`).
43      * Can only be called by the current owner.
44      */
45     function transferOwnership(address newOwner) public virtual onlyOwner {
46         require(newOwner != address(0), "Ownable: new owner is the zero address");
47         emit OwnershipTransferred(_owner, newOwner);
48         _owner = newOwner;
49     }
50 }
51 
52 library SafeMath {
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56 
57         return c;
58     }
59 
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return sub(a, b, "SafeMath: subtraction overflow");
63     }
64 
65     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68 
69         return c;
70     }
71     
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         if (a == 0) {
74             return 0;
75         }
76 
77         uint256 c = a * b;
78         require(c / a == b, "SafeMath: multiplication overflow");
79 
80         return c;
81     }
82 
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         return div(a, b, "SafeMath: division by zero");
85     }
86 
87     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91 
92         return c;
93     }
94 
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         return mod(a, b, "SafeMath: modulo by zero");
97     }
98 
99     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b != 0, errorMessage);
101         return a % b;
102     }
103 }
104 
105 interface IERC20 {
106     function totalSupply() external view returns (uint256);
107 
108     function balanceOf(address account) external view returns (uint256);
109 
110     function transfer(address recipient, uint256 amount) external returns (bool);
111 
112     function allowance(address owner, address spender) external view returns (uint256);
113 
114     function approve(address spender, uint256 amount) external returns (bool);
115 
116     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
117 
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 contract StakingToken is Ownable {
124     
125     //initializing safe computations
126     using SafeMath for uint;
127 
128     IERC20 public contractAddress;
129     uint public stakingPool;
130     uint public stakeholdersIndex;
131     uint public totalStakes;
132     uint private setTime;
133     uint public minimumStakeValue;
134     address admin;
135     
136     uint rewardToShare;
137     
138     struct Stakeholder {
139          bool staker;
140          uint id;
141     }
142 
143     modifier validatStake(uint _stake) {
144         require(_stake >= minimumStakeValue, "Amount is below minimum stake value.");
145         require(contractAddress.balanceOf(msg.sender) >= _stake, "Must have enough balance to stake");
146         require(
147             contractAddress.allowance(msg.sender, address(this)) >= _stake, 
148             "Must approve tokens before staking"
149         );
150         _;
151     }
152     
153     mapping (address => Stakeholder) public stakeholders;
154     mapping (uint => address) public stakeholdersReverseMapping;
155     mapping(address => uint256) private stakes;
156     mapping(address => uint256) private rewards;
157     mapping(address => uint256) private time;
158     mapping(address => bool) public registered;
159 
160     constructor(IERC20 _contractAddress) {
161         contractAddress = _contractAddress;
162         stakingPool = 0;
163         stakeholdersIndex = 0;
164         totalStakes = 0;
165         totalStakes = 0;
166         setTime = 0;
167         rewardToShare = 0;
168         minimumStakeValue = 0.1 ether;
169     }
170     
171     function bal(address addr) public view returns(uint) {
172         return contractAddress.balanceOf(addr);
173     }
174     
175     function approvedTokenBalance(address _sender) public view returns(uint) {
176         return contractAddress.allowance(_sender, address(this));
177     }
178     
179     function changeAdmin(address _newAdmin) public returns(bool) {
180         require(msg.sender == admin, 'Access denied!');
181         require(_newAdmin != address(0), "New admin is zero address");
182         admin = _newAdmin;
183         return true;
184     }
185     
186     function newStake(uint _stake) external validatStake(_stake) {
187         require(
188             stakes[msg.sender] == 0 && 
189             registered[msg.sender] == false, 
190             "Already a stakeholder"
191         );
192          require(approvedTokenBalance(msg.sender) >= _stake, "No token approve yet");
193         // Aprrove tokens before staking
194         contractAddress.transferFrom(msg.sender, address(this), _stake);
195         
196         addStakeholder(msg.sender); 
197         uint registerCost = calculateCost(_stake);
198         uint stakeToPool = _stake.sub(registerCost);
199         stakingPool = stakingPool.add(stakeToPool);
200         stakes[msg.sender] = registerCost;
201         totalStakes = totalStakes.add(registerCost);
202         registered[msg.sender] = true;
203     }
204     
205     function stake(uint _stake) external { 
206         require(
207             registered[msg.sender] == true, 
208             "Not a stakeholder, use the newStake method to stake"
209         );
210         require(_stake >= minimumStakeValue, "Amount is below minimum stake value.");
211         require(contractAddress.balanceOf(msg.sender) >= _stake, "Must have enough balance to stake");
212         require(
213             approvedTokenBalance(msg.sender) >= _stake, 
214             "Must approve tokens before staking"
215         );
216         
217         contractAddress.transferFrom(msg.sender, address(this), _stake);
218         
219         // check previous stake balance
220         uint previousStakeBalance = stakes[msg.sender];
221         
222         uint availableTostake = calculateCost(_stake);
223         uint stakeToPool2 = _stake.sub(availableTostake);
224         stakingPool = stakingPool.add(stakeToPool2);
225         totalStakes = totalStakes.add(availableTostake);
226         stakes[msg.sender] = previousStakeBalance.add(availableTostake);
227     }
228     
229     function stakeOf(address _stakeholder) external view returns(uint256) {
230         return stakes[_stakeholder];
231     }
232     
233     function removeStake(uint _stake) external {
234         require(registered[msg.sender] == true, "Not a stakeholder");
235         require(stakes[msg.sender] > 0, 'stakes must be above 0');
236         require(stakes[msg.sender] >= _stake, "Amount is greater than current stake");
237         
238         time[msg.sender] = block.timestamp;
239         uint _balance = stakes[msg.sender];
240         stakes[msg.sender] = stakes[msg.sender].sub(_stake);
241          
242         uint _reward = rewards[msg.sender];
243         rewards[msg.sender] = 0;
244         totalStakes = totalStakes.sub(_stake);
245         // 20% withrawal charges
246         uint withdrawalCharges = _stake.mul(20).div(100);
247         stakingPool = stakingPool.add(withdrawalCharges);
248         uint _totalAmount = _balance.sub(withdrawalCharges);
249         _totalAmount = _totalAmount.add(_reward);
250         contractAddress.transfer(msg.sender, _totalAmount);
251         
252         if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
253     }
254     
255     function addStakeholder(address _stakeholder) private {
256         require(stakeholders[_stakeholder].staker == false, "Already a stakeholder");
257         stakeholders[_stakeholder].staker = true;    
258         stakeholders[_stakeholder].id = stakeholdersIndex;
259         stakeholdersReverseMapping[stakeholdersIndex] = _stakeholder;
260         stakeholdersIndex = stakeholdersIndex.add(1);
261     }
262    
263     function removeStakeholder(address _stakeholder) private  {
264         require(stakeholders[_stakeholder].staker == true, "Not a stakeholder");
265         
266         // get id of the stakeholders to be deleted
267         uint swappableId = stakeholders[_stakeholder].id;
268         
269         // swap the stakeholders info and update admins mapping
270         // get the last stakeholdersReverseMapping address for swapping
271         address swappableAddress = stakeholdersReverseMapping[stakeholdersIndex -1];
272         
273         // swap the stakeholdersReverseMapping and then reduce stakeholder index
274         stakeholdersReverseMapping[swappableId] = stakeholdersReverseMapping[stakeholdersIndex - 1];
275         
276         // also remap the stakeholder id
277         stakeholders[swappableAddress].id = swappableId;
278         
279         // delete and reduce admin index 
280         delete(stakeholders[_stakeholder]);
281         delete(stakeholdersReverseMapping[stakeholdersIndex - 1]);
282         stakeholdersIndex = stakeholdersIndex.sub(1);
283         registered[msg.sender] = false;
284     }
285     
286     function getRewardToShareWeekly() external onlyOwner() {
287         require(block.timestamp > setTime, 'wait a week from last call');
288         setTime = block.timestamp + 7 days;
289         rewardToShare = stakingPool.div(2);
290         stakingPool = stakingPool.sub(rewardToShare);
291     }
292     
293     function getRewards() external {
294         require(registered[msg.sender] == true, 'address does not belong to a stakeholders');
295         require(rewardToShare > 0, 'no reward to share at this time');
296         require(block.timestamp > time[msg.sender], 'can only call this function once a week');
297         
298         time[msg.sender] = block.timestamp + 7 days;
299         uint _initialStake = stakes[msg.sender];
300         uint reward = _initialStake.mul(rewardToShare).div(totalStakes);
301         rewards[msg.sender] = rewards[msg.sender].add(reward);
302     }
303     
304     /* return will converted to ether in frontend*/
305     function rewardOf(address _stakeholder) external view returns(uint256){
306         return rewards[_stakeholder];
307     }
308     
309     function calculateCost(uint256 _stake) private pure returns(uint availableForstake) {
310         uint stakingCost =  (_stake).mul(20).div(100);
311         availableForstake = _stake.sub(stakingCost);
312         return availableForstake;
313     }
314     
315 }