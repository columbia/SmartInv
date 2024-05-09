1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28     uint256 public totalSupply;
29     function balanceOf(address who) public constant returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35     function allowance(address owner, address spender) public constant returns (uint256);
36     function transferFrom(address from, address to, uint256 value) public returns (bool);
37     function approve(address spender, uint256 value) public returns (bool);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract TrineChain is ERC20 {
42     
43     using SafeMath for uint256; 
44     address owner = msg.sender; 
45 
46     mapping (address => uint256) balances; 
47     mapping (address => mapping (address => uint256)) allowed;
48     mapping (address => uint256) locknum; 
49 
50     string public constant name = "TrineChain";
51     string public constant symbol = "TRCOS";
52     uint public constant decimals = 18;
53     uint256 _Rate = 10 ** decimals;    
54     uint256 public totalSupply = 270000000 * _Rate;
55     
56 
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60     event Locked(address indexed to, uint256 amount);
61 
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     modifier onlyPayloadSize(uint size) {
68         assert(msg.data.length >= size + 4);
69         _;
70     }
71 
72      function TrineChain() public {
73         balances[owner] = totalSupply;
74     }
75 
76     function transferOwnership(address newOwner) onlyOwner public {
77         if (newOwner != address(0) && newOwner != owner) {
78              owner = newOwner;   
79         }
80     }
81 
82 
83     function lock(address _to, uint256 _amount) private returns (bool) {
84         require(owner != _to);
85         require(_amount > 0);
86         require(_amount * _Rate  <= balances[_to]);
87         locknum[_to]=_amount * _Rate;
88         Locked(_to, _amount * _Rate);
89         return true;
90     }
91 
92     function locked(address[] addresses, uint256[] amounts) onlyOwner public {
93 
94         require(addresses.length <= 255);
95         require(addresses.length == amounts.length);
96         
97         for (uint8 i = 0; i < addresses.length; i++) {
98             lock(addresses[i], amounts[i]);
99         }
100     }
101 
102     function distr(address _to, uint256 _amount) private returns (bool) {
103         require(owner != _to);
104         require(_amount > 0);
105         require(balances[owner] >= _amount * _Rate);
106 
107         balances[owner] = balances[owner].sub(_amount * _Rate);
108         balances[_to] = balances[_to].add(_amount * _Rate);
109         locknum[_to] += lockcheck(_amount) * _Rate;
110         
111         Transfer(owner, _to, _amount * _Rate);
112         return true;
113     }
114 
115     function lockcheck(uint256 _amount) internal pure returns (uint256) {
116         if(_amount < 3000){
117         return _amount * 4/10;
118         }
119         if(_amount >= 3000 && _amount < 10000){
120         return _amount * 5/10;
121         }
122         if(_amount >= 10000 && _amount < 50000){
123         return _amount * 6/10;
124         }
125         if(_amount >= 50000 && _amount < 500000){
126         return _amount * 7/10;
127         }
128         if(_amount >= 500000){
129         return _amount * 8/10;
130         }
131     }
132     
133     function distribute(address[] addresses, uint256[] amounts) onlyOwner public {
134 
135         require(addresses.length <= 255);
136         require(addresses.length == amounts.length);
137         
138         for (uint8 i = 0; i < addresses.length; i++) {
139             distr(addresses[i], amounts[i]);
140         }
141     }
142 
143     function lockedOf(address _owner) constant public returns (uint256) {
144         return locknum[_owner];
145     }
146 
147     function balanceOf(address _owner) constant public returns (uint256) {
148 	    return balances[_owner];
149     }
150 
151     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
152 
153         require(_to != address(0));
154         require(_amount <= balances[msg.sender]);
155         require(_amount <= balances[msg.sender].sub(locknum[msg.sender]));
156         balances[msg.sender] = balances[msg.sender].sub(_amount);
157         balances[_to] = balances[_to].add(_amount);
158         Transfer(msg.sender, _to, _amount);
159         return true;
160     }
161 
162     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
163 
164         require(_to != address(0));
165         require(_amount <= balances[_from]);
166         require(_amount <= balances[_from].sub(locknum[_from]));
167         require(_amount <= allowed[_from][msg.sender]);
168         
169         balances[_from] = balances[_from].sub(_amount);
170         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
171         balances[_to] = balances[_to].add(_amount);
172         Transfer(_from, _to, _amount);
173         return true;
174     }
175 
176     function approve(address _spender, uint256 _value) public returns (bool success) {
177         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
178         allowed[msg.sender][_spender] = _value;
179         Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     function allowance(address _owner, address _spender) constant public returns (uint256) {
184         return allowed[_owner][_spender];
185     }
186 }