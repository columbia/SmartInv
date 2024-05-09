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
16 
17 bestSolution: public(uint256)
18 addressOfWinner: public(address)
19 
20 durationInBlocks: public(uint256)
21 competitionEnd: public(uint256)
22 claimPeriodeLength: public(uint256)
23 
24 
25 # METHODS:
26 @public
27 def __init__(_durationInBlocks: uint256):
28     self.owner = msg.sender
29     self.bestSolution = 0
30     self.durationInBlocks = _durationInBlocks
31     self.competitionEnd = block.number + _durationInBlocks
32     self.addressOfWinner = ZERO_ADDRESS
33     # set claim periode to three days
34     # assuming an average blocktime of 14 seconds -> 86400/14
35     self.claimPeriodeLength = 6172
36 
37 
38 @public
39 @payable
40 def __default__():
41     # return any funds sent to the contract address directly
42     send(msg.sender, msg.value)
43 
44 
45 @private
46 def _calculateNewSolution(_x1: uint256, _x2: uint256) -> uint256:
47     # check new parameters against constraints
48     assert _x1 <= 40
49     assert _x2 <= 35
50     assert (3 * _x1) + (2 * _x2) <= 200
51     assert _x1 + _x2 <= 120
52     assert _x1 > 0 and _x2 > 0
53     # calculate and return new solution
54     return (4 * _x1) + (6 * _x2)
55 
56 
57 @public
58 def submitSolution(_x1: uint256, _x2: uint256) -> uint256:
59     newSolution: uint256
60     newSolution = self._calculateNewSolution(_x1, _x2)
61     assert newSolution > self.bestSolution
62     # save the solution and it's values
63     self.x1 = _x1
64     self.x2 = _x2
65     self.bestSolution = newSolution
66     self.addressOfWinner = msg.sender
67     log.NewSolutionFound(msg.sender, newSolution)
68     return newSolution
69 
70 
71 @public
72 def claimBounty():
73     assert block.number > self.competitionEnd
74     if (self.addressOfWinner == ZERO_ADDRESS):
75         # no solution was found -> extend duration of competition
76         self.competitionEnd = block.number + self.durationInBlocks
77     else:
78         assert block.number < (self.competitionEnd + self.claimPeriodeLength)
79         assert msg.sender == self.addressOfWinner
80         send(self.addressOfWinner, self.balance)
81         # extend duration of competition
82         self.competitionEnd = block.number + self.durationInBlocks
83         log.BountyTransferred(self.addressOfWinner, self.balance)
84 
85 
86 @public
87 @payable
88 def topUpBounty():
89     log.BountyIncreased(msg.value)
90 
91 
92 @public
93 def extendCompetition():
94     # only if no valid solution has been submitted
95     assert self.addressOfWinner == ZERO_ADDRESS
96     assert block.number > (self.competitionEnd + self.claimPeriodeLength)
97     # extend duration of competition
98     self.competitionEnd = block.number + self.durationInBlocks
99     # reset winner address
100     self.addressOfWinner = ZERO_ADDRESS
101     log.CompetitionTimeExtended(self.competitionEnd)