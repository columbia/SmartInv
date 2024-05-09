1 pragma solidity ^0.4.18;
2 
3 
4 interface Whitelist {
5     function add(address _wlAddress) public;
6     function addBulk(address[] _wlAddresses) public;
7     function remove(address _wlAddresses) public;
8     function removeBulk(address[] _wlAddresses) public;
9     function getAll() public constant returns(address[]);
10     function isInList(address _checkAddress) public constant returns(bool);
11 }
12 
13 contract Administrated {
14     address public administrator;
15 
16     modifier onlyAdministrator() {
17         require(administrator == tx.origin);
18         _;
19     }
20 
21     modifier notAdministrator() {
22         require(administrator != tx.origin);
23         _;
24     }
25 
26     function setAdministrator(address _administrator)
27         internal
28     {
29         administrator = _administrator;
30     }
31 }
32 
33 contract BasicWhitelist is Whitelist, Administrated {
34     address[] public whitelist;
35 
36     //Up to 65536 users in list
37     mapping(address => uint16) public wlIndex;
38 
39 
40     function BasicWhitelist()
41         public
42     {
43         setAdministrator(tx.origin);
44     }
45 
46     //Add whitelist
47     function add(address _wlAddress)
48         public
49         onlyAdministrator
50     {
51         if ( !isInList(_wlAddress) ) {
52             wlIndex[_wlAddress] = uint16(whitelist.length);
53             whitelist.push(_wlAddress);
54         }
55     }
56 
57     //Bulk add
58     function addBulk(address[] _wlAddresses)
59         public
60         onlyAdministrator
61     {
62         require(_wlAddresses.length <= 256);
63 
64         for (uint8 i = 0; i < _wlAddresses.length; i++) {
65             add(_wlAddresses[i]);
66         }
67     }
68 
69     //Remove address from whitelist
70     function remove(address _wlAddress)
71         public
72         onlyAdministrator
73     {
74         if ( isInList(_wlAddress) ) {
75             uint16 index = wlIndex[_wlAddress];
76             wlIndex[_wlAddress] = 0;
77 
78             for ( uint16 i = index; i < ( whitelist.length - 1 ); i++) {
79                 whitelist[i] = whitelist[i + 1];
80             }
81 
82             delete whitelist[whitelist.length - 1];
83             whitelist.length--;
84         }
85     }
86 
87     //Bulk remove
88     function removeBulk(address[] _wlAddresses)
89         public
90         onlyAdministrator
91     {
92         require(_wlAddresses.length <= 256);
93 
94         for (uint8 i = 0; i < _wlAddresses.length; i++) {
95             remove(_wlAddresses[i]);
96         }
97     }
98 
99     //Get list
100     function getAll()
101         public
102         constant
103         returns(address[])
104     {
105         return whitelist;
106     }
107 
108     //
109     function isInList(address _checkAddress)
110         public
111         constant
112         returns(bool)
113     {
114         return whitelist.length > 0
115                 && (
116                     wlIndex[_checkAddress] > 0
117                     || whitelist[wlIndex[_checkAddress]] == _checkAddress
118                    );
119     }
120 }
121 
122 
123 contract UNITPaymentGatewayList is BasicWhitelist {
124     function UNITPaymentGatewayList()
125         public
126     {
127         setAdministrator(tx.origin);
128     }
129 }