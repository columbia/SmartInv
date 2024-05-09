1 pragma solidity ^0.5.8;
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
113 contract AccountWallet is Ownable
114 {
115     mapping(string => string) private btc;
116     mapping(string => address) private eth;
117 
118     event SetAddress(string account, string btcAddress, address ethAddress);
119     event UpdateAddress(string from, string to);
120     event DeleteAddress(string account);
121 
122     function version() external pure returns(string memory)
123     {
124         return '1.0.0';
125     }
126 
127     function getAddress(string calldata account) external view returns (string memory, address)
128     {
129         return (btc[account], eth[account]);
130     }
131 
132     function setAddress(string calldata account, string calldata btcAddress, address ethAddress) external onlyMaster onlyWhenNotStopped
133     {
134         require(bytes(account).length > 0);
135 
136         btc[account] = btcAddress;
137         eth[account] = ethAddress;
138 
139         emit SetAddress(account, btcAddress, ethAddress);
140     }
141 
142     function updateAccount(string calldata from, string calldata to) external onlyMaster onlyWhenNotStopped
143     {
144         require(bytes(from).length > 0);
145         require(bytes(to).length > 0);
146 
147         btc[to] = btc[from];
148         eth[to] = eth[from];
149 
150         btc[from] = '';
151         eth[from] = address(0);
152 
153         emit UpdateAddress(from, to);
154     }
155 
156     function deleteAccount(string calldata account) external onlyMaster onlyWhenNotStopped
157     {
158         require(bytes(account).length > 0);
159 
160         btc[account] = '';
161         eth[account] = address(0);
162 
163         emit DeleteAddress(account);
164     }
165 }