1 pragma solidity ^0.4.20;
2 
3 contract BFCTOKEN
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
14     function allowance(address _owner, address _spender) public returns (uint256 remaining);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 
19 }
20 
21 contract BF is BFCTOKEN
22 {
23 
24   mapping (address => uint256) public balanceOf;
25 
26   mapping (address => mapping (address => uint256)) internal allowed;
27 
28   //init
29   constructor(string _name,string _symbol,uint8 _decimals,uint _totalSupply) public
30   {
31      name = _name;
32      symbol = _symbol;
33      decimals = _decimals;
34      totalSupply = _totalSupply;
35      balanceOf[msg.sender] = _totalSupply;
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
49       
50       success = true;
51   }
52 
53   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
54   {
55       require(_to != address(0));
56       require(balanceOf[_from] >= _value);
57       require(allowed[_from][msg.sender] >= _value);
58       require(balanceOf[_to] + _value >= balanceOf[_to]);
59 
60       balanceOf[_from] -= _value;
61       balanceOf[_to] += _value;
62 
63       emit Transfer(_from,_to,_value);
64       
65       success = true;
66   }
67 
68   function approve(address _spender, uint256 _value) public returns (bool success)
69   {
70      allowed[msg.sender][_spender] = _value;
71 
72      emit Approval(msg.sender,_spender,_value);
73 
74 
75      success = true;
76   }
77 
78   function allowance(address _owner, address _spender) public returns (uint256 remaining)
79   {
80      return allowed[_owner][_spender];
81   }
82 
83 }