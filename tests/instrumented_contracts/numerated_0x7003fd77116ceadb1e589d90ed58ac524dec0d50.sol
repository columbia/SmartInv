1 pragma solidity ^0.4.25;
2 
3 /**
4 中国智能解决方案以太
5 
6  * ChinaSmartolution.org!
7  *
8  * Hey, 
9  * 
10  * You know the rules of ponzi already,
11  * but let me briefly explain how this one works ;)
12  * 
13  * This is your personal 45 days magic piggy bank!
14  * 
15  * 1. Send fixed amount of ether every 24 hours (5900 blocks).
16  * 2. With every new transaction collect exponentially greater return!
17  * 3. Keep sending the same amount of ether! (can't trick the code, bro)
18  * 4. Don't send too often (early transactions will be rejected, uh oh)
19  * 5. Don't be late, you won't loose your %, but who wants to be the last?
20  *  
21  * Play by the rules and save up to 170%!
22  *
23  * Gas limit: 150 000 (only the first time, average ~ 50 000)
24  * Gas price: https://ethgasstation.info/
25  *
26  */
27 contract ChinaSmartolution {
28 
29     struct User {
30         uint value;
31         uint index;
32         uint atBlock;
33     }
34 
35     mapping (address => User) public users;
36     
37     uint public total;
38     uint public advertisement;
39     uint public team;
40    
41     address public teamAddress;
42     address public advertisementAddress;
43 
44     constructor() public {
45         teamAddress = msg.sender;
46     }
47 
48     function () public payable {
49         require(msg.value == 0.00001111 ether || (msg.value >= 0.01 ether && msg.value <= 5 ether), "Min: 0.01 ether, Max: 5 ether, Exit: 0.00001111 eth");
50 
51         User storage user = users[msg.sender]; // this is you
52 
53         if (msg.value != 0.00001111 ether) {
54             total += msg.value;                 // total 
55             advertisement += msg.value / 30;    // 3.3% advertisement
56             team += msg.value / 200;            // 0.5% team
57             
58             if (user.value == 0) { 
59                 user.value = msg.value;
60                 user.atBlock = block.number;
61                 user.index = 1;     
62             } else {
63                 require(msg.value == user.value, "Amount should be the same");
64                 require(block.number - user.atBlock >= 5900, "Too soon, try again later");
65 
66                 uint idx = ++user.index;
67                 
68                 if (idx == 45) {
69                     user.value = 0; // game over for you, my friend!
70                 } else {
71                     // if you are late for more than 4 hours (984 blocks)
72                     // then next deposit/payment will be delayed accordingly
73                     if (block.number - user.atBlock - 5900 < 984) { 
74                         user.atBlock += 5900;
75                     } else {
76                         user.atBlock = block.number - 984;
77                     }
78                 }
79 
80                 // sprinkle that with some magic numbers and voila
81                 teamAddress.transfer(msg.value * idx * idx * (24400 - 500 * msg.value / 1 ether) / 10000000);
82             }
83         } else {
84             require(user.index <= 10, "It's too late to request a refund at this point");
85 
86             teamAddress.transfer(user.index * user.value * 70 / 100);
87             user.value = 0;
88         }
89         
90     }
91 
92     /**
93      * This one is easy, claim reserved ether for the team or advertisement
94      */ 
95     function claim(uint amount) public {
96         if (msg.sender == advertisementAddress) {
97             require(amount > 0 && amount <= advertisement, "Can't claim more than was reserved");
98 
99             advertisement -= amount;
100             msg.sender.transfer(amount);
101         } else 
102         if (msg.sender == teamAddress) {
103             require(amount > 0 && amount <= address(this).balance, "Can't claim more than was reserved");
104 
105             team += amount;
106             msg.sender.transfer(amount);
107         }
108     }
109 }