1 pragma solidity ^0.4.24;
2 
3     contract DAO {
4         function balanceOf(address addr) public returns (uint);
5     }
6     
7     interface RegisterInterface {
8         function register(string);
9     }
10     
11 // auth
12 contract Auth {
13     address      public  owner;
14     constructor () public {
15          owner = msg.sender;
16     }
17     
18     modifier auth {
19         require(isAuthorized(msg.sender) == true);
20         _;
21     }
22     
23     function isAuthorized(address src) internal view returns (bool) {
24         if(src == owner){
25             return true;
26         } else {
27             return false;
28         }
29     }
30 }
31 
32 contract TokenTimelock is Auth{
33     
34     constructor() public {
35         benificiary = msg.sender;
36     }
37     
38     uint constant public days_of_month = 30;
39     
40     uint[] public dateArray;
41     uint public release_percent = 0;
42     
43     mapping (uint => bool) public release_map;
44     uint256 public totalFutureRelease = 0;
45     
46     // cosToken address, 
47     address constant public contract_addr = 0x589891a198195061cb8ad1a75357a3b7dbadd7bc;
48     address public benificiary;
49     uint     public  startTime; 
50     bool public lockStart = false;
51     
52     // set total cos to lock
53     function set_total(uint256 total) auth public {
54         require(lockStart == false);
55         totalFutureRelease = total;
56     }
57     
58     // set month to release
59     function set_lock_info(int startMonth,int periods,int percent,int gap) auth public {
60         require(lockStart == false);
61         require(startMonth > 0);
62         require(periods > 0);
63         require(percent > 0);
64         require(gap > 0);
65         require(periods * percent == 100);
66         release_percent = uint(percent);
67         uint tmp = uint(startMonth);
68         delete dateArray;
69         for (int i = 0; i < periods; i++) {
70              dateArray.push(tmp * days_of_month);
71              tmp += uint(gap);
72         }
73     }
74 
75     // when transfer certain balance to this contract address, we can call lock
76     function lock(int offsetMinutes) auth public returns(bool) {
77         require(lockStart == false);
78         require(offsetMinutes >= 0);
79         for(uint i = 0; i < dateArray.length; i++) {
80             require(dateArray[i] != 0);
81         }
82         require(release_percent != 0);
83         require(totalFutureRelease != 0);
84         
85         DAO cosTokenApi = DAO(contract_addr);
86         uint256 balance = cosTokenApi.balanceOf(address(this));
87         require(balance == totalFutureRelease);
88         
89         startTime = block.timestamp + uint(offsetMinutes) * 1 minutes;
90         lockStart = true;
91     }
92     
93     function set_benificiary(address b) auth public {
94         benificiary = b;
95     }
96     
97     function release_specific(uint i) private {
98         if (release_map[i] == true) {
99             emit mapCheck(true,i);
100             return;
101         }
102         emit mapCheck(false,i);
103         
104         DAO cosTokenApi = DAO(contract_addr);
105         uint256 balance = cosTokenApi.balanceOf(address(this));
106         uint256 eachRelease = 0;
107         eachRelease = (totalFutureRelease / 100) * release_percent;
108         
109         bool ok = balance >= eachRelease; 
110         emit balanceCheck(ok,balance);
111         require(balance >= eachRelease);
112   
113         bool success = contract_addr.call(bytes4(keccak256("transfer(address,uint256)")),benificiary,eachRelease);
114         emit tokenTransfer(success);
115         require(success);
116         release_map[i] = true;
117     }
118     
119     event mapCheck(bool ok,uint window);
120     event balanceCheck(bool ok,uint256 balance);
121     event tokenTransfer(bool success);
122 
123     function release() auth public {
124         require(lockStart == true);
125         require(release_map[dateArray[dateArray.length-1]] == false);
126         uint theDay = dayFor();
127         
128         for (uint i=0; i<dateArray.length;i++) {
129             if(theDay > dateArray[i]) {
130                 release_specific(dateArray[i]);
131             }
132         }
133     }
134     
135         // days after lock
136     function dayFor() view public returns (uint) {
137         uint timestamp = block.timestamp;
138         return timestamp < startTime ? 0 : (timestamp - startTime) / 1 days + 1;
139     }
140     
141     function regist(string key) auth public {
142         RegisterInterface(contract_addr).register(key);
143     }
144 }