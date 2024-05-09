1 pragma solidity 0.4.19;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/Whitelist.sol
48 
49 contract Whitelist is Ownable {
50     mapping(address => bool) public allowedAddresses;
51 
52     event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);
53 
54     function addToWhitelist(address[] _addresses) public onlyOwner {
55         for (uint256 i = 0; i < _addresses.length; i++) {
56             allowedAddresses[_addresses[i]] = true;
57             WhitelistUpdated(now, "Added", _addresses[i]);
58         }
59     }
60 
61     function removeFromWhitelist(address[] _addresses) public onlyOwner {
62         for (uint256 i = 0; i < _addresses.length; i++) {
63             allowedAddresses[_addresses[i]] = false;
64             WhitelistUpdated(now, "Removed", _addresses[i]);
65         }
66     }
67 
68     function isWhitelisted(address _address) public view returns (bool) {
69         return allowedAddresses[_address];
70     }
71 }