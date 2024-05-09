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
36     function updateLock(bool b) onlyOwner public {
37         
38         require(isLock != b," updateLock new status == old status");
39         isLock = b;
40     }
41     
42     function transferToOwner()    
43     onlyOwner 
44     msgSendFilter 
45     public {
46         uint256 totalBalace = address(this).balance;
47         owner.transfer(totalBalace);
48         emit transferToOwnerEvent(totalBalace);
49     }
50 }
51 
52 contract IOldInviteData{
53     
54     function checkUp(address addr,bytes32 name) public view returns (uint8);
55     function GetAddressByName(bytes32 name) public view returns (address);
56     function m_addrToName(address addr) public view returns (bytes32 name);
57         
58 }
59 contract BRMobaInviteData is MobaBase {
60    
61     address owner = 0x0;
62     uint256 price = 10 finney;
63     mapping(bytes32 => address) public m_nameToAddr;
64     mapping(address => bytes32) public m_addrToName;
65     IOldInviteData public oldInviteAddr;
66     
67     constructor(IOldInviteData oldAddr) public {
68         oldInviteAddr = IOldInviteData(oldAddr);
69     }
70     event createInviteNameEvent(address addr,bytes32 name);
71     
72     function createInviteName(bytes32 name) 
73     notLock 
74     msgSendFilter
75     public payable {
76         require(msg.value == price);
77         require(checkUp(msg.sender,name) == 0,"current name has been used or current address has been one name"); 
78         m_nameToAddr[name] = msg.sender;
79         m_addrToName[msg.sender] = name;
80         emit createInviteNameEvent(msg.sender,name);
81     }
82     
83     function checkUp(address addr,bytes32 name) public view returns (uint8) {
84         if(m_nameToAddr[name] != address(0)) {
85             return 1;
86         }
87         if ( m_addrToName[addr] != 0){
88             return 2;
89         }
90         uint8  oldResult = oldInviteAddr.checkUp(addr,name);
91         if(oldResult != 0) {
92              return oldResult;
93         }
94         return 0;
95     }
96     
97     function GetAddressByName(bytes32 name) public view returns (address){
98         address oldAddr =  oldInviteAddr.GetAddressByName(name);
99         if(oldAddr != address(0)) {
100             return oldAddr;
101         }
102         return m_nameToAddr[name];
103     }
104     
105      function GetNameByAddr(address addr) public view returns (bytes32 name){
106         bytes32 oldName =  oldInviteAddr.m_addrToName(addr);
107         if(oldName != 0) {
108             return oldName;
109         }
110         return m_addrToName[addr];
111     }
112 }