1 /**
2  * CoolCrypto
3  * Keep it Simple, Keep it Cool
4  * @title CoolToken Smart Contract
5  * @author CoolCrypto
6  * @description A Cool Token For Everyone
7  * 100 Million COOL
8  * 4 Decimals
9  * With love in 2017
10  **/
11 pragma solidity >=0.4.4;
12 
13 //Cool safeMath
14 library safeMath {
15   function mul(uint a, uint b) internal returns (uint) {
16     uint c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20   function div(uint a, uint b) internal returns (uint) {
21     assert(b > 0);
22     uint c = a / b;
23     assert(a == b * c + a % b);
24     return c;
25   }
26   function sub(uint a, uint b) internal returns (uint) {
27     assert(b <= a);
28     return a - b;
29   }
30   function add(uint a, uint b) internal returns (uint) {
31     uint c = a + b;
32     assert(c >= a);
33     return c;
34   }
35   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a >= b ? a : b;
37   }
38   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
39     return a < b ? a : b;
40   }
41   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a >= b ? a : b;
43   }
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 //Cool Contract
55 contract Token {
56     string public standard = 'CoolToken';
57     string public name = 'Cool';
58     string public symbol = 'COOL';
59     uint8 public decimals = 4;
60     uint256 public totalSupply = 1000000000000;
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 
65     mapping(address => uint256) public balanceOf;
66     mapping(address => mapping(address => uint256)) public allowed;
67 
68     function Token() {
69         balanceOf[msg.sender] = totalSupply;
70     }
71 
72     function transfer(address _to, uint256 _value) {
73         require(_value > 0 && balanceOf[msg.sender] >= _value);
74 
75         balanceOf[msg.sender] -= _value;
76         balanceOf[_to] += _value;
77 
78         Transfer(msg.sender, _to, _value);
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) {
82         require(_value > 0 && balanceOf[_from] >= _value && allowed[_from][msg.sender] >= _value);
83 
84         balanceOf[_from] -= _value;
85         balanceOf[_to] += _value;
86         allowed[_from][msg.sender] -= _value;
87 
88         Transfer(_from, _to, _value);
89     }
90 
91     function approve(address _spender, uint256 _value) {
92         allowed[msg.sender][_spender] = _value;
93     }
94 
95   
96     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
97         return allowed[_owner][_spender];
98     }
99 
100     function getBalanceOf(address _who) returns(uint256 amount) {
101         return balanceOf[_who];
102     }
103 }