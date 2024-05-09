1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint a, uint b) internal pure returns (uint) {
6         uint c = a * b;
7         require(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint a, uint b) internal pure returns (uint) {
12         uint c = a / b;
13         return c;
14     }
15 
16     function sub(uint a, uint b) internal pure returns (uint) {
17         require(b <= a);
18         return a - b;
19     }
20 
21     function add(uint a, uint b) internal pure returns (uint) {
22         uint c = a + b;
23         require(c >= a);
24         return c;
25     }
26 
27     function max(uint a, uint b) internal pure returns (uint) {
28         return a >= b ? a : b;
29     }
30 
31     function min(uint a, uint b) internal pure returns (uint) {
32         return a < b ? a : b;
33     }
34 
35 }
36 
37 // @title The Contract is EDR Standard Token Design.
38 //
39 // @Author: Tim Wars
40 // @Date: 2018.8.3
41 // @Seealso: ERC20
42 //
43 contract IscToken {
44 
45     // === Event ===
46     event Transfer(address indexed from, address indexed to, uint value);
47     event Approval(address indexed owner, address indexed spender, uint value);
48     event Burn(address indexed from, uint value);
49 	event Owner(address indexed from, address indexed to);
50     event TransferEdrIn(address indexed from, uint value);
51     event TransferEdrOut(address indexed from, uint value);
52 
53     // === Defined ===
54     using SafeMath for uint;
55 
56     // --- Owner Section ---
57     address public owner;
58     bool public frozen = false; //
59 
60     // --- ERC20 EDR Token Section ---
61     uint8 constant public decimals = 5;
62     uint public totalSupply = 1000 * 10 ** (8+uint256(decimals));  // ***** 1 * 100 Million
63     string constant public name = "ISChain Token";
64     string constant public symbol = "ISC";
65 
66     mapping(address => uint) ownerance; // Owner Balance
67     mapping(address => mapping(address => uint)) public allowance; // Allower Balance
68 
69     // --- EDR Token Section ---
70     address private EDRADDR  = 0x245580fc423Bd82Ab531d325De0Ba5ff8Ec79402;
71 
72     uint public edrBalance; // Current EDR hold EDR balance
73     uint public totalCirculating; // Total EDR out circulating
74 
75 
76     // === Modifier ===
77     // --- Functional Section ---
78     modifier onlyPayloadSize(uint size) {
79       assert(msg.data.length == size + 4);
80       _;
81     }
82 
83     // --- Owner Section ---
84     modifier isOwner() {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     modifier isNotFrozen() {
90         require(!frozen);
91         _;
92     }
93 
94     // --- ERC20 Section ---
95     modifier hasEnoughBalance(uint _amount) {
96         require(ownerance[msg.sender] >= _amount);
97         _;
98     }
99 
100     modifier overflowDetected(address _owner, uint _amount) {
101         require(ownerance[_owner] + _amount >= ownerance[_owner]);
102         _;
103     }
104 
105     modifier hasAllowBalance(address _owner, address _allower, uint _amount) {
106         require(allowance[_owner][_allower] >= _amount);
107         _;
108     }
109 
110     modifier isNotEmpty(address _addr, uint _value) {
111         require(_addr != address(0));
112         require(_value != 0);
113         _;
114     }
115 
116     modifier isValidAddress {
117         assert(0x0 != msg.sender);
118         _;
119     }
120 
121     // === Constructor ===
122     constructor() public {
123         owner = msg.sender;
124         ownerance[EDRADDR] = totalSupply;
125         edrBalance = totalSupply;
126         totalCirculating = 0;
127         emit Transfer(address(0), EDRADDR, totalSupply);
128     }
129 
130 
131     // --- ERC20 Token Section ---
132     function approve(address _spender, uint _value)
133         isNotFrozen
134         isValidAddress
135         public returns (bool success)
136     {
137         require(_value == 0 || allowance[msg.sender][_spender] == 0); // must spend to 0 where pre approve balance.
138         allowance[msg.sender][_spender] = _value;
139         emit Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     function transferFrom(address _from, address _to, uint _value)
144         isNotFrozen
145         isValidAddress
146         overflowDetected(_to, _value)
147         public returns (bool success)
148     {
149         require(ownerance[_from] >= _value);
150         require(allowance[_from][msg.sender] >= _value);
151 
152         ownerance[_to] = ownerance[_to].add(_value);
153         ownerance[_from] = ownerance[_from].sub(_value);
154         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
155         emit Transfer(_from, _to, _value);
156         return true;
157     }
158 
159     function balanceOf(address _owner) public
160         constant returns (uint balance)
161     {
162         return ownerance[_owner];
163     }
164 
165     function transfer(address _to, uint _value) public
166         isNotFrozen
167         isValidAddress
168         isNotEmpty(_to, _value)
169         hasEnoughBalance(_value)
170         overflowDetected(_to, _value)
171         onlyPayloadSize(2 * 32)
172         returns (bool success)
173     {
174         ownerance[msg.sender] = ownerance[msg.sender].sub(_value);
175         ownerance[_to] = ownerance[_to].add(_value);
176         emit Transfer(msg.sender, _to, _value);
177         if (msg.sender == EDRADDR) {
178             totalCirculating = totalCirculating.add(_value);
179             edrBalance = totalSupply - totalCirculating;
180             emit TransferEdrOut(_to, _value);
181         }
182         if (_to == EDRADDR) {
183             totalCirculating = totalCirculating.sub(_value);
184             edrBalance = totalSupply - totalCirculating;
185             emit TransferEdrIn(_to, _value);
186         }
187         return true;
188     }
189 
190     // --- Owner Section ---
191     function transferOwner(address _newOwner)
192         isOwner
193         public returns (bool success)
194     {
195         if (_newOwner != address(0)) {
196             owner = _newOwner;
197             emit Owner(msg.sender, owner);
198         }
199         return true;
200     }
201 
202     function freeze()
203         isOwner
204         public returns (bool success)
205     {
206         frozen = true;
207         return true;
208     }
209 
210     function unfreeze()
211         isOwner
212         public returns (bool success)
213     {
214         frozen = false;
215         return true;
216     }
217 
218     function burn(uint _value)
219         isNotFrozen
220         isValidAddress
221         hasEnoughBalance(_value)
222         public returns (bool success)
223     {
224         ownerance[msg.sender] = ownerance[msg.sender].sub(_value);
225         ownerance[0x0] = ownerance[0x0].add(_value);
226         totalSupply = totalSupply.sub(_value);
227         totalCirculating = totalCirculating.sub(_value);
228         emit Burn(msg.sender, _value);
229         return true;
230     }
231 
232     // --- Extension Section ---
233     function transferMultiple(address[] _dests, uint[] _values)
234         isNotFrozen
235         isValidAddress
236         public returns (uint)
237     {
238         uint i = 0;
239         if (msg.sender == EDRADDR) {
240             while (i < _dests.length) {
241                 require(ownerance[msg.sender] >= _values[i]);
242                 ownerance[msg.sender] = ownerance[msg.sender].sub(_values[i]);
243                 ownerance[_dests[i]] = ownerance[_dests[i]].add(_values[i]);
244                 totalCirculating = totalCirculating.add(_values[i]);
245                 emit Transfer(msg.sender, _dests[i], _values[i]);
246                 emit TransferEdrOut(_dests[i], _values[i]);
247                 i += 1;
248             }
249             edrBalance = totalSupply - totalCirculating;
250         } else {
251             while (i < _dests.length) {
252                 require(ownerance[msg.sender] >= _values[i]);
253                 ownerance[msg.sender] = ownerance[msg.sender].sub(_values[i]);
254                 ownerance[_dests[i]] = ownerance[_dests[i]].add(_values[i]);
255                 emit Transfer(msg.sender, _dests[i], _values[i]);
256                 i += 1;
257             }
258         }
259         return(i);
260     }
261 
262     // --- Edr Section ---
263     function transferEdrAddr(address _newEddr)
264         isOwner
265         isValidAddress
266         onlyPayloadSize(32)
267         public returns (bool success)
268     {
269         if (_newEddr != address(0)) {
270             address _oldaddr = EDRADDR;
271             ownerance[_newEddr] = ownerance[EDRADDR];
272             ownerance[EDRADDR] = 0;
273             EDRADDR = _newEddr;
274             emit Transfer(_oldaddr, EDRADDR, ownerance[_newEddr]);
275         }
276         return true;
277     }
278 
279 
280 }