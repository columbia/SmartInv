1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Ownable {
28   address public owner;
29   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30   function Ownable() public {
31     owner = msg.sender;
32   }
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 }
43 
44 contract Pausable is Ownable {
45   event Pause();
46   event Unpause();
47   bool public paused = false;
48   modifier whenNotPaused() {
49     require(!paused);
50     _;
51   }
52   modifier whenPaused() {
53     require(paused);
54     _;
55   }
56   function pause() onlyOwner whenNotPaused public {
57     paused = true;
58     Pause();
59   }
60   function unpause() onlyOwner whenPaused public {
61     paused = false;
62     Unpause();
63   }
64   
65 }
66 
67 contract ERC20 {
68     function totalSupply() public view returns (uint256);
69     function balanceOf(address who) public view returns (uint256);
70     function allowance(address owner, address spender) public view returns (uint256);
71     function transfer(address to, uint256 value) public returns (bool);
72     function transferFrom(address from, address to, uint256 value) public returns (bool);
73     function approve(address spender, uint256 value) public returns (bool);
74 
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 contract CocacolaToken is ERC20, Pausable {
79 
80     using SafeMath for uint256;
81 
82     string public name;
83     string public symbol;
84     uint8 public decimals;
85     uint256 initialSupply;
86     uint256 totalSupply_;
87 
88     mapping(address => uint256) balances;
89     mapping(address => bool) internal locks;
90     mapping(address => mapping(address => uint256)) internal allowed;
91 
92     function CocacolaToken() public {
93         name = "COCACOLA";
94         symbol = "COLA";
95         decimals = 18;
96         initialSupply = 10000000000;
97         totalSupply_ = initialSupply * 10 ** uint(decimals);
98         balances[owner] = totalSupply_;
99         Transfer(address(0), owner, totalSupply_);
100     }
101     function () public payable {
102         revert();
103     }
104     function totalSupply() public view returns (uint256) {
105         return totalSupply_;
106     }
107     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
108         require(_to != address(0));
109         require(_value <= balances[msg.sender]);
110         require(locks[msg.sender] == false);
111 
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         Transfer(msg.sender, _to, _value);
115         return true;
116     }
117     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
118         require(_to != address(0));
119         require(_value <= balances[_from]);
120         require(_value <= allowed[_from][msg.sender]);
121         require(locks[_from] == false);
122 
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         Transfer(_from, _to, _value);
127         return true;
128     }
129     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
130         require(_value > 0);
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135     function balanceOf(address _owner) public view returns (uint256 balance) {
136         return balances[_owner];
137     }
138     function allowance(address _owner, address _spender) public view returns (uint256) {
139         return allowed[_owner][_spender];
140     }
141     function lock(address _owner) public onlyOwner returns (bool) {
142         require(locks[_owner] == false);
143         locks[_owner] = true;
144         return true;
145     }
146     function unlock(address _owner) public onlyOwner returns (bool) {
147         require(locks[_owner] == true);
148         locks[_owner] = false;
149         return true;
150     }
151     function showLockState(address _owner) public view returns (bool) {
152         return locks[_owner];
153     }
154     function mint( uint256 _amount) onlyOwner public returns (bool) {
155         totalSupply_ = totalSupply_.add(_amount);
156         balances[owner] = balances[owner].add(_amount);
157         Transfer(address(0), owner, _amount);
158         return true;
159     }
160     function burn(uint256 _value) public onlyOwner returns (bool success) {
161         require(_value <= balances[msg.sender]);
162         address burner = msg.sender;
163         balances[burner] = balances[burner].sub(_value);
164         totalSupply_ = totalSupply_.sub(_value);
165         return true;
166     }
167 }