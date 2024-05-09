1 pragma solidity ^0.4.24;
2 
3 
4 contract Owned {
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         owner = newOwner;
18     }
19 }
20 
21 
22 contract SafeMath {
23     function mul(uint a, uint b) internal pure returns (uint) {
24         uint c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function div(uint a, uint b) internal pure returns (uint) {
30         assert(b > 0);
31         uint c = a / b;
32         assert(a == b * c + a % b);
33         return c;
34     }
35 
36     function sub(uint a, uint b) internal pure returns (uint) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint a, uint b) internal pure returns (uint) {
42         uint c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract Pausable is Owned {
49     bool public paused = false;
50     event Pause();
51     event Unpause();
52 
53     modifier notPaused {
54         require(!paused);
55         _;
56     }
57 
58     function pause() public onlyOwner {
59         paused = true;
60         emit Pause();
61     }
62 
63     function unpause() public onlyOwner {
64         paused = false;
65         emit Unpause();
66     }
67 }
68 
69 contract EIP20Interface {
70     function totalSupply() public view returns (uint256);
71     function balanceOf(address _owner) public view returns (uint256 balance);
72     function transfer(address _to, uint256 _value) public returns (bool success);
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
74     function approve(address _spender, uint256 _value) public returns (bool success);
75     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 }
80 
81 
82 contract Qobit is Owned, SafeMath, Pausable, EIP20Interface {
83     uint256 private totalSupply_;
84     string public name;
85     string public symbol;
86     uint8 public decimals;
87     
88     mapping (address => uint256) public balances;
89     mapping (address => uint256) public frozen;
90     mapping (address => mapping (address => uint256)) public allowed;
91 
92     event Freeze(address indexed from, uint256 value);
93     event Unfreeze(address indexed from, uint256 value);
94     event Burned(address indexed from, uint256 value);
95 
96     constructor() public {
97         name = "Qobit.com Token";
98         symbol = "QOBI";
99         decimals = 8;
100         totalSupply_ = 1500000000 * 10 ** uint256(decimals);
101         balances[msg.sender] = totalSupply_;
102     }
103 
104     // mint part
105     function mint(address _addr, uint256 _amount) onlyOwner public returns (bool success) {
106         require(_addr != 0x0);
107         totalSupply_ = add(totalSupply_, _amount);
108         balances[_addr] = add(balances[_addr], _amount);
109         emit Transfer(address(0), _addr, _amount);
110         return true;
111     }
112 
113     // burn
114     function burn(address _addr, uint256 _amount) onlyOwner public returns (bool success) {
115         require(_addr != 0);
116         require(_amount <= balances[_addr]);
117 
118         totalSupply_ = sub(totalSupply_, _amount);
119         balances[_addr] = sub(balances[_addr], _amount);
120         emit Transfer(_addr, address(0), _amount);
121         emit Burned(_addr, _amount);
122         return true;
123     }
124 
125     // freeze part
126     function freeze(address _addr, uint256 _value) public onlyOwner returns (bool success) {
127         require(balances[_addr] >= _value);
128         require(_value > 0);
129         balances[_addr] = sub(balances[_addr], _value);
130         frozen[_addr] = add(frozen[_addr], _value);
131         emit Freeze(_addr, _value);
132         return true;
133     }
134     
135     function unfreeze(address _addr, uint256 _value) public onlyOwner returns (bool success) {
136         require(frozen[_addr] >= _value);
137         require(_value > 0);
138         frozen[_addr] = sub(frozen[_addr], _value);
139         balances[_addr] = add(balances[_addr], _value);
140         emit Unfreeze(_addr, _value);
141         return true;
142     }
143 
144     function frozenOf(address _addr) public view returns (uint256 balance) {
145         return frozen[_addr];
146     }
147     
148     // erc20 part
149     function totalSupply() public view returns (uint256) {
150         return totalSupply_;
151     }
152 
153     function balanceOf(address _addr) public view returns (uint256 balance) {
154         return balances[_addr];
155     }
156 
157     function transfer(address _to, uint256 _value) public notPaused returns (bool success) {
158         require(balances[msg.sender] >= _value);
159         require(balances[_to] + _value >= balances[_to]);
160         balances[msg.sender] -= _value;
161         balances[_to] += _value;
162         emit Transfer(msg.sender, _to, _value);
163         return true;
164     }
165 
166     function transferFrom(address _from, address _to, uint256 _value) public notPaused returns (bool success) {
167         require(balances[_from] >= _value);
168         require(balances[_to] + _value >= balances[_to]);
169         require(allowed[_from][msg.sender] >= _value);
170         balances[_to] += _value;
171         balances[_from] -= _value;
172         allowed[_from][msg.sender] -= _value;
173         emit Transfer(_from, _to, _value);
174         return true;
175     }
176 
177     function approve(address _spender, uint256 _value) public notPaused returns (bool success) {
178         require(_value > 0);
179         allowed[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
185         return allowed[_owner][_spender];
186     } 
187 }