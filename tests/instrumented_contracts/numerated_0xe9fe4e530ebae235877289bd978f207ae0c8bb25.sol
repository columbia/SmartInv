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
90         require(tokenOwner[clanId] == msg.sender);
91         tokenApprovals[clanId] = to;
92         emit Approval(msg.sender, to, clanId);
93     }
94 
95     function getApproved(uint256 clanId) external view returns (address operator) {
96         return tokenApprovals[clanId];
97     }
98     
99     function tokensOf(address player) external view returns (uint256[] tokens) {
100          return ownedTokens[player];
101     }
102     
103     function transferFrom(address from, address to, uint256 tokenId) public {
104         require(tokenApprovals[tokenId] == msg.sender || tokenOwner[tokenId] == msg.sender);
105 
106         removeTokenFrom(from, tokenId);
107         addTokenTo(to, tokenId);
108 
109         delete tokenApprovals[tokenId]; // Clear approval
110         emit Transfer(from, to, tokenId);
111     }
112 
113     function removeTokenFrom(address from, uint256 tokenId) internal {
114         require(tokenOwner[tokenId] == from);
115         tokenOwner[tokenId] = address(0);
116         delete tokenApprovals[tokenId]; // Clear approval
117 
118         uint256 tokenIndex = ownedTokensIndex[tokenId];
119         uint256 lastTokenIndex = ownedTokens[from].length.sub(1);
120         uint256 lastToken = ownedTokens[from][lastTokenIndex];
121 
122         ownedTokens[from][tokenIndex] = lastToken;
123         ownedTokens[from][lastTokenIndex] = 0;
124 
125         ownedTokens[from].length--;
126         ownedTokensIndex[tokenId] = 0;
127         ownedTokensIndex[lastToken] = tokenIndex;
128     }
129 
130     function addTokenTo(address to, uint256 tokenId) internal {
131         require(balanceOf(to) == 0); // Can only own one clan (thus coupon to keep things simple)
132         tokenOwner[tokenId] = to;
133 
134         ownedTokensIndex[tokenId] = ownedTokens[to].length;
135         ownedTokens[to].push(tokenId);
136     }
137 
138 }
139 
140 
141 library SafeMath {
142 
143   /**
144   * @dev Multiplies two numbers, throws on overflow.
145   */
146   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147     if (a == 0) {
148       return 0;
149     }
150     uint256 c = a * b;
151     assert(c / a == b);
152     return c;
153   }
154 
155   /**
156   * @dev Integer division of two numbers, truncating the quotient.
157   */
158   function div(uint256 a, uint256 b) internal pure returns (uint256) {
159     // assert(b > 0); // Solidity automatically throws when dividing by 0
160     uint256 c = a / b;
161     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162     return c;
163   }
164 
165   /**
166   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
167   */
168   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169     assert(b <= a);
170     return a - b;
171   }
172 
173   /**
174   * @dev Adds two numbers, throws on overflow.
175   */
176   function add(uint256 a, uint256 b) internal pure returns (uint256) {
177     uint256 c = a + b;
178     assert(c >= a);
179     return c;
180   }
181 }