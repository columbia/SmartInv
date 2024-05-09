1 pragma solidity >=0.4.4;
2 
3 // Copyright 2017 Alchemy Limited LLC, Do not distribute
4 
5 contract Constants {
6     uint DECIMALS = 8;
7 }
8 
9 
10 contract Owned {
11     address public owner;
12 
13     modifier onlyOwner() {
14         if (msg.sender != owner) throw;
15         _;
16     }
17 
18     address newOwner;
19 
20     function changeOwner(address _newOwner) onlyOwner {
21         newOwner = _newOwner;
22     }
23 
24     function acceptOwnership() {
25         if (msg.sender == newOwner) {
26             owner = newOwner;
27         }
28     }
29 }
30 
31 //from Zeppelin
32 contract SafeMath {
33     function safeMul(uint a, uint b) internal returns (uint) {
34         uint c = a * b;
35         assert(a == 0 || c / a == b);
36         return c;
37     }
38 
39     function safeSub(uint a, uint b) internal returns (uint) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function safeAdd(uint a, uint b) internal returns (uint) {
45         uint c = a + b;
46         assert(c>=a && c>=b);
47         return c;
48     }
49 
50     function assert(bool assertion) internal {
51         if (!assertion) throw;
52     }
53 }
54 
55 
56 
57 //Copyright 2017 Alchemy Limited LLC DO not distribute
58 //ERC20 token
59 
60 contract Token is SafeMath, Owned, Constants {
61     uint public currentSupply;
62     uint public remainingOwner;
63     uint public remainingAuctionable;
64     uint public ownerTokensFreeDay;
65     bool public launched = false;
66 
67     bool public remaindersSet = false;
68     bool public mintingDone = false;
69 
70     address public controller;
71 
72     string public name;
73     uint8 public decimals;
74     string public symbol;
75 
76     modifier onlyController() {
77         if (msg.sender != controller) throw;
78         _;
79     }
80 
81     modifier isLaunched() {
82         assert(launched == true);
83         _;
84     }
85 
86     modifier onlyPayloadSize(uint numwords) {
87         assert(msg.data.length == numwords * 32 + 4);
88         _;
89     }
90 
91     function Token() {
92         owner = msg.sender;
93         name = "Monolith TKN";
94         decimals = uint8(DECIMALS);
95         symbol = "TKN";
96     }
97 
98     function Launch() onlyOwner {
99         launched = true;
100     }
101 
102     function setOwnerFreeDay(uint day) onlyOwner {
103         if (ownerTokensFreeDay != 0) throw;
104 
105         ownerTokensFreeDay = day;
106     }
107 
108     function totalSupply() constant returns(uint) {
109         return currentSupply + remainingOwner;
110     }
111 
112     function setRemainders(uint _remainingOwner, uint _remainingAuctionable) onlyOwner {
113         if (remaindersSet) { throw; }
114 
115         remainingOwner = _remainingOwner;
116         remainingAuctionable = _remainingAuctionable;
117     }
118 
119     function finalizeRemainders() onlyOwner {
120         remaindersSet = true;
121     }
122 
123     function setController(address _controller) onlyOwner {
124         controller = _controller;
125     }
126 
127     function claimOwnerSupply() onlyOwner {
128         if (now < ownerTokensFreeDay) throw;
129         if (remainingOwner == 0) throw;
130         if (!remaindersSet) throw; // must finalize remainders
131 
132         balanceOf[owner] = safeAdd(balanceOf[owner], remainingOwner);
133         remainingOwner = 0;
134     }
135 
136     function claimAuctionableTokens(uint amount) onlyController {
137         if (amount > remainingAuctionable) throw;
138 
139         balanceOf[controller] = safeAdd(balanceOf[controller], amount);
140         currentSupply = safeAdd(currentSupply, amount);
141         remainingAuctionable = safeSub(remainingAuctionable,amount);
142 
143         Transfer(0, controller, amount);
144     }
145 
146     event Transfer(address indexed from, address indexed to, uint value);
147     event Approval(address indexed owner, address indexed spender, uint value);
148 
149     function mint(address addr, uint amount) onlyOwner onlyPayloadSize(2) {
150         if (mintingDone) throw;
151 
152         balanceOf[addr] = safeAdd(balanceOf[addr], amount);
153 
154         currentSupply = safeAdd(currentSupply, amount);
155 
156         Transfer(0, addr, amount);
157     }
158 
159 
160     uint constant D160 = 0x0010000000000000000000000000000000000000000;
161 
162     // We don't use safe math in this function
163     // because this will be called for the owner before the contract
164     // is published and we need to save gas.
165     function multiMint(uint[] data) onlyOwner {
166         if (mintingDone) throw;
167 
168         uint supplyAdd;
169         for (uint i = 0; i < data.length; i++ ) {
170             address addr = address( data[i] & (D160-1) );
171             uint amount = data[i] / D160;
172 
173             balanceOf[addr] += amount;
174             supplyAdd += amount;
175             Transfer(0, addr, amount);
176         }
177         currentSupply += supplyAdd;
178     }
179 
180     function completeMinting() onlyOwner {
181         mintingDone = true;
182     }
183 
184     mapping(address => uint) public balanceOf;
185     mapping(address => mapping (address => uint)) public allowance;
186 
187     function transfer(address _to, uint _value) isLaunched notPaused
188     onlyPayloadSize(2)
189     returns (bool success) {
190         if (balanceOf[msg.sender] < _value) return false;
191         if (_to == 0x0) return false;
192 
193         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
194         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
195         Transfer(msg.sender, _to, _value);
196         return true;
197     }
198 
199     function transferFrom(address _from, address _to, uint _value)  isLaunched notPaused
200     onlyPayloadSize(3)
201     returns (bool success) {
202         if (_to == 0x0) return false;
203         if (balanceOf[_from] < _value) return false;
204 
205         var allowed = allowance[_from][msg.sender];
206         if (allowed < _value) return false;
207 
208         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
209         balanceOf[_from] = safeSub(balanceOf[_from], _value);
210         allowance[_from][msg.sender] = safeSub(allowed, _value);
211         Transfer(_from, _to, _value);
212         return true;
213     }
214 
215     function approve(address _spender, uint _value)
216     onlyPayloadSize(2)
217     returns (bool success) {
218         //require user to set to zero before resetting to nonzero
219         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) {
220             return false;
221         }
222 
223         allowance[msg.sender][_spender] = _value;
224         Approval(msg.sender, _spender, _value);
225         return true;
226     }
227 
228     function increaseApproval (address _spender, uint _addedValue)
229     onlyPayloadSize(2)
230     returns (bool success) {
231         uint oldValue = allowance[msg.sender][_spender];
232         allowance[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
233         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
234         return true;
235     }
236 
237     function decreaseApproval (address _spender, uint _subtractedValue)
238     onlyPayloadSize(2)
239     returns (bool success) {
240         uint oldValue = allowance[msg.sender][_spender];
241         if (_subtractedValue > oldValue) {
242             allowance[msg.sender][_spender] = 0;
243         } else {
244             allowance[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
245         }
246         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
247         return true;
248     }
249 
250     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
251     ///  its behalf, and then a function is triggered in the contract that is
252     ///  being approved, `_spender`. This allows users to use their tokens to
253     ///  interact with contracts in one function call instead of two
254     /// @param _spender The address of the contract able to transfer the tokens
255     /// @param _amount The amount of tokens to be approved for transfer
256     /// @return True if the function call was successful
257     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
258     ) returns (bool success) {
259         if (!approve(_spender, _amount)) throw;
260 
261         ApproveAndCallFallBack(_spender).receiveApproval(
262             msg.sender,
263             _amount,
264             this,
265             _extraData
266         );
267 
268         return true;
269     }
270 
271     //Holds accumulated dividend tokens other than TKN
272     TokenHolder public tokenholder;
273 
274     //once locked, can no longer upgrade tokenholder
275     bool public lockedTokenHolder;
276 
277     function lockTokenHolder() onlyOwner {
278         lockedTokenHolder = true;
279     }
280 
281     function setTokenHolder(address _th) onlyOwner {
282         if (lockedTokenHolder) throw;
283         tokenholder = TokenHolder(_th);
284     }
285 
286     function burn(uint _amount) notPaused returns (bool result)  {
287         if (_amount > balanceOf[msg.sender]) return false;
288 
289         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _amount);
290         currentSupply  = safeSub(currentSupply, _amount);
291         result = tokenholder.burn(msg.sender, _amount);
292         if (!result) throw;
293         Transfer(msg.sender, 0, _amount);
294     }
295 
296     // Peterson's Law Protection
297     event logTokenTransfer(address token, address to, uint amount);
298 
299     function claimTokens(address _token) onlyOwner {
300         if (_token == 0x0) {
301             owner.transfer(this.balance);
302             return;
303         }
304 
305         Token token = Token(_token);
306         uint balance = token.balanceOf(this);
307         token.transfer(owner, balance);
308         logTokenTransfer(_token, owner, balance);
309     }
310 
311     // Pause mechanism
312 
313     bool public pausingMechanismLocked = false;
314     bool public paused = false;
315 
316     modifier notPaused() {
317         if (paused) throw;
318         _;
319     }
320 
321     function pause() onlyOwner {
322         if (pausingMechanismLocked) throw;
323         paused = true;
324     }
325 
326     function unpause() onlyOwner {
327         if (pausingMechanismLocked) throw;
328         paused = false;
329     }
330 
331     function neverPauseAgain() onlyOwner {
332         pausingMechanismLocked = true;
333     }
334 }
335 
336 contract TokenHolder {
337     function burn(address , uint )
338     returns (bool result) {
339         return false;
340     }
341 }
342 
343 contract ApproveAndCallFallBack {
344     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
345 }