1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.6;
3 
4 /**
5  * @title Claim
6  * @author gotbit
7  */
8 
9 interface IERC20 {
10     function balanceOf(address who) external view returns (uint balance);
11     function transfer(address to, uint value) external returns (bool trans1);
12 }
13 
14 contract Ownable {
15     address public owner;
16     event OwnershipTransferred(
17         address indexed previousOwner,
18         address indexed newOwner
19     );
20     modifier onlyOwner() {
21         require(msg.sender == owner, "Only owner can call this function");
22         _;
23     }
24 
25     function transferOwnership(address newOwner_) external onlyOwner {
26         require(
27             newOwner_ != address(0),
28             "You cant tranfer ownerships to address 0x0"
29         );
30         require(newOwner_ != owner, "You cant transfer ownerships to yourself");
31         emit OwnershipTransferred(owner, newOwner_);
32         owner = newOwner_;
33     }
34 }
35 
36 contract Claim is Ownable {
37     struct Round {
38         uint cliff;
39         uint constReward;
40         uint linearPeriod;
41     }
42 
43     struct Allocation {
44         uint seed;
45         uint strategic;
46         uint private_;
47     }
48 
49     struct User {
50         uint claimed;
51         Allocation allocation;
52         uint claimTimestamp;
53     }
54 
55     uint public constant MONTH = 30 days;
56     uint public constant MINUTE = 1 minutes;
57     uint public constant CONST_PERIOD = 2 * 24 hours;
58     uint public constant CONST_RELAX = MONTH;
59 
60     IERC20 public token;
61 
62     bool public isStarted;
63     uint public startTimestamp;
64 
65     mapping(string => Round) rounds;
66     mapping(address => User) public users;
67 
68     event Started(uint timestamp, address who);
69     event Claimed(address indexed to, uint value);
70     event SettedAllocation(address indexed to, uint seed, uint strategic, uint private_);
71 
72 
73     constructor(address owner_, address token_) {
74         owner = owner_;
75         token = IERC20(token_);
76 
77         rounds["seed"] = Round(1, 10, 13);
78         rounds["strategic"] = Round(0, 15, 9);
79         rounds["private"] = Round(0, 20, 7);
80     }
81 
82     function start() external onlyOwner returns (bool status) {
83         require(!isStarted, "The claim has already begun");
84 
85         isStarted = true;
86         startTimestamp = block.timestamp;
87 
88         emit Started(startTimestamp, msg.sender);
89 
90         return true;
91     }
92 
93     function claim() external returns (bool status) {
94         require(isStarted, "The claim has not started yet");
95 
96         uint value_ = calculateUnclaimed(msg.sender);
97 
98         require(value_ > 0, "You dont have DES to harvest");
99         require(
100             token.balanceOf(address(this)) >= value_,
101             "Not enough tokens on contract"
102         );
103 
104         users[msg.sender].claimed += value_;
105         users[msg.sender].claimTimestamp = block.timestamp;
106 
107         require(token.transfer(msg.sender, value_), 'Transfer issues');
108 
109         emit Claimed(msg.sender, value_);
110         return true;
111     }
112 
113     function getAllocation(address user_) external view returns (uint sum) {
114         return
115             (users[user_].allocation.seed +
116                 users[user_].allocation.strategic +
117                 users[user_].allocation.private_) / 2;
118     }
119 
120     function calculateUnclaimed(address user_)
121         public
122         view
123         returns (uint unclaimed)
124     {
125         require(isStarted, "The claim has not started yet");
126 
127         uint resultSeed_ = calculateRound(
128             "seed",
129             users[user_].allocation.seed
130         );
131         uint resultStrategic_ = calculateRound(
132             "strategic",
133             users[user_].allocation.strategic
134         );
135         uint resultPrivate_ = calculateRound(
136             "private",
137             users[user_].allocation.private_
138         );
139 
140         return
141             (resultSeed_ + resultStrategic_ + resultPrivate_) /
142             2 -
143             users[user_].claimed;
144     }
145 
146     function calculateRound(string memory roundName_, uint allocation_)
147         internal
148         view
149         returns (uint unclaimedFromRound)
150     {
151         require(isStarted, "The claim has not started yet");
152 
153         Round memory round_ = rounds[roundName_];
154 
155         uint timePassed_ = block.timestamp - startTimestamp;
156         uint bank_ = allocation_;
157 
158         if (timePassed_ < (round_.cliff * MONTH)) return 0;
159 
160         timePassed_ -= (round_.cliff * MONTH);
161         uint constReward_ = (bank_ * round_.constReward) / 100;
162         if (round_.cliff == 0) {
163             if (timePassed_ < CONST_PERIOD / 2) return constReward_ / 2;
164         }
165 
166         if (timePassed_ < CONST_RELAX) return constReward_;
167         timePassed_ -= CONST_RELAX;
168 
169         uint minutesPassed_ = timePassed_ / MINUTE;
170         uint leftInBank_ = bank_ - constReward_;
171         return
172             (leftInBank_ * MINUTE * minutesPassed_) /
173             (MONTH * round_.linearPeriod) +
174             constReward_;
175     }
176 
177     function setAllocations(
178         address[] memory whos_,
179         uint[] memory seeds_,
180         uint[] memory strategics_,
181         uint[] memory privates_
182     )
183     public
184     onlyOwner {
185         uint len = whos_.length;
186         require(seeds_.length == len, 'Different length');
187         require(strategics_.length == len, 'Different length');
188         require(privates_.length == len, 'Different length');
189 
190         for (uint i = 0; i < len; i++) {
191             address who_ = whos_[i];
192 
193             if (users[who_].claimed == 0) {
194                 uint seed_ = seeds_[i];
195                 uint strategic_ = strategics_[i];
196                 uint private_ = privates_[i];
197             
198                 users[who_] = User({
199                     claimed: users[who_].claimed,
200                     allocation: Allocation(seed_, strategic_, private_),
201                     claimTimestamp: users[who_].claimTimestamp
202                 });
203                 emit SettedAllocation(who_, seed_, strategic_, private_);
204             }
205         }
206     }
207 }