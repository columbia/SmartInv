1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 contract AddressWhitelist is Ownable {
75     enum Status { None, In, Out }
76     mapping(address => Status) private whitelist;
77 
78     address[] private whitelistIndices;
79 
80     // Adds an address to the whitelist
81     function addToWhitelist(address newElement) external onlyOwner {
82         // Ignore if address is already included
83         if (whitelist[newElement] == Status.In) {
84             return;
85         }
86 
87         // Only append new addresses to the array, never a duplicate
88         if (whitelist[newElement] == Status.None) {
89             whitelistIndices.push(newElement);
90         }
91 
92         whitelist[newElement] = Status.In;
93 
94         emit AddToWhitelist(newElement);
95     }
96 
97     // Removes an address from the whitelist.
98     function removeFromWhitelist(address elementToRemove) external onlyOwner {
99         if (whitelist[elementToRemove] != Status.Out) {
100             whitelist[elementToRemove] = Status.Out;
101             emit RemoveFromWhitelist(elementToRemove);
102         }
103     }
104 
105     // Checks whether an address is on the whitelist.
106     function isOnWhitelist(address elementToCheck) external view returns (bool) {
107         return whitelist[elementToCheck] == Status.In;
108     }
109 
110     // Gets all addresses that are currently included in the whitelist
111     // Note: This method skips over, but still iterates through addresses.
112     // It is possible for this call to run out of gas if a large number of
113     // addresses have been removed. To prevent this unlikely scenario, we can
114     // modify the implementation so that when addresses are removed, the last addresses
115     // in the array is moved to the empty index.
116     function getWhitelist() external view returns (address[] memory activeWhitelist) {
117         // Determine size of whitelist first
118         uint activeCount = 0;
119         for (uint i = 0; i < whitelistIndices.length; i++) {
120             if (whitelist[whitelistIndices[i]] == Status.In) {
121                 activeCount++;
122             }
123         }
124 
125         // Populate whitelist
126         activeWhitelist = new address[](activeCount);
127         activeCount = 0;
128         for (uint i = 0; i < whitelistIndices.length; i++) {
129             address addr = whitelistIndices[i];
130             if (whitelist[addr] == Status.In) {
131                 activeWhitelist[activeCount] = addr;
132                 activeCount++;
133             }
134         }
135     }
136 
137     event AddToWhitelist(address indexed addedAddress);
138     event RemoveFromWhitelist(address indexed removedAddress);
139 }