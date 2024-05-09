1 pragma solidity ^0.4.4;
2 contract XG4KCrowdFunding {
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
16     }
17     //Declares a state variable 'numCampaigns'
18     uint numCampaigns;
19     //Creates a mapping of Campaign datatypes
20     mapping (uint => Campaign) campaigns;
21     //first function sets up a new campaign
22     function newCampaign(address beneficiary, uint goal, uint deadline) returns (uint campaignID) {
23         campaignID = numCampaigns++; // campaignID is return variable
24         Campaign c = campaigns[campaignID]; // assigns reference
25         c.beneficiary = beneficiary;
26         c.fundingGoal = goal;
27         c.deadline = block.number + deadline;
28     }
29     //function to contributes to the campaign
30     function contribute(uint campaignID) {
31         Campaign c = campaigns[campaignID];
32         Funder f = c.funders[c.numFunders++];
33         f.addr = msg.sender;
34         f.amount = msg.value;
35         c.amount += f.amount;
36     }
37     // checks if the goal or time limit has been reached and ends the campaign
38     function checkGoalReached(uint campaignID) returns (bool reached) {
39         Campaign c = campaigns[campaignID];
40         if (c.amount >= c.fundingGoal){
41             c.beneficiary.send(c.amount);
42             clean(campaignID);
43         	return true;
44         }
45         if (c.deadline <= block.number){
46             uint j = 0;
47             uint n = c.numFunders;
48             while (j <= n){
49                 c.funders[j].addr.send(c.funders[j].amount);
50                 j++;
51             }
52             clean(campaignID);
53             return true;
54         }
55         return false;
56     }
57     function clean(uint id) private{
58     	Campaign c = campaigns[id];
59     	uint i = 0;
60     	uint n = c.numFunders;
61     	c.amount = 0;
62         c.beneficiary = 0;
63         c.fundingGoal = 0;
64         c.deadline = 0;
65         c.numFunders = 0;
66         while (i <= n){
67             c.funders[i].addr = 0;
68             c.funders[i].amount = 0;
69             i++;
70         }
71     }
72 }