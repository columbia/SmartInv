1 pragma solidity 0.5.12;
2 
3 contract AdvertisementTracker
4 {
5     event CampaignLaunched(
6         address owner,
7         bytes32 bidId,
8         string packageName,
9         uint[3] countries,
10         uint price,
11         uint budget,
12         uint startDate,
13         uint endDate,
14         string endPoint
15     );
16 
17     event CampaignCancelled(
18         address owner,
19         bytes32 bidId
20     );
21 
22     event BulkPoARegistered(
23         address owner,
24         bytes32 bidId,
25         bytes rootHash,
26         bytes signature,
27         uint256 newHashes
28     );
29 
30     constructor() public {
31     }
32 
33     function createCampaign (
34         bytes32 bidId,
35         string memory packageName,
36         uint[3] memory countries,
37         uint price,
38         uint budget,
39         uint startDate,
40         uint endDate,
41         string memory endPoint)
42     public
43     {
44         emit CampaignLaunched(
45             msg.sender,
46             bidId,
47             packageName,
48             countries,
49             price,
50             budget,
51             startDate,
52             endDate,
53             endPoint);
54     }
55 
56     function cancelCampaign (
57         bytes32 bidId)
58     public
59     {
60         emit CampaignCancelled(
61             msg.sender, 
62             bidId);
63     }
64 
65     function bulkRegisterPoA (
66         bytes32 bidId,
67         bytes memory rootHash,
68         bytes memory signature,
69         uint256 newHashes)
70     public
71     {
72         emit BulkPoARegistered(
73             msg.sender,
74             bidId,
75             rootHash,
76             signature,
77             newHashes);
78     }
79 
80 }