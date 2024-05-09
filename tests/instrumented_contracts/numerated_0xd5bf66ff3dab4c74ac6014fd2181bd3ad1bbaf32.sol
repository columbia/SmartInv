1 pragma solidity ^0.4.11;
2  
3 contract ERC20Interface {
4 
5     function totalSupply() constant returns (uint256 totalSupply);
6  
7     function balanceOf(address _owner) constant returns (uint256 balance);
8  
9     function transfer(address _to, uint256 _value) returns (bool success);
10  
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12  
13     function approve(address _spender, uint256 _value) returns (bool success);
14  
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
16  
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18  
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21  
22 contract ECCToken is ERC20Interface {
23     string public constant symbol = "ECC";
24     string public constant name = "ECC Token";
25     uint8 public constant decimals = 8;
26     uint256 _totalSupply = 300000000000000000;
27     
28     address public tokenKeeper;
29     
30     address public owner;
31  
32     mapping(address => uint256) balances;
33  
34     mapping(address => mapping (address => uint256)) allowed;
35  
36     modifier onlyOwner() {
37         if (msg.sender != owner) {
38             throw;
39         }
40         _;
41     }
42  
43     function ECCToken() {
44         owner = msg.sender;
45         tokenKeeper = msg.sender;
46         balances[owner] = _totalSupply;
47     }
48     
49     function tokenKeeperBalance() constant returns (uint256 balance) {
50         return balances[tokenKeeper];
51     }
52  
53     function totalSupply() constant returns (uint256 totalSupply) {
54         totalSupply = _totalSupply;
55     }
56  
57     function balanceOf(address _owner) constant returns (uint256 balance) {
58         return balances[_owner];
59     }
60  
61     function transfer(address _to, uint256 _amount) returns (bool success) {
62         if (balances[msg.sender] >= _amount 
63             && _amount > 0
64             && balances[_to] + _amount > balances[_to]) {
65             balances[msg.sender] -= _amount;
66             balances[_to] += _amount;
67             Transfer(msg.sender, _to, _amount);
68             return true;
69         } else {
70             return false;
71         }
72     }
73 
74     function transferFrom(
75         address _from,
76         address _to,
77         uint256 _amount
78     ) returns (bool success) {
79         if (balances[_from] >= _amount
80             && allowed[_from][msg.sender] >= _amount
81             && _amount > 0
82             && balances[_to] + _amount > balances[_to]) {
83             balances[_from] -= _amount;
84             allowed[_from][msg.sender] -= _amount;
85             balances[_to] += _amount;
86             Transfer(_from, _to, _amount);
87             return true;
88         } else {
89             return false;
90         }
91     }
92  
93     function approve(address _spender, uint256 _amount) returns (bool success) {
94         allowed[msg.sender][_spender] = _amount;
95         Approval(msg.sender, _spender, _amount);
96         return true;
97     }
98  
99     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
100         return allowed[_owner][_spender];
101     }
102     
103     function changeTokenKeeper(address _tokenKeeper) public onlyOwner returns (bool success) {
104         tokenKeeper = _tokenKeeper;
105         return true;
106     }
107 }