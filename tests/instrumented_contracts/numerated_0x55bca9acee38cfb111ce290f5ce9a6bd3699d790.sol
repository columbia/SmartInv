1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: contracts/Recovery.sol
77 
78 pragma solidity ^0.5.0;
79 
80 
81 contract Recovery is Ownable {
82     uint256 public depositValue;
83 
84     mapping(uint256 => address[]) public votes;
85     mapping(uint256 => mapping(address => bool)) public voted;
86 
87     event VotedForRecovery(uint256 indexed height, address voter);
88 
89     function setDeposit(uint256 DepositValue) public onlyOwner {
90         depositValue = DepositValue;
91     }
92 
93     function withdraw() public onlyOwner {
94         msg.sender.transfer(address(this).balance);
95     }
96 
97     function voteForSkipBlock(uint256 height) public payable {
98         require(msg.value >= depositValue);
99         require(!voted[height][msg.sender]);
100 
101         votes[height].push(msg.sender);
102         voted[height][msg.sender] = true;
103 
104         emit VotedForRecovery(height, msg.sender);
105     }
106 
107     function numVotes(uint256 height) public returns (uint256) {
108         return votes[height].length;
109     }
110 }