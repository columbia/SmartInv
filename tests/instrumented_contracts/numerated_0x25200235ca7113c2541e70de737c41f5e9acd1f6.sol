1 pragma solidity ^0.4.25;
2 
3 contract Ownable {
4   address public owner;
5 
6   constructor() public {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14 }
15 
16 contract Role is Ownable {
17 
18     struct AdminGroup {
19         mapping (address => bool) administers;
20         mapping (address => uint) administerListIndex;
21         address[] administerList;
22         mapping (address => bool) pausers;
23         mapping (address => uint) pauserListIndex;
24         address[] pauserList;
25     }
26 
27     AdminGroup private adminGroup;
28 
29     modifier administerAndAbove() {
30         require(isAdminister(msg.sender) || msg.sender == owner);
31         _;
32     }
33 
34     modifier pauserAndAbove() {
35         require(isPauser(msg.sender) || isAdminister(msg.sender) || msg.sender == owner);
36         _;
37     }
38 
39     function isAdminister(address account) public view returns (bool) {
40         return adminGroup.administers[account];
41     }
42 
43     function addAdminister(address account) public onlyOwner {
44         require(!isAdminister(account));
45         require(!isPauser(account));
46         if (account == owner) { revert(); }
47         adminGroup.administers[account] = true;
48         adminGroup.administerListIndex[account] = adminGroup.administerList.push(account)-1;
49         emit AdministerAdded(account);
50     }
51 
52     function removeAdminister(address account) public onlyOwner {
53         require(isAdminister(account));
54         require(!isPauser(account));
55         if (adminGroup.administerListIndex[account]==0){
56             require(adminGroup.administerList[0] == account);
57         }
58 
59         if (adminGroup.administerListIndex[account] >= adminGroup.administerList.length) return;
60 
61         adminGroup.administers[account] = false;
62 
63         for (uint i = adminGroup.administerListIndex[account]; i<adminGroup.administerList.length-1; i++){
64             adminGroup.administerList[i] = adminGroup.administerList[i+1];
65             adminGroup.administerListIndex[adminGroup.administerList[i+1]] = adminGroup.administerListIndex[adminGroup.administerList[i+1]]-1;
66         }
67         delete adminGroup.administerList[adminGroup.administerList.length-1];
68         delete adminGroup.administerListIndex[account];
69         adminGroup.administerList.length--;
70 
71         emit AdministerRemoved(account);
72     }
73 
74     function getAdministerList() view public returns(address[]) {
75         return adminGroup.administerList;
76     }
77 
78     function isPauser(address account) public view returns (bool) {
79         return adminGroup.pausers[account];
80     }
81 
82     function addPauser(address account) public onlyOwner {
83         require(!isAdminister(account));
84         require(!isPauser(account));
85         require(account != owner);
86         adminGroup.pausers[account] = true;
87         adminGroup.pauserListIndex[account] = adminGroup.pauserList.push(account)-1;
88         emit PauserAdded(account);
89     }
90 
91     function removePauser(address account) public onlyOwner{
92         require(isPauser(account));
93         require(!isAdminister(account));
94         if (adminGroup.pauserListIndex[account]==0){
95             require(adminGroup.pauserList[0] == account);
96         }
97 
98         if (adminGroup.pauserListIndex[account] >= adminGroup.pauserList.length) return;
99 
100         adminGroup.pausers[account] = false;
101 
102         for (uint i = adminGroup.pauserListIndex[account]; i<adminGroup.pauserList.length-1; i++){
103             adminGroup.pauserList[i] = adminGroup.pauserList[i+1];
104             adminGroup.pauserListIndex[adminGroup.pauserList[i+1]] = adminGroup.pauserListIndex[adminGroup.pauserList[i+1]]-1;
105         }
106         delete adminGroup.pauserList[adminGroup.pauserList.length-1];
107         delete adminGroup.pauserListIndex[account];
108         adminGroup.pauserList.length--;
109 
110         emit PauserRemoved(account);
111     }
112 
113     function getPauserList() view public returns(address[]) {
114         return adminGroup.pauserList;
115     }
116 
117     event AdministerAdded(address indexed account);
118     event AdministerRemoved(address indexed account);
119     event PauserAdded(address indexed account);
120     event PauserRemoved(address indexed account);
121 }
122 
123 contract Proxy is Role {
124 
125     event Upgraded(address indexed implementation);
126 
127     address internal _linkedContractAddress;
128 
129     function implementation() public view returns (address) {
130         return _linkedContractAddress;
131     }
132 
133     function upgradeTo(address newContractAddress) public administerAndAbove {
134         require(newContractAddress != address(0));
135         _linkedContractAddress = newContractAddress;
136         emit Upgraded(newContractAddress);
137     }
138 
139     function () payable public {
140         address _implementation = implementation();
141         require(_implementation != address(0));
142         bytes memory data = msg.data;
143 
144         assembly {
145             let result := delegatecall(gas, _implementation, add(data, 0x20), mload(data), 0, 0)
146             let size := returndatasize
147             let ptr := mload(0x40)
148             returndatacopy(ptr, 0, size)
149             switch result
150             case 0 { revert(ptr, size) }
151             default { return(ptr, size) }
152         }
153     }
154 }
155 
156 contract PathHiveNetworkProxy is Proxy {
157     string public name = "PathHive Network";
158     string public symbol = "PHV";
159     uint8 public decimals = 18;
160 
161     constructor() public {}
162 }