1 pragma solidity ^0.4.18;
2 
3 /* ==================================================================== */
4 /* Copyright (c) 2018 The Priate Conquest Project.  All rights reserved.
5 /* 
6 /* https://www.pirateconquest.com One of the world's slg games of blockchain 
7 /*  
8 /* authors rainy@livestar.com/Jonny.Fu@livestar.com
9 /*                 
10 /* ==================================================================== */
11 
12 contract KittyInterface {
13   function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens);
14   function ownerOf(uint256 _tokenId) external view returns (address owner);
15   function balanceOf(address _owner) public view returns (uint256 count);
16 }
17 
18 interface KittyTokenInterface {
19   function transferFrom(address _from, address _to, uint256 _tokenId) external;
20   function setTokenPrice(uint256 _tokenId, uint256 _price) external;
21   function CreateKittyToken(address _owner,uint256 _price, uint32 _kittyId) public;
22 }
23 
24 contract CaptainKitty {
25   address owner;
26   //event 
27   event CreateKitty(uint _count,address _owner);
28 
29   KittyInterface kittyContract;
30   KittyTokenInterface kittyToken;
31   /// @dev Trust contract
32   mapping (address => bool) actionContracts;
33   mapping (address => uint256) kittyToCount;
34   mapping (address => bool) kittyGetOrNot;
35 
36   function CaptainKitty() public {
37     owner = msg.sender;
38   }  
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43   
44   function setActionContract(address _actionAddr, bool _useful) public onlyOwner {
45     actionContracts[_actionAddr] = _useful;
46   }
47 
48   modifier onlyAccess() {
49     require(actionContracts[msg.sender]);
50     _;
51   }
52 
53   function setKittyContractAddress(address _address) external onlyOwner {
54     kittyContract = KittyInterface(_address);
55   }
56 
57   function setKittyTokenAddress(address _address) external onlyOwner {
58     kittyToken = KittyTokenInterface(_address);
59   }
60 
61   function createKitties() external payable {
62     uint256 kittycount = kittyContract.balanceOf(msg.sender);
63     require(kittyGetOrNot[msg.sender] == false);
64     if (kittycount>=99) {
65       kittycount=99;
66     }
67     if (kittycount>0 && kittyToCount[msg.sender]==0) {
68       kittyToCount[msg.sender] = kittycount;
69       kittyGetOrNot[msg.sender] = true;
70       for (uint i=0;i<kittycount;i++) {
71         kittyToken.CreateKittyToken(msg.sender,0, 1);
72       }
73       //event
74       CreateKitty(kittycount,msg.sender);
75     }
76   }
77 
78   function getKitties() external view returns(uint256 kittycnt,uint256 captaincnt,bool bGetOrNot) {
79     kittycnt = kittyContract.balanceOf(msg.sender);
80     captaincnt = kittyToCount[msg.sender];
81     bGetOrNot = kittyGetOrNot[msg.sender];
82   }
83 
84   function getKittyGetOrNot(address _addr) external view returns (bool) {
85     return kittyGetOrNot[_addr];
86   }
87 
88   function getKittyCount(address _addr) external view returns (uint256) {
89     return kittyToCount[_addr];
90   }
91 
92   function birthKitty() external onlyAccess payable {
93   }
94 }