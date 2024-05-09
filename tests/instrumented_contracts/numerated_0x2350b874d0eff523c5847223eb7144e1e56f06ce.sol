1 pragma solidity ^0.5.1;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 }
32 
33 /**
34  * @title Claimable
35  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
36  * This allows the new owner to accept the transfer.
37  */
38 contract Claimable is Ownable {
39   address public pendingOwner;
40 
41   /**
42    * @dev Modifier throws if called by any account other than the pendingOwner.
43    */
44   modifier onlyPendingOwner() {
45     require(msg.sender == pendingOwner);
46     _;
47   }
48 }  
49 
50 /// @title Synpatreg smart conract for synpat service
51 /// @author Telegram: @msmobile, IBerGroup
52 /// @notice This smart contract write events  with steem post hash
53 ///in particular ProofOfConnect.
54 
55 contract Synpatreg is Claimable {
56     string public version = '1.1.0';
57     mapping(bytes32 => bool) public permlinkSaved;
58     
59     event SynpatRecord(string indexed permlinkSaved_permlink, bytes32 _hashSha);
60     
61     function() external { } 
62  
63     ///@notice Make event record in Ethereumblockchain
64     /// @dev Implied that _hashSha is hash of steemet post title+body
65     /// @param _permlink  string, _permlink of steem post.
66     /// @param _hashSha   - result of Keccak SHA256 function.
67     /// @return true if ok, false otherwise 
68     function writeSha3(string calldata _permlink, bytes32 _hashSha) external  returns (bool){
69         bytes32 hash = calculateSha3(_permlink);
70         require(!permlinkSaved[hash],"Permalink already exist!");
71         permlinkSaved[hash]=true;
72         emit SynpatRecord(_permlink, _hashSha);
73         return true;
74     }
75     
76     ///@notice Calculate hash
77     /// @dev There is web3py analog exists: Web3.soliditySha3(['string'], ['_hashinput'])
78     /// @param _hashinput   - string .
79     /// @return byte32, result of keccak256 (sha3 in old style) 
80     function calculateSha3(string memory _hashinput) public pure returns (bytes32){
81         return keccak256(bytes(_hashinput)); 
82     }
83    
84     
85     ///@dev use in case of depricate this contract
86     function kill() external onlyOwner {
87         selfdestruct(msg.sender);
88     }
89 }