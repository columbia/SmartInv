1 pragma solidity 0.4.15;
2 
3 contract ERC20 {
4     function totalSupply() constant returns (uint256 totalSupply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _recipient, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10 
11     event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract StandardToken is ERC20 {
16 
17 	uint256 public totalSupply;
18 	mapping (address => uint256) balances;
19     mapping (address => mapping (address => uint256)) allowed;
20     
21     modifier when_can_transfer(address _from, uint256 _value) {
22         if (balances[_from] >= _value) _;
23     }
24 
25     modifier when_can_receive(address _recipient, uint256 _value) {
26         if (balances[_recipient] + _value > balances[_recipient]) _;
27     }
28 
29     modifier when_is_allowed(address _from, address _delegate, uint256 _value) {
30         if (allowed[_from][_delegate] >= _value) _;
31     }
32 
33     function transfer(address _recipient, uint256 _value)
34         when_can_transfer(msg.sender, _value)
35         when_can_receive(_recipient, _value)
36         returns (bool o_success)
37     {
38         balances[msg.sender] -= _value;
39         balances[_recipient] += _value;
40         Transfer(msg.sender, _recipient, _value);
41         return true;
42     }
43 
44     function transferFrom(address _from, address _recipient, uint256 _value)
45         when_can_transfer(_from, _value)
46         when_can_receive(_recipient, _value)
47         when_is_allowed(_from, msg.sender, _value)
48         returns (bool o_success)
49     {
50         allowed[_from][msg.sender] -= _value;
51         balances[_from] -= _value;
52         balances[_recipient] += _value;
53         Transfer(_from, _recipient, _value);
54         return true;
55     }
56 
57     function balanceOf(address _owner) constant returns (uint256 balance) {
58         return balances[_owner];
59     }
60 
61     function approve(address _spender, uint256 _value) returns (bool o_success) {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) constant returns (uint256 o_remaining) {
68         return allowed[_owner][_spender];
69     }
70 }
71 
72 contract BBPToken is StandardToken {
73 
74 	string public name = "BBP Coin";
75     string public symbol = "BBP";
76     uint public decimals = 3;
77 
78 	function BBPToken (address _bank, uint _totalSupply) {
79 		balances[_bank] += _totalSupply;
80 		totalSupply += _totalSupply;
81 	}
82 
83 	// Transfer amount of tokens from sender account to recipient.
84 	function transfer(address _recipient, uint _amount)
85 		returns (bool o_success)
86 	{
87 		return super.transfer(_recipient, _amount);
88 	}
89 
90 	// Transfer amount of tokens from a specified address to a recipient.
91 	function transferFrom(address _from, address _recipient, uint _amount)
92 		returns (bool o_success)
93 	{
94 		return super.transferFrom(_from, _recipient, _amount);
95 	}
96 }