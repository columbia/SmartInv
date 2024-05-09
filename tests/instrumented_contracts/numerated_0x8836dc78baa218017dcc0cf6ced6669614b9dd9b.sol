1 pragma solidity ^0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external returns (bool);
5     function balanceOf(address who) external returns (uint256);
6 }
7 
8 contract MoatAddress {
9 
10     event eSetAddr(string AddrName, address TargetAddr);
11 
12     mapping(bytes32 => address) internal addressBook;
13 
14     modifier onlyAdmin() {
15         require(msg.sender == getAddr("admin"));
16         _;
17     }
18 
19     constructor() public {
20         addressBook[keccak256("owner")] = msg.sender;
21         addressBook[keccak256("admin")] = msg.sender;
22     }
23 
24     function setAddr(string AddrName, address Addr) public {
25         require(
26             msg.sender == getAddr("owner") ||
27             msg.sender == getAddr("admin")
28         );
29         addressBook[keccak256(AddrName)] = Addr;
30         emit eSetAddr(AddrName, Addr);
31     }
32 
33     function getAddr(string AddrName) public view returns(address AssignedAddress) {
34         address realAddress = addressBook[keccak256(AddrName)];
35         require(realAddress != address(0));
36         return realAddress;
37     }
38 
39     function SendERC20ToAsset(address tokenAddress) onlyAdmin public {
40         token tokenFunctions = token(tokenAddress);
41         uint256 tokenBal = tokenFunctions.balanceOf(address(this));
42         tokenFunctions.transfer(getAddr("asset"), tokenBal);
43     }
44 
45 }