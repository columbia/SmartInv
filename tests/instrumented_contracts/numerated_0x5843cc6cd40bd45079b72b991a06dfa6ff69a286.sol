1 pragma solidity ^0.5.2;
2 pragma experimental ABIEncoderV2;
3 
4 contract Ownable {
5   address private _owner;
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   constructor() public {
18     _owner = msg.sender;
19   }
20 
21   /**
22    * @return the address of the owner.
23    */
24   function owner() public view returns(address) {
25     return _owner;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(isOwner());
33     _;
34   }
35 
36   /**
37    * @return true if `msg.sender` is the owner of the contract.
38    */
39   function isOwner() public view returns(bool) {
40     return msg.sender == _owner;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    * @notice Renouncing to ownership will leave the contract without an owner.
46    * It will not be possible to call the functions with the `onlyOwner`
47    * modifier anymore.
48    */
49   function renounceOwnership() public onlyOwner {
50     emit OwnershipRenounced(_owner);
51     _owner = address(0);
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     _transferOwnership(newOwner);
60   }
61 
62   /**
63    * @dev Transfers control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function _transferOwnership(address newOwner) internal {
67     require(newOwner != address(0));
68     emit OwnershipTransferred(_owner, newOwner);
69     _owner = newOwner;
70   }
71 }
72 
73 contract TwitterPoll is Ownable {
74   using ConcatLib for string[];
75   string public question;
76   string[] public yesVotes;
77   string[] public noVotes;
78 
79   constructor(string memory _question) public {
80     question = _question;
81   }
82 
83   function submitVotes(string[] memory _yesVotes, string[] memory _noVotes) public onlyOwner() {
84     yesVotes.concat(_yesVotes);
85     noVotes.concat(_noVotes);
86   }
87 
88   function getYesVotes() public view returns (string[] memory){
89     return yesVotes;
90   }
91 
92   function getNoVotes() public view returns (string[] memory){
93     return noVotes;
94   }
95 }
96 
97 library ConcatLib {
98   function concat(string[] storage _preBytes, string[] memory _postBytes) internal  {
99     for (uint i=0; i < _postBytes.length; i++) {
100       _preBytes.push(_postBytes[i]);
101     }
102   }
103 }