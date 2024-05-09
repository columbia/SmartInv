1 pragma solidity ^0.5.0;
2 
3 contract Ownable
4 {
5     bool private stopped;
6     address private _owner;
7     address private _master;
8 
9     event Stopped();
10     event Started();
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12     event MasterRoleTransferred(address indexed previousMaster, address indexed newMaster);
13 
14     constructor () internal
15     {
16         stopped = false;
17         _owner = msg.sender;
18         _master = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20         emit MasterRoleTransferred(address(0), _master);
21     }
22 
23     function owner() public view returns (address)
24     {
25         return _owner;
26     }
27 
28     function master() public view returns (address)
29     {
30         return _master;
31     }
32 
33     modifier onlyOwner()
34     {
35         require(isOwner());
36         _;
37     }
38 
39     modifier onlyMaster()
40     {
41         require(isMaster() || isOwner());
42         _;
43     }
44 
45     modifier onlyWhenNotStopped()
46     {
47         require(!isStopped());
48         _;
49     }
50 
51     function isOwner() public view returns (bool)
52     {
53         return msg.sender == _owner;
54     }
55 
56     function isMaster() public view returns (bool)
57     {
58         return msg.sender == _master;
59     }
60 
61     function transferOwnership(address newOwner) external onlyOwner
62     {
63         _transferOwnership(newOwner);
64     }
65 
66     function transferMasterRole(address newMaster) external onlyOwner
67     {
68         _transferMasterRole(newMaster);
69     }
70 
71     function isStopped() public view returns (bool)
72     {
73         return stopped;
74     }
75 
76     function stop() public onlyOwner
77     {
78         _stop();
79     }
80 
81     function start() public onlyOwner
82     {
83         _start();
84     }
85 
86     function _transferOwnership(address newOwner) internal
87     {
88         require(newOwner != address(0));
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 
93     function _transferMasterRole(address newMaster) internal
94     {
95         require(newMaster != address(0));
96         emit MasterRoleTransferred(_master, newMaster);
97         _master = newMaster;
98     }
99 
100     function _stop() internal
101     {
102         emit Stopped();
103         stopped = true;
104     }
105 
106     function _start() internal
107     {
108         emit Started();
109         stopped = false;
110     }
111 }
112 
113 contract ChannelWallet is Ownable
114 {
115     mapping(string => address) private addressMap;
116 
117     event SetAddress(string channelId, address _address);
118     event UpdateAddress(string from, string to);
119     event DeleteAddress(string account);
120 
121     constructor (address newMaster) public
122     {
123         _transferMasterRole(newMaster);
124     }
125 
126     function version() external pure returns(string memory)
127     {
128         return '0.0.1';
129     }
130 
131     function getAddress(string calldata channelId) external view returns (address)
132     {
133         return addressMap[channelId];
134     }
135 
136     function setAddress(string calldata channelId, address _address) external onlyMaster onlyWhenNotStopped
137     {
138         require(bytes(channelId).length > 0);
139 
140         addressMap[channelId] = _address;
141 
142         emit SetAddress(channelId, _address);
143     }
144 
145     function updateChannel(string calldata from, string calldata to, address _address) external onlyMaster onlyWhenNotStopped
146     {
147         require(bytes(from).length > 0);
148         require(bytes(to).length > 0);
149         require(addressMap[to] == address(0));
150 
151         addressMap[to] = _address;
152 
153         addressMap[from] = address(0);
154 
155         emit UpdateAddress(from, to);
156     }
157 
158     function deleteChannel(string calldata channelId) external onlyMaster onlyWhenNotStopped
159     {
160         require(bytes(channelId).length > 0);
161 
162         addressMap[channelId] = address(0);
163 
164         emit DeleteAddress(channelId);
165     }
166 }