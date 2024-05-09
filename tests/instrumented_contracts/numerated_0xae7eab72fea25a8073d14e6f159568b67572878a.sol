1 pragma solidity ^0.4.24;
2 
3 //Created by SVOVY
4 
5 contract ERC20Simple {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address _who) public view returns (uint256);
8   function transfer(address _to, uint256 _value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 
13 library SafeMath {
14 
15   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25 
26   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
27 
28     return _a / _b;
29   }
30 
31   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
32     assert(_b <= _a);
33     return _a - _b;
34   }
35 
36 
37   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
38     c = _a + _b;
39     assert(c >= _a);
40     return c;
41   }
42 }
43 
44 contract CRNToken is  ERC20Simple {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) internal balances;
48 
49   uint256 internal totalSupply_;
50 
51 
52   function totalSupply() public view returns (uint256) {
53     return totalSupply_;
54   }
55 
56 
57   function transfer(address _to, uint256 _value) public returns (bool) {
58     require(_value <= balances[msg.sender]);
59     require(_to != address(0));
60     
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     emit Transfer(msg.sender, _to, _value);
64     return true;
65   }
66   
67 
68 
69   function balanceOf(address _owner) public view returns (uint256) {
70     return balances[_owner];
71   }
72 
73 }
74 
75 
76 contract FLXCoin is CRNToken {
77 
78   event Burn(address indexed burner, uint256 value);
79 
80 	string public name = "FLX Coin";
81 	string public symbol = "FLX";
82 	uint8 public decimals = 2;
83 	uint public INITIAL_SUPPLY = 1000000000000;
84 	
85     function burn(uint256 _value) public {
86         _burn(msg.sender, _value);
87     }
88 
89 	constructor() public {
90 	  totalSupply_ = INITIAL_SUPPLY;
91 	  balances[msg.sender] = INITIAL_SUPPLY;
92 	}
93 	
94   function _burn(address _who, uint256 _value) internal {
95     require(_value <= balances[_who]);
96 
97     balances[_who] = balances[_who].sub(_value);
98     totalSupply_ = totalSupply_.sub(_value);
99     emit Burn(_who, _value);
100     emit Transfer(_who, address(0), _value);
101   }
102 }