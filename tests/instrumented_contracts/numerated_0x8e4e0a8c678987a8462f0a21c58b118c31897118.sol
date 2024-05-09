1 pragma solidity ^0.4.20;
2 
3 library safeMath
4 {
5   function add(uint256 a, uint256 b) internal pure returns (uint256)
6   {
7     uint256 c = a + b;
8     require(c >= a);
9     return c;
10   }
11   function sub(uint256 a, uint256 b) internal pure returns (uint256)
12   {
13     require(b <= a);
14     uint256 c = a - b;
15     return c;
16   }
17   function mul(uint256 a, uint256 b) internal pure returns (uint256)
18   {
19     uint256 c = a * b;
20     require(a == 0 || c / a == b);
21     return c;
22   }
23   function div(uint256 a, uint256 b) internal pure returns (uint256)
24   {
25     require(b > 0);
26     uint256 c = a / b;
27     return c;
28   }
29   function mod(uint256 a, uint256 b) internal pure returns (uint256)
30   {
31     require(b != 0);
32     return a % b;
33   }
34 }
35 
36 contract Event
37 {
38   event Transfer(address indexed from, address indexed to, uint256 value);
39   event Deposit(address indexed sender, uint256 amount , string status);
40   event TokenBurn(address indexed from, uint256 value);
41   event TokenAdd(address indexed from, uint256 value);
42   event Set_Status(string changedStatus);
43   event Set_TokenReward(uint256 changedTokenReward);
44   event Set_TimeStamp(uint256 ico_open_time, uint256 ico_closed_time);
45   event WithdrawETH(uint256 amount);
46   event BlockedAddress(address blockedAddress);
47   event TempLockedAddress(address tempLockAddress, uint256 unlockTime);
48 }
49 
50 contract Variable
51 {
52   string public name;
53   string public symbol;
54   uint256 public decimals;
55   uint256 public totalSupply;
56   address public owner;
57   string public status;
58 
59   uint256 internal _decimals;
60   uint256 internal tokenReward;
61   uint256 internal ico_open_time;
62   uint256 internal ico_closed_time;
63   bool internal transferLock;
64   bool internal depositLock;
65 
66   mapping (address => bool) public allowedAddress;
67   mapping (address => bool) public blockedAddress;
68   mapping (address => uint256) public tempLockedAddress;
69 
70   mapping (address => uint256) public balanceOf;
71 
72   constructor() public
73   {
74     name = "PURIECO";
75     symbol = "PEC";
76     decimals = 18;
77     _decimals = 10 ** uint256(decimals);
78     tokenReward = 0;
79     totalSupply = _decimals * 8800000000;
80     status = "";
81     ico_open_time = 0; // 18.01.01 00:00:00 1514732400;
82     ico_closed_time = 0;
83     transferLock = true;
84     depositLock = true;
85     owner =  msg.sender;
86     balanceOf[owner] = totalSupply;
87     allowedAddress[owner] = true;
88   }
89 }
90 
91 contract Modifiers is Variable
92 {
93   modifier isOwner
94   {
95     require(owner == msg.sender);
96     _;
97   }
98 
99   modifier isValidAddress
100   {
101     require(0x0 != msg.sender);
102     _;
103   }
104 }
105 
106 contract Set is Variable, Modifiers, Event
107 {
108   function setStatus(string _status) public isOwner returns(bool success)
109   {
110     status = _status;
111     emit Set_Status(status);
112     return true;
113   }
114   function setTokenReward(uint256 _tokenReward) public isOwner returns(bool success)
115   {
116     tokenReward = _tokenReward;
117     emit Set_TokenReward(tokenReward);
118     return true;
119   }
120   function setTimeStamp(uint256 _ico_open_time,uint256 _ico_closed_time) public isOwner returns(bool success)
121   {
122     ico_open_time = _ico_open_time;
123     ico_closed_time = _ico_closed_time;
124 
125     emit Set_TimeStamp(ico_open_time, ico_closed_time);
126     return true;
127   }
128   function setTransferLock(bool _transferLock) public isOwner returns(bool success)
129   {
130     transferLock = _transferLock;
131     return true;
132   }
133   function setDepositLock(bool _depositLock) public isOwner returns(bool success)
134   {
135     depositLock = _depositLock;
136     return true;
137   }
138   function setTimeStampStatus(uint256 _ico_open_time, uint256 _ico_closed_time, string _status) public isOwner returns(bool success)
139   {
140     ico_open_time = _ico_open_time;
141     ico_closed_time = _ico_closed_time;
142     status = _status;
143     emit Set_TimeStamp(ico_open_time,ico_closed_time);
144     emit Set_Status(status);
145     return true;
146   }
147 }
148 
149 contract manageAddress is Variable, Modifiers, Event
150 {
151 
152   function add_allowedAddress(address _address) public isOwner
153   {
154     allowedAddress[_address] = true;
155   }
156 
157   function add_blockedAddress(address _address) public isOwner
158   {
159     require(_address != owner);
160     blockedAddress[_address] = true;
161     emit BlockedAddress(_address);
162   }
163 
164   function delete_allowedAddress(address _address) public isOwner
165   {
166     require(_address != owner);
167     allowedAddress[_address] = false;
168   }
169 
170   function delete_blockedAddress(address _address) public isOwner
171   {
172     blockedAddress[_address] = false;
173   }
174 }
175 
176 contract Get is Variable, Modifiers
177 {
178   using safeMath for uint256;
179 
180   function get_tokenTime() public view returns(uint256 start, uint256 stop)
181   {
182     return (ico_open_time,ico_closed_time);
183   }
184   function get_transferLock() public view returns(bool)
185   {
186     return transferLock;
187   }
188   function get_depositLock() public view returns(bool)
189   {
190     return depositLock;
191   }
192   function get_tokenReward() public view returns(uint256)
193   {
194     return tokenReward;
195   }
196 }
197 
198 contract Admin is Variable, Modifiers, Event
199 {
200   using safeMath for uint256;
201 
202   function admin_transfer_tempLockAddress(address _to, uint256 _value, uint256 _unlockTime) public isOwner returns(bool success)
203   {
204     require(_value > 0);
205     require(balanceOf[msg.sender] >= _value);
206     require(balanceOf[_to].add(_value) >= balanceOf[_to]);
207     balanceOf[msg.sender] -= _value;
208     balanceOf[_to] += _value;
209     tempLockedAddress[_to] = _unlockTime;
210     emit Transfer(msg.sender, _to, _value);
211     emit TempLockedAddress(_to, _unlockTime);
212     return true;
213   }
214   function admin_transferFrom(address _from, address _to, uint256 _value) public isOwner returns(bool success)
215   {
216     require(_value > 0);
217     require(balanceOf[msg.sender] >= _value);
218     balanceOf[_from] = balanceOf[_from].sub(_value);
219     balanceOf[_to] = balanceOf[_to].add(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223   function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
224   {
225     require(_value > 0);
226     require(balanceOf[msg.sender] >= _value);
227     balanceOf[msg.sender] -= _value;
228     totalSupply -= _value;
229     emit TokenBurn(msg.sender, _value);
230     return true;
231   }
232   function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)
233   {
234     require(_value > 0);
235     balanceOf[msg.sender] = balanceOf[msg.sender].add(_value);
236     totalSupply = totalSupply.add(_value);
237     emit TokenAdd(msg.sender, _value);
238     return true;
239   }
240   function admin_renewLockedAddress(address _address, uint256 _unlockTime) public isOwner returns(bool success)
241   {
242     tempLockedAddress[_address] = _unlockTime;
243     emit TempLockedAddress(_address, _unlockTime);
244     return true;
245   }
246 }
247 
248 contract PEC is Variable, Event, Get, Set, Admin, manageAddress
249 {
250   function() payable public
251   {
252     require(msg.value > 0);
253     require(ico_open_time < block.timestamp && ico_closed_time > block.timestamp);
254     require(!depositLock);
255     uint256 tokenValue;
256     tokenValue = (msg.value).mul(tokenReward);
257     require(balanceOf[owner] >= tokenValue);
258     require(balanceOf[msg.sender].add(tokenValue) >= balanceOf[msg.sender]);
259     emit Deposit(msg.sender, msg.value, status);
260     balanceOf[owner] -= tokenValue;
261     balanceOf[msg.sender] += tokenValue;
262     emit Transfer(owner, msg.sender, tokenValue);
263   }
264   function transfer(address _to, uint256 _value) public isValidAddress
265   {
266     require(!blockedAddress[msg.sender] && !blockedAddress[_to]);
267     require(_value > 0 && _to != msg.sender);
268     require(balanceOf[msg.sender] >= _value);
269     require(allowedAddress[msg.sender] || transferLock == false);
270     require(tempLockedAddress[msg.sender] < block.timestamp);
271     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
272     balanceOf[_to] = balanceOf[_to].add(_value);
273     emit Transfer(msg.sender, _to, _value);
274   }
275   function ETH_withdraw(uint256 amount) public isOwner returns(bool)
276   {
277     owner.transfer(amount);
278     emit WithdrawETH(amount);
279     return true;
280   }
281 }