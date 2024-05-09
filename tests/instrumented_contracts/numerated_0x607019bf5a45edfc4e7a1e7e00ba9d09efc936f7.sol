1 /**
2  *Submitted for verification at Etherscan.io on 2020-03-20
3 */
4 
5 pragma solidity ^0.5.5;
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
36 contract GDFCToken {
37     
38     using SafeMath for uint256;
39     
40     string public name = "Global Decentralized Finance Chain";      //  token name
41     
42     string public symbol = "GDFC";           //  token symbol
43     
44     uint256 public decimals = 18;            //  token digit
45 
46     mapping (address => uint256) public balanceOf;
47     
48     mapping (address => mapping (address => uint256)) public allowance;
49  
50     
51     uint256 public totalSupply = 0;
52 
53     uint256 constant valueFounder = 100000000000000000000000000;
54     
55     
56 
57     modifier validAddress {
58         assert(address(0x0) != msg.sender);
59         _;
60     }
61     
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63     
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     event Burn(address indexed _from , uint256 _value);
66     
67     constructor() public {
68 
69         totalSupply = valueFounder;
70         balanceOf[msg.sender] = valueFounder;
71         emit Transfer(address(0x0), msg.sender, valueFounder);
72     }
73     
74     function _transfer(address _from, address _to, uint256 _value) private {
75         require(_to != address(0x0));
76         require(balanceOf[_from] >= _value);
77         balanceOf[_from] = balanceOf[_from].sub(_value);
78         balanceOf[_to] = balanceOf[_to].add(_value);
79         emit Transfer(_from, _to, _value);
80     }
81     
82     function transfer(address _to, uint256 _value) validAddress public returns (bool success) {
83         _transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) validAddress public returns (bool success) {
88         require(_value <= allowance[_from][msg.sender]);
89         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
90         _transfer(_from, _to, _value);
91         return true;
92     }
93 
94     function approve(address _spender, uint256 _value) validAddress public returns (bool success) {
95         require(balanceOf[msg.sender] >= _value);
96         allowance[msg.sender][_spender] = _value;
97         emit Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 }