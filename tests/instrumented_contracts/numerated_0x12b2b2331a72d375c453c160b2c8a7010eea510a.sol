1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20 {
28   uint256 public totalSupply;
29   function balanceOf(address who) public view returns (uint256);
30   function transfer(address to, uint256 value) public returns (bool);
31   function allowance(address owner, address spender) public view returns (uint256);
32   function transferFrom(address from, address to, uint256 value) public returns (bool);
33   function approve(address spender, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35   event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 contract StandardToken is ERC20 {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42   mapping (address => mapping (address => uint256)) allowed;
43 
44   function balanceOf(address _owner) public view returns (uint256 balance) {
45     return balances[_owner];
46   }
47 
48   function transfer(address _to, uint256 _value) public returns (bool) {
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     emit Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
56     uint256 _allowance = allowed[_from][msg.sender];
57     require (_value <= _allowance);
58     
59     balances[_from] = balances[_from].sub(_value);
60     balances[_to] = balances[_to].add(_value);
61     allowed[_from][msg.sender] = _allowance.sub(_value);
62     emit Transfer(_from, _to, _value);
63     return true;
64   }
65 
66 
67   function approve(address _spender, uint256 _value) public returns (bool) {
68     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
69     
70     allowed[msg.sender][_spender] = _value;
71     emit Approval(msg.sender, _spender, _value);
72     return true;
73   }
74 
75   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
76     return allowed[_owner][_spender];
77   }
78 }
79 
80 contract GUBI is StandardToken {
81   bytes16 public constant name = "GUBI";
82   bytes16 public constant symbol = "GUBI";
83   uint8 public constant decimals = 18;
84 
85     constructor() public {
86         totalSupply = 10000000000000000000000000000;
87         balances[msg.sender] = totalSupply;
88         emit Transfer(address(0), msg.sender, 10000000000000000000000000000);
89     }
90 }