1 pragma solidity >=0.5.0;
2 
3 contract PollingEvents {
4     event PollCreated(
5         address indexed creator,
6         uint256 blockCreated,
7         uint256 indexed pollId,
8         uint256 startDate,
9         uint256 endDate,
10         string multiHash,
11         string url
12     );
13 
14     event PollWithdrawn(
15         address indexed creator,
16         uint256 blockWithdrawn,
17         uint256 pollId
18     );
19 
20     event Voted(
21         address indexed voter,
22         uint256 indexed pollId,
23         uint256 indexed optionId
24     );
25 }
26 
27 contract PollingEmitter is PollingEvents {
28     uint256 public npoll;
29 
30     function createPoll(uint256 startDate, uint256 endDate, string calldata multiHash, string calldata url)
31         external
32     {
33         uint256 startDate_ = startDate > now ? startDate : now;
34         require(endDate > startDate_, "polling-invalid-poll-window");
35         emit PollCreated(
36             msg.sender,
37             block.number,
38             npoll,
39             startDate_,
40             endDate,
41             multiHash,
42             url
43         );
44         require(npoll < uint(-1), "polling-too-many-polls");
45         npoll++;
46     }
47 
48     function withdrawPoll(uint256 pollId)
49         external
50     {
51         emit PollWithdrawn(msg.sender, block.number, pollId);
52     }
53 
54     function vote(uint256 pollId, uint256 optionId)
55         external
56     {
57         emit Voted(msg.sender, pollId, optionId);
58     }
59 
60     function withdrawPoll(uint256[] calldata pollIds)
61         external
62     {
63         for (uint i = 0; i < pollIds.length; i++) {
64             emit PollWithdrawn(msg.sender, pollIds[i], block.number);
65         }
66     }
67 
68     function vote(uint256[] calldata pollIds, uint256[] calldata optionIds)
69         external
70     {
71         require(pollIds.length == optionIds.length, "non-matching-length");
72         for (uint i = 0; i < pollIds.length; i++) {
73             emit Voted(msg.sender, pollIds[i], optionIds[i]);
74         }
75     }
76 }