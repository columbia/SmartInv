1 pragma solidity ^0.4.21;
2 
3 
4 /*
5 
6 BASIC ERC20 Crowdsale ICO ERC20 Token
7 
8 Create this Token contract AFTER you already have the Sale contract created.
9 
10    Token(address sale_address)   // creates token and links the Sale contract
11 
12 @author Hunter Long, Jun Kawasaki
13 @repo https://github.com/hunterlong/ethereum-ico-contract
14 
15 Thank you.
16 
17 */
18 
19 
20 contract TelomereCoin {
21     uint256 public totalSupply;
22     bool public allowTransfer;
23 
24     function balanceOf(address _owner) constant returns (uint256 balance);
25     function transfer(address _to, uint256 _value) returns (bool success);
26     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
27     function approve(address _spender, uint256 _value) returns (bool success);
28     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
29 
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 }
33 
34 contract StandardToken is TelomereCoin {
35 
36     function transfer(address _to, uint256 _value) returns (bool success) {
37         require(allowTransfer);
38         require(balances[msg.sender] >= _value);
39         balances[msg.sender] -= _value;
40         balances[_to] += _value;
41         Transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
46         require(allowTransfer);
47         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
48         balances[_to] += _value;
49         balances[_from] -= _value;
50         allowed[_from][msg.sender] -= _value;
51         Transfer(_from, _to, _value);
52         return true;
53     }
54 
55     function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59     function approve(address _spender, uint256 _value) returns (bool success) {
60         require(allowTransfer);
61         allowed[msg.sender][_spender] = _value;
62         Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
67       return allowed[_owner][_spender];
68     }
69 
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 }
73 
74 
75 contract Token is StandardToken {
76 
77     string public name = "Telomere Coin";
78     uint8 public decimals = 0;
79     string public symbol = "TXY";
80     string public version = 'TXY 1.0';
81     address public mintableAddress;
82 
83     function Token(address sale_address) {
84         balances[msg.sender] = 0;
85         totalSupply = 0;
86         name = name;
87         decimals = decimals;
88         symbol = symbol;
89         mintableAddress = sale_address;
90         allowTransfer = true;
91         createTokens();
92     }
93 
94     // creates all tokens 5 million
95     // this address will hold all tokens
96     // all community contrubutions coins will be taken from this address
97     function createTokens() internal {
98         uint256 total = 116000000;
99         balances[this] = total;
100         totalSupply = total;
101     }
102 
103     function changeTransfer(bool allowed) external {
104         require(msg.sender == mintableAddress);
105         allowTransfer = allowed;
106     }
107 
108     function mintToken(address to, uint256 amount) external returns (bool success) {
109         require(msg.sender == mintableAddress);
110         require(balances[this] >= amount);
111         balances[this] -= amount;
112         balances[to] += amount;
113         Transfer(this, to, amount);
114         return true;
115     }
116 
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
118         allowed[msg.sender][_spender] = _value;
119         Approval(msg.sender, _spender, _value);
120 
121         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
122         return true;
123     }
124 }