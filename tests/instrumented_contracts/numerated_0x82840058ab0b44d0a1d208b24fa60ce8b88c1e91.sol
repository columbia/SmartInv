1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC20 {
5     function balanceOf(address _owner) external returns (uint256);
6     function transfer(address _to, uint256 _amount) external;
7     function transferFrom(address _from, address _to, uint256 _amount) external;
8     function mint(address _to, uint256 _amount) external;
9     function burn(uint256 _amount) external;
10 }
11 
12 contract BridgeOperatable {
13     address public owner;
14     address public operator1;
15     address public operator2;
16 
17     event OwnershipTransferred(address indexed _from, address indexed _to);
18     event Operator1Transferred(address indexed _from, address indexed _to);
19     event Operator2Transferred(address indexed _from, address indexed _to);
20 
21     constructor() {
22         owner = msg.sender;
23         operator1 = msg.sender;
24         operator2 = msg.sender;
25     }
26 
27     modifier onlyOwner {
28         require(msg.sender == owner, 'onlyOwner: insufficient privilege');
29         _;
30     }
31 
32     modifier onlyOperator1 {
33         require(msg.sender == operator1, 'onlyOperator1: insufficient privilege');
34         _;
35     }
36 
37     modifier onlyOperator2 {
38         require(msg.sender == operator2, 'onlyOperator2: insufficient privilege');
39         _;
40     }
41 
42     function transferOwner(address _owner) public onlyOwner {
43         emit Operator1Transferred(owner, _owner);
44         owner = _owner;
45     }
46 
47     function transferOperator1(address _operator1) public onlyOwner {
48         emit Operator1Transferred(operator1, _operator1);
49         operator1 = _operator1;
50     }
51 
52     function transferOperator2(address _operator2) public onlyOwner {
53         emit Operator2Transferred(operator2, _operator2);
54         operator2 = _operator2;
55     }
56 }
57 
58 contract NodokaBridge is BridgeOperatable {
59     mapping(address => Token) public tokens;
60     mapping(address => Token) public pairs;
61     mapping(address => address payable) public treasury; 
62 
63     struct Token {
64         bool active;
65         address tokenAddress;
66         bool isERC20;  // false: native, true: ERC20
67         bool mintable; // false: unlock, true: mint
68         bool burnable; // false: lock,   true: burn
69         uint256 minAmount;
70         uint256 maxAmount;
71     }
72     
73     event Bridge(address indexed _from, address indexed _token1, address indexed _token2, address _to, uint256 _amount);
74     event Trigger(address indexed _from, address indexed _token, address _to, uint256 _amount);
75 
76     constructor() {}
77     
78     function setPair(address _token1, bool _mintable, bool _burnable, address _token2) external onlyOwner returns (bool) {
79         Token memory token1 = Token(true, _token1, _token1 == address(0) ? false: true, _mintable, _burnable, 1, 2**256-1);
80         Token memory token2 = Token(true, _token2, _token2 == address(0) ? false: true, false, false, 1, 2**256-1);
81         
82         tokens[_token1] = token1;
83         pairs[_token1] = token2;
84         return true;
85     }
86     
87     function removePair(address _token1) external onlyOwner returns (bool) {
88         pairs[_token1] = Token(true, address(0), false, false, false, 0, 0);
89         return true;
90     }
91 
92     function setMinMax(address _token, uint256 _minAmount, uint256 _maxAmount) external onlyOwner returns (bool) {
93         tokens[_token].minAmount = _minAmount;
94         tokens[_token].maxAmount = _maxAmount;
95         return true;
96     }
97 
98     function setTreasury(address _token, address payable _treasury) external onlyOwner returns (bool) {
99         treasury[_token] = _treasury;
100         return true;
101     }
102     
103     receive() external payable {
104         // Do nothing
105     }
106     
107     function deposit(address _token, address _to, uint256 _amount) external payable returns (bool) {
108         Token memory token1 = tokens[_token];
109         Token memory token2 = pairs[_token];
110         require(token2.active, "the token is not acceptable");
111         require(_amount >= token1.minAmount, 'amount is less than min');
112         require(_amount <= token1.maxAmount || token1.maxAmount == 0, 'amount ecxeeds max');
113 
114         if (token1.isERC20) {
115             IERC20 token = IERC20(_token);
116             token.transferFrom(msg.sender, address(this), _amount);
117 
118             if (token1.burnable) {
119                 token.burn(_amount);
120             }
121 
122             emit Bridge(msg.sender, token1.tokenAddress, token2.tokenAddress, _to, _amount);
123         } else {
124             token1 = tokens[address(0)];
125             token2 = pairs[address(0)];
126             require(msg.value > 0, "msg.value is zero");
127             require(token2.active, "the native token is not acceptable");
128 
129             emit Bridge(msg.sender, token1.tokenAddress, token2.tokenAddress, msg.sender, msg.value);
130         }
131         
132         return true;
133     }
134 
135     function withdraw(address _token, uint256 _amount) external onlyOperator1 returns (bool) {
136         if(_token == address(0)) {
137             // Native token
138             require(address(this).balance >= _amount, 'insufficient balance');
139             treasury[_token].transfer(_amount);
140         } else {
141             // ERC20 token
142             IERC20 token = IERC20(_token);
143             require(token.balanceOf(address(this)) >= _amount, 'insufficient balance');
144             token.transfer(treasury[_token], _amount);
145         }
146         return true;
147     }
148     
149     function trigger(address _token, address payable _to, uint256 _amount) external onlyOperator2 returns (bool) {
150         Token memory token = tokens[_token];
151         require(token.active, "the token is inactive");
152 
153         if (!token.isERC20) {
154             // Native token
155             _to.transfer(_amount);
156         } else if (token.mintable) {
157             // Mintable ERC20
158             IERC20(token.tokenAddress).mint(_to, _amount);
159         } else {
160             // Non-mintable ERC20 
161             IERC20(token.tokenAddress).transfer(_to, _amount);
162         }
163         return true;
164     }
165 }