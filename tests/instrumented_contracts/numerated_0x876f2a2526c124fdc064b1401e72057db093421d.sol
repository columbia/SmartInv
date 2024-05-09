1 contract MultiAsset {
2     function isCreated(bytes32 _symbol) constant returns(bool);
3     function owner(bytes32 _symbol) constant returns(address);
4     function totalSupply(bytes32 _symbol) constant returns(uint);
5     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint);
6     function transfer(address _to, uint _value, bytes32 _symbol) returns(bool);
7     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
8     function proxyTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool);
9     function proxyApprove(address _spender, uint _value, bytes32 _symbol) returns(bool);
10     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint);
11     function transferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
12     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool);
13     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
14     function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool);
15     function proxySetCosignerAddress(address _address, bytes32 _symbol) returns(bool);
16 }
17 
18 contract Safe {
19     // Should always be placed as first modifier!
20     modifier noValue {
21         if (msg.value > 0) {
22             // Internal Out Of Gas/Throw: revert this transaction too;
23             // Call Stack Depth Limit reached: revert this transaction too;
24             // Recursive Call: safe, no any changes applied yet, we are inside of modifier.
25             _safeSend(msg.sender, msg.value);
26         }
27         _
28     }
29 
30     modifier onlyHuman {
31         if (_isHuman()) {
32             _
33         }
34     }
35 
36     modifier noCallback {
37         if (!isCall) {
38             _
39         }
40     }
41 
42     modifier immutable(address _address) {
43         if (_address == 0) {
44             _
45         }
46     }
47 
48     address stackDepthLib;
49     function setupStackDepthLib(address _stackDepthLib) immutable(address(stackDepthLib)) returns(bool) {
50         stackDepthLib = _stackDepthLib;
51         return true;
52     }
53 
54     modifier requireStackDepth(uint16 _depth) {
55         if (stackDepthLib == 0x0) {
56             throw;
57         }
58         if (_depth > 1023) {
59             throw;
60         }
61         if (!stackDepthLib.delegatecall(0x32921690, stackDepthLib, _depth)) {
62             throw;
63         }
64         _
65     }
66 
67     // Must not be used inside the functions that have noValue() modifier!
68     function _safeFalse() internal noValue() returns(bool) {
69         return false;
70     }
71 
72     function _safeSend(address _to, uint _value) internal {
73         if (!_unsafeSend(_to, _value)) {
74             throw;
75         }
76     }
77 
78     function _unsafeSend(address _to, uint _value) internal returns(bool) {
79         return _to.call.value(_value)();
80     }
81 
82     function _isContract() constant internal returns(bool) {
83         return msg.sender != tx.origin;
84     }
85 
86     function _isHuman() constant internal returns(bool) {
87         return !_isContract();
88     }
89 
90     bool private isCall = false;
91     function _setupNoCallback() internal {
92         isCall = true;
93     }
94 
95     function _finishNoCallback() internal {
96         isCall = false;
97     }
98 }
99 
100 contract BitHryvna is Safe {
101     event Transfer(address indexed from, address indexed to, uint value);
102     event Approve(address indexed from, address indexed spender, uint value);
103 
104     MultiAsset public multiAsset;
105     bytes32 public symbol;
106 
107     function init(address _multiAsset, bytes32 _symbol) noValue() immutable(address(multiAsset)) returns(bool) {
108         MultiAsset ma = MultiAsset(_multiAsset);
109         if (!ma.isCreated(_symbol)) {
110             return false;
111         }
112         multiAsset = ma;
113         symbol = _symbol;
114         return true;
115     }
116 
117     modifier onlyMultiAsset() {
118         if (msg.sender == address(multiAsset)) {
119             _
120         }
121     }
122 
123     function totalSupply() constant returns(uint) {
124         return multiAsset.totalSupply(symbol);
125     }
126 
127     function balanceOf(address _owner) constant returns(uint) {
128         return multiAsset.balanceOf(_owner, symbol);
129     }
130 
131     function allowance(address _from, address _spender) constant returns(uint) {
132         return multiAsset.allowance(_from, _spender, symbol);
133     }
134 
135     function transfer(address _to, uint _value) returns(bool) {
136         return __transferWithReference(_to, _value, "");
137     }
138 
139     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
140         return __transferWithReference(_to, _value, _reference);
141     }
142 
143     function __transferWithReference(address _to, uint _value, string _reference) private noValue() returns(bool) {
144         return _isHuman() ?
145             multiAsset.proxyTransferWithReference(_to, _value, symbol, _reference) :
146             multiAsset.transferFromWithReference(msg.sender, _to, _value, symbol, _reference);
147     }
148 
149     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
150         return __transferToICAPWithReference(_icap, _value, "");
151     }
152 
153     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
154         return __transferToICAPWithReference(_icap, _value, _reference);
155     }
156 
157     function __transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) private noValue() returns(bool) {
158         return _isHuman() ?
159             multiAsset.proxyTransferToICAPWithReference(_icap, _value, _reference) :
160             multiAsset.transferFromToICAPWithReference(msg.sender, _icap, _value, _reference);
161     }
162     
163     function transferFrom(address _from, address _to, uint _value) returns(bool) {
164         return __transferFromWithReference(_from, _to, _value, "");
165     }
166 
167     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
168         return __transferFromWithReference(_from, _to, _value, _reference);
169     }
170 
171     function __transferFromWithReference(address _from, address _to, uint _value, string _reference) private noValue() onlyHuman() returns(bool) {
172         return multiAsset.proxyTransferFromWithReference(_from, _to, _value, symbol, _reference);
173     }
174 
175     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
176         return __transferFromToICAPWithReference(_from, _icap, _value, "");
177     }
178 
179     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
180         return __transferFromToICAPWithReference(_from, _icap, _value, _reference);
181     }
182 
183     function __transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) private noValue() onlyHuman() returns(bool) {
184         return multiAsset.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference);
185     }
186 
187     function approve(address _spender, uint _value) noValue() onlyHuman() returns(bool) {
188         return multiAsset.proxyApprove(_spender, _value, symbol);
189     }
190 
191     function setCosignerAddress(address _cosigner) noValue() onlyHuman() returns(bool) {
192         return multiAsset.proxySetCosignerAddress(_cosigner, symbol);
193     }
194 
195     function emitTransfer(address _from, address _to, uint _value) onlyMultiAsset() {
196         Transfer(_from, _to, _value);
197     }
198 
199     function emitApprove(address _from, address _spender, uint _value) onlyMultiAsset() {
200         Approve(_from, _spender, _value);
201     }
202 
203     function sendToOwner() noValue() returns(bool) {
204         address owner = multiAsset.owner(symbol);
205         uint balance = this.balance;
206         bool success = true;
207         if (balance > 0) {
208             success = _unsafeSend(owner, balance);
209         }
210         return multiAsset.transfer(owner, balanceOf(owner), symbol) && success;
211     }
212 }