1 pragma solidity ^0.4.6;
2 
3 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
4 ///  later changed
5 contract Owned {
6     /// @dev `owner` is the only address that can call a function with this
7     /// modifier
8     modifier onlyOwner { if (msg.sender != owner) throw; _; }
9 
10     address public owner;
11 
12     /// @notice The Constructor assigns the message sender to be `owner`
13     function Owned() { owner = msg.sender;}
14 
15     /// @notice `owner` can step down and assign some other address to this role
16     /// @param _newOwner The address of the new owner. 0x0 can be used to create
17     ///  an unowned neutral vault, however that cannot be undone
18     function changeOwner(address _newOwner) onlyOwner {
19         owner = _newOwner;
20     }
21 }
22 
23 
24 contract GivethDirectory is Owned {
25 
26     enum CampaignStatus {Preparing, Active, Obsoleted, Deleted}
27 
28     struct Campaign {
29         string name;
30         string description;
31         string url;
32         address token;
33         address vault;
34         address milestoneTracker;
35         string extra;
36         CampaignStatus status;
37     }
38 
39     Campaign[] campaigns;
40 
41     function addCampaign(
42         string name,
43         string description,
44         string url,
45         address token,
46         address vault,
47         address milestoneTracker,
48         string extra
49     ) onlyOwner returns(uint idCampaign) {
50 
51         idCampaign = campaigns.length++;
52         Campaign c = campaigns[idCampaign];
53         c.name = name;
54         c.description = description;
55         c.url = url;
56         c.token = token;
57         c.vault = vault;
58         c.milestoneTracker = milestoneTracker;
59         c.extra = extra;
60     }
61 
62     function updateCampaign(
63         uint idCampaign,
64         string name,
65         string description,
66         string url,
67         address token,
68         address vault,
69         address milestoneTracker,
70         string extra
71     ) onlyOwner {
72         if (idCampaign >= campaigns.length) throw;
73         Campaign c = campaigns[idCampaign];
74         c.name = name;
75         c.description = description;
76         c.url = url;
77         c.token = token;
78         c.vault = vault;
79         c.milestoneTracker = milestoneTracker;
80         c.extra = extra;
81     }
82 
83     function changeStatus(uint idCampaign, CampaignStatus newStatus) onlyOwner {
84         if (idCampaign >= campaigns.length) throw;
85         Campaign c = campaigns[idCampaign];
86         c.status = newStatus;
87     }
88 
89     function getCampaign(uint idCampaign) constant returns (
90         string name,
91         string description,
92         string url,
93         address token,
94         address vault,
95         address milestoneTracker,
96         string extra,
97         CampaignStatus status
98     ) {
99         if (idCampaign >= campaigns.length) throw;
100         Campaign c = campaigns[idCampaign];
101         name = c.name;
102         description = c.description;
103         url = c.url;
104         token = c.token;
105         vault = c.vault;
106         milestoneTracker = c.milestoneTracker;
107         extra = c.extra;
108         status = c.status;
109     }
110 
111     function numberOfCampaigns() constant returns (uint) {
112         return campaigns.length;
113     }
114 
115 }