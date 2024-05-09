1 pragma solidity ^0.4.14;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function transfer(address to, uint tokens) public returns (bool success);
7 }
8 
9 // ----------------------------------------------------------------------------
10 // Four Leaf clover (FLC) Token interface 
11 // ----------------------------------------------------------------------------
12 contract FLC {
13     function create(uint units) public;
14 }
15 
16 
17 // ----------------------------------------------------------------------------
18 // contract WhiteListAccess
19 // ----------------------------------------------------------------------------
20 contract WhiteListAccess {
21     
22     function WhiteListAccess() public {
23         owner = msg.sender;
24         whitelist[owner] = true;
25         whitelist[address(this)] = true;        
26     }
27     
28     address public owner;
29     mapping (address => bool) whitelist;
30 
31     modifier onlyBy(address who) { require(msg.sender == who); _; }
32     modifier onlyOwner {require(msg.sender == owner); _;}
33     modifier onlyWhitelisted {require(whitelist[msg.sender]); _;}
34 
35     function addToWhiteList(address trusted) public onlyOwner() {
36         whitelist[trusted] = true;
37     }
38 
39     function removeFromWhiteList(address untrusted) public onlyOwner() {
40         whitelist[untrusted] = false;
41     }
42 
43 }
44 
45 // ----------------------------------------------------------------------------
46 // NRB_Common contract
47 // ----------------------------------------------------------------------------
48 contract NRB_Common is WhiteListAccess {
49     
50     // Ownership    
51     bool _init;
52     
53     function NRB_Common() public { ETH_address = 0x1; }
54 
55     // Deployment
56     address public ETH_address;    // representation of Ether as Token (0x1)
57     address public FLC_address;
58     address public NRB_address;
59 
60     function init(address _main, address _flc) public {
61         require(!_init);
62         FLC_address = _flc;
63         NRB_address = _main;
64         whitelist[NRB_address] = true;
65         _init = true;
66     }
67 
68     // Debug
69     event Debug(string, bool);
70     event Debug(string, uint);
71     event Debug(string, uint, uint);
72     event Debug(string, uint, uint, uint);
73     event Debug(string, uint, uint, uint, uint);
74     event Debug(string, address);
75     event Debug(string, address, address);
76     event Debug(string, address, address, address);
77 }
78 
79 // ----------------------------------------------------------------------------
80 // NRB_Tokens (main) contract
81 // ----------------------------------------------------------------------------
82 
83 contract NRB_Tokens is NRB_Common {
84 
85     // how much raised for each token
86     mapping(address => uint) raisedAmount;
87 
88     mapping(address => Token) public tokens;
89     mapping(uint => address) public tokenlist;
90     uint public tokenlenth;
91     
92     struct Token {
93         bool registered;
94         bool validated;
95         uint index;
96         uint decimals;
97         uint nextRecord;
98         string name;
99         string symbol;
100         address addrs;
101     }
102 
103     function NRB_Tokens() public {
104         tokenlenth = 1;
105         registerAndValidateToken(ETH_address, "Ethereum", "ETH", 18, 7812500000000000);
106     }
107 
108     function getTokenListLength() constant public returns (uint) {
109         return tokenlenth-1;
110     }
111 
112     function getTokenByIndex(uint _index) constant public returns (bool, uint, uint, uint, string, string, address) {
113         return getTokenByAddress(tokenlist[_index]);
114     }
115 
116     function getTokenByAddress(address _token) constant public returns (bool, uint, uint, uint, string, string, address) {
117         Token memory _t = tokens[_token];
118         return (_t.validated, _t.index, _t.decimals, _t.nextRecord, _t.name, _t.symbol, _t.addrs);
119     }
120 
121     function getTokenAddressByIndex(uint _index) constant public returns (address) {
122         return tokens[tokenlist[_index]].addrs;
123     }
124 
125     function isTokenRegistered(address _token) constant public returns (bool) {
126         return tokens[_token].registered;
127     }
128 
129     function registerTokenPayment(address _token, uint _value) public onlyWhitelisted() {
130         raisedAmount[_token] = raisedAmount[_token] + _value;
131     }
132 
133     function registerAndValidateToken(address _token, string _name, string _symbol, uint _decimals, uint _nextRecord) public onlyOwner() {
134         registerToken(_token, _name, _symbol, _decimals, _nextRecord);
135         tokens[_token].validated = true;
136     }
137 
138     function registerToken(address _token, string _name, string _symbol, uint _decimals, uint _nextRecord) public onlyWhitelisted() {
139         require(!tokens[_token].validated);
140         if (_token != ETH_address) {
141             require(ERC20Interface(_token).totalSupply() > 0);
142             require(ERC20Interface(_token).balanceOf(address(this)) == 0);
143         }
144         tokens[_token].validated = false;
145         tokens[_token].registered = true;
146         tokens[_token].addrs = _token;
147         tokens[_token].name = _name;
148         tokens[_token].symbol = _symbol;
149         tokens[_token].decimals = _decimals;
150         tokens[_token].index = tokenlenth;
151         tokens[_token].nextRecord = _nextRecord;
152         tokenlist[tokenlenth] = _token;
153         tokenlenth++;
154     }
155 
156     function validateToken(address _token, bool _valid) public onlyOwner() {
157         tokens[_token].validated = _valid;
158     }
159 
160     function sendFLC(address user, address token, uint totalpaid) public onlyWhitelisted() returns (uint) {
161         uint flc = 0;
162         uint next = 0;
163         (flc, next) = calculateFLCCore(token, totalpaid);
164         if (flc > 0) {
165             tokens[token].nextRecord = next;
166             FLC(FLC_address).create(flc);
167             ERC20Interface(FLC_address).transfer(user, flc);
168         }
169         return flc;
170     }
171 
172     function calculateFLC(address token, uint totalpaid) constant public returns (uint) {
173         uint flc = 0;
174         uint next = 0;
175         (flc, next) = calculateFLCCore(token, totalpaid);
176         return flc;
177     }
178 
179     function calculateFLCCore(address token, uint totalpaid) constant public returns (uint, uint) {
180         uint next = tokens[token].nextRecord;
181         uint flc = 0;
182         while (next <= totalpaid) {
183             next = next * 2;
184             flc++;
185         }
186         return (flc, next);
187     }
188 
189 }