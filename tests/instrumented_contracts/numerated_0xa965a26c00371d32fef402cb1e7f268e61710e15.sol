1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 
46 contract DateTime {
47        
48                struct _DateTime {
49                 uint16 year;
50                 uint8 month;
51                 uint8 day;
52                 }
53 
54    
55 
56         uint constant DAY_IN_SECONDS = 86400;
57         uint constant YEAR_IN_SECONDS = 31536000;
58         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
59         uint16 constant ORIGIN_YEAR = 1970;
60         uint constant GMT_TO_LOCAL = 19800;
61          
62            function toTimestamp(uint16 year, uint8 month, uint8 day) public returns (uint timestamp) {
63                 uint16 i;
64 
65                 // Year
66                 for (i = ORIGIN_YEAR; i < year; i++) {
67                         if (isLeapYear(i)) {
68                                 timestamp += LEAP_YEAR_IN_SECONDS;
69                         }
70                         else {
71                                 timestamp += YEAR_IN_SECONDS;
72                         }
73                 }
74 
75                 // Month
76                 uint8[12] memory monthDayCounts;
77                 monthDayCounts[0] = 31;
78                 if (isLeapYear(year)) {
79                         monthDayCounts[1] = 29;
80                 }
81                 else {
82                         monthDayCounts[1] = 28;
83                 }
84                 monthDayCounts[2] = 31;
85                 monthDayCounts[3] = 30;
86                 monthDayCounts[4] = 31;
87                 monthDayCounts[5] = 30;
88                 monthDayCounts[6] = 31;
89                 monthDayCounts[7] = 31;
90                 monthDayCounts[8] = 30;
91                 monthDayCounts[9] = 31;
92                 monthDayCounts[10] = 30;
93                 monthDayCounts[11] = 31;
94 
95                 for (i = 1; i < month; i++) {
96                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
97                 }
98 
99                 // Day
100                 timestamp += DAY_IN_SECONDS * (day - 1);
101                 timestamp-=GMT_TO_LOCAL;
102                 
103                 return timestamp;
104         }
105         function isLeapYear(uint16 year) public pure returns (bool) {
106                 if (year % 4 != 0) {
107                         return false;
108                 }
109                 if (year % 100 != 0) {
110                         return true;
111                 }
112                 if (year % 400 != 0) {
113                         return false;
114                 }
115                 return true;
116         }
117 }
118 
119 
120 
121 contract ApcrdaZebichain is Ownable{
122     mapping (uint256 =>string ) event_details; // timestamp to hash
123      DateTime public dt;
124     function ApcrdaZebichain() public{
125      }
126  
127      function viewMerkleHash(uint16 year, uint8 month, uint8 day)  public view returns(string hash)
128      {
129          uint  time = dt.toTimestamp(year,month,day);
130          hash= event_details[time];
131      }
132      
133      function insertHash(uint16 year, uint8 month, uint8 day, string hash) onlyOwner public{
134              dt = new DateTime();
135              uint  t = dt.toTimestamp(year,month,day);
136              event_details[t]=hash;
137          
138        }
139 
140 
141   }