1 pragma solidity ^0.4.25;
2 
3 interface ERC721 {
4     function totalSupply() external view returns (uint256 tokens);
5     function balanceOf(address owner) external view returns (uint256 balance);
6     function ownerOf(uint256 tokenId) external view returns (address owner);
7     function exists(uint256 tokenId) external view returns (bool tokenExists);
8     function approve(address to, uint256 tokenId) external;
9     function getApproved(uint256 tokenId) external view returns (address operator);
10 
11     function transferFrom(address from, address to, uint256 tokenId) external;
12     function tokensOf(address owner) external view returns (uint256[] tokens);
13     //function tokenByIndex(uint256 index) external view returns (uint256 token);
14 
15     // Events
16     event Transfer(address from, address to, uint256 tokenId);
17     event Approval(address owner, address approved, uint256 tokenId);
18 }
19 
20 contract WWGClanCoupon is ERC721 {
21     using SafeMath for uint256;
22     
23     // Clan contract not finalized/deployed yet, so buyers get an ERC-721 coupon 
24     // which will be burnt in exchange for real clan token in next few weeks 
25     
26     address preLaunchMinter;
27     address wwgClanContract;
28     
29     uint256 numClans;
30     address owner; // Minor management
31     
32     event ClanMinted(address to, uint256 clanId);
33     
34     // ERC721 stuff
35     mapping (uint256 => address) public tokenOwner;
36     mapping (uint256 => address) public tokenApprovals;
37     mapping (address => uint256[]) public ownedTokens;
38     mapping(uint256 => uint256) public ownedTokensIndex;
39     
40     constructor() public {
41         owner = msg.sender;
42     }
43     
44     function setCouponMinter(address prelaunchContract) external {
45         require(msg.sender == owner);
46         require(preLaunchMinter == address(0));
47         preLaunchMinter = prelaunchContract;
48     }
49     
50     function setClanContract(address clanContract) external {
51         require(msg.sender == owner);
52         wwgClanContract = address(clanContract);
53     }
54     
55     function mintClan(uint256 clanId, address clanOwner) external {
56         require(msg.sender == address(preLaunchMinter));
57         require(tokenOwner[clanId] == address(0));
58 
59         numClans++;
60         addTokenTo(clanOwner, clanId);
61         emit Transfer(address(0), clanOwner, clanId);
62     }
63     
64     // Finalized clan contract has control to redeem, so will burn this coupon upon doing so
65     function burnCoupon(address clanOwner, uint256 tokenId) external {
66         require (msg.sender == wwgClanContract);
67         removeTokenFrom(clanOwner, tokenId);
68         numClans = numClans.sub(1);
69         
70         emit ClanMinted(clanOwner, tokenId);
71     }
72     
73     function balanceOf(address player) public view returns (uint256) {
74         return ownedTokens[player].length;
75     }
76     
77     function ownerOf(uint256 clanId) external view returns (address) {
78         return tokenOwner[clanId];
79     }
80     
81     function totalSupply() external view returns (uint256) {
82         return numClans;
83     }
84     
85     function exists(uint256 clanId) public view returns (bool) {
86         return tokenOwner[clanId] != address(0);
87     }
88     
89     function approve(address to, uint256 clanId) external {
90         tokenApprovals[clanId] = to;
91         emit Approval(msg.sender, to, clanId);
92     }
93 
94     function getApproved(uint256 clanId) external view returns (address operator) {
95         return tokenApprovals[clanId];
96     }
97     
98     function tokensOf(address player) external view returns (uint256[] tokens) {
99          return ownedTokens[player];
100     }
101     
102     function transferFrom(address from, address to, uint256 tokenId) public {
103         require(tokenApprovals[tokenId] == msg.sender || tokenOwner[tokenId] == msg.sender);
104 
105         removeTokenFrom(from, tokenId);
106         addTokenTo(to, tokenId);
107 
108         delete tokenApprovals[tokenId]; // Clear approval
109         emit Transfer(from, to, tokenId);
110     }
111 
112     function removeTokenFrom(address from, uint256 tokenId) internal {
113         require(tokenOwner[tokenId] == from);
114         tokenOwner[tokenId] = address(0);
115         delete tokenApprovals[tokenId]; // Clear approval
116 
117         uint256 tokenIndex = ownedTokensIndex[tokenId];
118         uint256 lastTokenIndex = ownedTokens[from].length.sub(1);
119         uint256 lastToken = ownedTokens[from][lastTokenIndex];
120 
121         ownedTokens[from][tokenIndex] = lastToken;
122         ownedTokens[from][lastTokenIndex] = 0;
123 
124         ownedTokens[from].length--;
125         ownedTokensIndex[tokenId] = 0;
126         ownedTokensIndex[lastToken] = tokenIndex;
127     }
128 
129     function addTokenTo(address to, uint256 tokenId) internal {
130         require(balanceOf(to) == 0); // Can only own one clan (thus coupon to keep things simple)
131         tokenOwner[tokenId] = to;
132 
133         ownedTokensIndex[tokenId] = ownedTokens[to].length;
134         ownedTokens[to].push(tokenId);
135     }
136 
137 }
138 
139 
140 library SafeMath {
141 
142   /**
143   * @dev Multiplies two numbers, throws on overflow.
144   */
145   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146     if (a == 0) {
147       return 0;
148     }
149     uint256 c = a * b;
150     assert(c / a == b);
151     return c;
152   }
153 
154   /**
155   * @dev Integer division of two numbers, truncating the quotient.
156   */
157   function div(uint256 a, uint256 b) internal pure returns (uint256) {
158     // assert(b > 0); // Solidity automatically throws when dividing by 0
159     uint256 c = a / b;
160     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161     return c;
162   }
163 
164   /**
165   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
166   */
167   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168     assert(b <= a);
169     return a - b;
170   }
171 
172   /**
173   * @dev Adds two numbers, throws on overflow.
174   */
175   function add(uint256 a, uint256 b) internal pure returns (uint256) {
176     uint256 c = a + b;
177     assert(c >= a);
178     return c;
179   }
180 }