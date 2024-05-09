1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 contract Pausable is Ownable {
59   event Pause();
60   event Unpause();
61 
62   bool public paused = false;
63 
64   modifier whenNotPaused() {
65     require(!paused);
66     _;
67   }
68 
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     Pause();
77   }
78 
79   function unpause() onlyOwner whenPaused public {
80     paused = false;
81     Unpause();
82   }
83 }
84 
85 
86 
87 contract ERC20 {
88     function totalSupply() public view returns (uint256);
89     function balanceOf(address who) public view returns (uint256);
90     function allowance(address owner, address spender) public view returns (uint256);
91     function transfer(address to, uint256 value) public returns (bool);
92     function transferFrom(address from, address to, uint256 value) public returns (bool);
93     function approve(address spender, uint256 value) public returns (bool);
94 
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 contract ChieldCureToken is ERC20, Ownable, Pausable {
100 
101     using SafeMath for uint256;
102 
103     string public name;
104     string public symbol;
105     uint8 public decimals;
106     uint256 initialSupply;
107     uint256 totalSupply_;
108 
109     mapping(address => uint256) balances;
110     mapping(address => bool) internal locks;
111     mapping(address => mapping(address => uint256)) internal allowed;
112 
113     function ChieldCureToken() public {
114         name = "CHIELDCURE";
115         symbol = "CD";
116         decimals = 18;
117         initialSupply = 10000000000;
118         totalSupply_ = initialSupply * 10 ** uint(decimals);
119         balances[owner] = totalSupply_;
120         Transfer(address(0), owner, totalSupply_);
121     }
122 
123     function totalSupply() public view returns (uint256) {
124         return totalSupply_;
125     }
126 
127     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
128         require(_to != address(0));
129         require(_value <= balances[msg.sender]);
130         require(locks[msg.sender] == false);
131 
132         // SafeMath.sub will throw if there is not enough balance.
133         balances[msg.sender] = balances[msg.sender].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         Transfer(msg.sender, _to, _value);
136         return true;
137     }
138 
139     function balanceOf(address _owner) public view returns (uint256 balance) {
140         return balances[_owner];
141     }
142 
143     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
144         require(_to != address(0));
145         require(_value <= balances[_from]);
146         require(_value <= allowed[_from][msg.sender]);
147         require(locks[_from] == false);
148 
149         balances[_from] = balances[_from].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152         Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
157         require(_value > 0);
158         allowed[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160         return true;
161     }
162 
163     function allowance(address _owner, address _spender) public view returns (uint256) {
164         return allowed[_owner][_spender];
165     }
166 
167     function burn(uint256 _value) public onlyOwner returns (bool success) {
168         require(_value <= balances[msg.sender]);
169         address burner = msg.sender;
170         balances[burner] = balances[burner].sub(_value);
171         totalSupply_ = totalSupply_.sub(_value);
172         return true;
173     }
174 
175     function lock(address _owner) public onlyOwner returns (bool) {
176         require(locks[_owner] == false);
177         locks[_owner] = true;
178         return true;
179     }
180 
181     function unlock(address _owner) public onlyOwner returns (bool) {
182         require(locks[_owner] == true);
183         locks[_owner] = false;
184         return true;
185     }
186 
187     function showLockState(address _owner) public view returns (bool) {
188         return locks[_owner];
189     }
190 
191     function () public payable {
192         revert();
193     }
194 
195     function mint( uint256 _amount) onlyOwner public returns (bool) {
196         totalSupply_ = totalSupply_.add(_amount);
197         balances[owner] = balances[owner].add(_amount);
198 
199         Transfer(address(0), owner, _amount);
200         return true;
201     }
202 
203     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
204         require(_to != address(0));
205         require(_value <= balances[owner]);
206 
207         balances[owner] = balances[owner].sub(_value);
208         balances[_to] = balances[_to].add(_value);
209         Transfer(owner, _to, _value);
210         return true;
211     }
212 }