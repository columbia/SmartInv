1 pragma solidity ^0.4.20;
2 
3 contract ERC20Interface
4 {
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     uint public totalSupply;
9 
10     function transfer(address _to, uint256 _value) public returns (bool success);
11 
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     function allowance(address _owner, address _spender) view returns (uint256 remaining);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 
19 }
20 
21 contract BFToken is ERC20Interface
22 {
23 
24   mapping (address => uint256) public balanceOf;
25 
26   mapping (address => mapping (address => uint256)) internal allowed;
27 
28   //init
29   function BFToken(string _name,string _symbol,uint8 _decimals,uint _totalSupply) public
30   {
31      name = _name;
32      symbol = _symbol;
33      decimals = _decimals;
34      totalSupply = _totalSupply;
35      balanceOf[msg.sender] = totalSupply;
36   }
37   
38   function transfer(address _to, uint256 _value) public returns (bool success)
39   {
40       require(_to != address(0));
41       require(balanceOf[msg.sender] >= _value);
42       require(balanceOf[_to] + _value >= balanceOf[_to]);
43 
44 
45       balanceOf[msg.sender] -= _value;
46       balanceOf[_to] += _value;
47 
48       emit Transfer(msg.sender,_to,_value);
49   }
50 
51   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
52   {
53       require(_to != address(0));
54       require(balanceOf[_from] >= _value);
55       require(allowed[_from][msg.sender] >= _value);
56       require(balanceOf[_to] + _value >= balanceOf[_to]);
57 
58       balanceOf[_from] -= _value;
59       balanceOf[_to] += _value;
60 
61       emit Transfer(_from,_to,_value);
62   }
63 
64   function approve(address _spender, uint256 _value) public returns (bool success)
65   {
66      allowed[msg.sender][_spender] = _value;
67 
68      emit Approval(msg.sender,_spender,_value);
69 
70 
71      success = true;
72   }
73 
74   function allowance(address _owner, address _spender) view returns (uint256 remaining)
75   {
76      return allowed[_owner][_spender];
77   }
78 
79 }