1 pragma solidity ^0.4.11;
2 
3 interface IERC20 {
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract SupremeToken is IERC20 {
15     
16     uint public constant _totalSupply = 5000000;
17     
18     string public constant symbol = "SUPREME";
19     string public constant name = "SUPREME";
20     uint8 public constant decimals = 2;
21     
22     mapping(address => uint256) balances;
23     mapping(address => mapping(address => uint256)) allowed;
24     
25     function SupremeToken() {
26         balances[msg.sender] = _totalSupply;
27     }
28     
29     function totalSupply() constant returns (uint256 totalSupply) {
30         return _totalSupply;
31     }
32     
33     function balanceOf(address _owner) constant returns (uint256 balance) {
34         return balances[_owner];
35     }
36     
37     function transfer(address _to, uint256 _value) returns (bool success) {
38         require(
39             balances[msg.sender] >= _value
40             && _value > 0
41         );
42         balances[msg.sender] -= _value;
43         balances[_to] += _value;
44         Transfer(msg.sender, _to, _value);
45         return true;
46     }
47     
48     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
49         require(
50             allowed[_from][msg.sender] >= _value
51             && balances[_from] >= _value
52             && _value > 0
53         );
54         balances[_from] -= _value;
55         balances[_to] += _value;
56         allowed[_from][msg.sender] -= _value;
57         Transfer(_from, _to, _value);
58         return true;
59     }
60     
61     function approve(address _spender, uint256 _value) returns (bool success) {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66     
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
68         return allowed[_owner][_spender];
69     }
70     
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 }