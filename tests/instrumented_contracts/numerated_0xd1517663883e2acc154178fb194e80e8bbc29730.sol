1 /**
2  *Submitted for verification at Etherscan.io on 2018-03-26
3 */
4 
5 pragma solidity ^0.4.13;
6 
7 
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 contract ERC20 is ERC20Basic {
16   function allowance(address owner, address spender) public view returns (uint256);
17   function transferFrom(address from, address to, uint256 value) public returns (bool);
18   function approve(address spender, uint256 value) public returns (bool);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
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
32   function Ownable() public {
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
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 library SafeMath {
59   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60     if (a == 0) {
61       return 0;
62     }
63     uint256 c = a * b;
64     assert(c / a == b);
65     return c;
66   }
67 
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   function add(uint256 a, uint256 b) internal pure returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 contract Deipool is ERC20,Ownable{
88 	using SafeMath for uint256;
89 
90 	string public constant name="Deipool";
91 	string public symbol="Dip";
92 	string public constant version = "1.0";
93 	uint256 public constant decimals = 18;
94 	uint256 public totalSupply;
95 
96 	uint256 public constant MAX_SUPPLY=100000000*10**decimals;
97 
98 	
99     mapping(address => uint256) balances;
100 	mapping (address => mapping (address => uint256)) allowed;
101 	event GetETH(address indexed _from, uint256 _value);
102 
103 	function Deipool(){
104 		totalSupply=MAX_SUPPLY;
105 		balances[0x1abf8c91D7575a89798bFf0b62A196e733Ee949B] = MAX_SUPPLY;
106 		Transfer(0x0, 0x1abf8c91D7575a89798bFf0b62A196e733Ee949B, MAX_SUPPLY);
107 	}
108 
109 	function () payable external
110 	{
111 		GetETH(msg.sender,msg.value);
112 	}
113 
114 	function etherProceeds() external
115 		onlyOwner
116 	{
117 		if(!msg.sender.send(this.balance)) revert();
118 	}
119 
120   	function transfer(address _to, uint256 _value) public  returns (bool)
121  	{
122 		require(_to != address(0));
123 		// SafeMath.sub will throw if there is not enough balance.
124 		balances[msg.sender] = balances[msg.sender].sub(_value);
125 		balances[_to] = balances[_to].add(_value);
126 		Transfer(msg.sender, _to, _value);
127 		return true;
128   	}
129 
130   	function balanceOf(address _owner) public constant returns (uint256 balance) 
131   	{
132 		return balances[_owner];
133   	}
134 
135   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
136   	{
137 		require(_to != address(0));
138 		uint256 _allowance = allowed[_from][msg.sender];
139 
140 		balances[_from] = balances[_from].sub(_value);
141 		balances[_to] = balances[_to].add(_value);
142 		allowed[_from][msg.sender] = _allowance.sub(_value);
143 		Transfer(_from, _to, _value);
144 		return true;
145   	}
146 
147   	function approve(address _spender, uint256 _value) public returns (bool) 
148   	{
149 		allowed[msg.sender][_spender] = _value;
150 		Approval(msg.sender, _spender, _value);
151 		return true;
152   	}
153 
154   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
155   	{
156 		return allowed[_owner][_spender];
157   	}
158 
159 	  
160 }