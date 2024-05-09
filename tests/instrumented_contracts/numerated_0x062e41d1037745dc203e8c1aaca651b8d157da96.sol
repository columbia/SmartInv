1 pragma solidity ^0.4.17;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
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
44 /**
45  * @title Whitelist
46  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
47  * @dev This simplifies the implementation of "user permissions".
48  */
49 contract Whitelist is Ownable {
50   mapping(address => bool) public whitelist;
51   
52   event WhitelistedAddressAdded(address addr);
53   event WhitelistedAddressRemoved(address addr);
54 
55   /**
56    * @dev Throws if called by any account that's not whitelisted.
57    */
58   modifier onlyWhitelisted() {
59     require(whitelist[msg.sender]);
60     _;
61   }
62 
63   /**
64    * @dev add an address to the whitelist
65    * @param addr address
66    * @return true if the address was added to the whitelist, false if the address was already in the whitelist 
67    */
68   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
69     if (!whitelist[addr]) {
70       whitelist[addr] = true;
71       WhitelistedAddressAdded(addr);
72       success = true; 
73     }
74   }
75 
76   /**
77    * @dev add addresses to the whitelist
78    * @param addrs addresses
79    * @return true if at least one address was added to the whitelist, 
80    * false if all addresses were already in the whitelist  
81    */
82   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
83     for (uint256 i = 0; i < addrs.length; i++) {
84       if (addAddressToWhitelist(addrs[i])) {
85         success = true;
86       }
87     }
88   }
89 
90   /**
91    * @dev remove an address from the whitelist
92    * @param addr address
93    * @return true if the address was removed from the whitelist, 
94    * false if the address wasn't in the whitelist in the first place 
95    */
96   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
97     if (whitelist[addr]) {
98       whitelist[addr] = false;
99       WhitelistedAddressRemoved(addr);
100       success = true;
101     }
102   }
103 
104   /**
105    * @dev remove addresses from the whitelist
106    * @param addrs addresses
107    * @return true if at least one address was removed from the whitelist, 
108    * false if all addresses weren't in the whitelist in the first place
109    */
110   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
111     for (uint256 i = 0; i < addrs.length; i++) {
112       if (removeAddressFromWhitelist(addrs[i])) {
113         success = true;
114       }
115     }
116   }
117 
118 }