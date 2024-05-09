1 pragma solidity ^0.4.24;
2 
3 
4 //******新能源创世链******
5 
6 
7 
8 contract SafeMath {
9   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b > 0);
20     uint256 c = a / b;
21     assert(a == b * c + a % b);
22     return c;
23   }
24 
25   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c>=a && c>=b);
33     return c;
34   }
35 
36 }
37 
38 contract NewEnergyCreationChain is SafeMath {
39     address public owner;
40     string public name;
41     string public symbol;
42     uint public decimals;
43     uint256 public totalSupply;
44 
45     mapping (address => uint256) public balanceOf;
46     mapping (address => mapping (address => uint256)) public allowance;
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Burn(address indexed from, uint256 value);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51     
52     mapping (address => bool) public frozenAccount;
53     event FrozenFunds(address target, bool frozen);
54 
55     bool lock = false;
56 
57     constructor(
58         uint256 initialSupply,
59         string tokenName,
60         string tokenSymbol,
61         uint decimalUnits
62     ) public {
63         owner = msg.sender;
64         name = tokenName;
65         symbol = tokenSymbol; 
66         decimals = decimalUnits;
67         totalSupply = initialSupply * 10 ** uint256(decimals);
68         balanceOf[msg.sender] = totalSupply;
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     modifier isLock {
77         require(!lock);
78         _;
79     }
80     
81     function setLock(bool _lock) onlyOwner public{
82         lock = _lock;
83     }
84 
85     function transferOwnership(address newOwner) onlyOwner public {
86         if (newOwner != address(0)) {
87             owner = newOwner;
88         }
89     }
90  
91 
92     function _transfer(address _from, address _to, uint _value) isLock internal {
93         require (_to != 0x0);
94         require (balanceOf[_from] >= _value);
95         require (balanceOf[_to] + _value > balanceOf[_to]);
96         require(!frozenAccount[_from]);
97         require(!frozenAccount[_to]);
98         balanceOf[_from] -= _value;
99         balanceOf[_to] += _value;
100         emit Transfer(_from, _to, _value);
101     }
102 
103     function transfer(address _to, uint256 _value) public returns (bool success) {
104         _transfer(msg.sender, _to, _value);
105         return true;
106     }
107 
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
109         require(_value <= allowance[_from][msg.sender]);
110         allowance[_from][msg.sender] -= _value;
111         _transfer(_from, _to, _value);
112         return true;
113     }
114 
115     function approve(address _spender, uint256 _value) public returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     function burn(uint256 _value) onlyOwner public returns (bool success) {
122         require(balanceOf[msg.sender] >= _value);
123         balanceOf[msg.sender] -= _value;
124         totalSupply -= _value;
125         emit Burn(msg.sender, _value);
126         return true;
127     }
128 
129     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
130         require(balanceOf[_from] >= _value); 
131         require(_value <= allowance[_from][msg.sender]); 
132         balanceOf[_from] -= _value;
133         allowance[_from][msg.sender] -= _value;
134         totalSupply -= _value;
135         emit Burn(_from, _value);
136         return true;
137     }
138 
139     
140     function freezeAccount(address target, bool freeze) onlyOwner public {
141         frozenAccount[target] = freeze;
142         emit FrozenFunds(target, freeze);
143     }
144 
145     function transferBatch(address[] _to, uint256 _value) public returns (bool success) {
146         for (uint i=0; i<_to.length; i++) {
147             _transfer(msg.sender, _to[i], _value);
148         }
149         return true;
150     }
151 }