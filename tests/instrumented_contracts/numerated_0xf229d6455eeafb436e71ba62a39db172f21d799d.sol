1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256)
5 	{
6 		uint256 c = a * b;
7 		assert(a == 0 || c / a == b);
8 		return c;
9 	}
10 
11 	function div(uint256 a, uint256 b) internal pure returns (uint256)
12 	{
13 		uint256 c = a / b;
14 		return c;
15 	}
16 
17 	function sub(uint256 a, uint256 b) internal pure returns (uint256)
18 	{
19 		assert(b <= a);
20 		return a - b;
21 	}
22 
23 	function add(uint256 a, uint256 b) internal pure returns (uint256)
24 	{
25 		uint256 c = a + b;
26 		assert(c >= a);
27 		return c;
28 	}
29 }
30 
31 contract TokenERC20 {
32     using SafeMath for uint256;
33 
34     string public name;
35     string public symbol;
36     uint8 public decimals = 18;
37     uint256 public totalSupply;
38 
39     mapping (address => uint256) public balances;
40     mapping (address => mapping (address => uint256)) public allowed;
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46     constructor(
47         uint256 initialSupply,
48         string tokenName,
49         string tokenSymbol
50     )
51         public
52     {
53         totalSupply = initialSupply.mul(10 ** uint256(decimals));
54         balances[msg.sender] = totalSupply;
55         name = tokenName;
56         symbol = tokenSymbol;
57     }
58 
59     function _transfer(address _from, address _to, uint _value) internal
60     {
61         require(_to != address(0));
62 
63         balances[_from] = balances[_from].sub(_value);
64 		balances[_to] = balances[_to].add(_value);
65         emit Transfer(_from, _to, _value);
66     }
67 
68     function transfer(address _to, uint256 _value) public returns (bool success)
69     {
70         _transfer(msg.sender, _to, _value);
71         return true;
72     }
73 
74     function balanceOf(address _owner) public constant returns (uint256 balance)
75     {
76 		return balances[_owner];
77 	}
78 
79     function transferFrom(
80         address _from,
81         address _to,
82         uint256 _value
83     )
84         public
85         returns (bool success)
86     {
87         allowed[_from][msg.sender] = allowance(_from, msg.sender).sub(_value);
88         _transfer(_from, _to, _value);
89         return true;
90     }
91 
92     function approve(address _spender, uint256 _value) public returns (bool success)
93     {
94         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
95 
96         allowed[msg.sender][_spender] = _value;
97         emit Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining)
102     {
103 		return allowed[_owner][_spender];
104 	}
105 
106     function increaseApproval(address _spender, uint _addedValue) public returns (bool success)
107     {
108         uint256 oldValue = allowed[msg.sender][_spender];
109 		allowed[msg.sender][_spender] = oldValue.add(_addedValue);
110 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111 		return true;
112 	}
113 
114 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success)
115     {
116 		uint256 oldValue = allowed[msg.sender][_spender];
117 		if (_subtractedValue > oldValue) {
118 			allowed[msg.sender][_spender] = 0;
119 		} else {
120 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
121 		}
122 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123 		return true;
124 	}
125 }
126 
127 contract AIOTokenERC20 is TokenERC20(500000000, "AIO Token", "AIOT") {
128 
129 }