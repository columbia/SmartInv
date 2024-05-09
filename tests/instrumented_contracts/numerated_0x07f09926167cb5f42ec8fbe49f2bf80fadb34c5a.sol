1 pragma solidity 0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         emit OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 
45 contract Whitelist is Ownable {
46     mapping(address => bool) public allowedAddresses;
47 
48     event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);
49 
50     function addToWhitelist(address[] _addresses) public onlyOwner {
51         for (uint256 i = 0; i < _addresses.length; i++) {
52             allowedAddresses[_addresses[i]] = true;
53             emit WhitelistUpdated(now, "Added", _addresses[i]);
54         }
55     }
56 
57     function removeFromWhitelist(address[] _addresses) public onlyOwner {
58         for (uint256 i = 0; i < _addresses.length; i++) {
59             allowedAddresses[_addresses[i]] = false;
60             emit WhitelistUpdated(now, "Removed", _addresses[i]);
61         }
62     }
63 
64     function isWhitelisted(address _address) public view returns (bool) {
65         return allowedAddresses[_address];
66     }
67 }