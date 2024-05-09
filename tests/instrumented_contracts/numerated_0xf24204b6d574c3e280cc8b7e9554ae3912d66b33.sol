1 pragma solidity 0.4.18;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint supply) {}
6     function balanceOf(address _owner) constant returns (uint balance) {}
7     function transfer(address _to, uint _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
9     function approve(address _spender, uint _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
11 
12     event Transfer(address indexed _from, address indexed _to, uint _value);
13     event Approval(address indexed _owner, address indexed _spender, uint _value);
14 }
15 
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint _value) public returns (bool) {
19         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
20             balances[msg.sender] -= _value;
21             balances[_to] += _value;
22             Transfer(msg.sender, _to, _value);
23             return true;
24         } else { return false; }
25     }
26 
27     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
28         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
29             balances[_to] += _value;
30             balances[_from] -= _value;
31             allowed[_from][msg.sender] -= _value;
32             Transfer(_from, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function balanceOf(address _owner) constant public returns (uint) {
38         return balances[_owner];
39     }
40 
41     function approve(address _spender, uint _value) public returns (bool) {
42         allowed[msg.sender][_spender] = _value;
43         Approval(msg.sender, _spender, _value);
44         return true;
45     }
46 
47     function allowance(address _owner, address _spender) constant public returns (uint) {
48         return allowed[_owner][_spender];
49     }
50 
51     mapping (address => uint) balances;
52     mapping (address => mapping (address => uint)) allowed;
53     uint public totalSupply;
54 }
55 
56 contract PGToken is StandardToken {
57 
58     uint8 constant public decimals = 0;
59     uint public totalSupply = 0;
60     string constant public name = "P&G Token 20171231";
61     string constant public symbol = "PGT20171231";
62     StandardToken public usdt = StandardToken(0x3aeAe69C196D8db9A35B39C51d7cac00643eC7f1);
63     address public owner;// = msg.sender;
64     address[] internal members;
65     mapping (address => bool) isMember;
66 
67     function PGToken() public {
68         owner = msg.sender;
69     }
70 
71     function issue(address _to, uint64 _amount) public {
72         require (owner == msg.sender);
73         if (!isMember[_to]) {
74             members.push(_to);
75             isMember[_to] = true;
76         }
77         balances[_to] += _amount;
78         totalSupply += _amount;
79     }
80 
81     function pay() public {
82         require (owner == msg.sender);
83         require (usdt.balanceOf(this) >= totalSupply);
84         for (uint i = 0; i < members.length; i++) {
85             address addr = members[i];
86             if (addr != owner) {
87                 uint256 balance = balances[addr];
88                 if (balance > 0) {
89                     usdt.transfer(addr, balance);
90                     balances[addr] = 0;
91                 }
92             }
93         }
94         usdt.transfer(owner, usdt.balanceOf(this));
95         selfdestruct(owner);
96     }
97 }