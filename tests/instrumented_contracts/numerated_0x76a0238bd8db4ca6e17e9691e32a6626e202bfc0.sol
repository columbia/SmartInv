1 pragma solidity ^0.4.16;
2 
3 // copyright contact@bytether.com
4 
5 contract BasicAccessControl {
6     address public owner;
7     address[] public moderators;
8 
9     function BasicAccessControl() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     modifier onlyModerators() {
19         if (msg.sender != owner) {
20             bool found = false;
21             for (uint index = 0; index < moderators.length; index++) {
22                 if (moderators[index] == msg.sender) {
23                     found = true;
24                     break;
25                 }
26             }
27             require(found);
28         }
29         _;
30     }
31 
32     function ChangeOwner(address _newOwner) onlyOwner public {
33         if (_newOwner != address(0)) {
34             owner = _newOwner;
35         }
36     }
37 
38     function Kill() onlyOwner public {
39         selfdestruct(owner);
40     }
41 
42     function AddModerator(address _newModerator) onlyOwner public {
43         if (_newModerator != address(0)) {
44             for (uint index = 0; index < moderators.length; index++) {
45                 if (moderators[index] == _newModerator) {
46                     return;
47                 }
48             }
49             moderators.push(_newModerator);
50         }
51     }
52     
53     function RemoveModerator(address _oldModerator) onlyOwner public {
54         uint foundIndex = 0;
55         for (; foundIndex < moderators.length; foundIndex++) {
56             if (moderators[foundIndex] == _oldModerator) {
57                 break;
58             }
59         }
60         if (foundIndex < moderators.length) {
61             moderators[foundIndex] = moderators[moderators.length-1];
62             delete moderators[moderators.length-1];
63             moderators.length--;
64         }
65     }
66 }
67 
68 contract BytetherOV is BasicAccessControl{
69     enum ResultCode { 
70         SUCCESS,
71         ERROR_EXIST,
72         ERROR_NOT_EXIST,
73         ERROR_PARAM
74     }
75 
76     struct OwnerShip {
77         address myEther;
78         uint verifyCode;
79         string referCode;
80         uint createTime;
81     }
82     
83     uint public total = 0;
84     bool public maintaining = false;
85     
86     // bitcoin_address -> OwnerShip list
87     mapping(string => OwnerShip[]) items;
88     
89     modifier isActive {
90         require(maintaining != true);
91         _;
92     }
93 
94     function BytetherOV() public {
95         owner = msg.sender;
96     }
97 
98     function () payable public {}
99 
100     // event
101     event LogCreate(bytes32 indexed btcAddress, uint verifyCode, ResultCode result);
102     
103     // moderators function
104     function ToggleMaintenance() onlyModerators public {
105         maintaining = !maintaining;
106     }
107     
108     function UnclockVerification(string _btcAddress, uint _verifyCode) onlyModerators public returns(ResultCode) {
109         // remove from the verify code list
110         var array = items[_btcAddress];
111         for (uint i = 0; i<array.length; i++){
112             if (array[i].verifyCode == _verifyCode) {
113                 if (i != array.length-1) {
114                     array[i] = array[array.length-1];
115                 }
116                 delete array[array.length-1];
117                 array.length--;
118                 total--;
119                 return ResultCode.SUCCESS;
120             }
121         }
122         return ResultCode.ERROR_NOT_EXIST;
123     }
124     
125     // public function
126     function GetOwnership(string _btcAddress, uint _verifyCode) constant public returns(address, string) {
127         var array = items[_btcAddress];
128         for (uint i=0; i<array.length; i++) {
129             if (array[i].verifyCode == _verifyCode) {
130                 var item = array[i];
131                 return (item.myEther, item.referCode);
132             }
133         }
134         return (0, "");
135     }
136     
137     function GetOwnershipByAddress(string _btcAddress, address _etherAddress) constant public returns(uint, string) {
138         var array = items[_btcAddress];
139         for (uint i=0; i<array.length; i++) {
140             if (array[i].myEther == _etherAddress) {
141                 var item = array[i];
142                 return (item.verifyCode, item.referCode);
143             }
144         }
145         return (0, "");
146     }
147     
148     function AddOwnership(string _btcAddress, uint _verifyCode, string _referCode) isActive public returns(ResultCode) {
149         if (bytes(_btcAddress).length == 0 || _verifyCode == 0) {
150             LogCreate(0, _verifyCode, ResultCode.ERROR_PARAM);
151             return ResultCode.ERROR_PARAM;
152         }
153         
154         bytes32 btcAddressHash = keccak256(_btcAddress);
155         var array = items[_btcAddress];
156         for (uint i=0; i<array.length; i++) {
157             if (array[i].verifyCode == _verifyCode) {
158                 LogCreate(btcAddressHash, _verifyCode, ResultCode.ERROR_EXIST);
159                 return ResultCode.ERROR_EXIST;
160             }
161         }
162         OwnerShip memory item;
163         item.myEther = msg.sender;
164         item.verifyCode = _verifyCode;
165         item.referCode = _referCode;
166         item.createTime = now;
167 
168         total++;
169         array.push(item);
170         LogCreate(btcAddressHash, _verifyCode, ResultCode.SUCCESS);
171         return ResultCode.SUCCESS;
172     }
173     
174     function GetVerifyCodes(string _btcAddress) constant public returns(uint[]) {
175         var array = items[_btcAddress];
176         uint[] memory verifyCodes = new uint[](array.length);
177         for (uint i=0; i<array.length; i++) {
178             verifyCodes[i] = array[i].verifyCode;
179         }
180         return verifyCodes;
181     }
182 }