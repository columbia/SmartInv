1 pragma solidity ^0.4.8;
2 
3 /*
4 AvatarNetwork Copyright
5 
6 https://avatarnetwork.io
7 */
8 
9 contract Owned {
10 
11     address owner;
12 
13     function Owned() {
14         owner = msg.sender;
15     }
16 
17     function changeOwner(address newOwner) onlyOwner {
18         owner = newOwner;
19     }
20 
21     modifier onlyOwner() {
22         if (msg.sender==owner) _;
23     }
24 }
25 
26 contract Token is Owned {
27 
28     uint256 public totalSupply;
29     function balanceOf(address _owner) constant returns (uint256 balance);
30     function transfer(address _to, uint256 _value) returns (bool success);
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32     function approve(address _spender, uint256 _value) returns (bool success);
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 contract ERC20Token is Token {
40 
41     function transfer(address _to, uint256 _value) returns (bool success) {
42 
43         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
44             balances[msg.sender] -= _value;
45             balances[_to] += _value;
46             Transfer(msg.sender, _to, _value);
47             return true;
48         } else {
49             return false;
50         }
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54 
55         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
56             balances[_to] += _value;
57             balances[_from] -= _value;
58             allowed[_from][msg.sender] -= _value;
59             Transfer(_from, _to, _value);
60             return true;
61         } else {
62             return false;
63         }
64     }
65 
66     function balanceOf(address _owner) constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     function approve(address _spender, uint256 _value) returns (bool success) {
71         allowed[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
77         return allowed[_owner][_spender];
78     }
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82 }
83 
84 contract Farmercoin is ERC20Token {
85 
86     bool public isTokenSale = true;
87     uint256 public price;
88     uint256 public limit;
89 
90     address walletOut = 0x82833C2703BEd909AdFA29F383A4374C45809b81;
91 
92     function getWalletOut() constant returns (address _to) {
93         return walletOut;
94     }
95 
96     function () external payable  {
97         if (isTokenSale == false) {
98             throw;
99         }
100 
101         uint256 tokenAmount = (msg.value  * 100000000) / price;
102 
103         if (balances[owner] >= tokenAmount && balances[msg.sender] + tokenAmount > balances[msg.sender]) {
104             if (balances[owner] - tokenAmount < limit) {
105                 throw;
106             }
107             balances[owner] -= tokenAmount;
108             balances[msg.sender] += tokenAmount;
109             Transfer(owner, msg.sender, tokenAmount);
110         } else {
111             throw;
112         }
113     }
114 
115     function stopSale() onlyOwner {
116         isTokenSale = false;
117     }
118 
119     function startSale() onlyOwner {
120         isTokenSale = true;
121     }
122 
123     function setPrice(uint256 newPrice) onlyOwner {
124         price = newPrice;
125     }
126 
127     function setLimit(uint256 newLimit) onlyOwner {
128         limit = newLimit;
129     }
130 
131     function setWallet(address _to) onlyOwner {
132         walletOut = _to;
133     }
134 
135     function sendFund() onlyOwner {
136         walletOut.send(this.balance);
137     }
138 
139     string public name;
140     uint8 public decimals;
141     string public symbol;
142     string public version = '1.0';
143 
144     function Farmercoin() {
145         totalSupply = 100000000 * 100000000;
146         balances[msg.sender] = totalSupply;
147         name = 'Farmercoin';
148         decimals = 8;
149         symbol = 'FC';
150         price = 142857142857143;
151         limit = 9950000000000000;
152     }
153 
154     /* Добавляет на счет владельца контракта токенов */
155     function add(uint256 _value) onlyOwner returns (bool success)
156     {
157         if (balances[msg.sender] + _value <= balances[msg.sender]) {
158             return false;
159         }
160         totalSupply += _value;
161         balances[msg.sender] += _value;
162 
163         return true;
164     }
165 
166     /* Уничтожает токены на счете владельца контракта */
167     function burn(uint256 _value) onlyOwner  returns (bool success)
168     {
169         if (balances[msg.sender] < _value) {
170             return false;
171         }
172         totalSupply -= _value;
173         balances[msg.sender] -= _value;
174         return true;
175     }
176 }