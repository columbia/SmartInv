1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the EthCrossChainManagerProxy for business contract like LockProxy to obtain the reliable EthCrossChainManager contract hash.
5  */
6 interface IEthCrossChainManagerProxy {
7     function getEthCrossChainManager() external view returns (address);
8 }
