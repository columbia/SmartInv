1 pragma solidity ^0.4.15;
2 
3 contract Oracle {
4     event NewSymbol(string _symbol, uint8 _decimals);
5     function getTimestamp(string symbol) constant returns(uint256);
6     function getRateFor(string symbol) returns (uint256);
7     function getCost(string symbol) constant returns (uint256);
8     function getDecimals(string symbol) constant returns (uint256);
9 }
10 
11 contract Token {
12     function transfer(address _to, uint _value) returns (bool success);
13     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
14     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
15     function approve(address _spender, uint256 _value) returns (bool success);
16     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
17 }
18 
19 
20 contract LightOracle is Oracle {
21     Token public token = Token(0xF970b8E36e23F7fC3FD752EeA86f8Be8D83375A6);
22 
23     address public owner;
24     address public provider1;
25     address public provider2;
26     address public collector = this;
27 
28     string public currency = "ARS";
29     uint8 public decimals = 2;
30 
31     uint256 private rate;
32     uint256 private cost;
33 
34     uint256 public updateTimestamp;
35 
36     bool public deprecated;
37 
38     mapping(address => bool) public blacklist;
39 
40     event RateDelivered(uint256 _rate, uint256 _cost, uint256 _timestamp);
41 
42     function LightOracle() public {
43         owner = msg.sender;
44         NewSymbol(currency, decimals);
45     }
46 
47     function updateRate(uint256 _rate) public {
48         require(msg.sender == provider1 || msg.sender == provider2 || msg.sender == owner);
49         rate = _rate;
50         updateTimestamp = block.timestamp;
51     }
52     
53     function updateCost(uint256 _cost) public {
54         require(msg.sender == provider1 || msg.sender == provider2 || msg.sender == owner);
55         cost = _cost;
56     }
57 
58     function getTimestamp(string symbol) constant returns (uint256) {
59         require(isCurrency(symbol));
60         return updateTimestamp;
61     }
62     
63     function getRateFor(string symbol) public returns (uint256) {
64         require(isCurrency(symbol));
65         require(!blacklist[msg.sender]);
66         uint256 costRcn = cost * rate;
67         require(token.transferFrom(msg.sender, collector, costRcn));
68         RateDelivered(rate, costRcn, updateTimestamp);
69         return rate;
70     }
71 
72     function isContract(address addr) internal returns (bool) {
73         uint size;
74         assembly { size := extcodesize(addr) }
75         return size > 0;
76     }
77 
78     function getCost(string symbol) constant returns (uint256) {
79         require(isCurrency(symbol));
80         require(!blacklist[msg.sender]);
81         return cost * rate;
82     }
83 
84     function getDecimals(string symbol) constant returns (uint256) {
85         require(isCurrency(symbol));
86         return decimals;
87     }
88 
89     function getRateForExternal(string symbol) constant returns (uint256) {
90         require(isCurrency(symbol));
91         require(!blacklist[msg.sender]);
92         require(!isContract(msg.sender));
93         return rate;
94     }
95 
96     function setProvider1(address _provider) public returns (bool) {
97         require(msg.sender == owner);
98         provider1 = _provider;
99         return true;
100     }
101 
102     function setProvider2(address _provider) public returns (bool) {
103         require(msg.sender == owner);
104         provider2 = _provider;
105         return true;
106     }
107 
108     function transfer(address to) public returns (bool) {
109         require(msg.sender == owner);
110         require(to != address(0));
111         owner = to;
112         return true;
113     }
114 
115     function setDeprecated(bool _deprecated) public returns (bool) {
116         require(msg.sender == owner);
117         deprecated = _deprecated;
118         return true;
119     }
120 
121     function withdrawal(Token _token, address to, uint256 amount) returns (bool) {
122         require (msg.sender == owner);
123         require (to != address(0));
124         require (_token != to);
125         return _token.transfer(to, amount);
126     }
127 
128     function setBlacklist(address to, bool blacklisted) returns (bool) {
129         require (msg.sender == owner);
130         blacklist[to] = blacklisted;
131         return true;
132     }
133 
134     function setCollector(address _collector) returns (bool) {
135         require (msg.sender == owner);
136         collector = _collector;
137         return true;
138     }
139 
140     function isCurrency(string target) internal returns (bool) {
141         bytes memory t = bytes(target);
142         bytes memory c = bytes(currency);
143         if (t.length != c.length) return false;
144         if (t[0] != c[0]) return false;
145         if (t[1] != c[1]) return false;
146         if (t[2] != c[2]) return false;
147         return true;
148     } 
149 }