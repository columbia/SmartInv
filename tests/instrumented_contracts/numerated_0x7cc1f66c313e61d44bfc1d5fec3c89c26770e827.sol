1 interface DividendERC20:
2     def distributeDividends(_value: uint256): nonpayable
3 
4 
5 interface ERC20:
6     def approve(_spender : address, _value : uint256) -> bool: nonpayable
7     def transfer(_to : address, _value : uint256) -> bool: nonpayable
8     def balanceOf(_owner: address) -> uint256: view
9 
10 struct FarmInfo:
11     yieldPerBlock: uint256
12     tokenContract: address
13     lastBlockUpdate: uint256
14     id: uint256
15     marketType: uint256
16 
17 event NewFarm:
18     tokenContract: address
19     marketType: uint256
20 
21 event UpdateFarm:
22     tokenContract: address
23     marketType: uint256
24 
25 event DeleteFarm:
26     tokenContract: address
27     marketType: uint256
28 
29 event Harvest:
30     tokenContract: address
31     marketType: uint256
32     yieldAmount: uint256
33 
34 ifexTokenContract: public(address)
35 owner: public(address)
36 
37 farmId: public(uint256)
38 tokenToFarmInfo: public(HashMap[address, FarmInfo])
39 idToFarmTokenAddress: public(HashMap[uint256, address])
40 
41 isInitialized: public(bool)
42 
43 @internal
44 def ownable(account: address):
45     assert account == self.owner, "Invalid permission"
46 
47 @external
48 def initialize(_ifexTokenContract: address):
49     assert self.isInitialized == False, "Already initialized"
50     self.ifexTokenContract = _ifexTokenContract
51     self.owner = msg.sender
52     self.isInitialized = True
53 
54 @external
55 def addFarm(tokenContract: address, yieldPerBlock: uint256, marketType: uint256):
56     self.ownable(msg.sender)
57     self.farmId += 1
58 
59     farmInfo: FarmInfo = empty(FarmInfo)
60     farmInfo.yieldPerBlock = yieldPerBlock
61     farmInfo.tokenContract = tokenContract
62     farmInfo.id = self.farmId
63     farmInfo.lastBlockUpdate = block.number
64     farmInfo.marketType = marketType
65 
66     self.tokenToFarmInfo[tokenContract] = farmInfo
67     self.idToFarmTokenAddress[farmInfo.id] = farmInfo.tokenContract
68 
69     ERC20(self.ifexTokenContract).approve(tokenContract, MAX_UINT256)
70     log NewFarm(tokenContract, marketType)
71 
72 @external
73 def deleteFarm(tokenContract: address):
74     self.ownable(msg.sender)
75     
76     farmToDelete: FarmInfo = self.tokenToFarmInfo[tokenContract]
77     self.tokenToFarmInfo[farmToDelete.tokenContract] = empty(FarmInfo)
78     self.idToFarmTokenAddress[farmToDelete.id] = ZERO_ADDRESS
79     log DeleteFarm(tokenContract, farmToDelete.marketType)
80 
81 @external
82 def updateFarm(tokenContract: address, yieldPerBlock: uint256):
83     self.ownable(msg.sender)
84 
85     farmToUpdate: FarmInfo = self.tokenToFarmInfo[tokenContract]
86     farmToUpdate.yieldPerBlock = yieldPerBlock
87 
88     self.tokenToFarmInfo[tokenContract] = farmToUpdate
89     self.idToFarmTokenAddress[farmToUpdate.id] = farmToUpdate.tokenContract
90     log UpdateFarm(tokenContract, farmToUpdate.marketType)
91 
92 @external
93 def harvest(tokenContract: address):
94     assert msg.sender == tx.origin
95     farmToHarvest: FarmInfo = self.tokenToFarmInfo[tokenContract]
96 
97     blockDelta: uint256 = block.number - farmToHarvest.lastBlockUpdate
98     if blockDelta > 0 and farmToHarvest.tokenContract == tokenContract:
99         yieldAmount: uint256 = farmToHarvest.yieldPerBlock * blockDelta
100         DividendERC20(farmToHarvest.tokenContract).distributeDividends(yieldAmount)
101         farmToHarvest.lastBlockUpdate = block.number
102         self.tokenToFarmInfo[farmToHarvest.tokenContract] = farmToHarvest
103         log Harvest(tokenContract, farmToHarvest.marketType, yieldAmount)
104 
105 @external
106 def withdraw():
107     self.ownable(msg.sender)
108 
109     ifexBalance: uint256 = ERC20(self.ifexTokenContract).balanceOf(self)
110     ERC20(self.ifexTokenContract).transfer(self.owner, ifexBalance)