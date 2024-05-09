1 /**
2  * SignatureChallenge.sol
3 
4  * The links below will provide more information about the MtPelerin's Bridge protocol:
5  * https://www.mtpelerin.com
6  * https://github.com/MtPelerin/MtPelerin-protocol
7 
8  * The unflattened code is available through this github tag:
9  * https://github.com/MtPelerin/MtPelerin-protocol/tree/etherscan-verify-batch-3
10 
11  * @notice Copyright © 2016 - 2019 Mt Pelerin Group SA - All Rights Reserved
12 
13  * @notice All matters regarding the intellectual property of this code 
14  * @notice or software are subject to Swiss Law without reference to its 
15  * @notice conflicts of law rules.
16 
17  * @notice License for each contract is available in the respective file
18  * @notice or in the LICENSE.md file.
19  * @notice https://github.com/MtPelerin/
20 
21  * @notice Code by OpenZeppelin is copyrighted and licensed on their repository:
22  * @notice https://github.com/OpenZeppelin/openzeppelin-solidity
23  */
24 
25 pragma solidity ^0.4.24;
26 
27 // File: contracts/zeppelin/ownership/Ownable.sol
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipRenounced(address indexed previousOwner);
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   constructor() public {
50     owner = msg.sender;
51   }
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to relinquish control of the contract.
63    */
64   function renounceOwnership() public onlyOwner {
65     emit OwnershipRenounced(owner);
66     owner = address(0);
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address _newOwner) public onlyOwner {
74     _transferOwnership(_newOwner);
75   }
76 
77   /**
78    * @dev Transfers control of the contract to a newOwner.
79    * @param _newOwner The address to transfer ownership to.
80    */
81   function _transferOwnership(address _newOwner) internal {
82     require(_newOwner != address(0));
83     emit OwnershipTransferred(owner, _newOwner);
84     owner = _newOwner;
85   }
86 }
87 
88 // File: contracts/SignatureChallenge.sol
89 
90 /**
91  * @title SignatureChallenge
92  * @dev SignatureChallenge accept anyone to send a transaction with a challenge in it.
93  * Any Oracle which creates a challenge, may use it to assess that someone does really
94  * own a given address.
95  *
96  * @notice Copyright © 2016 - 2019 Mt Pelerin Group SA - All Rights Reserved
97  * @notice This content cannot be used, copied or reproduced in part or in whole
98  * @notice without the express and written permission of Mt Pelerin Group SA.
99  * @notice Written by *Mt Pelerin Group SA*, <info@mtpelerin.com>
100  * @notice All matters regarding the intellectual property of this code or software
101  * @notice are subjects to Swiss Law without reference to its conflicts of law rules.
102  *
103  * Error messages
104  * SC01: No ETH must be provided for the challenge
105  * SC02: Target must not be null
106  * SC03: Execution call must be successful
107  * SC04: Challenges are not active
108  * SC05: Challenge must not be longer than challengeBytes
109  *
110  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
111  */
112 contract SignatureChallenge is Ownable {
113 
114   bool public active = true;
115   uint8 public challengeBytes = 2;
116 
117   function () external payable {
118     require(msg.value == 0, "SC01");
119     acceptCode(msg.data);
120   }
121 
122   /**
123    * @dev Update Challenge
124    */
125   function updateChallenge(
126     bool _active,
127     uint8 _challengeBytes,
128     bytes _testCode) public onlyOwner
129   {
130     if(!signChallengeWhenValid()) {
131       active = _active;
132       challengeBytes = _challengeBytes;
133       emit ChallengeUpdated(_active, _challengeBytes);
134 
135       if (active) {
136         acceptCode(_testCode);
137       }
138     }
139   }
140 
141   /**
142    * @dev execute
143    */
144   function execute(address _target, bytes _data)
145     public payable
146   {
147     if (!signChallengeWhenValid()) {
148       executeOwnerRestricted(_target, _data);
149     }
150   }
151 
152   /**
153    * @dev Makes sure to accept the code even it matches a valid function signature.
154    */
155   function signChallengeWhenValid() private returns (bool)
156   {
157     // Prevent any loophole against the default function
158     // SignatureChallenge may be set inactive to bypass this feature
159     if (active && msg.data.length == challengeBytes) {
160       require(msg.value == 0, "SC01");
161       acceptCode(msg.data);
162       return true;
163     }
164     return false;
165   }
166 
167   /**
168    * @dev execute restricted to owner
169    */
170   function executeOwnerRestricted(address _target, bytes _data)
171     private onlyOwner
172   {
173     require(_target != address(0), "SC02");
174     // solium-disable-next-line security/no-call-value
175     require(_target.call.value(msg.value)(_data), "SC03");
176   }
177 
178   /**
179    * @dev accept code
180    */
181   function acceptCode(bytes _code) private {
182     require(active, "SC04");
183     require(_code.length == challengeBytes, "SC05");
184     emit ChallengeSigned(msg.sender, _code);
185   }
186 
187   event ChallengeUpdated(bool active, uint8 length);
188   event ChallengeSigned(address indexed signer, bytes code);
189 }