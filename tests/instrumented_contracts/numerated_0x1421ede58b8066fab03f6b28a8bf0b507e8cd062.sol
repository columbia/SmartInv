1 pragma solidity ^0.4.18;
2 
3 
4 
5 library SafeMath {
6 
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a / b;
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20 {
34 
35 	function totalSupply() public view returns (uint256);
36 	function balanceOf(address who) public view returns (uint256);
37 	function transfer(address to, uint256 value) public returns (bool);
38 	function allowance(address owner, address spender) public view returns (uint256);
39 	function transferFrom(address from, address to, uint256 value) public returns (bool);
40 	function approve(address spender, uint256 value) public returns (bool);
41 
42 	event Transfer(address indexed from, address indexed to, uint256 value);
43 	event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 
47 
48 contract TipestryToken is ERC20 {
49 	
50 	using SafeMath for uint256;
51 	
52 	address public owner;	
53 
54 	string public constant name = "tipestry"; 
55   	string public constant symbol = "TIP"; 
56   	uint8 public constant decimals = 18; 
57 
58   	uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
59 
60 	uint256 totalSupply_;
61 
62 	mapping(address => uint256) balances;
63 	mapping (address => mapping (address => uint256)) internal allowed;
64 
65 	event Burn(address indexed burner, uint256 value);
66 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68 	modifier onlyOwner() {
69     	require(msg.sender == owner);
70     	_;
71   	}
72 
73 	function TipestryToken() public {
74         owner = msg.sender;		
75 		totalSupply_ = INITIAL_SUPPLY;
76     	balances[owner] = INITIAL_SUPPLY;
77     	Transfer(0x0, owner, INITIAL_SUPPLY);
78 	}
79 
80 
81 	function totalSupply() public view returns (uint256) {
82     	return totalSupply_;
83   	}
84 
85   	function transfer(address _to, uint256 _value) public returns (bool) {
86 	    require(_to != address(0));
87 	    require(_value <= balances[msg.sender]);
88 
89 	    // SafeMath.sub will throw if there is not enough balance.
90 	    balances[msg.sender] = balances[msg.sender].sub(_value);
91 	    balances[_to] = balances[_to].add(_value);
92 	    Transfer(msg.sender, _to, _value);
93 	    return true;
94 	}
95 
96 	function balanceOf(address _owner) public view returns (uint256 balance) {
97 	    return balances[_owner];
98 	}
99 
100 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
101 	    require(_to != address(0));
102 	    require(_value <= balances[_from]);
103 	    require(_value <= allowed[_from][msg.sender]);
104 
105 	    balances[_from] = balances[_from].sub(_value);
106 	    balances[_to] = balances[_to].add(_value);
107 	    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108 	    Transfer(_from, _to, _value);
109 	    return true;
110 	 }
111 
112 	 function approve(address _spender, uint256 _value) public returns (bool) {
113 	    allowed[msg.sender][_spender] = _value;
114 	    Approval(msg.sender, _spender, _value);
115 	    return true;
116 	 }
117 
118 	function allowance(address _owner, address _spender) public view returns (uint256) {
119     	return allowed[_owner][_spender];
120   	}
121 
122   	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
123 	    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
124 	    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125 	    return true;
126 	}
127 
128 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
129 	    uint oldValue = allowed[msg.sender][_spender];
130 	    if (_subtractedValue > oldValue) {
131 	      allowed[msg.sender][_spender] = 0;
132 	    } else {
133 	      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
134 	    }
135 	    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136 	    return true;
137 	}
138 
139 	function burn(uint256 _value) public {
140 	    require(_value <= balances[msg.sender]);
141 	    // no need to require value <= totalSupply, since that would imply the
142 	    // sender's balance is greater than the totalSupply, which *should* be an assertion failure
143 
144 	    address burner = msg.sender;
145 	    balances[burner] = balances[burner].sub(_value);
146 	    totalSupply_ = totalSupply_.sub(_value);
147 	    Burn(burner, _value);
148 	}
149 
150 
151 	function transferOwnership(address newOwner) public onlyOwner {
152 		require(newOwner != address(0));
153 		OwnershipTransferred(owner, newOwner);
154 		owner = newOwner;
155 	}
156 
157 }