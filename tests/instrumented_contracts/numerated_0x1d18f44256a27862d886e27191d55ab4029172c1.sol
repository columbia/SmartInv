1 pragma solidity ^0.4.20;
2 
3 // solc -v : 0.4.23+commit.124ca40d.Emscripten.clang
4 
5 library safeMath
6 {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256)
8   {
9     if(a==0) return 0;
10     uint256 c = a * b;
11     require(c / a == b);
12     return c;
13   }
14 
15   function add(uint256 a, uint256 b) internal pure returns (uint256)
16   {
17     uint256 c = a + b;
18     require(c >= a);
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     require(b <= a);
24     uint256 c = a - b;
25 
26     return c;
27   }
28 
29   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b != 0);
31     return a % b;
32   }
33 }
34 
35 contract Event
36 {
37   event Transfer(address indexed from, address indexed to, uint256 value);
38   event Deposit(address indexed sender, uint256 amount);
39   event TokenBurn(address indexed from, uint256 value);
40   event TokenAdd(address indexed from, uint256 value);
41   event Set_TokenReward(uint256 changedTokenReward);
42   event Set_DepositPeriod(uint256 startingTime, uint256 closingTime);
43   event WithdrawETH(uint256 amount);
44   event BlockedAddress(address blockedAddress);
45   event TempLockedAddress(address tempLockAddress, uint256 unlockTime);
46 }
47 
48 contract Variable
49 {
50   string public name;
51   string public symbol;
52   uint256 public decimals;
53   uint256 public totalSupply;
54   address public owner;
55   uint256 internal _decimals;
56   uint256 internal tokenReward;
57   uint256 internal startingTime;
58   uint256 internal closingTime;
59   bool internal transferLock;
60   bool internal depositLock;
61   mapping (address => bool) public allowedAddress;
62   mapping (address => bool) public blockedAddress;
63   mapping (address => uint256) public tempLockedAddress;
64 
65   address withdraw_wallet;
66   mapping (address => uint256) public balanceOf;
67 
68 
69   constructor() public
70   {
71     name = "FAS";
72     symbol = "FAS";
73     decimals = 18;
74     _decimals = 10 ** uint256(decimals);
75     tokenReward = 0;
76     totalSupply = _decimals * 3600000000;
77     startingTime = 0;// 18.01.01 00:00:00 1514732400;
78     closingTime = 0;// 18.12.31 23.59.59 1546268399;
79     transferLock = true;
80     depositLock = true;
81     owner =  0x562C15Bb5Bd14Ed949b0dab50CcC45f75A9484CD;
82     balanceOf[owner] = totalSupply;
83     allowedAddress[owner] = true;
84     withdraw_wallet = 0x562C15Bb5Bd14Ed949b0dab50CcC45f75A9484CD;
85   }
86 }
87 
88 contract Modifiers is Variable
89 {
90   modifier isOwner
91   {
92     assert(owner == msg.sender);
93     _;
94   }
95 
96   modifier isValidAddress
97   {
98     assert(0x0 != msg.sender);
99     _;
100   }
101 }
102 
103 contract Set is Variable, Modifiers, Event
104 {
105   function setTokenReward(uint256 _tokenReward) public isOwner returns(bool success)
106   {
107     tokenReward = _tokenReward;
108     emit Set_TokenReward(tokenReward);
109     return true;
110   }
111   function setDepositPeriod(uint256 _startingTime,uint256 _closingTime) public isOwner returns(bool success)
112   {
113     startingTime = _startingTime;
114     closingTime = _closingTime;
115 
116     emit Set_DepositPeriod(startingTime, closingTime);
117     return true;
118   }
119   function setTransferLock(bool _transferLock) public isOwner returns(bool success)
120   {
121     transferLock = _transferLock;
122     return true;
123   }
124   function setDepositLock(bool _depositLock) public isOwner returns(bool success)
125   {
126     depositLock = _depositLock;
127     return true;
128   }
129 }
130 
131 contract manageAddress is Variable, Modifiers, Event
132 {
133 
134   function add_allowedAddress(address _address) public isOwner
135   {
136     allowedAddress[_address] = true;
137   }
138 
139   function add_blockedAddress(address _address) public isOwner
140   {
141     require(_address != owner);
142     blockedAddress[_address] = true;
143     emit BlockedAddress(_address);
144   }
145 
146   function delete_allowedAddress(address _address) public isOwner
147   {
148     require(_address != owner);
149     allowedAddress[_address] = false;
150   }
151 
152   function delete_blockedAddress(address _address) public isOwner
153   {
154     blockedAddress[_address] = false;
155   }
156 }
157 
158 contract Get is Variable, Modifiers
159 {
160   function get_tokenTime() public view returns(uint256 start, uint256 stop)
161   {
162     return (startingTime,closingTime);
163   }
164   function get_transferLock() public view returns(bool)
165   {
166     return transferLock;
167   }
168   function get_depositLock() public view returns(bool)
169   {
170     return depositLock;
171   }
172   function get_tokenReward() public view returns(uint256)
173   {
174     return tokenReward;
175   }
176 
177 }
178 
179 contract Admin is Variable, Modifiers, Event
180 {
181   using safeMath for uint256;
182 
183   function admin_transfer_tempLockAddress(address _to, uint256 _value, uint256 _unlockTime) public isOwner returns(bool success)
184   {
185     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
186     balanceOf[_to] = balanceOf[_to].add(_value);
187     tempLockedAddress[_to] = _unlockTime;
188     emit Transfer(msg.sender, _to, _value);
189     emit TempLockedAddress(_to, _unlockTime);
190     return true;
191   }
192   function admin_transferFrom(address _from, address _to, uint256 _value) public isOwner returns(bool success)
193   {
194     balanceOf[_from] = balanceOf[_from].sub(_value);
195     balanceOf[_to] = balanceOf[_to].add(_value);
196     emit Transfer(_from, _to, _value);
197     return true;
198   }
199   function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
200   {
201     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
202     totalSupply = totalSupply.sub(_value);
203     emit TokenBurn(msg.sender, _value);
204     return true;
205   }
206   function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)
207   {
208     balanceOf[msg.sender] = balanceOf[msg.sender].add(_value);
209     totalSupply = totalSupply.add(_value);
210     emit TokenAdd(msg.sender, _value);
211     return true;
212   }
213   function admin_renewLockedAddress(address _address, uint256 _unlockTime) public isOwner returns(bool success)
214   {
215     tempLockedAddress[_address] = _unlockTime;
216     emit TempLockedAddress(_address, _unlockTime);
217     return true;
218   }
219 }
220 
221 contract FAS is Variable, Event, Get, Set, Admin, manageAddress
222 {
223   using safeMath for uint256;
224 
225   function() payable public
226   {
227     require(startingTime < block.timestamp && closingTime > block.timestamp);
228     require(!depositLock);
229     uint256 tokenValue;
230     tokenValue = (msg.value).mul(tokenReward);
231     emit Deposit(msg.sender, msg.value);
232     balanceOf[owner] = balanceOf[owner].sub(tokenValue);
233     balanceOf[msg.sender] = balanceOf[msg.sender].add(tokenValue);
234     emit Transfer(owner, msg.sender, tokenValue);
235   }
236   function transfer(address _to, uint256 _value) public isValidAddress
237   {
238     require(allowedAddress[msg.sender] || transferLock == false);
239     require(tempLockedAddress[msg.sender] < block.timestamp);
240     require(!blockedAddress[msg.sender] && !blockedAddress[_to]);
241     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
242     balanceOf[_to] = balanceOf[_to].add(_value);
243     emit Transfer(msg.sender, _to, _value);
244   }
245   function withdraw(uint256 amount) public isOwner returns(bool)
246   {
247     withdraw_wallet.transfer(amount);
248     emit WithdrawETH(amount);
249     return true;
250   }
251 }