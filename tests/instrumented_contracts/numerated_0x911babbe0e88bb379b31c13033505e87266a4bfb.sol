1 pragma solidity ^0.4.7;
2 contract MobaBase {
3     address public owner = 0x0;
4     bool public isLock = false;
5     constructor ()  public  {
6         owner = msg.sender;
7     }
8     
9     modifier onlyOwner {
10         require(msg.sender == owner,"only owner can call this function");
11         _;
12     }
13     
14     modifier notLock {
15         require(isLock == false,"contract current is lock status");
16         _;
17     }
18     
19     modifier msgSendFilter() {
20         address addr = msg.sender;
21         uint size;
22         assembly { size := extcodesize(addr) }
23         require(size <= 0,"address must is not contract");
24         require(msg.sender == tx.origin, "msg.sender must equipt tx.origin");
25         _;
26     }
27     
28     function transferOwnership(address newOwner) onlyOwner public {
29         if (newOwner != address(0)) {
30             owner = newOwner;
31         }
32     }
33     
34     function updateLock(bool b) onlyOwner public {
35         
36         require(isLock != b," updateLock new status == old status");
37         isLock = b;
38     }
39 }
40 
41 contract IBRInviteData {
42     function GetAddressByName(bytes32 name) public view returns (address);
43 }
44 contract IBRPerSellData {
45    function GetPerSellInfo(uint16 id) public view returns (uint16,uint256 price,bool isOver);
46 }
47 
48 contract BRPerSellControl is MobaBase {
49     
50     IBRInviteData mInviteAddr;
51     IBRPerSellData mPerSellData;
52     mapping (address => uint16[]) public mBuyList;
53 
54     event updateIntefaceEvent();
55     event transferToOwnerEvent(uint256 price);
56     event buyPerSellEvent(uint16 perSellId,bytes32 name,uint256 price);
57     constructor(address inviteData, address perSellData) public {
58         mInviteAddr  = IBRInviteData(inviteData);
59         mPerSellData = IBRPerSellData(perSellData);
60     }
61     
62     function updateInteface(address inviteData, address perSellData) 
63     onlyOwner 
64     msgSendFilter 
65     public {
66         mInviteAddr  = IBRInviteData(inviteData);
67         mPerSellData = IBRPerSellData(perSellData);
68         emit updateIntefaceEvent();
69     }
70     
71     function transferToOwner()    
72     onlyOwner 
73     msgSendFilter 
74     public {
75         uint256 totalBalace = address(this).balance;
76         owner.transfer(totalBalace);
77         emit transferToOwnerEvent(totalBalace);
78     }
79     
80    function GetPerSellInfo(uint16 id) public view returns (uint16 pesellId,uint256 price,bool isOver) {
81         return mPerSellData.GetPerSellInfo(id);
82     }
83     
84     function buyPerSell(uint16 perSellId,bytes32 name) 
85     notLock
86     msgSendFilter 
87     payable public {
88         uint16 id; uint256 price; bool isOver;
89         (id,price,isOver) = mPerSellData.GetPerSellInfo(perSellId);
90         require(id == perSellId && id > 0,"perSell.Id is error"  );
91         require(msg.value == price,"msg.value is error");
92         require(isOver == false,"persell is over status");
93         
94         address inviteAddr = mInviteAddr.GetAddressByName(name);
95         if(inviteAddr != address(0)) {
96            uint giveToEth   = msg.value * 10 / 100;
97            inviteAddr.transfer(giveToEth);
98         }
99         mBuyList[msg.sender].push(id);
100         emit buyPerSellEvent(perSellId,name,price);
101     }
102     
103 
104 }