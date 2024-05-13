1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the EthCrossChainData contract, the implementation is in EthCrossChainData.sol
5  */
6 interface IEthCrossChainData {
7     function putCurEpochStartHeight(uint32 curEpochStartHeight) external returns (bool);
8     function getCurEpochStartHeight() external view returns (uint32);
9     function putCurEpochConPubKeyBytes(bytes calldata curEpochPkBytes) external returns (bool);
10     function getCurEpochConPubKeyBytes() external view returns (bytes memory);
11     function markFromChainTxExist(uint64 fromChainId, bytes32 fromChainTx) external returns (bool);
12     function checkIfFromChainTxExist(uint64 fromChainId, bytes32 fromChainTx) external view returns (bool);
13     function getEthTxHashIndex() external view returns (uint256);
14     function putEthTxHash(bytes32 ethTxHash) external returns (bool);
15     function putExtraData(bytes32 key1, bytes32 key2, bytes calldata value) external returns (bool);
16     function getExtraData(bytes32 key1, bytes32 key2) external view returns (bytes memory);
17     function transferOwnership(address newOwner) external;
18     function pause() external returns (bool);
19     function unpause() external returns (bool);
20     function paused() external view returns (bool);
21     // Not used currently by ECCM
22     function getEthTxHash(uint256 ethTxHashIndex) external view returns (bytes32);
23 }