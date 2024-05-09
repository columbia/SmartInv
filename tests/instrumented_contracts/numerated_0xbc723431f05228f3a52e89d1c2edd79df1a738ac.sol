1 pragma solidity ^0.5.7;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9 
10         uint256 c = a * b;
11         require(c / a == b);
12 
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b > 0);
18         uint256 c = a / b;
19         
20 	return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a);
25         uint256 c = a - b;
26 
27         return c;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a);
33 
34         return c;
35     }
36 
37     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b != 0);
39         return a % b;
40     }
41 }
42 
43 contract ERC20Standard {
44 	using SafeMath for uint256;
45 	uint public totalSupply;
46 	
47 	string public name;
48 	uint8 public decimals;
49 	string public symbol;
50 	string public version;
51 	
52 	mapping (address => uint256) balances;
53 	mapping (address => mapping (address => uint)) allowed;
54 
55 	//Fix for short address attack against ERC20
56 	modifier onlyPayloadSize(uint size) {
57 		assert(msg.data.length == size + 4);
58 		_;
59 	} 
60 
61 	function balanceOf(address _owner) public view returns (uint balance) {
62 		return balances[_owner];
63 	}
64 
65 	function transfer(address _recipient, uint _value) public onlyPayloadSize(2*32) {
66 	    require(balances[msg.sender] >= _value && _value > 0);
67 	    balances[msg.sender] = balances[msg.sender].sub(_value);
68 	    balances[_recipient] = balances[_recipient].add(_value);
69 	    emit Transfer(msg.sender, _recipient, _value);        
70         }
71 
72 	function transferFrom(address _from, address _to, uint _value) public {
73 	    require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
74             balances[_to] = balances[_to].add(_value);
75             balances[_from] = balances[_from].sub(_value);
76             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
77             emit Transfer(_from, _to, _value);
78         }
79 
80 	function  approve(address _spender, uint _value) public {
81 		allowed[msg.sender][_spender] = _value;
82 		emit Approval(msg.sender, _spender, _value);
83 	}
84 
85 	function allowance(address _spender, address _owner) public view returns (uint balance) {
86 		return allowed[_owner][_spender];
87 	}
88 
89 	//Event which is triggered to log all transfers to this contract's event log
90 	event Transfer(
91 		address indexed _from,
92 		address indexed _to,
93 		uint _value
94 		);
95 		
96 	//Event which is triggered whenever an owner approves a new allowance for a spender.
97 	event Approval(
98 		address indexed _owner,
99 		address indexed _spender,
100 		uint _value
101 		);
102 }
103 
104 contract NewToken is ERC20Standard {
105 	constructor() public {
106 		totalSupply = 3866603800000000;
107 		name = "Unichain";
108 		decimals = 8;
109 		symbol = "UNCH";
110 		version = "1.0";
111 		balances[msg.sender] = totalSupply;
112 	}
113 }