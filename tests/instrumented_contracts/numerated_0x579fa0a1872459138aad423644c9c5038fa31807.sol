1 /* ==================================================================== */
2 /* Copyright (c) 2018 The ether.online Project.  All rights reserved.
3 /* 
4 /* https://ether.online  The first RPG game of blockchain 
5 /*  
6 /* authors rickhunter.shen@gmail.com   
7 /*         ssesunding@gmail.com            
8 /* ==================================================================== */
9 
10 pragma solidity ^0.4.20;
11 
12 contract AccessAdmin {
13     bool public isPaused = false;
14     address public addrAdmin;  
15 
16     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
17 
18     function AccessAdmin() public {
19         addrAdmin = msg.sender;
20     }  
21 
22 
23     modifier onlyAdmin() {
24         require(msg.sender == addrAdmin);
25         _;
26     }
27 
28     modifier whenNotPaused() {
29         require(!isPaused);
30         _;
31     }
32 
33     modifier whenPaused {
34         require(isPaused);
35         _;
36     }
37 
38     function setAdmin(address _newAdmin) external onlyAdmin {
39         require(_newAdmin != address(0));
40         AdminTransferred(addrAdmin, _newAdmin);
41         addrAdmin = _newAdmin;
42     }
43 
44     function doPause() external onlyAdmin whenNotPaused {
45         isPaused = true;
46     }
47 
48     function doUnpause() external onlyAdmin whenPaused {
49         isPaused = false;
50     }
51 }
52 
53 contract AccessService is AccessAdmin {
54     address public addrService;
55     address public addrFinance;
56 
57     modifier onlyService() {
58         require(msg.sender == addrService);
59         _;
60     }
61 
62     modifier onlyFinance() {
63         require(msg.sender == addrFinance);
64         _;
65     }
66 
67     function setService(address _newService) external {
68         require(msg.sender == addrService || msg.sender == addrAdmin);
69         require(_newService != address(0));
70         addrService = _newService;
71     }
72 
73     function setFinance(address _newFinance) external {
74         require(msg.sender == addrFinance || msg.sender == addrAdmin);
75         require(_newFinance != address(0));
76         addrFinance = _newFinance;
77     }
78 
79     function withdraw(address _target, uint256 _amount) 
80         external 
81     {
82         require(msg.sender == addrFinance || msg.sender == addrAdmin);
83         require(_amount > 0);
84         address receiver = _target == address(0) ? addrFinance : _target;
85         uint256 balance = this.balance;
86         if (_amount < balance) {
87             receiver.transfer(_amount);
88         } else {
89             receiver.transfer(this.balance);
90         }      
91     }
92 }
93 
94 interface shareRecipient { 
95     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
96 }
97 
98 contract EOMarketToken is AccessService {
99     uint8 public decimals = 0;
100     uint256 public totalSupply = 100;
101     uint256 public totalSold = 0;
102     string public name = " Ether Online Shares Token";
103     string public symbol = "EOST";
104 
105     mapping (address => uint256) balances;
106     mapping (address => mapping(address => uint256)) allowed;
107     address[] shareholders;
108     mapping (address => uint256) addressToIndex;
109 
110     event Transfer(address indexed _from, address indexed _to, uint256 _value);
111     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
112 
113     function EOMarketToken() public {
114         addrAdmin = msg.sender;
115         addrService = msg.sender;
116         addrFinance = msg.sender;
117 
118         balances[this] = totalSupply;
119     }
120 
121     function() external payable {
122 
123     }
124 
125     function balanceOf(address _owner) external view returns (uint256) {
126         return balances[_owner];
127     }
128 
129     function approve(address _spender, uint256 _value) public returns (bool) {
130         allowed[msg.sender][_spender] = _value;
131         Approval(msg.sender, _spender, _value);
132         return true;
133     }
134 
135     function allowance(address _owner, address _spender) external view returns (uint256) {
136         return allowed[_owner][_spender];
137     }
138 
139     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
140         require(_value <= allowed[_from][msg.sender]);
141         allowed[_from][msg.sender] -= _value;
142         return _transfer(_from, _to, _value);
143     }
144 
145     function transfer(address _to, uint256 _value) external returns (bool) {
146         return _transfer(msg.sender, _to, _value);     
147     }
148 
149     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
150         external
151         returns (bool success) 
152     {
153         shareRecipient spender = shareRecipient(_spender);
154         if (approve(_spender, _value)) {
155             spender.receiveApproval(msg.sender, _value, this, _extraData);
156             return true;
157         }
158     }
159 
160     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
161         require(_to != address(0));
162         uint256 oldToVal = balances[_to];
163         uint256 oldFromVal = balances[_from];
164         require(_value > 0 && _value <= oldFromVal);
165         uint256 newToVal = oldToVal + _value;
166         assert(newToVal >= oldToVal);
167         require(newToVal <= 10);
168         uint256 newFromVal = oldFromVal - _value;
169         balances[_from] = newFromVal;
170         balances[_to] = newToVal;
171 
172         if (newFromVal == 0 && _from != address(this)) {
173             uint256 index = addressToIndex[_from];
174             uint256 lastIndex = shareholders.length - 1;
175             if (index != lastIndex) {
176                 shareholders[index] = shareholders[lastIndex];
177                 addressToIndex[shareholders[index]] = index;
178                 delete addressToIndex[_from];
179             }
180             shareholders.length -= 1; 
181         }
182 
183         if (oldToVal == 0) {
184             addressToIndex[_to] = shareholders.length;
185             shareholders.push(_to);
186         }
187 
188         Transfer(_from, _to, _value);
189         return true;
190     }
191 
192     function buy(uint256 _amount) 
193         external 
194         payable
195         whenNotPaused
196     {    
197         require(_amount > 0 && _amount <= 10);
198         uint256 price = (1 ether) * _amount;
199         require(msg.value == price);
200         require(balances[this] > _amount);
201         uint256 newBanlance = balances[msg.sender] + _amount;
202         assert(newBanlance >= _amount);
203         require(newBanlance <= 10);
204         _transfer(this, msg.sender, _amount);
205         totalSold += _amount;
206         addrFinance.transfer(price);
207     }
208 
209     function getShareholders() external view returns(address[100] addrArray, uint256[100] amountArray, uint256 soldAmount) {
210         uint256 length = shareholders.length;
211         for (uint256 i = 0; i < length; ++i) {
212             addrArray[i] = shareholders[i];
213             amountArray[i] = balances[shareholders[i]];
214         } 
215         soldAmount = totalSold;
216     }
217 }