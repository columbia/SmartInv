1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /*
5 //https://cointool.app web3 basic tools!
6 //
7 //
8 //  _____      _    _______          _                        
9 // / ____|    (_)  |__   __|        | |     /\                
10 //| |     ___  _ _ __ | | ___   ___ | |    /  \   _ __  _ __  
11 //| |    / _ \| | '_ \| |/ _ \ / _ \| |   / /\ \ | '_ \| '_ \ 
12 //| |___| (_) | | | | | | (_) | (_) | |_ / ____ \| |_) | |_) |
13 // \_____\___/|_|_| |_|_|\___/ \___/|_(_)_/    \_\ .__/| .__/ 
14 //                                               | |   | |    
15 //                                               |_|   |_|    
16 //
17 */
18 
19 
20 interface IERC20 {
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address to, uint256 amount) external returns (bool);
23 }
24 
25 contract CoinTool_App{
26     address owner;
27     address private immutable original;
28     mapping(address => mapping(bytes =>uint256)) public map;
29 
30     constructor() payable {
31         original = address(this);
32         owner = tx.origin;
33     }
34     receive() external payable {}
35     fallback() external payable{}
36 
37     function t(uint256 total,bytes memory data,bytes calldata _salt) external payable {
38         require(msg.sender == tx.origin);
39         bytes memory bytecode = bytes.concat(bytes20(0x3D602d80600A3D3981F3363d3d373d3D3D363d73), bytes20(address(this)), bytes15(0x5af43d82803e903d91602b57fd5bf3));
40         uint256 i = map[msg.sender][_salt]+1;
41         uint256 end = total+i;
42         for (i; i < end;++i) {
43 	        bytes32 salt = keccak256(abi.encodePacked(_salt,i,msg.sender));
44 			assembly {
45 	            let proxy := create2(0, add(bytecode, 32), mload(bytecode), salt)
46                     let succeeded := call(
47                         gas(),
48                         proxy,
49                         0,
50                         add(data, 0x20),
51                         mload(data),
52                         0,
53                         0
54                     )
55 			}
56         }
57         map[msg.sender][_salt] += total;
58     }
59 
60 
61     function t_(uint256[] calldata a,bytes memory data,bytes calldata _salt) external payable {
62         require(msg.sender == tx.origin);
63         bytes memory bytecode = bytes.concat(bytes20(0x3D602d80600A3D3981F3363d3d373d3D3D363d73), bytes20(address(this)), bytes15(0x5af43d82803e903d91602b57fd5bf3));
64         uint256 i = 0;
65         for (i; i < a.length; ++i) {
66 	        bytes32 salt = keccak256(abi.encodePacked(_salt,a[i],msg.sender));
67 			assembly {
68 	            let proxy := create2(0, add(bytecode, 32), mload(bytecode), salt)
69                     let succeeded := call(
70                         gas(),
71                         proxy,
72                         0,
73                         add(data, 0x20),
74                         mload(data),
75                         0,
76                         0
77                     )
78 			}
79         }
80         uint256 e = a[a.length-1];
81         if(e>map[msg.sender][_salt]){
82            map[msg.sender][_salt] = e;
83         }
84     }
85 
86     function f(uint256[] calldata a,bytes memory data,bytes memory _salt) external payable {
87         require(msg.sender == tx.origin);
88         bytes32 bytecode = keccak256(abi.encodePacked(bytes.concat(bytes20(0x3D602d80600A3D3981F3363d3d373d3D3D363d73), bytes20(address(this)), bytes15(0x5af43d82803e903d91602b57fd5bf3))));
89         uint256 i = 0;
90         for (i; i < a.length; ++i) {
91 	        bytes32 salt = keccak256(abi.encodePacked(_salt,a[i],msg.sender));
92             address proxy = address(uint160(uint(keccak256(abi.encodePacked(
93                     hex'ff',
94                     address(this),
95                     salt,
96                     bytecode
97                 )))));
98 			assembly {
99                 let succeeded := call(
100                     gas(),
101                     proxy,
102                     0,
103                     add(data, 0x20),
104                     mload(data),
105                     0,
106                     0
107                 )
108 			}
109         }
110     }
111 
112 
113 
114     function d(address a,bytes memory data) external payable{
115         require(msg.sender == original);
116         a.delegatecall(data);
117     }
118     function c(address a,bytes calldata data) external payable {
119        require(msg.sender == original);
120        external_call(a,data);
121     }
122 
123     function dKill(address a,bytes memory data) external payable{
124         require(msg.sender == original);
125         a.delegatecall(data);
126         selfdestruct(payable(msg.sender));
127     }
128     function cKill(address a,bytes calldata data) external payable {
129        require(msg.sender == original);
130        external_call(a,data);
131        selfdestruct(payable(msg.sender));
132     }
133 
134     function k() external {
135         require(msg.sender == original);
136         selfdestruct(payable(msg.sender));
137     }
138    
139     function external_call(address destination,bytes memory data) internal{
140         assembly {
141             let succeeded := call(
142                 gas(),
143                 destination,
144                 0,
145                 add(data, 0x20),
146                 mload(data),
147                 0,
148                 0
149             )
150         }
151     }
152 
153 
154     function claimTokens(address _token) external  {
155         require(owner == msg.sender);
156         if (_token == address(0x0)) {
157            payable (owner).transfer(address(this).balance);
158             return;
159         }
160         IERC20 erc20token = IERC20(_token);
161         uint256 balance = erc20token.balanceOf(address(this));
162         erc20token.transfer(owner, balance);
163     }
164 
165 }