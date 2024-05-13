1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.7.4;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
8 import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
9 
10 contract Profile is ERC721("Profile", "Profile"), Ownable {
11     using SafeERC20 for IERC20;
12 
13     mapping(address => bool) public isMinted;
14 
15     uint256 public mintFee;
16 
17     IERC20 public immutable babyToken;
18 
19     uint256 public immutable startMintTime;
20 
21     address public constant hole = 0x000000000000000000000000000000000000dEaD;
22 
23     uint256 public supplyHard = 10000;
24     uint256 public mintTotal;
25 
26     mapping(address => uint256) public avatar;
27 
28     mapping(uint256 => address) public mintOwners;
29 
30     mapping(address => bool) public isAdmin;
31 
32     event Mint(uint256 orderId, address account);
33     event Grant(uint256 orderId, address account, uint256 tokenId);
34     event SetAvatar(address account, uint256 tokenId);
35 
36     constructor(
37         IERC20 _babyToken,
38         uint256 _mintFee,
39         uint256 _startMintTime
40     ) {
41         babyToken = _babyToken;
42         mintFee = _mintFee;
43         startMintTime = _startMintTime;
44     }
45 
46     function setAdmin(address admin, bool enable) external onlyOwner {
47         require(admin != address(0), "Profile: address is zero");
48         isAdmin[admin] = enable;
49     }
50 
51     function setMintFee(uint256 _mintFee) external onlyOwner {
52         mintFee = _mintFee;
53     }
54 
55     function setSupplyHard(uint256 _supplyHard) external onlyOwner {
56         require(
57             _supplyHard >= mintTotal,
58             "Profile: Supply must not be less than what has been produced"
59         );
60         supplyHard = _supplyHard;
61     }
62 
63     function mint() external {
64         require(!isMinted[msg.sender], "Profile: mint already involved");
65         require(mintTotal <= supplyHard, "Profile: token haven't been minted.");
66         require(
67             block.timestamp > startMintTime,
68             "Profile: It's not the start time"
69         );
70         isMinted[msg.sender] = true;
71         mintTotal = mintTotal + 1;
72         mintOwners[mintTotal] = msg.sender;
73         babyToken.safeTransferFrom(msg.sender, hole, mintFee);
74         emit Mint(mintTotal, msg.sender);
75     }
76 
77     function grant(uint256 orderId, uint256 tokenId) external onlyAdmin {
78         require(!_exists(tokenId), "Profile: token already exists");
79         require(
80             mintOwners[orderId] != address(0),
81             "Profile: token already exists"
82         );
83         require(tokenId > 0, "Profile: tokenId is invalid");
84         _mint(mintOwners[orderId], tokenId);
85 
86         emit Grant(orderId, mintOwners[orderId], tokenId);
87         delete mintOwners[orderId];
88     }
89 
90     function setBaseURI(string memory baseUri) external onlyOwner {
91         _setBaseURI(baseUri);
92     }
93 
94     function setAvatar(uint256 tokenId) external {
95         require(
96             ownerOf(tokenId) == msg.sender || tokenId == 0,
97             "set avator of token that is not own"
98         );
99         avatar[msg.sender] = tokenId;
100         emit SetAvatar(msg.sender, tokenId);
101     }
102 
103     function _transfer(
104         address from,
105         address to,
106         uint256 tokenId
107     ) internal override {
108         if (avatar[from] == tokenId) {
109             avatar[from] = 0;
110             emit SetAvatar(msg.sender, 0);
111         }
112         super._transfer(from, to, tokenId);
113     }
114 
115     modifier onlyAdmin() {
116         require(isAdmin[msg.sender], "Profile: caller is not the admin");
117         _;
118     }
119 }
