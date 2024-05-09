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
50     string public name;             // contract's name
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
104         name = "NRB_Tokens";
105         tokenlenth = 1;
106         registerAndValidateToken(ETH_address, "Ethereum", "ETH", 18, 7812500000000000);
107     }
108 
109     function getTokenListLength() constant public returns (uint) {
110         return tokenlenth-1;
111     }
112 
113     function getTokenByIndex(uint _index) constant public returns (bool, uint, uint, uint, string, string, address) {
114         return getTokenByAddress(tokenlist[_index]);
115     }
116 
117     function getTokenByAddress(address _token) constant public returns (bool, uint, uint, uint, string, string, address) {
118         Token memory _t = tokens[_token];
119         return (_t.validated, _t.index, _t.decimals, _t.nextRecord, _t.name, _t.symbol, _t.addrs);
120     }
121 
122     function getTokenAddressByIndex(uint _index) constant public returns (address) {
123         return tokens[tokenlist[_index]].addrs;
124     }
125 
126     function isTokenRegistered(address _token) constant public returns (bool) {
127         return tokens[_token].registered;
128     }
129 
130     function registerTokenPayment(address _token, uint _value) public onlyWhitelisted() {
131         raisedAmount[_token] = raisedAmount[_token] + _value;
132     }
133 
134     function registerAndValidateToken(address _token, string _name, string _symbol, uint _decimals, uint _nextRecord) public onlyOwner() {
135         registerToken(_token, _name, _symbol, _decimals, _nextRecord);
136         tokens[_token].validated = true;
137     }
138 
139     function registerToken(address _token, string _name, string _symbol, uint _decimals, uint _nextRecord) public onlyWhitelisted() {
140         require(!tokens[_token].validated);
141         if (_token != ETH_address) {
142             require(ERC20Interface(_token).totalSupply() > 0);
143             require(ERC20Interface(_token).balanceOf(address(this)) == 0);
144         }
145         tokens[_token].validated = false;
146         tokens[_token].registered = true;
147         tokens[_token].addrs = _token;
148         tokens[_token].name = _name;
149         tokens[_token].symbol = _symbol;
150         tokens[_token].decimals = _decimals;
151         tokens[_token].index = tokenlenth;
152         tokens[_token].nextRecord = _nextRecord;
153         tokenlist[tokenlenth] = _token;
154         tokenlenth++;
155     }
156 
157     function validateToken(address _token, bool _valid) public onlyOwner() {
158         tokens[_token].validated = _valid;
159     }
160 
161     function sendFLC(address user, address token, uint totalpaid) public onlyWhitelisted() returns (uint) {
162         uint flc = 0;
163         uint next = 0;
164         (flc, next) = calculateFLCCore(token, totalpaid);
165         if (flc > 0) {
166             tokens[token].nextRecord = next;
167             FLC(FLC_address).create(flc);
168             ERC20Interface(FLC_address).transfer(user, flc);
169         }
170         return flc;
171     }
172 
173     function calculateFLC(address token, uint totalpaid) constant public returns (uint) {
174         uint flc = 0;
175         uint next = 0;
176         (flc, next) = calculateFLCCore(token, totalpaid);
177         return flc;
178     }
179 
180     function calculateFLCCore(address token, uint totalpaid) constant public returns (uint, uint) {
181         uint next = tokens[token].nextRecord;
182         uint flc = 0;
183         while (next <= totalpaid) {
184             next = next * 2;
185             flc++;
186         }
187         return (flc, next);
188     }
189 
190     // recover tokens sent accidentally
191     function _withdrawal(address _token) public {
192         uint _balance =  ERC20Interface(_token).balanceOf(address(this));
193         if (_balance > 0) {
194             ERC20Interface(_token).transfer(owner, _balance);
195         }
196     }
197     
198     // Don't accept ETH
199     function () public payable {
200         revert();
201     }
202 }