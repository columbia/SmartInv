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
34 
35 
36 contract Token  {
37 
38     using SafeMath for uint256;
39 
40     string public name;
41     string public symbol;
42     uint8 public decimals;
43     uint public totalSupply;
44 
45     mapping (address => uint) public balances;
46     mapping (address => mapping (address => uint)) public allowance;
47   
48 
49     event Transfer(address indexed from, address indexed to, uint value);
50     event Burn(address indexed from, uint value);
51 	
52 
53     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 tokenDecimal) public {
54         totalSupply = initialSupply * 10 ** uint(tokenDecimal);
55         balances[msg.sender] = totalSupply;
56         name = tokenName;
57         symbol = tokenSymbol;
58 		decimals = tokenDecimal;
59     }
60 
61     function _transfer(address _from, address _to, uint _value) internal {
62 		require(_from != 0x0);
63 		require(_to != 0x0);
64 		require(balances[_from] >= _value && balances[_to] + _value > balances[_to]);
65 		
66       
67 		uint previousBalances = balances[_from].add(balances[_to]);
68 		balances[_from] = balances[_from].sub(_value);
69 		balances[_to] = balances[_to].add(_value);
70 		emit Transfer(_from, _to, _value);
71 		assert(balances[_from] + balances[_to] == previousBalances);
72     }
73 	
74 	function balanceOf(address _from) public view returns (uint) {
75 		return balances[_from];
76 	}
77 
78     function transfer(address _to, uint _value) public returns (bool) {
79 		_transfer(msg.sender, _to, _value);
80 		return true;
81     }
82 
83     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
84 		require(_value <= allowance[_from][msg.sender]);
85         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
86         _transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function approve(address _spender, uint _value) public returns (bool) {
91 		allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94 
95     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool) {
96 		tokenRecipient spender = tokenRecipient(_spender);
97 		if (approve(_spender, _value)) {
98 			spender.receiveApproval(msg.sender, _value, this, _extraData);
99 			return true;
100         }
101 		return false;
102     }
103 
104     function burn(uint _value) public returns (bool) {
105 		require(balances[msg.sender] >= _value);
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         totalSupply = totalSupply.sub(_value);
108         emit Burn(msg.sender, _value);
109         return true;
110     }
111 
112       function burnFrom(address _from, uint _value) public  returns (bool) {
113         require(balances[_from] >= _value);
114         require(_value <= allowance[_from][msg.sender]);
115         balances[_from] = balances[_from].sub(_value);
116         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
117         totalSupply = totalSupply.sub(_value);
118         emit Burn(_from, _value);
119         return true;
120     }
121 	
122 
123       
124 
125 }