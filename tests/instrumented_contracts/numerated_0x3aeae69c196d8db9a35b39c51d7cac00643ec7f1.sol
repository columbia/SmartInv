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
56 contract USDT is StandardToken {
57 
58     uint8 constant public decimals = 0;
59     uint public totalSupply = 0;
60     string constant public name = "USD Token";
61     string constant public symbol = "USDT";
62 
63     function USDT() public {
64         totalSupply = 1e6;
65         balances[msg.sender] = totalSupply;
66     }
67 }