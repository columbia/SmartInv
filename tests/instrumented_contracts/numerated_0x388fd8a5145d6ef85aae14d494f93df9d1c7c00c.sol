1 pragma solidity ^0.4.11;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
4         uint256 c = a * b;
5         assert(a == 0 || c / a == b);
6         return c;
7     }
8 
9     function div(uint256 a, uint256 b) internal constant returns (uint256) {
10         // assert(b > 0); // Solidity automatically throws when dividing by 0
11         uint256 c = a / b;
12         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal constant returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 
29 contract Ownable {
30 
31     address public owner;
32 
33     function Ownable() {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address newOwner) onlyOwner {
43         require(newOwner != address(0));
44         owner = newOwner;
45     }
46 }
47 
48 contract ERC20Basic is Ownable {
49     uint256 public totalSupply;
50     function balanceOf(address who) public constant returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 contract BasicToken is ERC20Basic {
56     using SafeMath for uint256;
57 
58     mapping(address => uint256) balances;
59 
60     function transfer(address _to, uint256 _value) public returns (bool) {
61         balances[msg.sender] = balances[msg.sender].sub(_value);
62         balances[_to] = balances[_to].add(_value);
63         Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function balanceOf(address _owner) public constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71 }
72 
73 contract ERC20 is ERC20Basic {
74     function allowance(address owner, address spender) constant returns (uint256);
75     function transferFrom(address from, address to, uint256 value) returns (bool);
76     function approve(address spender, uint256 value) returns (bool);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 
81 contract StandardToken is ERC20, BasicToken {
82 
83     mapping (address => mapping (address => uint256)) allowed;
84 
85 
86     event Burn(address indexed burner, uint256 value);
87     
88     event Mint(address indexed to, uint256 amount);
89     event MintFinished();
90 
91     bool public mintingFinished = false;
92 
93     modifier canMint() {
94         require(!mintingFinished);
95         _;
96     }
97 
98     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
99         totalSupply = totalSupply.add(_amount);
100         balances[_to] = balances[_to].add(_amount);
101         emit Mint(_to, _amount);
102         emit Transfer(address(0), _to, _amount);
103         return true;
104     }
105 
106     function finishMinting() onlyOwner canMint public returns (bool) {
107         mintingFinished = true;
108         emit MintFinished();
109         return true;
110     }
111 
112     function burn(uint256 _value) public {
113         require(_value <= balances[msg.sender]);
114 
115         address burner = msg.sender;
116         balances[burner] = balances[burner].sub(_value);
117         totalSupply = totalSupply.sub(_value);
118         Burn(burner, _value);
119         Transfer(burner, address(0), _value);
120     }
121 
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123         require(_to != address(0));
124         require(_value <= balances[_from]);
125         require(_value <= allowed[_from][msg.sender]);
126 
127         balances[_from] = balances[_from].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130         Transfer(_from, _to, _value);
131         return true;
132     }
133 
134     function approve(address _spender, uint256 _value) public returns (bool) {
135 
136         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
137     
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144         return allowed[_owner][_spender];
145     }
146 }
147 
148 contract BTRL is StandardToken {
149     string public constant name = "Bitcoin Regular";
150     string public constant symbol = "BTRL";
151     uint256 public constant decimals = 8;
152     uint256 public constant INITIAL_SUPPLY = 21000000 * 10**8;
153     function BTRL() 
154 	{
155         totalSupply = INITIAL_SUPPLY;
156         balances[msg.sender] = INITIAL_SUPPLY;
157     }
158 }