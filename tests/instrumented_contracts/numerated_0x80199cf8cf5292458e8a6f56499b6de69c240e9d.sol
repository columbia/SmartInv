1 pragma solidity ^0.4.18;
2 
3 /// @title Ownable contract
4 contract Ownable {
5 
6   address public owner;
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9   
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14   modifier onlyOwner() {
15     require(msg.sender == owner);
16     _;
17   }
18 
19   function transferOwnership(address newOwner) onlyOwner public {
20     require(newOwner != address(0));
21     OwnershipTransferred(owner, newOwner);
22     owner = newOwner;
23   }
24   
25 }
26 
27 /// @title Mortal contract - used to selfdestruct once we have no use of this contract
28 contract Mortal is Ownable {
29     function executeSelfdestruct() onlyOwner {
30         selfdestruct(owner);
31     }
32 }
33 
34 /// @title CCWhitelist contract
35 contract CCWhitelist is Mortal {
36     
37     mapping (address => bool) public whitelisted;
38 
39     /// @dev Whitelist a single address
40     /// @param addr Address to be whitelisted
41     function whitelist(address addr) public onlyOwner {
42         require(!whitelisted[addr]);
43         whitelisted[addr] = true;
44     }
45 
46     /// @dev Remove an address from whitelist
47     /// @param addr Address to be removed from whitelist
48     function unwhitelist(address addr) public onlyOwner {
49         require(whitelisted[addr]);
50         whitelisted[addr] = false;
51     }
52 
53     /// @dev Whitelist array of addresses
54     /// @param arr Array of addresses to be whitelisted
55     function bulkWhitelist(address[] arr) public onlyOwner {
56         for (uint i = 0; i < arr.length; i++) {
57             whitelisted[arr[i]] = true;
58         }
59     }
60 
61     /// @dev Check if address is whitelisted
62     /// @param addr Address to be checked if it is whitelisted
63     /// @return Is address whitelisted?
64     function isWhitelisted(address addr) public constant returns (bool) {
65         return whitelisted[addr];
66     }   
67 
68 }