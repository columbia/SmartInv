1 pragma solidity ^0.4.24; 
2 
3 // ----------------------------------------------------------------------------
4 // 'SQR' 'SaleQR' standard token contract saleqr.com
5 // d3675d8103feb8888f00bc4de8df3b71 5c5645168ab95bb3a0647a6329b76bad
6 // Symbol      : SQR
7 // Name        : SaleQR
8 // Total supply: 200,000,000.000000000000000000
9 // Decimals    : 18
10 // Website     : saleqr.com
11 // ----------------------------------------------------------------------------
12 
13 library SafeMath {
14     function add(uint a, uint b) internal pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function sub(uint a, uint b) internal pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function mul(uint a, uint b) internal pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 
32 
33 contract ERC20Basic {
34   uint256 public totalSupply;
35   function balanceOf(address who) public constant returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 
41 
42 contract BasicToken is ERC20Basic {
43   using SafeMath for uint256;
44 
45   mapping(address => uint256) balances;
46 
47   function transfer(address _to, uint256 _value) public returns (bool) {
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     emit Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   function balanceOf(address _owner) public constant returns (uint256 balance) {
55     return balances[_owner];
56   }
57 
58 }
59 
60 
61 
62 contract ERC20 is ERC20Basic {
63   function allowance(address owner, address spender) public constant returns (uint256);
64   function transferFrom(address from, address to, uint256 value) public returns (bool);
65   function approve(address spender, uint256 value) public returns (bool);
66   event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74   
75   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76     var _allowance = allowed[_from][msg.sender];
77 
78     
79     balances[_to] = balances[_to].add(_value);
80     balances[_from] = balances[_from].sub(_value);
81     allowed[_from][msg.sender] = _allowance.sub(_value);
82     emit Transfer(_from, _to, _value);
83     return true;
84   }
85   
86   function approve(address _spender, uint256 _value) public returns (bool) {
87     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
88     allowed[msg.sender][_spender] = _value;
89     emit Approval(msg.sender, _spender, _value);
90     return true;
91   }
92 
93   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
94     return allowed[_owner][_spender];
95   }
96 
97 }
98 
99 
100 
101 contract SaleQR is StandardToken {
102 
103   string public constant name = "SaleQR";
104   string public constant symbol = "SQR";
105   uint256 public constant decimals = 18;
106   uint256 public constant INITIAL_SUPPLY = 200000000*10**18;
107   string public constant version = "1.0";
108 
109   function SaleQR() public {
110     totalSupply = INITIAL_SUPPLY;
111     balances[msg.sender] = INITIAL_SUPPLY;
112   }
113   
114 }