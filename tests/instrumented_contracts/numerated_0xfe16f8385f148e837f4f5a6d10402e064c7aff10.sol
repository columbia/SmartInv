1 pragma solidity ^0.4.21;
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
14 contract FXNOW is IERC20{
15     
16     uint256 public constant _totalSupply = 830000000000000000;
17     string public constant symbol = "FNCT";
18     string public constant name = "FXNOW";
19     uint8 public constant decimals = 8;
20     
21     mapping(address => uint256) balances;
22     mapping(address => mapping(address => uint256)) allowed;
23     
24     function FXNOW(){
25         balances[msg.sender] = _totalSupply;
26     }
27     
28     function totalSupply() constant returns (uint256 totalSupply){
29         return _totalSupply;
30     }
31     
32     function balanceOf(address _owner) constant returns (uint256 balance){
33         return balances[_owner];
34     }
35     
36     function transfer(address _to, uint256 _value) returns (bool success){
37         require(
38                 balances[msg.sender] >= _value
39                 && _value > 0 
40             );
41             balances[msg.sender] -= _value;
42             balances[_to] += _value;
43             Transfer(msg.sender, _to, _value);
44             return true;
45     }
46     
47     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
48         require(
49                 allowed[_from][msg.sender] >= _value
50                 && balances[_from] >= _value
51                 && _value > 0 
52             );
53             balances[_from] -= _value;
54             balances[_to] += _value;
55             allowed[_from][msg.sender] -= _value;
56             Transfer(_from, _to, _value);
57             return true;
58     }
59     
60     function approve(address _spender, uint256 _value) returns (bool success){
61         allowed[msg.sender][_spender] = _value;
62         Approval(msg.sender, _spender, _value);
63         return true;
64     }
65     
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
67         return allowed[_owner][_spender];
68     }
69     
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 }