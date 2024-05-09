1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9 
10         c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a / b;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25         c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 contract Common {
32     event Pause();
33     event Unpause();
34     event OwnershipRenounced(address indexed previousOwner);
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     bool public paused = false;
38     address public owner;
39 
40     modifier whenNotPaused() {
41         require(!paused);
42         _;
43     }
44 
45     modifier whenPaused() {
46         require(paused);
47         _;
48     }
49 
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     constructor() public {
56         owner = msg.sender;
57     }
58 
59     function pause() onlyOwner whenNotPaused public {
60         paused = true;
61         emit Pause();
62     }
63 
64     function unpause() onlyOwner whenPaused public {
65         paused = false;
66         emit Unpause();
67     }
68 
69     function renounceOwnership() public onlyOwner {
70         emit OwnershipRenounced(owner);
71         owner = address(0);
72     }
73 
74     function transferOwnership(address _newOwner) public onlyOwner {
75         _transferOwnership(_newOwner);
76     }
77 
78     function _transferOwnership(address _newOwner) internal {
79         require(_newOwner != address(0));
80         emit OwnershipTransferred(owner, _newOwner);
81         owner = _newOwner;
82     }
83 
84 }
85 
86 contract ERC20 {
87     function allowance(address owner, address spender) public view returns (uint256);
88     function transferFrom(address from, address to, uint256 value) public returns (bool);
89     function approve(address spender, uint256 value) public returns (bool);
90     function totalSupply() public view returns (uint256);
91     function balanceOf(address who) public view returns (uint256);
92     function transfer(address to, uint256 value) public returns (bool);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 contract MTCToken is Common,ERC20 {
98     using SafeMath for uint256;
99     event Burn(address indexed burner, uint256 value);
100 
101     mapping (address => mapping (address => uint256)) internal allowed;
102     mapping(address => uint256) balances;
103     uint256 totalSupply_;
104 
105     string public name = "MTCToken";
106     string public symbol = "MTC";
107     uint256 public decimals = 18;
108 
109     constructor() public {
110         totalSupply_ = 100 * 100000000  * ( 10** decimals );
111         balances[msg.sender] = totalSupply_;
112         emit Transfer(address(0x0), msg.sender, totalSupply_);
113     }
114 
115     function totalSupply() public view returns (uint256) {
116         return totalSupply_;
117     }
118 
119     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
120         require(_to != address(0));
121         require(_value <= balances[msg.sender]);
122 
123         balances[msg.sender] = balances[msg.sender].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         emit Transfer(msg.sender, _to, _value);
126         return true;
127     }
128 
129     function balanceOf(address _owner) public view returns (uint256) {
130         return balances[_owner];
131     }
132 
133     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool)
134     {
135         require(_to != address(0));
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);
138 
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         emit Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     function allowance(address _owner, address _spender) public view returns (uint256)
153     {
154         return allowed[_owner][_spender];
155     }
156 
157     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool){
158         allowed[msg.sender][_spender] = (
159         allowed[msg.sender][_spender].add(_addedValue));
160         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161         return true;
162     }
163 
164     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool){
165         uint oldValue = allowed[msg.sender][_spender];
166         if (_subtractedValue > oldValue) {
167             allowed[msg.sender][_spender] = 0;
168         } else {
169             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
170         }
171         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172         return true;
173     }
174 
175     function burn(uint256 _value) onlyOwner public {
176         _burn(msg.sender, _value);
177     }
178 
179     function _burn(address _who, uint256 _value) internal {
180         require(_value <= balances[_who]);
181         balances[_who] = balances[_who].sub(_value);
182         totalSupply_ = totalSupply_.sub(_value);
183         emit Burn(_who, _value);
184         emit Transfer(_who, address(0), _value);
185     }
186 
187     function setName(string _name) onlyOwner public {
188         name = _name;
189     }
190 
191     function setSymbol(string _symbol) onlyOwner public {
192         symbol = _symbol;
193     }
194 
195     function() payable public {
196         revert();
197     }
198 }