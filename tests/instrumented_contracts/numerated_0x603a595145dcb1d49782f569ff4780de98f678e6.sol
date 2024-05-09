1 pragma solidity 0.4.24;
2 
3 /**
4  * @title IPFS hash handler
5  *
6  * @dev IPFS multihash handler. Does a small check to validate that a multihash is
7  *   correct by validating the digest size byte of the hash. For example, the IPFS
8  *   Multihash "QmPtkU87jX1SnyhjAgUwnirmabAmeASQ4wGfwxviJSA4wf" is the base58
9  *   encoded form of the following data:
10  *
11  *     ┌────┬────┬───────────────────────────────────────────────────────────────────┐
12  *     │byte│byte│             variable length hash based on digest size             │
13  *     ├────┼────┼───────────────────────────────────────────────────────────────────┤
14  *     │0x12│0x20│0x1714c8d0fa5dbe9e6c04059ddac50c3860fb0370d67af53f2bd51a4def656526 │
15  *     └────┴────┴───────────────────────────────────────────────────────────────────┘
16  *       ▲    ▲                                   ▲
17  *       │    └───────────┐                       │
18  *   hash function    digest size             hash value
19  *
20  * we still store the data as `bytes` since it is inherently a variable length structure.
21  *
22  * @dev See multihash format: https://git.io/vbooc
23  */
24 contract DependentOnIPFS {
25   /**
26    * @dev Validate a multihash bytes value
27    */
28   function isValidIPFSMultihash(bytes _multihashBytes) internal pure returns (bool) {
29     require(_multihashBytes.length > 2);
30 
31     uint8 _size;
32 
33     // There isn't another way to extract only this byte into a uint8
34     // solhint-disable no-inline-assembly
35     assembly {
36       // Seek forward 33 bytes beyond the solidity length value and the hash function byte
37       _size := byte(0, mload(add(_multihashBytes, 33)))
38     }
39 
40     return (_multihashBytes.length == _size + 2);
41   }
42 }
43 
44 /**
45  * @title Voteable poll with associated IPFS data
46  *
47  * A poll records votes on a variable number of choices. A poll specifies
48  * a window during which users can vote. Information like the poll title and
49  * the descriptions for each option are stored on IPFS.
50  */
51 contract Poll is DependentOnIPFS {
52   // There isn't a way around using time to determine when votes can be cast
53   // solhint-disable not-rely-on-time
54 
55   bytes public pollDataMultihash;
56   uint16 public numChoices;
57   uint256 public startTime;
58   uint256 public endTime;
59   address public author;
60   address public pollAdmin;
61 
62   AccountRegistryInterface public registry;
63   SigningLogicInterface public signingLogic;
64 
65   mapping(uint256 => uint16) public votes;
66 
67   mapping (bytes32 => bool) public usedSignatures;
68 
69   event VoteCast(address indexed voter, uint16 indexed choice);
70 
71   constructor(
72     bytes _ipfsHash,
73     uint16 _numChoices,
74     uint256 _startTime,
75     uint256 _endTime,
76     address _author,
77     AccountRegistryInterface _registry,
78     SigningLogicInterface _signingLogic,
79     address _pollAdmin
80   ) public {
81     require(_startTime >= now && _endTime > _startTime);
82     require(isValidIPFSMultihash(_ipfsHash));
83 
84     numChoices = _numChoices;
85     startTime = _startTime;
86     endTime = _endTime;
87     pollDataMultihash = _ipfsHash;
88     author = _author;
89     registry = _registry;
90     signingLogic = _signingLogic;
91     pollAdmin = _pollAdmin;
92   }
93 
94   function vote(uint16 _choice) external {
95     voteForUser(_choice, msg.sender);
96   }
97 
98   function voteFor(uint16 _choice, address _voter, bytes32 _nonce, bytes _delegationSig) external onlyPollAdmin {
99     require(!usedSignatures[keccak256(abi.encodePacked(_delegationSig))], "Signature not unique");
100     usedSignatures[keccak256(abi.encodePacked(_delegationSig))] = true;
101     bytes32 _delegationDigest = signingLogic.generateVoteForDelegationSchemaHash(
102       _choice,
103       _voter,
104       _nonce,
105       this
106     );
107     require(_voter == signingLogic.recoverSigner(_delegationDigest, _delegationSig));
108     voteForUser(_choice, _voter);
109   }
110 
111   /**
112    * @dev Cast or change your vote
113    * @param _choice The index of the option in the corresponding IPFS document.
114    */
115   function voteForUser(uint16 _choice, address _voter) internal duringPoll {
116     // Choices are indexed from 1 since the mapping returns 0 for "no vote cast"
117     require(_choice <= numChoices && _choice > 0);
118     uint256 _voterId = registry.accountIdForAddress(_voter);
119 
120     votes[_voterId] = _choice;
121     emit VoteCast(_voter, _choice);
122   }
123 
124   modifier duringPoll {
125     require(now >= startTime && now <= endTime);
126     _;
127   }
128 
129   modifier onlyPollAdmin {
130     require(msg.sender == pollAdmin);
131     _;
132   }
133 }
134 
135 interface AccountRegistryInterface {
136   function accountIdForAddress(address _address) public view returns (uint256);
137   function addressBelongsToAccount(address _address) public view returns (bool);
138   function createNewAccount(address _newUser) external;
139   function addAddressToAccount(
140     address _newAddress,
141     address _sender
142     ) external;
143   function removeAddressFromAccount(address _addressToRemove) external;
144 }
145 
146 contract SigningLogicInterface {
147   function recoverSigner(bytes32 _hash, bytes _sig) external pure returns (address);
148   function generateRequestAttestationSchemaHash(
149     address _subject,
150     address _attester,
151     address _requester,
152     bytes32 _dataHash,
153     uint256[] _typeIds,
154     bytes32 _nonce
155     ) external view returns (bytes32);
156   function generateAttestForDelegationSchemaHash(
157     address _subject,
158     address _requester,
159     uint256 _reward,
160     bytes32 _paymentNonce,
161     bytes32 _dataHash,
162     uint256[] _typeIds,
163     bytes32 _requestNonce
164     ) external view returns (bytes32);
165   function generateContestForDelegationSchemaHash(
166     address _requester,
167     uint256 _reward,
168     bytes32 _paymentNonce
169   ) external view returns (bytes32);
170   function generateStakeForDelegationSchemaHash(
171     address _subject,
172     uint256 _value,
173     bytes32 _paymentNonce,
174     bytes32 _dataHash,
175     uint256[] _typeIds,
176     bytes32 _requestNonce,
177     uint256 _stakeDuration
178     ) external view returns (bytes32);
179   function generateRevokeStakeForDelegationSchemaHash(
180     uint256 _subjectId,
181     uint256 _attestationId
182     ) external view returns (bytes32);
183   function generateAddAddressSchemaHash(
184     address _senderAddress,
185     bytes32 _nonce
186     ) external view returns (bytes32);
187   function generateVoteForDelegationSchemaHash(
188     uint16 _choice,
189     address _voter,
190     bytes32 _nonce,
191     address _poll
192     ) external view returns (bytes32);
193   function generateReleaseTokensSchemaHash(
194     address _sender,
195     address _receiver,
196     uint256 _amount,
197     bytes32 _uuid
198     ) external view returns (bytes32);
199   function generateLockupTokensDelegationSchemaHash(
200     address _sender,
201     uint256 _amount,
202     bytes32 _nonce
203     ) external view returns (bytes32);
204 }
205 
206 /*
207  * @title Bloom voting center
208  * @dev The voting center is the home of all polls conducted within the Bloom network.
209  *   Anyone can create a new poll and there is no "owner" of the network. The Bloom dApp
210  *   assumes that all polls are in the `polls` field so any Bloom poll should be created
211  *   through the `createPoll` function.
212  */
213 contract VotingCenter {
214   Poll[] public polls;
215 
216   event PollCreated(address indexed poll, address indexed author);
217 
218   /**
219    * @dev create a poll and store the address of the poll in this contract
220    * @param _ipfsHash Multihash for IPFS file containing poll information
221    * @param _numOptions Number of choices in this poll
222    * @param _startTime Time after which a user can cast a vote in the poll
223    * @param _endTime Time after which the poll no longer accepts new votes
224    * @return The address of the new Poll
225    */
226   function createPoll(
227     bytes _ipfsHash,
228     uint16 _numOptions,
229     uint256 _startTime,
230     uint256 _endTime,
231     AccountRegistryInterface _registry,
232     SigningLogicInterface _signingLogic,
233     address _pollAdmin
234   ) public returns (address) {
235     Poll newPoll = new Poll(
236       _ipfsHash,
237       _numOptions,
238       _startTime,
239       _endTime,
240       msg.sender,
241       _registry,
242       _signingLogic,
243       _pollAdmin
244       );
245     polls.push(newPoll);
246 
247     emit PollCreated(newPoll, msg.sender);
248 
249     return newPoll;
250   }
251 
252   function allPolls() view public returns (Poll[]) {
253     return polls;
254   }
255 
256   function numPolls() view public returns (uint256) {
257     return polls.length;
258   }
259 }