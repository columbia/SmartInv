1 pragma solidity =0.8.7;
2 
3 import "./IAuction.sol";
4 
5 interface IBasket {
6     struct PendingPublisher {
7         address publisher;
8         uint256 block;
9     }
10 
11     struct PendingLicenseFee {
12         uint256 licenseFee;
13         uint256 block;
14     }
15 
16     struct PendingWeights {
17         address[] tokens;
18         uint256[] weights;
19         uint256 block;
20         bool pending;
21     }
22 
23     function initialize(IFactory.Proposal memory, IAuction) external;
24     function mint(uint256) external;
25     function mintTo(uint256, address) external;
26     function burn(uint256) external;
27     function changePublisher(address) external;
28     function changeLicenseFee(uint256) external;
29     function publishNewIndex(address[] calldata, uint256[] calldata) external;
30     function deleteNewIndex() external;
31     function auctionBurn(uint256) external;
32     function updateIBRatio(uint256) external returns (uint256);
33     function setNewWeights() external;
34     function validateWeights(address[] memory, uint256[] memory) external pure;
35 
36     function ibRatio() external view returns (uint256);
37     function getPendingWeights() external view returns (address[] memory, uint256[] memory);
38     function factory() external view returns (IFactory);
39     function auction() external view returns (IAuction);
40     function lastFee() external view returns (uint256);
41 
42 
43     event Minted(address indexed _to, uint256 _amount);
44     event Burned(address indexed _from, uint256 _amount);
45     event ChangedPublisher(address indexed _newPublisher);
46     event ChangedLicenseFee(uint256 _newLicenseFee);
47     event PublishedNewIndex(address _publisher);
48     event DeletedNewIndex(address _publisher);
49     event WeightsSet();
50     event NewIBRatio(uint256);
51 }