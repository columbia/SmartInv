1 pragma solidity ^0.4.24;
2 
3 
4 contract SafeMath {
5   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b > 0);
16     uint256 c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 
32 }
33 
34 contract hopay is SafeMath {
35     address public owner;
36     string public name;
37     string public symbol;
38     uint public decimals;
39     uint256 public totalSupply;
40 
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 
47     bool lock = false;
48 
49     constructor(
50         uint256 initialSupply,
51         string tokenName,
52         string tokenSymbol,
53         uint decimalUnits
54     ) public {
55         owner = msg.sender;
56         name = tokenName;
57         symbol = tokenSymbol; 
58         decimals = decimalUnits;
59         totalSupply = initialSupply * 10 ** uint256(decimals);
60         balanceOf[msg.sender] = totalSupply;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     modifier isLock {
69         require(!lock);
70         _;
71     }
72     
73     function setLock(bool _lock) onlyOwner public{
74         lock = _lock;
75     }
76 
77     function transferOwnership(address newOwner) onlyOwner public {
78         if (newOwner != address(0)) {
79             owner = newOwner;
80         }
81     }
82  
83 
84     function _transfer(address _from, address _to, uint _value) isLock internal {
85         require (_to != 0x0);
86         require (balanceOf[_from] >= _value);
87         require (balanceOf[_to] + _value > balanceOf[_to]);
88         balanceOf[_from] -= _value;
89         balanceOf[_to] += _value;
90         emit Transfer(_from, _to, _value);
91     }
92 
93     function transfer(address _to, uint256 _value) public returns (bool success) {
94         _transfer(msg.sender, _to, _value);
95         return true;
96     }
97 
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function approve(address _spender, uint256 _value) public returns (bool success) {
106         allowance[msg.sender][_spender] = _value;
107         emit Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     function transferBatch(address[] _to, uint256 _value) public returns (bool success) {
112         for (uint i=0; i<_to.length; i++) {
113             _transfer(msg.sender, _to[i], _value);
114         }
115         return true;
116     }
117 }