1 pragma solidity ^0.4.25;
2 
3 
4 contract SafeMath {
5     function safeSub(uint a, uint b) internal pure returns (uint) {
6         assert(b <= a);
7         return a - b;
8     }
9 
10     function safeSub(int a, int b) internal pure returns (int) {
11         if (b < 0) assert(a - b > a);
12         else assert(a - b <= a);
13         return a - b;
14     }
15 
16     function safeAdd(uint a, uint b) internal pure returns (uint) {
17         uint c = a + b;
18         assert(c >= a && c >= b);
19         return c;
20     }
21 
22     function safeMul(uint a, uint b) internal pure returns (uint) {
23         uint c = a * b;
24         assert(a == 0 || c / a == b);
25         return c;
26     }
27 }
28 
29 
30 contract Token {
31     function transfer(address receiver, uint amount) public returns (bool) {
32         (receiver);
33         (amount);
34         return false;
35     }
36 
37     function balanceOf(address holder) public view returns (uint) {
38         (holder);
39         return 0;
40     }
41 
42     function approve(address _spender, uint256 _value) public returns (bool) {
43         (_spender);
44         (_value);
45         return false;
46     }
47 }
48 
49 
50 contract Casino {
51     function deposit(address _receiver, uint _amount, bool _chargeGas) public;
52 }
53 
54 
55 contract Owned {
56     address public owner;
57     address public receiver;
58     mapping (address => bool) public moderator;
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     modifier onlyModerator {
66         require(moderator[msg.sender]);
67         _;
68     }
69 
70     modifier onlyAdmin {
71         require(moderator[msg.sender] || msg.sender == owner);
72         _;
73     }
74 
75     constructor() internal {
76         owner = msg.sender;
77         receiver = msg.sender;
78     }
79 
80     function setOwner(address _address) public onlyOwner {
81         owner = _address;
82     }
83 
84     function setReceiver(address _address) public onlyAdmin {
85         receiver = _address;
86     }
87 
88     function addModerator(address _address) public onlyOwner {
89         moderator[_address] = true;
90     }
91 
92     function removeModerator(address _address) public onlyOwner {
93         moderator[_address] = false;
94     }
95 }
96 
97 
98 contract RequiringAuthorization is Owned {
99     mapping(address => bool) public authorized;
100 
101     modifier onlyAuthorized {
102         require(authorized[msg.sender]);
103         _;
104     }
105 
106     constructor() internal {
107         authorized[msg.sender] = true;
108     }
109 
110     function authorize(address _address) public onlyAdmin {
111         authorized[_address] = true;
112     }
113 
114     function deauthorize(address _address) public onlyAdmin {
115         authorized[_address] = false;
116     }
117 
118 }
119 
120 
121 contract Pausable is Owned {
122     bool public paused = false;
123 
124     event Paused(bool _paused);
125 
126     modifier onlyPaused {
127         require(paused == true);
128         _;
129     }
130 
131     modifier onlyActive {
132         require(paused == false);
133         _;
134     }
135 
136     function pause() public onlyActive onlyAdmin {
137         paused = true;
138     }
139 
140     function activate() public onlyPaused onlyOwner {
141         paused = false;
142     }
143 }
144 
145 
146 contract BankWallet is Pausable, RequiringAuthorization, SafeMath {
147     address public edgelessToken;
148     address public edgelessCasino;
149 
150     uint public maxFundAmount = 0.22 ether;
151 
152     event Withdrawal(address _token, uint _amount);
153     event Deposit(address _receiver, uint _amount);
154     event Fund(address _receiver, uint _amount);
155 
156     constructor(address _token, address _casino) public {
157         edgelessToken = _token;
158         edgelessCasino = _casino;
159         owner = msg.sender;
160     }
161 
162     function () public payable {}
163 
164     function withdraw(address _token, uint _amount) public onlyAdmin returns (bool _success) {
165         _success = false;
166         if (_token == address (0)) {
167             uint weiAmount = _amount;
168             if (weiAmount > address(this).balance) {
169                 return false;
170             }
171             _success = receiver.send(weiAmount);
172         } else {
173             Token __token = Token(_token);
174             uint amount = _amount;
175             if (amount > __token.balanceOf(this)) {
176                 return false;
177             }
178             _success = __token.transfer(receiver, amount);
179         }
180 
181         if (_success) {
182             emit Withdrawal(_token, _amount);
183         }
184     }
185 
186     function approve(uint _amount) public onlyAuthorized {
187         _approveForCasino(edgelessCasino, _amount);
188     }
189 
190     function deposit(address _address, uint _amount, bool _chargeGas) public onlyAuthorized {
191         Casino __casino = Casino(edgelessCasino);
192         __casino.deposit(_address, _amount, _chargeGas);
193         emit Deposit(_address, _amount);
194     }
195 
196     function fund(address _address, uint _amount) public onlyAuthorized returns (bool _success) {
197         require(_amount <= maxFundAmount);
198         _success = _address.send(_amount);
199         if (_success) {
200             emit Fund(_address, _amount);
201         }
202     }
203 
204     function setCasinoContract(address _casino) public onlyAdmin {
205         edgelessCasino = _casino;
206         _approveForCasino(_casino, 1000000000);
207     }
208 
209     function setMaxFundAmount(uint _amount) public onlyAdmin {
210         maxFundAmount = _amount;
211     }
212 
213     function _approveForCasino(address _address, uint _amount) internal returns (bool _success) {
214         Token __token = Token(edgelessToken);
215         _success = __token.approve(_address, _amount);
216     }
217 
218 }