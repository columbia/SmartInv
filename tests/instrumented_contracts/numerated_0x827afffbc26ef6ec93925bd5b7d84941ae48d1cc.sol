1 pragma solidity ^0.5.0;
2 contract ERC20 {
3     string public  name = "VOS Token";
4     string public  symbol = "VOS";
5     uint8 public  decimals = 18;
6     uint public totalSupply = 10000000000 * 10 ** uint(decimals);
7     mapping(address => uint256) public balanceOf;
8     mapping(address => mapping(address => uint256)) allowed;
9     event Transfer(address indexed from, address indexed to, uint tokens);
10     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
11     constructor() public {
12        balanceOf[msg.sender] = totalSupply;
13        emit Transfer(address(0), msg.sender, totalSupply);
14     }
15   function transfer(address _to, uint256 _value) public returns (bool success) {
16       require(_to != address(0));
17       require(balanceOf[msg.sender] >= _value);
18       require(balanceOf[ _to] + _value >= balanceOf[ _to]);   
19       balanceOf[msg.sender] -= _value;
20       balanceOf[_to] += _value;
21       emit Transfer(msg.sender, _to, _value);
22       return true;
23   }
24   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
25       require(_to != address(0));
26       require(allowed[_from][msg.sender] >= _value);
27       require(balanceOf[_from] >= _value);
28       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
29 
30       balanceOf[_from] -= _value;
31       balanceOf[_to] += _value;
32       allowed[_from][msg.sender] -= _value;
33       emit Transfer(msg.sender, _to, _value);
34       return true;
35   }
36   function approve(address _spender, uint256 _value) public returns (bool success) {
37       allowed[msg.sender][_spender] = _value;
38       emit Approval(msg.sender, _spender, _value);
39       return true;
40   }
41   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
42       return allowed[_owner][_spender];
43   }
44 }