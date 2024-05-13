1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.5.0;
3 
4 import "../../libs/token/ERC20/SafeERC20.sol";
5 import "../../libs/token/ERC20/IERC20.sol";
6 import "../../libs/ownership/Ownable.sol";
7 import "../../libs/utils/ReentrancyGuard.sol";
8 import "../../libs/math/SafeMath.sol";
9 import "../../libs/lifecycle/Pausable.sol";
10 
11 import "./interfaces/ILockProxy.sol";
12 
13 contract PolyWrapperV1 is Ownable, Pausable, ReentrancyGuard {
14     using SafeMath for uint;
15     using SafeERC20 for IERC20;
16 
17     uint public chainId;
18     address public feeCollector;
19 
20     ILockProxy public lockProxy;
21 
22     constructor(address _owner, uint _chainId) public {
23         require(_chainId != 0, "!legal");
24         transferOwnership(_owner);
25         chainId = _chainId;
26     }
27 
28     function setFeeCollector(address collector) external onlyOwner {
29         require(collector != address(0), "emtpy address");
30         feeCollector = collector;
31     }
32 
33 
34     function setLockProxy(address _lockProxy) external onlyOwner {
35         require(_lockProxy != address(0));
36         lockProxy = ILockProxy(_lockProxy);
37         require(lockProxy.managerProxyContract() != address(0), "not lockproxy");
38     }
39 
40     function pause() external onlyOwner {
41         _pause();
42     }
43 
44     function unpause() external onlyOwner {
45         _unpause();
46     }
47 
48 
49     function extractFee(address token) external {
50         require(msg.sender == feeCollector, "!feeCollector");
51         if (token == address(0)) {
52             msg.sender.transfer(address(this).balance);
53         } else {
54             IERC20(token).safeTransfer(feeCollector, IERC20(token).balanceOf(address(this)));
55         }
56     }
57     
58     function lock(address fromAsset, uint64 toChainId, bytes memory toAddress, uint amount, uint fee, uint id) public payable nonReentrant whenNotPaused {
59         
60         require(toChainId != chainId && toChainId != 0, "!toChainId");
61         require(amount > fee, "amount less than fee");
62         require(toAddress.length !=0, "empty toAddress");
63         address addr;
64         assembly { addr := mload(add(toAddress,0x14)) }
65         require(addr != address(0),"zero toAddress");
66         
67         _pull(fromAsset, amount);
68 
69         _push(fromAsset, toChainId, toAddress, amount.sub(fee));
70 
71         emit PolyWrapperLock(fromAsset, msg.sender, toChainId, toAddress, amount.sub(fee), fee, id);
72     }
73 
74     function speedUp(address fromAsset, bytes memory txHash, uint fee) public payable nonReentrant whenNotPaused {
75         _pull(fromAsset, fee);
76         emit PolyWrapperSpeedUp(fromAsset, txHash, msg.sender, fee);
77     }
78 
79     function _pull(address fromAsset, uint amount) internal {
80         if (fromAsset == address(0)) {
81             require(msg.value == amount, "insufficient ether");
82         } else {
83             IERC20(fromAsset).safeTransferFrom(msg.sender, address(this), amount);
84         }
85     }
86 
87     function _push(address fromAsset, uint64 toChainId, bytes memory toAddress, uint amount) internal {
88         if (fromAsset == address(0)) {
89             require(lockProxy.lock.value(amount)(fromAsset, toChainId, toAddress, amount), "lock ether fail");
90         } else {
91             IERC20(fromAsset).safeApprove(address(lockProxy), 0);
92             IERC20(fromAsset).safeApprove(address(lockProxy), amount);
93             require(lockProxy.lock(fromAsset, toChainId, toAddress, amount), "lock erc20 fail");
94         }
95     }
96 
97     event PolyWrapperLock(address indexed fromAsset, address indexed sender, uint64 toChainId, bytes toAddress, uint net, uint fee, uint id);
98     event PolyWrapperSpeedUp(address indexed fromAsset, bytes indexed txHash, address indexed sender, uint efee);
99 
100 }
