1 pragma solidity ^0.4.18;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4         uint256 c = a * b;
5         assert(a == 0 || c / a == b);
6         return c;
7     }
8 
9     function div(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18 
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 
25     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
26         return a >= b ? a : b;
27     }
28 
29     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
30         return a < b ? a : b;
31     }
32 
33     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
34         return a >= b ? a : b;
35     }
36 
37     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
38         return a < b ? a : b;
39     }
40 
41 }
42 contract Ownable {
43     address public owner;
44     function Ownable() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner() {
49         if (msg.sender != owner) {
50             revert();
51         }
52         _;
53     }
54 
55     function transferOwnership(address newOwner) public onlyOwner {
56         if (newOwner != address(0)) {
57             owner = newOwner;
58         }
59     }
60 
61     function destruct() public onlyOwner {
62         selfdestruct(owner);
63     }
64 }
65 contract ERC20Basic {
66     function balanceOf(address who) public constant returns (uint256);
67 	function transfer(address to, uint256 value) public returns (bool success);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 contract ERC20 is ERC20Basic {
71     function allowance(address owner, address spender) public constant returns (uint256);
72     function transferFrom(address from, address to, uint256 value) public;
73     function approve(address spender, uint256 value) public returns (bool success);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 contract BasicToken is ERC20Basic {
77     using SafeMath for uint256;
78 
79     mapping(address => uint256) balances;
80     uint256 public totalSupply;
81 
82     modifier onlyPayloadSize(uint256 size) {
83         if(msg.data.length < size + 4) {
84             revert();
85         }
86         _;
87     }
88 
89     function transfer(address _to, uint256 _value) public returns (bool success) {
90         require(_to != address(0));
91         require(_value <= balances[msg.sender]);
92 
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         Transfer(msg.sender, _to, _value);
96 		return true;
97     }
98 
99     function balanceOf(address _owner) public constant returns (uint256 balance) {
100         return balances[_owner];
101     }
102 
103 }
104 contract StandardToken is BasicToken, ERC20 {
105 
106     mapping (address => mapping (address => uint256)) allowed;
107 
108     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) {
109         require(_to != address(0));
110         require(_value <= balances[_from]);
111         require(_value <= allowed[_from][msg.sender]);
112 
113         var _allowance = allowed[_from][msg.sender];
114         balances[_to] = balances[_to].add(_value);
115         balances[_from] = balances[_from].sub(_value);
116         allowed[_from][msg.sender] = _allowance.sub(_value);
117         Transfer(_from, _to, _value);
118     }
119 
120     function approve(address _spender, uint256 _value) public returns (bool success) {
121         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
122 
123         allowed[msg.sender][_spender] = _value;
124         Approval(msg.sender, _spender, _value);
125 		return true;
126     }
127 
128     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
129         return allowed[_owner][_spender];
130     }
131 }
132 contract COC is StandardToken, Ownable {
133 
134     string public constant name = "COC原油币";
135     string public constant symbol = "COC";
136     uint8 public constant decimals = 18;
137 
138     function COC() public {
139         owner = msg.sender;
140         totalSupply=10000000000000000000000000000;
141         balances[owner]=totalSupply;
142     }
143 
144     function () public {
145         revert();
146     }
147 }