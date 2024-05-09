1 pragma solidity ^0.4.15;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address _from, address _to, uint256 _value);
11     event Approval(address _owner, address _spender, uint256 _value);
12 }
13 
14 
15 /*  ERC 20 token */
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {
19       if (balances[msg.sender] >= _value && _value > 0) {
20         balances[msg.sender] -= _value;
21         balances[_to] += _value;
22         Transfer(msg.sender, _to, _value);
23         return true;
24       } else {
25         return false;
26       }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31         balances[_to] += _value;
32         balances[_from] -= _value;
33         allowed[_from][msg.sender] -= _value;
34         Transfer(_from, _to, _value);
35         return true;
36       } else {
37         return false;
38       }
39     }
40 
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 }
58 
59 contract TestToken is StandardToken {
60     uint256 public constant PRICE = 4000;
61 
62     // metadata
63     string public constant name = "Infinite Test Token";
64     string public constant symbol = "TEST";
65     uint256 public constant decimals = 18;
66     string public version = "1.0";
67 
68     event CreatedToken();
69 
70     function TestToken() {
71         CreatedToken();
72     }
73 
74     function () payable {
75         buyTokens(msg.sender);
76     }
77 
78     function buyTokens(address beneficiary) payable {
79         uint256 tokens = msg.value * PRICE;
80         balances[beneficiary] += tokens;
81         Transfer(0x0, beneficiary, tokens);
82         totalSupply += tokens;
83         msg.sender.transfer(msg.value);
84     }
85 }