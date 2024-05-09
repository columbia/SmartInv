1 pragma solidity ^0.4.24;
2 
3 
4 contract IAddressDeployerOwner {
5     function ownershipTransferred(address _byWhom) public returns(bool);
6 }
7 
8 
9 contract AddressDeployer {
10     event Deployed(address at);
11 
12     address public owner = msg.sender;
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address _newOwner) public onlyOwner {
20         owner = _newOwner;
21     }
22 
23     function transferOwnershipAndNotify(IAddressDeployerOwner _newOwner) public onlyOwner {
24         owner = _newOwner;
25         require(_newOwner.ownershipTransferred(msg.sender));
26     }
27 
28     function deploy(bytes _data) public onlyOwner returns(address addr) {
29         // solium-disable-next-line security/no-inline-assembly
30         assembly {
31             addr := create(0, add(_data, 0x20), mload(_data))
32         }
33         require(addr != 0);
34         emit Deployed(addr);
35         selfdestruct(msg.sender);
36     }
37 }