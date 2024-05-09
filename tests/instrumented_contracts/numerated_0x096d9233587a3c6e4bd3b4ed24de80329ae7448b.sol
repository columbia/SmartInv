1 pragma solidity ^0.4.16;
2 
3 
4 contract streamDesk {
5     
6         struct Deal {
7         uint256 value;
8         uint256 cancelTime;
9         string seller;
10         string buyer;
11         byte status;
12         uint256 commission;
13         string temporaryWallet;
14         }
15     
16     Deal[] public deals;
17     
18     
19     
20     byte constant public startDeal          = 0x01;
21     byte constant public coinTrasnferred    = 0x02;
22     byte constant public coinNotTrasnferred = 0x03;
23     byte constant public fiatTrasnferred    = 0x04;
24     byte constant public fiatNotTrasnferred = 0x05;
25     byte constant public coinRelease        = 0x06;
26     byte constant public coinReturn         = 0x07;
27     
28     
29     
30     event newDeal( bytes32, string, string);
31     event dealChangedStatus(bytes32, byte);
32     address public owner;
33     address public serviceAddress;
34     mapping(bytes32 => uint)  public dealsIndex;
35     
36     constructor(address _serviceAddress) {
37         owner = msg.sender;
38         serviceAddress = _serviceAddress;
39 
40     }
41     
42     byte defaultStatus = 0x01;
43     
44     function changeServiceAddress(address _serviceAddress) public {
45         require(msg.sender == owner);
46         serviceAddress = _serviceAddress;
47     }
48     
49 
50     
51     
52     function addDeal(uint _value, string _seller, string _buyer, uint _commission, bytes32 _hashDeal, string _temporaryWallet) public  {
53         require(msg.sender == serviceAddress);
54         require(dealsIndex[_hashDeal] == 0);
55         deals.push(Deal(_value,
56                         now + 7200,
57                         _seller, 
58                         _buyer,
59                         0x01,
60                         _commission,
61                         _temporaryWallet
62                         )
63                     );
64         dealsIndex[_hashDeal] = deals.length;
65         emit newDeal(_hashDeal, _buyer, _seller);
66     }
67     
68 
69 
70     function changeStatus(byte _newStatus, bytes32 _hashDeal ) public {
71         require(msg.sender == serviceAddress);
72 
73   
74         if(deals[dealsIndex[_hashDeal] - 1].status == 0x01) {
75             require(_newStatus == 0x02 || _newStatus == 0x03);
76         }
77         else if(deals[dealsIndex[_hashDeal] - 1].status == 0x02) {
78             require(_newStatus == 0x04 || _newStatus == 0x05);
79         }
80         else if(deals[dealsIndex[_hashDeal] - 1].status == 0x04) {
81             require(_newStatus == 0x06);
82         }
83         else if(deals[dealsIndex[_hashDeal] - 1].status == 0x05) {
84             require(_newStatus == 0x07);
85         }
86         
87          emit dealChangedStatus(
88                                _hashDeal, 
89                                _newStatus);
90                                
91         if(_newStatus == 0x03 || _newStatus == 0x06 || _newStatus == 0x07) {
92             delete deals[dealsIndex[_hashDeal] -1];
93             dealsIndex[_hashDeal] = 0;
94         }
95         else {
96             deals[dealsIndex[_hashDeal] - 1].status = _newStatus;
97         }
98     }
99     
100     function getDealData(bytes32 _hashDeal) public view returns(uint256, uint256,string,string, byte, uint256,  string) {
101         uint  dealIndex = dealsIndex[_hashDeal] - 1;
102         return (deals[dealIndex].value, 
103                 deals[dealIndex].cancelTime,
104                 deals[dealIndex].seller,
105                 deals[dealIndex].buyer,
106                 deals[dealIndex].status,
107                 deals[dealIndex].commission,
108                 deals[dealIndex].temporaryWallet);
109     }
110 }