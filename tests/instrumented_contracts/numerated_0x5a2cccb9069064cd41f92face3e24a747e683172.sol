1 pragma solidity ^0.4.13;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 library SafeMath {
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     if (a == 0) {
57       return 0;
58     }
59     uint256 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 contract IGI is ERC20,Ownable{
83 	using SafeMath for uint256;
84 
85 	string public constant name="International General integral";
86 	string public symbol="IGI";
87 	string public constant version = "1.0";
88 	uint256 public constant decimals = 18;
89 	uint256 public totalSupply;
90 
91 	uint256 public constant MAX_SUPPLY=495000000*10**decimals;
92 
93 	
94     mapping(address => uint256) balances;
95 	mapping (address => mapping (address => uint256)) allowed;
96 	event GetETH(address indexed _from, uint256 _value);
97 
98 	//owner一次性获取代币
99 	function IGI(){
100 		totalSupply=MAX_SUPPLY;
101 		balances[msg.sender] = MAX_SUPPLY;
102 		Transfer(0x0, msg.sender, MAX_SUPPLY);
103 	}
104 
105 	//允许用户往合约账户打币
106 	function () payable external
107 	{
108 		GetETH(msg.sender,msg.value);
109 	}
110 
111 	function etherProceeds() external
112 		onlyOwner
113 	{
114 		if(!msg.sender.send(this.balance)) revert();
115 	}
116 
117   	function transfer(address _to, uint256 _value) public  returns (bool)
118  	{
119 		require(_to != address(0));
120 		// SafeMath.sub will throw if there is not enough balance.
121 		balances[msg.sender] = balances[msg.sender].sub(_value);
122 		balances[_to] = balances[_to].add(_value);
123 		Transfer(msg.sender, _to, _value);
124 		return true;
125   	}
126 
127   	function balanceOf(address _owner) public constant returns (uint256 balance) 
128   	{
129 		return balances[_owner];
130   	}
131 
132   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
133   	{
134 		require(_to != address(0));
135 		uint256 _allowance = allowed[_from][msg.sender];
136 
137 		balances[_from] = balances[_from].sub(_value);
138 		balances[_to] = balances[_to].add(_value);
139 		allowed[_from][msg.sender] = _allowance.sub(_value);
140 		Transfer(_from, _to, _value);
141 		return true;
142   	}
143 
144   	function approve(address _spender, uint256 _value) public returns (bool) 
145   	{
146 		allowed[msg.sender][_spender] = _value;
147 		Approval(msg.sender, _spender, _value);
148 		return true;
149   	}
150 
151   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
152   	{
153 		return allowed[_owner][_spender];
154   	}
155 
156 	  
157 }