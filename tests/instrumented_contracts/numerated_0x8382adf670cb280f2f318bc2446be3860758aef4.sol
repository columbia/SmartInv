1 pragma solidity 0.5.13;
2 
3 // File: openzeppelin-solidity/contracts/GSN/Context.sol
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22     function _msgData() internal view returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 contract Ownable is Context {
38     address private _owner;
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40     /**
41      * @dev Initializes the contract setting the deployer as the initial owner.
42      */
43     constructor () internal {
44         _owner = _msgSender();
45         emit OwnershipTransferred(address(0), _owner);
46     }
47     /**
48      * @dev Returns the address of the current owner.
49      */
50     function owner() public view returns (address) {
51         return _owner;
52     }
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(isOwner(), "Ownable: caller is not the owner");
58         _;
59     }
60     /**
61      * @dev Returns true if the caller is the current owner.
62      */
63     function isOwner() public view returns (bool) {
64         return _msgSender() == _owner;
65     }
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         _transferOwnership(newOwner);
83     }
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      */
87     function _transferOwnership(address newOwner) internal {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 }
93 // File: contracts/GramChain.sol
94 contract GramChain is Ownable {
95     // Map if hash has been submitted to contract
96     mapping (bytes32 => bool) private _containsMap;
97     // The actual hash event
98     event AddedHashEntry(bytes32 indexed hash);
99     // adding entries only if it doesn't already exist and it's the owner
100     function addHashEntry(bytes32 dataHash) external onlyOwner {
101         require(!_containsMap[dataHash], "The given hash already exists");
102         _containsMap[dataHash] = true;
103         emit AddedHashEntry(dataHash);
104     }
105     // adding entries only if it doesn't already exist and it's the owner
106     function addHashEntries(bytes32[] calldata hashlist) external onlyOwner {
107         for (uint i=0; i < hashlist.length; i++) {
108             bytes32 dataHash = hashlist[i];
109             require(!_containsMap[dataHash], "The given hash already exists");
110             _containsMap[dataHash] = true;
111             emit AddedHashEntry(dataHash);
112         }
113     }
114     // Verify hash exists in contract
115     function verifyDataHash(bytes32 dataHash) external view returns (bool) {
116         return _containsMap[dataHash];
117     }
118 }