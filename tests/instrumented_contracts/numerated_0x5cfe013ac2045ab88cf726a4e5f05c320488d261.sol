1 pragma solidity ^0.4.13;
2 
3 contract EIP20Interface {
4 
5     uint256 public totalSupply;
6 
7 
8     function balanceOf(address _owner) public view returns (uint256 balance);
9 
10   
11     function transfer(address _to, uint256 _value) public returns (bool success);
12 
13 
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
15 
16     function approve(address _spender, uint256 _value) public returns (bool success);
17 
18     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 }
23 
24 contract Monarch is EIP20Interface {
25     using SafeMath for uint256;
26     
27 	uint public constant totalSupply = 100000000000000000;
28 
29 	string public constant symbol = "XMA";
30 	string public constant name = "Monarch";
31 	uint8 public constant decimals = 8;
32 
33 	mapping(address => uint256) public balances;
34 	mapping(address => mapping(address => uint256)) public allowed;
35 
36     modifier validDestination( address to ) {
37         require(to != address(0x0));
38         require(to != address(this) );
39         _;
40     }
41 
42 	function Monarch() public{
43 		balances[msg.sender] = totalSupply;
44 	}
45 
46 	function balanceOf(address _owner) public view returns (uint256 balance){
47 		return balances[_owner];		
48 	}
49 
50 
51 	function transfer(address _to, uint _value) public
52         validDestination(_to)
53         returns (bool)
54         {
55 		require(
56 			balances[msg.sender] >= _value
57 			&& _value > 0
58 		);
59 		balances[msg.sender] = balances[msg.sender].sub(_value);
60 		balances[_to] = balances[_to].add(_value);
61 		emit Transfer(msg.sender, _to, _value);
62 		return true;
63 	}
64 
65 
66 	function transferFrom(address _from, address _to, uint _value) public
67         validDestination(_to)
68         returns (bool)
69         
70         {require(
71 			allowed[_from][msg.sender] >= _value
72 			&& balances[_from] >= _value
73 			&& _value > 0
74 		);
75 		balances[_from] = balances[_from].sub(_value);
76 		balances[_to] = balances[_to].add(_value);
77 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78 		emit Transfer(_from, _to, _value);
79 		return true;
80 	}
81 
82 
83 	function approve(address _spender, uint256 _value) public returns (bool success){
84 		allowed[msg.sender][_spender] = _value;
85 		emit Approval(msg.sender, _spender, _value);
86 		return true;		
87 	}
88 
89 
90 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
91 		return allowed[_owner][_spender];
92 	}
93 
94     function () public {
95     
96     }
97 
98 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
99 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 }
101 
102 library SafeMath {
103 
104   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
105     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
106     // benefit is lost if 'b' is also tested.
107     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
108     if (_a == 0) {
109       return 0;
110     }
111 
112     c = _a * _b;
113     assert(c / _a == _b);
114     return c;
115   }
116 
117   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
118     // assert(_b > 0); // Solidity automatically throws when dividing by 0
119     // uint256 c = _a / _b;
120     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
121     return _a / _b;
122   }
123 
124   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
125     assert(_b <= _a);
126     return _a - _b;
127   }
128 
129   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
130     c = _a + _b;
131     assert(c >= _a);
132     return c;
133   }
134 }