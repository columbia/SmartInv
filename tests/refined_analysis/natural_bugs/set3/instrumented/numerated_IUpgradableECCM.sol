1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of upgradableECCM to make ECCM be upgradable, the implementation is in UpgradableECCM.sol
5  */
6 interface IUpgradableECCM {
7     function pause() external returns (bool);
8     function unpause() external returns (bool);
9     function paused() external view returns (bool);
10     function upgradeToNew(address) external returns (bool);
11     function isOwner() external view returns (bool);
12     function setChainId(uint64 _newChainId) external returns (bool);
13 }
