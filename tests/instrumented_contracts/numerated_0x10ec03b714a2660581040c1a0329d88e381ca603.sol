1 pragma solidity ^0.4.2;
2 
3 /*
4 
5 EthPledge allows people to pledge to donate a certain amount to a charity, which gets sent only if others match it. A user may pledge to donate 10 Ether to a charity, for example, which will get listed here and will be sent to the charity later only if other people also collectively contribute 10 Ether under that pledge. You can also pledge to donate several times what other people donate, up to a certain amount -- for example, you may choose to put up 10 Ether, which gets sent to the charity if others only contribute 2 Ether.
6 
7 Matching pledges of this kind are quite common (companies may pledge to match all charitable donations their employees make up to a certain amount, for example, or it may just be a casual arrangement between 2 people) and by running on the Ethereum blockchain, EthPledge guarantees 100% transparency. 
8 
9 Note that as Ethereum is still relatively new at this stage, not many charities have an Ethereum address to take donations yet, though it's our hope that more will come. The main charity with an Ethereum donation address at this time is Heifer International, whose Ethereum address is 0xb30cb3b3E03A508Db2A0a3e07BA1297b47bb0fb1 (see https://www.heifer.org/what-you-can-do/give/digital-currency.html)
10 
11 Visit EthPledge.com to play with this smart contract. Reach out: contact@EthPledge.com
12 
13 */
14 
15 contract EthPledge {
16     
17     address public owner;
18     
19     function EthPledge() {
20         owner = msg.sender;
21     }
22     
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27     
28     struct Campaign {
29         address benefactor; // Person starting the campaign, who puts in some ETH to donate to an Ethereum address. 
30         address charity;
31         uint amountPledged;
32         uint amountRaised;
33         uint donationsReceived;
34         uint multiplier; // If this was 5, for example, other donators would only need to put up 1/5th of the amount the benefactor does for the pledge to be successful and all funds to be donated. Eg. Benefactor pledges 10 ETH, then after only 2 ETH is contributed to the campaign, all funds are send to the charity and the campaign ends
35         bool active;
36         bool successful;
37         uint timeStarted;
38         bytes32 descriptionPart1; // Allow a description of up to 132 characters. Each bytes32 part can only hold 32 characters.
39         bytes32 descriptionPart2;
40         bytes32 descriptionPart3;
41         bytes32 descriptionPart4;
42     }
43     
44     mapping (uint => Campaign) public campaign;
45     
46     mapping (address => uint[]) public campaignsStartedByUser;
47     
48     mapping (address => mapping(uint => uint)) public addressToCampaignIDToFundsDonated;
49     
50     mapping (address => uint[]) public campaignIDsDonatedToByUser; // Will contain duplicates if a user donates to a campaign twice
51     
52     struct Donation {
53         address donator;
54         uint amount;
55         uint timeSent;
56     }
57     
58     mapping (uint => mapping(uint => Donation)) public campaignIDtoDonationNumberToDonation;
59     
60     uint public totalCampaigns;
61     
62     uint public totalDonations;
63     
64     uint public totalETHraised;
65     
66     uint public minimumPledgeAmount = 10**14; // Basically nothing, can be adjusted later
67     
68     function createCampaign (address charity, uint multiplier, bytes32 descriptionPart1, bytes32 descriptionPart2, bytes32 descriptionPart3, bytes32 descriptionPart4) payable {
69         require (msg.value >= minimumPledgeAmount);
70         require (multiplier > 0);
71         campaign[totalCampaigns].benefactor = msg.sender;
72         campaign[totalCampaigns].charity = charity;
73         campaign[totalCampaigns].multiplier = multiplier;
74         campaign[totalCampaigns].timeStarted = now;
75         campaign[totalCampaigns].amountPledged = msg.value;
76         campaign[totalCampaigns].active = true;
77         campaign[totalCampaigns].descriptionPart1 = descriptionPart1;
78         campaign[totalCampaigns].descriptionPart2 = descriptionPart2;
79         campaign[totalCampaigns].descriptionPart3 = descriptionPart3;
80         campaign[totalCampaigns].descriptionPart4 = descriptionPart4;
81         campaignsStartedByUser[msg.sender].push(totalCampaigns);
82         totalETHraised += msg.value;
83         totalCampaigns++;
84     }
85     
86     function cancelCampaign (uint campaignID) {
87         
88         // If the benefactor cancels their campaign, they get a refund of their pledge amount in line with how much others have donated - if you cancel the pledge when 10% of the donation target has been reached, for example, 10% of the pledge amount (along with the donations) will be sent to the charity address, and 90% of the pledge amount you put up will be returned to you
89         
90         require (msg.sender == campaign[campaignID].benefactor);
91         require (campaign[campaignID].active == true);
92         campaign[campaignID].active = false;
93         campaign[campaignID].successful = false;
94         uint amountShort = campaign[campaignID].amountPledged - (campaign[campaignID].amountRaised * campaign[campaignID].multiplier);
95         uint amountToSendToCharity = campaign[campaignID].amountPledged + campaign[campaignID].amountRaised - amountShort;
96         campaign[campaignID].charity.transfer(amountToSendToCharity);
97         campaign[campaignID].benefactor.transfer(amountShort);
98     }
99     
100     function contributeToCampaign (uint campaignID) payable {
101         require (msg.value > 0);
102         require (campaign[campaignID].active == true);
103         campaignIDsDonatedToByUser[msg.sender].push(campaignID);
104         addressToCampaignIDToFundsDonated[msg.sender][campaignID] += msg.value;
105         
106         campaignIDtoDonationNumberToDonation[campaignID][campaign[campaignID].donationsReceived].donator = msg.sender;
107         campaignIDtoDonationNumberToDonation[campaignID][campaign[campaignID].donationsReceived].amount = msg.value;
108         campaignIDtoDonationNumberToDonation[campaignID][campaign[campaignID].donationsReceived].timeSent = now;
109         
110         campaign[campaignID].donationsReceived++;
111         totalDonations++;
112         totalETHraised += msg.value;
113         campaign[campaignID].amountRaised += msg.value;
114         if (campaign[campaignID].amountRaised >= (campaign[campaignID].amountPledged / campaign[campaignID].multiplier)) {
115             // Target reached
116             campaign[campaignID].active = false;
117             campaign[campaignID].successful = true;
118             campaign[campaignID].charity.transfer(campaign[campaignID].amountRaised + campaign[campaignID].amountPledged);
119         }
120     }
121     
122     function adjustMinimumPledgeAmount (uint newMinimum) onlyOwner {
123         require (newMinimum > 0);
124         minimumPledgeAmount = newMinimum;
125     }
126     
127     // Below are view functions that an external contract can call to get information on a campaign ID or user
128     
129     function returnHowMuchMoreETHNeeded (uint campaignID) view returns (uint) {
130         return (campaign[campaignID].amountPledged / campaign[campaignID].multiplier - campaign[campaignID].amountRaised);
131     }
132     
133     function generalInfo() view returns (uint, uint, uint) {
134         return (totalCampaigns, totalDonations, totalETHraised);
135     }
136     
137     function lookupDonation (uint campaignID, uint donationNumber) view returns (address, uint, uint) {
138         return (campaignIDtoDonationNumberToDonation[campaignID][donationNumber].donator, campaignIDtoDonationNumberToDonation[campaignID][donationNumber].amount, campaignIDtoDonationNumberToDonation[campaignID][donationNumber].timeSent);
139     }
140     
141     // Below two functions have to be split into two parts, otherwise there are call-stack too deep errors
142     
143     function lookupCampaignPart1 (uint campaignID) view returns (address, address, uint, uint, uint, bytes32, bytes32) {
144         return (campaign[campaignID].benefactor, campaign[campaignID].charity, campaign[campaignID].amountPledged, campaign[campaignID].amountRaised,campaign[campaignID].donationsReceived, campaign[campaignID].descriptionPart1, campaign[campaignID].descriptionPart2);
145     }
146     
147     function lookupCampaignPart2 (uint campaignID) view returns (uint, bool, bool, uint, bytes32, bytes32) {
148         return (campaign[campaignID].multiplier, campaign[campaignID].active, campaign[campaignID].successful, campaign[campaignID].timeStarted, campaign[campaignID].descriptionPart3, campaign[campaignID].descriptionPart4);
149     }
150     
151     // Below functions are probably not necessary, but included just in case another contract needs this information in future
152     
153     function lookupUserDonationHistoryByCampaignID (address user) view returns (uint[]) {
154         return (campaignIDsDonatedToByUser[user]);
155     }
156     
157     function lookupAmountUserDonatedToCampaign (address user, uint campaignID) view returns (uint) {
158         return (addressToCampaignIDToFundsDonated[user][campaignID]);
159     }
160     
161 }