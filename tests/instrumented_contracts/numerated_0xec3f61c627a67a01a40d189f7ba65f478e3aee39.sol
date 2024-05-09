1 pragma solidity ^0.4.11;
2 
3 pragma solidity ^0.4.11;
4 
5 interface IERC20 {
6     function totalSupply() constant returns (uint256 totalSupply);
7     function balanceOf(address _owner) constant returns (uint256 balance);
8     function transfer(address _to, uint256 _value) returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
10     function approve(address _spender, uint256 _value) returns (bool success);
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 contract HXTToken is IERC20 {
17     
18     uint public constant _totalSupply = 290000000000;
19     
20     string public constant symbol = "HXT";
21     string public constant name = "Hextracoin Token";
22     uint8 public constant decimals = 4;
23     
24     mapping(address => uint256) balances;
25     mapping(address =>mapping(address => uint256)) allowed;
26     
27     function HXTtoken () {
28         balances[msg.sender] = _totalSupply;
29     }
30     
31     function totalSupply() constant returns (uint256 totalSupply) {
32         return _totalSupply;
33     }
34     
35     function balanceOf(address _owner) constant returns (uint256 balance) {
36         return balances[_owner];
37     }
38     function transfer(address _to, uint256 _value) returns (bool success) {
39         require(
40             balances[msg.sender] >= _value
41             && _value > 0
42             );
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             Transfer(msg.sender, _to, _value);
46             return true;
47             
48     }
49     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
50         require(
51             allowed[_from][msg.sender] >= _value
52             && balances[_from] >= _value
53             && _value >0 
54             );
55             balances[_from] -= _value;
56             balances[_to] += _value;
57             allowed[_from][msg.sender] -= _value;
58             Transfer(_from, _to, _value);
59             return true;
60     }
61     function approve(address _spender, uint256 _value) returns (bool success) {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
67         return allowed[_owner][_spender];
68         
69     }
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 }