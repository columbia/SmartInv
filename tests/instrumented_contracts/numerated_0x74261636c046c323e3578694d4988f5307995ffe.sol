1 pragma solidity ^0.5.12;
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
17 contract rupx_contract is ERC20Interface {
18   mapping (address => uint256) public balanceOf;
19   mapping (address => mapping (address => uint256) ) internal allowed;
20 
21   constructor() public {
22     name = "rupx";
23     symbol = "Rupaya";
24     decimals = 18;
25     totalSupply = 37461322000000000000000000;
26     balanceOf[msg.sender] = totalSupply;
27   }
28 
29   function transfer(address _to, uint256 _value) public returns (bool success){
30     require(_to != address(0));
31     require(balanceOf[msg.sender] >= _value);
32     require(balanceOf[_to] + _value >= balanceOf[_to]);
33 
34     balanceOf[msg.sender] -= _value;
35     balanceOf[_to] += _value;
36     emit Transfer(msg.sender, _to, _value);
37     success = true;
38   }
39 
40   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
41     require(_to != address(0));
42     require(balanceOf[_from] >= _value);
43     require(allowed[_from][msg.sender]  >= _value);
44     require(balanceOf[_to] + _value >= balanceOf[_to]);
45 
46     balanceOf[_from] -= _value;
47     balanceOf[_to] += _value;
48     allowed[_from][msg.sender] -= _value;
49     emit Transfer(_from, _to, _value);
50     success = true;
51   }
52 
53   function approve(address _spender, uint256 _value) public returns (bool success){
54       require((_value == 0)||(allowed[msg.sender][_spender] == 0));
55       allowed[msg.sender][_spender] = _value;
56       emit Approval(msg.sender, _spender, _value);
57       success = true;
58   }
59 
60   function allowance(address _owner, address _spender) public view returns (uint256 remaining){
61     return allowed[_owner][_spender];
62   }
63 }