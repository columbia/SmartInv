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
27     uint256 public totalSupply;
28     function balanceOf(address _owner) constant returns (uint256 balance);
29     function transfer(address _to, uint256 _value) returns (bool success);
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31     function approve(address _spender, uint256 _value) returns (bool success);
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35     event Err(uint256 _value);
36 }
37 
38 contract ERC20Token is Token {
39 
40     function transfer(address _to, uint256 _value) returns (bool success) {
41 
42         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             Transfer(msg.sender, _to, _value);
46             return true;
47         } else { return false; }
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
51 
52         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53             balances[_to] += _value;
54             balances[_from] -= _value;
55             allowed[_from][msg.sender] -= _value;
56             Transfer(_from, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function balanceOf(address _owner) constant returns (uint256 balance) {
62         return balances[_owner];
63     }
64 
65     function approve(address _spender, uint256 _value) returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
72         return allowed[_owner][_spender];
73     }
74 
75     mapping (address => uint256) balances;
76     mapping (address => mapping (address => uint256)) allowed;
77 }
78 
79 contract AvatarCoin is ERC20Token {
80 
81     bool public isTokenSale = true;
82     uint256 public price;
83     uint256 public limit;
84 
85     address walletOut = 0xde51a2071599a7c84a4b33d7d5fef644e0169513;
86 
87     function getWalletOut() constant returns (address _to) {
88         return walletOut;
89     }
90 
91     function () external payable  {
92         if (isTokenSale == false) {
93             throw;
94         }
95 
96         uint256 tokenAmount = (msg.value  * 100000000) / price;
97 
98         if (balances[owner] >= tokenAmount && balances[msg.sender] + tokenAmount > balances[msg.sender]) {
99             if (balances[owner] - tokenAmount < limit) {
100                 throw;
101             }
102             balances[owner] -= tokenAmount;
103             balances[msg.sender] += tokenAmount;
104             Transfer(owner, msg.sender, tokenAmount);
105         } else {
106             throw;
107         }
108     }
109 
110     function stopSale() onlyOwner {
111         isTokenSale = false;
112     }
113 
114     function startSale() onlyOwner {
115         isTokenSale = true;
116     }
117 
118     function setPrice(uint256 newPrice) onlyOwner {
119         price = newPrice;
120     }
121 
122     function setLimit(uint256 newLimit) onlyOwner {
123         limit = newLimit;
124     }
125 
126     function setWallet(address _to) onlyOwner {
127         walletOut = _to;
128     }
129 
130     function sendFund() onlyOwner {
131         walletOut.send(this.balance);
132     }
133 
134     string public name;
135     uint8 public decimals;
136     string public symbol;
137     string public version = '1.0';
138 
139     function AvatarCoin() {
140         totalSupply = 100000000 * 100000000;
141         balances[msg.sender] = totalSupply;
142         name = 'AvatarCoin';
143         decimals = 8;
144         symbol = 'AVR';
145         price = 250000000000000;
146         limit = 9925000000000000;
147     }
148 }