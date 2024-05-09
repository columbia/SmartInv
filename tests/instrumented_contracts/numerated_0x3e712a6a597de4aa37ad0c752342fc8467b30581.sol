1 pragma solidity ^0.5.2;
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
15 }
16 
17 contract WEEX_contract is ERC20Interface {
18   mapping (address => uint256) public balanceOf;
19   mapping (address => mapping (address => uint256) ) internal allowed;
20 
21   constructor() public {
22     name = "WEEX";
23     symbol = "WEEX";
24     decimals = 4;
25     // 发币10亿，再加小数位4个0。
26     totalSupply = 10000000000000;
27     balanceOf[msg.sender] = totalSupply;
28   }
29 
30   function transfer(address _to, uint256 _value) public returns (bool success){
31     require(_to != address(0));
32     require(balanceOf[msg.sender] >= _value);
33     require(balanceOf[_to] + _value >= balanceOf[_to]);
34 
35     balanceOf[msg.sender] -= _value;
36     balanceOf[_to] += _value;
37     emit Transfer(msg.sender, _to, _value);
38     success = true;
39   }
40 
41   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
42     require(_to != address(0));
43     require(balanceOf[_from] >= _value);
44     require(allowed[_from][msg.sender]  >= _value);
45     require(balanceOf[_to] + _value >= balanceOf[_to]);
46 
47     balanceOf[_from] -= _value;
48     balanceOf[_to] += _value;
49     allowed[_from][msg.sender] -= _value;
50     emit Transfer(_from, _to, _value);
51     success = true;
52   }
53 
54   function approve(address _spender, uint256 _value) public returns (bool success){
55       require((_value == 0)||(allowed[msg.sender][_spender] == 0));
56       allowed[msg.sender][_spender] = _value;
57       emit Approval(msg.sender, _spender, _value);
58       success = true;
59   }
60 
61   function allowance(address _owner, address _spender) public view returns (uint256 remaining){
62     return allowed[_owner][_spender];
63   }
64 }