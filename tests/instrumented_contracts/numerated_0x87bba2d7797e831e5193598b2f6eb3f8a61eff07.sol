1 pragma solidity ^0.4.4;
2 contract CrowdFunding {
3     // data structure to hold information about campaign contributors
4     struct Funder {
5         address addr;
6         uint amount;
7     }
8     // Campaign data structure
9     struct Campaign {
10         address beneficiary;
11         uint fundingGoal;
12         uint numFunders;
13         uint amount;
14         uint deadline;
15         mapping (uint => Funder) funders;
16         mapping (address => uint) balances;
17     }
18     //Declares a state variable 'numCampaigns'
19     uint numCampaigns;
20     //Creates a mapping of Campaign datatypes
21     mapping (uint => Campaign) campaigns;
22     //first function sets up a new campaign
23     function newCampaign(address beneficiary, uint goal, uint deadline) returns (uint campaignID) {
24         campaignID = numCampaigns++; // campaignID is return variable
25         Campaign c = campaigns[campaignID]; // assigns reference
26         c.beneficiary = beneficiary;
27         c.fundingGoal = goal;
28         c.deadline = block.number + deadline;
29     }
30     //function to contributes to the campaign
31     function contribute(uint campaignID) {
32         Campaign c = campaigns[campaignID];
33         Funder f = c.funders[c.numFunders++];
34         f.addr = msg.sender;
35         f.amount = msg.value;
36         c.amount += f.amount;
37     }
38     // checks if the goal or time limit has been reached and ends the campaign
39     function checkGoalReached(uint campaignID) returns (bool reached) {
40         Campaign c = campaigns[campaignID];
41         if (c.amount >= c.fundingGoal){
42             uint i = 0;
43             uint f = c.numFunders;
44             c.beneficiary.send(c.amount);
45             c.amount = 0;
46             c.beneficiary = 0;
47             c.fundingGoal = 0;
48             c.deadline = 0;
49             c.numFunders = 0;
50             while (i <= f){
51                 c.funders[i].addr = 0;
52                 c.funders[i].amount = 0;
53                 i++;
54             }
55         return true;
56         }
57         if (c.deadline <= block.number){
58             uint j = 0;
59             uint n = c.numFunders;
60             c.beneficiary = 0;
61             c.fundingGoal = 0;
62             c.numFunders = 0;
63             c.deadline = 0;
64             c.amount = 0;
65             while (j <= n){
66                 c.funders[j].addr.send(c.funders[j].amount);
67                 c.funders[j].addr = 0;
68                 c.funders[j].amount = 0;
69                 j++;
70             }
71             return true;
72         }
73         return false;
74     }
75 }