1 pragma solidity ^0.5.5;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract SNToken {
33     
34     using SafeMath for uint256;
35     
36     string public name = "Skynet  天网";      //  token name
37     
38     string public symbol = "SN";           //  token symbol
39     
40     uint256 public decimals = 18;            //  token digit
41 
42     mapping (address => uint256) public balanceOf;
43     
44     mapping (address => mapping (address => uint256)) public allowance;
45  
46     
47     uint256 public totalSupply = 0;
48 
49     uint256 constant valueFounder = 21000000000000000000000000;
50     
51     
52 
53     modifier validAddress {
54         assert(address(0x0) != msg.sender);
55         _;
56     }
57     
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61     event Burn(address indexed _from , uint256 _value);
62     
63     constructor() public {
64 
65         totalSupply = valueFounder;
66         balanceOf[msg.sender] = valueFounder;
67         emit Transfer(address(0x0), msg.sender, valueFounder);
68     }
69     
70     function _transfer(address _from, address _to, uint256 _value) private {
71         require(_to != address(0x0));
72         require(balanceOf[_from] >= _value);
73         balanceOf[_from] = balanceOf[_from].sub(_value);
74         balanceOf[_to] = balanceOf[_to].add(_value);
75         emit Transfer(_from, _to, _value);
76     }
77     
78     function transfer(address _to, uint256 _value) validAddress public returns (bool success) {
79         _transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) validAddress public returns (bool success) {
84         require(_value <= allowance[_from][msg.sender]);
85         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
86         _transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function approve(address _spender, uint256 _value) validAddress public returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);
92         allowance[msg.sender][_spender] = _value;
93         emit Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 }