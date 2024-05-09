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
30   bool internal transferLock;
31   bool internal depositLock;
32   mapping (address => bool) public allowedAddress;
33   mapping (address => bool) public blockedAddress;
34   mapping (address => uint256) public tempLockedAddress;
35 
36   mapping (address => uint256) public balanceOf;
37 
38   constructor() public
39   {
40     name = "GMB";
41     symbol = "GMB";
42     decimals = 18;
43     _decimals = 10 ** uint256(decimals);
44     totalSupply = _decimals * 5000000000;
45     transferLock = true;
46     depositLock = true;
47     owner =  msg.sender;
48     balanceOf[owner] = totalSupply;
49     allowedAddress[owner] = true;
50     watchdog = 0xC124570F91c00105bF8ccD56c03405997918fbd8;
51   }
52 }
53 
54 contract Modifiers is Variable
55 {
56   address public newWatchdog;
57   address public newOwner;
58 
59   modifier isOwner
60   {
61     assert(owner == msg.sender);
62     _;
63   }
64 
65   modifier isValidAddress
66   {
67     assert(0x0 != msg.sender);
68     _;
69   }
70 
71   modifier isWatchdog
72   {
73     assert(watchdog == msg.sender);
74     _;
75   }
76 
77   function transferOwnership(address _newOwner) public isWatchdog
78   {
79       newOwner = _newOwner;
80   }
81 
82   function transferOwnershipWatchdog(address _newWatchdog) public isOwner
83   {
84       newWatchdog = _newWatchdog;
85   }
86 
87   function acceptOwnership() public isOwner
88   {
89       require(newOwner != 0x0);
90       owner = newOwner;
91       newOwner = address(0);
92   }
93 
94   function acceptOwnershipWatchdog() public isWatchdog
95   {
96       require(newWatchdog != 0x0);
97       watchdog = newWatchdog;
98       newWatchdog = address(0);
99   }
100 }
101 
102 contract Event
103 {
104   event Transfer(address indexed from, address indexed to, uint256 value);
105   event Deposit(address indexed sender, uint256 amount , string status);
106   event TokenBurn(address indexed from, uint256 value);
107   event TokenAdd(address indexed from, uint256 value);
108   event BlockedAddress(address blockedAddress);
109 }
110 
111 contract manageAddress is Variable, Modifiers, Event
112 {
113   function add_allowedAddress(address _address) public isOwner
114   {
115     allowedAddress[_address] = true;
116   }
117 
118   function add_blockedAddress(address _address) public isOwner
119   {
120     require(_address != owner);
121     blockedAddress[_address] = true;
122     emit BlockedAddress(_address);
123   }
124 
125   function delete_allowedAddress(address _address) public isOwner
126   {
127     require(_address != owner);
128     allowedAddress[_address] = false;
129   }
130 
131   function delete_blockedAddress(address _address) public isOwner
132   {
133     blockedAddress[_address] = false;
134   }
135 }
136 
137 contract Admin is Variable, Modifiers, Event
138 {
139   function admin_transferFrom(address _from, uint256 _value) public isOwner returns(bool success)
140   {
141     require(balanceOf[_from] >= _value);
142     require(balanceOf[owner] + (_value ) >= balanceOf[owner]);
143     balanceOf[_from] -= _value;
144     balanceOf[owner] += _value;
145     emit Transfer(_from, owner, _value);
146     return true;
147   }
148   function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
149   {
150     require(balanceOf[msg.sender] >= _value);
151     balanceOf[msg.sender] -= _value;
152     totalSupply -= _value;
153     emit TokenBurn(msg.sender, _value);
154     return true;
155   }
156   function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)
157   {
158     balanceOf[msg.sender] += _value;
159     totalSupply += _value;
160     emit TokenAdd(msg.sender, _value);
161     return true;
162   }
163 }
164 
165 contract Get is Variable, Modifiers
166 {
167   function get_transferLock() public view returns(bool)
168   {
169     return transferLock;
170   }
171   function get_depositLock() public view returns(bool)
172   {
173     return depositLock;
174   }
175 }
176 
177 contract Set is Variable, Modifiers, Event
178 {
179   function setTransferLock(bool _transferLock) public isOwner returns(bool success)
180   {
181     transferLock = _transferLock;
182     return true;
183   }
184   function setDepositLock(bool _depositLock) public isOwner returns(bool success)
185   {
186     depositLock = _depositLock;
187     return true;
188   }
189 }
190 
191 contract GMB is Variable, Event, Get, Set, Admin, manageAddress
192 {
193   using safeMath for uint256;
194 
195   function() payable public
196   {
197     revert();
198   }
199   function transfer(address _to, uint256 _value) public isValidAddress
200   {
201     require(allowedAddress[msg.sender] || transferLock == false);
202     require(!blockedAddress[msg.sender] && !blockedAddress[_to]);
203     require(balanceOf[msg.sender] >= _value);
204     require((balanceOf[_to].add(_value)) >= balanceOf[_to]);
205     balanceOf[msg.sender] -= _value;
206     balanceOf[_to] += _value;
207     emit Transfer(msg.sender, _to, _value);
208   }
209 }