1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     require(newOwner != address(0));
66     OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70 }
71 
72 
73 
74 
75 /**
76  * @title SafeMath
77  * @dev Math operations with safety checks that throw on error
78  */
79 library SafeMath {
80   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81     if (a == 0) {
82       return 0;
83     }
84     uint256 c = a * b;
85     assert(c / a == b);
86     return c;
87   }
88 
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return c;
94   }
95 
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   function add(uint256 a, uint256 b) internal pure returns (uint256) {
102     uint256 c = a + b;
103     assert(c >= a);
104     return c;
105   }
106 }
107 
108 contract AGP is ERC20,Ownable{
109 	using SafeMath for uint256;
110 
111 	string public constant name="THE GLOBAL CHAIN";
112 	string public symbol="AGP";
113 	string public constant version = "1.0";
114 	uint256 public constant decimals = 18;
115 	uint256 public totalSupply;
116 
117 	uint256 public constant MAX_SUPPLY=600000000*10**decimals;
118 
119 	
120     mapping(address => uint256) balances;
121 	mapping (address => mapping (address => uint256)) allowed;
122 	event GetETH(address indexed _from, uint256 _value);
123 
124 	//owner一次性获取代币
125 	function AGP(){
126 		totalSupply=MAX_SUPPLY;
127 		balances[msg.sender] = MAX_SUPPLY;
128 		Transfer(0x0, msg.sender, MAX_SUPPLY);
129 	}
130 
131 	//允许用户往合约账户打币
132 	function () payable external
133 	{
134 		GetETH(msg.sender,msg.value);
135 	}
136 
137 	function etherProceeds() external
138 		onlyOwner
139 	{
140 		if(!msg.sender.send(this.balance)) revert();
141 	}
142 
143   	function transfer(address _to, uint256 _value) public  returns (bool)
144  	{
145 		require(_to != address(0));
146 		// SafeMath.sub will throw if there is not enough balance.
147 		balances[msg.sender] = balances[msg.sender].sub(_value);
148 		balances[_to] = balances[_to].add(_value);
149 		Transfer(msg.sender, _to, _value);
150 		return true;
151   	}
152 
153   	function balanceOf(address _owner) public constant returns (uint256 balance) 
154   	{
155 		return balances[_owner];
156   	}
157 
158   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
159   	{
160 		require(_to != address(0));
161 		uint256 _allowance = allowed[_from][msg.sender];
162 
163 		balances[_from] = balances[_from].sub(_value);
164 		balances[_to] = balances[_to].add(_value);
165 		allowed[_from][msg.sender] = _allowance.sub(_value);
166 		Transfer(_from, _to, _value);
167 		return true;
168   	}
169 
170   	function approve(address _spender, uint256 _value) public returns (bool) 
171   	{
172 		allowed[msg.sender][_spender] = _value;
173 		Approval(msg.sender, _spender, _value);
174 		return true;
175   	}
176 
177   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
178   	{
179 		return allowed[_owner][_spender];
180   	}
181 
182 	  
183 }