1 pragma solidity ^0.4.24;
2 
3 contract owned {
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
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract Stopped is owned {
21 
22     bool public stopped = true;
23 
24     modifier noStopped {
25         assert(!stopped);
26         _;
27     }
28 
29     function start() onlyOwner public {
30       stopped = false;
31     }
32 
33     function stop() onlyOwner public {
34       stopped = true;
35     }
36 
37 }
38 
39 contract MathTCT {
40 
41     function add(uint256 x, uint256 y) constant internal returns(uint256 z) {
42       assert((z = x + y) >= x);
43     }
44 
45     function sub(uint256 x, uint256 y) constant internal returns(uint256 z) {
46       assert((z = x - y) <= x);
47     }
48 }
49 
50 contract TokenERC20 {
51 
52     function totalSupply() constant public returns (uint256 supply);
53     function balanceOf(address who) constant public returns (uint256 value);
54     function allowance(address owner, address spender) constant public returns (uint256 _allowance);
55     function transfer(address to, uint value) public returns (bool ok);
56     function transferFrom( address from, address to, uint value) public returns (bool ok);
57     function approve( address spender, uint value) public returns (bool ok);
58 
59     event Transfer( address indexed from, address indexed to, uint value);
60     event Approval( address indexed owner, address indexed spender, uint value);
61 
62 }
63 
64 contract TCT is owned, Stopped, MathTCT, TokenERC20 {
65 
66     string public name;
67     string public symbol;
68     uint8 public decimals = 18;
69     uint256 public totalSupply;
70 
71     mapping (address => uint256) public balanceOf;
72     mapping (address => mapping (address => uint256)) public allowance;
73     mapping (address => bool) public frozenAccount;
74 
75     event FrozenFunds(address target, bool frozen);
76     event Burn(address from, uint256 value);
77 
78     constructor(string _name, string _symbol) public {
79         totalSupply = 200000000 * 10 ** uint256(decimals);
80         balanceOf[msg.sender] = totalSupply;
81         name = _name;
82         symbol = _symbol;
83     }
84 
85     function totalSupply() constant public returns (uint256) {
86         return totalSupply;
87     }
88 
89     function balanceOf(address who) constant public returns (uint) {
90         return balanceOf[who];
91     }
92 
93     function allowance(address owner, address spender) constant public returns (uint256) {
94         return allowance[owner][spender];
95     }
96 
97     function _transfer(address _from, address _to, uint _value) internal {
98         require (_to != 0x0);
99         require (balanceOf[_from] >= _value);
100         require(!frozenAccount[_from]);
101         require(!frozenAccount[_to]);
102         balanceOf[_from] = sub(balanceOf[_from], _value);
103         balanceOf[_to] = add(balanceOf[_to], _value);
104         emit Transfer(_from, _to, _value);
105     }
106 
107     function transfer(address _to, uint256 _value) noStopped public returns(bool) {
108         _transfer(msg.sender, _to, _value);
109         return true;
110     }
111 
112     function transferFrom(address _from, address _to, uint256 _value) noStopped public returns (bool success) {
113         require(_value <= allowance[_from][msg.sender]);
114         allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value);
115         _transfer(_from, _to, _value);
116         return true;
117     }
118 
119     function approve(address _spender, uint256 _value) noStopped public returns (bool success) {
120         require(!frozenAccount[msg.sender]);
121         require(!frozenAccount[_spender]);
122         allowance[msg.sender][_spender] = _value;
123         return true;
124     }
125 
126     function mintToken(address target, uint256 mintedAmount) noStopped onlyOwner public {
127         balanceOf[target] = add(balanceOf[target], mintedAmount);
128         totalSupply = add(totalSupply, mintedAmount);
129         emit Transfer(0, target, mintedAmount);
130     }
131 
132     function freezeAccount(address target, bool freeze) noStopped onlyOwner public {
133         frozenAccount[target] = freeze;
134         emit FrozenFunds(target, freeze);
135     }
136 
137     function burn(uint256 _value) noStopped public returns (bool success) {
138         require(!frozenAccount[msg.sender]);
139         require(balanceOf[msg.sender] >= _value);
140         balanceOf[msg.sender] = sub(balanceOf[msg.sender], _value);
141         totalSupply = sub(totalSupply, _value);
142         emit Burn(msg.sender, _value);
143         return true;
144     }
145 
146     function burnFrom(address _from, uint256 _value) noStopped public returns (bool success) {
147         require(!frozenAccount[msg.sender]);
148         require(!frozenAccount[_from]);
149         require(balanceOf[_from] >= _value);
150         require(_value <= allowance[_from][msg.sender]);
151         balanceOf[_from] = sub(balanceOf[_from], _value);
152         allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value);
153         totalSupply = sub(totalSupply, _value);
154         emit Burn(_from, _value);
155         return true;
156     }
157 
158 }