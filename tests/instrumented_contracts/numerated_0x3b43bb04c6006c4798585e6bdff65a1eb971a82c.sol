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
82 
83 contract ITE is ERC20,Ownable{
84 	using SafeMath for uint256;
85 
86 	string public constant name="Intelligent Travel Chain";
87 	string public symbol="ITE";
88 	string public constant version = "1.0";
89 	uint256 public constant decimals = 18;
90 	uint256 public totalSupply;
91 
92 	uint256 public constant MAX_SUPPLY=10000000000*10**decimals;
93 
94 	
95     mapping(address => uint256) balances;
96 	mapping (address => mapping (address => uint256)) allowed;
97 	event GetETH(address indexed _from, uint256 _value);
98 
99 	//owner一次性获取代币
100 	function ITE(){
101 		totalSupply=MAX_SUPPLY;
102 		balances[msg.sender] = MAX_SUPPLY;
103 		Transfer(0x0, msg.sender, MAX_SUPPLY);
104 	}
105 
106 	//允许用户往合约账户打币
107 	function () payable external
108 	{
109 		GetETH(msg.sender,msg.value);
110 	}
111 
112 	function etherProceeds() external
113 		onlyOwner
114 	{
115 		if(!msg.sender.send(this.balance)) revert();
116 	}
117 
118   	function transfer(address _to, uint256 _value) public  returns (bool)
119  	{
120 		require(_to != address(0));
121 		// SafeMath.sub will throw if there is not enough balance.
122 		balances[msg.sender] = balances[msg.sender].sub(_value);
123 		balances[_to] = balances[_to].add(_value);
124 		Transfer(msg.sender, _to, _value);
125 		return true;
126   	}
127 
128   	function balanceOf(address _owner) public constant returns (uint256 balance) 
129   	{
130 		return balances[_owner];
131   	}
132 
133   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
134   	{
135 		require(_to != address(0));
136 		uint256 _allowance = allowed[_from][msg.sender];
137 
138 		balances[_from] = balances[_from].sub(_value);
139 		balances[_to] = balances[_to].add(_value);
140 		allowed[_from][msg.sender] = _allowance.sub(_value);
141 		Transfer(_from, _to, _value);
142 		return true;
143   	}
144 
145   	function approve(address _spender, uint256 _value) public returns (bool) 
146   	{
147 		allowed[msg.sender][_spender] = _value;
148 		Approval(msg.sender, _spender, _value);
149 		return true;
150   	}
151 
152   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
153   	{
154 		return allowed[_owner][_spender];
155   	}
156 
157 	  
158 }