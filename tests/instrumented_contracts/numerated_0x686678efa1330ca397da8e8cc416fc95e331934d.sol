1 /**
2  *Submitted for verification at Etherscan.io on 2020-03-16
3 */
4 
5 pragma solidity ^0.5.2;
6 contract ERC20Interface {
7   string public name;
8   string public symbol;
9   uint8 public decimals;
10   uint public totalSupply;
11 
12   function transfer(address _to, uint256 _value) public returns (bool success);
13   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
14   function approve(address _spender, uint256 _value) public returns (bool success);
15   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
16 
17   event Transfer(address indexed _from, address indexed _to, uint256 _value);
18   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract FTYY_contract is ERC20Interface {
22   mapping (address => uint256) public balanceOf;
23   mapping (address => mapping (address => uint256) ) internal allowed;
24 
25   constructor() public {
26     name = "ft application";
27     symbol = "FTYY";
28     decimals = 18;
29     // 
30      totalSupply = 5000000* (10 ** 18);
31     balanceOf[msg.sender] = totalSupply;
32   }
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
46     require(_to != address(0));
47     require(balanceOf[_from] >= _value);
48     require(allowed[_from][msg.sender]  >= _value);
49     require(balanceOf[_to] + _value >= balanceOf[_to]);
50 
51     balanceOf[_from] -= _value;
52     balanceOf[_to] += _value;
53     allowed[_from][msg.sender] -= _value;
54     emit Transfer(_from, _to, _value);
55     success = true;
56   }
57 
58   function approve(address _spender, uint256 _value) public returns (bool success){
59       require((_value == 0)||(allowed[msg.sender][_spender] == 0));
60       allowed[msg.sender][_spender] = _value;
61       emit Approval(msg.sender, _spender, _value);
62       success = true;
63   }
64 
65   function allowance(address _owner, address _spender) public view returns (uint256 remaining){
66     return allowed[_owner][_spender];
67   }
68 }