1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Contract module which provides a basic access control mechanism, where
5  * there is an account (an owner) that can be granted exclusive access to
6  * specific functions.
7  *
8  * This module is used through inheritance. It will make available the modifier
9  * `onlyOwner`, which can be aplied to your functions to restrict their use to
10  * the owner.
11  */
12 contract Ownable {
13     address private _owner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18      * @dev Initializes the contract setting the deployer as the initial owner.
19      */
20     constructor () internal {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26      * @dev Returns the address of the current owner.
27      */
28     function owner() public view returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(isOwner(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40     /**
41      * @dev Returns true if the caller is the current owner.
42      */
43     function isOwner() public view returns (bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48      * @dev Leaves the contract without owner. It will not be possible to call
49      * `onlyOwner` functions anymore. Can only be called by the current owner.
50      *
51      * > Note: Renouncing ownership will leave the contract without an owner,
52      * thereby removing any functionality that is only available to the owner.
53      */
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(_owner, address(0));
56         _owner = address(0);
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 contract AutionRecord is Ownable{
78 
79     event Join(address owner, uint256 userid, uint256 amount, uint256 round );
80     event Reword(address owner, uint256 userid, uint256 amount, uint256 round);
81     event Auctoin(uint256 round, uint256 amount, uint256 bgtime, uint256 edtime, uint256 num);
82 
83     function join(address owner, uint256 userid, uint256 amount, uint256 round ) external onlyOwner{
84         emit Join(owner, userid, amount, round );
85     }
86 
87     function reword(address owner, uint256 userid, uint256 amount, uint256 round ) external onlyOwner{
88         emit Reword(owner, userid, amount, round );
89     }
90 
91     function auctoin(uint256 round, uint256 amount, uint256 bgtime, uint256 edtime, uint256 num) external onlyOwner{
92         emit Auctoin(round, amount, bgtime, edtime, num);
93     }
94 }