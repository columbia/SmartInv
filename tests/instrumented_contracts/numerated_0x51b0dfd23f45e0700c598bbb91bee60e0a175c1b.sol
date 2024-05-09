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
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34   address public owner;
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   function Ownable() public {
40     owner = msg.sender;
41   }
42 
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48   function transferOwnership(address newOwner) public onlyOwner {
49     require(newOwner != address(0));
50     OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53 
54 }
55 
56 contract Pausable is Ownable {
57   event Pause();
58   event Unpause();
59 
60   bool public paused = false;
61 
62   modifier whenNotPaused() {
63     require(!paused);
64     _;
65   }
66 
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   function pause() onlyOwner whenNotPaused public {
73     paused = true;
74     Pause();
75   }
76 
77   function unpause() onlyOwner whenPaused public {
78     paused = false;
79     Unpause();
80   }
81 }
82 
83 
84 contract ERC20 {
85     function totalSupply() public view returns (uint256);
86     function balanceOf(address who) public view returns (uint256);
87     function allowance(address owner, address spender) public view returns (uint256);
88     function transfer(address to, uint256 value) public returns (bool);
89     function transferFrom(address from, address to, uint256 value) public returns (bool);
90     function approve(address spender, uint256 value) public returns (bool);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 contract FriendsCoin is ERC20, Ownable, Pausable {
97 
98     using SafeMath for uint256;
99 
100     string public name;
101     string public symbol;
102     uint8 public decimals;
103     uint256 initialSupply;
104     uint256 totalSupply_;
105 
106     mapping(address => uint256) balances;
107     mapping(address => mapping(address => uint256)) internal allowed;
108 
109     function FriendsCoin() public {
110         name = "FriendsCoin";
111         symbol = "FZC";
112         decimals = 18;
113         initialSupply = 30000000000;
114         totalSupply_ = initialSupply * 10 ** uint(decimals);
115         balances[owner] = totalSupply_;
116         Transfer(address(0), owner, totalSupply_);
117     }
118 
119     function totalSupply() public view returns (uint256) {
120         return totalSupply_;
121     }
122 
123     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
124         require(_to != address(0));
125         require(_value <= balances[msg.sender]);
126 
127         // SafeMath.sub will throw if there is not enough balance.
128         balances[msg.sender] = balances[msg.sender].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         Transfer(msg.sender, _to, _value);
131         return true;
132     }
133 
134     function balanceOf(address _owner) public view returns (uint256 balance) {
135         return balances[_owner];
136     }
137 
138     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
139         require(_to != address(0));
140         require(_value <= balances[_from]);
141         require(_value <= allowed[_from][msg.sender]);
142 
143         balances[_from] = balances[_from].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146         Transfer(_from, _to, _value);
147         return true;
148     }
149 
150     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
151         require(_value > 0);
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     function allowance(address _owner, address _spender) public view returns (uint256) {
158         return allowed[_owner][_spender];
159     }
160 
161     function burn(uint256 _value) public onlyOwner returns (bool success) {
162         require(_value <= balances[msg.sender]);
163         address burner = msg.sender;
164         balances[burner] = balances[burner].sub(_value);
165         totalSupply_ = totalSupply_.sub(_value);
166         return true;
167     }
168 
169     function () public payable {
170         revert();
171     }
172 
173     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
174         require(_to != address(0));
175         require(_value <= balances[owner]);
176 
177         balances[owner] = balances[owner].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         Transfer(owner, _to, _value);
180         return true;
181     }
182 }