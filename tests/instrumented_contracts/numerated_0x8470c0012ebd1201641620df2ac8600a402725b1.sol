1 pragma solidity ^0.4.18;
2 
3 /* @nitzaalfinas */
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 contract MerialCoin {
25 
26     using SafeMath for uint256;
27 
28     string  public symbol;
29     string  public name;
30     uint8   public decimals;
31     uint256 public totalSupply;
32 
33     address public owner;
34 
35     mapping (address => uint256) public balanceOf;
36     mapping (address => bool) public frozenAddress;
37     mapping (address => mapping (address => uint256)) public allowance;
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event FrozenAddress(address indexed target, bool frozen);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42     event Burn(address indexed from, uint256 value);
43 
44     constructor () public {
45         name        = 'Merial Coin';
46         symbol      = 'MRA';
47         decimals    = 18;
48         totalSupply = 1000000000 * 10 ** uint256(decimals);
49 
50         owner                 = msg.sender;
51         balanceOf[msg.sender] = totalSupply;
52     }
53 
54     function transferOwnership(address _newOwner) public returns (bool success) {
55         require(msg.sender == owner);
56         owner = _newOwner;
57         return true;
58     }
59 
60     function totalSupply() public view returns (uint256) {
61         return totalSupply;
62     }
63 
64     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
65         return balanceOf[tokenOwner];
66     }
67 
68 
69     function _transfer(address _from, address _to, uint _value) internal {
70 
71         require(_to != address(0x0));
72 
73         require(!frozenAddress[_from]);
74 
75         require(!frozenAddress[_to]);
76 
77         require(_from != _to);
78 
79         require(balanceOf[_from] >= _value);
80 
81         require(balanceOf[_to] + _value >= balanceOf[_to]);
82 
83         uint previousBalances = balanceOf[_from] + balanceOf[_to];
84 
85         balanceOf[_from] = balanceOf[_from].sub(_value);
86 
87         balanceOf[_to] = balanceOf[_to].add(_value);
88 
89         emit Transfer(_from, _to, _value);
90 
91         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
92     }
93 
94     function transfer(address _to, uint256 _value) public returns (bool success) {
95         _transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         require (_value <= allowance[_from][msg.sender]);
101         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
102         _transfer(_from, _to, _value);
103         return true;
104     }
105 
106     function freezeAddress(address target, bool freeze) public returns (bool success) {
107 
108         require(msg.sender == owner);
109         require(target != owner);
110         require(msg.sender != target);
111 
112         frozenAddress[target] = freeze;
113 
114         emit FrozenAddress(target, freeze);
115 
116         return true;
117     }
118 
119     function approve(address _spender, uint256 _value) public returns (bool success) {
120         require(!frozenAddress[msg.sender]);
121         require(!frozenAddress[_spender]);
122         require(msg.sender != _spender);
123         allowance[msg.sender][_spender] = _value;
124         emit Approval(msg.sender, _spender, _value);
125         return true;
126     }
127 
128     function burn(uint256 _value) public returns (bool success) {
129         require(!frozenAddress[msg.sender]);
130         require(balanceOf[msg.sender] >= _value);
131         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
132         totalSupply = totalSupply.sub(_value);
133         emit Burn(msg.sender, _value);
134         return true;
135     }
136 
137     function burnFrom(address _from, uint256 _value) public returns (bool success) {
138         require(!frozenAddress[msg.sender]);
139         require(!frozenAddress[_from]);
140         require(balanceOf[_from] >= _value);
141         require(_value <= allowance[_from][msg.sender] );
142         balanceOf[_from] = balanceOf[_from].sub(_value);
143         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
144         totalSupply = totalSupply.sub(_value);
145         emit Burn(msg.sender, _value);
146         return true;
147     }
148 
149 }