1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function decimals() external view returns (uint8);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     function getOwner() external view returns (address);
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18     address public owner;
19     address public newOwner;
20 
21     event OwnershipTransferred(address indexed from, address indexed to);
22 
23     constructor() {
24         owner = msg.sender;
25         emit OwnershipTransferred(address(0), owner);
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner, "Ownable: Caller is not the owner");
30         _;
31     }
32 
33     function getOwner() external view returns (address) {
34         return owner;
35     }
36 
37     function transferOwnership(address transferOwner) external onlyOwner {
38         require(transferOwner != newOwner);
39         newOwner = transferOwner;
40     }
41 
42     function acceptOwnership() virtual external {
43         require(msg.sender == newOwner);
44         emit OwnershipTransferred(owner, newOwner);
45         owner = newOwner;
46         newOwner = address(0);
47     }
48 }
49 
50 interface INimbusStakingPool {
51     function balanceOf(address account) external view returns (uint256);
52     function stakingToken() external view returns (IBEP20);
53 }
54 
55 interface INimbusReferralProgram {
56     function userSponsorByAddress(address user) external view returns (uint);
57     function userIdByAddress(address user) external view returns (uint);
58 }
59 
60 interface INimbusRouter {
61     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
62 }
63 
64 contract NBUInfluencerBonusPart is Ownable {
65     IBEP20 public immutable NBU;
66     
67     uint public nbuBonusAmount;
68     INimbusReferralProgram public immutable referralProgram;
69     INimbusStakingPool[] public stakingPools;
70     
71     INimbusRouter public swapRouter;                
72     address public swapToken;                       
73     uint public swapTokenAmountForBonusThreshold;  
74     
75     mapping (address => bool) public influencers;
76     mapping (address => mapping (address => bool)) public processedUsers;
77 
78     event ProcessInfluencerBonus(address indexed influencer, address indexed user, uint userAmount, uint influencerBonus);
79     event Rescue(address indexed to, uint amount);
80     event RescueToken(address indexed token, address indexed to, uint amount); 
81 
82     constructor(address nbu, address router, address referral) {
83         NBU = IBEP20(nbu);
84         swapRouter = INimbusRouter(router);
85         referralProgram = INimbusReferralProgram(referral);
86         nbuBonusAmount = 5 * 1e18;
87     }
88 
89     function claimBonus(address[] memory users) external {
90         for (uint i; i < users.length; i++) {
91             claimBonus(users[i]);
92         }
93     }
94 
95     function claimBonus(address user) public {
96         require(influencers[msg.sender], "NBUInfluencerBonusPart: Not influencer");
97         require(!processedUsers[msg.sender][user], "NBUInfluencerBonusPart: Bonus for user already received");
98         uint userSponsor = referralProgram.userSponsorByAddress(user);
99         require(userSponsor == referralProgram.userIdByAddress(msg.sender) && userSponsor != 0, "NBUInfluencerBonusPart: Not user sponsor");
100         uint amount;
101         for (uint i; i < stakingPools.length; i++) {
102             amount += stakingPools[i].balanceOf(user);
103         }
104 
105         address[] memory path = new address[](2);
106         path[0] = swapToken;
107         path[1] = address(NBU);
108         uint minNbuAmountForBonus = swapRouter.getAmountsOut(swapTokenAmountForBonusThreshold, path)[1];
109         require (amount >= minNbuAmountForBonus, "NBUInfluencerBonusPart: Bonus threshold not met");
110         require(NBU.transfer(msg.sender, nbuBonusAmount), "NBUInfluencerBonusPart: Error while transfer");
111         processedUsers[msg.sender][user] = true;
112         emit ProcessInfluencerBonus(msg.sender, user, amount, nbuBonusAmount);
113     }
114 
115     function isBonusForUserAllowed(address influencer, address user) external view returns (bool) {
116         if (!influencers[influencer]) return false;
117         if (processedUsers[influencer][user]) return false;
118         if (referralProgram.userSponsorByAddress(user) != referralProgram.userIdByAddress(influencer)) return false;
119         uint amount;
120         for (uint i; i < stakingPools.length; i++) {
121             amount += stakingPools[i].balanceOf(user);
122         }
123 
124         address[] memory path = new address[](2);
125         path[0] = swapToken;
126         path[1] = address(NBU);
127         uint minNbuAmountForBonus = swapRouter.getAmountsOut(swapTokenAmountForBonusThreshold, path)[1];
128         return amount >= minNbuAmountForBonus;
129     }
130 
131 
132 
133     function rescue(address payable to, uint256 amount) external onlyOwner {
134         require(to != address(0), "NBUInfluencerBonusPart: Address is zero");
135         require(amount > 0, "NBUInfluencerBonusPart: Should be greater than 0");
136         TransferHelper.safeTransferBNB(to, amount);
137         emit Rescue(to, amount);
138     }
139 
140     function rescue(address to, address token, uint256 amount) external onlyOwner {
141         require(to != address(0), "NBUInfluencerBonusPart: Address is zero");
142         require(amount > 0, "NBUInfluencerBonusPart: Should be greater than 0");
143         TransferHelper.safeTransfer(token, to, amount);
144         emit RescueToken(token, to, amount);
145     }
146 
147     function updateSwapRouter(address newSwapRouter) external onlyOwner {
148         require(newSwapRouter != address(0), "NBUInfluencerBonusPart: Address is zero");
149         swapRouter = INimbusRouter(newSwapRouter);
150     }
151     
152     function updateStakingPoolAdd(address newStakingPool) external onlyOwner {
153         INimbusStakingPool pool = INimbusStakingPool(newStakingPool);
154         require (pool.stakingToken() == NBU, "NBUInfluencerBonusPart: Wrong pool staking tokens");
155 
156         for (uint i; i < stakingPools.length; i++) {
157             require (address(stakingPools[i]) != newStakingPool, "NBUInfluencerBonusPart: Pool exists");
158         }
159         stakingPools.push(pool);
160     }
161 
162     function updateStakingPoolRemove(uint poolIndex) external onlyOwner {
163         stakingPools[poolIndex] = stakingPools[stakingPools.length - 1];
164         stakingPools.pop();
165     }
166 
167     function updateInfluencer(address influencer, bool isActive) external onlyOwner {
168         influencers[influencer] = isActive;
169     }
170 
171     function updateNbuBonusAmount(uint newAmount) external onlyOwner {
172         nbuBonusAmount = newAmount;
173     }
174 
175     function updateSwapToken(address newSwapToken) external onlyOwner {
176         require(newSwapToken != address(0), "NBUInfluencerBonusPart: Address is zero");
177         swapToken = newSwapToken;
178     }
179 
180     function updateSwapTokenAmountForBonusThreshold(uint threshold) external onlyOwner {
181         swapTokenAmountForBonusThreshold = threshold;
182     }
183 }
184 
185 library TransferHelper {
186     function safeApprove(address token, address to, uint value) internal {
187         // bytes4(keccak256(bytes('approve(address,uint256)')));
188         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
189         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
190     }
191 
192     function safeTransfer(address token, address to, uint value) internal {
193         // bytes4(keccak256(bytes('transfer(address,uint256)')));
194         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
195         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
196     }
197 
198     function safeTransferFrom(address token, address from, address to, uint value) internal {
199         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
200         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
201         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
202     }
203 
204     function safeTransferBNB(address to, uint value) internal {
205         (bool success,) = to.call{value:value}(new bytes(0));
206         require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
207     }
208 }