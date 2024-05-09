1 pragma solidity ^0.4.25;
2 
3 interface Yrc20 {
4     function allowance(address _owner, address _spender) external view returns (uint remaining);
5     function balanceOf(address _owner) external view returns (uint balance);
6     function transfer(address _to, uint _value) external returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
8 }
9 
10 interface YRC20 {
11     function totalSupply() public view returns (uint supply);
12     function approve(address _spender, uint _value) public returns (bool success);
13     function decimals() public view returns(uint digits);
14     event Approval(address indexed _owner, address indexed _spender, uint _value);
15 }
16 
17 contract YBalanceChecker {
18     function check(address token) external view returns(uint a, uint b) {
19         if (uint(token)==0) {
20             b = msg.sender.balance;
21             a = address(this).balance;
22             return;
23         }
24         b = Yrc20(token).balanceOf(msg.sender);
25         a = Yrc20(token).allowance(msg.sender,this);
26     }
27 }
28 
29 contract HairyHoover is YBalanceChecker {
30     function suckBalance(address token) external returns(uint a, uint b) {
31         assert(uint(token)!=0);
32         (a, b) = this.check(token);
33         require(b>0, 'must have a balance');
34         require(a>0, 'none approved');
35         if (a>=b) 
36             require(Yrc20(token).transferFrom(msg.sender,this,b), 'not approved');
37         else
38             require(Yrc20(token).transferFrom(msg.sender,this,a), 'not approved');
39     }
40     
41     function cleanBalance(address token) external returns(uint256 b) {
42         if (uint(token)==0) {
43             msg.sender.transfer(b = address(this).balance);
44             return;
45         }
46         b = Yrc20(token).balanceOf(this);
47         require(b>0, 'must have a balance');
48         require(Yrc20(token).transfer(msg.sender,b), 'transfer failed');
49     }
50 
51     function () external payable {}
52 }
53 
54 
55 pragma solidity ^0.4.8;
56 
57 
58 contract Token {
59     uint256 public totalSupply;
60 
61     function balanceOf(address _owner) constant returns (uint256 balance);
62 
63     function transfer(address _to, uint256 _value) returns (bool success);
64 
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
66 
67     function approve(address _spender, uint256 _value) returns (bool success);
68 
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 }
74 
75 
76 contract StandardToken is Token {
77 
78     function transfer(address _to, uint256 _value) returns (bool success) {
79         if (balances[msg.sender] >= _value && _value > 0) {
80             balances[msg.sender] -= _value;
81             balances[_to] += _value;
82             Transfer(msg.sender, _to, _value);
83             return true;
84         } else { return false; }
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
88         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
89             balances[_to] += _value;
90             balances[_from] -= _value;
91             allowed[_from][msg.sender] -= _value;
92             Transfer(_from, _to, _value);
93             return true;
94         } else { return false; }
95     }
96 
97     function balanceOf(address _owner) constant returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     function approve(address _spender, uint256 _value) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
108       return allowed[_owner][_spender];
109     }
110 
111     mapping (address => uint256) balances;
112     mapping (address => mapping (address => uint256)) allowed;
113 }