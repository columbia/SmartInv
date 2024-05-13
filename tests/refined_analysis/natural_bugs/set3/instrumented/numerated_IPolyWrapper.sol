1 pragma solidity ^0.5.0;
2 
3 interface IPolyWrapper {
4     function feeCollector() external view returns (address);
5     function lockProxy() external view returns (address);
6     function paused() external view returns (bool);
7     function chainId() external view returns (uint);
8     function owner() external view returns (address);
9 
10     function lock(
11         address fromAsset,
12         uint64 toChainId, 
13         bytes calldata toAddress,
14         uint amount,
15         uint fee,
16         uint id
17     ) external payable;
18 
19     function speedUp(
20         address fromAsset, 
21         bytes calldata txHash,
22         uint fee
23     ) external payable;
24 
25     function setFeeCollector(address collector) external;
26     function setLockProxy(address _lockProxy) external;
27     function extractFee(address token) external;
28     function pause() external;
29     function unpause() external;
30 
31     event PolyWrapperLock(address indexed fromAsset, address indexed sender, uint64 toChainId, bytes toAddress, uint net, uint fee, uint id);
32     event PolyWrapperSpeedUp(address indexed fromAsset, bytes indexed txHash, address indexed sender, uint efee);
33 }