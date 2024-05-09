1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract Ownable {
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7     address public owner;
8     constructor() { owner = msg.sender; }
9     modifier onlyOwner { require(owner == msg.sender, "onlyOwner not owner!");_; }
10     function transferOwnership(address new_) external onlyOwner {address _old = owner; owner = new_; emit OwnershipTransferred(_old, new_); }
11 }
12 
13 interface iCGO {
14     function balanceOf(address account, uint256 id) external view returns (uint256);
15     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
16 }
17 
18 interface iMSC {
19     function controllerMint(address to_, uint256 amount_) external;
20 }
21 
22 contract MutantMinter is Ownable {
23 
24     address public constant burnAddress = 0x000000000000000000000000000000000000dEaD;
25     uint8 public saleState = 0; //1-CGO 2-PUB
26     uint256 public totalSupply = 0;
27     uint256 public constant maxToken = 999;
28     mapping(address => uint256) public psMinted;
29 
30     iCGO public CGO = iCGO(0x5923Ef0e180d286c3441cb9879EBab06bB2182c9);
31     iMSC public MSC = iMSC(0xEE0e0b6c76d528B07113bB5709b30822DE46732B);
32 
33     modifier onlySender {
34         require(msg.sender == tx.origin, "No smart contract"); _; 
35     }
36 
37     function setToken(address address_) external onlyOwner {
38         MSC = iMSC(address_);
39     }
40 
41     function setCGO(address address_) external onlyOwner {
42         CGO = iCGO(address_); 
43     }
44 
45     function setSaleState(uint8 _state) external onlyOwner {
46         saleState = _state;
47     }
48 
49     function ownerMint(uint256 amount_) external onlyOwner {
50         require(amount_ + totalSupply <= maxToken, "No more NFTs");
51         internalmintM(msg.sender, amount_);
52     }
53 
54     function mintWithCGO(uint256 amount_) external onlySender {
55         require(saleState == 1, "Inactive");
56         require(amount_ + totalSupply <= maxToken, "No more NFTs");
57         require(amount_ <= CGO.balanceOf(msg.sender, 0), "You do not own enough CGO");
58 
59         CGO.safeTransferFrom(msg.sender, burnAddress, 0, amount_, "0x00");
60         internalmintM(msg.sender, amount_);
61     }
62 
63     function mintPublic() external onlySender {
64         require(saleState == 2, "Inactive");
65         require(1 + totalSupply <= maxToken, "No more NFTs");
66         require(psMinted[msg.sender] == 0, "No mints remaining");
67 
68         psMinted[msg.sender] ++;
69         internalmintM(msg.sender, 1);
70     }
71 
72     function internalmintM(address to_, uint256 amount_) internal {
73         for (uint256 i = 0; i < amount_; i++) {
74           totalSupply ++;
75           MSC.controllerMint(to_, totalSupply);
76         }
77     }
78 }