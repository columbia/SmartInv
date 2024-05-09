1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @title ERC721SS (ERC721 Sumo Soul) Minter
7  * @author 0xSumo
8  */
9 
10 interface IERC721 {
11     function ownerOf(uint256 tokenId_) external view returns (address);
12 }
13 
14 interface IERC721SS {
15     function mint(uint256 tokenId_, address to_) external;
16     function ownerOf(uint256 tokenId_) external view returns (address);
17 }
18 
19 abstract contract Ownable {
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21     address public owner;
22     constructor() { owner = msg.sender; }
23     modifier onlyOwner { require(owner == msg.sender, "onlyOwner not owner!");_; } 
24     function transferOwnership(address new_) external onlyOwner { address _old = owner; owner = new_; emit OwnershipTransferred(_old, new_); }
25 }
26 
27 abstract contract MerkleProof {
28     bytes32 internal _merkleRoot;
29     function _setMerkleRoot(bytes32 merkleRoot_) internal virtual { _merkleRoot = merkleRoot_; }
30     function isWhitelisted(address address_, bytes32[] memory proof_) public view returns (bool) {
31         bytes32 _leaf = keccak256(abi.encodePacked(address_));
32         for (uint256 i = 0; i < proof_.length; i++) {
33             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
34         }
35         return _leaf == _merkleRoot;
36     }
37 }
38 
39 contract ERC721SSMinter is Ownable, MerkleProof {
40 
41     IERC721SS public ERC721SS = IERC721SS(0x508c1CC6099F273A751386561e49Cf279571E716);
42     IERC721 public ERC721 = IERC721(0xd2b14f166Daeb1Ec73a4901745DBE2199Db6B40C);
43     uint256 public Ids = 334;
44     uint256 public constant optionPrice = 0.01 ether;
45     mapping(uint256 => string) public ADD;
46     struct IdAndAdd { uint256 ids_; string add_; }
47     mapping(address => uint256) internal minted;
48 
49     function setERC721SS(address _address) external onlyOwner { 
50         ERC721SS = IERC721SS(_address); 
51     }
52 
53     function setERC721(address _address) external onlyOwner { 
54         ERC721 = IERC721(_address); 
55     }
56 
57     function claimSBT(uint256 tokenId, string memory add) external payable {
58             require(ERC721.ownerOf(tokenId) == msg.sender, "Not owner");
59             require(msg.value == optionPrice, "Value sent is not correct");
60             require(bytes(add).length > 0, "Give addy");
61             ADD[tokenId] = add;
62             ERC721SS.mint(tokenId, msg.sender);
63     }
64 
65     function claimSBTFree(uint256 tokenId) external {
66         require(ERC721.ownerOf(tokenId) == msg.sender, "Not owner");
67         ERC721SS.mint(tokenId, msg.sender);
68     }
69 
70     function mintSBT(bytes32[] memory proof_, string memory add) external payable {
71         require(isWhitelisted(msg.sender, proof_), "You are not whitelisted!");
72         require(msg.value == optionPrice, "Value sent is not correct");
73         require(bytes(add).length > 0, "Give addy");
74         require(Ids < 999, "No more");
75         require(2 > minted[msg.sender], "You have no whitelistMint left");
76         minted[msg.sender]++;
77         ADD[Ids] = add;
78         ERC721SS.mint(Ids, msg.sender);
79         Ids++;
80     }
81 
82     function mintSBTFree(bytes32[] memory proof_) external {
83         require(isWhitelisted(msg.sender, proof_), "You are not whitelisted!");
84         require(Ids < 999, "No more");
85         require(2 > minted[msg.sender], "You have no whitelistMint left");
86         minted[msg.sender]++;
87         ERC721SS.mint(Ids, msg.sender);
88         Ids++;
89     }
90 
91     function changedMind(uint256 tokenId, string memory add) external payable {
92         require(ERC721SS.ownerOf(tokenId) == msg.sender, "Not owner");
93         require(msg.value == optionPrice, "Value sent is not correct");
94         ADD[tokenId] = add;
95     }
96 
97     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
98         _setMerkleRoot(merkleRoot_);
99     }
100 
101     function getAllIdAndAdd(uint256 _startIndex, uint256 _count) external view returns (IdAndAdd[] memory) {
102         IdAndAdd[] memory _IdAndAdd = new IdAndAdd[](_count);
103         for (uint256 i = 0; i < _count; i++) {
104             uint256 currentIndex = _startIndex + i;
105             uint256 _ids = currentIndex;
106             string memory _add  = ADD[currentIndex];
107             _IdAndAdd[i] = IdAndAdd(_ids, _add);
108         }
109         return _IdAndAdd;
110     }
111 
112     function withdraw() public onlyOwner {
113         uint balance = address(this).balance;
114         payable(msg.sender).transfer(balance);
115     }
116 }