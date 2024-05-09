1 pragma solidity ^0.4.20;
2 
3 
4 library safeMath
5 {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256)
7   {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function add(uint256 a, uint256 b) internal pure returns (uint256)
13   {
14     uint256 c = a + b;
15     assert(c >= a);
16     return c;
17   }
18 }
19 
20 contract Variable
21 {
22   string public name;
23   string public symbol;
24   uint256 public decimals;
25   uint256 public totalSupply;
26   address public owner;
27   address public watchdog;
28 
29   uint256 internal _decimals;
30   uint256 internal startingTime;
31   uint256 internal closingTime;
32   bool internal transferLock;
33   bool internal depositLock;
34   mapping (address => bool) public allowedAddress;
35   mapping (address => bool) public blockedAddress;
36   mapping (address => uint256) public tempLockedAddress;
37 
38   mapping (address => uint256) public balanceOf;
39 
40   constructor() public
41   {
42     name = "GMB";
43     symbol = "GMB";
44     decimals = 18;
45     _decimals = 10 ** uint256(decimals);
46     totalSupply = _decimals * 5000000000;
47     startingTime = 0;// 18.01.01 00:00:00 1514732400;
48     closingTime = 0;// 18.12.31 23.59.59 1546268399;
49     transferLock = true;
50     depositLock = true;
51     owner =  msg.sender;
52     balanceOf[owner] = totalSupply;
53     allowedAddress[owner] = true;
54     watchdog = 0xC124570F91c00105bF8ccD56c03405997918fbd8;
55   }
56 }
57 
58 contract Modifiers is Variable
59 {
60   address public newWatchdog;
61   address public newOwner;
62 
63   modifier isOwner
64   {
65     assert(owner == msg.sender);
66     _;
67   }
68 
69   modifier isValidAddress
70   {
71     assert(0x0 != msg.sender);
72     _;
73   }
74 
75   modifier isWatchdog
76   {
77     assert(watchdog == msg.sender);
78     _;
79   }
80 
81   function transferOwnership(address _newOwner) public isWatchdog
82   {
83       newOwner = _newOwner;
84   }
85 
86   function transferOwnershipWatchdog(address _newWatchdog) public isOwner
87   {
88       newWatchdog = _newWatchdog;
89   }
90 
91   function acceptOwnership() public isOwner
92   {
93       require(newOwner != 0x0);
94       owner = newOwner;
95       newOwner = address(0);
96   }
97 
98   function acceptOwnershipWatchdog() public isWatchdog
99   {
100       require(newWatchdog != 0x0);
101       watchdog = newWatchdog;
102       newWatchdog = address(0);
103   }
104 }
105 
106 contract Event
107 {
108   event Transfer(address indexed from, address indexed to, uint256 value);
109   event Deposit(address indexed sender, uint256 amount , string status);
110   event TokenBurn(address indexed from, uint256 value);
111   event TokenAdd(address indexed from, uint256 value);
112   event Set_TimeStamp(uint256 ICO_startingTime, uint256 ICO_closingTime);
113   event BlockedAddress(address blockedAddress);
114   event TempLockedAddress(address tempLockAddress, uint256 unlockTime);
115 }
116 
117 contract manageAddress is Variable, Modifiers, Event
118 {
119   function add_allowedAddress(address _address) public isOwner
120   {
121     allowedAddress[_address] = true;
122   }
123 
124   function add_blockedAddress(address _address) public isOwner
125   {
126     require(_address != owner);
127     blockedAddress[_address] = true;
128     emit BlockedAddress(_address);
129   }
130 
131   function delete_allowedAddress(address _address) public isOwner
132   {
133     require(_address != owner);
134     allowedAddress[_address] = false;
135   }
136 
137   function delete_blockedAddress(address _address) public isOwner
138   {
139     blockedAddress[_address] = false;
140   }
141 }
142 
143 contract Admin is Variable, Modifiers, Event
144 {
145   function admin_transferFrom(address _from, uint256 _value) public isOwner returns(bool success)
146   {
147     require(balanceOf[_from] >= _value);
148     require(balanceOf[owner] + (_value ) >= balanceOf[owner]);
149     balanceOf[_from] -= _value;
150     balanceOf[owner] += _value;
151     emit Transfer(_from, owner, _value);
152     return true;
153   }
154   function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
155   {
156     require(balanceOf[msg.sender] >= _value);
157     balanceOf[msg.sender] -= _value;
158     totalSupply -= _value;
159     emit TokenBurn(msg.sender, _value);
160     return true;
161   }
162   function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)
163   {
164     balanceOf[msg.sender] += _value;
165     totalSupply += _value;
166     emit TokenAdd(msg.sender, _value);
167     return true;
168   }
169   function admin_renewLockedAddress(address _address, uint256 _unlockTime) public isOwner returns(bool success)
170   {
171     tempLockedAddress[_address] = _unlockTime;
172     emit TempLockedAddress(_address, _unlockTime);
173     return true;
174   }
175 }
176 
177 contract Get is Variable, Modifiers
178 {
179   function get_tokenTime() public view returns(uint256 start, uint256 stop)
180   {
181     return (startingTime, closingTime);
182   }
183   function get_transferLock() public view returns(bool)
184   {
185     return transferLock;
186   }
187   function get_depositLock() public view returns(bool)
188   {
189     return depositLock;
190   }
191 }
192 
193 contract Set is Variable, Modifiers, Event
194 {
195   function setTimeStamp(uint256 _startingTime,uint256 _closingTime) public isOwner returns(bool success)
196   {
197     startingTime = _startingTime;
198     closingTime = _closingTime;
199 
200     emit Set_TimeStamp(_startingTime, _closingTime);
201     return true;
202   }
203   function setTransferLock(bool _transferLock) public isOwner returns(bool success)
204   {
205     transferLock = _transferLock;
206     return true;
207   }
208   function setDepositLock(bool _depositLock) public isOwner returns(bool success)
209   {
210     depositLock = _depositLock;
211     return true;
212   }
213   function setTimeStampStatus(uint256 _startingTime, uint256 _closingTime) public isOwner returns(bool success)
214   {
215     startingTime = _startingTime;
216     closingTime = _closingTime;
217     emit Set_TimeStamp(startingTime,closingTime);
218     return true;
219   }
220 }
221 
222 contract GMB is Variable, Event, Get, Set, Admin, manageAddress
223 {
224   using safeMath for uint256;
225 
226   function() payable public
227   {
228     revert();
229   }
230   function transfer(address _to, uint256 _value) public isValidAddress
231   {
232     require(allowedAddress[msg.sender] || transferLock == false);
233     require(tempLockedAddress[msg.sender] < block.timestamp);
234     require(!blockedAddress[msg.sender] && !blockedAddress[_to]);
235     require(balanceOf[msg.sender] >= _value);
236     require((balanceOf[_to].add(_value)) >= balanceOf[_to]);
237     balanceOf[msg.sender] -= _value;
238     balanceOf[_to] += _value;
239     emit Transfer(msg.sender, _to, _value);
240   }
241 }