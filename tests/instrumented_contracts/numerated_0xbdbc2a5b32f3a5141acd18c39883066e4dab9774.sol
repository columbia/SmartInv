1 // File: contracts/OwnableProxy.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract OwnableProxy {
15     address private _proxyOwner;
16     address private _pendingProxyOwner;
17 
18     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19     event NewPendingOwner(address indexed currentOwner, address indexed pendingOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor () internal {
25         _proxyOwner = msg.sender;
26         emit ProxyOwnershipTransferred(address(0), _proxyOwner);
27     }
28 
29     /**
30      * @dev Returns the address of the current owner.
31      */
32     function proxyOwner() public view returns (address) {
33         return _proxyOwner;
34     }
35 
36     /**
37      * @dev Returns the address of the current owner.
38      */
39     function pendingProxyOwner() public view returns (address) {
40         return _pendingProxyOwner;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyProxyOwner() {
47         require(isProxyOwner(), "Ownable: caller is not the owner");
48         _;
49     }
50 
51     /**
52      * @dev Returns true if the caller is the current owner.
53      */
54     function isProxyOwner() public view returns (bool) {
55         return msg.sender == _proxyOwner;
56     }
57 
58     /**
59      * @dev Transfers ownership of the contract to a new account (`newOwner`).
60      * Can only be called by the current owner.
61      */
62     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
63         _transferProxyOwnership(newOwner);
64         emit NewPendingOwner(_proxyOwner, newOwner);
65     }
66 
67     function claimProxyOwnership() public {
68         _claimProxyOwnership(msg.sender);
69     }
70 
71     function initProxyOwnership(address newOwner) public {
72         require(_proxyOwner == address(0), "Ownable: already owned");
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         _transferProxyOwnership(newOwner);
75     }
76 
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      */
81     function _transferProxyOwnership(address newOwner) internal {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         _pendingProxyOwner = newOwner;
84     }
85 
86     function _claimProxyOwnership(address newOwner) internal {
87         require(newOwner == _pendingProxyOwner, "Claimed by wrong address");
88         emit ProxyOwnershipTransferred(_proxyOwner, newOwner);
89         _proxyOwner = newOwner;
90         _pendingProxyOwner = address(0);
91     }
92 
93 }
94 
95 // File: contracts/TokenProxy.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title Proxy
103  * @dev Gives the possibility to delegate any call to a foreign implementation.
104  */
105 contract TokenProxy is OwnableProxy {
106     event Upgraded(address indexed implementation);
107     address public implementation;
108 
109     function upgradeTo(address _address) public onlyProxyOwner{
110         require(_address != implementation, "New implementation cannot be the same as old");
111         implementation = _address;
112         emit Upgraded(_address);
113     }
114 
115     /**
116     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
117     * This function will return whatever the implementation call returns
118     */
119     
120     function () external payable {
121         address _impl = implementation;
122         require(_impl != address(0));
123         assembly {
124             let ptr := mload(0x40)
125             calldatacopy(ptr, returndatasize, calldatasize)
126             let result := delegatecall(gas, _impl, ptr, calldatasize, returndatasize, returndatasize)
127             let size := returndatasize
128             returndatacopy(ptr, 0, size)
129 
130             switch result
131             case 0 { revert(ptr, size) }
132             default { return(ptr, size) }
133         }
134     }
135     
136     /*
137     function() external payable {
138         address position = implementation;
139         
140         assembly {
141             let ptr := mload(0x40)
142             calldatacopy(ptr, returndatasize, calldatasize)
143             let result := delegatecall(gas, sload(position), ptr, calldatasize, returndatasize, returndatasize)
144             returndatacopy(ptr, 0, returndatasize)
145 
146             switch result
147             case 0 { revert(ptr, returndatasize) }
148             default { return(ptr, returndatasize) }
149         }
150     }
151     */
152 
153 }