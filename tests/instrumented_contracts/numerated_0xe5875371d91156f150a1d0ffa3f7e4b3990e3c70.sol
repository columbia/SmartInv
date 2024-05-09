1 pragma solidity ^0.4.21;
2 
3 // File: contracts/AddressRegistry.sol
4 
5 contract AddressRegistry {
6     mapping (address => address) public mainnetAddressFor;
7 
8     event AddressRegistration(address registrant, address registeredMainnetAddress);
9 
10     function register(address mainnetAddress) public {
11         emit AddressRegistration(msg.sender, mainnetAddress);
12         mainnetAddressFor[msg.sender] = mainnetAddress;
13     }
14 }