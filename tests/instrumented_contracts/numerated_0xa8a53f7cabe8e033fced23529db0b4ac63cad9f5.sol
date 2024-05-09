1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC721 {
5     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
6     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
7     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
8     
9     function balanceOf(address _owner) external view returns (uint256);
10     function ownerOf(uint256 _tokenId) external view returns (address);
11     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external payable;
12     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
13     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
14     function approve(address _approved, uint256 _tokenId) external payable;
15     function setApprovalForAll(address _operator, bool _approved) external;
16     function getApproved(uint256 _tokenId) external view returns (address);
17     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
18 }
19 
20 contract AsterFiStaking {
21     
22     struct Stake {
23         address owner;
24         uint256 tokenId;
25         uint256 stakedAt;
26         uint256 unstakeAvailableAt;
27         bool active;
28     }
29     
30     mapping(address => mapping(uint256 => Stake)) public stakes;
31     mapping(address => uint256[]) public stakedNFTs;
32     
33     uint256 public stakingPeriod = 12 * 30 days;
34     IERC721 public _AsterFiContract;
35 
36     constructor(address nftContract) {
37         _AsterFiContract = IERC721(nftContract);
38     }
39     
40     function stake(uint256 _tokenId) external {
41         require(_AsterFiContract.ownerOf(_tokenId) == msg.sender, "You don't own this NFT");
42         require(stakes[msg.sender][_tokenId].active == false, "NFT already staked");
43         
44         stakes[msg.sender][_tokenId] = Stake(msg.sender, _tokenId, block.timestamp, block.timestamp + stakingPeriod, true);
45         
46         stakedNFTs[msg.sender].push(_tokenId);
47         
48         _AsterFiContract.transferFrom(msg.sender, address(this), _tokenId);
49     }
50     
51     function unstake(uint256 _tokenId) external {
52         require(stakes[msg.sender][_tokenId].active == true, "NFT not staked");
53         require(stakes[msg.sender][_tokenId].unstakeAvailableAt <= block.timestamp, "Cannot unstake yet");
54         
55     uint256[] storage userStakedNFTs = stakedNFTs[msg.sender];
56     for (uint256 i = 0; i < userStakedNFTs.length; i++) {
57         if (userStakedNFTs[i] == _tokenId) {
58             userStakedNFTs[i] = userStakedNFTs[userStakedNFTs.length - 1];
59             userStakedNFTs.pop();
60             break;
61         }
62     }
63     
64     delete stakes[msg.sender][_tokenId];
65         
66         _AsterFiContract.transferFrom(address(this), msg.sender, _tokenId);
67     }
68     
69     function getStakeInfo(address _owner, uint256 _tokenId) external view returns (Stake memory) {
70         return stakes[_owner][_tokenId];
71     }
72     
73     function getStakedNFTs(address _owner) external view returns (uint256[] memory) {
74         return stakedNFTs[_owner];
75     }
76     
77 }