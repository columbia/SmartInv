1 pragma solidity 0.5.6;
2 
3 /// @author The Calystral Team
4 /// @title A subscriber contract
5 contract Whitelist {
6     /// This mapping contains the index and subscriber addresses.
7     mapping (uint => address) subscriberIndexToAddress;
8 
9     /// This mapping contains the addresses and subscriber status.
10     mapping (address => uint) subscriberAddressToSubscribed;
11 
12     /// The current subscriber index.
13     /// Caution: This wiil be likely unequal to the actual subscriber amount.
14     /// This will be used as the index of a new subscriber.
15     /// We start at 1 because 0 will be the indicator that an address is not a subscriber.
16     uint subscriberIndex = 1;
17 
18     /// This event will be triggered when a subscription was done.
19     event OnSubscribed(address subscriberAddress);
20 
21     /// This event will be triggered when a subscription was revoked.
22     event OnUnsubscribed(address subscriberAddress);
23 
24     /// This modifier prevents other smart contracts from subscribing.
25     modifier isNotAContract(){
26         require (msg.sender == tx.origin, "Contracts are not allowed to interact.");
27         _;
28     }
29     
30     /// Fall back to the subscribe function if no specific function was called.
31     function() external {
32         subscribe();
33     }
34     
35     /// Gets the subscriber list.
36     function getSubscriberList() external view returns (address[] memory) {
37         uint subscriberListAmount = getSubscriberAmount();
38         
39         address[] memory subscriberList = new address[](subscriberListAmount);
40         uint subscriberListCounter = 0;
41         
42         /// Iterate over all subscriber addresses, to fill the subscriberList.
43         for (uint i = 1; i < subscriberIndex; i++) {
44             address subscriberAddress = subscriberIndexToAddress[i];
45 
46             /// Add the addresses which are actual subscribers only.
47             if (isSubscriber(subscriberAddress) == true) {
48                 subscriberList[subscriberListCounter] = subscriberAddress;
49                 subscriberListCounter++;
50             }
51         }
52 
53         return subscriberList;
54     }
55 
56     /// Gets the amount of subscriber.
57     function getSubscriberAmount() public view returns (uint) {
58         uint subscriberListAmount = 0;
59 
60         /// Iterate over all subscriber addresses, to get the actual subscriber amount.
61         for (uint i = 1; i < subscriberIndex; i++) {
62             address subscriberAddress = subscriberIndexToAddress[i];
63             
64             /// Count the addresses which are actual subscribers only.
65             if (isSubscriber(subscriberAddress) == true) {
66                 subscriberListAmount++;
67             }
68         }
69 
70         return subscriberListAmount;
71     }
72 
73     /// The sender's address will be added to the subscriber list
74     function subscribe() public isNotAContract {
75         require(isSubscriber(msg.sender) == false, "You already subscribed.");
76         
77         // New subscriber
78         subscriberAddressToSubscribed[msg.sender] = subscriberIndex;
79         subscriberIndexToAddress[subscriberIndex] = msg.sender;
80         subscriberIndex++;
81 
82         emit OnSubscribed(msg.sender);
83     }
84 
85     /// The sender's subscribtion will be revoked.
86     function unsubscribe() external isNotAContract {
87         require(isSubscriber(msg.sender) == true, "You have not subscribed yet.");
88 
89         uint index = subscriberAddressToSubscribed[msg.sender];
90         delete subscriberIndexToAddress[index];
91 
92         emit OnUnsubscribed(msg.sender);
93     }
94     
95     /// Checks wheter the transaction origin address is in the subscriber list
96     function isSubscriber() external view returns (bool) {
97         return isSubscriber(tx.origin);
98     }
99 
100     /// Checks wheter the given address is in the subscriber list
101     function isSubscriber(address subscriberAddress) public view returns (bool) {
102         return subscriberIndexToAddress[subscriberAddressToSubscribed[subscriberAddress]] != address(0);
103     }
104 }