1 pragma solidity ^0.4.18;
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
14 pragma solidity ^0.4.18;
15 
16 
17 contract VertNite is IERC20 {
18     
19     uint public constant _totalSupply = 20000000000000000000000000;
20     
21     string public constant symbol = "VTN";
22     string public constant name = "VertNite";
23     uint8 public constant decimals = 18;
24     
25     mapping(address => uint256) balances;
26     mapping(address => mapping(address => uint256)) allowed;
27     
28     function VertNite() {
29         balances[msg.sender] = _totalSupply;
30     }
31     
32     function totalSupply() constant returns (uint256 totalSupply) {
33         return _totalSupply;
34     }
35     
36     function balanceOf(address _owner) constant returns (uint256 balance) {
37         return balances[_owner];
38     }
39     
40     function transfer(address _to, uint256 _value) returns (bool success) {
41         require(
42             balances[msg.sender] >= _value
43             && _value > 0
44         );
45         balances[msg.sender] -= _value;
46         balances[_to] += _value;
47         Transfer(msg.sender, _to, _value);
48         return true;
49     }
50     
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52         require(
53             allowed[_from][msg.sender] >= _value
54             && balances[_from] >= _value
55             && _value > 0
56         );
57         balances[_from] -= _value;
58         balances[_to] += _value;
59         allowed[_from][msg.sender] -= _value;
60         Transfer(_from, _to, _value);
61         return true;
62     }
63     
64     function approve(address _spender, uint256 _value) returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69     
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71         return allowed[_owner][_spender];
72     }
73     
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76     
77 }