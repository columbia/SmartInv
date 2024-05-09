1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract SEA {
31     using SafeMath for uint256;
32     string public name;
33     string public symbol;
34     uint256 public decimals;
35     uint256 public totalSupply;
36 	address public owner;
37 	uint256 public basisPointsRate = 0;
38 	uint256 public maximumFee = 0;
39 	uint256 public minimumFee = 0;
40 
41     mapping (address => uint256) public balanceOf;
42     mapping (address => uint256) public freezes;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event CollectFee(address indexed _from, address indexed _owner, uint256 fee);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48     event Params(address indexed _owner, uint256 feeBasisPoints, uint256 minFee, uint256 maxFee);
49     event Freeze(address indexed to, uint256 value);
50     event Unfreeze(address indexed to, uint256 value);
51 	event Withdraw(address indexed to, uint256 value);
52 
53     constructor(uint256 initialSupply, uint8 decimalUnits, string tokenName, string tokenSymbol) public {
54         balanceOf[msg.sender] = initialSupply;
55         totalSupply = initialSupply;
56         name = tokenName;
57         symbol = tokenSymbol;
58         decimals = decimalUnits;
59 		owner = msg.sender;
60     }
61 
62     function transfer(address _to, uint256 _value) public returns (bool success) {
63 		require(_to != address(0));
64         uint256 fee = calFee(_value);
65         require(_value > fee);
66         uint256 sendAmount = _value.sub(fee);
67 		require(balanceOf[msg.sender] >= _value && _value > 0 && balanceOf[_to] + sendAmount > balanceOf[_to]);
68 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
69 		balanceOf[_to] = balanceOf[_to].add(sendAmount);
70 		if (fee > 0) {
71             balanceOf[owner] = balanceOf[owner].add(fee);
72             emit CollectFee(msg.sender, owner, fee);
73         }
74         emit Transfer(msg.sender, _to, sendAmount);
75 		return true;
76     }
77 
78     function approve(address _spender, uint256 _value) public returns (bool success) {
79 		require(_spender != address(0));
80 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
81         allowance[msg.sender][_spender] = _value;
82 		emit Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
87 		require((_from != address(0)) && (_to != address(0)));
88         uint256 fee = calFee(_value);
89         require(_value > fee);
90         uint256 sendAmount = _value.sub(fee);
91 		require(balanceOf[_from] >= _value && allowance[_from][msg.sender] >= _value && _value > 0 && balanceOf[_to] + sendAmount > balanceOf[_to]);
92 		balanceOf[_to] = balanceOf[_to].add(sendAmount);
93 		balanceOf[_from] = balanceOf[_from].sub(_value);
94 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
95 		if (fee > 0) {
96             balanceOf[owner] = balanceOf[owner].add(fee);
97             emit CollectFee(msg.sender, owner, fee);
98         }
99 		emit Transfer(_from, _to, _value);
100 		return true;
101     }
102 
103     function freeze(address _to,uint256 _value) public returns (bool success) {
104 		require(msg.sender == owner);
105         require(balanceOf[_to] >= _value);
106         require(_value > 0);
107         balanceOf[_to] = balanceOf[_to].sub(_value);
108         freezes[_to] = freezes[_to].add(_value);
109         emit Freeze(_to, _value);
110         return true;
111     }
112 
113 	function unfreeze(address _to,uint256 _value) public returns (bool success) {
114 		require(msg.sender == owner);
115         require(freezes[_to] >= _value);
116         require(_value > 0);
117         freezes[_to] = freezes[_to].sub(_value);
118 		balanceOf[_to] = balanceOf[_to].add(_value);
119         emit Unfreeze(_to, _value);
120         return true;
121     }
122 
123 	function setParams(uint256 newBasisPoints, uint256 newMinFee, uint256 newMaxFee) public returns (bool success) {
124 	    require(msg.sender == owner);
125         require(newBasisPoints <= 20);
126         require(newMinFee <= 50);
127         require(newMaxFee <= 50);
128 		require(newMinFee <= newMaxFee);
129         basisPointsRate = newBasisPoints;
130         minimumFee = newMinFee.mul(10**decimals);
131         maximumFee = newMaxFee.mul(10**decimals);
132         emit Params(msg.sender, basisPointsRate, minimumFee, maximumFee);
133         return true;
134     }
135 
136     function calFee(uint256 _value) private view returns (uint256 fee) {
137         fee = (_value.mul(basisPointsRate)).div(10000);
138         if (fee > maximumFee) {
139             fee = maximumFee;
140         }
141         if (fee < minimumFee) {
142             fee = minimumFee;
143         }
144     }
145 
146 	function withdrawEther(uint256 amount) public returns (bool success) {
147 		require (msg.sender == owner);
148 		owner.transfer(amount);
149 		emit Withdraw(msg.sender,amount);
150 		return true;
151 	}
152 
153 	function destructor() public returns (bool success) {
154 	    require(msg.sender == owner);
155         selfdestruct(owner);
156         return true;
157     }
158 
159 	function() payable private {
160     }
161 }