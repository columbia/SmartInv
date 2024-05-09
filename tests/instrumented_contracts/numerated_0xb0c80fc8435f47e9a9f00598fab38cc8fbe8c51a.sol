1 pragma solidity ^0.4.8;
2 
3   // ----------------------------------------------------------------------------------------------
4   //  制作代币请加微信：FAC2323 ,高级代币可增发，冻结，销毁，锁仓生息，空投，转投，直投，兑换
5   // Sample fixed supply token contract
6   // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
7   // ----------------------------------------------------------------------------------------------
8 
9    // ERC Token Standard #20 Interface
10   // https://github.com/ethereum/EIPs/issues/20
11   contract ERC20Interface {
12 
13       function totalSupply() constant returns (uint256 totalSupply);
14 
15 
16       function balanceOf(address _owner) constant returns (uint256 balance);
17 
18       function transfer(address _to, uint256 _value) returns (bool success);
19 
20       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
21 
22 
23       function approve(address _spender, uint256 _value) returns (bool success);
24 
25 
26       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
27 
28 
29       event Transfer(address indexed _from, address indexed _to, uint256 _value);
30 
31      
32       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33   }
34 
35 
36    contract FixedSupplyToken is ERC20Interface {
37       string public constant symbol = "EHD";
38       string public constant name = "以太钻石"; 
39       uint8 public constant decimals = 18; 
40       uint256 _totalSupply = 55000000000000000000000000; 
41 
42 
43       address public owner;
44 
45 
46       mapping(address => uint256) balances;
47 
48 
49       mapping(address => mapping (address => uint256)) allowed;
50 
51 
52       modifier onlyOwner() {
53           if (msg.sender != owner) {
54               throw;
55           }
56           _;
57       }
58 
59 
60       function FixedSupplyToken() {
61           owner = msg.sender;
62           balances[owner] = _totalSupply;
63       }
64 
65       function totalSupply() constant returns (uint256 totalSupply) {
66           totalSupply = _totalSupply;
67       }
68 
69 
70       function balanceOf(address _owner) constant returns (uint256 balance) {
71           return balances[_owner];
72       }
73 
74 
75       function transfer(address _to, uint256 _amount) returns (bool success) {
76           if (balances[msg.sender] >= _amount 
77               && _amount > 0
78               && balances[_to] + _amount > balances[_to]) {
79               balances[msg.sender] -= _amount;
80               balances[_to] += _amount;
81               Transfer(msg.sender, _to, _amount);
82               return true;
83           } else {
84               return false;
85           }
86       }
87 
88 
89       function transferFrom(
90           address _from,
91           address _to,
92           uint256 _amount
93       ) returns (bool success) {
94           if (balances[_from] >= _amount
95               && allowed[_from][msg.sender] >= _amount
96               && _amount > 0
97               && balances[_to] + _amount > balances[_to]) {
98               balances[_from] -= _amount;
99               allowed[_from][msg.sender] -= _amount;
100               balances[_to] += _amount;
101               Transfer(_from, _to, _amount);
102               return true;
103           } else {
104               return false;
105           }
106       }
107 
108 
109       function approve(address _spender, uint256 _amount) returns (bool success) {
110           allowed[msg.sender][_spender] = _amount;
111           Approval(msg.sender, _spender, _amount);
112           return true;
113       }
114 
115       //返回被允许转移的余额数量
116       function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
117           return allowed[_owner][_spender];
118       }
119   }