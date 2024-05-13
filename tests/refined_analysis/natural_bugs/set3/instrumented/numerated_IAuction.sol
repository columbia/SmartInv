1 pragma solidity =0.8.7;
2 
3 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
4 import "./IBasket.sol";
5 import "./IFactory.sol";
6 
7 interface IAuction {
8     struct Bounty {
9         address token;
10         uint256 amount;
11         bool active;
12     }
13 
14     function startAuction() external;
15     function bondForRebalance() external;
16     function settleAuction(
17         uint256[] calldata,
18         address[] calldata,
19         uint256[] calldata,
20         address[] calldata,
21         uint256[] calldata
22     ) external;
23     function bondBurn() external;
24     function killAuction() external;
25     function addBounty(IERC20, uint256) external returns (uint256);
26     function initialize(address, address) external;
27     function initialized() external view returns (bool);
28 
29     function auctionOngoing() external view returns (bool);
30     function auctionStart() external view returns (uint256);
31     function hasBonded() external view returns (bool);
32     function bondAmount() external view returns (uint256);
33     function bondBlock() external view returns (uint256);
34 
35     function basket() external view returns (IBasket);
36     function factory() external view returns (IFactory);
37     function auctionBonder() external view returns (address);
38 
39     event AuctionStarted();
40     event Bonded(address _bonder, uint256 _amount);
41     event AuctionSettled(address _settler);
42     event BondBurned(address _burned, address _burnee, uint256 _amount);
43     event BountyAdded(IERC20 _token, uint256 _amount, uint256 _id);
44     event BountyClaimed(address _claimer, address _token, uint256 _amount, uint256 _id);
45 }