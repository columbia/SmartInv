1 pragma solidity ^0.4.25;
2 /**
3  * Smart contract holds Ethereum and Edgeless tokens.
4  * Ethereum is used to fund authorized casino wallets which is responsible for
5  * approving withdrawal and sending deposits to casino smart contract.
6  * Edgeless tokens is used to fund casino bankroll for users who chooses
7  * to deposit not an EDG token but crypto like BTC, ETH, etc.
8  * author: Rytis Grincevičius
9  * */
10 
11 contract SafeMath {
12     function safeSub(uint a, uint b) internal pure returns (uint) {
13         assert(b <= a);
14         return a - b;
15     }
16 
17     function safeSub(int a, int b) internal pure returns (int) {
18         if (b < 0) assert(a - b > a);
19         else assert(a - b <= a);
20         return a - b;
21     }
22 
23     function safeAdd(uint a, uint b) internal pure returns (uint) {
24         uint c = a + b;
25         assert(c >= a && c >= b);
26         return c;
27     }
28 
29     function safeMul(uint a, uint b) internal pure returns (uint) {
30         uint c = a * b;
31         assert(a == 0 || c / a == b);
32         return c;
33     }
34 }
35 
36 
37 contract Token {
38     function transfer(address receiver, uint amount) public returns (bool) {
39         (receiver);
40         (amount);
41         return false;
42     }
43 
44     function balanceOf(address holder) public view returns (uint) {
45         (holder);
46         return 0;
47     }
48 
49     function approve(address _spender, uint256 _value) public returns (bool) {
50         (_spender);
51         (_value);
52         return false;
53     }
54 }
55 
56 
57 contract Casino {
58     function deposit(address _receiver, uint _amount, bool _chargeGas) public;
59 }
60 
61 
62 contract Owned {
63     address public owner;
64     address public receiver;
65     mapping (address => bool) public moderator;
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     modifier onlyModerator {
73         require(moderator[msg.sender]);
74         _;
75     }
76 
77     modifier onlyAdmin {
78         require(moderator[msg.sender] || msg.sender == owner);
79         _;
80     }
81 
82     constructor() internal {
83         owner = msg.sender;
84         receiver = msg.sender;
85     }
86 
87     function setOwner(address _address) public onlyOwner {
88         owner = _address;
89     }
90 
91     function setReceiver(address _address) public onlyAdmin {
92         receiver = _address;
93     }
94 
95     function addModerator(address _address) public onlyOwner {
96         moderator[_address] = true;
97     }
98 
99     function removeModerator(address _address) public onlyOwner {
100         moderator[_address] = false;
101     }
102 }
103 
104 
105 contract RequiringAuthorization is Owned {
106     mapping(address => bool) public authorized;
107 
108     modifier onlyAuthorized {
109         require(authorized[msg.sender]);
110         _;
111     }
112 
113     constructor() internal {
114         authorized[msg.sender] = true;
115     }
116 
117     function authorize(address _address) public onlyAdmin {
118         authorized[_address] = true;
119     }
120 
121     function deauthorize(address _address) public onlyAdmin {
122         authorized[_address] = false;
123     }
124 
125 }
126 
127 
128 contract Pausable is Owned {
129     bool public paused = false;
130 
131     event Paused(bool _paused);
132 
133     modifier onlyPaused {
134         require(paused == true);
135         _;
136     }
137 
138     modifier onlyActive {
139         require(paused == false);
140         _;
141     }
142 
143     function pause() public onlyActive onlyAdmin {
144         paused = true;
145     }
146 
147     function activate() public onlyPaused onlyOwner {
148         paused = false;
149     }
150 }
151 
152 
153 contract BankWallet is Pausable, RequiringAuthorization, SafeMath {
154     address public edgelessToken;
155     address public edgelessCasino;
156 
157     uint public maxFundAmount = 0.22 ether;
158 
159     event Withdrawal(address _token, uint _amount);
160     event Deposit(address _receiver, uint _amount);
161     event Fund(address _receiver, uint _amount);
162 
163     constructor(address _token, address _casino) public {
164         edgelessToken = _token;
165         edgelessCasino = _casino;
166         owner = msg.sender;
167     }
168 
169     function () public payable {}
170 
171     // Allow andmin to withdraw 
172     function withdraw(address _token, uint _amount) public onlyAdmin returns (bool _success) {
173         _success = false;
174         if (_token == address (0)) {
175             uint weiAmount = _amount;
176             if (weiAmount > address(this).balance) {
177                 return false;
178             }
179             _success = receiver.send(weiAmount);
180         } else {
181             Token __token = Token(_token);
182             uint amount = _amount;
183             if (amount > __token.balanceOf(this)) {
184                 return false;
185             }
186             _success = __token.transfer(receiver, amount);
187         }
188 
189         if (_success) {
190             emit Withdrawal(_token, _amount);
191         }
192     }
193 
194     function approve(uint _amount) public onlyAuthorized {
195         _approveForCasino(edgelessCasino, _amount);
196     }
197 
198     function deposit(address _address, uint _amount, bool _chargeGas) public onlyActive onlyAuthorized {
199         Casino __casino = Casino(edgelessCasino);
200         __casino.deposit(_address, _amount, _chargeGas);
201         emit Deposit(_address, _amount);
202     }
203 
204     function fund(address _address, uint _amount) public onlyActive onlyAuthorized returns (bool _success) {
205         require(_amount <= maxFundAmount);
206         _success = _address.send(_amount);
207         if (_success) {
208             emit Fund(_address, _amount);
209         }
210     }
211 
212     function setCasinoContract(address _casino) public onlyAdmin {
213         edgelessCasino = _casino;
214         _approveForCasino(_casino, 1000000000);
215     }
216 
217     function setMaxFundAmount(uint _amount) public onlyAdmin {
218         maxFundAmount = _amount;
219     }
220 
221     function _approveForCasino(address _address, uint _amount) internal returns (bool _success) {
222         Token __token = Token(edgelessToken);
223         _success = __token.approve(_address, _amount);
224     }
225 
226 }