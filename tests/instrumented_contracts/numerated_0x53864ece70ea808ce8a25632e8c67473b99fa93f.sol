1 pragma solidity 0.4.24;
2 
3 contract Owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public returns (bool success) {
16         owner = newOwner;
17         return true;
18     }
19 }
20 
21 contract Stopped is Owned {
22 
23     bool public stopped = true;
24 
25     modifier noStopped {
26         require(!stopped);
27         _;
28     }
29 
30     function start() onlyOwner public {
31       stopped = false;
32     }
33 
34     function stop() onlyOwner public {
35       stopped = true;
36     }
37 
38 }
39 
40 contract MathTCT {
41 
42     function add(uint256 x, uint256 y) pure internal returns(uint256 z) {
43       assert((z = x + y) >= x);
44     }
45 
46     function sub(uint256 x, uint256 y) pure internal returns(uint256 z) {
47       assert((z = x - y) <= x);
48     }
49 }
50 
51 contract TokenERC20 {
52 
53     function totalSupply() view public returns (uint256 supply);
54     function balanceOf(address who) view public returns (uint256 value);
55     function allowance(address owner, address spender) view public returns (uint256 _allowance);
56     function transfer(address to, uint256 value) public returns (bool success);
57     function transferFrom(address from, address to, uint256 value) public returns (bool success);
58     function approve(address spender, uint256 value) public returns (bool success);
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 
63 }
64 
65 contract TCT is Owned, Stopped, MathTCT, TokenERC20 {
66 
67     string public name;
68     string public symbol;
69     uint8 public decimals = 18;
70     uint256 public totalSupply;
71 
72     mapping (address => uint256) public balanceOf;
73     mapping (address => mapping (address => uint256)) public allowance;
74     mapping (address => bool) public frozenAccount;
75 
76     event FrozenFunds(address indexed target, bool frozen);
77     event Burn(address indexed from, uint256 value);
78 
79     constructor(string _name, string _symbol) public {
80         totalSupply = 200000000 * 10 ** uint256(decimals);
81         balanceOf[msg.sender] = totalSupply;
82         name = _name;
83         symbol = _symbol;
84     }
85 
86     function totalSupply() view public returns (uint256 supply) {
87         return totalSupply;
88     }
89 
90     function balanceOf(address who) view public returns (uint256 value) {
91         return balanceOf[who];
92     }
93 
94     function allowance(address owner, address spender) view public returns (uint256 _allowance) {
95         return allowance[owner][spender];
96     }
97 
98     function _transfer(address _from, address _to, uint256 _value) internal {
99         require (_to != 0x0);
100         require (balanceOf[_from] >= _value);
101         require(!frozenAccount[_from]);
102         require(!frozenAccount[_to]);
103         balanceOf[_from] = sub(balanceOf[_from], _value);
104         balanceOf[_to] = add(balanceOf[_to], _value);
105         emit Transfer(_from, _to, _value);
106     }
107 
108     function transfer(address _to, uint256 _value) noStopped public returns(bool success) {
109         _transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     function transferFrom(address _from, address _to, uint256 _value) noStopped public returns (bool success) {
114         require(_value <= allowance[_from][msg.sender]);
115         allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value);
116         _transfer(_from, _to, _value);
117         return true;
118     }
119 
120     function approve(address _spender, uint256 _value) noStopped public returns (bool success) {
121         require(!frozenAccount[msg.sender]);
122         require(!frozenAccount[_spender]);
123         allowance[msg.sender][_spender] = _value;
124         emit Approval(msg.sender, _spender, _value);
125         return true;
126     }
127     
128     function increaseApproval(address _spender, uint256 _addedValue) noStopped public returns (bool success) {
129         require(!frozenAccount[msg.sender]);
130         require(!frozenAccount[_spender]);
131         allowance[msg.sender][_spender] = add(allowance[msg.sender][_spender], _addedValue);
132         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
133         return true;
134     }
135 
136     function decreaseApproval(address _spender, uint256 _subtractedValue) noStopped public returns (bool success) {
137         require(!frozenAccount[msg.sender]);
138         require(!frozenAccount[_spender]);
139         uint256 oldValue = allowance[msg.sender][_spender];
140         if (_subtractedValue > oldValue) {
141             allowance[msg.sender][_spender] = 0;
142         } else {
143             allowance[msg.sender][_spender] = sub(oldValue, _subtractedValue);
144         }
145         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
146         return true;
147     }
148 
149     function freezeAccount(address target, bool freeze) noStopped onlyOwner public returns (bool success) {
150         frozenAccount[target] = freeze;
151         emit FrozenFunds(target, freeze);
152         return true;
153     }
154 
155     function burn(uint256 _value) noStopped onlyOwner public returns (bool success) {
156         require(!frozenAccount[msg.sender]);
157         require(balanceOf[msg.sender] >= _value);
158         balanceOf[msg.sender] = sub(balanceOf[msg.sender], _value);
159         totalSupply = sub(totalSupply, _value);
160         emit Burn(msg.sender, _value);
161         return true;
162     }
163 
164 }