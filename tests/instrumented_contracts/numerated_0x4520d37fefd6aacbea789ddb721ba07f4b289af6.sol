1 pragma solidity ^0.4.16;
2 contract SafeMath {
3     function safeMul(uint a, uint b) internal returns (uint) {
4         uint c = a * b;
5         safeassert(a == 0 || c / a == b);
6         return c;
7     }
8     
9     function safeSub(uint a, uint b) internal returns (uint) {
10         safeassert(b <= a);
11         return a - b;
12     }
13     
14     function safeAdd(uint a, uint b) internal returns (uint) {
15         uint c = a + b;
16         safeassert(c>=a && c>=b);
17         return c;
18     }
19     
20     function safeassert(bool assertion) internal {
21         require(assertion);
22     }
23 }
24 contract COIN is SafeMath {
25     string public symbol;
26     string public name;
27     uint256 public decimals;
28     uint preicoEnd = 1517356799; // Pre ICO Expiry 30 Jan 2018 23:59:59
29     
30     uint256 rate;
31     uint256 public tokenSold;
32     uint256 _totalSupply;
33     address public owner;
34     
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37     
38     mapping(address => uint256) balances;
39     mapping(address => mapping (address => uint256)) allowed;
40     
41     /**
42     * @dev Fix for the ERC20 short address attack.
43     */
44     modifier onlyPayloadSize(uint size) {
45         require(msg.data.length >= size + 4) ;
46         _;
47     }
48     
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53       
54     function transferOwnership(address __newOwner) public onlyOwner {
55         require(__newOwner != 0x0);
56         owner = __newOwner;
57     }
58     
59     function totalSupply() constant returns (uint256) {
60         return _totalSupply;
61     }
62  
63     function balanceOf(address _owner) constant returns (uint256 balance) {
64         return balances[_owner];
65     }
66     
67     function COIN(
68         string _name,
69         uint256 _supply,
70         uint256 _rate,
71         string _symbol,
72         uint256 _decimals
73     ) {
74         tokenSold = safeMul(2000000, (10 ** _decimals));
75         _totalSupply = safeMul(_supply, safeMul(1000000, (10 ** _decimals)));
76         name = _name;
77         symbol = _symbol;
78         rate = _rate;
79         decimals = _decimals;
80         owner = msg.sender;
81         balances[msg.sender] = tokenSold;
82         Transfer(address(this), msg.sender, tokenSold);
83     }
84     
85     function () payable {
86         require(preicoEnd > now);
87         uint256 token_amount = safeMul(msg.value, rate);
88         require(safeAdd(tokenSold, token_amount) <= _totalSupply);
89         
90         tokenSold = safeAdd(tokenSold, token_amount);
91         balances[msg.sender] = safeAdd(balances[msg.sender], token_amount);
92         owner.transfer(msg.value);
93         Transfer(address(this), msg.sender, token_amount);
94     }
95  
96     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
97         if (balances[msg.sender] >= _amount
98             && _amount > 0
99             && safeAdd(balances[_to], _amount) > balances[_to]) {
100             balances[msg.sender] = safeSub(balances[msg.sender], _amount);
101             balances[_to] = safeAdd(balances[_to], _amount);
102             Transfer(msg.sender, _to, _amount);
103             return true;
104         } else {
105             return false;
106         }
107     }
108     
109     function transferFrom(
110         address _from,
111         address _to,
112         uint256 _amount
113     ) onlyPayloadSize(2 * 32) public returns (bool success) {
114         if (balances[_from] >= _amount
115         && allowed[_from][msg.sender] >= _amount
116         && _amount > 0
117         && safeAdd(balances[_to], _amount) > balances[_to]) {
118             balances[_from] = safeSub(balances[_from], _amount);
119             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _amount);
120             balances[_to] = safeAdd(balances[_to], _amount);
121             Transfer(_from, _to, _amount);
122             return true;
123         } else {
124             return false;
125         }
126     }
127  
128     function approve(address _spender, uint256 _amount) public returns (bool success) {
129         allowed[msg.sender][_spender] = _amount;
130         Approval(msg.sender, _spender, _amount);
131         return true;
132     }
133  
134     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
135         return allowed[_owner][_spender];
136     }
137 }