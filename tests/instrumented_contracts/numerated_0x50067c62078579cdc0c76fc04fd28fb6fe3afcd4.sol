1 pragma solidity ^0.4.16;
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
56     function BasicAccessControl() public {
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
101 contract ERC20Interface {
102     function totalSupply() public constant returns (uint);
103     function balanceOf(address tokenOwner) public constant returns (uint balance);
104     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
105     function transfer(address to, uint tokens) public returns (bool success);
106     function approve(address spender, uint tokens) public returns (bool success);
107     function transferFrom(address from, address to, uint tokens) public returns (bool success);
108 }
109 
110 interface EtheremonAdventureItem {
111     function ownerOf(uint256 _tokenId) external view returns (address);
112     function getItemInfo(uint _tokenId) constant external returns(uint classId, uint value);
113     function spawnItem(uint _classId, uint _value, address _owner) external returns(uint);
114 }
115 
116 contract EtheremonAdventureData {
117     
118     function addLandRevenue(uint _siteId, uint _emontAmount, uint _etherAmount) external;
119     function addTokenClaim(uint _tokenId, uint _emontAmount, uint _etherAmount) external;
120     
121     // public function
122     function getLandRevenue(uint _classId) constant public returns(uint _emontAmount, uint _etherAmount);
123     function getTokenClaim(uint _tokenId) constant public returns(uint _emontAmount, uint _etherAmount);
124 }
125 
126 contract EtheremonAdventureRevenue is BasicAccessControl {
127     using SafeMath for uint;
128     
129     struct PairData {
130         uint d1;
131         uint d2;
132     }
133     
134     address public tokenContract;
135     address public adventureDataContract;
136     address public adventureItemContract;
137 
138     modifier requireTokenContract {
139         require(tokenContract != address(0));
140         _;
141     }
142     
143     modifier requireAdventureDataContract {
144         require(adventureDataContract != address(0));
145         _;
146     }
147 
148     modifier requireAdventureItemContract {
149         require(adventureItemContract != address(0));
150         _;
151     }
152     
153     
154     function setConfig(address _tokenContract, address _adventureDataContract, address _adventureItemContract) onlyModerators public {
155         tokenContract = _tokenContract;
156         adventureDataContract = _adventureDataContract;
157         adventureItemContract = _adventureItemContract;
158     }
159     
160     function withdrawEther(address _sendTo, uint _amount) onlyOwner public {
161         // it is used in case we need to upgrade the smartcontract
162         if (_amount > address(this).balance) {
163             revert();
164         }
165         _sendTo.transfer(_amount);
166     }
167     
168     function withdrawToken(address _sendTo, uint _amount) onlyOwner requireTokenContract external {
169         ERC20Interface token = ERC20Interface(tokenContract);
170         if (_amount > token.balanceOf(address(this))) {
171             revert();
172         }
173         token.transfer(_sendTo, _amount);
174     }
175     // public
176     
177     function () payable public {
178     }
179     
180 
181     function getEarning(uint _tokenId) constant public returns(uint _emontAmount, uint _ethAmount) {
182         PairData memory tokenInfo;
183         PairData memory currentRevenue;
184         PairData memory claimedRevenue;
185         (tokenInfo.d1, tokenInfo.d2) = EtheremonAdventureItem(adventureItemContract).getItemInfo(_tokenId);
186         EtheremonAdventureData data = EtheremonAdventureData(adventureDataContract);
187         (currentRevenue.d1, currentRevenue.d2) = data.getLandRevenue(tokenInfo.d1);
188         (claimedRevenue.d1, claimedRevenue.d2) = data.getTokenClaim(_tokenId);
189         
190         _emontAmount = ((currentRevenue.d1.mul(9)).div(100)).sub(claimedRevenue.d1);
191         _ethAmount = ((currentRevenue.d2.mul(9)).div(100)).sub(claimedRevenue.d2);
192     }
193     
194     function claimEarning(uint _tokenId) isActive requireTokenContract requireAdventureDataContract requireAdventureItemContract public {
195         EtheremonAdventureItem item = EtheremonAdventureItem(adventureItemContract);
196         EtheremonAdventureData data = EtheremonAdventureData(adventureDataContract);
197         if (item.ownerOf(_tokenId) != msg.sender) revert();
198         PairData memory tokenInfo;
199         PairData memory currentRevenue;
200         PairData memory claimedRevenue;
201         PairData memory pendingRevenue;
202         (tokenInfo.d1, tokenInfo.d2) = item.getItemInfo(_tokenId);
203         (currentRevenue.d1, currentRevenue.d2) = data.getLandRevenue(tokenInfo.d1);
204         (claimedRevenue.d1, claimedRevenue.d2) = data.getTokenClaim(_tokenId);
205         
206         pendingRevenue.d1 = ((currentRevenue.d1.mul(9)).div(100)).sub(claimedRevenue.d1);
207         pendingRevenue.d2 = ((currentRevenue.d2.mul(9)).div(100)).sub(claimedRevenue.d2);
208         
209         if (pendingRevenue.d1 == 0 && pendingRevenue.d2 == 0) revert();
210         data.addTokenClaim(_tokenId, pendingRevenue.d1, pendingRevenue.d2);
211         
212         if (pendingRevenue.d1 > 0) {
213             ERC20Interface(tokenContract).transfer(msg.sender, pendingRevenue.d1);
214         }
215         
216         if (pendingRevenue.d2 > 0) {
217             msg.sender.transfer(pendingRevenue.d2);
218         }
219         
220     }
221 }