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
41 contract BRMobaInviteData is MobaBase {
42    
43     address owner = 0x0;
44     uint256 price = 10 finney;
45     mapping(bytes32 => address) public m_nameToAddr;
46     mapping(address => bytes32) public m_addrToName;
47     
48     function createInviteName(bytes32 name) 
49     notLock 
50     msgSendFilter
51     public payable {
52         require(msg.value == price);
53         require(checkUp(msg.sender,name) == 0,"current name has been used or current address has been one name"); 
54         m_nameToAddr[name] = msg.sender;
55         m_addrToName[msg.sender] = name;
56     }
57     
58     function checkUp(address addr,bytes32 name) public view returns (uint8) {
59         if(m_nameToAddr[name] != address(0)) {
60             return 1;
61         }
62         if ( m_addrToName[addr] != 0){
63             return 2;
64         }
65         return 0;
66     }
67     
68     function GetAddressByName(bytes32 name) public view returns (address){
69         return m_nameToAddr[name];
70     }
71 }