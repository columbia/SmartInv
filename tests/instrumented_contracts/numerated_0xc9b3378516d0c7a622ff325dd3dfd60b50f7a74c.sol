1 pragma solidity >=0.4.4;
2 
3 //from Zeppelin
4 contract SafeMath {
5     function safeMul(uint a, uint b) internal returns (uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeSub(uint a, uint b) internal returns (uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function safeAdd(uint a, uint b) internal returns (uint) {
17         uint c = a + b;
18         assert(c>=a && c>=b);
19         return c;
20     }
21 
22     function assert(bool assertion) internal {
23         if (!assertion) throw;
24     }
25 }
26 
27 contract Owned {
28     address public owner;
29 
30     function Owned() {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner() {
35         if (msg.sender != owner) throw;
36         _;
37     }
38 
39     address newOwner;
40 
41     function changeOwner(address _newOwner) onlyOwner {
42         newOwner = _newOwner;
43     }
44 
45     function acceptOwnership() {
46         if (msg.sender == newOwner) {
47             owner = newOwner;
48         }
49     }
50 }
51 
52 contract Finalizable is Owned {
53     bool public finalized;
54 
55     function finalize() onlyOwner {
56         finalized = true;
57     }
58 
59     modifier notFinalized() {
60         if (finalized) throw;
61         _;
62     }
63 }
64 
65 contract IToken {
66     function transfer(address _to, uint _value) returns (bool);
67     function balanceOf(address owner) returns(uint);
68 }
69 
70 contract TokenReceivable is Owned {
71     event logTokenTransfer(address token, address to, uint amount);
72 
73     function claimTokens(address _token, address _to) onlyOwner returns (bool) {
74         IToken token = IToken(_token);
75         uint balance = token.balanceOf(this);
76         if (token.transfer(_to, balance)) {
77             logTokenTransfer(_token, _to, balance);
78             return true;
79         }
80         return false;
81     }
82 }
83 
84 contract EventDefinitions {
85     event Transfer(address indexed from, address indexed to, uint value);
86     event Approval(address indexed owner, address indexed spender, uint value);
87 }
88 
89 contract Token is Finalizable, TokenReceivable, SafeMath, EventDefinitions {
90 
91     string public name = "FunFair";
92     uint8 public decimals = 8;
93     string public symbol = "FUN";
94 
95     Controller controller;
96     address owner;
97 
98     function setController(address _c) onlyOwner notFinalized {
99         controller = Controller(_c);
100     }
101 
102     function balanceOf(address a) constant returns (uint) {
103         return controller.balanceOf(a);
104     }
105 
106     function totalSupply() constant returns (uint) {
107         return controller.totalSupply();
108     }
109 
110     function allowance(address _owner, address _spender) constant returns (uint) {
111         return controller.allowance(_owner, _spender);
112     }
113 
114     function transfer(address _to, uint _value)
115     onlyPayloadSize(2)
116     returns (bool success) {
117        success = controller.transfer(msg.sender, _to, _value);
118         if (success) {
119             Transfer(msg.sender, _to, _value);
120         }
121     }
122 
123     function transferFrom(address _from, address _to, uint _value)
124     onlyPayloadSize(3)
125     returns (bool success) {
126        success = controller.transferFrom(msg.sender, _from, _to, _value);
127         if (success) {
128             Transfer(_from, _to, _value);
129         }
130     }
131 
132     function approve(address _spender, uint _value)
133     onlyPayloadSize(2)
134     returns (bool success) {
135         //promote safe user behavior
136         if (controller.allowance(msg.sender, _spender) > 0) throw;
137 
138         success = controller.approve(msg.sender, _spender, _value);
139         if (success) {
140             Approval(msg.sender, _spender, _value);
141         }
142     }
143 
144     function increaseApproval (address _spender, uint _addedValue)
145     onlyPayloadSize(2)
146     returns (bool success) {
147         success = controller.increaseApproval(msg.sender, _spender, _addedValue);
148         if (success) {
149             uint newval = controller.allowance(msg.sender, _spender);
150             Approval(msg.sender, _spender, newval);
151         }
152     }
153 
154     function decreaseApproval (address _spender, uint _subtractedValue)
155     onlyPayloadSize(2)
156     returns (bool success) {
157         success = controller.decreaseApproval(msg.sender, _spender, _subtractedValue);
158         if (success) {
159             uint newval = controller.allowance(msg.sender, _spender);
160             Approval(msg.sender, _spender, newval);
161         }
162     }
163 
164     modifier onlyPayloadSize(uint numwords) {
165     assert(msg.data.length == numwords * 32 + 4);
166         _;
167     }
168 
169 }
170 
171 contract Controller is Owned, Finalizable {
172     Ledger public ledger;
173     address public token;
174 
175     function setToken(address _token) onlyOwner {
176         token = _token;
177     }
178 
179     function setLedger(address _ledger) onlyOwner {
180         ledger = Ledger(_ledger);
181     }
182 
183     modifier onlyToken() {
184         if (msg.sender != token) throw;
185         _;
186     }
187 
188     function totalSupply() constant returns (uint) {
189         return ledger.totalSupply();
190     }
191 
192     function balanceOf(address _a) onlyToken constant returns (uint) {
193         return Ledger(ledger).balanceOf(_a);
194     }
195 
196     function allowance(address _owner, address _spender)
197     onlyToken constant returns (uint) {
198         return ledger.allowance(_owner, _spender);
199     }
200 
201     function transfer(address _from, address _to, uint _value)
202     onlyToken
203     returns (bool success) {
204         return ledger.transfer(_from, _to, _value);
205     }
206 
207     function transferFrom(address _spender, address _from, address _to, uint _value)
208     onlyToken
209     returns (bool success) {
210         return ledger.transferFrom(_spender, _from, _to, _value);
211     }
212 
213     function approve(address _owner, address _spender, uint _value)
214     onlyToken
215     returns (bool success) {
216         return ledger.approve(_owner, _spender, _value);
217     }
218 
219     function increaseApproval (address _owner, address _spender, uint _addedValue)
220     onlyToken
221     returns (bool success) {
222         return ledger.increaseApproval(_owner, _spender, _addedValue);
223     }
224 
225     function decreaseApproval (address _owner, address _spender, uint _subtractedValue)
226     onlyToken
227     returns (bool success) {
228         return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
229     }
230 }
231 
232 contract Ledger is Owned, SafeMath, Finalizable {
233     address public controller;
234     mapping(address => uint) public balanceOf;
235     mapping (address => mapping (address => uint)) public allowance;
236     uint public totalSupply;
237 
238     function setController(address _controller) onlyOwner notFinalized {
239         controller = _controller;
240     }
241 
242     modifier onlyController() {
243         if (msg.sender != controller) throw;
244         _;
245     }
246 
247     function transfer(address _from, address _to, uint _value)
248     onlyController
249     returns (bool success) {
250         if (balanceOf[_from] < _value) return false;
251 
252         balanceOf[_from] = safeSub(balanceOf[_from], _value);
253         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
254         return true;
255     }
256 
257     function transferFrom(address _spender, address _from, address _to, uint _value)
258     onlyController
259     returns (bool success) {
260         if (balanceOf[_from] < _value) return false;
261 
262         var allowed = allowance[_from][_spender];
263         if (allowed < _value) return false;
264 
265         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
266         balanceOf[_from] = safeSub(balanceOf[_from], _value);
267         allowance[_from][_spender] = safeSub(allowed, _value);
268         return true;
269     }
270 
271     function approve(address _owner, address _spender, uint _value)
272     onlyController
273     returns (bool success) {
274         //require user to set to zero before resetting to nonzero
275         if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
276             return false;
277         }
278 
279         allowance[_owner][_spender] = _value;
280         return true;
281     }
282 
283     function increaseApproval (address _owner, address _spender, uint _addedValue)
284     onlyController
285     returns (bool success) {
286         uint oldValue = allowance[_owner][_spender];
287         allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
288         return true;
289     }
290 
291     function decreaseApproval (address _owner, address _spender, uint _subtractedValue)
292     onlyController
293     returns (bool success) {
294         uint oldValue = allowance[_owner][_spender];
295         if (_subtractedValue > oldValue) {
296             allowance[_owner][_spender] = 0;
297         } else {
298             allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
299         }
300         return true;
301     }
302 
303     function mint(address _a, uint _amount) onlyOwner notFinalized {
304         balanceOf[_a] = safeAdd(balanceOf[_a], _amount);
305         totalSupply = safeAdd(totalSupply, _amount);
306     }
307 
308     function multiMint(uint[] bits) onlyOwner notFinalized {
309         for (uint i=0; i<bits.length; i++) {
310 	    address a = address(bits[i]>>96);
311 	    uint amount = bits[i]&((1<<96) - 1);
312 	    mint(a, amount);
313         }
314     }
315 }