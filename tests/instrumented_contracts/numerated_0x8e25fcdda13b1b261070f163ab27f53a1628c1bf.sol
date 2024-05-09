1 pragma solidity ^0.4.18;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4         uint256 c = a * b;
5         assert(a == 0 || c / a == b);
6         return c;
7     }
8 
9     function div(uint256 a, uint256 b) internal pure returns (uint256) {
10         // assert(b > 0); // Solidity automatically throws when dividing by 0
11         uint256 c = a / b;
12         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 
27     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
28         return a >= b ? a : b;
29     }
30 
31     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
32         return a < b ? a : b;
33     }
34 
35     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
36         return a >= b ? a : b;
37     }
38 
39     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a < b ? a : b;
41     }
42 
43 }
44 contract Ownable {
45     address public owner;
46     function Ownable() public {
47         owner = msg.sender;
48     }
49 
50     modifier onlyOwner() {
51         if (msg.sender != owner) {
52             revert();
53         }
54         _;
55     }
56 
57     function transferOwnership(address newOwner) public onlyOwner {
58         if (newOwner != address(0)) {
59             owner = newOwner;
60         }
61     }
62 
63     function destruct() public onlyOwner {
64         selfdestruct(owner);
65     }
66 }
67 contract ERC20Basic {
68     function balanceOf(address who) public constant returns (uint256);
69     function transfer(address to, uint256 value) public;
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 contract ERC20 is ERC20Basic {
73     function allowance(address owner, address spender) public constant returns (uint256);
74     function transferFrom(address from, address to, uint256 value) public;
75     function approve(address spender, uint256 value) public;
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 contract BasicToken is ERC20Basic {
79     using SafeMath for uint256;
80 
81     mapping(address => uint256) balances;
82     uint256 public totalSupply;
83 
84     modifier onlyPayloadSize(uint256 size) {
85         if(msg.data.length < size + 4) {
86             revert();
87         }
88         _;
89     }
90 
91     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) {
92         balances[msg.sender] = balances[msg.sender].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         Transfer(msg.sender, _to, _value);
95     }
96 
97     function balanceOf(address _owner) public constant returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101 }
102 contract StandardToken is BasicToken, ERC20 {
103 
104     mapping (address => mapping (address => uint256)) allowed;
105 
106     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) {
107         var _allowance = allowed[_from][msg.sender];
108         balances[_to] = balances[_to].add(_value);
109         balances[_from] = balances[_from].sub(_value);
110         allowed[_from][msg.sender] = _allowance.sub(_value);
111         Transfer(_from, _to, _value);
112     }
113 
114     function approve(address _spender, uint256 _value) public {
115         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
116 
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119     }
120 
121     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
122         return allowed[_owner][_spender];
123     }
124 }
125 contract LTS is StandardToken, Ownable {
126 
127     string public constant name = "I love the sauce（我爱酱小白）";
128     string public constant symbol = "LTS";
129     uint256 public constant decimals = 8;
130 
131     function LTS() public {
132         owner = msg.sender;
133         totalSupply=10000000000000000;
134         balances[owner]=totalSupply;
135     }
136 
137     function () public {
138         revert();
139     }
140 }