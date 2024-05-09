1 pragma solidity ^0.4.9;
2 
3 contract ProofOfIdleness {
4     address public organizer;
5     
6     // number of remaining participants
7     uint public countRemaining = 0;
8     
9     // stores the last ping of every participants
10     mapping (address => uint) public lastPing;
11     
12     // Events allow light clients to react on changes efficiently.
13     event Eliminated(address a);
14     event Pinged(address a, uint time);
15 
16     // This is the constructor whose code is
17     // run only when the contract is created.
18     function ProofOfIdleness() {
19         organizer = msg.sender;
20     }
21     
22     
23     // function called when the user pings
24     function idle() {
25       if (lastPing[msg.sender] == 0)
26         throw;
27         
28       lastPing[msg.sender] = now;
29       Pinged(msg.sender, now);
30     }
31     
32     
33     // function called when a new user wants to join
34     function join() payable { 
35         if (lastPing[msg.sender] > 0 || msg.value != 1 ether)
36             throw;
37         
38         lastPing[msg.sender] = now; 
39         countRemaining = countRemaining + 1;
40         Pinged(msg.sender, now);
41         
42         if (!organizer.send(0.01 ether)) {
43           throw;
44         }
45     }
46     
47     
48     // function used to eliminate address ̀`a'
49     // will only succeed if the lastPing[a] is at least 27 hours old
50     function eliminate(address a) {
51       if (lastPing[a] == 0 || now <= lastPing[a] + 27 hours)
52         throw;
53         
54       lastPing[a] = 0;
55       countRemaining = countRemaining - 1;
56       Eliminated(a);
57     }
58     
59     
60     // function used to claim the whole reward
61     // will only succeed if called by the last remaining participant
62     function claimReward() {
63       if (lastPing[msg.sender] == 0 || countRemaining != 1)
64         throw;
65         
66       if (!msg.sender.send(this.balance))
67         throw;
68     }
69 }