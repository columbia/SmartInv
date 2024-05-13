1 pragma solidity =0.8.7;
2 
3 import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
4 import './interfaces/IFactory.sol';
5 import './interfaces/IBasket.sol';
6 import "./interfaces/IAuction.sol";
7 import "hardhat/console.sol";
8 
9 contract Auction is IAuction {
10     using SafeERC20 for IERC20;
11 
12     uint256 private constant BASE = 1e18;
13     uint256 private constant ONE_DAY = 4 * 60 * 24;
14     uint256 private constant BLOCK_DECREMENT = 10000;
15     
16     bool public override auctionOngoing;
17     uint256 public override auctionStart;
18     bool public override hasBonded;
19     uint256 public override bondAmount;
20     uint256 public override bondTimestamp;
21     bool public override initialized;
22 
23     IBasket public override basket;
24     IFactory public override factory;
25     address public override auctionBonder;
26 
27     Bounty[] private _bounties;
28 
29     modifier onlyBasket() {
30         require(msg.sender == address(basket), 'not basket');
31         _;
32     }
33 
34     function startAuction() onlyBasket public override {
35         require(auctionOngoing == false, 'ongoing auction');
36 
37         auctionOngoing = true;
38         auctionStart = block.number;
39 
40         emit AuctionStarted();
41     }
42 
43     function killAuction() onlyBasket public override {
44         auctionOngoing = false;
45     }
46 
47     function initialize(address basket_, address factory_) public override {
48         require(!initialized);
49         basket = IBasket(basket_);
50         factory = IFactory(factory_);
51         initialized = true;
52     }
53 
54     function bondForRebalance() public override {
55         require(auctionOngoing);
56         require(!hasBonded);
57 
58         bondTimestamp = block.number;
59 
60         IERC20 basketToken = IERC20(address(basket));
61         bondAmount = basketToken.totalSupply() / factory.bondPercentDiv();
62         basketToken.safeTransferFrom(msg.sender, address(this), bondAmount);
63         hasBonded = true;
64         auctionBonder = msg.sender;
65 
66         emit Bonded(msg.sender, bondAmount);
67     }
68 
69     function settleAuction(
70         uint256[] memory bountyIDs,
71         address[] memory inputTokens,
72         uint256[] memory inputWeights,
73         address[] memory outputTokens,
74         uint256[] memory outputWeights
75     ) public override {
76         require(auctionOngoing);
77         require(hasBonded);
78         require(bondTimestamp + ONE_DAY > block.number);
79         require(msg.sender == auctionBonder);
80 
81         for (uint256 i = 0; i < inputTokens.length; i++) {
82             IERC20(inputTokens[i]).safeTransferFrom(msg.sender, address(basket), inputWeights[i]);
83         }
84 
85         for (uint256 i = 0; i < outputTokens.length; i++) {
86             IERC20(outputTokens[i]).safeTransferFrom(address(basket), msg.sender, outputWeights[i]);
87         }
88 
89         uint256 a = factory.auctionMultiplier() * basket.ibRatio();
90         uint256 b = (bondTimestamp - auctionStart) * BASE / factory.auctionDecrement();
91         uint256 newRatio = a - b;
92 
93         (address[] memory pendingTokens, uint256[] memory pendingWeights) = basket.getPendingWeights();
94         IERC20 basketAsERC20 = IERC20(address(basket));
95 
96         for (uint256 i = 0; i < pendingWeights.length; i++) {
97             uint256 tokensNeeded = basketAsERC20.totalSupply() * pendingWeights[i] * newRatio / BASE / BASE;
98             require(IERC20(pendingTokens[i]).balanceOf(address(basket)) >= tokensNeeded);
99         }
100 
101         basketAsERC20.transfer(msg.sender, bondAmount);
102         withdrawBounty(bountyIDs);
103         basket.setNewWeights();
104         basket.updateIBRatio(newRatio);
105         auctionOngoing = false;
106         hasBonded = false;
107 
108         emit AuctionSettled(msg.sender);
109     }
110 
111     function bondBurn() external override {
112         require(auctionOngoing);
113         require(hasBonded);
114         require(bondTimestamp + ONE_DAY <= block.number);
115 
116         basket.auctionBurn(bondAmount);
117         hasBonded = false;
118         auctionOngoing = false;
119         basket.deleteNewIndex();
120 
121         emit BondBurned(msg.sender, auctionBonder, bondAmount);
122 
123         auctionBonder = address(0);
124     }
125 
126     function addBounty(IERC20 token, uint256 amount) public override returns (uint256) {
127         // add bounty to basket
128         token.safeTransferFrom(msg.sender, address(this), amount);
129         _bounties.push(Bounty({
130             token: address(token),
131             amount: amount,
132             active: true
133         }));
134 
135         uint256 id = _bounties.length - 1;
136         emit BountyAdded(token, amount, id);
137         return id;
138     }
139 
140     function withdrawBounty(uint256[] memory bountyIds) internal {
141         // withdraw bounties
142         for (uint256 i = 0; i < bountyIds.length; i++) {
143             Bounty memory bounty = _bounties[bountyIds[i]];
144             require(bounty.active);
145 
146             IERC20(bounty.token).transfer(msg.sender, bounty.amount);
147             bounty.active = false;
148 
149             emit BountyClaimed(msg.sender, bounty.token, bounty.amount, bountyIds[i]);
150         }
151     }
152  }