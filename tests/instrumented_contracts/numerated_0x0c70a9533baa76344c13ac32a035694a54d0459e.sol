1 pragma solidity ^0.4.13;
2 contract ERC20Basic {
3   uint256 public totalSupply;
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8 
9 contract ERC20 is ERC20Basic {
10   function allowance(address owner, address spender) public view returns (uint256);
11   function transferFrom(address from, address to, uint256 value) public returns (bool);
12   function approve(address spender, uint256 value) public returns (bool);
13   event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 contract Ownable {
16   address public owner;
17 
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() public {
27     owner = msg.sender;
28   }
29 
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 
50 }
51 
52 library SafeMath {
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 contract SummerGreen is ERC20,Ownable{
82 	using SafeMath for uint256;
83 
84 	string public constant name="夏生绿";
85 	string public symbol="SummerGreen";
86 	string public constant version = "1.0";
87 	uint256 public constant decimals = 18;
88 	uint256 public totalSupply;
89 
90 	uint256 public constant MAX_SUPPLY=10000000000*10**decimals;
91 
92 	
93     mapping(address => uint256) balances;
94 	mapping (address => mapping (address => uint256)) allowed;
95 	event GetETH(address indexed _from, uint256 _value);
96 
97 	//owner一次性获取代币
98 	function SummerGreen(){
99 		totalSupply=MAX_SUPPLY;
100 		balances[msg.sender] = MAX_SUPPLY;
101 		Transfer(0x0, msg.sender, MAX_SUPPLY);
102 	}
103 
104 	//允许用户往合约账户打币
105 	function () payable external
106 	{
107 		GetETH(msg.sender,msg.value);
108 	}
109 
110 	function etherProceeds() external
111 		onlyOwner
112 	{
113 		if(!msg.sender.send(this.balance)) revert();
114 	}
115 
116   	function transfer(address _to, uint256 _value) public  returns (bool)
117  	{
118 		require(_to != address(0));
119 		// SafeMath.sub will throw if there is not enough balance.
120 		balances[msg.sender] = balances[msg.sender].sub(_value);
121 		balances[_to] = balances[_to].add(_value);
122 		Transfer(msg.sender, _to, _value);
123 		return true;
124   	}
125 
126   	function balanceOf(address _owner) public constant returns (uint256 balance) 
127   	{
128 		return balances[_owner];
129   	}
130 
131   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
132   	{
133 		require(_to != address(0));
134 		uint256 _allowance = allowed[_from][msg.sender];
135 
136 		balances[_from] = balances[_from].sub(_value);
137 		balances[_to] = balances[_to].add(_value);
138 		allowed[_from][msg.sender] = _allowance.sub(_value);
139 		Transfer(_from, _to, _value);
140 		return true;
141   	}
142 
143   	function approve(address _spender, uint256 _value) public returns (bool) 
144   	{
145 		allowed[msg.sender][_spender] = _value;
146 		Approval(msg.sender, _spender, _value);
147 		return true;
148   	}
149 
150   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
151   	{
152 		return allowed[_owner][_spender];
153   	}
154 
155 	  
156 }