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
34 contract WbkChainToken {
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
45     event Burn(address indexed from, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47     
48     mapping (address => bool) public frozenAccount;
49     event FrozenFunds(address target, bool frozen);
50 
51     bool lock = false;
52 
53     constructor(
54         uint256 initialSupply,
55         string tokenName,
56         string tokenSymbol,
57         uint decimalUnits
58     ) public {
59         owner = msg.sender;
60         name = tokenName;
61         symbol = tokenSymbol; 
62         decimals = decimalUnits;
63         totalSupply = initialSupply * 10 ** uint256(decimals);
64         balanceOf[msg.sender] = totalSupply;
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     modifier isLock {
73         require(!lock);
74         _;
75     }
76     
77     function setLock(bool _lock) onlyOwner public{
78         lock = _lock;
79     }
80 
81     function transferOwnership(address newOwner) onlyOwner public {
82         if (newOwner != address(0)) {
83             owner = newOwner;
84         }
85     }
86  
87 
88     function _transfer(address _from, address _to, uint _value) isLock internal {
89         require (_to != 0x0);
90         require (balanceOf[_from] >= _value);
91         require (balanceOf[_to] + _value > balanceOf[_to]);
92         require(!frozenAccount[_from]);
93         require(!frozenAccount[_to]);
94         balanceOf[_from] -= _value;
95         balanceOf[_to] += _value;
96         emit Transfer(_from, _to, _value);
97     }
98 
99     function transfer(address _to, uint256 _value) public returns (bool success) {
100         _transfer(msg.sender, _to, _value);
101         return true;
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_value <= allowance[_from][msg.sender]);
106         allowance[_from][msg.sender] -= _value;
107         _transfer(_from, _to, _value);
108         return true;
109     }
110 
111     function approve(address _spender, uint256 _value) public returns (bool success) {
112         allowance[msg.sender][_spender] = _value;
113         emit Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     function burn(uint256 _value) onlyOwner public returns (bool success) {
118         require(balanceOf[msg.sender] >= _value);
119         balanceOf[msg.sender] -= _value;
120         totalSupply -= _value;
121         emit Burn(msg.sender, _value);
122         return true;
123     }
124 
125     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
126         require(balanceOf[_from] >= _value); 
127         require(_value <= allowance[_from][msg.sender]); 
128         balanceOf[_from] -= _value;
129         allowance[_from][msg.sender] -= _value;
130         totalSupply -= _value;
131         emit Burn(_from, _value);
132         return true;
133     }
134 
135     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
136         uint256 _amount = mintedAmount * 10 ** uint256(decimals);
137         balanceOf[target] += _amount;
138         totalSupply += _amount;
139         emit Transfer(this, target, _amount);
140     }
141     
142     function freezeAccount(address target, bool freeze) onlyOwner public {
143         frozenAccount[target] = freeze;
144         emit FrozenFunds(target, freeze);
145     }
146 
147     function transferBatch(address[] _to, uint256 _value) public returns (bool success) {
148         for (uint i=0; i<_to.length; i++) {
149             _transfer(msg.sender, _to[i], _value);
150         }
151         return true;
152     }
153 }