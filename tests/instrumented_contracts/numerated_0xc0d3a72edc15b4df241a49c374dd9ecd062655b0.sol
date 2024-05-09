1 pragma solidity ^0.4.18;
2 /* ==================================================================== */
3 /* Copyright (c) 2018 The Priate Conquest Project.  All rights reserved.
4 /* 
5 /* https://www.pirateconquest.com One of the world's slg games of blockchain 
6 /*  
7 /* authors rainy@livestar.com/Jonny.Fu@livestar.com
8 /*                 
9 /* ==================================================================== */
10 interface CaptainTokenInterface {
11   function CreateCaptainToken(address _owner,uint256 _price, uint32 _captainId, uint32 _color,uint32 _atk, uint32 _defense,uint32 _level,uint256 _exp) public;
12 }
13 
14 interface CaptainGameConfigInterface {
15   function getCardInfo(uint32 cardId) external constant returns (uint32,uint32,uint32, uint32,uint32,uint256,uint256);
16   function getSellable(uint32 _captainId) external returns (bool);
17 }
18 contract CaptainSell {
19 
20   address devAddress;
21   function CaptainSell() public {
22     devAddress = msg.sender;
23   }
24 
25   CaptainTokenInterface public captains;
26   CaptainGameConfigInterface public config; 
27   /// @dev The BuyToken event is fired whenever a token is sold.
28   event BuyToken(uint256 tokenId, uint256 oldPrice, address prevOwner, address winner);
29   
30   //mapping
31   mapping(uint32 => uint256) captainToCount; 
32   /// @notice No tipping!
33   /// @dev Reject all Ether from being sent here, unless it's from one of the
34   ///  two auction contracts. (Hopefully, we can prevent user accidents.)
35   function() external payable {
36   }
37 
38   modifier onlyOwner() {
39     require(msg.sender == devAddress);
40     _;
41   }
42 
43   //setting configuration
44   function setGameConfigContract(address _address) external onlyOwner {
45     config = CaptainGameConfigInterface(_address);
46   }
47 
48   //setting configuration
49   function setCaptainTokenContract(address _address) external onlyOwner {
50     captains = CaptainTokenInterface(_address);
51   }
52 
53 
54   function prepurchase(uint32 _captainId) external payable {
55     uint32 color;
56     uint32 atk;
57     uint32 defense;
58     uint256 price;
59     uint256 captainCount;
60     uint256 SellCount = captainToCount[_captainId];
61     (color,atk,,,defense,price,captainCount) = config.getCardInfo(_captainId);
62     require(config.getSellable(_captainId) == true);
63     SellCount += 1;
64     require(SellCount<=captainCount);
65 
66     // Safety check to prevent against an unexpected 0x0 default.
67     require(msg.sender != address(0));
68     
69     // Making sure sent amount is greater than or equal to the sellingPrice
70     require(msg.value >= price);
71     captains.CreateCaptainToken(msg.sender,price,_captainId,color,atk, defense,1,0);
72     captainToCount[_captainId] = SellCount;
73 
74     //transfer
75     devAddress.transfer(msg.value);
76     //event 
77     BuyToken(_captainId, price,address(this),msg.sender);
78   }
79 
80   function getCaptainCount(uint32 _captainId) external constant returns (uint256) {
81     return captainToCount[_captainId];
82   }
83 
84   //@notice withraw all by dev
85   function withdraw() external onlyOwner {
86     require(this.balance>0);
87     msg.sender.transfer(this.balance);
88   }
89 
90 }