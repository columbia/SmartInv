1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /*
45  * Manager that stores permitted addresses 
46  */
47 contract PermissionManager is Ownable {
48     mapping (address => bool) permittedAddresses;
49 
50     function addAddress(address newAddress) public onlyOwner {
51         permittedAddresses[newAddress] = true;
52     }
53 
54     function removeAddress(address remAddress) public onlyOwner {
55         permittedAddresses[remAddress] = false;
56     }
57 
58     function isPermitted(address pAddress) public view returns(bool) {
59         if (permittedAddresses[pAddress]) {
60             return true;
61         }
62         return false;
63     }
64 }