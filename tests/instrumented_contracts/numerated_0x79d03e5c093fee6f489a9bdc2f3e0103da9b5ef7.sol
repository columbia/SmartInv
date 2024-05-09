1 pragma solidity ^0.4.18;
2 
3 
4 contract Token {
5 
6     uint256 constant private MAX_UINT256 = 2**256 - 1;
7     mapping(address => uint) public balances;
8     mapping(address => mapping(address => uint)) public allowed;
9 
10     string public description;
11     uint8 public decimals;
12     string public logoURL;
13     string public name;
14     string public symbol;
15     uint public totalSupply;
16 
17     address public creator;
18 
19     event Transfer(address indexed _from, address indexed _to, uint256 _value);
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21     
22     event Created(address creator, uint supply);
23 
24     function Token(
25         string _description,
26         string _logoURL,
27         string _name,
28         string _symbol,
29         uint256 _totalSupply
30     ) public
31     {
32         description = _description;
33         logoURL = _logoURL;
34         name = _name;
35         symbol = _symbol;
36         decimals = 18;
37         totalSupply = _totalSupply;
38 
39         creator = tx.origin;
40         Created(creator, _totalSupply);
41         balances[creator] = _totalSupply;
42     }
43 
44     // Don't let people randomly send ETH to contract
45     function() public payable {
46         revert();
47     }
48 
49     function transfer(address _to, uint256 _value) public returns (bool success) {
50         require(balances[msg.sender] >= _value);
51         balances[msg.sender] -= _value;
52         balances[_to] += _value;
53         Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         uint256 allowance = allowed[_from][msg.sender];
59         require(balances[_from] >= _value && allowance >= _value);
60         balances[_to] += _value;
61         balances[_from] -= _value;
62         if (allowance < MAX_UINT256) {
63             allowed[_from][msg.sender] -= _value;
64         }
65         Transfer(_from, _to, _value);
66         return true;
67     }
68 
69     function balanceOf(address _owner) public view returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) public returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
80         return allowed[_owner][_spender];
81     }
82     
83     function setLogoURL(string url) public {
84         require(msg.sender == creator);
85         logoURL = url;
86     }
87 }
88 
89 // Sample constructor args
90 // "0x54686520746f6b656e20666f7220617765736f6d652070656f706c652e", "0x68747470733a2f2f692e696d6775722e636f6d2f5a336871756c492e6a7067", "0x417765736f6d6520546f6b656e", "0x415745", "0x52b7d2dcc80cd2e4000000"
91 
92 contract Coinsling {
93 
94     address public owner;
95 
96     function Coinsling() public {
97         owner = msg.sender;
98     }
99 
100     event TokenCreated(address token);
101     function sling(
102         string _description,
103         string _logoURL,
104         string _name,
105         string _symbol,
106         uint   _totalSupply
107     ) public payable returns (Token token)
108     {
109         token = new Token(
110             _description,
111             _logoURL,
112             _name,
113             _symbol,
114             _totalSupply
115         );
116 
117         TokenCreated(token);
118         return token;
119     }
120 
121     // This allows me to collect the revenue paid into the contract
122     function transfer(uint amount, address to) public {
123         require(msg.sender == owner);
124         to.transfer(amount);
125     }
126 }