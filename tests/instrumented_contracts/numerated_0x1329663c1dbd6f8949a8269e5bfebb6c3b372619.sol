1 pragma solidity 0.4.18;
2 
3 /*===========================================
4 =                                           =
5 =     Provided by KEPLER LAB                =
6 =     Please visit https://keplerlab.io/    =
7 =                                           =
8 ============================================*/
9 
10 
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13         uint256 c = a * b;
14         assert(a == 0 || c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal constant returns (uint256) {
19         uint256 c = a / b;
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal constant returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 contract Ownable {
36     address public owner;
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     function Ownable() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) onlyOwner public {
49         require(newOwner != address(0));
50         OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 }
54 
55 contract ERC20 {
56     uint256 public totalSupply;
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 
61     function allowance(address owner, address spender) public view returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract Pausable is Ownable {
68     event Paused();
69     event Unpaused();
70 
71     bool public pause = false;
72 
73     modifier whenNotPaused() {
74         require(!pause);
75         _;
76     }
77 
78     modifier whenPaused() {
79         require(pause);
80         _;
81     }
82 
83     function pause() onlyOwner whenNotPaused public {
84         pause = true;
85         Paused();
86     }
87 
88     function unpause() onlyOwner whenPaused public {
89         pause = false;
90         Unpaused();
91     }
92 }
93 
94 contract StandardToken is ERC20, Pausable {
95     using SafeMath for uint256;
96 
97     mapping (address => uint256) balances;
98     mapping (address => mapping (address => uint256)) allowed;
99 
100     event AddSupply(address indexed from, uint256 value);
101     event Burn(address indexed from, uint256 value);
102 
103     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
104         require(_to != address(0));
105         require(_value > 0);
106 
107         balances[msg.sender] = balances[msg.sender].sub(_value);
108         balances[_to] = balances[_to].add(_value);
109         Transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
114         require(_from != address(0));
115         require(_to != address(0));
116 
117         uint256 _allowance = allowed[_from][msg.sender];
118 
119         balances[_from] = balances[_from].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         allowed[_from][msg.sender] = _allowance.sub(_value);
122         Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     function balanceOf(address _owner) public constant returns (uint256 balance) {
127         return balances[_owner];
128     }
129 
130     function approve(address _spender, uint256 _value) public returns (bool) {
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
137         return allowed[_owner][_spender];
138     }
139 
140     function addSupply(uint256 _value) onlyOwner public returns (bool success) {
141         require(_value > 0);      
142         balances[msg.sender] = balances[msg.sender].add(_value);                    
143         totalSupply = totalSupply.add(_value);                          
144         AddSupply(msg.sender, _value);
145         return true;
146     }
147 
148     function burn(uint256 _value) public returns (bool success) {
149         require(_value > 0); 
150         require(balances[msg.sender] >= _value);         
151         balances[msg.sender] = balances[msg.sender].sub(_value);                    
152         totalSupply = totalSupply.sub(_value);                          
153         Burn(msg.sender, _value);
154         return true;
155     }
156 }
157 
158 contract DCCToken is StandardToken {
159 
160     string public name = "David Coin";
161     string public symbol = "DCC";
162     uint public decimals = 18;
163 
164     uint public constant TOTAL_SUPPLY    = 10000e18;
165     address public constant WALLET_DCC   = 0x6a0Dc4629C0a6A655e8E4DC80b017145b1774622; 
166 
167     function DCCToken() public {
168         balances[msg.sender] = TOTAL_SUPPLY;
169         totalSupply = TOTAL_SUPPLY;
170 
171         transfer(WALLET_DCC, TOTAL_SUPPLY);
172     }
173 
174     function() payable public { }
175 
176     function withdrawEther() public {
177         if (address(this).balance > 0)
178 		    owner.send(address(this).balance);
179 	}
180 
181     function withdrawSelfToken() public {
182         if(balanceOf(this) > 0)
183             this.transfer(WALLET_DCC, balanceOf(this));
184     }
185 
186     function close() public onlyOwner {
187         selfdestruct(owner);
188     }
189 }