1 pragma solidity ^0.4.18;
2 
3 contract Dexy {
4     string public symbol = "Dexy";
5     string public name = "Dexy";
6     uint8 public constant decimals = 8;
7     uint256 _totalSupply = 0;
8 	uint256 _maxTotalSupply = 100000000000000000000; // 1 Trillion Coins
9 
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12  
13     mapping(address => uint256) balances;
14  
15     mapping(address => mapping (address => uint256)) allowed;
16  
17     function totalSupply() public constant returns (uint256) {        
18 		return _totalSupply;
19     }
20  
21     function balanceOf(address _owner) public constant returns (uint256 balance) {
22         return balances[_owner];
23     }
24  
25     function transfer(address _to, uint256 _amount) public returns (bool success) {
26         if (balances[msg.sender] >= _amount 
27             && _amount > 0
28             && balances[_to] + _amount > balances[_to]) {
29             balances[msg.sender] -= _amount;
30             balances[_to] += _amount;
31             Transfer(msg.sender, _to, _amount);
32             return true;
33         } else {
34             return false;
35         }
36     }
37     function transferFrom(
38         address _from,
39         address _to,
40         uint256 _amount
41     ) public returns (bool success) {
42         if (balances[_from] >= _amount
43             && allowed[_from][msg.sender] >= _amount
44             && _amount > 0
45             && balances[_to] + _amount > balances[_to]) {
46             balances[_from] -= _amount;
47             allowed[_from][msg.sender] -= _amount;
48             balances[_to] += _amount;
49             Transfer(_from, _to, _amount);
50             return true;
51         } else {
52             return false;
53         }
54     }
55  
56     function approve(address _spender, uint256 _amount) public returns (bool success) {
57         allowed[msg.sender][_spender] = _amount;
58         Approval(msg.sender, _spender, _amount);
59         return true;
60     }
61  
62     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
63         return allowed[_owner][_spender];
64     }
65 
66 	function MaxTotalSupply() public constant returns(uint256)
67 	{
68 		return _maxTotalSupply;
69 	}
70 	
71 	function TimeNow() public constant returns(uint256)
72 	{
73 		return now;
74 	}
75 }