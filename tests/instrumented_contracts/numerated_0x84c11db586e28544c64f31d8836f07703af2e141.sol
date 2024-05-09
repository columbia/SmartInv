1 pragma solidity ^0.4.18;
2 contract Lotto {
3 
4   address public owner = msg.sender;
5   address[] internal playerPool;
6   uint seed = 0;
7   uint amount = 0.01 ether;
8   // events
9   event Payout(address from, address to, uint quantity);
10   event BoughtIn(address from);
11   event Rejected();
12 
13   modifier onlyBy(address _account) {
14     require(msg.sender == _account);
15     _;
16   }
17   
18   function changeOwner(address _newOwner) public onlyBy(owner) {
19     owner = _newOwner;
20   }
21 
22 /*
23 The reasoning behind this method to get a random number is, because I'm not
24 displaying the current number of players, no one should know who the 11th player
25 will be, and that should be random enough to prevent anyone from cheating the system.
26 The reward is only 1 ether so it's low enough that miners won't try to influence it
27 ... i hope.
28 */
29   function random(uint upper) internal returns (uint) {
30     seed = uint(keccak256(keccak256(playerPool[playerPool.length -1], seed), now));
31     return seed % upper;
32   }
33 
34   // only accepts a value of 0.001 ether. no extra eth please!! don't be crazy!
35   // i'll make contracts for different sized bets eventually.
36   function buyIn() payable public returns (uint) {
37     if (msg.value * 10 != 0.01 ether) {
38       revert();
39       Rejected();
40     } else {
41       playerPool.push(msg.sender);
42       BoughtIn(msg.sender);
43       if (playerPool.length >= 11) {
44         selectWinner();
45       }
46     }
47     return playerPool.length;
48   }
49 
50   function selectWinner() private {
51     address winner = playerPool[random(playerPool.length)];
52     
53     winner.transfer(amount);
54     playerPool.length = 0;
55     owner.transfer(this.balance);
56     Payout(this, winner, amount);
57     
58   }
59   
60 /*
61 If the contract becomes stagnant and new players haven't signed up for awhile,
62 this function will return the money to all the players. The function is made
63 payable so I can send some ether with the transaction to pay for gas. this way
64 I can make sure all players are paid back. 
65 
66 as a note, 100 finney == 0.1 ether.
67 */
68   function refund() public onlyBy(owner) payable {
69     require(playerPool.length > 0);
70     for (uint i = 0; i < playerPool.length; i++) {
71       playerPool[i].transfer(100 finney);
72     }
73       playerPool.length = 0;
74   }
75   
76 /*
77 Self destruct just in case. Also, will refund all ether to the players before it
78 explodes into beautiful digital star dust.
79 */
80   function close() public onlyBy(owner) {
81     refund();
82     selfdestruct(owner);
83   }
84 
85 
86 // fallback function acts the same as buyIn(), omitting the return of course.
87   function () public payable {
88     require(msg.value * 10 == 0.01 ether);
89     playerPool.push(msg.sender);
90     BoughtIn(msg.sender);
91     if (playerPool.length >= 11) {
92       selectWinner();
93     }
94   }
95 }