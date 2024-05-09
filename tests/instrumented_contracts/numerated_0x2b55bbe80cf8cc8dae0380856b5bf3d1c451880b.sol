1 pragma solidity ^0.4.18;
2 
3 contract EternalWealth {
4     
5     uint public doomsday;
6     address owner;
7     address public savior;
8     uint public blessings = 0;
9     uint public tithes = 0;
10     uint public lifePoints = 0;
11     
12     function EternalWealth() public payable {
13         owner = msg.sender;
14         doomsday = now + 3 hours;
15         savior = msg.sender;
16         blessings += msg.value;
17     }
18     
19     function ExtendLife() public payable {
20 
21         require(msg.value >= 0.001 ether);
22 
23         if (now > doomsday) {
24             revert();
25         }
26     
27         blessings += msg.value * 8 / 10;
28         tithes += msg.value * 2 / 10;
29         savior = msg.sender;
30         doomsday = now + 30 minutes;
31         lifePoints += 1;
32     }
33     
34 
35     function ClaimBlessings() public {
36         require(msg.sender == savior);
37         require(now > doomsday);
38         uint pendingBlessings = blessings;
39         blessings = 0;
40         savior.transfer(pendingBlessings);
41     }
42     
43     function WithdrawTithes() public {
44         uint pendingTithes = tithes;
45         tithes = 0;
46         owner.transfer(pendingTithes);
47     }
48     
49 }