1 # Author: Sören Steiger, github.com/ssteiger
2 # License: MIT
3 
4 # EVENTS:
5 NewSolutionFound: event({_addressOfWinner: indexed(address), _solution: uint256})
6 BountyTransferred: event({_to: indexed(address), _amount: wei_value})
7 BountyIncreased: event({_amount: wei_value})
8 CompetitionTimeExtended: event({_to: uint256})
9 
10 
11 # STATE VARIABLES:
12 owner: public(address)
13 
14 x1: public(uint256)
15 x2: public(uint256)
16 x3: public(uint256)
17 x4: public(uint256)
18 
19 bestSolution: public(uint256)
20 addressOfWinner: public(address)
21 
22 durationInBlocks: public(uint256)
23 competitionEnd: public(uint256)
24 claimPeriodeLength: public(uint256)
25 
26 
27 # METHODS:
28 @public
29 def __init__(_durationInBlocks: uint256):
30     self.owner = msg.sender
31     self.bestSolution = 0
32     self.durationInBlocks = _durationInBlocks
33     self.competitionEnd = block.number + _durationInBlocks
34     self.addressOfWinner = ZERO_ADDRESS
35     # set claim periode to three days
36     # assuming an average blocktime of 14 seconds -> 86400/14
37     self.claimPeriodeLength = 6172
38 
39 
40 @public
41 @payable
42 def __default__():
43     # return any funds sent to the contract address directly
44     send(msg.sender, msg.value)
45 
46 
47 @private
48 def _calculateNewSolution(_x1: uint256, _x2: uint256, _x3: uint256, _x4: uint256) -> uint256:
49     # check new parameters against constraints
50     assert _x1 >= 40
51     assert _x2 <= 615
52     assert _x3 < 200 and _x3 < 400
53     assert (3 * _x1) + (2 * _x3) >= 200
54     assert (3 * _x2) - (2 * _x3 * _x4) <= 400
55     assert _x1 + _x2 >= 120
56     assert _x1 > 0 and _x2 > 0 and _x3 > 0
57     assert _x4 == 0 or _x4 == 1
58     assert _x1 + _x2 * _x3 <= 200000
59     assert _x1 + _x2 * _x3 <= 4000
60     # calculate and return new solution
61     return (4 * _x1) + (3 * _x2) - (1000 * _x4)
62 
63 
64 @public
65 def submitSolution(_x1: uint256, _x2: uint256, _x3: uint256, _x4: uint256) -> uint256:
66     newSolution: uint256
67     newSolution = self._calculateNewSolution(_x1, _x2, _x3, _x4)
68     assert newSolution > self.bestSolution
69     # save the solution and it's values
70     self.x1 = _x1
71     self.x2 = _x2
72     self.x3 = _x3
73     self.x4 = _x4
74     self.bestSolution = newSolution
75     self.addressOfWinner = msg.sender
76     log.NewSolutionFound(msg.sender, newSolution)
77     return newSolution
78 
79 
80 @public
81 def claimBounty():
82     assert block.number > self.competitionEnd
83     if (self.addressOfWinner == ZERO_ADDRESS):
84         # no solution was found -> extend duration of competition
85         self.competitionEnd = block.number + self.durationInBlocks
86     else:
87         assert block.number < (self.competitionEnd + self.claimPeriodeLength)
88         assert msg.sender == self.addressOfWinner
89         send(self.addressOfWinner, self.balance)
90         # extend duration of competition
91         self.competitionEnd = block.number + self.durationInBlocks
92         log.BountyTransferred(self.addressOfWinner, self.balance)
93 
94 
95 @public
96 @payable
97 def topUpBounty():
98     log.BountyIncreased(msg.value)
99 
100 
101 @public
102 def extendCompetition():
103     # only if no valid solution has been submitted
104     assert self.addressOfWinner == ZERO_ADDRESS
105     assert block.number > (self.competitionEnd + self.claimPeriodeLength)
106     # extend duration of competition
107     self.competitionEnd = block.number + self.durationInBlocks
108     # reset winner address
109     self.addressOfWinner = ZERO_ADDRESS
110     log.CompetitionTimeExtended(self.competitionEnd)