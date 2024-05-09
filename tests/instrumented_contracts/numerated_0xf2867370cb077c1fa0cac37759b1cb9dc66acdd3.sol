1 pragma solidity ^0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external returns (bool);
5     function balanceOf(address who) external returns (uint256);
6 }
7 
8 interface AddressRegistry {
9     function getAddr(string AddrName) external returns(address);
10 }
11 
12 contract Registry {
13     address public RegistryAddress;
14     modifier onlyAdmin() {
15         require(msg.sender == getAddress("admin"));
16         _;
17     }
18     function getAddress(string AddressName) internal view returns(address) {
19         AddressRegistry aRegistry = AddressRegistry(RegistryAddress);
20         address realAddress = aRegistry.getAddr(AddressName);
21         require(realAddress != address(0));
22         return realAddress;
23     }
24 }
25 
26 contract TokenMigration is Registry {
27 
28     address public MTUV1;
29     mapping(address => bool) public Migrated;
30 
31     constructor(address prevMTUAddress, address rAddress) public {
32         MTUV1 = prevMTUAddress;
33         RegistryAddress = rAddress;
34     }
35 
36     function getMTUBal(address holder) internal view returns(uint balance) {
37         token tokenFunctions = token(MTUV1);
38         return tokenFunctions.balanceOf(holder);
39     }
40 
41     function Migrate() public {
42         require(!Migrated[msg.sender]);
43         Migrated[msg.sender] = true;
44         token tokenTransfer = token(getAddress("unit"));
45         tokenTransfer.transfer(msg.sender, getMTUBal(msg.sender));
46     }
47 
48     function SendEtherToAsset(uint256 weiAmt) onlyAdmin public {
49         getAddress("asset").transfer(weiAmt);
50     }
51 
52     function CollectERC20(address tokenAddress) onlyAdmin public {
53         token tokenFunctions = token(tokenAddress);
54         uint256 tokenBal = tokenFunctions.balanceOf(address(this));
55         tokenFunctions.transfer(msg.sender, tokenBal);
56     }
57 
58 }