1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 contract ForeignToken {
27     function balanceOf(address _owner) constant public returns (uint256);
28     function transfer(address _to, uint256 _value) public returns (bool);
29 }
30 
31 contract LU {
32     using SafeMath for uint256;
33 	uint256 public totalSupply;
34 	string public name;
35 	uint256 public decimals;
36 	string public symbol;
37 	address public owner;
38 
39 	mapping (address => uint256) balances;
40 	mapping (address => mapping (address => uint256)) allowed;
41 
42   function LU(uint256 _totalSupply, string _symbol, string _name) public {
43 		decimals = 18;
44 		symbol = _symbol;
45 		name = _name;
46 		owner = msg.sender;
47         totalSupply = _totalSupply * (10 ** decimals);
48         balances[msg.sender] = totalSupply;
49   }
50 	//Fix for short address attack against ERC20
51 	modifier onlyPayloadSize(uint size) {
52 		assert(msg.data.length == size + 4);
53 		_;
54 	} 
55 
56 	function balanceOf(address _owner) constant public returns (uint256) {
57 		return balances[_owner];
58 	}
59 	
60     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
61         require(_to != address(0));
62         require(_amount <= balances[msg.sender]);
63         balances[msg.sender] = balances[msg.sender].sub(_amount);
64         balances[_to] = balances[_to].add(_amount);
65         emit Transfer(msg.sender, _to, _amount);
66         return true;
67     }
68     
69     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
70         require(_to != address(0));
71         require(_amount <= balances[_from]);
72         require(_amount <= allowed[_from][msg.sender]);
73         
74         balances[_from] = balances[_from].sub(_amount);
75         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
76         balances[_to] = balances[_to].add(_amount);
77         emit Transfer(_from, _to, _amount);
78         return true;
79     }
80 
81 	function approve(address _spender, uint256 _value) public {
82 		allowed[msg.sender][_spender] = _value;
83 		Approval(msg.sender, _spender, _value);
84 	}
85 
86 	function allowance(address _owner, address _spender) constant public returns (uint256) {
87 		return allowed[_owner][_spender];
88 	}
89 	
90 	function () payable public{
91 	}
92 	
93 	function withdraw() public {
94 		require(msg.sender == owner);
95         uint256 etherBalance = address(this).balance;
96         owner.transfer(etherBalance);
97     }
98     
99     function withdrawForeignTokens(address _tokenContract)  public returns (bool) {
100 		require(msg.sender == owner);
101         ForeignToken token = ForeignToken(_tokenContract);
102         uint256 amount = token.balanceOf(address(this));
103         return token.transfer(owner, amount);
104     }
105 
106 	//Event which is triggered to log all transfers to this contract's event log
107 	event Transfer(
108 		address indexed _from,
109 		address indexed _to,
110 		uint256 _value
111 		);
112 		
113 	//Event which is triggered whenever an owner approves a new allowance for a spender.
114 	event Approval(
115 		address indexed _owner,
116 		address indexed _spender,
117 		uint256 _value
118 		);
119 
120 }