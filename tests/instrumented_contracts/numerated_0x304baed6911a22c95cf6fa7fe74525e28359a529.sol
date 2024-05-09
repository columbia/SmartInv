1 pragma solidity 0.4.24;
2 
3 // Created for conduction of leadrex ICO - https://leadrex.io/
4 // Copying in whole or in part is prohibited.
5 // Authors: https://loftchain.io/
6 
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a / b;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract owned {
34     address public owner;
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address newOwner) onlyOwner public {
46         owner = newOwner;
47     }
48 }
49 
50 interface tokenRecipient {
51     function receiveApproval(
52         address _from,
53         uint256 _value,
54         address _token,
55         bytes _extraData
56     ) external;
57 }
58 
59 contract LDX is owned {
60     using SafeMath for uint256;
61 
62     string public name = "LeadRex";
63     string public symbol = "LDX";
64     uint8 public decimals = 18;
65     uint256 DEC = 10 ** uint256(decimals);
66     uint256 public totalSupply = 135900000 * DEC;
67 
68     enum State { Active, Refunding, Closed }
69     State public state;
70 
71     struct Round {
72         uint256 _softCap;
73         uint256 _hardCap;
74         address _wallet;
75         uint256 _tokensForRound;
76         uint256 _rate;
77         uint256 _minValue;
78         uint256 _bonus1;
79         uint256 _bonus4;
80         uint256 _bonus8;
81         uint256 _bonus15;
82         uint256 _number;
83     }
84 
85     struct Deposited {
86         mapping(address => uint256) _deposited;
87     }
88 
89     mapping(uint => Round) public roundInfo;
90     mapping(uint => Deposited) allDeposited;
91 
92     Round public currentRound;
93 
94     constructor() public {
95         roundInfo[0] = Round(
96             250 * 1 ether,
97             770 * 1 ether,
98             0x950D69e56F4dFE84D0f590E0f9F1BdC6d60A46A9,
99             18600000 * DEC,
100             16200,
101             0.1 ether,
102             15,
103             20,
104             25,
105             30,
106             0
107         );
108         roundInfo[1] = Round(
109             770 * 1 ether,
110             1230 * 1 ether,
111             0x792Cf510b2082c3287C80ba3bb1616D13d2525E3,
112             21000000 * DEC,
113             13000,
114             0.1 ether,
115             10,
116             15,
117             20,
118             25,
119             1
120         );
121         roundInfo[2] = Round(
122             1230 * 1 ether,
123             1850 * 1 ether,
124             0x2382Caf2cc1122b1f13EB10155c5C7c69b88975f,
125             19000000 * DEC,
126             8200,
127             0.05 ether,
128             5,
129             10,
130             15,
131             20,
132             2
133         );
134         roundInfo[3] = Round(
135             1850 * 1 ether,
136             4620 * 1 ether,
137             0x57B1fDfE53756e71b1388EcE6cB7C045185BC71C,
138             25000000 * DEC,
139             4333,
140             0.05 ether,
141             5,
142             10,
143             15,
144             20,
145             3
146         );
147         roundInfo[4] = Round(
148             4620 * 1 ether,
149             10700 * 1 ether,
150             0xA9764d8eb302d6a3D363104B94C657849273D5CE,
151             26000000 * DEC,
152             2000,
153             0.05 ether,
154             5,
155             10,
156             15,
157             20,
158             4
159         );
160 
161         balanceOf[msg.sender] = totalSupply;
162 
163         state = State.Active;
164 
165         currentRound = roundInfo[0];
166     }
167 
168     mapping(address => uint256) public balanceOf;
169     mapping(address => mapping(address => uint256)) public allowance;
170 
171     event Transfer(address indexed from, address indexed to, uint256 value);
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173     event Burn(address indexed from, uint256 value);
174     event RefundsEnabled();
175     event Refunded(address indexed beneficiary, uint256 weiAmount);
176 
177     modifier transferredIsOn {
178         require(state != State.Active);
179         _;
180     }
181 
182     function transfer(address _to, uint256 _value) transferredIsOn public {
183         _transfer(msg.sender, _to, _value);
184     }
185 
186     function transferFrom(address _from, address _to, uint256 _value) transferredIsOn public returns (bool success) {
187         require(_value <= allowance[_from][msg.sender]);
188         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
189         _transfer(_from, _to, _value);
190         return true;
191     }
192 
193     function approve(address _spender, uint256 _value) public returns (bool success) {
194         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
195 
196         allowance[msg.sender][_spender] = _value;
197         emit Approval(msg.sender, _spender, _value);
198         return true;
199     }
200 
201     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
202     public
203     returns (bool success) {
204         tokenRecipient spender = tokenRecipient(_spender);
205         if (approve(_spender, _value)) {
206             spender.receiveApproval(msg.sender, _value, this, _extraData);
207             return true;
208         }
209     }
210 
211     function transferOwner(address _to, uint256 _value) onlyOwner public {
212         _transfer(msg.sender, _to, _value);
213     }
214 
215     function _transfer(address _from, address _to, uint _value) internal {
216         require(_to != 0x0);
217         require(balanceOf[_from] >= _value);
218         require(balanceOf[_to].add(_value) >= balanceOf[_to]);
219         balanceOf[_from] = balanceOf[_from].sub(_value);
220         balanceOf[_to] = balanceOf[_to].add(_value);
221         emit Transfer(_from, _to, _value);
222     }
223 
224     function buyTokens(address beneficiary) payable public {
225         require(state == State.Active);
226         require(msg.value >= currentRound._minValue);
227         require(currentRound._rate > 0);
228         require(address(this).balance <= currentRound._hardCap);
229         uint amount = currentRound._rate.mul(msg.value);
230         uint bonus = getBonusPercent(msg.value);
231         amount = amount.add(amount.mul(bonus).div(100));
232         require(amount <= currentRound._tokensForRound);
233 
234         _transfer(owner, msg.sender, amount);
235 
236         currentRound._tokensForRound = currentRound._tokensForRound.sub(amount);
237         uint _num = currentRound._number;
238         allDeposited[_num]._deposited[beneficiary] = allDeposited[_num]._deposited[beneficiary].add(msg.value);
239     }
240 
241     function() external payable {
242         buyTokens(msg.sender);
243     }
244 
245     function getBonusPercent(uint _value) internal view returns(uint _bonus) {
246         if (_value >= 15 ether) {
247             return currentRound._bonus15;
248         } else if (_value >= 8 ether) {
249             return currentRound._bonus8;
250         } else if (_value >= 4 ether) {
251             return currentRound._bonus4;
252         } else if (_value >= 1 ether) {
253             return currentRound._bonus1;
254         } else return 0;
255     }
256 
257     function finishRound() onlyOwner public {
258         if (address(this).balance < currentRound._softCap) {
259             enableRefunds();
260         } else {
261             currentRound._wallet.transfer(address(this).balance);
262             uint256 _nextRound = currentRound._number + 1;
263             uint256 _burnTokens = currentRound._tokensForRound;
264             balanceOf[owner] = balanceOf[owner].sub(_burnTokens);
265             if (_nextRound < 5) {
266                 currentRound = roundInfo[_nextRound];
267             } else {
268                 state = State.Closed;
269             }
270         }
271     }
272 
273     function enableRefunds() onlyOwner public {
274         require(state == State.Active);
275         state = State.Refunding;
276         emit RefundsEnabled();
277     }
278 
279     function refund(address investor) public {
280         require(state == State.Refunding);
281         require(allDeposited[currentRound._number]._deposited[investor] > 0);
282         uint256 depositedValue = allDeposited[currentRound._number]._deposited[investor];
283         allDeposited[currentRound._number]._deposited[investor] = 0;
284         investor.transfer(depositedValue);
285         emit Refunded(investor, depositedValue);
286     }
287 
288     function withdraw(uint amount) onlyOwner public returns(bool) {
289         require(amount <= address(this).balance);
290         owner.transfer(amount);
291         return true;
292     }
293 
294     function burn(uint256 _value) public returns (bool success) {
295         require(balanceOf[msg.sender] >= _value);
296         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
297         emit Burn(msg.sender, _value);
298         return true;
299     }
300 }