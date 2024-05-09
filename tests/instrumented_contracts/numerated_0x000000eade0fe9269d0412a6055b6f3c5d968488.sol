1 pragma solidity ^0.4.23;
2 
3 // File: contracts/utilities/UpgradeHelper.sol
4 
5 contract OldTrueUSDInterface {
6     function delegateToNewContract(address _newContract) public;
7     function claimOwnership() public;
8     function balances() public returns(address);
9     function allowances() public returns(address);
10     function totalSupply() public returns(uint);
11     function transferOwnership(address _newOwner) external;
12 }
13 contract NewTrueUSDInterface {
14     function setTotalSupply(uint _totalSupply) public;
15     function transferOwnership(address _newOwner) public;
16     function claimOwnership() public;
17 }
18 
19 contract TokenControllerInterface {
20     function claimOwnership() external;
21     function transferChild(address _child, address _newOwner) external;
22     function requestReclaimContract(address _child) external;
23     function issueClaimOwnership(address _child) external;
24     function setTrueUSD(address _newTusd) external;
25     function setTusdRegistry(address _Registry) external;
26     function claimStorageForProxy(address _delegate,
27         address _balanceSheet,
28         address _alowanceSheet) external;
29     function setGlobalPause(address _globalPause) external;
30     function transferOwnership(address _newOwner) external;
31     function owner() external returns(address);
32 }
33 
34 /**
35  */
36 contract UpgradeHelper {
37     OldTrueUSDInterface public constant oldTrueUSD = OldTrueUSDInterface(0x8dd5fbCe2F6a956C3022bA3663759011Dd51e73E);
38     NewTrueUSDInterface public constant newTrueUSD = NewTrueUSDInterface(0x0000000000085d4780B73119b644AE5ecd22b376);
39     TokenControllerInterface public constant tokenController = TokenControllerInterface(0x0000000000075EfBeE23fe2de1bd0b7690883cc9);
40     address public constant registry = address(0x0000000000013949F288172bD7E36837bDdC7211);
41     address public constant globalPause = address(0x0000000000027f6D87be8Ade118d9ee56767d993);
42 
43     function upgrade() public {
44         // TokenController should have end owner as it's pending owner at the end
45         address endOwner = tokenController.owner();
46 
47         // Helper contract becomes the owner of controller, and both TUSD contracts
48         tokenController.claimOwnership();
49         newTrueUSD.claimOwnership();
50 
51         // Initialize TrueUSD totalSupply
52         newTrueUSD.setTotalSupply(oldTrueUSD.totalSupply());
53 
54         // Claim storage contract from oldTrueUSD
55         address balanceSheetAddress = oldTrueUSD.balances();
56         address allowanceSheetAddress = oldTrueUSD.allowances();
57         tokenController.requestReclaimContract(balanceSheetAddress);
58         tokenController.requestReclaimContract(allowanceSheetAddress);
59 
60         // Transfer storage contract to controller then transfer it to NewTrueUSD
61         tokenController.issueClaimOwnership(balanceSheetAddress);
62         tokenController.issueClaimOwnership(allowanceSheetAddress);
63         tokenController.transferChild(balanceSheetAddress, newTrueUSD);
64         tokenController.transferChild(allowanceSheetAddress, newTrueUSD);
65         
66         newTrueUSD.transferOwnership(tokenController);
67         tokenController.issueClaimOwnership(newTrueUSD);
68         tokenController.setTrueUSD(newTrueUSD);
69         tokenController.claimStorageForProxy(newTrueUSD, balanceSheetAddress, allowanceSheetAddress);
70 
71         // Configure TrueUSD
72         tokenController.setTusdRegistry(registry);
73         tokenController.setGlobalPause(globalPause);
74 
75         // Point oldTrueUSD delegation to NewTrueUSD
76         tokenController.transferChild(oldTrueUSD, address(this));
77         oldTrueUSD.claimOwnership();
78         oldTrueUSD.delegateToNewContract(newTrueUSD);
79         
80         // Controller owns both old and new TrueUSD
81         oldTrueUSD.transferOwnership(tokenController);
82         tokenController.issueClaimOwnership(oldTrueUSD);
83         tokenController.transferOwnership(endOwner);
84     }
85 }