1 pragma solidity ^0.5.7;
2 
3 
4 
5 library SafeMath256 {
6 
7     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         c = a + b;
9         assert(c >= a);
10         return c;
11     }
12 
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         if (a == 0) {
21             return 0;
22         }
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b > 0);
31         uint256 c = a / b;
32         assert(a == b * c + a % b);
33         return a / b;
34     }
35 
36 
37     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b != 0);
39         return a % b;
40     }
41 }
42 
43 
44 contract Ownable {
45     address private _owner;
46     address payable internal _receiver;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49     event ReceiverChanged(address indexed previousReceiver, address indexed newReceiver);
50 
51 
52     constructor () internal {
53         _owner = msg.sender;
54         _receiver = msg.sender;
55     }
56 
57 
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62 
63     modifier onlyOwner() {
64         require(msg.sender == _owner);
65         _;
66     }
67 
68 
69     function transferOwnership(address newOwner) external onlyOwner {
70         require(newOwner != address(0));
71         address __previousOwner = _owner;
72         _owner = newOwner;
73         emit OwnershipTransferred(__previousOwner, newOwner);
74     }
75 
76 
77     function changeReceiver(address payable newReceiver) external onlyOwner {
78         require(newReceiver != address(0));
79         address __previousReceiver = _receiver;
80         _receiver = newReceiver;
81         emit ReceiverChanged(__previousReceiver, newReceiver);
82     }
83 
84 
85     function rescueTokens(address tokenAddress, address receiver, uint256 amount) external onlyOwner {
86         IERC20 _token = IERC20(tokenAddress);
87         require(receiver != address(0));
88         uint256 balance = _token.balanceOf(address(this));
89         require(balance >= amount);
90 
91         assert(_token.transfer(receiver, amount));
92     }
93 
94 
95     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
96         require(to != address(0));
97         uint256 balance = address(this).balance;
98         require(balance >= amount);
99 
100         to.transfer(amount);
101     }
102 }
103 
104 
105 
106 contract Pausable is Ownable {
107     bool private _paused;
108 
109     event Paused(address account);
110     event Unpaused(address account);
111 
112     constructor () internal {
113         _paused = false;
114     }
115 
116 
117     function paused() public view returns (bool) {
118         return _paused;
119     }
120 
121 
122     modifier whenNotPaused() {
123         require(!_paused, "Paused.");
124         _;
125     }
126 
127 
128     function setPaused(bool state) external onlyOwner {
129         if (_paused && !state) {
130             _paused = false;
131             emit Unpaused(msg.sender);
132         } else if (!_paused && state) {
133             _paused = true;
134             emit Paused(msg.sender);
135         }
136     }
137 }
138 
139 
140 interface IERC20 {
141     function balanceOf(address owner) external view returns (uint256);
142     function transfer(address to, uint256 value) external returns (bool);
143 }
144 
145 
146 
147 interface IToken {
148     function balanceOf(address owner) external view returns (uint256);
149     function transfer(address to, uint256 value) external returns (bool);
150     function inWhitelist(address account) external view returns (bool);
151 }
152 
153 
154 
155 interface ITokenPublicSale {
156     function status() external view returns (uint256 auditEtherPrice,
157         uint16 stage,
158         uint16 season,
159         uint256 tokenUsdPrice,
160         uint256 currentTopSalesRatio,
161         uint256 txs,
162         uint256 tokenTxs,
163         uint256 tokenBonusTxs,
164         uint256 tokenWhitelistTxs,
165         uint256 tokenIssued,
166         uint256 tokenBonus,
167         uint256 tokenWhitelist);
168 }
169 
170 
171 contract Get102Token is Ownable, Pausable {
172     using SafeMath256 for uint256;
173 
174     IToken           public TOKEN             = IToken(0xfaCe8492ce3EE56855827b5eC3f9Affd0a4c5E15);
175     ITokenPublicSale public TOKEN_PUBLIC_SALE = ITokenPublicSale(0x2B4F291DAC3f50dF9f846901DD350a7Ff2357bd6);
176 
177     uint256 private WEI_MIN = 1 ether;
178     uint256 private TOKEN_PER_TXN = 102000000; // 102.000000 Token
179 
180     uint256 private _txs;
181 
182     mapping (address => bool) _alreadyGot;
183 
184     event Tx(uint256 etherPrice, uint256 vokdnUsdPrice, uint256 weiUsed);
185 
186 
187     function txs() public view returns (uint256) {
188         return _txs;
189     }
190 
191 
192     function () external payable whenNotPaused {
193         require(msg.value >= WEI_MIN);
194         require(TOKEN.balanceOf(address(this)) >= TOKEN_PER_TXN);
195         require(TOKEN.balanceOf(msg.sender) == 0);
196         require(!TOKEN.inWhitelist(msg.sender));
197         require(!_alreadyGot[msg.sender]);
198 
199         uint256 __etherPrice;
200         uint256 __tokenUsdPrice;
201         (__etherPrice, , , __tokenUsdPrice, , , , , , , ,) = TOKEN_PUBLIC_SALE.status();
202 
203         require(__etherPrice > 0);
204 
205         uint256 __usd = TOKEN_PER_TXN.mul(__tokenUsdPrice).div(1000000);
206         uint256 __wei = __usd.mul(1 ether).div(__etherPrice);
207 
208         require(msg.value >= __wei);
209 
210         if (msg.value > __wei) {
211             msg.sender.transfer(msg.value.sub(__wei));
212             _receiver.transfer(__wei);
213         }
214 
215         _txs = _txs.add(1);
216         _alreadyGot[msg.sender] = true;
217         emit Tx(__etherPrice, __tokenUsdPrice, __wei);
218 
219         assert(TOKEN.transfer(msg.sender, TOKEN_PER_TXN));
220     }
221 }