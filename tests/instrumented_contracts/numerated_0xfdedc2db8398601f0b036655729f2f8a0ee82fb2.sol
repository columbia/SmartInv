1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 contract Governance {
68     using SafeMath for uint256;
69     mapping(bytes32 => Proposal) public proposals;
70     bytes32[] public allProposals;
71     mapping(address => bool) public isVoter;
72     uint256 public voters;
73 
74     struct Proposal {
75         bool finished;
76         uint256 yesVotes;
77         uint256 noVotes;
78         mapping(address => bool) voted;
79         address targetContract;
80         bytes transaction;
81     }
82 
83     event ProposalStarted(bytes32 proposalHash);
84     event ProposalFinished(bytes32 proposalHash);
85     event ProposalExecuted(bytes32 proposalHash);
86     event Vote(bytes32 proposalHash, bool vote, uint256 yesVotes, uint256 noVotes, uint256 voters);
87     event VoterAdded(address voter);
88     event VoterDeleted(address voter);
89 
90     constructor() public {
91         isVoter[msg.sender] = true;
92         voters = 1;
93     }
94 
95     modifier onlyVoter() {
96         require(isVoter[msg.sender], "Should be voter");
97         _;
98     }
99 
100     modifier onlyMe() {
101         require(msg.sender == address(this), "Call via Governance");
102         _;
103     }
104 
105     function newProposal( address _targetContract, bytes memory _transaction ) public onlyVoter {
106         require(_targetContract != address(0), "Address must be non-zero");
107         require(_transaction.length >= 4, "Tx must be 4+ bytes");
108         bytes32 _proposalHash = keccak256(abi.encodePacked(_targetContract, _transaction, now));
109         require(proposals[_proposalHash].transaction.length == 0, "The poll has already been initiated");
110         proposals[_proposalHash].targetContract = _targetContract;
111         proposals[_proposalHash].transaction = _transaction;
112         allProposals.push(_proposalHash);
113         emit ProposalStarted(_proposalHash);
114     }
115 
116     function vote(bytes32 _proposalHash, bool _yes) public onlyVoter { // solhint-disable code-complexity
117         require(!proposals[_proposalHash].voted[msg.sender], "Already voted");
118         require(!proposals[_proposalHash].finished, "Already finished");
119         require(voters > 0, "Should have one or more voters");
120         if (_yes) {
121             proposals[_proposalHash].yesVotes = proposals[_proposalHash].yesVotes.add(1);
122         } else {
123             proposals[_proposalHash].noVotes = proposals[_proposalHash].noVotes.add(1);
124         }
125         emit Vote(_proposalHash, _yes, proposals[_proposalHash].yesVotes, proposals[_proposalHash].noVotes, voters);
126         proposals[_proposalHash].voted[msg.sender] = true;
127         if (voters == 1) {
128             if (proposals[_proposalHash].yesVotes > 0) {
129                 executeProposal(_proposalHash);
130             }
131             finishProposal(_proposalHash);
132             return();
133         }
134         if (voters == 2) {
135             if (proposals[_proposalHash].yesVotes == 2) {
136                 executeProposal(_proposalHash);
137                 finishProposal(_proposalHash);
138             } else if (proposals[_proposalHash].noVotes == 1) {
139                 finishProposal(_proposalHash);
140             }
141             return();
142         }
143         if (proposals[_proposalHash].yesVotes > voters.div(2)) {
144             executeProposal(_proposalHash);
145             finishProposal(_proposalHash);
146             return();
147         } else if (proposals[_proposalHash].noVotes > voters.div(2)) {
148             finishProposal(_proposalHash);
149             return();
150         }
151     }
152 
153     function addVoter(address _address) public onlyMe {
154         require(_address != address(0), "Need non-zero address");
155         require(!isVoter[_address], "Already in voters list");
156         isVoter[_address] = true;
157         voters = voters.add(1);
158         emit VoterAdded(_address);
159     }
160 
161     function delVoter(address _address) public onlyMe {
162         require(msg.sender == address(this), "Call via Governance procedure");
163         require(isVoter[_address], "Not in voters list");
164         isVoter[_address] = false;
165         voters = voters.sub(1);
166         emit VoterDeleted(_address);
167     }
168 
169     function executeProposal(bytes32 _proposalHash) internal {
170         require(!proposals[_proposalHash].finished, "Already finished");
171         // solhint-disable-next-line avoid-low-level-calls
172         (bool success, bytes memory returnData) = address(
173             proposals[_proposalHash].targetContract).call(proposals[_proposalHash].transaction
174         );
175         require(success, string(returnData));
176         emit ProposalExecuted(_proposalHash);
177     }
178 
179     function finishProposal(bytes32 _proposalHash) internal {
180         require(!proposals[_proposalHash].finished, "Already finished");
181         proposals[_proposalHash].finished = true;
182         emit ProposalFinished(_proposalHash);
183     }
184 }