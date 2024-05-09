1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address previousOwner, address newOwner);
7 
8     function Ownable() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0));
19         emit OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 }
23 
24 contract StorageBase is Ownable {
25 
26     function withdrawBalance() external onlyOwner returns (bool) {
27         // The owner has a method to withdraw balance from multiple contracts together,
28         // use send here to make sure even if one withdrawBalance fails the others will still work
29         bool res = msg.sender.send(address(this).balance);
30         return res;
31     }
32 }
33 
34 // owner of ActivityStorage should be ActivityCore contract address
35 contract ActivityStorage is StorageBase {
36 
37     struct Activity {
38         // accept bid or not
39         bool isPause;
40         // limit max num of monster buyable per address
41         uint16 buyLimit;
42         // price (in wei)
43         uint128 packPrice;
44         // startDate (in seconds)
45         uint64 startDate;
46         // endDate (in seconds)
47         uint64 endDate;
48         // packId => address of bid winner
49         mapping(uint16 => address) soldPackToAddress;
50         // address => number of success bid
51         mapping(address => uint16) addressBoughtCount;
52     }
53 
54     // limit max activityId to 65536, big enough
55     mapping(uint16 => Activity) public activities;
56 
57     function createActivity(
58         uint16 _activityId,
59         uint16 _buyLimit,
60         uint128 _packPrice,
61         uint64 _startDate,
62         uint64 _endDate
63     ) 
64         external
65         onlyOwner
66     {
67         // activity should not exist and can only be initialized once
68         require(activities[_activityId].buyLimit == 0);
69 
70         activities[_activityId] = Activity({
71             isPause: false,
72             buyLimit: _buyLimit,
73             packPrice: _packPrice,
74             startDate: _startDate,
75             endDate: _endDate
76         });
77     }
78 
79     function sellPackToAddress(
80         uint16 _activityId, 
81         uint16 _packId, 
82         address buyer
83     ) 
84         external 
85         onlyOwner
86     {
87         Activity storage activity = activities[_activityId];
88         activity.soldPackToAddress[_packId] = buyer;
89         activity.addressBoughtCount[buyer]++;
90     }
91 
92     function pauseActivity(uint16 _activityId) external onlyOwner {
93         activities[_activityId].isPause = true;
94     }
95 
96     function unpauseActivity(uint16 _activityId) external onlyOwner {
97         activities[_activityId].isPause = false;
98     }
99 
100     function deleteActivity(uint16 _activityId) external onlyOwner {
101         delete activities[_activityId];
102     }
103 
104     function getAddressBoughtCount(uint16 _activityId, address buyer) external view returns (uint16) {
105         return activities[_activityId].addressBoughtCount[buyer];
106     }
107 
108     function getBuyerAddress(uint16 _activityId, uint16 packId) external view returns (address) {
109         return activities[_activityId].soldPackToAddress[packId];
110     }
111 }