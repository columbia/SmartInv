1 pragma solidity ^0.4.11;
2 
3 // copyright contact@bytether.com
4 
5 contract BytetherOV {
6     enum ResultCode { 
7         SUCCESS,
8         ERROR_EXIST,
9         ERROR_NOT_EXIST
10     }
11     struct OwnerShip {
12         address myEther;
13         uint verifyCode;
14         string referCode;
15         uint createTime;
16     }
17     
18     address public owner;
19     address[] public moderators;
20     uint public total = 0;
21     bool public maintaining = false;
22     
23     // bitcoin_address -> OwnerShip list
24     mapping(string => OwnerShip[]) items;
25 
26     // modifier
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31     
32     modifier isActive {
33         require(maintaining != true);
34         _;
35     }
36 
37     modifier onlyModerators() {
38         if (msg.sender != owner) {
39             bool found = false;
40             for (uint index = 0; index < moderators.length; index++) {
41                 if (moderators[index] == msg.sender) {
42                     found = true;
43                     break;
44                 }
45             }
46             require(found);
47         }
48         _;
49     }
50 
51     function BytetherOV() public {
52         owner = msg.sender;
53     }
54 
55     // event
56     event LogCreate(bytes32 indexed btcAddress, uint verifyCode, ResultCode result);
57     
58     // owner function
59     function ChangeOwner(address _newOwner) onlyOwner public {
60         if (_newOwner != address(0)) {
61             owner = _newOwner;
62         }
63     }
64     
65     function Kill() onlyOwner public {
66         selfdestruct(owner);
67     }
68     
69     function ToggleMaintenance() onlyModerators public {
70         maintaining = !maintaining;
71     }
72     
73     function AddModerator(address _newModerator) onlyOwner public {
74         for (uint index = 0; index < moderators.length; index++) {
75             if (moderators[index] == _newModerator) {
76                 return;
77             }
78         }
79         moderators.push(_newModerator);
80     }
81     
82     function RemoveModerator(address _oldModerator) onlyOwner public {
83         uint foundIndex = 0;
84         for (; foundIndex < moderators.length; foundIndex++) {
85             if (moderators[foundIndex] == _oldModerator) {
86                 break;
87             }
88         }
89         if (foundIndex < moderators.length) {
90             moderators[foundIndex] = moderators[moderators.length-1];
91             delete moderators[moderators.length-1];
92             moderators.length--;
93         }
94     }
95     
96     // moderator function
97     function UnclockVerification(string _btcAddress, uint _verifyCode) onlyModerators public returns(ResultCode) {
98         // remove from the verify code list
99         var array = items[_btcAddress];
100         for (uint i = 0; i<array.length; i++){
101             if (array[i].verifyCode == _verifyCode) {
102                 if (i != array.length-1) {
103                     array[i] = array[array.length-1];
104                 }
105                 delete array[array.length-1];
106                 array.length--;
107                 total--;
108                 return ResultCode.SUCCESS;
109             }
110         }
111         return ResultCode.ERROR_NOT_EXIST;
112     }
113     
114     // public function
115     function GetOwnership(string _btcAddress, uint _verifyCode) constant public returns(address, string) {
116         var array = items[_btcAddress];
117         for (uint i=0; i<array.length; i++) {
118             if (array[i].verifyCode == _verifyCode) {
119                 var item = array[i];
120                 return (item.myEther, item.referCode);
121             }
122         }
123         return (0, "");
124     }
125     
126     function AddOwnership(string _btcAddress, uint _verifyCode, string _referCode) isActive public returns(ResultCode) {
127         bytes32 btcAddressHash = keccak256(_btcAddress);
128         var array = items[_btcAddress];
129         for (uint i=0; i<array.length; i++) {
130             if (array[i].verifyCode == _verifyCode) {
131                 LogCreate(btcAddressHash, _verifyCode, ResultCode.ERROR_EXIST);
132                 return ResultCode.ERROR_EXIST;
133             }
134         }
135         OwnerShip memory item;
136         item.myEther = msg.sender;
137         item.verifyCode = _verifyCode;
138         item.referCode = _referCode;
139         item.createTime = now;
140 
141         total++;
142         array.push(item);
143         LogCreate(btcAddressHash, _verifyCode, ResultCode.SUCCESS);
144         return ResultCode.SUCCESS;
145     }
146     
147     function GetVerifyCodes(string _btcAddress) constant public returns(uint[]) {
148         var array = items[_btcAddress];
149         uint[] memory verifyCodes = new uint[](array.length);
150         for (uint i=0; i<array.length; i++) {
151             verifyCodes[i] = array[i].verifyCode;
152         }
153         return verifyCodes;
154     }
155 }