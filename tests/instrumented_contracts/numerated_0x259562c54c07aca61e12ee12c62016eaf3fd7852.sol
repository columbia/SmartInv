1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.7.4;
3 
4 interface IERC20 {
5 
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function allowance(address owner, address spender) external view returns (uint256);
11 
12     function transfer(address recipient, uint256 amount) external returns (bool);
13 
14     function approve(address spender, uint256 amount) external returns (bool);
15 
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17 
18 
19     //    event Transfer(address indexed from, address indexed to, uint256 value);
20     //    event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 
24 contract Nokon is IERC20 {
25 
26     string public constant name = "Nokon";
27     string public constant symbol = "NKO";
28     uint8 public constant decimals = 8;
29 
30 
31     event Bought(uint256 amountz);
32     event Sold(uint256 amount);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34     event Transfer(address indexed from, address indexed to, uint tokens);
35 
36 
37     mapping(address => uint256) balances;
38     mapping(address => mapping(address => uint256)) allowed;
39 
40     mapping(address => bool) public authorizedAddress;
41 
42     address authAddress = parseAddr('0x44F6827aa307F4d7FAeb64Be47543647B3a871dB');
43     uint256 totalSupply_ = 1200000000000000000;
44     bool presell = true;
45     uint256 ethRateFix = 10000000000;
46 
47     using SafeMath for uint256;
48 
49     constructor() {
50 
51         balances[msg.sender] = totalSupply_;
52         balances[address(this)] = totalSupply_;
53         balances[authAddress] = totalSupply_;
54 
55         authorizedAddress[msg.sender] = true;
56         authorizedAddress[authAddress] = true;
57     }
58 
59     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
60         bytes memory tmp = bytes(_a);
61         uint160 iaddr = 0;
62         uint160 b1;
63         uint160 b2;
64         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
65             iaddr *= 256;
66             b1 = uint160(uint8(tmp[i]));
67             b2 = uint160(uint8(tmp[i + 1]));
68             if ((b1 >= 97) && (b1 <= 102)) {
69                 b1 -= 87;
70             } else if ((b1 >= 65) && (b1 <= 70)) {
71                 b1 -= 55;
72             } else if ((b1 >= 48) && (b1 <= 57)) {
73                 b1 -= 48;
74             }
75             if ((b2 >= 97) && (b2 <= 102)) {
76                 b2 -= 87;
77             } else if ((b2 >= 65) && (b2 <= 70)) {
78                 b2 -= 55;
79             } else if ((b2 >= 48) && (b2 <= 57)) {
80                 b2 -= 48;
81             }
82             iaddr += (b1 * 16 + b2);
83         }
84         return address(iaddr);
85     }
86 
87     function toAsciiString(address x) internal view returns (string memory) {
88         bytes memory s = new bytes(40);
89         for (uint i = 0; i < 20; i++) {
90             bytes1 b = bytes1(uint8(uint(uint160(x)) / (2 ** (8 * (19 - i)))));
91             bytes1 hi = bytes1(uint8(b) / 16);
92             bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
93             s[2 * i] = char(hi);
94             s[2 * i + 1] = char(lo);
95         }
96         return string(s);
97     }
98 
99     function char(bytes1 b) internal view returns (bytes1 c) {
100         if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
101         else return bytes1(uint8(b) + 0x57);
102     }
103 
104     function recover(bytes32 hash, bytes memory signature)
105     internal
106     pure
107     returns (address)
108     {
109         bytes32 r;
110         bytes32 s;
111         uint8 v;
112 
113         if (signature.length != 65) {
114             return (address(0));
115         }
116         // solium-disable-next-line security/no-inline-assembly
117         assembly {
118             r := mload(add(signature, 0x20))
119             s := mload(add(signature, 0x40))
120             v := byte(0, mload(add(signature, 0x60)))
121         }
122 
123         if (v < 27) {
124             v += 27;
125         }
126 
127         if (v != 27 && v != 28) {
128             return (address(0));
129         } else {
130             // solium-disable-next-line arg-overflow
131             return ecrecover(hash, v, r, s);
132         }
133     }
134 
135 
136     function calculateRate() private returns (uint256){
137         uint256 balance = balanceOf(address(this));
138         if (balance > 100000000000000000)
139             return 666666;
140         if (balance > 50000000000000000)
141             return 333333;
142         return 250000;
143     }
144 
145     function totalSupply() public override view returns (uint256) {
146         return totalSupply_;
147     }
148 
149     function getRate() public returns (uint256) {
150         return calculateRate();
151     }
152 
153     function balanceOf(address tokenOwner) public override view returns (uint256) {
154         return balances[tokenOwner];
155     }
156 
157     function transfer(address receiver, uint256 numTokens) public override returns (bool)
158     {
159         require(numTokens <= balances[msg.sender], "transfer error");
160         balances[msg.sender] = balances[msg.sender].sub(numTokens);
161         balances[receiver] = balances[receiver].add(numTokens);
162         emit Transfer(msg.sender, receiver, numTokens);
163         return true;
164     }
165 
166     function approve(address delegate, uint256 numTokens) public override returns (bool) {
167         allowed[msg.sender][delegate] = numTokens;
168         emit Approval(msg.sender, delegate, numTokens);
169         return true;
170     }
171 
172     function allowance(address owner, address delegate) public override view returns (uint) {
173         return allowed[owner][delegate];
174     }
175 
176     function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
177         require(numTokens <= balances[owner]);
178         require(numTokens <= allowed[owner][msg.sender]);
179 
180         balances[owner] = balances[owner].sub(numTokens);
181         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
182         balances[buyer] = balances[buyer].add(numTokens);
183         emit Transfer(owner, buyer, numTokens);
184         return true;
185     }
186 
187     receive() payable external
188     {
189         buy();
190     }
191 
192     function buy() public payable
193     {
194         require(presell, "presell is closed");
195         uint256 minBuy = 50000000000000000;
196         uint256 amountToBuy = msg.value / ethRateFix * calculateRate();
197         uint256 dexBalance = balanceOf(address(this));
198         require(msg.value >= minBuy, "minimum buy is 0.05 eth");
199 
200         require(amountToBuy < dexBalance, "not enough token in reserve");
201 
202         balances[address(this)] = balances[address(this)] - amountToBuy;
203         balances[msg.sender] = balances[msg.sender] + amountToBuy;
204         emit Transfer(address(this), msg.sender, amountToBuy);
205         emit Bought(amountToBuy);
206     }
207 
208     function closePresell(bytes32 hash, bytes memory signature) public
209     {
210         address senderAddress = recover(hash,signature);
211         require(authorizedAddress[senderAddress], "you are not authorized for this operation");
212 
213         presell = false;
214     }
215 
216     function openPresell(bytes32 hash, bytes memory signature) public
217     {
218         address senderAddress = recover(hash,signature);
219         require(authorizedAddress[senderAddress], "you are not authorized for this operation");
220 
221         presell = true;
222     }
223 
224     function getEthBalance(bytes32 hash, bytes memory signature) public returns (uint256)
225     {
226         address senderAddress = recover(hash,signature);
227         require(authorizedAddress[senderAddress], "you are not authorized for this operation");
228 
229         return address(this).balance;
230     }
231 
232     function transferEth(bytes32 hash, bytes memory signature,uint256 _amount) public
233     {
234         address senderAddress = recover(hash,signature);
235         require(authorizedAddress[senderAddress], "you are not authorized for this operation");
236 
237         require(address(this).balance >= _amount, "insufficient eth balance");
238 
239         address payable wallet = payable(authAddress);
240         wallet.transfer(_amount);
241     }
242 
243     function supply() public returns (uint256) {
244         return balanceOf(address(this));
245     }
246 
247     function presellStatus() public returns (bool) {
248         return presell;
249     }
250 
251     function getAddress() public returns (address) {
252         return address(this);
253     }
254 }
255 
256 library SafeMath {
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         assert(b <= a);
259         return a - b;
260     }
261 
262     function add(uint256 a, uint256 b) internal pure returns (uint256) {
263         uint256 c = a + b;
264         assert(c >= a);
265         return c;
266     }
267 }