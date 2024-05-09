1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-03
3 */
4 
5 pragma solidity ^0.4.13;
6 
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 contract ERC20 is ERC20Basic {
16   function allowance(address owner, address spender) public constant returns (uint256);
17   function transferFrom(address from, address to, uint256 value) public returns (bool);
18   function approve(address spender, uint256 value) public returns (bool);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 
24 
25 contract Ownable {
26   address public owner;
27 
28 
29   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31 
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   function Ownable() {
37     owner = msg.sender;
38   }
39 
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) onlyOwner public {
55     require(newOwner != address(0));
56     OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 
60 }
61 
62 
63 
64 library SafeMath {
65   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a * b;
67     assert(a == 0 || c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal constant returns (uint256) {
72     assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   function add(uint256 a, uint256 b) internal constant returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 contract GXT is ERC20,Ownable{
90 	using SafeMath for uint256;
91 
92 	string public constant name="银河系通证";
93 	string public symbol="GXT";
94 	string public constant version = "1.0";
95 	uint256 public constant decimals = 18;
96 	uint256 public totalSupply;
97 
98 	uint256 public constant MAX_SUPPLY=uint256(700000000)*uint256(10)**decimals;
99 
100 	
101     mapping(address => uint256) balances;
102 	mapping (address => mapping (address => uint256)) allowed;
103 	event GetETH(address indexed _from, uint256 _value);
104 
105 	//owner一次性获取代币
106 	function GXT(){
107 		totalSupply=MAX_SUPPLY;
108 		balances[msg.sender] = MAX_SUPPLY;
109 		Transfer(0x0, msg.sender, MAX_SUPPLY);
110 	}
111 
112 	//允许用户往合约账户打币
113 	function () payable external
114 	{
115 		GetETH(msg.sender,msg.value);
116 	}
117 
118 	function etherProceeds() external
119 		onlyOwner
120 	{
121 		if(!msg.sender.send(this.balance)) revert();
122 	}
123 
124   	function transfer(address _to, uint256 _value) public  returns (bool)
125  	{
126 		require(_to != address(0));
127         require(_to != address(this));
128         require(msg.sender != address(0));
129         require(_value <= balances[msg.sender]);
130 		// SafeMath.sub will throw if there is not enough balance.
131 		balances[msg.sender] = balances[msg.sender].sub(_value);
132 		balances[_to] = balances[_to].add(_value);
133 		Transfer(msg.sender, _to, _value);
134 		return true;
135   	}
136 
137   	function balanceOf(address _owner) public constant returns (uint256 balance) 
138   	{
139 		return balances[_owner];
140   	}
141 
142   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
143   	{
144 	    require(_from != address(0));
145         require(_to != address(0));
146         require(_to != address(this));
147         
148         require(_value <= balances[_from]);
149         require(_value <= allowed[_from][msg.sender]);
150         
151 		uint256 _allowance = allowed[_from][msg.sender];
152 
153 		balances[_from] = balances[_from].sub(_value);
154 		balances[_to] = balances[_to].add(_value);
155 		allowed[_from][msg.sender] = _allowance.sub(_value);
156 		Transfer(_from, _to, _value);
157 		return true;
158   	}
159 
160   	function approve(address _spender, uint256 _value) public returns (bool) 
161   	{
162   	    require(_value > 0);
163 		allowed[msg.sender][_spender] = _value;
164 		Approval(msg.sender, _spender, _value);
165 		return true;
166   	}
167 
168   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
169   	{
170 		return allowed[_owner][_spender];
171   	}
172 
173 	  
174 }