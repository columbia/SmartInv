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
138   function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
139   {
140     require(balanceOf[msg.sender] >= _value);
141     balanceOf[msg.sender] -= _value;
142     totalSupply -= _value;
143     emit TokenBurn(msg.sender, _value);
144     return true;
145   }
146   function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)
147   {
148     balanceOf[msg.sender] += _value;
149     totalSupply += _value;
150     emit TokenAdd(msg.sender, _value);
151     return true;
152   }
153 }
154 
155 contract Get is Variable, Modifiers
156 {
157   function get_transferLock() public view returns(bool)
158   {
159     return transferLock;
160   }
161   function get_depositLock() public view returns(bool)
162   {
163     return depositLock;
164   }
165 }
166 
167 contract Set is Variable, Modifiers, Event
168 {
169   function setTransferLock(bool _transferLock) public isOwner returns(bool success)
170   {
171     transferLock = _transferLock;
172     return true;
173   }
174   function setDepositLock(bool _depositLock) public isOwner returns(bool success)
175   {
176     depositLock = _depositLock;
177     return true;
178   }
179 }
180 
181 contract FAS is Variable, Event, Get, Set, Admin, manageAddress
182 {
183   using safeMath for uint256;
184 
185   function() payable public
186   {
187     revert();
188   }
189   function transfer(address _to, uint256 _value) public isValidAddress
190   {
191     require(allowedAddress[msg.sender] || transferLock == false);
192     require(!blockedAddress[msg.sender] && !blockedAddress[_to]);
193     require(balanceOf[msg.sender] >= _value);
194     require((balanceOf[_to].add(_value)) >= balanceOf[_to]);
195     balanceOf[msg.sender] -= _value;
196     balanceOf[_to] += _value;
197     emit Transfer(msg.sender, _to, _value);
198   }
199 }