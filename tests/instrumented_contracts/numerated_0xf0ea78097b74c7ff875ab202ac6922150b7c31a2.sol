1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract ERC20 {
32 
33 	function totalSupply() public view returns (uint256);
34 	function balanceOf(address who) public view returns (uint256);
35 	function transfer(address to, uint256 value) public returns (bool);
36 	function allowance(address owner, address spender) public view returns (uint256);
37 	function transferFrom(address from, address to, uint256 value) public returns (bool);
38 	function approve(address spender, uint256 value) public returns (bool);
39 
40 	event Transfer(address indexed from, address indexed to, uint256 value);
41 	event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 
45 
46 contract OcubicleToken is ERC20 {
47 	
48 	using SafeMath for uint256;
49 	
50 	address public owner;	
51 
52 	string public constant name = "Ocubicle"; 
53   	string public constant symbol = "XCB"; 
54   	uint8 public constant decimals = 18; 
55 
56   	uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
57 
58 	uint256 totalSupply_;
59 
60 	mapping(address => uint256) balances;
61 	mapping (address => mapping (address => uint256)) internal allowed;
62 
63 	event Burn(address indexed burner, uint256 value);
64 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66 	modifier onlyOwner() {
67     	require(msg.sender == owner);
68     	_;
69   	}
70 
71 	function OcubicleToken() public {
72         owner = msg.sender;		
73 		totalSupply_ = INITIAL_SUPPLY;
74     	balances[owner] = INITIAL_SUPPLY;
75     	Transfer(0x0, owner, INITIAL_SUPPLY);
76 	}
77 
78 
79 	function totalSupply() public view returns (uint256) {
80     	return totalSupply_;
81   	}
82 
83   	function transfer(address _to, uint256 _value) public returns (bool) {
84 	    require(_to != address(0));
85 	    require(_value <= balances[msg.sender]);
86 
87 	    // SafeMath.sub will throw if there is not enough balance.
88 	    balances[msg.sender] = balances[msg.sender].sub(_value);
89 	    balances[_to] = balances[_to].add(_value);
90 	    Transfer(msg.sender, _to, _value);
91 	    return true;
92 	}
93 
94 	function balanceOf(address _owner) public view returns (uint256 balance) {
95 	    return balances[_owner];
96 	}
97 
98 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
99 	    require(_to != address(0));
100 	    require(_value <= balances[_from]);
101 	    require(_value <= allowed[_from][msg.sender]);
102 
103 	    balances[_from] = balances[_from].sub(_value);
104 	    balances[_to] = balances[_to].add(_value);
105 	    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
106 	    Transfer(_from, _to, _value);
107 	    return true;
108 	 }
109 
110 	 function approve(address _spender, uint256 _value) public returns (bool) {
111 	    allowed[msg.sender][_spender] = _value;
112 	    Approval(msg.sender, _spender, _value);
113 	    return true;
114 	 }
115 
116 	function allowance(address _owner, address _spender) public view returns (uint256) {
117     	return allowed[_owner][_spender];
118   	}
119 
120   	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
121 	    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
122 	    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123 	    return true;
124 	}
125 
126 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
127 	    uint oldValue = allowed[msg.sender][_spender];
128 	    if (_subtractedValue > oldValue) {
129 	      allowed[msg.sender][_spender] = 0;
130 	    } else {
131 	      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
132 	    }
133 	    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134 	    return true;
135 	}
136 
137 	function burn(uint256 _value) public {
138 	    require(_value <= balances[msg.sender]);
139 	    // no need to require value <= totalSupply, since that would imply the
140 	    // sender's balance is greater than the totalSupply, which *should* be an assertion failure
141 
142 	    address burner = msg.sender;
143 	    balances[burner] = balances[burner].sub(_value);
144 	    totalSupply_ = totalSupply_.sub(_value);
145 	    Burn(burner, _value);
146 	}
147 
148 
149 	function transferOwnership(address newOwner) public onlyOwner {
150 		require(newOwner != address(0));
151 		OwnershipTransferred(owner, newOwner);
152 		owner = newOwner;
153 	}
154 
155 }