1 pragma solidity ^0.4.25;
2 
3 contract ERC20Interface {
4   function transfer(address to, uint tokens) public;
5   function transferFrom(address from, address to, uint tokens) public returns (bool);
6   function balanceOf(address tokenOwner) public view returns (uint256);
7   function allowance(address tokenOwner, address spender) public view returns (uint);
8 }
9 
10 contract KNLuckyRoll{
11     address public admin;
12     uint256 exceed;
13     uint256 _seed = now;
14     event PlayResult(
15     address player,
16     string xtype,
17     uint256 betvalue,
18     bool win,
19     uint256 wonamount
20     );
21     
22     event Shake(
23     address from,
24     bytes32 make_chaos
25     );
26     
27     constructor() public{
28         admin = 0x7D5c8C59837357e541BC7d87DeE53FCbba55bA65;
29     }
30     
31     function random() private view returns (uint8) {
32         return uint8(uint256(keccak256(block.timestamp, block.difficulty, _seed))%100); // random 0-99
33     }
34     
35     function PlayX2() public payable {
36         require(msg.value >= 1);
37         require(ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).balanceOf(address(msg.sender)) >= 50000000000000000000);
38         ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).transferFrom(msg.sender, address(this), 50000000000000000000);
39         uint8 _random = random();
40 
41         if (_random + 50 >= 100) {
42             if(msg.value*97/50 < address(this).balance) {
43                 msg.sender.transfer(msg.value*97/50);
44                 uint256 winx2 = msg.value*97/50;
45                 emit PlayResult(msg.sender, "x2", msg.value, true, winx2);
46             } else {
47                 msg.sender.transfer(address(this).balance);
48                 emit PlayResult(msg.sender, "x2", msg.value, true, address(this).balance);
49             }
50         } else {
51             emit PlayResult(msg.sender, "x2", msg.value, false, 0x0);
52         }
53     }
54     
55     function PlayX3() public payable {
56         require(msg.value >= 1);
57         require(ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).balanceOf(address(msg.sender)) >= 50000000000000000000);
58         ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).transferFrom(msg.sender, address(this), 50000000000000000000);
59         uint8 _random = random();
60 
61         if (_random + 33 >= 100) {
62             if(msg.value*97/33 < address(this).balance) {
63                 msg.sender.transfer(msg.value*95/33);
64                 uint256 winx3 = msg.value*97/33;
65                 emit PlayResult(msg.sender, "x3", msg.value, true, winx3);
66             } else {
67                 msg.sender.transfer(address(this).balance);
68                 emit PlayResult(msg.sender, "x3", msg.value, true, address(this).balance);
69             }
70         } else {
71             emit PlayResult(msg.sender, "x3", msg.value, false, 0x0);
72         }
73     }
74     
75     function PlayX5() public payable {
76         require(msg.value >= 1);
77         require(ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).balanceOf(address(msg.sender)) >= 50000000000000000000);
78         ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).transferFrom(msg.sender, address(this), 50000000000000000000);
79         uint8 _random = random();
80 
81         if (_random + 20 >= 100) {
82             if(msg.value*97/20 < address(this).balance) {
83                 msg.sender.transfer(msg.value*97/20);
84                 uint256 winx5 = msg.value*97/20;
85                 emit PlayResult(msg.sender, "x5", msg.value, true, winx5);
86             } else {
87                 msg.sender.transfer(address(this).balance);
88                 emit PlayResult(msg.sender, "x5", msg.value, true, address(this).balance);
89             }
90         } else {
91             emit PlayResult(msg.sender, "x5", msg.value, false, 0x0);
92         }
93     }
94     
95     function PlayX10() public payable {
96         require(msg.value >= 1);
97         require(ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).balanceOf(address(msg.sender)) >= 50000000000000000000);
98         ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).transferFrom(msg.sender, address(this), 50000000000000000000);
99         uint8 _random = random();
100 
101         if (_random + 10 >= 100) {
102             if(msg.value*97/10 < address(this).balance) {
103                 msg.sender.transfer(msg.value*97/10);
104                 uint256 winx10 = msg.value*97/10;
105                 emit PlayResult(msg.sender, "x10", msg.value, true, winx10);
106             } else {
107                 msg.sender.transfer(address(this).balance);
108                 emit PlayResult(msg.sender, "x10", msg.value, true, address(this).balance);
109             }
110         } else {
111             emit PlayResult(msg.sender, "x10", msg.value, false, 0x0);
112         }
113     }
114     
115     function PlayX20() public payable {
116         require(msg.value >= 1);
117         require(ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).balanceOf(address(msg.sender)) >= 50000000000000000000);
118         ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).transferFrom(msg.sender, address(this), 50000000000000000000);
119         uint8 _random = random();
120 
121         if (_random + 5 >= 100) {
122             if(msg.value*97/5 < address(this).balance) {
123                 msg.sender.transfer(msg.value*97/5);
124                 uint256 winx20 = msg.value*97/5;
125                 emit PlayResult(msg.sender, "x20", msg.value, true, winx20);
126             } else {
127                 msg.sender.transfer(address(this).balance);
128                 emit PlayResult(msg.sender, "x20", msg.value, true, address(this).balance);
129             }
130         } else {
131             emit PlayResult(msg.sender, "x20", msg.value, false, 0x0);
132         }
133     }
134     
135     function PlayX30() public payable {
136         require(msg.value >= 1);
137         require(ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).balanceOf(address(msg.sender)) >= 50000000000000000000);
138         ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).transferFrom(msg.sender, address(this), 50000000000000000000);
139         uint8 _random = random();
140 
141         if (_random + 3 >= 100) {
142             if(msg.value*97/3 < address(this).balance) {
143                 msg.sender.transfer(msg.value*97/3);
144                 uint256 winx30 = msg.value*97/3;
145                 emit PlayResult(msg.sender, "x30", msg.value, true, winx30);
146             } else {
147                 msg.sender.transfer(address(this).balance);
148                 emit PlayResult(msg.sender, "x30", msg.value, true, address(this).balance);
149             }
150         } else {
151             emit PlayResult(msg.sender, "x30", msg.value, false, 0x0);
152         }
153     }
154     
155     function PlayX50() public payable {
156         require(msg.value >= 1);
157         require(ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).balanceOf(address(msg.sender)) >= 50000000000000000000);
158         ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).transferFrom(msg.sender, address(this), 50000000000000000000);
159         uint8 _random = random();
160 
161         if (_random + 2 >= 100) {
162             if(msg.value*97/2 < address(this).balance) {
163                 msg.sender.transfer(msg.value*97/2);
164                 uint256 winx50 = msg.value*97/2;
165                 emit PlayResult(msg.sender, "x50", msg.value, true, winx50);
166             } else {
167                 msg.sender.transfer(address(this).balance);
168                 emit PlayResult(msg.sender, "x50", msg.value, true, address(this).balance);
169             }
170         } else {
171             emit PlayResult(msg.sender, "x50", msg.value, false, 0x0);
172         }
173     }
174     
175     function PlayX100() public payable {
176         require(msg.value >= 1);
177         require(ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).balanceOf(address(msg.sender)) >= 50000000000000000000);
178         ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).transferFrom(msg.sender, address(this), 50000000000000000000);
179         uint8 _random = random();
180 
181         if (_random + 1 >= 100) {
182             if(msg.value*97 < address(this).balance) {
183                 msg.sender.transfer(msg.value*97);
184                 uint256 winx100 = msg.value*95;
185                 emit PlayResult(msg.sender, "x100", msg.value, true, winx100);
186             } else {
187                 msg.sender.transfer(address(this).balance);
188                 emit PlayResult(msg.sender, "x100", msg.value, true, address(this).balance);
189             }
190         } else {
191             emit PlayResult(msg.sender, "x100", msg.value, false, 0x0);
192         }
193     }
194     
195     function Playforfreetoken() public payable {
196         require(msg.value >= 0.01 ether);
197         exceed = msg.value - 0.01 ether;
198         require(ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).balanceOf(address(this)) >= 200000000000000000000);
199         ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).transfer(msg.sender, 200000000000000000000);
200         uint8 _random = random();
201 
202         if (_random + 50 >= 100) {
203             if(msg.value < address(this).balance) {
204                 msg.sender.transfer(msg.value);
205                 uint256 winfreetoken = msg.value;
206                 emit PlayResult(msg.sender, "freetoken", msg.value, true, winfreetoken);
207             } else {
208                 msg.sender.transfer(address(this).balance);
209                 emit PlayResult(msg.sender, "freetoken", msg.value, true, address(this).balance);
210             }
211         } else {
212             msg.sender.transfer(exceed);
213             emit PlayResult(msg.sender, "freetoken", msg.value, false, 0);
214         }
215     }
216     
217     function Playforbulktoken() public payable {
218         require(msg.value >= 1 ether);
219         exceed = msg.value - 1 ether;
220         require(ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).balanceOf(address(this)) >= 20000000000000000000000);
221         ERC20Interface(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d).transfer(msg.sender, 20000000000000000000000);
222         uint8 _random = random();
223 
224         if (_random + 50 >= 100) {
225             if(msg.value < address(this).balance) {
226                 msg.sender.transfer(msg.value);
227                 emit PlayResult(msg.sender, "bulktoken", msg.value, true, msg.value);
228             } else {
229                 msg.sender.transfer(address(this).balance);
230                 emit PlayResult(msg.sender, "bulktoken", msg.value, true, address(this).balance);
231             }
232         } else {
233             msg.sender.transfer(exceed);
234             emit PlayResult(msg.sender, "bulktoken", msg.value, false, 0);
235         }
236     }
237 
238     modifier onlyAdmin() {
239         // Ensure the participant awarding the ether is the admin
240         require(msg.sender == admin);
241         _;
242     }
243     
244     function withdrawEth(address to, uint256 balance) external onlyAdmin {
245         if (balance == uint256(0x0)) {
246             to.transfer(address(this).balance);
247         } else {
248         to.transfer(balance);
249         }
250     }
251     
252     function withdrawToken(address contractAddress, address to, uint256 balance) external onlyAdmin {
253         ERC20Interface erc20 = ERC20Interface(contractAddress);
254         if (balance == uint256(0x0)){
255             erc20.transfer(to, erc20.balanceOf(address(this)));
256         } else {
257             erc20.transfer(to, balance);
258         }
259     }
260     
261     function shake(uint256 choose_a_number_to_chaos_the_algo) public {
262         _seed = uint256(keccak256(choose_a_number_to_chaos_the_algo));
263         emit Shake(msg.sender, "You changed the algo");
264     }
265     
266     function () public payable {
267         require(msg.value > 0 ether);
268     }
269 }