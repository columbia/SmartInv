1 pragma solidity ^0.4.25;
2 contract ERC20Interface {
3   string public name;
4   string public symbol;
5   uint8 public decimals;
6   uint public totalSupply;
7 
8   function transfer(address _to, uint256 _value) public returns (bool success);
9   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
10   function approve(address _spender, uint256 _value) public returns (bool success);
11   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
12 
13   event Transfer(address indexed _from, address indexed _to, uint256 _value);
14   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16 }
17 
18 
19 contract FCG is ERC20Interface {
20 
21   mapping (address => uint256) public balanceOf;
22   mapping (address => mapping (address => uint256) ) internal allowed;
23 
24   constructor() public {
25     name = "FCG";
26     symbol = "FCG";
27     decimals = 8;
28     // 发币60亿，再加小数位8个0。
29     totalSupply = 600000000000000000;
30     balanceOf[msg.sender] = totalSupply;
31   }
32 
33 
34   function transfer(address _to, uint256 _value) public returns (bool success){
35     require(_to != address(0));
36     require(balanceOf[msg.sender] >= _value);
37     require(balanceOf[_to] + _value >= balanceOf[_to]);
38 
39     balanceOf[msg.sender] -= _value;
40     balanceOf[_to] += _value;
41     emit Transfer(msg.sender, _to, _value);
42     success = true;
43   }
44 
45   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
46 
47     require(_to != address(0));
48     require(balanceOf[msg.sender] >= _value);
49     require(allowed[_from][msg.sender]  >= _value);
50     require(balanceOf[_to] + _value >= balanceOf[_to]);
51 
52     balanceOf[_from] -= _value;
53     balanceOf[_to] += _value;
54     emit Transfer(_from, _to, _value);
55     success = true;
56   }
57 
58   function approve(address _spender, uint256 _value) public returns (bool success){
59       allowed[msg.sender][_spender] = _value;
60       emit Approval(msg.sender, _spender, _value);
61       success = true;
62   }
63 
64   function allowance(address _owner, address _spender) public view returns (uint256 remaining){
65     return allowed[_owner][_spender];
66   }
67 
68 }