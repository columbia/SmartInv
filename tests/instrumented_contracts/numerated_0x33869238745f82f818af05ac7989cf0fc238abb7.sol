1 pragma solidity ^0.4.17;
2 
3 contract Election{
4     
5     address public manager; // contract manager
6     
7     bool public isActive;
8     mapping(uint256 => address[]) public users; // all votes
9     mapping(address => uint256[]) public votes; // to fetch one user's votes
10     uint256 public totalUsers; // total users participated (not unique user count)
11     uint256 public totalVotes; // for calculating avg vote guess on client side. (stats only)
12     address[] public winners; // winner list. will be set after manager calls finalizeContract function
13     uint256 public winnerPrice; // reward per user for successfull guess.
14     uint256 public voteResult; // candidate's vote result will be set after election.
15     
16     
17     // minimum reqired ether to enter competition.
18     modifier mRequiredValue(){
19         require(msg.value == .01 ether);
20         _;
21     }
22     
23     // manager only functions: pause, finalizeContract
24     modifier mManagerOnly(){
25         require(msg.sender == manager);
26         _;
27     }
28     
29     // contract will be manually paused before on election day by manager.
30     modifier mIsActive(){
31         require(isActive);
32         _;
33     }
34     
35     // constructor
36     function Election() public{
37         manager = msg.sender;
38         isActive = true;
39     }
40     
41     /**
42     * user can join competition with this function.
43     * user's guess multiplied with 10 before calling this function for not using decimal numbers.
44     * ex: user guess: 40.2 -> 402
45     **/
46     function voteRequest(uint256 guess) public payable mIsActive mRequiredValue {
47         require(guess > 0);
48         require(guess <= 1000);
49         address[] storage list = users[guess];
50         list.push(msg.sender);
51         votes[msg.sender].push(guess);
52         totalUsers++;
53         totalVotes += guess;
54     }
55     
56     // get user's vote history.
57     function getUserVotes() public view returns(uint256[]){
58         return votes[msg.sender];
59     }
60 
61     // stats only function
62     function getSummary() public returns(uint256, uint256, uint256) {
63         return(
64             totalVotes,
65             totalUsers,
66             this.balance
67         );
68     }
69     
70     // for pausing contract. contract will be paused on election day. new users can't join competition after contract paused.
71     function pause() public mManagerOnly {
72         isActive = !isActive;
73     }
74     
75     /** send ether to winners.(5% manager fee.)
76      * if there is no winner choose closest estimates will get rewards.
77      * manager will call this function after official results announced by YSK.
78      * winners will receive rewards instantly.
79      * election results will be rounded to one decimal only.
80      * if result is 40.52 then winner is who guessed 40.5
81      * if result is 40.56 then winner is who guessed 40.6
82      **/
83     function finalizeContract(uint256 winningNumber) public mManagerOnly {
84         voteResult = winningNumber;
85         address[] memory list = users[winningNumber];
86         address[] memory secondaryList;
87         uint256 winnersCount = list.length;
88 
89         if(winnersCount == 0){
90             // if there is no winner choose closest estimates.
91             bool loop = true;
92             uint256 index = 1;
93             while(loop == true){
94                 list = users[winningNumber-index];
95                 secondaryList = users[winningNumber+index];
96                 winnersCount = list.length + secondaryList.length;
97 
98                 if(winnersCount > 0){
99                     loop = false;
100                 }
101                 else{
102                     index++;
103                 }
104             }
105         }
106         
107         uint256 managerFee = (this.balance/100)*5; // manager fee %5
108         uint256 reward = (this.balance - managerFee) / winnersCount; // reward for per winner.
109         winnerPrice = reward;
110         
111         // set winner list
112         winners = list;
113         // transfer eth to winners.
114         for (uint256 i = 0; i < list.length; i++) {
115             list[i].transfer(reward);
116         }
117                 
118         // if anyone guessed the correct percent secondaryList will be empty array.
119         for (uint256 j = 0; j < secondaryList.length; j++) {
120             // transfer eth to winners.
121             secondaryList[j].transfer(reward);
122             winners.push(secondaryList[j]); // add to winners
123         }
124         
125         // transfer fee to manager
126         manager.transfer(this.balance);
127         
128         
129     }
130     
131 }