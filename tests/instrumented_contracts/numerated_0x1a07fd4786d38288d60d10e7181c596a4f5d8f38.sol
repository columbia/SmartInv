1 pragma solidity 0.4.24;
2 
3 
4 interface MakerCDP {
5     function open() external returns (bytes32 cup);
6     function give(bytes32 cup, address guy) external;
7 }
8 
9 
10 contract UniqueCDP {
11 
12     address public deployer;
13     address public cdpAddr;
14 
15     constructor(address saiTub) public {
16         deployer = msg.sender;
17         cdpAddr = saiTub;
18     }
19 
20     function registerCDP(uint maxCup) public {
21         MakerCDP loanMaster = MakerCDP(cdpAddr);
22         for (uint i = 0; i < maxCup; i++) {
23             loanMaster.open();
24         }
25     }
26 
27     function transferCDP(address nextOwner, uint cdpNum) public {
28         require(msg.sender == deployer, "Invalid Address.");
29         MakerCDP loanMaster = MakerCDP(cdpAddr);
30         loanMaster.give(bytes32(cdpNum), nextOwner);
31     }
32 
33 }