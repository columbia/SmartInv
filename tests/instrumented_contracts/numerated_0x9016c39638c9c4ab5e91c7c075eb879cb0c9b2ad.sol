1 pragma solidity ^0.4.11;
2 
3 contract VKBToken {
4 	string public constant symbol = "VKB";
5 	string public constant name = "VKBToken";
6 	uint8 public constant decimals = 18;
7 	uint256 _totalSupply = 210000;
8 	
9 	address public owner;
10 	
11 	mapping(address => uint256) balances;
12 	
13 	mapping(address => mapping(address => uint256)) allowed;
14 	
15 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
16 	
17 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 	
19 	modifier onlyOwner() {
20 	    require(msg.sender == owner);
21 	    _;
22 	}
23 	
24 	function VKBToken() {
25 	    owner = msg.sender;
26 	    balances[owner] = _totalSupply;
27 	}
28 
29 	function totalSupply() constant returns (uint256 totalSupply) {
30 	    totalSupply = _totalSupply;
31 	}
32 	
33 	function balanceOf(address _owner) constant returns (uint256 balance) {
34 	    return balances[_owner];
35 	}
36 	
37     function transfer(address _to, uint256 _amount) returns (bool success) {
38         if (balances[msg.sender] >= _amount 
39             && _amount > 0
40             && balances[_to] + _amount > balances[_to]) {
41             balances[msg.sender] -= _amount;
42             balances[_to] += _amount;
43             Transfer(msg.sender, _to, _amount);
44             return true;
45         } else {
46             return false;
47         }
48     }
49     
50     function transferFrom(
51         address _from,
52         address _to,
53         uint256 _amount
54     ) returns (bool success) {
55         if (balances[_from] >= _amount
56             && allowed[_from][msg.sender] >= _amount
57             && _amount > 0
58             && balances[_to] + _amount > balances[_to]) {
59             balances[_from] -= _amount;
60             allowed[_from][msg.sender] -= _amount;
61             balances[_to] += _amount;
62             Transfer(_from, _to, _amount);
63             return true;
64         } else {
65             return false;
66         }
67     }
68     
69     function approve(address _spender, uint256 _amount) returns (bool success) {
70         allowed[msg.sender][_spender] = _amount;
71         Approval(msg.sender, _spender, _amount);
72         return true;
73     }
74  
75     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
76         return allowed[_owner][_spender];
77     }
78 }