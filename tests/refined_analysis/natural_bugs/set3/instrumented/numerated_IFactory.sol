1 pragma solidity =0.8.7;
2 
3 import "./IBasket.sol";
4 
5 interface IFactory {
6     struct Bounty {
7         address token;
8         uint256 amount;
9         bool active;
10     }
11 
12     struct Proposal {
13         uint256 licenseFee;
14         string tokenName;
15         string tokenSymbol;
16         address proposer;
17         address[] tokens;
18         uint256[] weights;
19         address basket;
20     }
21 
22 
23     //TODO: validate these
24     function proposal(uint256) external view returns (Proposal memory);
25     function minLicenseFee() external view returns (uint256);
26     function auctionDecrement() external view returns (uint256);
27     function auctionMultiplier() external view returns (uint256);
28     function bondPercentDiv() external view returns (uint256);
29     function ownerSplit() external view returns (uint256);
30     function auctionImpl() external view returns (IAuction);
31     function basketImpl() external view returns (IBasket);
32     function getProposalWeights(uint256 id) external view returns (address[] memory, uint256[] memory);
33 
34     function createBasket(uint256) external returns (IBasket);
35     function proposeBasketLicense(uint256, string calldata, string calldata, address[] memory tokens, uint256[] memory weights) external returns (uint256);
36     function setMinLicenseFee(uint256) external;
37     function setAuctionDecrement(uint256) external;
38     function setAuctionMultiplier(uint256) external;
39     function setBondPercentDiv(uint256) external;
40     function setOwnerSplit(uint256) external;
41 
42     event BasketCreated(address indexed basket);
43     event BasketLicenseProposed(address indexed proposer, string indexed tokenName);
44 }