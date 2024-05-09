1 /**
2  * Cool Crypto
3  *
4  * Keep it Simple, 
5  * Keep it Cool
6  * 
7  * @title CoolToken Smart Contract
8  * @author CoolCrypto
9  * @description A Cool Token For Everyone
10  * 
11  * 100 Million COOL
12  * 
13  **/
14 pragma solidity >=0.4.4;
15 
16 //Cool safeMath
17 library safeMath {
18   function mul(uint a, uint b) internal returns (uint) {
19     uint c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23   function div(uint a, uint b) internal returns (uint) {
24     assert(b > 0);
25     uint c = a / b;
26     assert(a == b * c + a % b);
27     return c;
28   }
29   function sub(uint a, uint b) internal returns (uint) {
30     assert(b <= a);
31     return a - b;
32   }
33   function add(uint a, uint b) internal returns (uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
39     return a >= b ? a : b;
40   }
41   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
42     return a < b ? a : b;
43   }
44   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a >= b ? a : b;
46   }
47   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
48     return a < b ? a : b;
49   }
50   function assert(bool assertion) internal {
51     if (!assertion) {
52       throw;
53     }
54   }
55 }
56 
57 //Cool Contract
58 contract CoolToken {
59     string public standard = 'CoolToken';
60     string public name = 'Cool';
61     string public symbol = 'COOL';
62     uint8 public decimals = 18;
63     uint256 public totalSupply = 100000000000000000000000000;
64     // 100000000000000000000000000/10^18=100M COOL.
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 
69     mapping(address => uint256) public balanceOf;
70     mapping(address => mapping(address => uint256)) public allowed;
71 
72     function Token() {
73         balanceOf[msg.sender] = totalSupply;
74     }
75 
76     function transfer(address _to, uint256 _value) {
77         require(_value > 0 && balanceOf[msg.sender] >= _value);
78 
79         balanceOf[msg.sender] -= _value;
80         balanceOf[_to] += _value;
81 
82         Transfer(msg.sender, _to, _value);
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) {
86         require(_value > 0 && balanceOf[_from] >= _value && allowed[_from][msg.sender] >= _value);
87 
88         balanceOf[_from] -= _value;
89         balanceOf[_to] += _value;
90         allowed[_from][msg.sender] -= _value;
91 
92         Transfer(_from, _to, _value);
93     }
94 
95     function approve(address _spender, uint256 _value) {
96         allowed[msg.sender][_spender] = _value;
97     }
98 
99   
100     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
101         return allowed[_owner][_spender];
102     }
103 
104     function getBalanceOf(address _who) returns(uint256 amount) {
105         return balanceOf[_who];
106     }
107 }