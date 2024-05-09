1 pragma solidity ^0.4.18;
2 
3 
4 contract owned {
5     address public owner;
6     address public candidate;
7 
8     function owned() payable internal {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(owner == msg.sender);
14         _;
15     }
16 
17     function changeOwner(address _owner) onlyOwner public {
18         candidate = _owner;
19     }
20 
21     function confirmOwner() public {
22         require(candidate != address(0));
23         require(candidate == msg.sender);
24         owner = candidate;
25         delete candidate;
26     }
27 }
28 
29 
30 library SafeMath {
31     function sub(uint256 a, uint256 b) pure internal returns (uint256) {
32         assert(a >= b);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) pure internal returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a && c >= b);
39         return c;
40     }
41     
42     function times(uint256 a, uint256 b) pure internal returns (uint256) {
43     uint c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function divides(uint256 a, uint256 b) pure internal returns (uint256) {
49     assert(b > 0);
50     uint c = a / b;
51     assert(a == b * c + a % b);
52     return c;
53   }
54   
55   
56     
57 }
58 
59 
60 contract ERC20 {
61     uint256 public totalSupply;
62     function balanceOf(address who) public constant returns (uint256 value);
63     function allowance(address owner, address spender) public constant returns (uint256 _allowance);
64     function transfer(address to, uint256 value) public returns (bool success);
65     function transferFrom(address from, address to, uint256 value) public returns (bool success);
66     function approve(address spender, uint256 value) public returns (bool success);
67 
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 
73 contract AGTC is ERC20, owned {
74     using SafeMath for uint256;
75     string public name = "ASGARSTAR";
76     string public symbol = "AGTC";
77     uint8 public decimals = 18;
78     uint256 public totalSupply;
79 
80     mapping (address => uint256) private balances;
81     mapping (address => mapping (address => uint256)) private allowed;
82 
83     function balanceOf(address _who) public constant returns (uint256) {
84         return balances[_who];
85     }
86 
87     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88         return allowed[_owner][_spender];
89     }
90 
91     function AGTC() public {
92         totalSupply = 210000000 * 1 ether;
93         balances[msg.sender] = totalSupply;
94         Transfer(0, msg.sender, totalSupply);
95     }
96 
97     function transfer(address _to, uint256 _value) public returns (bool success) {
98         require(_to != address(0));
99         require(balances[msg.sender] >= _value);
100         balances[msg.sender] = balances[msg.sender].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         Transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107         require(_to != address(0));
108         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
109         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
110         balances[_from] = balances[_from].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     function approve(address _spender, uint256 _value) public returns (bool success) {
117         require(_spender != address(0));
118         require(balances[msg.sender] >= _value);
119         allowed[msg.sender][_spender] = _value;
120         Approval(msg.sender, _spender, _value);
121         return true;
122     }
123 
124     function withdrawTokens(uint256 _value) public onlyOwner {
125         require(balances[this] >= _value);
126         balances[this] = balances[this].sub(_value);
127         balances[msg.sender] = balances[msg.sender].add(_value);
128         Transfer(this, msg.sender, _value);
129     }
130 }