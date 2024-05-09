1 pragma solidity 0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external; }
4 
5 library SafeMath {
6 
7   function add(uint a, uint b) internal pure returns (uint) {
8     uint256 c = a + b;
9     assert(c >= a);
10     return c;
11   }
12 
13   function sub(uint a, uint b) internal pure returns (uint) {
14     assert(b <= a);
15     return a - b;
16   }
17 
18   function mul(uint a, uint b) internal pure returns (uint) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function div(uint a, uint b) internal pure returns (uint) {
28     uint256 c = a / b;
29     return c;
30   }
31 
32 }
33 
34 contract owned {
35 
36 	address public owner;
37 
38 	constructor() public {
39 		owner = msg.sender;
40 	}
41 
42     modifier onlyOwner {
43 		require (msg.sender == owner);
44 		_;
45     }
46 
47 	function transferOwnership(address newOwner) public onlyOwner {
48 		require(newOwner != 0x0);
49 		owner = newOwner;
50 	}
51 }
52 
53 
54 contract Token is owned {
55 
56 	using SafeMath for uint256;
57 
58 	string public name;
59     string public symbol;
60     uint8 public decimals;
61     uint public totalSupply;
62 
63     mapping (address => uint) public balances;
64     mapping (address => mapping (address => uint)) public allowance;
65 	mapping (address => bool) public frozenAccount;
66 
67     event Transfer(address indexed from, address indexed to, uint value);
68     event Burn(address indexed from, uint value);
69 	event FrozenFunds(address indexed target, bool frozen);
70 
71     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 tokenDecimal) public {
72         totalSupply = initialSupply * 10 ** uint(tokenDecimal);
73         balances[msg.sender] = totalSupply;
74         name = tokenName;
75         symbol = tokenSymbol;
76 		decimals = tokenDecimal;
77     }
78 
79     function _transfer(address _from, address _to, uint _value) internal {
80 		require(_from != 0x0);
81 		require(_to != 0x0);
82 		require(balances[_from] >= _value && balances[_to] + _value > balances[_to]);
83 		require(!frozenAccount[_from]);
84         require(!frozenAccount[_to]);
85 		uint previousBalances = balances[_from].add(balances[_to]);
86 		balances[_from] = balances[_from].sub(_value);
87 		balances[_to] = balances[_to].add(_value);
88 		emit Transfer(_from, _to, _value);
89 		assert(balances[_from] + balances[_to] == previousBalances);
90     }
91 	
92 	function balanceOf(address _from) public view returns (uint) {
93 		return balances[_from];
94 	}
95 
96     function transfer(address _to, uint _value) public returns (bool) {
97 		_transfer(msg.sender, _to, _value);
98 		return true;
99     }
100 
101     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
102 		require(_value <= allowance[_from][msg.sender]);
103         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
104         _transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function approve(address _spender, uint _value) public returns (bool) {
109 		allowance[msg.sender][_spender] = _value;
110         return true;
111     }
112 
113     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool) {
114 		tokenRecipient spender = tokenRecipient(_spender);
115 		if (approve(_spender, _value)) {
116 			spender.receiveApproval(msg.sender, _value, this, _extraData);
117 			return true;
118         }
119 		return false;
120     }
121 
122     function burn(uint _value) public returns (bool) {
123 		require(balances[msg.sender] >= _value);
124         balances[msg.sender] = balances[msg.sender].sub(_value);
125         totalSupply = totalSupply.sub(_value);
126         emit Burn(msg.sender, _value);
127         return true;
128     }
129 
130     function burnFrom(address _from, uint _value) public onlyOwner returns (bool) {
131         require(balances[_from] >= _value);
132         require(_value <= allowance[_from][msg.sender]);
133         balances[_from] = balances[_from].sub(_value);
134         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
135         totalSupply = totalSupply.sub(_value);
136         emit Burn(_from, _value);
137         return true;
138     }
139 	
140 	function mintToken(address target, uint mintedAmount) public onlyOwner returns (bool) {
141 		balances[target] = balances[target].add(mintedAmount);
142         totalSupply = totalSupply.add(mintedAmount);
143 		emit Transfer(0, this, mintedAmount);
144 		emit Transfer(this, target, mintedAmount);
145 		return true;
146     }
147 	
148 	function freezeAccount(address target, bool freeze) public onlyOwner returns (bool) {
149 		frozenAccount[target] = freeze;
150 		emit FrozenFunds(target, freeze);
151 		return true;
152     }
153 
154 }