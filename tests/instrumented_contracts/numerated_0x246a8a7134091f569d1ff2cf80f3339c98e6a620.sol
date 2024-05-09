1 pragma solidity ^0.4.24;
2 
3 
4 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
5 
6 
7 contract SafeMath {
8   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b > 0);
19     uint256 c = a / b;
20     assert(a == b * c + a % b);
21     return c;
22   }
23 
24   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c>=a && c>=b);
32     return c;
33   }
34 
35 }
36 
37 contract BankToken is SafeMath {
38     address public owner;
39     string public name;
40     string public symbol;
41     uint public decimals;
42     uint256 public totalSupply;
43 
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Burn(address indexed from, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50     
51     mapping (address => bool) public frozenAccount;
52     event FrozenFunds(address target, bool frozen);
53 
54     bool lock = false;
55 
56     constructor(
57         uint256 initialSupply,
58         string tokenName,
59         string tokenSymbol,
60         uint decimalUnits
61     ) public {
62         owner = msg.sender;
63         name = tokenName;
64         symbol = tokenSymbol; 
65         decimals = decimalUnits;
66         totalSupply = initialSupply * 10 ** uint256(decimals);
67         balanceOf[msg.sender] = totalSupply;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     modifier isLock {
76         require(!lock);
77         _;
78     }
79     
80     function setLock(bool _lock) onlyOwner public{
81         lock = _lock;
82     }
83 
84     function transferOwnership(address newOwner) onlyOwner public {
85         if (newOwner != address(0)) {
86             owner = newOwner;
87         }
88     }
89  
90 
91     function _transfer(address _from, address _to, uint _value) isLock internal {
92         require (_to != 0x0);
93         require (balanceOf[_from] >= _value);
94         require (balanceOf[_to] + _value > balanceOf[_to]);
95         require(!frozenAccount[_from]);
96         require(!frozenAccount[_to]);
97         balanceOf[_from] -= _value;
98         balanceOf[_to] += _value;
99         emit Transfer(_from, _to, _value);
100     }
101 
102     function transfer(address _to, uint256 _value) public returns (bool success) {
103         _transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
108         require(_value <= allowance[_from][msg.sender]);
109         allowance[_from][msg.sender] -= _value;
110         _transfer(_from, _to, _value);
111         return true;
112     }
113 
114     function approve(address _spender, uint256 _value) public returns (bool success) {
115         allowance[msg.sender][_spender] = _value;
116         emit Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120     function burn(uint256 _value) onlyOwner public returns (bool success) {
121         require(balanceOf[msg.sender] >= _value);
122         balanceOf[msg.sender] -= _value;
123         totalSupply -= _value;
124         emit Burn(msg.sender, _value);
125         return true;
126     }
127 
128     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
129         require(balanceOf[_from] >= _value); 
130         require(_value <= allowance[_from][msg.sender]); 
131         balanceOf[_from] -= _value;
132         allowance[_from][msg.sender] -= _value;
133         totalSupply -= _value;
134         emit Burn(_from, _value);
135         return true;
136     }
137 
138     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
139         uint256 _amount = mintedAmount * 10 ** uint256(decimals);
140         balanceOf[target] += _amount;
141         totalSupply += _amount;
142         emit Transfer(this, target, _amount);
143     }
144     
145     function freezeAccount(address target, bool freeze) onlyOwner public {
146         frozenAccount[target] = freeze;
147         emit FrozenFunds(target, freeze);
148     }
149 
150     function transferBatch(address[] _to, uint256 _value) public returns (bool success) {
151         for (uint i=0; i<_to.length; i++) {
152             _transfer(msg.sender, _to[i], _value);
153         }
154         return true;
155     }
156 }