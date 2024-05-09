1 pragma solidity ^0.4.19;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12     function () public payable {
13         revert();
14     }
15 }
16 
17 
18 /*  ERC 20 token */
19 contract StandardToken is Token {
20 
21     function transfer(address _to, uint256 _value) returns (bool success) {
22         if (balances[msg.sender] >= _value && _value > 0) {
23             balances[msg.sender] -= _value;
24             balances[_to] += _value;
25             Transfer(msg.sender, _to, _value);
26             return true;
27         } else {
28             return false;
29         }
30     }
31 
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
33         if (balances[_to] + _value < balances[_to]) revert(); // Check for overflows
34         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
35             balances[_to] += _value;
36             balances[_from] -= _value;
37             allowed[_from][msg.sender] -= _value;
38             Transfer(_from, _to, _value);
39             return true;
40         } else {
41             return false;
42         }
43     }
44 
45     function balanceOf(address _owner) constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49     function approve(address _spender, uint256 _value) returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
56         return allowed[_owner][_spender];
57     }
58 
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61     function () public payable {
62         revert();
63     }
64 }
65 
66 contract SafeMath {
67 
68     /* function assert(bool assertion) internal { */
69     /*   if (!assertion) { */
70     /*     throw; */
71     /*   } */
72     /* }      // assert no longer needed once solidity is on 0.4.10 */
73 
74     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
75         uint256 z = x + y;
76         assert((z >= x) && (z >= y));
77         return z;
78     }
79 
80     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
81         assert(x >= y);
82         uint256 z = x - y;
83         return z;
84     }
85 
86     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
87         uint256 z = x * y;
88         assert((x == 0)||(z/x == y));
89         return z;
90     }
91 
92     function () public payable {
93         revert();
94     }
95 
96 }
97 contract Owner {
98 
99 	/// @dev `owner` is the only address that can call a function with this
100 	/// modifier
101 	modifier onlyOwner() {
102 		require(msg.sender == owner);
103 		_;
104 	}
105 
106 	address public owner;
107 
108 	/// @notice The Constructor assigns the message sender to be `owner`
109 	function Owner() public {
110 		owner = msg.sender;
111 	}
112 
113 	address public newOwner;
114 
115 	/// @notice `owner` can step down and assign some other address to this role
116 	/// @param _newOwner The address of the new owner. 0x0 can be used to create
117 	///  an unowned neutral vault, however that cannot be undone
118 	function changeOwner(address _newOwner) public onlyOwner {
119 		newOwner = _newOwner;
120 	}
121 
122 
123 	function acceptOwnership() public {
124 		if (msg.sender == newOwner) {
125 			owner = newOwner;
126 		}
127 	}
128 
129 	function () public payable {
130 		revert();
131 	}
132 
133 }
134 contract MOT is Owner, StandardToken, SafeMath {
135 	string public constant name = "MOT";
136 	string public constant symbol = "MOT";
137 	uint256 public constant decimals = 18;
138 	string public version = "1.0";
139 
140 
141 	uint256 public constant total = 1 * (10**8) * 10**decimals;   // 1*10^8 MOT total
142 
143 	function MOT() {
144 
145 		totalSupply = total;
146 		balances[msg.sender] = total;             // Give the creator all initial tokens
147 	}
148 	function () public payable {
149 		revert();
150 	}
151 }