1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract BasicAccessControl {
50     address public owner;
51     // address[] public moderators;
52     uint16 public totalModerators = 0;
53     mapping (address => bool) public moderators;
54     bool public isMaintaining = false;
55 
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     modifier onlyModerators() {
66         require(msg.sender == owner || moderators[msg.sender] == true);
67         _;
68     }
69 
70     modifier isActive {
71         require(!isMaintaining);
72         _;
73     }
74 
75     function ChangeOwner(address _newOwner) onlyOwner public {
76         if (_newOwner != address(0)) {
77             owner = _newOwner;
78         }
79     }
80 
81 
82     function AddModerator(address _newModerator) onlyOwner public {
83         if (moderators[_newModerator] == false) {
84             moderators[_newModerator] = true;
85             totalModerators += 1;
86         }
87     }
88     
89     function RemoveModerator(address _oldModerator) onlyOwner public {
90         if (moderators[_oldModerator] == true) {
91             moderators[_oldModerator] = false;
92             totalModerators -= 1;
93         }
94     }
95 
96     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
97         isMaintaining = _isMaintaining;
98     }
99 }
100 
101 contract EtheremonAdventureData is BasicAccessControl {
102     
103     using SafeMath for uint;
104     
105     struct LandTokenClaim {
106         uint emontAmount;
107         uint etherAmount;
108     }
109     
110     // total revenue 
111     struct LandRevenue {
112         uint emontAmount;
113         uint etherAmount;
114     }
115     
116     struct ExploreData {
117         address sender;
118         uint typeId;
119         uint monsterId;
120         uint siteId;
121         uint itemSeed;
122         uint startAt; // blocknumber
123     }
124     
125     uint public exploreCount = 0;
126     mapping(uint => ExploreData) public exploreData; // explore count => data
127     mapping(address => uint) public explorePending; // address => explore id
128     
129     mapping(uint => LandTokenClaim) public claimData; // tokenid => claim info
130     mapping(uint => LandRevenue) public siteData; // class id => amount 
131     
132     function addLandRevenue(uint _siteId, uint _emontAmount, uint _etherAmount) onlyModerators external {
133         LandRevenue storage revenue = siteData[_siteId];
134         revenue.emontAmount = revenue.emontAmount.add(_emontAmount);
135         revenue.etherAmount = revenue.etherAmount.add(_etherAmount);
136     }
137     
138     function addTokenClaim(uint _tokenId, uint _emontAmount, uint _etherAmount) onlyModerators external {
139         LandTokenClaim storage claim = claimData[_tokenId];
140         claim.emontAmount = claim.emontAmount.add(_emontAmount);
141         claim.etherAmount = claim.etherAmount.add(_etherAmount);
142     }
143     
144     function addExploreData(address _sender, uint _typeId, uint _monsterId, uint _siteId, uint _startAt, uint _emontAmount, uint _etherAmount) onlyModerators external returns(uint){
145         if (explorePending[_sender] > 0) revert();
146         exploreCount += 1;
147         ExploreData storage data = exploreData[exploreCount];
148         data.sender = _sender;
149         data.typeId = _typeId;
150         data.monsterId = _monsterId;
151         data.siteId = _siteId;
152         data.itemSeed = 0;
153         data.startAt = _startAt;
154         explorePending[_sender] = exploreCount;
155         
156         LandRevenue storage revenue = siteData[_siteId];
157         revenue.emontAmount = revenue.emontAmount.add(_emontAmount);
158         revenue.etherAmount = revenue.etherAmount.add(_etherAmount);
159         return exploreCount;
160     }
161     
162     function removePendingExplore(uint _exploreId, uint _itemSeed) onlyModerators external {
163         ExploreData storage data = exploreData[_exploreId];
164         if (explorePending[data.sender] != _exploreId)
165             revert();
166         explorePending[data.sender] = 0;
167         data.itemSeed = _itemSeed;
168     }
169     
170     // public function
171     function getLandRevenue(uint _classId) constant public returns(uint _emontAmount, uint _etherAmount) {
172         LandRevenue storage revenue = siteData[_classId];
173         return (revenue.emontAmount, revenue.etherAmount);
174     }
175     
176     function getTokenClaim(uint _tokenId) constant public returns(uint _emontAmount, uint _etherAmount) {
177         LandTokenClaim storage claim = claimData[_tokenId];
178         return (claim.emontAmount, claim.etherAmount);
179     }
180     
181     function getExploreData(uint _exploreId) constant public returns(address _sender, uint _typeId, uint _monsterId, uint _siteId, uint _itemSeed, uint _startAt) {
182         ExploreData storage data = exploreData[_exploreId];
183         return (data.sender, data.typeId, data.monsterId, data.siteId, data.itemSeed, data.startAt);
184     }
185     
186     function getPendingExplore(address _player) constant public returns(uint) {
187         return explorePending[_player];
188     }
189     
190     function getPendingExploreData(address _player) constant public returns(uint _exploreId, uint _typeId, uint _monsterId, uint _siteId, uint _itemSeed, uint _startAt) {
191         _exploreId = explorePending[_player];
192         if (_exploreId > 0) {
193             ExploreData storage data = exploreData[_exploreId];
194             return (_exploreId, data.typeId, data.monsterId, data.siteId, data.itemSeed, data.startAt);
195         }
196         
197     }
198 }