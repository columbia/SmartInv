1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title A contract that maintains a hashtable of EOS addresses associated with Ethereum addresses
5  * @author Sagewise
6  */
7 contract EOSVerify {
8   event LogRegisterEOSAddress(address indexed _from, string _eosAddress);
9   mapping(address => string) public eosAddressBook;
10 
11   /**
12    * @notice Associate a string, which represents an EOS address, to the Ethereum address of the entity interacting with the contract
13    * @param eosAddress A string value that represents an EOS address
14    */
15   function registerEOSAddress(string eosAddress) public {
16     assert(bytes(eosAddress).length <= 64);
17 
18     eosAddressBook[msg.sender] = eosAddress;
19 
20     emit LogRegisterEOSAddress(msg.sender, eosAddress);
21   }
22 }