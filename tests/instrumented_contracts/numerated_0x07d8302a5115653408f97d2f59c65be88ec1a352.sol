1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) public constant returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 
19 
20 
21 contract Ownable {
22   address public owner;
23 
24 
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   function Ownable() {
33     owner = msg.sender;
34   }
35 
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) onlyOwner public {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 library SafeMath {
61   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
62     uint256 c = a * b;
63     assert(a == 0 || c / a == b);
64     return c;
65   }
66 
67   function div(uint256 a, uint256 b) internal constant returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return c;
72   }
73 
74   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   function add(uint256 a, uint256 b) internal constant returns (uint256) {
80     uint256 c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 contract EPAY is ERC20,Ownable{
87 	using SafeMath for uint256;
88 
89 	string public constant name="EPAY";
90 	string public symbol="EPAY";
91 	string public constant version = "1.0";
92 	uint256 public constant decimals = 18;
93 
94 	uint256 public constant MAX_SUPPLY=50000000*10**decimals;
95 
96 	
97     mapping(address => uint256) balances;
98 	mapping (address => mapping (address => uint256)) allowed;
99 	event GetETH(address indexed _from, uint256 _value);
100 
101 	//owner一次性获取代币
102 	function EPAY(){
103 		balances[msg.sender] = MAX_SUPPLY;
104 		Transfer(0x0, msg.sender, MAX_SUPPLY);
105 	}
106 
107 	//允许用户往合约账户打币
108 	function () payable external
109 	{
110 		GetETH(msg.sender,msg.value);
111 	}
112 
113 	function etherProceeds() external
114 		onlyOwner
115 	{
116 		if(!msg.sender.send(this.balance)) revert();
117 	}
118 
119   	function transfer(address _to, uint256 _value) public  returns (bool)
120  	{
121 		require(_to != address(0));
122 		// SafeMath.sub will throw if there is not enough balance.
123 		balances[msg.sender] = balances[msg.sender].sub(_value);
124 		balances[_to] = balances[_to].add(_value);
125 		Transfer(msg.sender, _to, _value);
126 		return true;
127   	}
128 
129   	function balanceOf(address _owner) public constant returns (uint256 balance) 
130   	{
131 		return balances[_owner];
132   	}
133 
134   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
135   	{
136 		require(_to != address(0));
137 		uint256 _allowance = allowed[_from][msg.sender];
138 
139 		balances[_from] = balances[_from].sub(_value);
140 		balances[_to] = balances[_to].add(_value);
141 		allowed[_from][msg.sender] = _allowance.sub(_value);
142 		Transfer(_from, _to, _value);
143 		return true;
144   	}
145 
146   	function approve(address _spender, uint256 _value) public returns (bool) 
147   	{
148 		allowed[msg.sender][_spender] = _value;
149 		Approval(msg.sender, _spender, _value);
150 		return true;
151   	}
152 
153   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
154   	{
155 		return allowed[_owner][_spender];
156   	}
157 
158 	  
159 }