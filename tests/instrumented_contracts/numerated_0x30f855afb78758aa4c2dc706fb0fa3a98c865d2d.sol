1 pragma solidity 0.4.25;
2 
3 
4 interface IOrbsVoting {
5 
6     event VoteOut(address indexed voter, address[] validators, uint voteCounter);
7     event Delegate(
8         address indexed delegator,
9         address indexed to,
10         uint delegationCounter
11     );
12     event Undelegate(address indexed delegator, uint delegationCounter);
13 
14     /// @dev Voting method to select which validators you want to vote out in this election period.
15     /// @param validators address[] an array of validators addresses you want to vote out. In case you want to vote, but not vote out anyone, send an empty array.
16     function voteOut(address[] validators) external;
17 
18     /// @dev Delegation method to select who you would like to delegate your stake to.
19     /// @param to address the address, you want to delegate your stake to. If you want to cancel a delegation - delegate to yourself to yourself.
20     function delegate(address to) external;
21 
22     /// @dev Delegation method to select who you would like to delegate your stake to.
23     function undelegate() external;
24 
25     /// @dev returns vote pair - validators list and the block number the vote was set.
26     /// @param guardian address the address of the guardian
27     function getCurrentVote(address guardian)
28         external
29         view
30         returns (address[] validators, uint blockNumber);
31 
32     /// @dev returns vote pair - validators list and the block number the vote was set.
33     ///      same as getCurrentVote but returns addresses represented as byte20.
34     function getCurrentVoteBytes20(address guardian)
35         external
36         view
37         returns (bytes20[] validatorsBytes20, uint blockNumber);
38 
39     /// @dev returns the address to which the delegator has delegated the stake
40     /// @param delegator address the address of the delegator
41     function getCurrentDelegation(address delegator)
42         external
43         view
44         returns (address);
45 }
46 
47 
48 contract OrbsVoting is IOrbsVoting {
49 
50     // A vote is a pair of block number and list of validators. The vote's block
51     // number is used to determine the vote qualification for an election event.
52     struct VotingRecord {
53         uint blockNumber;
54         address[] validators;
55     }
56 
57     // The version of the current Voting smart contract.
58     uint public constant VERSION = 1;
59 
60     // Vars to see that voting and delegating is moving forward. Is used to emit
61     // events to test for completeness.
62     uint internal voteCounter;
63     uint internal delegationCounter;
64 
65     // The amount of validators you can vote out in each election round. This will be set to 3 in the construction.
66     uint public maxVoteOutCount;
67 
68     // Internal mappings to keep track of the votes and delegations.
69     mapping(address => VotingRecord) internal votes;
70     mapping(address => address) internal delegations;
71 
72     /// @dev Constructor that initializes the Voting contract. maxVoteOutCount will be set to 3.
73     constructor(uint maxVoteOutCount_) public {
74         require(maxVoteOutCount_ > 0, "maxVoteOutCount_ must be positive");
75         maxVoteOutCount = maxVoteOutCount_;
76     }
77 
78     /// @dev Voting method to select which validators you want to vote out in this election period.
79     /// @param validators address[] an array of validators addresses you want to vote out. In case you want to vote, but not vote out anyone, send an empty array.
80     function voteOut(address[] validators) external {
81         address sender = msg.sender;
82         require(validators.length <= maxVoteOutCount, "Validators list is over the allowed length");
83         sanitizeValidators(validators);
84 
85         voteCounter++;
86 
87         votes[sender] = VotingRecord({
88             blockNumber: block.number,
89             validators: validators
90         });
91 
92         emit VoteOut(sender, validators, voteCounter);
93     }
94 
95     /// @dev Delegation method to select who you would like to delegate your stake to.
96     /// @param to address the address, you want to delegate your stake to. If you want to cancel a delegation - delegate to yourself to yourself.
97     function delegate(address to) external {
98         address sender = msg.sender;
99         require(to != address(0), "must delegate to non 0");
100         require(sender != to , "cant delegate to yourself");
101 
102         delegationCounter++;
103 
104         delegations[sender] = to;
105 
106         emit Delegate(sender, to, delegationCounter);
107     }
108 
109     /// @dev Delegation method to select who you would like to delegate your stake to.
110     function undelegate() external {
111         address sender = msg.sender;
112         delegationCounter++;
113 
114         delete delegations[sender];
115 
116         emit Delegate(sender, sender, delegationCounter);
117         emit Undelegate(sender, delegationCounter);
118     }
119 
120     /// @dev returns vote pair - validators list and the block number the vote was set.
121     ///      same as getCurrentVote but returns addresses represented as byte20.
122     function getCurrentVoteBytes20(address guardian)
123         public
124         view
125         returns (bytes20[] memory validatorsBytes20, uint blockNumber)
126     {
127         address[] memory validatorAddresses;
128         (validatorAddresses, blockNumber) = getCurrentVote(guardian);
129 
130         uint validatorAddressesLength = validatorAddresses.length;
131 
132         validatorsBytes20 = new bytes20[](validatorAddressesLength);
133 
134         for (uint i = 0; i < validatorAddressesLength; i++) {
135             validatorsBytes20[i] = bytes20(validatorAddresses[i]);
136         }
137     }
138 
139     /// @dev returns the address to which the delegator has delegated the stake
140     /// @param delegator address the address of the delegator
141     function getCurrentDelegation(address delegator)
142         public
143         view
144         returns (address)
145     {
146         return delegations[delegator];
147     }
148 
149     /// @dev returns vote pair - validators list and the block number the vote was set.
150     /// @param guardian address the address of the guardian
151     function getCurrentVote(address guardian)
152         public
153         view
154         returns (address[] memory validators, uint blockNumber)
155     {
156         VotingRecord storage lastVote = votes[guardian];
157 
158         blockNumber = lastVote.blockNumber;
159         validators = lastVote.validators;
160     }
161 
162     /// @dev check that the validators array is unique and non zero.
163     /// @param validators address[]
164     function sanitizeValidators(address[] validators)
165         private
166         pure
167     {
168         uint validatorsLength = validators.length;
169         for (uint i = 0; i < validatorsLength; i++) {
170             require(validators[i] != address(0), "All validator addresses must be non 0");
171             for (uint j = i + 1; j < validatorsLength; j++) {
172                 require(validators[j] != validators[i], "Duplicate Validators");
173             }
174         }
175     }
176 }