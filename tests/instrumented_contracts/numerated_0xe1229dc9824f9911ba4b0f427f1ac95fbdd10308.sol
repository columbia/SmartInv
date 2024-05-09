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
46 	
47 	function kill(){
48        if (owner == msg.sender) { 
49           selfdestruct(owner);
50        }
51     }
52 }
53 
54 contract ERC20Basic is Ownable {
55     uint256 public totalSupply;
56     function balanceOf(address who) public constant returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract BasicToken is ERC20Basic {
62     using SafeMath for uint256;
63 
64     mapping(address => uint256) balances;
65 
66     function transfer(address _to, uint256 _value) public returns (bool) {
67         balances[msg.sender] = balances[msg.sender].sub(_value);
68         balances[_to] = balances[_to].add(_value);
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72 
73     function balanceOf(address _owner) public constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77 }
78 
79 contract ERC20 is ERC20Basic {
80     function allowance(address owner, address spender) constant returns (uint256);
81     function transferFrom(address from, address to, uint256 value) returns (bool);
82     function approve(address spender, uint256 value) returns (bool);
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89     mapping (address => mapping (address => uint256)) allowed;
90 
91 
92     event Burn(address indexed burner, uint256 value);
93     
94     event Mint(address indexed to, uint256 amount);
95     event MintFinished();
96 
97     bool public mintingFinished = false;
98 
99     modifier canMint() {
100         require(!mintingFinished);
101         _;
102     }
103 
104     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
105         totalSupply = totalSupply.add(_amount);
106         balances[_to] = balances[_to].add(_amount);
107         emit Mint(_to, _amount);
108         emit Transfer(address(0), _to, _amount);
109         return true;
110     }
111 
112     function finishMinting() onlyOwner canMint public returns (bool) {
113         mintingFinished = true;
114         emit MintFinished();
115         return true;
116     }
117 
118     function burn(uint256 _value) public {
119         require(_value <= balances[msg.sender]);
120 
121         address burner = msg.sender;
122         balances[burner] = balances[burner].sub(_value);
123         totalSupply = totalSupply.sub(_value);
124         Burn(burner, _value);
125         Transfer(burner, address(0), _value);
126     }
127 
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
129         require(_to != address(0));
130         require(_value <= balances[_from]);
131         require(_value <= allowed[_from][msg.sender]);
132 
133         balances[_from] = balances[_from].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136         Transfer(_from, _to, _value);
137         return true;
138     }
139 
140     function approve(address _spender, uint256 _value) public returns (bool) {
141 
142         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
143     
144         allowed[msg.sender][_spender] = _value;
145         Approval(msg.sender, _spender, _value);
146         return true;
147     }
148 
149     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
150         return allowed[_owner][_spender];
151     }
152 }
153 
154 contract TNPC is StandardToken 
155 {
156     string  public constant name           = "The New Public Coin";
157     string  public constant symbol         = "TNPC";
158     uint256 public constant decimals       = 8;
159     uint256 public constant INITIAL_SUPPLY = 70000000 * 10**8;
160     function TNPC() 
161 	{
162          totalSupply          = INITIAL_SUPPLY;
163          balances[msg.sender] = INITIAL_SUPPLY;
164     }
165 }