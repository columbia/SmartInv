1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC721 {
5     function ownerOf(uint256 tokenId_) external view returns (address);
6     function transferFrom(address from_, address to_, uint256 tokenId_) external;
7 }
8 interface IGasGangsters {
9     function mintAsController(address to_, uint256 tokenId_) external;
10 }
11 
12 abstract contract Ownable {
13     event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
14     address public owner; 
15     constructor() { owner = msg.sender; }
16     modifier onlyOwner { require(owner == msg.sender, "Not Owner!"); _; }
17     function transferOwnership(address new_) external { 
18         address _oldOwner = owner;
19         require(_oldOwner == msg.sender, "Not Owner!");
20         owner = new_; 
21         emit OwnershipTransferred(_oldOwner, new_);
22     }
23 }
24 
25 contract GasBurner is Ownable {
26     // GasBurner is simple.
27     // Step 1: Burn the existing ERC721
28     // Step 2: Mint the cooresponding ERC721
29 
30     // Interfaces
31     IERC721 public GasBox;
32     IGasGangsters public GasGangsters;
33 
34     // Constants
35     address public constant burnAddress = 0x000000000000000000000000000000000000dEaD;
36 
37     // Constructor
38     constructor(address gasBox_, address gasGangsters_) {
39         GasBox = IERC721(gasBox_);
40         GasGangsters = IGasGangsters(gasGangsters_);
41     }
42 
43     // Setters
44     function setGasBox(address gasBox_) external onlyOwner {
45         GasBox = IERC721(gasBox_);
46     }
47     function setGasGangsters(address gasGangsters_) external onlyOwner {
48         GasGangsters = IGasGangsters(gasGangsters_);
49     }
50 
51     // We use the name initiateGangsters because it's on-lore
52     function initiateGangsters(uint256[] calldata tokenIds_) external {
53         uint256 l = tokenIds_.length;
54         uint256 i; unchecked { do {
55             // This will "burn" the token. Reverts on non-ownership as default behavior
56             GasBox.transferFrom(msg.sender, burnAddress, tokenIds_[i]);
57             // This will "mint" the token using tokenId and SM version of ERC721G
58             GasGangsters.mintAsController(msg.sender, tokenIds_[i]);
59         } while (++i < l); }
60     }
61 }