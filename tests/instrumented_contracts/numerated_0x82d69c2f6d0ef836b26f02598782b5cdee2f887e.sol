1 pragma solidity ^0.4.24;
2 contract BREBuy {
3     
4     struct ContractParam {
5         uint32  totalSize ; 
6         uint256 singlePrice;
7         uint8  pumpRate;
8         bool hasChange;
9     }
10     
11     address owner = 0x0;
12     uint32  gameIndex = 0;
13     uint256 totalPrice= 0;
14     bool isLock = false;
15     ContractParam public setConfig;
16     ContractParam public curConfig;
17     
18     address[] public addressArray = new address[](0);
19                     
20     event openLockEvent();
21     event addPlayerEvent(uint32 gameIndex,address player);
22     event gameOverEvent(uint32 gameIndex,uint32 totalSize,uint256 singlePrice,uint8 pumpRate,address winAddr,uint overTime);
23     event stopGameEvent(uint totalBalace,uint totalSize,uint price);
24           
25     /* Initializes contract with initial supply tokens to the creator of the contract */
26     constructor ( uint32 _totalSize,
27                   uint256 _singlePrice
28     )  public  {
29         owner = msg.sender;
30         setConfig = ContractParam(_totalSize,_singlePrice * 1 finney ,5,false);
31         curConfig = ContractParam(_totalSize,_singlePrice * 1 finney ,5,false);
32         startNewGame();
33     }
34 
35     modifier onlyOwner {
36         require(msg.sender == owner,"only owner can call this function");
37         _;
38     }
39     
40      modifier notLock {
41         require(isLock == false,"contract current is lock status");
42         _;
43     }
44     
45     function isNotContract(address addr) private view returns (bool) {
46         uint size;
47         assembly { size := extcodesize(addr) }
48         return size <= 0;
49     }
50 
51     function updateLock(bool b) onlyOwner public {
52         
53         require(isLock != b," updateLock new status == old status");
54        
55         isLock = b;
56        
57         if(isLock) {
58             stopGame();
59         }else{
60             startNewGame();
61             emit openLockEvent();
62         }
63     }
64     
65     function stopGame() onlyOwner private {
66       
67       if(addressArray.length <= 0) {
68           return;
69       }  
70       uint totalBalace = address(this).balance;
71       uint price = totalBalace / addressArray.length;
72       for(uint i = 0; i < addressArray.length; i++) {
73           address curPlayer =  addressArray[i];
74           curPlayer.transfer(price);
75       }
76       emit stopGameEvent(totalBalace,addressArray.length,price);
77       addressArray.length=0;
78     }
79 
80     function transferOwnership(address newOwner) onlyOwner public {
81         if (newOwner != address(0)) {
82             owner = newOwner;
83         }
84     }
85     
86     function changeConfig( uint32 _totalSize,uint256 _singlePrice,uint8 _pumpRate) onlyOwner public payable {
87     
88         curConfig.hasChange = true;
89         if(setConfig.totalSize != _totalSize) {
90             setConfig.totalSize = _totalSize;
91         }
92         if(setConfig.pumpRate  != _pumpRate){
93             setConfig.pumpRate  = _pumpRate;
94         }
95         if(setConfig.singlePrice != _singlePrice * 1 finney){
96             setConfig.singlePrice = _singlePrice * 1 finney;
97         }
98     }
99     
100     function startNewGame() private {
101         
102         gameIndex++;
103         if(curConfig.hasChange) {
104             if(curConfig.totalSize   != setConfig.totalSize) {
105                 curConfig.totalSize   = setConfig.totalSize;
106             }
107             if(curConfig.singlePrice != setConfig.singlePrice){
108                curConfig.singlePrice = setConfig.singlePrice; 
109             }
110             if( curConfig.pumpRate    != setConfig.pumpRate) {
111                 curConfig.pumpRate    = setConfig.pumpRate;
112             }
113             curConfig.hasChange = false;
114         }
115         addressArray.length=0;
116     }
117     
118     
119     function addPlayer() notLock public payable {
120         
121         require(isNotContract(msg.sender),"Contract not call addPlayer");
122         require(msg.value == curConfig.singlePrice,"msg.value error");
123         totalPrice = totalPrice + msg.value;
124         addressArray.push(msg.sender);
125        
126         emit addPlayerEvent(gameIndex,msg.sender);
127         if(addressArray.length >= curConfig.totalSize) {
128             gameResult();
129             startNewGame();
130         }
131     }
132     
133     function getGameInfo() public view returns  (uint256,uint32,uint256,uint8,address[],uint256,bool)  {
134         return (gameIndex,
135                 curConfig.totalSize,
136                 curConfig.singlePrice,
137                 curConfig.pumpRate,
138                 addressArray,
139                 totalPrice,
140                 isLock);
141     }
142     
143     function gameResult() private {
144             
145       uint index  = getRamdon();
146       address lastAddress = addressArray[index];
147       uint totalBalace = address(this).balance;
148       uint giveToOwn   = totalBalace * curConfig.pumpRate / 100;
149       uint giveToActor = totalBalace - giveToOwn;
150       owner.transfer(giveToOwn);
151       lastAddress.transfer(giveToActor);
152       emit gameOverEvent(
153                     gameIndex,
154                     curConfig.totalSize,
155                     curConfig.singlePrice,
156                     curConfig.pumpRate,
157                     lastAddress,
158                     now);
159     }
160     
161     function getRamdon() private view returns (uint) {
162       bytes32 ramdon = keccak256(abi.encodePacked(ramdon,now,blockhash(block.number-1)));
163       for(uint i = 0; i < addressArray.length; i++) {
164             ramdon = keccak256(abi.encodePacked(ramdon,now, addressArray[i]));
165       }
166       uint index  = uint(ramdon) % addressArray.length;
167       return index;
168     }
169 }