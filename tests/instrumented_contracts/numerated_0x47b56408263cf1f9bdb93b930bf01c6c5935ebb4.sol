1 pragma solidity ^0.4.25;
2 contract ERC20Interface {
3   string public name;
4   string public symbol;
5   uint8 public decimals;
6   uint public totalSupply;
7 
8   //function balanceOf(address _owner) view returns (uint256 balance);
9   function transfer(address _to, uint256 _value) public returns (bool success);
10   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
11   function approve(address _spender, uint256 _value) public returns (bool success);
12   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
13 
14   event Transfer(address indexed _from, address indexed _to, uint256 _value);
15   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 
17 }
18 
19 
20 contract ERC20 is ERC20Interface {
21 
22   mapping (address => uint256) public balanceOf;
23   mapping (address => mapping (address => uint256) ) internal allowed;
24 
25   constructor() public {
26     name = "IFX";
27     symbol = "IFX";
28     decimals = 8;
29     // 发币10亿，再加小数位8个0。
30     totalSupply = 100000000000000000;
31     balanceOf[msg.sender] = totalSupply;
32   }
33 
34 //   function balanceOf(address _owner) view returns (uint256 balance){
35 //       return balanceOf[_owner];
36 //   }
37 
38   function transfer(address _to, uint256 _value) public returns (bool success){
39     require(_to != address(0));
40     require(balanceOf[msg.sender] >= _value);
41     require(balanceOf[_to] + _value >= balanceOf[_to]);
42 
43     balanceOf[msg.sender] -= _value;
44     balanceOf[_to] += _value;
45     emit Transfer(msg.sender, _to, _value);
46     success = true;
47   }
48 
49   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
50 
51     require(_to != address(0));
52     require(balanceOf[msg.sender] >= _value);
53     require(allowed[_from][msg.sender]  >= _value);
54     require(balanceOf[_to] + _value >= balanceOf[_to]);
55 
56     balanceOf[_from] -= _value;
57     balanceOf[_to] += _value;
58     emit Transfer(_from, _to, _value);
59     success = true;
60   }
61 
62   function approve(address _spender, uint256 _value) public returns (bool success){
63       allowed[msg.sender][_spender] = _value;
64       emit Approval(msg.sender, _spender, _value);
65       success = true;
66   }
67 
68   function allowance(address _owner, address _spender) public view returns (uint256 remaining){
69     return allowed[_owner][_spender];
70   }
71 
72 }