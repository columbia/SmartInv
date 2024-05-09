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
24 contract CaptainKitties {
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
36 
37   function CaptainKitties() public {
38     owner = msg.sender;
39   }  
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44   
45   function setKittyContractAddress(address _address) external onlyOwner {
46     kittyContract = KittyInterface(_address);
47   }
48 
49   function setKittyTokenAddress(address _address) external onlyOwner {
50     kittyToken = KittyTokenInterface(_address);
51   }
52 
53   function createKitties() external payable {
54     uint256 kittycount = kittyContract.balanceOf(msg.sender);
55     require(kittyGetOrNot[msg.sender] == false);
56     if (kittycount>=9) {
57       kittycount=9;
58     }
59     if (kittycount>0 && kittyToCount[msg.sender]==0) {
60       kittyToCount[msg.sender] = kittycount;
61       kittyGetOrNot[msg.sender] = true;
62       for (uint i=0;i<kittycount;i++) {
63         kittyToken.CreateKittyToken(msg.sender,0, 1);
64       }
65       //event
66       CreateKitty(kittycount,msg.sender);
67     }
68   }
69 
70   function getKitties() external view returns(uint256 kittycnt,uint256 captaincnt,bool bGetOrNot) {
71     kittycnt = kittyContract.balanceOf(msg.sender);
72     captaincnt = kittyToCount[msg.sender];
73     bGetOrNot = kittyGetOrNot[msg.sender];
74   }
75 
76   function getKittyGetOrNot(address _addr) external view returns (bool) {
77     return kittyGetOrNot[_addr];
78   }
79 
80   function getKittyCount(address _addr) external view returns (uint256) {
81     return kittyToCount[_addr];
82   }
83 
84   function birthKitty() external {
85   }
86 
87 }