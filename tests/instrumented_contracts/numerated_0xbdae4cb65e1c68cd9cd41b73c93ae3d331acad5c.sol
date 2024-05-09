1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4     address public owner;
5 
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10     /**
11     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12     * account.
13     */
14     function Ownable() public {
15         owner = msg.sender;
16     }
17 
18     /**
19     * @dev Throws if called by any account other than the owner.
20     */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     /**
27     * @dev Allows the current owner to transfer control of the contract to a newOwner.
28     * @param newOwner The address to transfer ownership to.
29     */
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(0));
32         emit OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 
36 }
37 
38 contract Vote is Ownable {
39     // Candidate registered
40     event CandidateRegistered(uint candidateId, string candidateName, string candidateDescription);
41     // Vote cast
42     event VoteCast(uint candidateId);
43 
44     struct Candidate {
45         uint candidateId;
46         string candidateName;
47         string candidateDescription;
48     }
49 
50     uint internal salt;
51     string public voteName;
52     uint public totalVotes;
53 
54     // mapping of candidate IDs to votes
55     mapping (uint => uint) public voteCount;
56     // mapping of scerets to vote status
57     mapping (bytes32 => bool) internal canVote;
58     // counter/mapping of candidates
59     uint public nextCandidateId = 1;
60     mapping (uint => Candidate) public candidateDirectory;
61 
62     function Vote(uint _salt, string _voteName, bytes32[] approvedHashes) public {
63         salt = _salt;
64         voteName = _voteName;
65         totalVotes = approvedHashes.length;
66         for (uint i; i < approvedHashes.length; i++) {
67             canVote[approvedHashes[i]] = true;
68         }
69     }
70 
71     // Allows the owner to register new candidates
72     function registerCandidate(string candidateName, string candidateDescription) public onlyOwner {
73         uint candidateId = nextCandidateId++;
74         candidateDirectory[candidateId] = Candidate(candidateId, candidateName, candidateDescription);
75         emit CandidateRegistered(candidateId, candidateName, candidateDescription);
76     }
77 
78     // get candidate information by id
79     function candidateInformation(uint candidateId) public view returns (string name, string description) {
80         Candidate storage candidate = candidateDirectory[candidateId];
81         return (candidate.candidateName, candidate.candidateDescription);
82     }
83 
84     // Users can only vote by providing a secret uint s.t. candidateDirectory[keccak256(uint, salt)] == true
85     function castVote(uint secret, uint candidateId) public {
86         bytes32 claimedApprovedHash = keccak256(secret, salt); // keccak256(secret) vulnerable to a rainbow table attack
87         require(canVote[claimedApprovedHash]);
88         canVote[claimedApprovedHash] = false;
89         voteCount[candidateId] += 1;
90 
91         emit VoteCast(candidateId);
92     }
93 }