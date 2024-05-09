1 pragma solidity ^0.4.16;
2 
3 contract ERC20 {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) public constant returns (uint balance);
6     function transfer(address _to, uint _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
8     function approve(address _spender, uint _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint remaining);
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a * b;
17         assert(a == 0 || c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a / b;
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 contract StandardToken is ERC20 {
39     using SafeMath for uint256;
40 
41     mapping(address => uint256) balances;
42     mapping(address => mapping (address => uint256)) internal allowed;
43 
44     function transfer(address _to, uint256 _value) public returns (bool) {
45         require(_to != address(0));
46         require(_value <= balances[msg.sender]);
47 
48         balances[msg.sender] = balances[msg.sender].sub(_value);
49         balances[_to] = balances[_to].add(_value);
50         Transfer(msg.sender, _to, _value);
51         return true;
52     }
53 
54     function balanceOf(address _owner) public constant returns (uint256 balance) {
55         return balances[_owner];
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
59         require(_to != address(0));
60         require(_value <= balances[_from]);
61         require(_value <= allowed[_from][msg.sender]);
62 
63         balances[_from] = balances[_from].sub(_value);
64         balances[_to] = balances[_to].add(_value);
65         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
66         Transfer(_from, _to, _value);
67         return true;
68     }
69 
70     function approve(address _spender, uint256 _value) public returns (bool) {
71         allowed[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
77         return allowed[_owner][_spender];
78     }
79 
80     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
81         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
82         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
83         return true;
84     }
85 
86     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
87         uint oldValue = allowed[msg.sender][_spender];
88         if (_subtractedValue > oldValue) {
89             allowed[msg.sender][_spender] = 0;
90         } else {
91             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
92         }
93         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
94         return true;
95     }
96 }
97 
98 contract Ownable {
99     address public owner;
100 
101     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
102 
103     function Ownable() public {
104         owner = msg.sender;
105     }
106 
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111 
112     function transferOwnership(address newOwner) onlyOwner public {
113         require(newOwner != address(0));
114         OwnershipTransferred(owner, newOwner);
115         owner = newOwner;
116     }
117 }
118 
119 contract BurnableToken is StandardToken {
120     event Burn(address indexed burner, uint256 value);
121 
122     function burn(uint256 _value) public {
123         require(_value > 0);
124         require(_value <= balances[msg.sender]);
125 
126         address burner = msg.sender;
127         balances[burner] = balances[burner].sub(_value);
128         totalSupply = totalSupply.sub(_value);
129         Burn(burner, _value);
130     }
131 }
132 
133 contract WysToken is BurnableToken, Ownable {
134     string public constant name = "wys Token";
135     string public constant symbol = "WYS";
136     uint8 public constant decimals = 18;
137     string public version = "2.0";
138 
139     address internal wyskerTeam;
140     uint256 public totalSupply;
141 
142     function WysToken(uint256 _totalSupply, address _wyskerTeam) public {
143         wyskerTeam = _wyskerTeam;
144         totalSupply = _totalSupply;
145         balances[wyskerTeam] = totalSupply;
146     }
147 
148     function issueTokens(address _to, uint256 _value) onlyOwner public returns (bool) {
149         require(_to != address(0));
150         require(_value <= balances[wyskerTeam]);
151 
152         balances[wyskerTeam] = balances[wyskerTeam].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154         Transfer(msg.sender, _to, _value);
155         return true;
156     }
157 }