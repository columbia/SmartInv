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
34 
35   mapping (address => uint256) public balanceOf;
36 
37   constructor() public
38   {
39     name = "FAS CHAIN";
40     symbol = "FAS";
41     decimals = 18;
42     _decimals = 10 ** uint256(decimals);
43     totalSupply = _decimals * 3600000000;
44     transferLock = true;
45     depositLock = true;
46     owner =  msg.sender;
47     balanceOf[owner] = totalSupply;
48     allowedAddress[owner] = true;
49     watchdog = 0x1fbbf98b345c82325baa7514c37d2050d84bd949;
50   }
51 }
52 
53 contract Modifiers is Variable
54 {
55   address public newWatchdog;
56   address public newOwner;
57 
58   modifier isOwner
59   {
60     assert(owner == msg.sender);
61     _;
62   }
63 
64   modifier isValidAddress
65   {
66     assert(0x0 != msg.sender);
67     _;
68   }
69 
70   modifier isWatchdog
71   {
72     assert(watchdog == msg.sender);
73     _;
74   }
75 
76   function transferOwnership(address _newOwner) public isWatchdog
77   {
78       newOwner = _newOwner;
79   }
80 
81   function transferOwnershipWatchdog(address _newWatchdog) public isOwner
82   {
83       newWatchdog = _newWatchdog;
84   }
85 
86   function acceptOwnership() public isOwner
87   {
88       require(newOwner != 0x0);
89       owner = newOwner;
90       newOwner = address(0);
91   }
92 
93   function acceptOwnershipWatchdog() public isWatchdog
94   {
95       require(newWatchdog != 0x0);
96       watchdog = newWatchdog;
97       newWatchdog = address(0);
98   }
99 }
100 
101 contract Event
102 {
103   event Transfer(address indexed from, address indexed to, uint256 value);
104   event Deposit(address indexed sender, uint256 amount , string status);
105   event TokenBurn(address indexed from, uint256 value);
106   event TokenAdd(address indexed from, uint256 value);
107   event BlockedAddress(address blockedAddress);
108 }
109 
110 contract manageAddress is Variable, Modifiers, Event
111 {
112   function add_allowedAddress(address _address) public isOwner
113   {
114     allowedAddress[_address] = true;
115   }
116 
117   function add_blockedAddress(address _address) public isOwner
118   {
119     require(_address != owner);
120     blockedAddress[_address] = true;
121     emit BlockedAddress(_address);
122   }
123 
124   function delete_allowedAddress(address _address) public isOwner
125   {
126     require(_address != owner);
127     allowedAddress[_address] = false;
128   }
129 
130   function delete_blockedAddress(address _address) public isOwner
131   {
132     blockedAddress[_address] = false;
133   }
134 }
135 
136 contract Admin is Variable, Modifiers, Event
137 {
138   function admin_transferFrom(address _from, uint256 _value) public isOwner returns(bool success)
139   {
140     require(balanceOf[_from] >= _value);
141     require(balanceOf[owner] + (_value ) >= balanceOf[owner]);
142     balanceOf[_from] -= _value;
143     balanceOf[owner] += _value;
144     emit Transfer(_from, owner, _value);
145     return true;
146   }
147   function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
148   {
149     require(balanceOf[msg.sender] >= _value);
150     balanceOf[msg.sender] -= _value;
151     totalSupply -= _value;
152     emit TokenBurn(msg.sender, _value);
153     return true;
154   }
155   function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)
156   {
157     balanceOf[msg.sender] += _value;
158     totalSupply += _value;
159     emit TokenAdd(msg.sender, _value);
160     return true;
161   }
162 }
163 
164 contract Get is Variable, Modifiers
165 {
166   function get_transferLock() public view returns(bool)
167   {
168     return transferLock;
169   }
170   function get_depositLock() public view returns(bool)
171   {
172     return depositLock;
173   }
174 }
175 
176 contract Set is Variable, Modifiers, Event
177 {
178   function setTransferLock(bool _transferLock) public isOwner returns(bool success)
179   {
180     transferLock = _transferLock;
181     return true;
182   }
183   function setDepositLock(bool _depositLock) public isOwner returns(bool success)
184   {
185     depositLock = _depositLock;
186     return true;
187   }
188 }
189 
190 contract FAS is Variable, Event, Get, Set, Admin, manageAddress
191 {
192   using safeMath for uint256;
193 
194   function() payable public
195   {
196     revert();
197   }
198   function transfer(address _to, uint256 _value) public isValidAddress
199   {
200     require(allowedAddress[msg.sender] || transferLock == false);
201     require(!blockedAddress[msg.sender] && !blockedAddress[_to]);
202     require(balanceOf[msg.sender] >= _value);
203     require((balanceOf[_to].add(_value)) >= balanceOf[_to]);
204     balanceOf[msg.sender] -= _value;
205     balanceOf[_to] += _value;
206     emit Transfer(msg.sender, _to, _value);
207   }
208 }