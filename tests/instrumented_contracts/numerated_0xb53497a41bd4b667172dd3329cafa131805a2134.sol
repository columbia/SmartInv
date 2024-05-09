1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10 		if (a == 0) {
11 			return 0;
12 		}
13 		uint256 c = a * b;
14 		assert(c / a == b);
15 		return c;
16 	}
17 
18 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
19 		// assert(b > 0); // Solidity automatically throws when dividing by 0
20 		uint256 c = a / b;
21 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
22 		return c;
23 	}
24 
25 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26 		assert(b <= a);
27 		return a - b;
28 	}
29 
30 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
31 		uint256 c = a + b;
32 		assert(c >= a);
33 		return c;
34 	}
35 }
36 
37 contract Ownable {
38   address public owner;
39 
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     require(newOwner != address(0));
66     emit OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70 }
71 
72 contract ERC20 is Ownable {
73 	function totalSupply() public view returns (uint256 totalSup);
74 	function balanceOf(address _owner) public view returns (uint256 balance);
75 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
76 	function allowance(address _owner, address _spender) public view returns (uint256 remaining);
77 	function approve(address _spender, uint256 _value) public returns (bool success);
78 	function transfer(address _to, uint256 _value) public returns (bool success);
79 	event Transfer(address indexed _from, address indexed _to, uint _value);
80 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81 }
82 
83 contract ERC223 {
84 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
85 	event Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);
86 }
87 
88 contract ERC223ReceivingContract {
89 	function tokenFallback(address _from, uint _value, bytes _data) public;
90 }
91 
92 contract MDFToken is ERC223, ERC20 {
93 
94 	using SafeMath for uint256;
95 
96 	uint public constant _totalSupply = 100000000000000e18;
97 	//starting supply of Token
98 
99 	string public constant symbol = "MDFT";
100 	string public constant name = "Mildred Drake Family Trust Hedge Fund";
101 	uint8 public constant decimals = 18;
102 
103 	mapping(address => uint256) balances;
104 	mapping(address => mapping(address => uint256)) allowed;
105 
106 	constructor() public{
107 		balances[msg.sender] = _totalSupply;
108 		emit Transfer(0x0, msg.sender, _totalSupply);
109 	}
110 
111 	function totalSupply() public view returns (uint256 totalSup) {
112 	return _totalSupply;
113 	}
114 
115 	function balanceOf(address _owner) public view returns (uint256 balance) {
116 		return balances[_owner];
117 	}
118 
119 	function transfer(address _to, uint256 _value) public returns (bool success) {
120 		require(
121 			!isContract(_to)
122 		);
123 		balances[msg.sender] = balances[msg.sender].sub(_value);
124 		balances[_to] = balances[_to].add(_value);
125 		emit Transfer(msg.sender, _to, _value);
126 		return true;
127 	}
128 
129 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success){
130 		require(
131 			isContract(_to)
132 		);
133 		balances[msg.sender] = balances[msg.sender].sub(_value);
134 		balances[_to] = balances[_to].add(_value);
135 		ERC223ReceivingContract(_to).tokenFallback(msg.sender, _value, _data);
136 		emit Transfer(msg.sender, _to, _value, _data);
137 		return true;
138 	}
139 
140 	function isContract(address _from) private view returns (bool) {
141 		uint256 codeSize;
142 		assembly {
143 			codeSize := extcodesize(_from)
144 		}
145 		return codeSize > 0;
146 	}
147 
148 
149 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
150 		require(
151 			balances[_from] >= _value
152 			&& _value > 0
153 		);
154 		balances[_from] = balances[_from].sub(_value);
155 		balances[_to] = balances[_to].add(_value);
156 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157 		emit Transfer(_from, _to, _value);
158 		return true;
159 	}
160 
161 	function approve(address _spender, uint256 _value) public returns (bool success) {
162 		require(
163 			(_value == 0) || (allowed[msg.sender][_spender] == 0)
164 		);
165 		allowed[msg.sender][_spender] = _value;
166 		emit Approval(msg.sender, _spender, _value);
167 		return true;
168 	}
169 
170 	function allowance(address _owner, address _spender) public view returns (uint256 remain) {
171 		return allowed[_owner][_spender];
172 	}
173 
174 	function () public payable {
175 		revert();
176 	}
177 
178 	event Transfer(address  indexed _from, address indexed _to, uint256 _value);
179 	event Transfer(address indexed _from, address  indexed _to, uint _value, bytes _data);
180 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
181 
182 
183     function multiTransfer(address[] _toAddresses, uint256[] _amounts) public {
184         /* Ensures _toAddresses array is less than or equal to 255 */
185         require(_toAddresses.length <= 255);
186         /* Ensures _toAddress and _amounts have the same number of entries. */
187         require(_toAddresses.length == _amounts.length);
188 
189         for (uint8 i = 0; i < _toAddresses.length; i++) {
190             transfer(_toAddresses[i], _amounts[i]);
191         }
192     }
193  function multiTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {
194         /* Ensures _toAddresses array is less than or equal to 255 */
195         require(_toAddresses.length <= 255);
196         /* Ensures _toAddress and _amounts have the same number of entries. */
197         require(_toAddresses.length == _amounts.length);
198 
199         for (uint8 i = 0; i < _toAddresses.length; i++) {
200             transferFrom(_from, _toAddresses[i], _amounts[i]);
201         }
202     }
203 
204 }