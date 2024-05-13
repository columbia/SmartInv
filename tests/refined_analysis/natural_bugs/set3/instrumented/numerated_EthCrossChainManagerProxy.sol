1 pragma solidity ^0.5.0;
2 import "./../../../libs/ownership/Ownable.sol";
3 import "./../../../libs/lifecycle/Pausable.sol";
4 import "./../interface/IUpgradableECCM.sol";
5 import "./../interface/IEthCrossChainManagerProxy.sol";
6 
7 contract EthCrossChainManagerProxy is IEthCrossChainManagerProxy, Ownable, Pausable {
8     address private EthCrossChainManagerAddr_;
9     
10     constructor(address _ethCrossChainManagerAddr) public {
11         EthCrossChainManagerAddr_ = _ethCrossChainManagerAddr;
12     }
13     
14     function pause() onlyOwner public returns (bool) {
15         if (paused()) {
16             return true;
17         }
18         _pause();
19         return true;
20     }
21     function unpause() onlyOwner public returns (bool) {
22         if (!paused()) {
23             return true;
24         }
25         _unpause();
26         return true;
27     }
28     function pauseEthCrossChainManager() onlyOwner whenNotPaused public returns (bool) {
29         IUpgradableECCM eccm = IUpgradableECCM(EthCrossChainManagerAddr_);
30         require(pause(), "pause EthCrossChainManagerProxy contract failed!");
31         require(eccm.pause(), "pause EthCrossChainManager contract failed!");
32     }
33     function upgradeEthCrossChainManager(address _newEthCrossChainManagerAddr) onlyOwner whenPaused public returns (bool) {
34         IUpgradableECCM eccm = IUpgradableECCM(EthCrossChainManagerAddr_);
35         if (!eccm.paused()) {
36             require(eccm.pause(), "Pause old EthCrossChainManager contract failed!");
37         }
38         require(eccm.upgradeToNew(_newEthCrossChainManagerAddr), "EthCrossChainManager upgradeToNew failed!");
39         IUpgradableECCM neweccm = IUpgradableECCM(_newEthCrossChainManagerAddr);
40         require(neweccm.isOwner(), "EthCrossChainManagerProxy is not owner of new EthCrossChainManager contract");
41         EthCrossChainManagerAddr_ = _newEthCrossChainManagerAddr;
42     }
43     function unpauseEthCrossChainManager() onlyOwner whenPaused public returns (bool) {
44         IUpgradableECCM eccm = IUpgradableECCM(EthCrossChainManagerAddr_);
45         require(eccm.unpause(), "unpause EthCrossChainManager contract failed!");
46         require(unpause(), "unpause EthCrossChainManagerProxy contract failed!");
47     }
48     function getEthCrossChainManager() whenNotPaused public view returns (address) {
49         return EthCrossChainManagerAddr_;
50     }
51     function changeManagerChainID(uint64 _newChainId) onlyOwner whenPaused public {
52         IUpgradableECCM eccm = IUpgradableECCM(EthCrossChainManagerAddr_);
53         if (!eccm.paused()) {
54             require(eccm.pause(), "Pause old EthCrossChainManager contract failed!");
55         }
56         require(eccm.setChainId(_newChainId), "set chain ID failed. ");
57     }
58 }