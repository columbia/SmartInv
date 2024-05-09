1 pragma solidity ^0.4.16;
2 
3 // copyright contact@Etheremon.com
4 
5 contract SafeMath {
6 
7     /* function assert(bool assertion) internal { */
8     /*   if (!assertion) { */
9     /*     throw; */
10     /*   } */
11     /* }      // assert no longer needed once solidity is on 0.4.10 */
12 
13     function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {
14       uint256 z = x + y;
15       assert((z >= x) && (z >= y));
16       return z;
17     }
18 
19     function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
20       assert(x >= y);
21       uint256 z = x - y;
22       return z;
23     }
24 
25     function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {
26       uint256 z = x * y;
27       assert((x == 0)||(z/x == y));
28       return z;
29     }
30 
31 }
32 
33 contract BasicAccessControl {
34     address public owner;
35     // address[] public moderators;
36     uint16 public totalModerators = 0;
37     mapping (address => bool) public moderators;
38     bool public isMaintaining = true;
39 
40     function BasicAccessControl() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     modifier onlyModerators() {
50         require(msg.sender == owner || moderators[msg.sender] == true);
51         _;
52     }
53 
54     modifier isActive {
55         require(!isMaintaining);
56         _;
57     }
58 
59     function ChangeOwner(address _newOwner) onlyOwner public {
60         if (_newOwner != address(0)) {
61             owner = _newOwner;
62         }
63     }
64 
65 
66     function AddModerator(address _newModerator) onlyOwner public {
67         if (moderators[_newModerator] == false) {
68             moderators[_newModerator] = true;
69             totalModerators += 1;
70         }
71     }
72     
73     function RemoveModerator(address _oldModerator) onlyOwner public {
74         if (moderators[_oldModerator] == true) {
75             moderators[_oldModerator] = false;
76             totalModerators -= 1;
77         }
78     }
79 
80     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
81         isMaintaining = _isMaintaining;
82     }
83 }
84 
85 interface TokenRecipient { 
86     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
87 }
88 
89 contract TokenERC20 {
90     uint256 public totalSupply;
91 
92     mapping (address => uint256) public balanceOf;
93     mapping (address => mapping (address => uint256)) public allowance;
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96     event Burn(address indexed from, uint256 value);
97 
98     function _transfer(address _from, address _to, uint _value) internal {
99         require(_to != 0x0);
100         require(balanceOf[_from] >= _value);
101         require(balanceOf[_to] + _value > balanceOf[_to]);
102         uint previousBalances = balanceOf[_from] + balanceOf[_to];
103         balanceOf[_from] -= _value;
104         balanceOf[_to] += _value;
105         Transfer(_from, _to, _value);
106         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
107     }
108 
109     function transfer(address _to, uint256 _value) public {
110         _transfer(msg.sender, _to, _value);
111     }
112 
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
114         require(_value <= allowance[_from][msg.sender]);
115         allowance[_from][msg.sender] -= _value;
116         _transfer(_from, _to, _value);
117         return true; 
118     }
119 
120     function approve(address _spender, uint256 _value) public returns (bool success) {
121         allowance[msg.sender][_spender] = _value;
122         return true;
123     }
124 
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
126         TokenRecipient spender = TokenRecipient(_spender);
127         if (approve(_spender, _value)) {
128             spender.receiveApproval(msg.sender, _value, this, _extraData);
129             return true;
130         }
131     }
132 
133     function burn(uint256 _value) public returns (bool success) {
134         require(balanceOf[msg.sender] >= _value);
135         balanceOf[msg.sender] -= _value;
136         totalSupply -= _value;
137         Burn(msg.sender, _value);
138         return true;
139     }
140 
141     function burnFrom(address _from, uint256 _value) public returns (bool success) {
142         require(balanceOf[_from] >= _value);
143         require(_value <= allowance[_from][msg.sender]);
144         balanceOf[_from] -= _value;
145         allowance[_from][msg.sender] -= _value;
146         totalSupply -= _value;
147         Burn(_from, _value);
148         return true;
149     }
150 }
151 
152 contract PaymentInterface {
153     function createCastle(address _trainer, uint _tokens, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) public returns(uint);
154     function catchMonster(address _trainer, uint _tokens, uint32 _classId, string _name) public returns(uint);
155     function payService(address _trainer, uint _tokens, uint32 _type, string _text, uint64 _param1, uint64 _param2, uint64 _param3, uint64 _param4, uint64 _param5, uint64 _param6) public returns(uint);
156 }
157 
158 contract EtheremonToken is BasicAccessControl, TokenERC20 {
159     // metadata
160     string public constant name = "EtheremonToken";
161     string public constant symbol = "EMONT";
162     uint256 public constant decimals = 8;
163     string public version = "1.0";
164     
165     // deposit address
166     address public inGameRewardAddress;
167     address public userGrowPoolAddress;
168     address public developerAddress;
169     
170     // Etheremon payment
171     address public paymentContract;
172     
173     // for future feature
174     uint256 public sellPrice;
175     uint256 public buyPrice;
176     bool public trading = false;
177     mapping (address => bool) public frozenAccount;
178     event FrozenFunds(address target, bool frozen);
179     
180     modifier isTrading {
181         require(trading == true || msg.sender == owner);
182         _;
183     }
184     
185     modifier requirePaymentContract {
186         require(paymentContract != address(0));
187         _;        
188     }
189     
190     function () payable public {}
191 
192     // constructor    
193     function EtheremonToken(address _inGameRewardAddress, address _userGrowPoolAddress, address _developerAddress, address _paymentContract) public {
194         require(_inGameRewardAddress != address(0));
195         require(_userGrowPoolAddress != address(0));
196         require(_developerAddress != address(0));
197         inGameRewardAddress = _inGameRewardAddress;
198         userGrowPoolAddress = _userGrowPoolAddress;
199         developerAddress = _developerAddress;
200 
201         balanceOf[inGameRewardAddress] = 14000000 * 10**uint(decimals);
202         balanceOf[userGrowPoolAddress] = 5000000 * 10**uint(decimals);
203         balanceOf[developerAddress] = 1000000 * 10**uint(decimals);
204         totalSupply = balanceOf[inGameRewardAddress] + balanceOf[userGrowPoolAddress] + balanceOf[developerAddress];
205         paymentContract = _paymentContract;
206     }
207     
208     // moderators
209     function setAddress(address _inGameRewardAddress, address _userGrowPoolAddress, address _developerAddress, address _paymentContract) onlyModerators external {
210         inGameRewardAddress = _inGameRewardAddress;
211         userGrowPoolAddress = _userGrowPoolAddress;
212         developerAddress = _developerAddress;
213         paymentContract = _paymentContract;
214     }
215     
216     // public
217     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
218         if (_amount > this.balance) {
219             revert();
220         }
221         _sendTo.transfer(_amount);
222     }
223     
224     function _transfer(address _from, address _to, uint _value) internal {
225         require (_to != 0x0);
226         require (balanceOf[_from] >= _value);
227         require (balanceOf[_to] + _value > balanceOf[_to]);
228         require(!frozenAccount[_from]);
229         require(!frozenAccount[_to]);
230         balanceOf[_from] -= _value;
231         balanceOf[_to] += _value;
232         Transfer(_from, _to, _value);
233     }
234     
235     function freezeAccount(address _target, bool _freeze) onlyOwner public {
236         frozenAccount[_target] = _freeze;
237         FrozenFunds(_target, _freeze);
238     }
239     
240     function buy() payable isTrading public {
241         uint amount = msg.value / buyPrice;
242         _transfer(this, msg.sender, amount);
243     }
244 
245     function sell(uint256 amount) isTrading public {
246         require(this.balance >= amount * sellPrice);
247         _transfer(msg.sender, this, amount);
248         msg.sender.transfer(amount * sellPrice);
249     }
250     
251     // Etheremon 
252     function createCastle(uint _tokens, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requirePaymentContract external {
253         if (_tokens > balanceOf[msg.sender])
254             revert();
255         PaymentInterface payment = PaymentInterface(paymentContract);
256         uint deductedTokens = payment.createCastle(msg.sender, _tokens, _name, _a1, _a2, _a3, _s1, _s2, _s3);
257         if (deductedTokens == 0 || deductedTokens > _tokens)
258             revert();
259         _transfer(msg.sender, inGameRewardAddress, deductedTokens);
260     }
261     
262     function catchMonster(uint _tokens, uint32 _classId, string _name) isActive requirePaymentContract external {
263         if (_tokens > balanceOf[msg.sender])
264             revert();
265         PaymentInterface payment = PaymentInterface(paymentContract);
266         uint deductedTokens = payment.catchMonster(msg.sender, _tokens, _classId, _name);
267         if (deductedTokens == 0 || deductedTokens > _tokens)
268             revert();
269         _transfer(msg.sender, inGameRewardAddress, deductedTokens);
270     }
271     
272     function payService(uint _tokens, uint32 _type, string _text, uint64 _param1, uint64 _param2, uint64 _param3, uint64 _param4, uint64 _param5, uint64 _param6) isActive requirePaymentContract external {
273         if (_tokens > balanceOf[msg.sender])
274             revert();
275         PaymentInterface payment = PaymentInterface(paymentContract);
276         uint deductedTokens = payment.payService(msg.sender, _tokens, _type, _text, _param1, _param2, _param3, _param4, _param5, _param6);
277         if (deductedTokens == 0 || deductedTokens > _tokens)
278             revert();
279         _transfer(msg.sender, inGameRewardAddress, deductedTokens);
280     }
281 }