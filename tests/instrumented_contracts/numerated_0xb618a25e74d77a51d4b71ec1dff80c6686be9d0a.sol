1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 	if (a == 0) {
6 		return 0;
7 	}
8 	uint256 c = a * b;
9 	assert(c / a == b);
10 	return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14 	uint256 c = a / b;
15 	return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19 	assert(b <= a);
20 	return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24 	uint256 c = a + b;
25 	assert(c >= a);
26 	return c;
27   }
28 }
29 
30 contract HundredToken {
31   using SafeMath for uint256;
32   
33   event Transfer(address indexed from, address indexed to, uint256 value);
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35 
36   mapping(address => uint256) balances;
37   mapping (address => mapping (address => uint256)) allowed;  
38 
39   string public constant name = "hundred chain";
40   string public constant symbol = "BJC";
41   uint8 public constant decimals = 18;
42   address public founder = address(0);  
43 
44   function HundredToken() public {
45     totalSupply = 70000000 * 10**18;
46     balances[msg.sender] = totalSupply;
47   }
48   
49   uint256 public totalSupply;
50 
51   function balanceOf(address _owner) public view returns (uint256 balance) {
52     return balances[_owner];
53   }
54 
55   function transfer(address _to, uint256 _value) public returns (bool) {
56     require(_to != address(0));
57 
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64 
65   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
66     var _allowance = allowed[_from][msg.sender];
67     require(_to != address(0));
68     require (_value <= _allowance);
69     balances[_from] = balances[_from].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     allowed[_from][msg.sender] = _allowance.sub(_value);
72     Transfer(_from, _to, _value);
73     return true;
74   }
75 
76 
77   function approve(address _spender, uint256 _value) public returns (bool) {
78     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
79     allowed[msg.sender][_spender] = _value;
80     Approval(msg.sender, _spender, _value);
81     return true;
82   }
83 
84 
85   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
86     return allowed[_owner][_spender];
87   }  
88   
89   function changeFounder(address newFounder) public {
90 	require(msg.sender == founder);
91 
92 	founder = newFounder;
93   }  
94 }