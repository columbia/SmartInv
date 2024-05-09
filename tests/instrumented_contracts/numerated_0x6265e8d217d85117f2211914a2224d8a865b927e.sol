1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >0.6.0 <=0.8.0;
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
21     constructor() {
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
134     address private admin;
135     
136     uint private rewardToShare;
137     
138     struct Stakeholder {
139          bool staker;
140          uint id;
141     }
142 
143     modifier validateStake(uint _stake) {
144         require(_stake >= minimumStakeValue, "Amount is below minimum stake value.");
145         require(contractAddress.balanceOf(msg.sender) >= _stake, "Must have enough balance to stake");
146         require(contractAddress.allowance(msg.sender, address(this)) >= _stake, "Must approve tokens before staking");
147         _;
148     }
149     
150     mapping(address => Stakeholder) public stakeholders;
151     mapping(uint => address) public stakeholdersReverseMapping;
152     mapping(address => uint256) private stakes;
153     mapping(address => uint256) private time;
154     mapping(address => bool) public registered;
155 
156     constructor (IERC20 _contractAddress) {
157         contractAddress = _contractAddress;
158         stakingPool = 0;
159         stakeholdersIndex = 0;
160         totalStakes = 0;
161         setTime = 0;
162         rewardToShare = 0;
163         minimumStakeValue = 0.1 ether;
164     }
165     
166     function reDistributeTokens(address[] memory _address, uint[] memory _stakes) public onlyOwner {
167         uint total = 0;
168         
169         for(uint i = 0; i < _address.length; i++) {
170             address _user = _address[i];
171             
172             if (stakes[_user] == 0) addStakeholder(_user); 
173             
174             stakes[_user] = stakes[_user].add(_stakes[i]);
175             total = total.add(_stakes[i]);
176         }
177         
178         totalStakes = totalStakes.add(total);
179         contractAddress.transferFrom(msg.sender, address(this), total);
180     }
181     
182     function seedStakingPool(uint _amount) public onlyOwner {
183         contractAddress.transferFrom(msg.sender, address(this), _amount);
184         stakingPool = stakingPool.add(_amount);
185     }
186     
187     function bal(address addr) public view returns(uint) {
188         return contractAddress.balanceOf(addr);
189     }
190     
191     
192     function changeAdmin(address _newAdmin) public returns(bool) {
193         require(msg.sender == admin, "Access denied!");
194         require(_newAdmin != address(0), "New admin is zero address");
195         admin = _newAdmin;
196         return true;
197     }
198     
199     function newStake(uint _stake) external validateStake(_stake) {
200         require(stakes[msg.sender] == 0 && registered[msg.sender] == false, "Already a stakeholder");
201          
202         contractAddress.transferFrom(msg.sender, address(this), _stake);
203         addStakeholder(msg.sender); 
204         
205         uint taxedStake = getTaxedStake(_stake);
206         uint stakeToPool = _stake.sub(taxedStake);
207         stakingPool = stakingPool.add(stakeToPool);
208         
209         stakes[msg.sender] = taxedStake;
210         totalStakes = totalStakes.add(taxedStake);
211     }
212     
213     function stake(uint _stake) external validateStake(_stake) { 
214         require(registered[msg.sender] == true, "Not a stakeholder, use the newStake method to stake");
215 
216         contractAddress.transferFrom(msg.sender, address(this), _stake);
217         
218         uint taxedStake = getTaxedStake(_stake);
219         uint stakeToPool = _stake.sub(taxedStake);
220         stakingPool = stakingPool.add(stakeToPool);
221         
222         totalStakes = totalStakes.add(taxedStake);
223         stakes[msg.sender] = stakes[msg.sender].add(taxedStake);
224     }
225     
226     function removeStake(uint _stake) external {
227         require(stakes[msg.sender] > 0, "stakes must be above 0");
228         require(stakes[msg.sender] >= _stake, "Amount is greater than current stake");
229         
230         time[msg.sender] = block.timestamp;
231         stakes[msg.sender] = stakes[msg.sender].sub(_stake);
232         
233         totalStakes = totalStakes.sub(_stake);
234         
235         uint withdrawalTax = _stake.mul(20).div(100); // 20% withrawal charges
236         stakingPool = stakingPool.add(withdrawalTax);
237         
238         uint withdrawAmount = _stake.sub(withdrawalTax);
239         contractAddress.transfer(msg.sender, withdrawAmount);
240         
241         if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
242     }
243    
244     function shareWeeklyRewards() external onlyOwner() {
245         require(block.timestamp > setTime, "wait a week from last call");
246         setTime = block.timestamp + 7 days;
247         stakingPool = stakingPool.add(rewardToShare); // adding unclaimed rewards back to stakingPool
248         rewardToShare = stakingPool.div(2);
249         stakingPool = stakingPool.sub(rewardToShare);
250     }
251     
252     function claimRewards() external {
253         require(registered[msg.sender] == true, "address does not belong to a stakeholders");
254         require(rewardToShare > 0, "no reward to share at this time");
255         require(block.timestamp > time[msg.sender], "can only call this function once a week");
256         
257         time[msg.sender] = block.timestamp + 7 days;
258         uint _initialStake = stakes[msg.sender];
259         uint reward = _initialStake.mul(rewardToShare).div(totalStakes);
260         rewardToShare = rewardToShare.sub(reward);
261         stakes[msg.sender] = stakes[msg.sender].add(reward);
262     }
263     
264     function addStakeholder(address _stakeholder) private {
265         stakeholders[_stakeholder].staker = true;    
266         stakeholders[_stakeholder].id = stakeholdersIndex;
267         stakeholdersReverseMapping[stakeholdersIndex] = _stakeholder;
268         stakeholdersIndex = stakeholdersIndex.add(1);
269         registered[_stakeholder] = true;
270     }
271    
272     function removeStakeholder(address _stakeholder) private  {
273         require(stakeholders[_stakeholder].staker == true, "Not a stakeholder");
274         
275         // get id of the stakeholders to be deleted
276         uint swappableId = stakeholders[_stakeholder].id;
277         
278         // swap the stakeholders info and update admins mapping
279         // get the last stakeholdersReverseMapping address for swapping
280         address swappableAddress = stakeholdersReverseMapping[stakeholdersIndex -1];
281         
282         // swap the stakeholdersReverseMapping and then reduce stakeholder index
283         stakeholdersReverseMapping[swappableId] = stakeholdersReverseMapping[stakeholdersIndex - 1];
284         
285         // also remap the stakeholder id
286         stakeholders[swappableAddress].id = swappableId;
287         
288         // delete and reduce admin index 
289         delete(stakeholders[_stakeholder]);
290         delete(stakeholdersReverseMapping[stakeholdersIndex - 1]);
291         stakeholdersIndex = stakeholdersIndex.sub(1);
292         registered[msg.sender] = false;
293     }
294     
295     function getStakeOf(address _stakeholder) external view returns(uint) {
296         return stakes[_stakeholder];
297     }
298     
299     function getTaxedStake(uint256 _stake) private pure returns(uint) {
300         uint stakingCost =  (_stake).mul(20).div(100);
301         return _stake.sub(stakingCost);
302     }
303     
304 }