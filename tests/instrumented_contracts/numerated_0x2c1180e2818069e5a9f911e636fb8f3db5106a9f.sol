1 pragma solidity ^0.4.18;
2 
3 ////////////////////
4 // STANDARD TOKEN //
5 ////////////////////
6 
7 contract Token {
8 
9     uint256 public totalSupply;
10     function balanceOf(address _owner) public constant returns (uint256 balance);
11     function transfer(address _to, uint256 _value) public returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18 }
19 
20 contract StandardToken is Token {
21 
22      function balanceOf(address _owner) public constant returns (uint256 balance) {
23         return balances[_owner];
24     }
25 
26     function transfer(address _to, uint256 _value) public returns (bool success) {
27       if (balances[msg.sender] >= _value && _value > 0) {
28         balances[msg.sender] -= _value;
29         balances[_to] += _value;
30         Transfer(msg.sender, _to, _value);
31         return true;
32       } else {
33         return false;
34       }
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
38       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
39         balances[_to] += _value;
40         balances[_from] -= _value;
41         allowed[_from][msg.sender] -= _value;
42         Transfer(_from, _to, _value);
43         return true;
44       } else {
45         return false;
46       }
47     }
48 
49     function approve(address _spender, uint256 _value) public returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
56       return allowed[_owner][_spender];
57     }
58 
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61 
62 }
63 
64 ////////////////////////////////////////////
65 //   Emergency Response Ethereum-Based   //
66 ///////////////////////////////////////////
67 
68 
69 contract ERH is StandardToken {
70 
71 
72     string public constant name = "Emergency Response Ethereum-Based";
73     string public constant symbol = "ERH";
74     uint256 public constant decimals = 18;
75     uint256 public totalSupply = 10000000000 * 10**decimals;
76 
77 
78     function ERH (address _addressFounder)  {
79 
80       balances[_addressFounder] = totalSupply;
81       Transfer(0x0, _addressFounder, totalSupply);
82 
83     }
84 
85     function () payable public {
86       require(msg.value == 0);
87     }
88 
89 }