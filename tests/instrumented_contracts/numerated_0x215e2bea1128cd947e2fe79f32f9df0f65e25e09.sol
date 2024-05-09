1 pragma solidity ^0.5.17;
2 
3 library SafeMath
4 {
5   function add(uint256 a, uint256 b) internal pure returns (uint256)
6   {
7     uint256 c = a + b;
8     assert(c >= a);
9     return c;
10   }
11 }
12 
13 contract Variable
14 {
15   string public name;
16   string public symbol;
17   uint256 public decimals;
18   uint256 public totalSupply;
19   address public owner;
20   address public watchdog;
21 
22   uint256 internal _decimals;
23   bool internal transferLock;
24   
25   mapping (address => bool) public allowedAddress;
26   mapping (address => bool) public blockedAddress;
27 
28   mapping (address => uint256) public balanceOf;
29 
30   address public newWatchdog;
31   address public newOwner;
32 
33   constructor() public
34   {
35     name = "STA";
36     symbol = "STA";
37     decimals = 18;
38     _decimals = 10 ** uint256(decimals);
39     totalSupply = _decimals * 5200000000;
40     transferLock = true;
41     owner =  msg.sender;
42     balanceOf[owner] = totalSupply;
43     watchdog = 0x53A7b88a5C2888fdF1cE606D998BEC5546C68Ab1;
44     allowedAddress[owner] = true;
45     newWatchdog = address(0);
46     newOwner = address(0);
47   }
48 }
49 
50 contract Modifiers is Variable
51 {
52 
53   modifier isOwner
54   {
55     assert(owner == msg.sender);
56     _;
57   }
58 
59   modifier isValidAddress
60   {
61     assert(address(0) != msg.sender);
62     _;
63   }
64 
65   modifier isWatchdog
66   {
67     assert(watchdog == msg.sender);
68     _;
69   }
70 
71   function transferOwnership(address _newOwner) public isWatchdog
72   {
73       newOwner = _newOwner;
74   }
75 
76   function transferOwnershipWatchdog(address _newWatchdog) public isOwner
77   {
78       newWatchdog = _newWatchdog;
79   }
80 
81   function acceptOwnership() public isOwner
82   {
83       require(newOwner != address(0));
84       owner = newOwner;
85       newOwner = address(0);
86   }
87 
88   function acceptOwnershipWatchdog() public isWatchdog
89   {
90       require(newWatchdog != address(0));
91       watchdog = newWatchdog;
92       newWatchdog = address(0);
93   }
94 }
95 
96 contract Event
97 {
98   event Transfer(address indexed from, address indexed to, uint256 value);
99   event TokenBurn(address indexed from, uint256 value);
100   event TokenAdd(address indexed from, uint256 value);
101 }
102 
103 contract manageAddress is Variable, Modifiers, Event
104 {
105   function add_allowedAddress(address _address) public isOwner
106   {
107     allowedAddress[_address] = true;
108   }
109   function delete_allowedAddress(address _address) public isOwner
110   {
111     require(_address != owner);
112     allowedAddress[_address] = false;
113   }
114   function add_blockedAddress(address _address) public isOwner
115   {
116     require(_address != owner);
117     blockedAddress[_address] = true;
118   }
119   function delete_blockedAddress(address _address) public isOwner
120   {
121     blockedAddress[_address] = false;
122   }
123 }
124 contract Admin is Variable, Modifiers, Event
125 {
126   function admin_transferFrom(address _from, uint256 _value) public isOwner returns(bool success)
127   {
128     require(balanceOf[_from] >= _value);
129     require(balanceOf[owner] + (_value ) >= balanceOf[owner]);
130     balanceOf[_from] -= _value;
131     balanceOf[owner] += _value;
132     emit Transfer(_from, owner, _value);
133     return true;
134   }
135   function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)
136   {
137     balanceOf[msg.sender] += _value;
138     totalSupply += _value;
139     emit TokenAdd(msg.sender, _value);
140     return true;
141   }
142   function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
143   {
144     require(balanceOf[msg.sender] >= _value);
145     balanceOf[msg.sender] -= _value;
146     totalSupply -= _value;
147     emit TokenBurn(msg.sender, _value);
148     return true;
149   }
150 }
151 contract Get is Variable, Modifiers
152 {
153   function get_transferLock() public view returns(bool)
154   {
155     return transferLock;
156   }
157   function get_blockedAddress(address _address) public view returns(bool)
158   {
159     return blockedAddress[_address];
160   }
161 }
162 
163 contract Set is Variable, Modifiers, Event
164 {
165   function setTransferLock(bool _transferLock) public isOwner returns(bool success)
166   {
167     transferLock = _transferLock;
168     return true;
169   }
170 }
171 
172 contract STA is Variable, Event, Get, Set, Admin, manageAddress
173 {
174   using SafeMath for uint256;
175 
176   function() external payable 
177   {
178     revert();
179   }
180   
181   function transfer(address _to, uint256 _value) public isValidAddress
182   {
183 	require(allowedAddress[msg.sender] || transferLock == false);
184     require(!blockedAddress[msg.sender] && !blockedAddress[_to]);
185     require(balanceOf[msg.sender] >= _value && _value > 0);
186     require((balanceOf[_to].add(_value)) >= balanceOf[_to] );
187     
188     balanceOf[msg.sender] -= _value;
189     balanceOf[_to] += _value;
190     emit Transfer(msg.sender, _to, _value);
191   }
192 }