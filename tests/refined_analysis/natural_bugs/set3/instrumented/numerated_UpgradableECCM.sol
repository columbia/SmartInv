1 pragma solidity ^0.5.0;
2 
3 import "./../interface/IEthCrossChainData.sol";
4 import "./../interface/IUpgradableECCM.sol";
5 import "./../../../libs/lifecycle/Pausable.sol";
6 import "./../../../libs/ownership/Ownable.sol";
7 
8 contract UpgradableECCM is IUpgradableECCM, Ownable, Pausable {
9     address public EthCrossChainDataAddress;
10     uint64 public chainId;  
11     
12     constructor (address ethCrossChainDataAddr, uint64 _chainId) Pausable() Ownable()  public {
13         EthCrossChainDataAddress = ethCrossChainDataAddr;
14         chainId = _chainId;
15     }
16     function pause() onlyOwner public returns (bool) {
17         if (!paused()) {
18             _pause();
19         }
20         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
21         if (!eccd.paused()) {
22             require(eccd.pause(), "pause EthCrossChainData contract failed");
23         }
24         return true;
25     }
26     
27     function unpause() onlyOwner public returns (bool) {
28         if (paused()) {
29             _unpause();
30         }
31         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
32         if (eccd.paused()) {
33             require(eccd.unpause(), "unpause EthCrossChainData contract failed");
34         }
35         return true;
36     }
37 
38     // if we want to upgrade this contract, we need to invoke this method 
39     function upgradeToNew(address newEthCrossChainManagerAddress) whenPaused onlyOwner public returns (bool) {
40         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
41         eccd.transferOwnership(newEthCrossChainManagerAddress);
42         return true;
43     }
44     
45     function setChainId(uint64 _newChainId) whenPaused onlyOwner public returns (bool) {
46         chainId = _newChainId;
47         return true;
48     }
49 }