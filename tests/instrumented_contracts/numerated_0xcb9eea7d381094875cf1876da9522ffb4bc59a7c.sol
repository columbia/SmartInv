1 // File: ERC20Standard.sol
2 
3 pragma solidity ^0.5.7;
4 
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11 
12         uint256 c = a * b;
13         require(c / a == b);
14 
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b > 0);
20         uint256 c = a / b;
21 
22 	return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b <= a);
27         uint256 c = a - b;
28 
29         return c;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a);
35 
36         return c;
37     }
38 
39     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b != 0);
41         return a % b;
42     }
43 }
44 
45 contract ERC20Standard {
46 	using SafeMath for uint256;
47 	uint public totalSupply;
48 
49 	string public name;
50 	uint8 public decimals;
51 	string public symbol;
52 	string public version;
53 
54 	mapping (address => uint256) balances;
55 	mapping (address => mapping (address => uint)) allowed;
56 
57 	//Fix for short address attack against ERC20
58 	modifier onlyPayloadSize(uint size) {
59 		assert(msg.data.length == size + 4);
60 		_;
61 	}
62 
63 	function balanceOf(address _owner) public view returns (uint balance) {
64 		return balances[_owner];
65 	}
66 
67 	function transfer(address _recipient, uint _value) public onlyPayloadSize(2*32) {
68 	    require(balances[msg.sender] >= _value && _value > 0);
69 	    balances[msg.sender].sub(_value);
70 	    balances[_recipient].add(_value);
71 	    emit Transfer(msg.sender, _recipient, _value);
72         }
73 
74 	function transferFrom(address _from, address _to, uint _value) public {
75 	    require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
76             balances[_to].add(_value);
77             balances[_from].sub(_value);
78             allowed[_from][msg.sender].sub(_value);
79             emit Transfer(_from, _to, _value);
80         }
81 
82 	function  approve(address _spender, uint _value) public {
83 		allowed[msg.sender][_spender] = _value;
84 		emit Approval(msg.sender, _spender, _value);
85 	}
86 
87 	function allowance(address _spender, address _owner) public view returns (uint balance) {
88 		return allowed[_owner][_spender];
89 	}
90 
91 	//Event which is triggered to log all transfers to this contract's event log
92 	event Transfer(
93 		address indexed _from,
94 		address indexed _to,
95 		uint _value
96 		);
97 
98 	//Event which is triggered whenever an owner approves a new allowance for a spender.
99 	event Approval(
100 		address indexed _owner,
101 		address indexed _spender,
102 		uint _value
103 		);
104 }
105 
106 // File: BIP.sol
107 
108 pragma solidity ^0.5.2;
109 
110 
111 contract BIP is ERC20Standard {
112 	constructor() public {
113 		totalSupply = 200000000000000000000000000;
114 		name = "Blockchain Invest Platform Token";
115 		decimals = 18;
116 		symbol = "BIP";
117 		version = "1.2";
118 		balances[msg.sender] = totalSupply;
119 	}
120 }