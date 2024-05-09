1 pragma solidity ^0.4.16;
2 
3 contract EOCHToken {
4 
5     string public name = "Everything On Chain for Health";      //  token name
6     string public symbol = "EOCH";           //  token symbol
7     uint256 public decimals = 6;            //  token digit
8     uint256 constant valueFounder = 16000000000000000;
9 
10     mapping (address => uint256) public balanceMap;
11     mapping (address => uint256) public frozenOf; // ##
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     uint256 public totalSupply = 0;
15     bool public stopped = false;
16     bool public isMultiply = true;
17 
18     address owner = 0x0;
19 
20     modifier isOwner {
21         assert(owner == msg.sender);
22         _;
23     }
24 
25     modifier isRunning {
26         assert (!stopped);
27         _;
28     }
29 
30     modifier isMulti {
31         assert (isMultiply);
32         _;
33     }
34 
35     modifier validAddress {
36         assert(0x0 != msg.sender);
37         _;
38     }
39 
40     function EOCHToken() {
41         owner = msg.sender;
42         totalSupply = valueFounder;
43         balanceMap[owner] = valueFounder;
44         Transfer(0x0, owner, valueFounder);
45     }
46 
47     function transfer(address _to, uint256 _value) isRunning validAddress returns (bool success) {
48         require(balanceMap[msg.sender] >= _value);
49         require(balanceMap[_to] + _value >= balanceMap[_to]);
50         balanceMap[msg.sender] -= _value;
51         balanceMap[_to] += _value;
52         Transfer(msg.sender, _to, _value);
53         return true;
54     }
55 
56     function transferMulti(
57         address _to_1,
58         address _to_2,
59         address _to_3,
60         address _to_4,
61         address _to_5,
62         address _to_6,
63         address _to_7,
64         address _to_8,
65         address _to_9,
66         address _to_10,
67         uint256 _value) isRunning validAddress isMulti returns (bool success) {
68 
69         require(10 * _value > 0 && balanceMap[msg.sender] >= 10 * _value);
70         require(balanceMap[_to_1] + _value >= balanceMap[_to_1]) ;
71         require(balanceMap[_to_2] + _value >= balanceMap[_to_2]) ;
72         require(balanceMap[_to_3] + _value >= balanceMap[_to_3]) ;
73         require(balanceMap[_to_4] + _value >= balanceMap[_to_4]) ;
74         require(balanceMap[_to_5] + _value >= balanceMap[_to_5]) ;
75         require(balanceMap[_to_6] + _value >= balanceMap[_to_6]) ;
76         require(balanceMap[_to_7] + _value >= balanceMap[_to_7]) ;
77         require(balanceMap[_to_8] + _value >= balanceMap[_to_8]) ;
78         require(balanceMap[_to_9] + _value >= balanceMap[_to_9]) ;
79         require(balanceMap[_to_10] + _value >= balanceMap[_to_10]) ;
80 
81         balanceMap[msg.sender] -= 10 * _value;
82         balanceMap[_to_1] += _value;
83         balanceMap[_to_2] += _value;
84         balanceMap[_to_3] += _value;
85         balanceMap[_to_4] += _value;
86         balanceMap[_to_5] += _value;
87         balanceMap[_to_6] += _value;
88         balanceMap[_to_7] += _value;
89         balanceMap[_to_8] += _value;
90         balanceMap[_to_9] += _value;
91         balanceMap[_to_10] += _value;
92 
93         return true;
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress returns (bool success) {
97         require(balanceMap[_from] >= _value);
98         require(balanceMap[_to] + _value >= balanceMap[_to]);
99         require(allowance[_from][msg.sender] >= _value);
100         balanceMap[_to] += _value;
101         balanceMap[_from] -= _value;
102         allowance[_from][msg.sender] -= _value;
103         Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     function approve(address _spender, uint256 _value) isRunning validAddress returns (bool success) {
108         require(_value == 0 || allowance[msg.sender][_spender] == 0);
109         allowance[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function stop() isOwner {
115         stopped = true;
116     }
117 
118     function start() isOwner {
119         stopped = false;
120     }
121 
122     function stopMulti() isOwner {
123         isMultiply = false;
124     }
125 
126     function startMulti() isOwner {
127         isMultiply = true;
128     }
129 
130     function setName(string _name) isOwner {
131         name = _name;
132     }
133 
134     function burn(uint256 _value) {
135         require(balanceMap[msg.sender] >= _value);
136         balanceMap[msg.sender] -= _value;
137         balanceMap[0x0] += _value;
138         Transfer(msg.sender, 0x0, _value);
139     }
140 
141     event Transfer(address indexed _from, address indexed _to, uint256 _value);
142     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
143 
144     // ##
145 
146     function balanceOf(address _owner) public constant returns (uint256 balance){
147         return balanceMap[_owner] + frozenOf[_owner];
148     }
149 
150     function frozen(address targetAddress , uint256 value) public isOwner returns (bool success){
151 
152         require(balanceMap[targetAddress] >= value); // check has enough
153 
154         uint256 count = balanceMap[targetAddress] + frozenOf[targetAddress];
155 
156         balanceMap[targetAddress] -= value;
157         frozenOf[targetAddress] += value;
158 
159         require(count == balanceMap[targetAddress] + frozenOf[targetAddress]);
160 
161         return true;
162     }
163 
164     function unfrozen(address targetAddress, uint256 value) public isOwner returns (bool success){
165 
166         require(frozenOf[targetAddress] >= value); // check has enough
167 
168         uint256 count = balanceMap[targetAddress] + frozenOf[targetAddress];
169 
170         balanceMap[targetAddress] += value;
171         frozenOf[targetAddress] -= value;
172 
173         require(count == balanceMap[targetAddress] + frozenOf[targetAddress]);
174 
175         return true;
176     }
177 
178     function frozenOf(address targetAddress) public constant returns (uint256 frozen){
179         return frozenOf[targetAddress];
180     }
181 
182     function frozenOf() public constant returns (uint256 frozen){
183         return frozenOf[msg.sender];
184     }
185 }