1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the EthCrossChainManager contract for business contract like LockProxy to request cross chain transaction
5  */
6 interface IEthCrossChainManager {
7     function crossChain(uint64 _toChainId, bytes calldata _toContract, bytes calldata _method, bytes calldata _txData) external returns (bool);
8 }
