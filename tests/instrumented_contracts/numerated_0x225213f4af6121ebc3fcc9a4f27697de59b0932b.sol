1 pragma solidity ^0.4.25;
2 
3 contract BlockTO_9 {
4     address[] addresses;
5     mapping (address => bool) addressValidated;
6     
7     function becomeValidator() public {
8         require(!isValidator(msg.sender));
9         require(addresses.length < 10);
10         addresses.push(msg.sender);
11         addressValidated[msg.sender] = true;
12     }
13 
14     function isValidator(address _who) public view returns (bool) {
15         return addressValidated[_who];
16     }
17 
18     function getValidators() public view returns(address[]) {
19         return addresses;
20     }
21 }