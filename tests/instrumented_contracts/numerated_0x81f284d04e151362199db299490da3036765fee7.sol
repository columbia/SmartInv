1 pragma solidity ^0.4.11;
2 
3 
4 contract QatarCoin{
5     
6     uint public constant _totalsupply = 95000000;
7     
8     string public constant symbol = "QTA";
9     string public constant name = "Qatar Coin";
10     uint8 public constant decimls = 18;
11     
12     mapping(address => uint256) balances;
13     mapping(address => mapping(address => uint256)) allowed;
14     
15     function QatarCoin() {
16        balances[msg.sender] = _totalsupply;
17     }
18 
19     function totalSupply() constant returns (uint256 totalSupply) {
20         return _totalsupply;
21     }
22     
23     function balanceOf(address _owner) constant returns (uint256 balance) {
24         return balances[_owner];
25     }
26     
27     function transfer(address _to, uint256 _value) returns (bool success) {
28        require(
29         balances[msg.sender] >= _value
30         && _value > 0
31         
32         );
33       balances[msg.sender] -= _value;
34       balances[_to] += _value;
35       Transfer(msg.sender, _to, _value);
36       return true;
37       
38         
39         
40     }
41     
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
43         require(
44             allowed[_from][msg.sender] >= _value
45             && balances[_from] >= _value
46             && _value > 0 
47             );
48             balances[_from] -= _value;
49             balances[_to] += _value;
50             allowed[_from][msg.sender] -= _value;
51             Transfer(_from, _to, _value);
52             return true;
53     }
54     
55     function approve(address _spender, uint256 _value) returns (bool success) {
56         allowed[msg.sender][_spender] = _value;
57         Approval(msg.sender, _spender, _value);
58         return true;
59     }
60     
61     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
62         return allowed[_owner][_spender];
63     }
64     
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67 
68 
69 }