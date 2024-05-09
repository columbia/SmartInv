1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IERC20 {
5     
6     function name() external view returns (string memory);
7 
8     function symbol() external view returns (string memory);
9 
10     function decimals() external view returns (uint8);
11 
12     function totalSupply() external view returns (uint);
13 
14     function balanceOf(address owner) external view returns (uint);
15 
16     function allowance(address owner, address spender) external view returns (uint);
17 
18     function transfer(address to, uint value) external returns (bool);
19 
20     function approve(address spender, uint value) external returns (bool);
21 
22     function transferFrom(
23         address from,
24         address to,
25         uint value
26     ) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint value);
29 
30     event Approval(address indexed owner, address indexed spender, uint value);
31 }
32 
33 contract LnAdmin {
34     address public admin;
35     address public candidate;
36 
37     constructor(address _admin) public {
38         require(_admin != address(0), "admin address cannot be 0");
39         admin = _admin;
40         emit AdminChanged(address(0), _admin);
41     }
42 
43     function setCandidate(address _candidate) external onlyAdmin {
44         address old = candidate;
45         candidate = _candidate;
46         emit candidateChanged( old, candidate);
47     }
48 
49     function becomeAdmin( ) external {
50         require( msg.sender == candidate, "Only candidate can become admin");
51         address old = admin;
52         admin = candidate;
53         emit AdminChanged( old, admin ); 
54     }
55 
56     modifier onlyAdmin {
57         require( (msg.sender == admin), "Only the contract admin can perform this action");
58         _;
59     }
60 
61     event candidateChanged(address oldCandidate, address newCandidate );
62     event AdminChanged(address oldAdmin, address newAdmin);
63 }
64 
65 contract LnProxyBase is LnAdmin {
66     LnProxyImpl public target;
67 
68     constructor(address _admin) public LnAdmin(_admin) {}
69 
70     function setTarget(LnProxyImpl _target) external onlyAdmin {
71         target = _target;
72         emit TargetUpdated(_target);
73     }
74 
75     function Log0( bytes calldata callData ) external onlyTarget {
76         uint size = callData.length;
77         bytes memory _callData = callData;
78         assembly {
79             log0(add(_callData, 32), size)
80         }
81     }
82 
83     function Log1( bytes calldata callData, bytes32 topic1 ) external onlyTarget {
84         uint size = callData.length;
85         bytes memory _callData = callData;
86         assembly {
87             log1(add(_callData, 32), size, topic1 )
88         }
89     }
90 
91     function Log2( bytes calldata callData, bytes32 topic1, bytes32 topic2 ) external onlyTarget {
92         uint size = callData.length;
93         bytes memory _callData = callData;
94         assembly {
95             log2(add(_callData, 32), size, topic1, topic2 )
96         }
97     }
98 
99     function Log3( bytes calldata callData, bytes32 topic1, bytes32 topic2, bytes32 topic3 ) external onlyTarget {
100         uint size = callData.length;
101         bytes memory _callData = callData;
102         assembly {
103             log3(add(_callData, 32), size, topic1, topic2, topic3 )
104         }
105     }
106 
107     function Log4( bytes calldata callData, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4 ) external onlyTarget {
108         uint size = callData.length;
109         bytes memory _callData = callData;
110         assembly {
111             log4(add(_callData, 32), size, topic1, topic2, topic3, topic4 )
112         }
113     }
114 
115     //receive: It is executed on a call to the contract with empty calldata. This is the function that is executed on plain Ether transfers (e.g. via .send() or .transfer()).
116     //fallback: can only rely on 2300 gas being available,
117     receive() external payable {
118         target.setMessageSender(msg.sender);
119 
120         assembly {
121             let free_ptr := mload(0x40)
122             calldatacopy(free_ptr, 0, calldatasize())
123 
124             let result := call(gas(), sload(target_slot), callvalue(), free_ptr, calldatasize(), 0, 0)
125             returndatacopy(free_ptr, 0, returndatasize())
126 
127             if iszero(result) {
128                 revert(free_ptr, returndatasize())
129             }
130             return(free_ptr, returndatasize())
131         }
132     }
133 
134     modifier onlyTarget {
135         require(LnProxyImpl(msg.sender) == target, "Must be proxy target");
136         _;
137     }
138 
139     event TargetUpdated(LnProxyImpl newTarget);
140 }
141 
142 
143 abstract contract LnProxyImpl is LnAdmin {
144     
145     LnProxyBase public proxy;
146     LnProxyBase public integrationProxy;
147 
148     address public messageSender;
149 
150     constructor(address payable _proxy) internal {
151         
152         require(admin != address(0), "Admin must be set");
153 
154         proxy = LnProxyBase(_proxy);
155         emit ProxyUpdated(_proxy);
156     }
157 
158     function setProxy(address payable _proxy) external onlyAdmin {
159         proxy = LnProxyBase(_proxy);
160         emit ProxyUpdated(_proxy);
161     }
162 
163     function setIntegrationProxy(address payable _integrationProxy) external onlyAdmin {
164         integrationProxy = LnProxyBase(_integrationProxy);
165     }
166 
167     function setMessageSender(address sender) external onlyProxy {
168         messageSender = sender;
169     }
170 
171     modifier onlyProxy {
172         require(LnProxyBase(msg.sender) == proxy || LnProxyBase(msg.sender) == integrationProxy, "Only the proxy can call");
173         _;
174     }
175 
176     modifier optionalProxy {
177         if (LnProxyBase(msg.sender) != proxy && LnProxyBase(msg.sender) != integrationProxy && messageSender != msg.sender) {
178             messageSender = msg.sender;
179         }
180         _;
181     }
182 
183     modifier optionalProxy_onlyAdmin {
184         if (LnProxyBase(msg.sender) != proxy && LnProxyBase(msg.sender) != integrationProxy && messageSender != msg.sender) {
185             messageSender = msg.sender;
186         }
187         require(messageSender == admin, "only for admin");
188         _;
189     }
190 
191     event ProxyUpdated(address proxyAddress);
192 }
193 
194 contract LnProxyERC20 is LnProxyBase, IERC20 {
195     constructor(address _admin) public LnProxyBase(_admin) {}
196 
197     function name() public view override returns (string memory) {
198         
199         return IERC20(address(target)).name();
200     }
201 
202     function symbol() public view override returns (string memory) {
203         
204         return IERC20(address(target)).symbol();
205     }
206 
207     function decimals() public view override returns (uint8) {
208         
209         return IERC20(address(target)).decimals();
210     }
211 
212     function totalSupply() public view override returns (uint256) {
213         
214         return IERC20(address(target)).totalSupply();
215     }
216 
217     function balanceOf(address account) public view override returns (uint256) {
218         
219         return IERC20(address(target)).balanceOf(account);
220     }
221 
222     function allowance(address owner, address spender) public view override returns (uint256) {
223         
224         return IERC20(address(target)).allowance(owner, spender);
225     }
226 
227     function transfer(address to, uint256 value) public override returns (bool) {
228         
229         target.setMessageSender(msg.sender);
230 
231         IERC20(address(target)).transfer(to, value);
232 
233         return true;
234     }
235 
236     function approve(address spender, uint256 value) public override returns (bool) {
237         
238         target.setMessageSender(msg.sender);
239 
240         IERC20(address(target)).approve(spender, value);
241 
242         return true;
243     }
244 
245     function transferFrom(
246         address from,
247         address to,
248         uint256 value
249     ) public override returns (bool) {
250         
251         target.setMessageSender(msg.sender);
252 
253         IERC20(address(target)).transferFrom(from, to, value);
254 
255         return true;
256     }
257 }