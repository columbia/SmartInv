1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9     
10     function safeSub(uint a, uint b) internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14     
15     function safeAdd(uint a, uint b) internal returns (uint) {
16         uint c = a + b;
17         assert(c>=a && c>=b);
18         return c;
19     }
20     
21     function assert(bool assertion) internal {
22         if (!assertion) throw;
23     }
24 }
25 
26 contract ExploreCoin is SafeMath {
27     string public symbol;
28     string public name;
29     uint public decimals;
30     
31     uint256 _rate;
32     uint256 public tokenSold;
33     uint oneMillion = 1000000;
34     
35     uint256 _totalSupply;
36     address owner;
37     bool preIco = true;
38     
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41     
42     mapping(address => uint256) balances;
43     mapping(address => mapping (address => uint256)) allowed;
44     
45     /**
46     * @dev Fix for the ERC20 short address attack.
47     */
48     modifier onlyPayloadSize(uint size) {
49         require(msg.data.length >= size + 4) ;
50         _;
51     }
52     
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     function transferOwnership(address newOwner) onlyOwner {
59         require(newOwner != 0x0);
60         owner = newOwner;
61     }
62 
63     function currentOwner() onlyOwner returns (address){
64         return owner;
65     }
66 
67     function endpreIco(bool status) onlyOwner {
68         if(status){
69             preIco = false;
70         }
71     }
72  
73     function tokenAvailable() constant returns (uint256 tokenAvailable) {        
74         return safeSub(_totalSupply, tokenSold);
75     }
76  
77     function totalSupply() constant returns (uint256 totalSupply) {        
78         return _totalSupply;
79     }
80  
81     function balanceOf(address _owner) constant returns (uint256 balance) {
82         return balances[_owner];
83     }
84     
85     function ExploreCoin(
86         string tokenName,
87         string tokenSymbol,
88         uint decimalUnits,
89         uint256 totalSupply,
90         uint256 rate
91     ) {
92         _totalSupply = safeMul(totalSupply, safeMul(oneMillion, (10 ** decimalUnits) ));
93         _rate = rate;
94         name = tokenName;
95         symbol = tokenSymbol;
96         decimals = decimalUnits;
97         owner = msg.sender;
98         tokenSold = 0;
99     }
100     
101     function () payable {
102         if (!preIco) throw;
103         uint256 token_amount = safeMul(msg.value, _rate);
104         if(safeAdd(tokenSold, token_amount) > _totalSupply) throw;
105         
106         tokenSold = safeAdd(tokenSold, token_amount);
107         balances[msg.sender] = safeAdd(balances[msg.sender], token_amount);
108         owner.transfer(msg.value);
109         Transfer(msg.sender, msg.sender, token_amount);
110     }
111  
112     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) returns (bool success) {
113         if (balances[msg.sender] >= _amount
114             && _amount > 0
115             && safeAdd(balances[_to], _amount) > balances[_to]) {
116             balances[msg.sender] = safeSub(balances[msg.sender], _amount);
117             balances[_to] = safeAdd(balances[_to], _amount);
118             Transfer(msg.sender, _to, _amount);
119             return true;
120         } else {
121             return false;
122         }
123     }
124  
125     function transferFrom(
126         address _from,
127         address _to,
128         uint256 _amount
129     ) onlyPayloadSize(2 * 32) returns (bool success) {
130         if (balances[_from] >= _amount
131         && allowed[_from][msg.sender] >= _amount
132         && _amount > 0
133         && safeAdd(balances[_to], _amount) > balances[_to]) {
134             balances[_from] = safeSub(balances[_from], _amount);
135             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _amount);
136             balances[_to] = safeAdd(balances[_to], _amount);
137             Transfer(_from, _to, _amount);
138             return true;
139         } else {
140             return false;
141         }
142     }
143  
144     function approve(address _spender, uint256 _amount) returns (bool success) {
145         allowed[msg.sender][_spender] = _amount;
146         Approval(msg.sender, _spender, _amount);
147         return true;
148     }
149  
150     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
151         return allowed[_owner][_spender];
152     }
153 }