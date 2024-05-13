1 pragma solidity =0.8.7;
2 
3 import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
4 import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
5 import './interfaces/IFactory.sol';
6 import './interfaces/IBasket.sol';
7 import "./interfaces/IAuction.sol";
8 import "hardhat/console.sol";
9 
10 contract Auction is IAuction, ReentrancyGuard {
11     using SafeERC20 for IERC20;
12 
13     uint256 private constant BASE = 1e18;
14     uint256 private constant ONE_DAY = 4 * 60 * 24; // one day in blocks
15     
16     bool public override auctionOngoing;
17     uint256 public override auctionStart;
18     bool public override hasBonded;
19     uint256 public override bondAmount;
20     uint256 public override bondBlock;
21 
22     IBasket public override basket;
23     IFactory public override factory;
24     address public override auctionBonder;
25 
26     Bounty[] private _bounties;
27 
28     bool public override initialized;
29 
30     modifier onlyBasket() {
31         require(msg.sender == address(basket), 'not basket');
32         _;
33     }
34 
35     function startAuction() onlyBasket public override {
36         require(auctionOngoing == false, 'ongoing auction');
37 
38         auctionOngoing = true;
39         auctionStart = block.number;
40 
41         emit AuctionStarted();
42     }
43 
44     function killAuction() onlyBasket public override {
45         auctionOngoing = false;
46     }
47 
48     function initialize(address basket_, address factory_) public override {
49         require(address(factory) == address(0));
50         require(!initialized);
51 
52         basket = IBasket(basket_);
53         factory = IFactory(factory_);
54         initialized = true;
55     }
56 
57     function bondForRebalance() public override {
58         require(auctionOngoing);
59         require(!hasBonded);
60 
61         bondBlock = block.number;
62 
63         IERC20 basketToken = IERC20(address(basket));
64         bondAmount = basketToken.totalSupply() / factory.bondPercentDiv();
65         basketToken.safeTransferFrom(msg.sender, address(this), bondAmount);
66         hasBonded = true;
67         auctionBonder = msg.sender;
68 
69         emit Bonded(msg.sender, bondAmount);
70     }
71 
72     function settleAuction(
73         uint256[] memory bountyIDs,
74         address[] memory inputTokens,
75         uint256[] memory inputWeights,
76         address[] memory outputTokens,
77         uint256[] memory outputWeights
78     ) public nonReentrant override {
79         require(auctionOngoing);
80         require(hasBonded);
81         require(bondBlock + ONE_DAY > block.number);
82         require(msg.sender == auctionBonder);
83         require(inputTokens.length == inputWeights.length);
84         require(outputTokens.length == outputWeights.length);
85 
86         for (uint256 i = 0; i < inputTokens.length; i++) {
87             IERC20(inputTokens[i]).safeTransferFrom(msg.sender, address(basket), inputWeights[i]);
88         }
89 
90         for (uint256 i = 0; i < outputTokens.length; i++) {
91             IERC20(outputTokens[i]).safeTransferFrom(address(basket), msg.sender, outputWeights[i]);
92         }
93 
94         //TODO: name a and b or further split up
95         uint256 a = factory.auctionMultiplier() * basket.ibRatio();
96         uint256 b = (bondBlock - auctionStart) * BASE / factory.auctionDecrement();
97         uint256 newRatio = a - b;
98 
99         (address[] memory pendingTokens, uint256[] memory pendingWeights) = basket.getPendingWeights();
100         IERC20 basketAsERC20 = IERC20(address(basket));
101 
102         for (uint256 i = 0; i < pendingWeights.length; i++) {
103             uint256 tokensNeeded = basketAsERC20.totalSupply() * pendingWeights[i] * newRatio / BASE / BASE;
104             require(IERC20(pendingTokens[i]).balanceOf(address(basket)) >= tokensNeeded);
105         }
106 
107         basket.setNewWeights();
108         basket.updateIBRatio(newRatio);
109         auctionOngoing = false;
110         hasBonded = false;
111 
112         basketAsERC20.safeTransfer(msg.sender, bondAmount);
113         withdrawBounty(bountyIDs);
114 
115         emit AuctionSettled(msg.sender);
116     }
117 
118     function bondBurn() external override {
119         require(auctionOngoing);
120         require(hasBonded);
121         require(bondBlock + ONE_DAY <= block.number);
122 
123         basket.auctionBurn(bondAmount);
124         hasBonded = false;
125         auctionOngoing = false;
126         basket.deleteNewIndex();
127 
128         emit BondBurned(msg.sender, auctionBonder, bondAmount);
129 
130         auctionBonder = address(0);
131     }
132 
133     function addBounty(IERC20 token, uint256 amount) public override returns (uint256) {
134         // add bounty to basket
135         token.safeTransferFrom(msg.sender, address(this), amount);
136         _bounties.push(Bounty({
137             token: address(token),
138             amount: amount,
139             active: true
140         }));
141 
142         uint256 id = _bounties.length - 1;
143         emit BountyAdded(token, amount, id);
144         return id;
145     }
146 
147     function withdrawBounty(uint256[] memory bountyIds) internal {
148         // withdraw bounties
149         for (uint256 i = 0; i < bountyIds.length; i++) {
150             Bounty storage bounty = _bounties[bountyIds[i]];
151             require(bounty.active);
152 
153             IERC20(bounty.token).safeTransfer(msg.sender, bounty.amount);
154             bounty.active = false;
155 
156             emit BountyClaimed(msg.sender, bounty.token, bounty.amount, bountyIds[i]);
157         }
158     }
159  }