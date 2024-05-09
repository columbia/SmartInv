1 pragma solidity ^0.4.16;
2 
3 contract ERC20Interface {
4      function totalSupply() constant returns (uint256 supply);
5      function balanceOf(address _owner) constant returns (uint256 balance);
6      function transfer(address _to, uint256 _value) returns(bool);
7      function transferFrom(address _from, address _to, uint256 _value) returns(bool);
8      function approve(address _spender, uint256 _value) returns (bool success);
9      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10      event Transfer(address indexed _from, address indexed _to, uint256 _value);
11      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StdToken is ERC20Interface {
15      mapping(address => uint256) balances;
16      mapping (address => mapping (address => uint256)) allowed;
17      uint public supply = 0;
18 
19      function transfer(address _to, uint256 _value) returns(bool) {
20           require(balances[msg.sender] >= _value);
21           require(balances[_to] + _value > balances[_to]);
22 
23           balances[msg.sender] -= _value;
24           balances[_to] += _value;
25 
26           Transfer(msg.sender, _to, _value);
27           return true;
28      }
29 
30      function transferFrom(address _from, address _to, uint256 _value) returns(bool){
31           require(balances[_from] >= _value);
32           require(allowed[_from][msg.sender] >= _value);
33           require(balances[_to] + _value > balances[_to]);
34 
35           balances[_to] += _value;
36           balances[_from] -= _value;
37           allowed[_from][msg.sender] -= _value;
38 
39           Transfer(_from, _to, _value);
40           return true;
41      }
42 
43      function totalSupply() constant returns (uint256) {
44           return supply;
45      }
46 
47      function balanceOf(address _owner) constant returns (uint256) {
48           return balances[_owner];
49      }
50 
51      function approve(address _spender, uint256 _value) returns (bool) {
52           require((_value == 0) || (allowed[msg.sender][_spender] == 0));
53 
54           allowed[msg.sender][_spender] = _value;
55           Approval(msg.sender, _spender, _value);
56 
57           return true;
58      }
59 
60      function allowance(address _owner, address _spender) constant returns (uint256) {
61           return allowed[_owner][_spender];
62      }
63 }
64 
65 contract myToken is StdToken
66 {
67     string public constant name = "168 Token";
68     string public constant symbol = "168";
69     uint public constant decimals = 18;
70     uint public constant TOKEN_SUPPLY_LIMIT = 1000000 * (1 ether / 1 wei);
71     uint public constant MANAGER_SUPPLY = 650000 * (1 ether / 1 wei);
72     uint public constant ICO_PRICE = 1000;     // per 1 Ether
73     address public tokenManager = 0;
74 
75     modifier onlyTokenManager()
76     {
77         require(msg.sender==tokenManager);
78         _;
79     }
80 
81     function myToken()
82     {
83         tokenManager = msg.sender;
84         balances[tokenManager] += MANAGER_SUPPLY;
85         supply += MANAGER_SUPPLY;
86     }
87 
88     function buyTokens() public payable
89     {
90         require(msg.value >= ((1 ether / 1 wei) / 100));
91 
92         uint newTokens = msg.value * ICO_PRICE;
93 
94         require(supply + newTokens <= TOKEN_SUPPLY_LIMIT);
95 
96         tokenManager.transfer(msg.value);
97 
98         balances[msg.sender] += newTokens;
99         supply += newTokens;
100     }
101 
102     function setTokenManager(address _mgr) public onlyTokenManager
103     {
104         tokenManager = _mgr;
105     }
106 
107     function() payable
108     {
109         buyTokens();
110     }
111 }