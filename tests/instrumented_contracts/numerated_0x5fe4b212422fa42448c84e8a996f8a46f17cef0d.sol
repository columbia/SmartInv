1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   function transferOwnership(address newOwner) onlyOwner public {
30     require(newOwner != address(0));
31     OwnershipTransferred(owner, newOwner);
32     owner = newOwner;
33   }
34 }
35 
36 library SafeMath {
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a / b;
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 contract ENSATOKEN is ERC20,Ownable{
61 	using SafeMath for uint256;
62 	string public constant name="Energy Saving Chain ";
63 	string public symbol="ENSA";
64 	string public constant version = "1.0";
65 	uint256 public constant decimals = 18;
66 	uint256 public totalSupply;
67 	uint256 public constant MAX_SUPPLY=2100000000*10**decimals;
68   mapping(address => uint256) balances;
69 	mapping (address => mapping (address => uint256)) allowed;
70 
71 	event GetETH(address indexed _from, uint256 _value);
72 
73 	function ENSATOKEN() public {
74 		totalSupply=MAX_SUPPLY;
75 		balances[msg.sender] = MAX_SUPPLY;
76 		Transfer(0x0, msg.sender, MAX_SUPPLY);
77 	}
78 
79 	function () payable external
80 	{
81 		GetETH(msg.sender,msg.value);
82 	}
83 
84 	function etherProceeds() external
85 		onlyOwner
86 	{
87 		if(!msg.sender.send(this.balance)) revert();
88 	}
89 
90   	function transfer(address _to, uint256 _value) public  returns (bool)
91  	{
92 		require(_to != address(0));
93 		balances[msg.sender] = balances[msg.sender].sub(_value);
94 		balances[_to] = balances[_to].add(_value);
95 		Transfer(msg.sender, _to, _value);
96 		return true;
97   	}
98 
99   	function balanceOf(address _owner) public constant returns (uint256 balance) 
100   	{
101 		return balances[_owner];
102   	}
103 
104   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
105   	{
106 		require(_to != address(0));
107 		uint256 _allowance = allowed[_from][msg.sender];
108 
109 		balances[_from] = balances[_from].sub(_value);
110 		balances[_to] = balances[_to].add(_value);
111 		allowed[_from][msg.sender] = _allowance.sub(_value);
112 		Transfer(_from, _to, _value);
113 		return true;
114   	}
115 
116   	function approve(address _spender, uint256 _value) public returns (bool) 
117   	{
118 		allowed[msg.sender][_spender] = _value;
119 		Approval(msg.sender, _spender, _value);
120 		return true;
121   	}
122 
123   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
124   	{
125 		return allowed[_owner][_spender];
126   	}
127 }