1 pragma solidity ^0.4.24;
2 contract BREBuy {
3     
4 
5     struct ContractParam {
6         uint32  totalSize ; 
7         uint256 singlePrice;  // 一个eth '
8         uint8  pumpRate;
9         bool hasChange;
10     }
11     
12     address owner = 0x0;
13     uint32  gameIndex = 0;
14     uint256 totalPrice= 0;
15     ContractParam public setConfig;
16     ContractParam public curConfig;
17     
18     address[] public addressArray = new address[](0);
19     
20     
21    event  addPlayerEvent(uint32,address);
22     event GameOverEvent(uint32,uint32,uint256,uint8,address,uint );
23     
24     /* Initializes contract with initial supply tokens to the creator of the contract */
25     constructor ( uint32 _totalSize,
26                   uint256 _singlePrice
27     )  public payable  {
28         owner = msg.sender;
29         setConfig = ContractParam(_totalSize,_singlePrice * 1 finney ,5,false);
30         curConfig = ContractParam(_totalSize,_singlePrice * 1 finney ,5,false);
31         startNewGame();
32     }
33 
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address newOwner) onlyOwner public {
40         if (newOwner != address(0)) {
41             owner = newOwner;
42         }
43     }
44     
45     function changeConfig( uint32 _totalSize,uint256 _singlePrice,uint8 _pumpRate) onlyOwner public payable {
46     
47         curConfig.hasChange = true;
48         if(setConfig.totalSize != _totalSize) {
49             setConfig.totalSize = _totalSize;
50         }
51         if(setConfig.pumpRate  != _pumpRate){
52             setConfig.pumpRate  = _pumpRate;
53         }
54         if(setConfig.singlePrice != _singlePrice * 1 finney){
55             setConfig.singlePrice = _singlePrice * 1 finney;
56         }
57     }
58     
59     function startNewGame() private {
60         
61         gameIndex++;
62         if(curConfig.hasChange) {
63             if(curConfig.totalSize   != setConfig.totalSize) {
64                 curConfig.totalSize   = setConfig.totalSize;
65             }
66             if(curConfig.singlePrice != setConfig.singlePrice){
67                curConfig.singlePrice = setConfig.singlePrice; 
68             }
69             if( curConfig.pumpRate    != setConfig.pumpRate) {
70                 curConfig.pumpRate    = setConfig.pumpRate;
71             }
72             curConfig.hasChange = false;
73         }
74         addressArray.length=0;
75     }
76     
77     
78     function addPlayer() public payable {
79       
80         require(msg.value == curConfig.singlePrice);
81         totalPrice = totalPrice + msg.value;
82         addressArray.push(msg.sender);
83        
84         emit addPlayerEvent(gameIndex,msg.sender);
85         if(addressArray.length >= curConfig.totalSize) {
86             gameResult();
87             startNewGame();
88         }
89     }
90     
91     function getGameInfo() public view returns  (uint256,uint32,uint256,uint8,address[],uint256)  {
92         return (gameIndex,
93                 curConfig.totalSize,
94                 curConfig.singlePrice,
95                 curConfig.pumpRate,
96                 addressArray,
97                 totalPrice);
98     }
99     
100     function getSelfCount() private view returns (uint32) {
101         uint32 count = 0;
102         for(uint i = 0; i < addressArray.length; i++) {
103             if(msg.sender == addressArray[i]) {
104                 count++;
105             }
106         }
107         return count;
108     }
109     
110     function gameResult() private {
111             
112       uint index  = getRamdon();
113       address lastAddress = addressArray[index];
114       uint totalBalace = address(this).balance;
115       uint giveToOwn   = totalBalace * curConfig.pumpRate / 100;
116       uint giveToActor = totalBalace - giveToOwn;
117       owner.transfer(giveToOwn);
118       lastAddress.transfer(giveToActor);
119       emit GameOverEvent(
120                     gameIndex,
121                     curConfig.totalSize,
122                     curConfig.singlePrice,
123                     curConfig.pumpRate,
124                     lastAddress,
125                     now);
126     }
127     
128     function getRamdon() private view returns (uint) {
129       bytes32 ramdon = keccak256(abi.encodePacked(ramdon,now,blockhash(block.number-1)));
130       for(uint i = 0; i < addressArray.length; i++) {
131             ramdon = keccak256(abi.encodePacked(ramdon,now, addressArray[i]));
132       }
133       uint index  = uint(ramdon) % addressArray.length;
134       return index;
135     }
136 }