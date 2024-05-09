1 pragma solidity ^0.5.3;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     constructor () internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), _owner);
15     }
16 
17     /**
18      * @return the address of the owner.
19      */
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(isOwner());
29         _;
30     }
31 
32     /**
33      * @return true if `msg.sender` is the owner of the contract.
34      */
35     function isOwner() public view returns (bool) {
36         return msg.sender == _owner;
37     }
38 
39     /**
40      * @dev Allows the current owner to relinquish control of the contract.
41      * @notice Renouncing to ownership will leave the contract without an owner.
42      * It will not be possible to call the functions with the `onlyOwner`
43      * modifier anymore.
44      */
45     function renounceOwnership() public onlyOwner {
46         emit OwnershipTransferred(_owner, address(0));
47         _owner = address(0);
48     }
49 
50     /**
51      * @dev Allows the current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      */
54     function transferOwnership(address newOwner) public onlyOwner {
55         _transferOwnership(newOwner);
56     }
57 
58     /**
59      * @dev Transfers control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0));
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 interface ITransferPolicy {
70     function isTransferPossible(address from, address to, uint256 amount) 
71         external view returns (bool);
72     
73     function isBehalfTransferPossible(address sender, address from, address to, uint256 amount) 
74         external view returns (bool);
75 }
76 
77 contract WhitelistTransferPolicy is ITransferPolicy, Ownable {
78     mapping (address => bool) private whitelist;
79 
80     event AddressWhitelisted(address address_);
81     event AddressUnwhitelisted(address address_);
82 
83     constructor() Ownable() public {}
84 
85     function isTransferPossible(address from, address to, uint256) public view returns (bool) {
86         return (whitelist[from] && whitelist[to]);
87     }
88 
89     function isBehalfTransferPossible(address sender, address from, address to, uint256) public view returns (bool) {
90         return (whitelist[from] && whitelist[to] && whitelist[sender]);
91     }
92 
93     function isWhitelisted(address address_) public view returns (bool) {
94         return whitelist[address_];
95     }
96 
97     function unwhitelistAddress(address address_) public onlyOwner returns (bool) {
98         removeFromWhitelist(address_);
99         return true;
100     }
101 
102     function whitelistAddress(address address_) public onlyOwner returns (bool) {
103         addToWhitelist(address_);
104         return true;
105     }
106 
107     function whitelistAddresses(address[] memory addresses) public onlyOwner returns (bool) {
108         uint256 len = addresses.length;
109         for (uint256 i; i < len; i++) {
110             addToWhitelist(addresses[i]);
111         }
112         return true;
113     }
114 
115     function unwhitelistAddresses(address[] memory addresses) public onlyOwner returns (bool) {
116         uint256 len = addresses.length;
117         for (uint256 i; i < len; i++) {
118             removeFromWhitelist(addresses[i]);
119         }
120         return true;
121     }
122 
123     function addToWhitelist(address address_) internal {
124         whitelist[address_] = true;
125         emit AddressWhitelisted(address_);
126     }
127 
128 
129     function removeFromWhitelist(address address_) internal {
130         whitelist[address_] = false;
131         emit AddressUnwhitelisted(address_);
132     }
133 }