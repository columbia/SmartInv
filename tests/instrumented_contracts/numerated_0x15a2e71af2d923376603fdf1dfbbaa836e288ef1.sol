1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract ERC20Basic {
31     uint256 public totalSupply;
32 
33     function balanceOf(address who) public view returns (uint256);
34 
35     function transfer(address to, uint256 value) public returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41     function allowance(address owner, address spender) public view returns (uint256);
42 
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44 
45     function approve(address spender, uint256 value) public returns (bool);
46 
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract BasicToken is ERC20Basic {
51     using SafeMath for uint256;
52 
53     mapping(address => uint256) balances;
54 
55     function transfer(address _to, uint256 _value) public returns (bool) {
56         require(_to != address(0));
57         require(_value <= balances[msg.sender]);
58 
59         balances[msg.sender] = balances[msg.sender].sub(_value);
60         balances[_to] = balances[_to].add(_value);
61         Transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     function balanceOf(address _owner) public view returns (uint256 balance) {
66         return balances[_owner];
67     }
68 }
69 
70 contract StandardToken is ERC20, BasicToken {
71 
72     mapping(address => mapping(address => uint256)) internal allowed;
73 
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75         require(_to != address(0));
76         require(_value <= balances[_from]);
77         require(_value <= allowed[_from][msg.sender]);
78 
79         balances[_from] = balances[_from].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82         Transfer(_from, _to, _value);
83         return true;
84     }
85 
86     function approve(address _spender, uint256 _value) public returns (bool) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) public view returns (uint256) {
93         return allowed[_owner][_spender];
94     }
95 
96     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
97         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
98         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99         return true;
100     }
101 
102     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
103         uint oldValue = allowed[msg.sender][_spender];
104         if (_subtractedValue > oldValue) {
105             allowed[msg.sender][_spender] = 0;
106         } else {
107             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
108         }
109         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110         return true;
111     }
112 }
113 
114 contract FFFToken is StandardToken {
115     string public name = "FFF News";
116     string public symbol = "FFF";
117     uint8 public constant decimals = 18;
118     uint256 public totalSupply = 100 * (10 ** 8) * (10 ** 18);
119 
120     address owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123     event Burn(address indexed burner, uint256 value);
124 
125     function FFFToken() {
126         owner = msg.sender;
127         balances[owner] = totalSupply;
128         Transfer(address(0), owner, totalSupply);
129     }
130 
131     function transferOwnership(address newOwner) public {
132         require(msg.sender == owner);
133         require(newOwner != address(0));
134         OwnershipTransferred(owner, newOwner);
135         owner = newOwner;
136     }
137 
138     function burn(uint256 _value) public {
139         require(_value <= balances[msg.sender]);
140 
141         address burner = msg.sender;
142         balances[burner] = balances[burner].sub(_value);
143         totalSupply = totalSupply.sub(_value);
144         Burn(burner, _value);
145     }
146 
147     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public returns (bool) {
148         require(msg.sender == owner);
149         return ERC20(tokenAddress).transfer(owner, tokens);
150     }
151 
152     function setName(string s) public {
153         require(msg.sender == owner);
154         name = s;
155     }
156 
157     function setSymbol(string s) public {
158         require(msg.sender == owner);
159         symbol = s;
160     }
161 }