1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.4;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
7 
8 contract BabyWonderland is ERC721("Baby Wonderland", "BWL"), Ownable {
9     mapping(address => bool) public isMinter;
10 
11     event Mint(address account, uint256 tokenId);
12     event NewMinter(address account);
13     event DelMinter(address account);
14 
15     function addMinter(address _minter) external onlyOwner {
16         require(
17             _minter != address(0),
18             "BabyWonderland: minter is zero address"
19         );
20         isMinter[_minter] = true;
21         emit NewMinter(_minter);
22     }
23 
24     function delMinter(address _minter) external onlyOwner {
25         require(
26             _minter != address(0),
27             "BabyWonderland: minter is the zero address"
28         );
29         isMinter[_minter] = false;
30         emit DelMinter(_minter);
31     }
32 
33     function mint(address _recipient) public onlyMinter {
34         require(
35             _recipient != address(0),
36             "BabyWonderland: recipient is zero address"
37         );
38         uint256 _tokenId = totalSupply() + 1;
39         _mint(_recipient, _tokenId);
40         emit Mint(_recipient, _tokenId);
41     }
42 
43     function batchMint(address _recipient, uint256 _number)
44         external
45         onlyMinter
46     {
47         for (uint256 i = 0; i != _number; i++) {
48             mint(_recipient);
49         }
50     }
51 
52     function batchTransferFrom(
53         address from,
54         address to,
55         uint256[] memory tokenIds
56     ) external {
57         for (uint256 i = 0; i != tokenIds.length; ++i) {
58             transferFrom(from, to, tokenIds[i]);
59         }
60     }
61 
62     function setBaseURI(string memory baseUri) external onlyOwner {
63         _setBaseURI(baseUri);
64     }
65 
66     function tokenURI(uint256 tokenId)
67         public
68         view
69         virtual
70         override
71         returns (string memory)
72     {
73         string memory uri = super.tokenURI(tokenId);
74         return string(abi.encodePacked(uri, ".json"));
75     }
76 
77     modifier onlyMinter() {
78         require(
79             isMinter[msg.sender],
80             "BabyWonderland: caller is not the minter"
81         );
82         _;
83     }
84 }
