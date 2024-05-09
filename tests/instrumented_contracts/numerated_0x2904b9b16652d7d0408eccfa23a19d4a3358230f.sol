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
25   mapping (address => bool) public blockedAddress;
26 
27   mapping (address => uint256) public balanceOf;
28 
29   address public newWatchdog;
30   address public newOwner;
31 
32   constructor() public
33   {
34     name = "PURIEVER";
35     symbol = "PURE";
36     decimals = 18;
37     _decimals = 10 ** uint256(decimals);
38     totalSupply = _decimals * 1200000000;
39     transferLock = false;
40     owner =  msg.sender;
41     balanceOf[owner] = totalSupply;
42     watchdog = 0x1F5Ad54c24635b6c9728078a88142C0467a2FC11;
43     
44     newWatchdog = address(0);
45     newOwner = address(0);
46   }
47 }
48 
49 contract Modifiers is Variable
50 {
51 
52   modifier isOwner
53   {
54     assert(owner == msg.sender);
55     _;
56   }
57 
58   modifier isValidAddress
59   {
60     assert(address(0) != msg.sender);
61     _;
62   }
63 
64   modifier isWatchdog
65   {
66     assert(watchdog == msg.sender);
67     _;
68   }
69 
70   function transferOwnership(address _newOwner) public isWatchdog
71   {
72       newOwner = _newOwner;
73   }
74 
75   function transferOwnershipWatchdog(address _newWatchdog) public isOwner
76   {
77       newWatchdog = _newWatchdog;
78   }
79 
80   function acceptOwnership() public isOwner
81   {
82       require(newOwner != address(0));
83       owner = newOwner;
84       newOwner = address(0);
85   }
86 
87   function acceptOwnershipWatchdog() public isWatchdog
88   {
89       require(newWatchdog != address(0));
90       watchdog = newWatchdog;
91       newWatchdog = address(0);
92   }
93 }
94 
95 contract Event
96 {
97   event Transfer(address indexed from, address indexed to, uint256 value);
98   event TokenBurn(address indexed from, uint256 value);
99 }
100 
101 contract manageAddress is Variable, Modifiers, Event
102 {
103   function add_blockedAddress(address _address) public isOwner
104   {
105     require(_address != owner);
106     blockedAddress[_address] = true;
107   }
108   function delete_blockedAddress(address _address) public isOwner
109   {
110     blockedAddress[_address] = false;
111   }
112 }
113 contract Admin is Variable, Modifiers, Event
114 {
115   function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
116   {
117     require(balanceOf[msg.sender] >= _value);
118     balanceOf[msg.sender] -= _value;
119     totalSupply -= _value;
120     emit TokenBurn(msg.sender, _value);
121     return true;
122   }
123 }
124 contract Get is Variable, Modifiers
125 {
126   function get_transferLock() public view returns(bool)
127   {
128     return transferLock;
129   }
130   function get_blockedAddress(address _address) public view returns(bool)
131   {
132     return blockedAddress[_address];
133   }
134 }
135 
136 contract Set is Variable, Modifiers, Event
137 {
138   function setTransferLock(bool _transferLock) public isOwner returns(bool success)
139   {
140     transferLock = _transferLock;
141     return true;
142   }
143 }
144 
145 contract PURE is Variable, Event, Get, Set, manageAddress
146 {
147   using SafeMath for uint256;
148 
149   function() external payable 
150   {
151     revert();
152   }
153   
154   function transfer(address _to, uint256 _value) public isValidAddress
155   {
156     require(transferLock == false);
157     require(!blockedAddress[msg.sender] && !blockedAddress[_to]);
158     require(balanceOf[msg.sender] >= _value && _value > 0);
159     require((balanceOf[_to].add(_value)) >= balanceOf[_to] );
160     
161     balanceOf[msg.sender] -= _value;
162     balanceOf[_to] += _value;
163     emit Transfer(msg.sender, _to, _value);
164   }
165 }