1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/MerkleProof.sol
70 
71 pragma solidity 0.5.8;
72 
73 /**
74  * @title MerkleProof
75  * @dev Merkle proof verification based on
76  * https://github.com/ameensol/merkle-tree-solidity/blob/master/src/MerkleProof.sol
77  */
78 library MerkleProof {
79     /**
80     * @dev Verifies a Merkle proof proving the existence of a leaf in a Merkle tree. Assumes that each pair of leaves
81     * and each pair of pre-images are sorted.
82     * @param proof Merkle proof containing sibling hashes on the branch from the leaf to the root of the Merkle tree
83     * @param root Merkle root
84     * @param leaf Leaf of Merkle tree
85     */
86     function verify(
87         bytes32[] memory proof,
88         bytes32 root,
89         bytes32 leaf
90     ) internal pure returns (bool) {
91         bytes32 computedHash = leaf;
92         for (uint256 i = 0; i < proof.length; i++) {
93             bytes32 proofElement = proof[i];
94             if (computedHash < proofElement) {
95                 // Hash(current computed hash + current element of the proof)
96                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
97             } else {
98                 // Hash(current element of the proof + current computed hash)
99                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
100             }
101         }
102         // Check if the computed hash (root) is equal to the provided root
103         return computedHash == root;
104     }
105 }
106 
107 // File: contracts/V12Voting.sol
108 
109 pragma solidity 0.5.8;
110 
111 
112 
113 /**
114  * @title VGT (Vault Guardian Token) voting smart contract.
115  * @author https://peppersec.com
116  * @notice This smart contract implements voting based on ERC20 token. One token equals one vote.
117  * The voting goes up to date chosen by a voting creator. During the voting time, each token holder
118  * can cast for one of three options: "No Change", "Dual token" and "Transaction Split". Read more
119  * about options at https://voting.vault12.com.
120  * @dev Voting creator deploys the contract Merkle Tree root and expiration date.
121  * And then, each VGT holder whose included in the Merkle Tree can vote via `vote` method.
122  */
123 contract V12Voting {
124     using SafeMath for uint256;
125 
126     // soliditySha3('No Change')
127     bytes32 constant public NO_CHANGE = 0x9c7e52ebd85b19725c2fa45fea14ef32d24aa2665b667e9be796bb2811b936fc;
128     // soliditySha3('Dual Token')
129     bytes32 constant public DUAL_TOKEN = 0x0524f98cf62601e849aa545adff164c0f9b0303697043eddaf6d59d4fb4e4736;
130     // soliditySha3('Transaction Split')
131     bytes32 constant public TX_SPLIT = 0x84501b56c2648bdca07999c3b30e6edba0fa8c3178028b395e92f9bb53b4beba;
132 
133     /// @dev The voting offers tree options only. Read more here https://voting.vault12.com
134     mapping(bytes32 => bool) public votingOption;
135 
136     /// @dev IPFS hash of the published Merkle Tree that contains VGT holders.
137     string public ipfs;
138 
139     /// @dev Stores vote of each holder.
140     mapping (address => bytes32) public votes;
141     mapping (bytes32 => uint256) public votingResult;
142 
143     /// @dev Date up to which votes are accepted (timestamp).
144     uint256 public expirationDate;
145 
146     /// @dev Merkle Tree root loaded by the voting creator, which is base for voters' proofs.
147     bytes32 public merkleTreeRoot;
148 
149     /// @dev The event is fired when a holder makes a choice.
150     event NewVote(address indexed who, string vote, uint256 amount);
151 
152     /**
153     * @dev V12Voting contract constructor.
154     * @param _merkleTreeRoot Merkle Tree root of token holders.
155     * @param _ipfs IPFS hash where the Merkle Tree is stored.
156     * @param _expirationDate Date up to which votes are accepted (timestamp).
157     */
158     constructor(
159       bytes32 _merkleTreeRoot,
160       string memory _ipfs,
161       uint256 _expirationDate
162     ) public {
163         require(_expirationDate > block.timestamp, "wrong expiration date");
164         merkleTreeRoot = _merkleTreeRoot;
165         ipfs = _ipfs;
166         expirationDate = _expirationDate;
167 
168         votingOption[NO_CHANGE] = true;
169         votingOption[DUAL_TOKEN] = true;
170         votingOption[TX_SPLIT] = true;
171     }
172 
173     /**
174     * @dev V12Voting vote function.
175     * @param _vote Holder's vote decision.
176     * @param _amount Holder's voting power (VGT token amount).
177     * @param _proof Array of hashes that proofs that a sender is in the Merkle Tree.
178     */
179     function vote(string calldata _vote, uint256 _amount, bytes32[] calldata _proof) external {
180         require(canVote(msg.sender), "already voted");
181         require(isVotingOpen(), "voting finished");
182         bytes32 hashOfVote = keccak256(abi.encodePacked(_vote));
183         require(votingOption[hashOfVote], "invalid vote option");
184         bytes32 _leaf = keccak256(abi.encodePacked(keccak256(abi.encode(msg.sender, _amount))));
185         require(verify(_proof, merkleTreeRoot, _leaf), "the proof is wrong");
186 
187         votes[msg.sender] = hashOfVote;
188         votingResult[hashOfVote] = votingResult[hashOfVote].add(_amount);
189 
190         emit NewVote(msg.sender, _vote, _amount);
191     }
192 
193     /**
194     * @dev Returns current results of the voting. All the percents have 2 decimal places.
195     * e.g. value 1337 has to be interpreted as 13.37%
196     * @param _expectedVotingAmount Total amount of tokens of all the holders.
197     * @return noChangePercent Percent of votes casted for "No Change" option.
198     * @return noChangeVotes Amount of tokens casted for "No Change" option.
199     * @return dualTokenPercent Percent of votes casted for "Dual Token" option.
200     * @return dualTokenVotes Amount of tokens casted for "Dual Token" option.
201     * @return txSplitPercent Percent of votes casted for "Transaction Split" option.
202     * @return txSplitVotes Amount of tokens casted for "Transaction Split" option.
203     * @return totalVoted Total amount of tokens voted.
204     * @return turnoutPercent Percent of votes casted so far.
205     */
206     function votingPercentages(uint256 _expectedVotingAmount) external view returns(
207         uint256 noChangePercent,
208         uint256 noChangeVotes,
209         uint256 dualTokenPercent,
210         uint256 dualTokenVotes,
211         uint256 txSplitPercent,
212         uint256 txSplitVotes,
213         uint256 totalVoted,
214         uint256 turnoutPercent
215     ) {
216         noChangeVotes = votingResult[NO_CHANGE];
217         dualTokenVotes = votingResult[DUAL_TOKEN];
218         txSplitVotes = votingResult[TX_SPLIT];
219         totalVoted = noChangeVotes.add(dualTokenVotes).add(txSplitVotes);
220 
221         uint256 oneHundredPercent = 10000;
222         noChangePercent = noChangeVotes.mul(oneHundredPercent).div(totalVoted);
223         dualTokenPercent = dualTokenVotes.mul(oneHundredPercent).div(totalVoted);
224         txSplitPercent = oneHundredPercent.sub(noChangePercent).sub(dualTokenPercent);
225 
226         turnoutPercent = totalVoted.mul(oneHundredPercent).div(_expectedVotingAmount);
227 
228     }
229 
230     /**
231     * @dev Returns true if the voting is open.
232     * @return if the holders still can vote.
233     */
234     function isVotingOpen() public view returns(bool) {
235         return block.timestamp <= expirationDate;
236     }
237 
238     /**
239     * @dev Returns true if the holder has not voted yet. Notice, it does not check
240     the `_who` in the Merkle Tree.
241     * @param _who Holder address to check.
242     * @return if the holder can vote.
243     */
244     function canVote(address _who) public view returns(bool) {
245         return votes[_who] == bytes32(0);
246     }
247 
248     /**
249     * @dev Allows to verify Merkle Tree proof.
250     * @param _proof Array of hashes that proofs that the `_leaf` is in the Merkle Tree.
251     * @param _root Merkle Tree root.
252     * @param _leaf Bottom element of the Merkle Tree.
253     * @return verification result (true of false).
254     */
255     function verify(bytes32[] memory _proof, bytes32 _root, bytes32 _leaf) public pure returns (bool) {
256         return MerkleProof.verify(_proof, _root, _leaf);
257     }
258 }