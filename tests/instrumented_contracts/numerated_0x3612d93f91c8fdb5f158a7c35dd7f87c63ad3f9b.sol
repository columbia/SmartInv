1 pragma solidity ^0.4.7;
2 contract MobaBase {
3     address public owner = 0x0;
4     bool public isLock = false;
5     constructor ()  public  {
6         owner = msg.sender;
7     }
8     
9     event transferToOwnerEvent(uint256 price);
10     
11     modifier onlyOwner {
12         require(msg.sender == owner,"only owner can call this function");
13         _;
14     }
15     
16     modifier notLock {
17         require(isLock == false,"contract current is lock status");
18         _;
19     }
20     
21     modifier msgSendFilter() {
22         address addr = msg.sender;
23         uint size;
24         assembly { size := extcodesize(addr) }
25         require(size <= 0,"address must is not contract");
26         require(msg.sender == tx.origin, "msg.sender must equipt tx.origin");
27         _;
28     }
29     
30     function transferOwnership(address newOwner) onlyOwner public {
31         if (newOwner != address(0)) {
32             owner = newOwner;
33         }
34     }
35     
36     function transferToOwner()    
37     onlyOwner 
38     msgSendFilter 
39     public {
40         uint256 totalBalace = address(this).balance;
41         owner.transfer(totalBalace);
42         emit transferToOwnerEvent(totalBalace);
43     }
44     
45     function updateLock(bool b) onlyOwner public {
46         
47         require(isLock != b," updateLock new status == old status");
48         isLock = b;
49     }
50     
51    
52 }
53 
54 contract IBRInviteData {
55     function GetAddressByName(bytes32 name) public view returns (address);
56 }
57 contract IBRPerSellData {
58    function GetPerSellInfo(uint16 id) public view returns (uint16,uint256 price,bool isOver);
59 }
60 
61 contract BRPerSellControl is MobaBase {
62     
63     IBRInviteData public mInviteAddr;
64     IBRPerSellData public mPerSellData;
65     mapping (address => uint16[]) public mBuyList;
66 
67     event updateIntefaceEvent();
68     event transferToOwnerEvent(uint256 price);
69     event buyPerSellEvent(uint16 perSellId,bytes32 name,uint256 price);
70     constructor(address inviteData, address perSellData) public {
71         mInviteAddr  = IBRInviteData(inviteData);
72         mPerSellData = IBRPerSellData(perSellData);
73     }
74     
75     function updateInteface(address inviteData, address perSellData) 
76     onlyOwner 
77     msgSendFilter 
78     public {
79         mInviteAddr  = IBRInviteData(inviteData);
80         mPerSellData = IBRPerSellData(perSellData);
81         emit updateIntefaceEvent();
82     }
83     
84     function GetPerSellInfo(uint16 id) public view returns (uint16 pesellId,uint256 price,bool isOver) {
85         return mPerSellData.GetPerSellInfo(id);
86     }
87     
88     function buyPerSell(uint16 perSellId,bytes32 name) 
89     notLock
90     msgSendFilter 
91     payable public {
92         uint16 id; uint256 price; bool isOver;
93         (id,price,isOver) = mPerSellData.GetPerSellInfo(perSellId);
94         require(id == perSellId && id > 0,"perSell.Id is error"  );
95         require(msg.value == price,"msg.value is error");
96         require(isOver == false,"persell is over status");
97         
98         address inviteAddr = mInviteAddr.GetAddressByName(name);
99         if(inviteAddr != address(0)) {
100            uint giveToEth   = msg.value * 10 / 100;
101            inviteAddr.transfer(giveToEth);
102         }
103         mBuyList[msg.sender].push(id);
104         emit buyPerSellEvent(perSellId,name,price);
105     }
106     
107     function getBuyInfo(address addr) public view returns (uint16[]){
108         return mBuyList[addr];
109     }
110     
111 
112 }