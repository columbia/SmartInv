1 pragma solidity =0.8.7;
2 
3 import "hardhat/console.sol";
4 
5 import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
8 import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
9 import "./interfaces/IAuction.sol";
10 import "./interfaces/IBasket.sol";
11 import "./interfaces/IFactory.sol";
12 
13 contract Factory is IFactory, Ownable {
14     using SafeERC20 for IERC20;
15 
16     uint256 private constant BASE = 1e18;
17 
18     constructor (IAuction _auctionImpl, IBasket _basketImpl) {
19         auctionImpl = _auctionImpl;
20         basketImpl = _basketImpl;
21         ownerSplit = 0; //TODO: needed?
22     }
23 
24     Proposal[] private _proposals;
25 
26     IAuction public override auctionImpl;
27     IBasket public override basketImpl;
28 
29     uint256 public override minLicenseFee = 1e15; // 1e15 0.1%
30     uint256 public override auctionDecrement = 10000;
31     uint256 public override auctionMultiplier = 2;
32     uint256 public override bondPercentDiv = 400;
33     uint256 public override ownerSplit;
34 
35     function proposal(uint256 proposalId) external override view returns (Proposal memory) {
36         return _proposals[proposalId];
37     }
38 
39     function setMinLicenseFee(uint256 newMinLicenseFee) public override onlyOwner {
40         minLicenseFee = newMinLicenseFee;
41     }
42 
43     function setAuctionDecrement(uint256 newAuctionDecrement) public override onlyOwner {
44         auctionDecrement = newAuctionDecrement;
45     }
46 
47     function setAuctionMultiplier(uint256 newAuctionMultiplier) public override onlyOwner {
48         auctionMultiplier = newAuctionMultiplier;
49     }
50 
51     function setBondPercentDiv(uint256 newBondPercentDiv) public override onlyOwner {
52         bondPercentDiv = newBondPercentDiv;
53     }
54 
55     function setOwnerSplit(uint256 newOwnerSplit) public override onlyOwner {
56         require(newOwnerSplit <= 2e17); // 20%
57 
58         ownerSplit = newOwnerSplit;
59     }
60 
61     function getProposalWeights(uint256 id) external override view returns (address[] memory, uint256[] memory) {
62         return (_proposals[id].tokens, _proposals[id].weights);
63     }
64 
65     function proposeBasketLicense(
66         uint256 licenseFee, 
67         string memory tokenName, 
68         string memory tokenSymbol, 
69         address[] memory tokens,
70         uint256[] memory weights
71     ) public override returns (uint256 id) {
72         basketImpl.validateWeights(tokens, weights);
73 
74         require(licenseFee >= minLicenseFee);
75 
76         // create proposal object
77         Proposal memory proposal = Proposal({
78             licenseFee: licenseFee,
79             tokenName: tokenName,
80             tokenSymbol: tokenSymbol,
81             proposer: address(msg.sender),
82             tokens: tokens,
83             weights: weights,
84             basket: address(0)
85         });
86 
87         emit BasketLicenseProposed(msg.sender, tokenName);
88         _proposals.push(proposal);
89 
90         return _proposals.length - 1;
91     }
92 
93     function createBasket(uint256 idNumber) external override returns (IBasket) {
94         Proposal memory bProposal = _proposals[idNumber];
95         require(bProposal.basket == address(0));
96 
97         IAuction newAuction = IAuction(Clones.clone(address(auctionImpl)));
98         IBasket newBasket = IBasket(Clones.clone(address(basketImpl)));
99 
100         _proposals[idNumber].basket = address(newBasket);
101 
102         newAuction.initialize(address(newBasket), address(this));
103         newBasket.initialize(bProposal, newAuction);
104 
105         for (uint256 i = 0; i < bProposal.weights.length; i++) {
106             IERC20 token = IERC20(bProposal.tokens[i]);
107             token.safeTransferFrom(msg.sender, address(this), bProposal.weights[i]);
108             token.safeApprove(address(newBasket), bProposal.weights[i]);
109         }
110 
111         newBasket.mintTo(BASE, msg.sender);
112 
113         emit BasketCreated(address(newBasket));
114 
115         return newBasket;
116     }
117 }
