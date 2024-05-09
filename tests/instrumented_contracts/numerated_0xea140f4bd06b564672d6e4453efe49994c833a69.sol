1 pragma solidity ^0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external returns(bool);
5     function balanceOf(address who) external returns(uint256);
6 }
7 
8 interface AddressRegistry {
9     function getAddr(string AddrName) external returns(address);
10 }
11 
12 contract Registry {
13     address public RegistryAddress;
14     address public deployer;
15     modifier onlyAdmin() {
16         require(msg.sender == getAddress("admin"));
17         _;
18     }
19     function getAddress(string AddressName) internal view returns(address) {
20         AddressRegistry aRegistry = AddressRegistry(RegistryAddress);
21         address realAddress = aRegistry.getAddr(AddressName);
22         require(realAddress != address(0));
23         return realAddress;
24     }
25     constructor () public {
26         deployer = msg.sender;
27     }
28     function setRegistryAddr(address rAddress) public {
29         require(msg.sender == deployer);
30         RegistryAddress = rAddress;
31     }
32 }
33 
34 interface MFund {
35     function NonIssueDeposits() external payable;
36 }
37 
38 contract MoatAsset is Registry {
39 
40     event etherReceived(uint val);
41     function () public payable {
42         emit etherReceived(msg.value);
43     }
44 
45     constructor(address rAddress) public {
46         RegistryAddress = rAddress;
47     }    
48 
49     function SendEtherToFund(uint256 weiAmt) onlyAdmin public {
50         MFund MoatFund = MFund(getAddress("fund"));
51         MoatFund.NonIssueDeposits.value(weiAmt)();
52     }
53 
54     function CollectERC20(address tokenAddress) onlyAdmin public {
55         token tokenFunctions = token(tokenAddress);
56         uint256 tokenBal = tokenFunctions.balanceOf(address(this));
57         tokenFunctions.transfer(msg.sender, tokenBal);
58     }
59 
60     function SendEtherToDex(uint256 weiAmt) onlyAdmin public {
61         getAddress("dex").transfer(weiAmt);
62     }
63 
64     function SendERC20ToDex(address tokenAddress) onlyAdmin public {
65         token tokenFunctions = token(tokenAddress);
66         uint256 tokenBal = tokenFunctions.balanceOf(address(this));
67         tokenFunctions.transfer(getAddress("dex"), tokenBal);
68     }
69 
70 }