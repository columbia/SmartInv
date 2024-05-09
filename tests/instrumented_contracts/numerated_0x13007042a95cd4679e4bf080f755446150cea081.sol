1 pragma solidity ^0.4.25;
2 
3 contract subsetSum {
4     // Written by Ciarán Ó hAoláin, Maynooth University 2018
5 
6     // Data types that we need
7     struct Number {
8         bool exists;
9         bool isUsed;
10     }
11     struct Leader {
12         address id;
13         uint256 difference;
14         uint256[] negativeSet;
15         uint256[] positiveSet;
16     }
17 
18     // Things that we need to store
19     uint256[] numbers;
20     mapping (uint256 => Number) numberCheck;
21     mapping (address => bool) authorisedEntrants;
22     uint256 expiryTime;
23     address admin;
24     Leader leader;
25 
26     // Initial set up
27     constructor (uint256[] memory setElements, uint256 expiry) public {
28         require(setElements.length>0 && expiry > now, 'Invalid parameters');
29         numbers = setElements;
30         for (uint256 i = 0; i<setElements.length; i++) {
31             numberCheck[setElements[i]].exists=true;
32         }
33         expiryTime = expiry;
34         admin = msg.sender;
35     }
36 
37     // Record an event on the blockchain whenever a new record is recorded
38     event RunnerUpSubmission(address indexed submitter, uint256 submitterSolutionDifference);
39     event NewRecord(address indexed newRecordHolder, uint256 newRecordDifference);
40 
41     // Only for the competition administrator
42     modifier adminOnly {
43         require(msg.sender==admin, 'This requires admin privileges');
44         _;
45     }
46 
47     // Only for authorised entrants
48     modifier restrictedAccess {
49         require(now<expiryTime && authorisedEntrants[msg.sender], 'Unauthorised entrant');
50         _;
51     }
52 
53     // Withdrawal of prize pot is only allowed after the competition is over, if and only if
54     // the withdrawer is currently on top of the leaderboard OR
55     // there is no leader, so admin requests withdrawal OR
56     // a month has passed after the deadline and the winner hasn't withdrawn the prize pot, so admin requests withdrawal.
57     modifier winnerOnly {
58         require(now>expiryTime && (msg.sender==leader.id || ((address(0)==leader.id || now>expiryTime+2629746) && msg.sender==admin)), "You don't have permission to withdraw the prize");
59         _;
60     }
61 
62     // Get the numbers in the problem set
63     function getNumbers() public view returns(uint256[] numberSet) {
64         return numbers;
65     }
66 
67     // Get the details of the current leader on the leaderboard
68     function getRecord() public view returns (address winningAddress, uint256 difference, uint256[] negativeSet, uint256[] positiveSet) {
69         return (leader.id, leader.difference, leader.negativeSet, leader.positiveSet);
70     }
71 
72     // Get the current amount of money in the prize pot guaranteed to the person at the top of the leaderboard when the competition concludes.
73     function getPrizePot() public view returns (uint256 prizeFundAmount) {
74         return address(this).balance;
75     }
76 
77     // Get the expiry timestamp of the contract
78     function getExpiryDate() public view returns (uint256 expiryTimestamp) {
79         return expiryTime;
80     }
81     
82     // Get all the important Data
83     function getData() public view returns(uint256[] numberSet, address winningAddress, uint256 prizeFundAmount, uint256 expiryTimestamp) {
84         return (numbers, leader.id, address(this).balance, expiryTime);
85     }
86 
87     // This (fallback) function allows anybody to add to the prize pot by simply sending ETH to the contract's address
88     function () public payable {    }
89 
90     // For the sake of vanity...
91     function getAuthor() public pure returns (string authorName) {
92       return "Written by Ciarán Ó hAoláin, Maynooth University 2018";
93     }
94 
95     // This functions allows the admin to authorise ETH addresses to enter the competition
96     function authoriseEntrants(address[] addressesToAuthorise) public adminOnly {
97         for (uint256 i = 0; i<addressesToAuthorise.length; i++) authorisedEntrants[addressesToAuthorise[i]]=true;
98     }
99 
100     // Allows people to submit a new answer to the leaderboard. If it beats the current record, the new attempt will be recorded on the leaderboard.
101     function submitAnswer(uint256[] negativeSetSubmission, uint256[] positiveSetSubmission) public restrictedAccess returns (string response) {
102         require(negativeSetSubmission.length+positiveSetSubmission.length>0, 'Invalid submission.');
103         uint256 sumNegative = 0;
104         uint256 sumPositive = 0;
105         // Add everything up
106         for (uint256 i = 0; i<negativeSetSubmission.length; i++) {
107             require(numberCheck[negativeSetSubmission[i]].exists && !numberCheck[negativeSetSubmission[i]].isUsed, 'Invalid submission.');
108             sumNegative+=negativeSetSubmission[i];
109             numberCheck[negativeSetSubmission[i]].isUsed = true;
110         }
111         for (i = 0; i<positiveSetSubmission.length; i++) {
112             require(numberCheck[positiveSetSubmission[i]].exists && !numberCheck[positiveSetSubmission[i]].isUsed, 'Invalid submission.');
113             sumPositive+=positiveSetSubmission[i];
114             numberCheck[positiveSetSubmission[i]].isUsed = true;
115         }
116         // Input looks valid, now set everything back to normal
117         for (i = 0; i<negativeSetSubmission.length; i++) numberCheck[negativeSetSubmission[i]].isUsed = false;
118         for (i = 0; i<positiveSetSubmission.length; i++) numberCheck[positiveSetSubmission[i]].isUsed = false;
119         // Check the new result, if it's a new record, record it
120         uint256 difference = _diff(sumNegative, sumPositive);
121         if (leader.id==address(0) || difference<leader.difference) {
122             leader.id = msg.sender;
123             leader.difference=difference;
124             leader.negativeSet=negativeSetSubmission;
125             leader.positiveSet=positiveSetSubmission;
126             emit NewRecord(msg.sender, difference);
127             return "Congratulations, you are now on the top of the leaderboard.";
128         } else {
129             emit RunnerUpSubmission(msg.sender, difference);
130             return "Sorry, you haven't beaten the record.";
131         }
132     }
133 
134     // Allows the winner to withdraw the prize pot
135     function withdrawPrize(address prizeRecipient) public winnerOnly {
136         prizeRecipient.transfer(address(this).balance);
137     }
138 
139     // Internal function to check results
140     function _diff(uint256 a, uint256 b) private pure returns (uint256 difference) {
141         if (a>b) return a-b;
142         else return b-a;
143     }
144 
145 }