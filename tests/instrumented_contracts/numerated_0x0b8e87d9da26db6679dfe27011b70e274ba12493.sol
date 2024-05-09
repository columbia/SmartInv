1 pragma solidity ^0.4.23;
2 
3 /**
4 * @title Ownable
5 * @dev The Ownable contract has an owner address, and provides basic authorization control
6 * functions, this simplifies the implementation of "user permissions".
7 */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17     * account.
18     */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     /**
24     * @dev Throws if called by any account other than the owner.
25     */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32     * @dev Allows the current owner to transfer control of the contract to a newOwner.
33     * @param newOwner The address to transfer ownership to.
34     */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 contract Vote is Ownable {
44     // Candidate registered
45     event CandidateRegistered(uint candidateId, string candidateName, string candidateDescription);
46     // Vote cast
47     event VoteCast(uint candidateId);
48 
49     struct Candidate {
50         uint candidateId;
51         string candidateName;
52         string candidateDescription;
53     }
54 
55     uint internal salt;
56     string public voteName;
57     uint public totalVotes;
58 
59     // mapping of candidate IDs to votes
60     mapping (uint => uint) public voteCount;
61     // mapping of scerets to vote status
62     mapping (bytes32 => bool) internal canVote;
63     // counter/mapping of candidates
64     uint public nextCandidateId = 1;
65     mapping (uint => Candidate) public candidateDirectory;
66 
67     constructor(uint _salt, string _voteName, bytes32[] approvedHashes) public {
68         salt = _salt;
69         voteName = _voteName;
70         totalVotes = approvedHashes.length;
71         for (uint i; i < approvedHashes.length; i++) {
72             canVote[approvedHashes[i]] = true;
73         }
74     }
75 
76     // Allows the owner to register new candidates
77     function registerCandidate(string candidateName, string candidateDescription) public onlyOwner {
78         uint candidateId = nextCandidateId++;
79         candidateDirectory[candidateId] = Candidate(candidateId, candidateName, candidateDescription);
80         emit CandidateRegistered(candidateId, candidateName, candidateDescription);
81     }
82 
83     // get candidate information by id
84     function candidateInformation(uint candidateId) public view returns (string name, string description) {
85         Candidate storage candidate = candidateDirectory[candidateId];
86         return (candidate.candidateName, candidate.candidateDescription);
87     }
88 
89     // Users can only vote by providing a secret uint s.t. candidateDirectory[keccak256(uint, salt)] == true
90     function castVote(uint secret, uint candidateId) public {
91         bytes32 claimedApprovedHash = keccak256(secret, salt); // keccak256(secret) vulnerable to a rainbow table attack
92         require(canVote[claimedApprovedHash], "Provided secret was not correct.");
93         canVote[claimedApprovedHash] = false;
94         voteCount[candidateId] += 1;
95 
96         emit VoteCast(candidateId);
97     }
98 }