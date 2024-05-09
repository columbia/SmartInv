1 pragma solidity ^0.4.23;
2 
3 contract BasicAccessControl {
4     address public owner;
5     // address[] public moderators;
6     uint16 public totalModerators = 0;
7     mapping (address => bool) public moderators;
8     bool public isMaintaining = false;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     modifier onlyModerators() {
20         require(msg.sender == owner || moderators[msg.sender] == true);
21         _;
22     }
23 
24     modifier isActive {
25         require(!isMaintaining);
26         _;
27     }
28 
29     function ChangeOwner(address _newOwner) onlyOwner public {
30         if (_newOwner != address(0)) {
31             owner = _newOwner;
32         }
33     }
34 
35 
36     function AddModerator(address _newModerator) onlyOwner public {
37         if (moderators[_newModerator] == false) {
38             moderators[_newModerator] = true;
39             totalModerators += 1;
40         }
41     }
42     
43     function RemoveModerator(address _oldModerator) onlyOwner public {
44         if (moderators[_oldModerator] == true) {
45             moderators[_oldModerator] = false;
46             totalModerators -= 1;
47         }
48     }
49 
50     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
51         isMaintaining = _isMaintaining;
52     }
53 }
54 
55 contract EtheremonAdventurePresale {
56     function getBidBySiteIndex(uint8 _siteId, uint _index) constant external returns(address bidder, uint32 bidId, uint8 siteId, uint amount, uint time);
57 }
58 
59 interface EtheremonAdventureItem {
60     function spawnSite(uint _classId, uint _tokenId, address _owner) external;
61 }
62 
63 contract EtheremonAdventureClaim is BasicAccessControl {
64     uint constant public MAX_SITE_ID = 108;
65     uint constant public MIN_SITE_ID = 1;
66     
67     struct BiddingInfo {
68         address bidder;
69         uint32 bidId;
70         uint amount;
71         uint time;
72         uint8 siteId;
73     }
74     
75     mapping(uint32 => uint) public bidTokens;
76     
77     address public adventureItem;
78     address public adventurePresale;
79     
80     modifier requireAdventureItem {
81         require(adventureItem != address(0));
82         _;        
83     }
84     
85     modifier requireAdventurePresale {
86         require(adventurePresale != address(0));
87         _;        
88     }
89     
90     constructor(address _adventureItem, address _adventurePresale) public {
91         adventureItem = _adventureItem;
92         adventurePresale = _adventurePresale;
93     }
94     
95     function setContract(address _adventureItem, address _adventurePresale) onlyOwner public {
96         adventureItem = _adventureItem;
97         adventurePresale = _adventurePresale;
98     }
99     
100     function claimSiteToken(uint8 _siteId, uint _index) isActive requireAdventureItem requireAdventurePresale public {
101         if (_siteId < MIN_SITE_ID || _siteId > MAX_SITE_ID || _index > 10) revert();
102         BiddingInfo memory bidInfo;
103         (bidInfo.bidder, bidInfo.bidId, bidInfo.siteId, bidInfo.amount, bidInfo.time) = EtheremonAdventurePresale(adventurePresale).getBidBySiteIndex(_siteId, _index);
104         if (bidInfo.bidId == 0 || bidTokens[bidInfo.bidId] > 0) revert();
105         uint tokenId = (_siteId - 1) * 10 + _index + 1;
106         bidTokens[bidInfo.bidId] = tokenId;
107         EtheremonAdventureItem(adventureItem).spawnSite(_siteId, tokenId, bidInfo.bidder);
108     }
109     
110     function getTokenByBid(uint32 _bidId) constant public returns(uint) {
111         return bidTokens[_bidId];
112     }
113 }