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
80 contract ITI is ERC20,Ownable{
81 	using SafeMath for uint256;
82 
83 	string public constant name="Itelligent Travel Chain";
84 	string public symbol="ITI";
85 	string public constant version = "1.0";
86 	uint256 public constant decimals = 18;
87 	uint256 public totalSupply;
88 
89 	uint256 public constant MAX_SUPPLY=10000000000*10**decimals;
90 
91 	
92     mapping(address => uint256) balances;
93 	mapping (address => mapping (address => uint256)) allowed;
94 	event GetETH(address indexed _from, uint256 _value);
95 
96 	function ITI(){
97 		totalSupply=MAX_SUPPLY;
98 		balances[msg.sender] = MAX_SUPPLY;
99 		Transfer(0x0, msg.sender, MAX_SUPPLY);
100 	}
101 
102 	function () payable external
103 	{
104 		GetETH(msg.sender,msg.value);
105 	}
106 
107 	function etherProceeds() external
108 		onlyOwner
109 	{
110 		if(!msg.sender.send(this.balance)) revert();
111 	}
112 
113   	function transfer(address _to, uint256 _value) public  returns (bool)
114  	{
115 		require(_to != address(0));
116 		// SafeMath.sub will throw if there is not enough balance.
117 		balances[msg.sender] = balances[msg.sender].sub(_value);
118 		balances[_to] = balances[_to].add(_value);
119 		Transfer(msg.sender, _to, _value);
120 		return true;
121   	}
122 
123   	function balanceOf(address _owner) public constant returns (uint256 balance) 
124   	{
125 		return balances[_owner];
126   	}
127 
128   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
129   	{
130 		require(_to != address(0));
131 		uint256 _allowance = allowed[_from][msg.sender];
132 
133 		balances[_from] = balances[_from].sub(_value);
134 		balances[_to] = balances[_to].add(_value);
135 		allowed[_from][msg.sender] = _allowance.sub(_value);
136 		Transfer(_from, _to, _value);
137 		return true;
138   	}
139 
140   	function approve(address _spender, uint256 _value) public returns (bool) 
141   	{
142 		allowed[msg.sender][_spender] = _value;
143 		Approval(msg.sender, _spender, _value);
144 		return true;
145   	}
146 
147   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
148   	{
149 		return allowed[_owner][_spender];
150   	}
151 
152 	  
153 }