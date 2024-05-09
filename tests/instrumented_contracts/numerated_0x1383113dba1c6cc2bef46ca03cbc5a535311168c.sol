1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 // https://github.com/frangio/openzeppelin-contracts/blob/3a237b4441c6aab8631f1e9988c959eaefce72c1/contracts/GSN/Context.sol
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/90ed1af972299070f51bf4665a85da56ac4d355e/contracts/access/Ownable.sol
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor () internal {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Leaves the contract without owner. It will not be possible to call
71      * `onlyOwner` functions anymore. Can only be called by the current owner.
72      *
73      * NOTE: Renouncing ownership will leave the contract without an owner,
74      * thereby removing any functionality that is only available to the owner.
75      */
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         emit OwnershipTransferred(_owner, newOwner);
88         _owner = newOwner;
89     }
90 }
91 
92 contract InblocksPrecedenceSynchronizer is Ownable {
93 
94     struct Info {
95         uint index;
96         uint timestamp;
97     }
98 
99     mapping(bytes32 => Info) internal byRoot;
100     mapping(uint => bytes32) internal byIndex;
101     uint internal count;
102 
103     event Synchronized(bytes32 root, uint index, uint timestamp);
104 
105     function getLast() public view returns (bool isSynchronized, bytes32 root, int index, int timestamp) {
106         return getByIndex(count - 1);
107     }
108 
109     function getByIndex(uint _index) public view returns (bool isSynchronized, bytes32 root, int index, int timestamp) {
110         bytes32 _root;
111         if (_index < count) {
112             _root = byIndex[_index];
113         }
114         return getByRoot(_root);
115     }
116 
117     function getByRoot(bytes32 _root) public view returns (bool isSynchronized, bytes32 root, int index, int timestamp) {
118         if (byRoot[_root].timestamp == 0) {
119             return (false, "", - 1, - 1);
120         }
121         return (true, _root, int(byRoot[_root].index), int(byRoot[_root].timestamp));
122     }
123 
124     function synchronize(bytes32 root, uint index) public onlyOwner {
125         require(index == count);
126         byIndex[index] = root;
127         byRoot[root] = Info({index : index, timestamp : block.timestamp});
128         count++;
129         emit Synchronized(root, byRoot[root].index, byRoot[root].timestamp);
130     }
131 
132 }