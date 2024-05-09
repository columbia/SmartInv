1 pragma solidity ^0.4.19;
2 
3 contract Gatekeeper {
4     function enter(bytes32 _passcode, bytes8 _gateKey) public returns (bool);
5 }
6 
7 contract cyberEntry {
8     address public gkAddress;
9 
10     Gatekeeper gk; 
11 
12     function cyberEntry(address _gkAddress) public {
13         gkAddress = _gkAddress;
14         gk = Gatekeeper(gkAddress);
15     }
16 
17     function enter(bytes32 passphrase) public {
18         uint256 stipend = 483657;
19         
20         uint256 key;
21         uint256 upper;
22         uint256 lower;
23 
24         upper = uint256(bytes4("cool")) << 32;
25         lower = uint256(uint16(msg.sender));
26 
27         key = upper | lower;
28 
29         gk.enter.gas(stipend)( passphrase, bytes8(key));
30     }
31 }