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
20 
21   uint256 internal _decimals;
22   bool internal transferLock;
23   
24   mapping (address => bool) public allowedAddress;
25   mapping (address => bool) public blockedAddress;
26 
27   mapping (address => uint256) public balanceOf;
28 
29   constructor() public
30   {
31     name = "STA";
32     symbol = "STA";
33     decimals = 18;
34     _decimals = 10 ** uint256(decimals);
35     totalSupply = _decimals * 5200000000;
36     transferLock = true;
37     owner =  msg.sender;
38     balanceOf[owner] = totalSupply;
39     allowedAddress[owner] = true;
40   }
41 }
42 
43 contract Modifiers is Variable
44 {
45   modifier isOwner
46   {
47     assert(owner == msg.sender);
48     _;
49   }
50 }
51 
52 contract Event
53 {
54   event Transfer(address indexed from, address indexed to, uint256 value);
55   event TokenBurn(address indexed from, uint256 value);
56 }
57 
58 contract manageAddress is Variable, Modifiers, Event
59 {
60   function add_allowedAddress(address _address) public isOwner
61   {
62     allowedAddress[_address] = true;
63   }
64   function delete_allowedAddress(address _address) public isOwner
65   {
66     require(_address != owner);
67     allowedAddress[_address] = false;
68   }
69   function add_blockedAddress(address _address) public isOwner
70   {
71     require(_address != owner);
72     blockedAddress[_address] = true;
73   }
74   function delete_blockedAddress(address _address) public isOwner
75   {
76     blockedAddress[_address] = false;
77   }
78 }
79 contract Admin is Variable, Modifiers, Event
80 {
81   function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
82   {
83     require(balanceOf[msg.sender] >= _value);
84     balanceOf[msg.sender] -= _value;
85     totalSupply -= _value;
86     emit TokenBurn(msg.sender, _value);
87     return true;
88   }
89 }
90 contract Get is Variable, Modifiers
91 {
92   function get_transferLock() public view returns(bool)
93   {
94     return transferLock;
95   }
96   function get_blockedAddress(address _address) public view returns(bool)
97   {
98     return blockedAddress[_address];
99   }
100 }
101 
102 contract Set is Variable, Modifiers, Event
103 {
104   function setTransferLock(bool _transferLock) public isOwner returns(bool success)
105   {
106     transferLock = _transferLock;
107     return true;
108   }
109 }
110 
111 contract STA is Variable, Event, Get, Set, Admin, manageAddress
112 {
113   using SafeMath for uint256;
114 
115   function() external payable 
116   {
117     revert();
118   }
119   
120   function transfer(address _to, uint256 _value) public
121   {
122     require(allowedAddress[msg.sender] || transferLock == false);
123     require(!blockedAddress[msg.sender] && !blockedAddress[_to]);
124     require(balanceOf[msg.sender] >= _value && _value > 0);
125     require((balanceOf[_to].add(_value)) >= balanceOf[_to] );
126     
127     balanceOf[msg.sender] -= _value;
128     balanceOf[_to] += _value;
129     emit Transfer(msg.sender, _to, _value);
130   }
131 }