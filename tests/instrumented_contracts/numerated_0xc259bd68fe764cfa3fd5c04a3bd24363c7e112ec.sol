1 /**
2 */
3 
4 pragma solidity ^0.5.2;
5 contract ERC20Interface {
6   string public name;
7   string public symbol;
8   uint8 public decimals;
9   uint public totalSupply;
10 
11   function transfer(address _to, uint256 _value) public returns (bool success);
12   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13   function approve(address _spender, uint256 _value) public returns (bool success);
14   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
15 
16   event Transfer(address indexed _from, address indexed _to, uint256 _value);
17   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 contract YFIN_contract is ERC20Interface {
21   mapping (address => uint256) public balanceOf;
22   mapping (address => mapping (address => uint256) ) internal allowed;
23 
24   constructor() public {
25     name = "yfi.name";
26     symbol = "YFIN";
27     decimals = 18;
28     // 
29      totalSupply = 60000* (10 ** 18);
30     balanceOf[msg.sender] = totalSupply;
31   }
32 
33   function transfer(address _to, uint256 _value) public returns (bool success){
34     require(_to != address(0));
35     require(balanceOf[msg.sender] >= _value);
36     require(balanceOf[_to] + _value >= balanceOf[_to]);
37 
38     balanceOf[msg.sender] -= _value;
39     balanceOf[_to] += _value;
40     emit Transfer(msg.sender, _to, _value);
41     success = true;
42   }
43 
44   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
45     require(_to != address(0));
46     require(balanceOf[_from] >= _value);
47     require(allowed[_from][msg.sender]  >= _value);
48     require(balanceOf[_to] + _value >= balanceOf[_to]);
49 
50     balanceOf[_from] -= _value;
51     balanceOf[_to] += _value;
52     allowed[_from][msg.sender] -= _value;
53     emit Transfer(_from, _to, _value);
54     success = true;
55   }
56 
57   function approve(address _spender, uint256 _value) public returns (bool success){
58       require((_value == 0)||(allowed[msg.sender][_spender] == 0));
59       allowed[msg.sender][_spender] = _value;
60       emit Approval(msg.sender, _spender, _value);
61       success = true;
62   }
63 
64   function allowance(address _owner, address _spender) public view returns (uint256 remaining){
65     return allowed[_owner][_spender];
66   }
67 }