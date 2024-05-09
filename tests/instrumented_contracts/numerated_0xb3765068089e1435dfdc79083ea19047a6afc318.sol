1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev Initializes the contract setting the deployer as the initial owner.
22      */
23     constructor () internal {
24         address msgSender = _msgSender();
25         _owner = msgSender;
26         emit OwnershipTransferred(address(0), msgSender);
27     }
28 
29     /**
30      * @dev Returns the address of the current owner.
31      */
32     function owner() public view virtual returns (address) {
33         return _owner;
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     /**
45      * @dev Leaves the contract without owner. It will not be possible to call
46      * `onlyOwner` functions anymore. Can only be called by the current owner.
47      *
48      * NOTE: Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public virtual onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Transfers ownership of the contract to a new account (`newOwner`).
58      * Can only be called by the current owner.
59      */
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         emit OwnershipTransferred(_owner, newOwner);
63         _owner = newOwner;
64     }
65 }
66 
67 contract EstHashesRegistry is Ownable {
68 
69     mapping (bytes32 => uint32) hashes;
70 
71     function getTimestamp(bytes32 hash) external view returns (uint32) {
72         return hashes[hash];
73     }
74 
75     function addHash(bytes32 hash, uint32 timestamp) external onlyOwner {
76         hashes[hash] = timestamp;
77     }
78 }