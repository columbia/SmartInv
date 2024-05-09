1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC20 {
5     function transfer(address _to, uint256 _amount) external;
6 
7     function transferFrom(
8         address _from,
9         address _to,
10         uint256 _amount
11     ) external;
12 
13     function mint(address _to, uint256 _amount) external;
14 
15     function burn(uint256 _amount) external;
16 }
17 
18 contract Ownable {
19     address public owner;
20 
21     event OwnershipTransferred(address indexed _from, address indexed _to);
22 
23     constructor() {
24         owner = msg.sender;
25     }
26 
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     function transferOwnership(address _owner) public onlyOwner {
33         owner = _owner;
34         emit OwnershipTransferred(owner, _owner);
35     }
36 }
37 
38 contract BurnBridge is Ownable {
39     uint256 public feeValues;
40     address public adminAddress;
41     mapping(address => Token) public tokens;
42     mapping(address => mapping(uint256 => Token)) public pairs;
43     uint256 public nativeCirculation = 0;
44     uint256 public currentChainType;
45 
46     struct Token {
47         bool active;
48         address tokenAddress;
49         bool isERC20; // false: native, true: ERC20
50         bool mintable; // false: unlock, true: mint
51         bool burnable; // false: lock,   true: burn
52         uint256 chainType;
53     }
54 
55     event Bridge(
56         address indexed _from,
57         address indexed _token1,
58         address indexed _token2,
59         address _to,
60         uint256 _amount,
61         uint256 chainType
62     );
63     event addPair(
64         address _token1,
65         address _token2,
66         uint256 _token1ChainType,
67         uint256 _token2ChainType,
68         uint256 actionType
69     );
70 
71     //_currentChainType==1 for ETH,
72     //_currentChainType==2 for BSC,
73     //_currentChainType==3 for MATIC
74     constructor(uint256 _currentChainType) {
75         currentChainType = _currentChainType;
76     }
77 
78     function setPair(
79         address _token1,
80         bool _mintable,
81         bool _burnable,
82         address _token2,
83         uint256 chainType
84     ) external onlyOwner returns (bool) {
85         Token memory token1 = Token(
86             true,
87             _token1,
88             _token1 == address(0) ? false : true,
89             _mintable,
90             _burnable,
91             currentChainType
92         );
93         Token memory token2 = Token(
94             true,
95             _token2,
96             _token2 == address(0) ? false : true,
97             false,
98             false,
99             chainType
100         );
101 
102         tokens[_token1] = token1;
103         pairs[_token1][chainType] = token2;
104         emit addPair(_token1, _token2, currentChainType, chainType, 1);
105         return true;
106     }
107 
108     function removePair(address _token1, uint256 chainType)
109         external
110         onlyOwner
111         returns (bool)
112     {
113         pairs[_token1][chainType] = Token(
114             true,
115             address(0),
116             false,
117             false,
118             false,
119             chainType
120         );
121         emit addPair(
122             _token1,
123             pairs[_token1][chainType].tokenAddress,
124             currentChainType,
125             chainType,
126             2
127         );
128         return true;
129     }
130 
131     receive() external payable {
132         // Do nothing
133     }
134 
135     function deposit(
136         address _token,
137         address _to,
138         uint256 _amount,
139         uint256 _chainType
140     ) external payable returns (bool) {
141         Token memory token1 = tokens[_token];
142         Token memory token2 = pairs[_token][_chainType];
143         require(token2.active, "the token is not acceptable");
144 
145         uint256 feeAmount;
146         uint256 transferAmount;
147         if (token1.isERC20) {
148             IERC20 token = IERC20(_token);
149             transferAmount = _amount;
150             if (feeValues > 0 && adminAddress != address(0)) {
151                 feeAmount = (((feeValues) * transferAmount) / (10**5));
152                 transferAmount = transferAmount - feeAmount;
153             }
154             token.transferFrom(msg.sender, address(this), transferAmount);
155             if (feeAmount > 0) {
156                 token.transferFrom(msg.sender, adminAddress, feeAmount);
157             }
158 
159             if (token1.burnable) {
160                 token.burn(transferAmount);
161             }
162         } else {
163             token1 = tokens[address(0)];
164             token2 = pairs[address(0)][_chainType];
165             transferAmount = msg.value;
166             if (feeValues > 0 && adminAddress != address(0)) {
167                 feeAmount = (((feeValues) * transferAmount) / (10**5));
168                 transferAmount = transferAmount - feeAmount;
169             }
170             require(msg.value > 0, "msg.value is zero");
171             require(token2.active, "the native token is not acceptable");
172             if (feeAmount > 0) {
173                 (payable(adminAddress)).transfer(feeAmount);
174             }
175         }
176         emit Bridge(
177             msg.sender,
178             token1.tokenAddress,
179             token2.tokenAddress,
180             _to,
181             transferAmount,
182             _chainType
183         );
184 
185         return true;
186     }
187 
188     function trigger(
189         address _token,
190         address payable _to,
191         uint256 _amount
192     ) external onlyOwner returns (bool) {
193         Token memory token = tokens[_token];
194         require(token.active, "the token is not acceptable");
195 
196         if (!token.isERC20) {
197             // Native token
198             _to.transfer(_amount);
199         } else if (token.mintable) {
200             // Mintable ERC20
201             IERC20(token.tokenAddress).mint(_to, _amount);
202         } else {
203             // Non-mintable ERC20
204             IERC20(token.tokenAddress).transfer(_to, _amount);
205         }
206         return true;
207     }
208 
209     function setFeeValues(uint256 _feeValues) external onlyOwner {
210         feeValues = _feeValues;
211     }
212 
213     function setAdminAddress(address _adminAddress) external onlyOwner {
214         adminAddress = _adminAddress;
215     }
216 }