1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 
32 interface SKWInterface {
33      
34     function transfer(address _to, uint256 _value) external returns (bool success);
35 
36 }
37 
38 contract SKWVesting2 {
39     
40     using SafeMath for uint256;
41     
42     address public _beneficiary = 0x0;//受益地址
43     
44     uint256 public unLockTime_1;
45     
46     uint256 public unLockTime_2;
47     
48     uint256 public unLockTime_3;
49     
50     uint256 public unLockTime_4;
51     
52     uint256 public unLockTime_5;
53     
54     uint256 public unLockTime_6;
55     
56     uint256 public released;//释放数量 
57     
58     uint256 public totalBalance;//所有数量 
59     
60     bool public test = false;
61     
62     SKWInterface constant _token = SKWInterface(0x007ac2F589eb9d4Fe1cEA9f46B5f4f52DaB73dd4);
63     
64     event Released(uint256 amount);
65     
66     event TsetReleased(uint256 amount);
67     
68     constructor() public {
69        _beneficiary = 0xe00E02E84B6C223495e864308B6CcBB16106671a;
70        unLockTime_1 = 1543075200;//2018-11-25 00:00:00
71        unLockTime_2 = 1545667200;//2018-12-25 00:00:00
72        unLockTime_3 = 1548345600;//2019-1-25 00:00:00
73        unLockTime_4 = 1551024000;//2019-2-25 00:00:00
74        unLockTime_5 = 1553443200;//2019-3-25 00:00:00
75        unLockTime_6 = 1556121600;//2019-4-25 00:00:00
76        totalBalance = 5000000000000000;// 50000000.00000000 8个0
77        released = 0;
78     }
79     
80     function release() public {//释放
81         uint256 unreleased = releasableAmount();
82         require(unreleased > 0);
83         released = released.add(unreleased);
84         _token.transfer(_beneficiary, unreleased);
85         emit Released(unreleased);
86     }
87     
88     function releasableAmount() public view returns (uint256){
89         uint num = getUnLockNum();
90         if(num > 0 ){
91             uint256 currentBalance = totalBalance.div(6).mul(num) - released;
92             return currentBalance;
93         }else{
94             return 0;
95         }
96     }
97     
98     function getUnLockNum() public view returns (uint){
99         uint256 n = now;
100         if(n < unLockTime_1){
101             return 0;
102         }else if(n >= unLockTime_1 && n < unLockTime_2){
103             return 1;
104         }else if(n >= unLockTime_2 && n < unLockTime_3){
105             return 2;
106         }else if(n >= unLockTime_3 && n < unLockTime_4){
107             return 3;
108         }else if(n >= unLockTime_4 && n < unLockTime_5){
109             return 4;
110         }else if(n >= unLockTime_5 && n < unLockTime_6){
111             return 5;
112         }else {
113             return 6;
114         }
115     }
116     
117     function testRelease() public {//释放
118         require(!test);
119         uint256 unreleased = 1000000;
120         test = true;
121         _token.transfer(_beneficiary, unreleased);
122         emit TsetReleased(unreleased);
123     }
124     
125 }