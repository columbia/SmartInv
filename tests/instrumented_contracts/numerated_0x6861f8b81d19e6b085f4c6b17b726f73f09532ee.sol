1 /**
2  * Source Code first verified at https://etherscan.io on Friday, January 25, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract POLToken {
37     
38     using SafeMath for uint256;
39     
40     string public name = "Polaris";      //  token name
41     
42     string public symbol = "POL";           //  token symbol
43     
44     uint256 public decimals = 8;            //  token digit
45 
46     mapping (address => uint256) public balanceOf;
47     
48     mapping (address => mapping (address => uint256)) public allowance;
49  
50     
51     uint256 public totalSupply = 0;
52 
53     uint256 constant valueFounder = 2100000000000000;
54     
55     
56 
57     modifier validAddress {
58         assert(0x0 != msg.sender);
59         _;
60     }
61     
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63     
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     
66     constructor() public {
67 
68         totalSupply = valueFounder;
69         balanceOf[msg.sender] = valueFounder;
70         emit Transfer(0x0, msg.sender, valueFounder);
71     }
72     
73     function _transfer(address _from, address _to, uint256 _value) private {
74         require(_to != 0x0);
75         require(balanceOf[_from] >= _value);
76         balanceOf[_from] = balanceOf[_from].sub(_value);
77         balanceOf[_to] = balanceOf[_to].add(_value);
78         emit Transfer(_from, _to, _value);
79     }
80     
81     function transfer(address _to, uint256 _value) validAddress public returns (bool success) {
82         _transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function transferFrom(address _from, address _to, uint256 _value) validAddress public returns (bool success) {
87         require(_value <= allowance[_from][msg.sender]);
88         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
89         _transfer(_from, _to, _value);
90         return true;
91     }
92 
93     function approve(address _spender, uint256 _value) validAddress public returns (bool success) {
94         require(balanceOf[msg.sender] >= _value);
95         allowance[msg.sender][_spender] = _value;
96         emit Approval(msg.sender, _spender, _value);
97         return true;
98     }
99 }