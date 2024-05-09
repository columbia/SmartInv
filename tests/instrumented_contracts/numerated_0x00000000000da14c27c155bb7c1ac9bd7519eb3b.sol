1 pragma solidity ^0.4.23;
2 
3 // File: contracts/utilities/DepositAddressRegistrar.sol
4 
5 interface Registry {
6     function setAttributeValue(address who, bytes32 what, uint val) external;
7     function hasAttribute(address _who, bytes32 _attribute) external view returns(bool);
8 }
9 
10 contract DepositAddressRegistrar {
11     Registry public registry;
12     
13     bytes32 public constant IS_DEPOSIT_ADDRESS = "isDepositAddress"; 
14     event DepositAddressRegistered(address registeredAddress);
15 
16     constructor(address _registry) public {
17         registry = Registry(_registry);
18     }
19     
20     function registerDepositAddress() public {
21         address shiftedAddress = address(uint(msg.sender) >> 20);
22         require(!registry.hasAttribute(shiftedAddress, IS_DEPOSIT_ADDRESS), "deposit address already registered");
23         registry.setAttributeValue(shiftedAddress, IS_DEPOSIT_ADDRESS, uint(msg.sender));
24         emit DepositAddressRegistered(msg.sender);
25     }
26     
27     function() external payable {
28         registerDepositAddress();
29         msg.sender.transfer(msg.value);
30     }
31 }