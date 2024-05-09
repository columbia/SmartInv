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
21 
22 contract Ownable { 
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() {
34     owner = msg.sender;
35   }
36 
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) onlyOwner public {
52     require(newOwner != address(0));
53     OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 
60 
61 library SafeMath {
62   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
63     uint256 c = a * b;
64     assert(a == 0 || c / a == b);
65     return c;
66   }
67 
68   function div(uint256 a, uint256 b) internal constant returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   function add(uint256 a, uint256 b) internal constant returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 contract HK is ERC20,Ownable{
87 	using SafeMath for uint256;
88 
89 	string public constant name="HK";
90 	string public symbol="HK";
91 	string public constant version = "1.0";
92 	uint256 public constant decimals = 18;
93 	uint256 public totalSupply;
94 
95 	uint256 public constant MAX_SUPPLY=21000000*10**decimals;
96 
97 	
98     mapping(address => uint256) balances;
99 	mapping (address => mapping (address => uint256)) allowed;
100 	event GetETH(address indexed _from, uint256 _value);
101 
102 	//owner一次性获取代币
103 	function HK(){
104 		totalSupply=MAX_SUPPLY;
105 		balances[msg.sender] = MAX_SUPPLY;
106 		Transfer(0x0, msg.sender, MAX_SUPPLY);
107 	}
108 
109 	//允许用户往合约账户打币
110 	function () payable external
111 	{
112 		GetETH(msg.sender,msg.value);
113 	}
114 
115 	function etherProceeds() external
116 		onlyOwner
117 	{
118 		if(!msg.sender.send(this.balance)) revert();
119 	}
120 
121   	function transfer(address _to, uint256 _value) public  returns (bool)
122  	{
123 		require(_to != address(0));
124 		// SafeMath.sub will throw if there is not enough balance.
125 		balances[msg.sender] = balances[msg.sender].sub(_value);
126 		balances[_to] = balances[_to].add(_value);
127 		Transfer(msg.sender, _to, _value);
128 		return true;
129   	}
130 
131   	function balanceOf(address _owner) public constant returns (uint256 balance) 
132   	{
133 		return balances[_owner];
134   	}
135 
136   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
137   	{
138 		require(_to != address(0));
139 		uint256 _allowance = allowed[_from][msg.sender];
140 
141 		balances[_from] = balances[_from].sub(_value);
142 		balances[_to] = balances[_to].add(_value);
143 		allowed[_from][msg.sender] = _allowance.sub(_value);
144 		Transfer(_from, _to, _value);
145 		return true;
146   	}
147 
148   	function approve(address _spender, uint256 _value) public returns (bool) 
149   	{
150 		allowed[msg.sender][_spender] = _value;
151 		Approval(msg.sender, _spender, _value);
152 		return true;
153   	}
154 
155   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
156   	{
157 		return allowed[_owner][_spender];
158   	}
159 
160 	  
161 }