1 pragma solidity 0.5.9;
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
45      * @dev Allows the current owner to transfer control of the contract to a newOwner.
46      * @param newOwner The address to transfer ownership to.
47      */
48     function transferOwnership(address newOwner) public onlyOwner {
49         _transferOwnership(newOwner);
50     }
51 
52     /**
53      * @dev Transfers control of the contract to a newOwner.
54      * @param newOwner The address to transfer ownership to.
55      */
56     function _transferOwnership(address newOwner) internal {
57         require(newOwner != address(0));
58         emit OwnershipTransferred(_owner, newOwner);
59         _owner = newOwner;
60     }
61 }
62 
63 /**
64  * @title StateDrivenHashStore
65  * @dev The contract has his state and getters
66  */
67 contract HashStore is Ownable {
68     mapping(bytes32 => uint256) private _hashes;
69     event HashAdded(bytes32 hash);
70 
71     function addHash(bytes32 rootHash) external onlyOwner {
72         require(_hashes[rootHash] == 0, "addHash: this hash was already deployed");
73 
74         _hashes[rootHash] = block.timestamp;
75         emit HashAdded(rootHash);
76     }
77 
78     function getHashTimestamp(bytes32 rootHash) external view returns (uint256) {
79         return _hashes[rootHash];
80     }
81 }