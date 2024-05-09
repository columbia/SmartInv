1 pragma solidity ^0.4.19;
2 
3 /*
4                         ...........:??I7ZZ:......                               
5                         ......=??????7IIOOZZ=~...                               
6                    .  ..,I+?????????I7II==?ZZZO:,.. .......   .. .              
7                    ..??I:=~:~?????I7++++~:++++=?Z7~,.....,...........           
8                    .???.,,~:::::~+++++++~~=++++++++??+++?++???+.....            
9                    .?=,,,,,::::~~~+++++~~~~=+++++++I+?++?+?????????,.           
10               .....?,,,,,,,,:~:~~~?++??~~~~~++++++=??+++++?++++??+????~.......  
11               .....,,,,,,,,:?::~~~~+++~~~~~~~++++=I~:$++?+?++??+???????7?+....  
12               ...,=~~~~~~~~+I+++:~~:++=~~~~~:~+++++::::??+++++++?+????7II++.... 
13               ...?~~~~~~?+?II++++?+=?~~~~~~~~~~?+I=::::7+===+?+=+++??7III7?I... 
14               ..+?~~~~~???I??+++++++++++++~~~~~~+?:::::7===========+7IIIII7I?.. 
15               .~+~~~++???+???++++???I7?+++++++=+O,,::::I===========+I7II7777II. 
16          .....:++:~??????+?+I++??????77++++++$7~:::::::7=========?+?I777777+I?,.
17          .....?+?I++++++:7$??????????777?++Z$=:~:::::::7I++=====++?+I777777+??+.
18          ... ~???++++?,::777?I?IIII?ZZ+?$$?ZZ+~~~~::::?I7=====+?+++?7I7777?++I?.
19 . ...........+??=?++~,::::IZ?II7IIOZI????+7ZZI~~~~~:::7I7+==?+++++?+III77I+++??.
20 ...      .,=+~??+=?,::::,:Z???7~.7I77Z???+ZZZZ~~~~~~::II7=++++++++?+III77++????.
21 ,=??++++,,:=,,,:,,:,:,,.O7.......,III$$Z+?ZZZO~~~~~~+:I777II++++??+IIII7I??????~
22 .:?_1517529600_ZZI=:,7?$$........~?I777$$$?III???=~~~=$77II????????7II7$???????+
23  .. ..........?=+=+~I+7Z....... ..I?I?7ZZZIIII+++++++?I77IIII?????III$ZZ???????.
24 ..............=====?IIZ.. ..... ..II??I7IZIIII++++++??+I7IIIII?I?7I$Z$ZZ??????+.
25 . ..   ...  ..+++++=I?, .....    .7I???IIZI7II+++++????77IIIIIIII$ZZZ$ZZ?????+I.
26             ..=+++++II=.          7?I??I7ZIIII+++=+????+ZZZZ$ZZZOZZZZZZZ??????+.
27               =+=++=?I+.          $II??II$IIII+++++++++?$ZZ$ZOZ77777IZOZ?????+..
28               ,=+++=+II           +??I?7IIIIII?++??+++??....7III7777IIII?III?7..
29               .+++++??7.          ,II?I7I7ZIIII+++?+?+??....7III7777III7I+?++I. 
30               .+=++?+??.          .?III7IIZIIII+??????+?.....7III777IIIII++?+?. 
31               .+++I7???:          .IIII7IIIIIII???????+:.....I7II777III$II++I?. 
32               ..???????+.....     .=III7IIIIII?I???????.......7II77IIII7II+???. 
33               ...?I?????,.....    ..??I777III?II???????.... ..7II7II?I$$III???. 
34               ....:?I???II?77  .  ..??I7777IIIII?I????+.......:7I7II?I7$III+??. 
35                  ...???I++?++$......7II7I777III??????+,.......II7I+??$$$???$?I..
36                    ..?IIII?+?=......+III?I???????????+.......?I$$???I$?I=+~~II:.
37                    ........=?......~+=II??I7?$~~~~~:+I.......=I$Z$??IOI~====II7.
38                                   .==+?I?7I77:~:~~~~~I.....       ...Z======II. 
39                                   .:+=+I$7~?$~~~+~~~I?.....         .... ...... 
40                                   .........O:~~~~==:II.....         ..........  
41                                           ....,::~=:..                PolyETH         
42 */
43 
44 
45 library SafeMath {
46 
47     function add(uint a, uint b) internal pure returns (uint c) {
48 
49         c = a + b;
50 
51         require(c >= a);
52 
53     }
54 
55     function sub(uint a, uint b) internal pure returns (uint c) {
56 
57         require(b <= a);
58 
59         c = a - b;
60 
61     }
62 
63     function mul(uint a, uint b) internal pure returns (uint c) {
64 
65         c = a * b;
66 
67         require(a == 0 || c / a == b);
68 
69     }
70 
71     function div(uint a, uint b) internal pure returns (uint c) {
72 
73         require(b > 0);
74 
75         c = a / b;
76 
77     }
78 
79 }
80 
81 
82 
83 
84 
85 contract ERC20Interface {
86 
87     function totalSupply() public constant returns (uint);
88 
89     function balanceOf(address tokenOwner) public constant returns (uint balance);
90 
91     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
92 
93     function transfer(address to, uint tokens) public returns (bool success);
94 
95     function approve(address spender, uint tokens) public returns (bool success);
96 
97     function transferFrom(address from, address to, uint tokens) public returns (bool success);
98 
99 
100     event Transfer(address indexed from, address indexed to, uint tokens);
101 
102     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
103 
104 }
105 
106 
107 
108 
109 contract ApproveAndCallFallBack {
110 
111     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
112 
113 }
114 
115 
116 
117 contract Owned {
118 
119     address public owner;
120 
121     address public newOwner;
122 
123 
124     event OwnershipTransferred(address indexed _from, address indexed _to);
125 
126 
127     function Owned() public {
128 
129         owner = msg.sender;
130 
131     }
132 
133 
134     modifier onlyOwner {
135 
136         require(msg.sender == owner);
137 
138         _;
139 
140     }
141 
142 
143     function transferOwnership(address _newOwner) public onlyOwner {
144 
145         newOwner = _newOwner;
146 
147     }
148 
149     function acceptOwnership() public {
150 
151         require(msg.sender == newOwner);
152 
153         OwnershipTransferred(owner, newOwner);
154 
155         owner = newOwner;
156 
157         newOwner = address(0);
158 
159     }
160 
161 }
162 
163 
164 contract FixedSupplyToken is ERC20Interface, Owned {
165 
166     using SafeMath for uint;
167 
168 
169     string public symbol;
170 
171     string public  name;
172 
173     uint8 public decimals;
174 
175     uint public _totalSupply;
176 
177 
178     mapping(address => uint) balances;
179 
180     mapping(address => mapping(address => uint)) allowed;
181 
182 
183 
184     function FixedSupplyToken() public {
185 
186         symbol = "PLE";
187 
188         name = "PolyETH";
189 
190         decimals = 18;
191 
192         _totalSupply = 100000000 * 10**uint(decimals);
193 
194         balances[owner] = _totalSupply;
195 
196         Transfer(address(0), owner, _totalSupply);
197 
198     }
199 
200     function totalSupply() public constant returns (uint) {
201 
202         return _totalSupply  - balances[address(0)];
203 
204     }
205 
206 
207     function balanceOf(address tokenOwner) public constant returns (uint balance) {
208 
209         return balances[tokenOwner];
210 
211     }
212 
213 
214 
215     function transfer(address to, uint tokens) public returns (bool success) {
216 
217         balances[msg.sender] = balances[msg.sender].sub(tokens);
218 
219         balances[to] = balances[to].add(tokens);
220 
221         Transfer(msg.sender, to, tokens);
222 
223         return true;
224 
225     }
226 
227 
228 
229     function approve(address spender, uint tokens) public returns (bool success) {
230 
231         allowed[msg.sender][spender] = tokens;
232 
233         Approval(msg.sender, spender, tokens);
234 
235         return true;
236 
237     }
238 
239     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
240 
241         balances[from] = balances[from].sub(tokens);
242 
243         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
244 
245         balances[to] = balances[to].add(tokens);
246 
247         Transfer(from, to, tokens);
248 
249         return true;
250 
251     }
252 
253 
254     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
255 
256         return allowed[tokenOwner][spender];
257 
258     }
259 
260 
261     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
262 
263         allowed[msg.sender][spender] = tokens;
264 
265         Approval(msg.sender, spender, tokens);
266 
267         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
268 
269         return true;
270 
271     }
272 
273 
274     function () public payable {
275 
276         revert();
277 
278     }
279 
280 
281     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
282 
283         return ERC20Interface(tokenAddress).transfer(owner, tokens);
284 
285     }
286 
287 }