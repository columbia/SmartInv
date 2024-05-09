1 pragma solidity ^0.4.13;
2 
3 contract DependentOnIPFS {
4   /**
5    * @dev Validate a multihash bytes value
6    */
7   function isValidIPFSMultihash(bytes _multihashBytes) internal pure returns (bool) {
8     require(_multihashBytes.length > 2);
9 
10     uint8 _size;
11 
12     // There isn't another way to extract only this byte into a uint8
13     // solhint-disable no-inline-assembly
14     assembly {
15       // Seek forward 33 bytes beyond the solidity length value and the hash function byte
16       _size := byte(0, mload(add(_multihashBytes, 33)))
17     }
18 
19     return (_multihashBytes.length == _size + 2);
20   }
21 }
22 
23 contract Poll is DependentOnIPFS {
24   // There isn't a way around using time to determine when votes can be cast
25   // solhint-disable not-rely-on-time
26 
27   bytes public pollDataMultihash;
28   uint16 public numChoices;
29   uint256 public startTime;
30   uint256 public endTime;
31   address public author;
32 
33   mapping(address => uint16) public votes;
34 
35   event VoteCast(address indexed voter, uint16 indexed choice);
36 
37   function Poll(
38     bytes _ipfsHash,
39     uint16 _numChoices,
40     uint256 _startTime,
41     uint256 _endTime,
42     address _author
43   ) public {
44     require(_startTime >= now && _endTime > _startTime);
45     require(isValidIPFSMultihash(_ipfsHash));
46 
47     numChoices = _numChoices;
48     startTime = _startTime;
49     endTime = _endTime;
50     pollDataMultihash = _ipfsHash;
51     author = _author;
52   }
53 
54   /**
55    * @dev Cast or change your vote
56    * @param _choice The index of the option in the corresponding IPFS document.
57    */
58   function vote(uint16 _choice) public duringPoll {
59     // Choices are indexed from 1 since the mapping returns 0 for "no vote cast"
60     require(_choice <= numChoices && _choice > 0);
61 
62     votes[msg.sender] = _choice;
63     VoteCast(msg.sender, _choice);
64   }
65 
66   modifier duringPoll {
67     require(now >= startTime && now <= endTime);
68     _;
69   }
70 }
71 
72 contract VotingCenter {
73   Poll[] public polls;
74 
75   event PollCreated(address indexed poll, address indexed author);
76 
77   /**
78    * @dev create a poll and store the address of the poll in this contract
79    * @param _ipfsHash Multihash for IPFS file containing poll information
80    * @param _numOptions Number of choices in this poll
81    * @param _startTime Time after which a user can cast a vote in the poll
82    * @param _endTime Time after which the poll no longer accepts new votes
83    * @return The address of the new Poll
84    */
85   function createPoll(
86     bytes _ipfsHash,
87     uint16 _numOptions,
88     uint256 _startTime,
89     uint256 _endTime
90   ) public returns (address) {
91     Poll newPoll = new Poll(_ipfsHash, _numOptions, _startTime, _endTime, msg.sender);
92     polls.push(newPoll);
93 
94     PollCreated(address(newPoll), msg.sender);
95 
96     return address(newPoll);
97   }
98 
99   function allPolls() view public returns (Poll[]) {
100     return polls;
101   }
102 
103   function numPolls() view public returns (uint256) {
104     return polls.length;
105   }
106 }