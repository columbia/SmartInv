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
13 contract PolyWrapperV2 is Ownable, Pausable, ReentrancyGuard {
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
61         require(toAddress.length !=0, "empty toAddress");
62         address addr;
63         assembly { addr := mload(add(toAddress,0x14)) }
64         require(addr != address(0),"zero toAddress");
65         
66         _pull(fromAsset, amount);
67 
68         amount = _checkoutFee(fromAsset, amount, fee);
69 
70         _push(fromAsset, toChainId, toAddress, amount);
71 
72         emit PolyWrapperLock(fromAsset, msg.sender, toChainId, toAddress, amount, fee, id);
73     }
74 
75     function speedUp(address fromAsset, bytes memory txHash, uint fee) public payable nonReentrant whenNotPaused {
76         _pull(fromAsset, fee);
77         emit PolyWrapperSpeedUp(fromAsset, txHash, msg.sender, fee);
78     }
79 
80     function _pull(address fromAsset, uint amount) internal {
81         if (fromAsset == address(0)) {
82             require(msg.value == amount, "insufficient ether");
83         } else {
84             IERC20(fromAsset).safeTransferFrom(msg.sender, address(this), amount);
85         }
86     }
87 
88     // take fee in the form of ether
89     function _checkoutFee(address fromAsset, uint amount, uint fee) internal view returns (uint) {
90         if (fromAsset == address(0)) {
91             require(msg.value >= amount, "insufficient ether");
92             require(amount > fee, "amount less than fee");
93             return amount.sub(fee);
94         } else {
95             require(msg.value >= fee, "insufficient ether");
96             return amount;
97         }
98     }
99 
100     function _push(address fromAsset, uint64 toChainId, bytes memory toAddress, uint amount) internal {
101         if (fromAsset == address(0)) {
102             require(lockProxy.lock.value(amount)(fromAsset, toChainId, toAddress, amount), "lock ether fail");
103         } else {
104             IERC20(fromAsset).safeApprove(address(lockProxy), 0);
105             IERC20(fromAsset).safeApprove(address(lockProxy), amount);
106             require(lockProxy.lock(fromAsset, toChainId, toAddress, amount), "lock erc20 fail");
107         }
108     }
109 
110     event PolyWrapperLock(address indexed fromAsset, address indexed sender, uint64 toChainId, bytes toAddress, uint net, uint fee, uint id);
111     event PolyWrapperSpeedUp(address indexed fromAsset, bytes indexed txHash, address indexed sender, uint efee);
112 
113 }