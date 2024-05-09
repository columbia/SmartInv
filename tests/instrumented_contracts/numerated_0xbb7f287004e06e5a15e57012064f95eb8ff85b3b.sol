1 /**
2  * http://erc20f.com
3 *http://epay.duodiw.com
4 */
5 
6 pragma solidity ^0.5.2;
7 contract ERC20Interface {
8   string public name;
9   string public symbol;
10   uint8 public decimals;
11   uint public totalSupply;
12 
13   function transfer(address _to, uint256 _value) public returns (bool success);
14   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
15   function approve(address _spender, uint256 _value) public returns (bool success);
16   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
17 
18   event Transfer(address indexed _from, address indexed _to, uint256 _value);
19   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 
22 contract b99_contract is ERC20Interface {
23   mapping (address => uint256) public balanceOf;
24   mapping (address => mapping (address => uint256) ) internal allowed;
25 
26   constructor() public {
27     name = "business99";
28     symbol = "b99";
29     decimals = 18;
30     // 
31      totalSupply = 45000000* (10 ** 18);
32     balanceOf[msg.sender] = totalSupply;
33   }
34 
35   function transfer(address _to, uint256 _value) public returns (bool success){
36     require(_to != address(0));
37     require(balanceOf[msg.sender] >= _value);
38     require(balanceOf[_to] + _value >= balanceOf[_to]);
39 
40     balanceOf[msg.sender] -= _value;
41     balanceOf[_to] += _value;
42     emit Transfer(msg.sender, _to, _value);
43     success = true;
44   }
45 
46   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
47     require(_to != address(0));
48     require(balanceOf[_from] >= _value);
49     require(allowed[_from][msg.sender]  >= _value);
50     require(balanceOf[_to] + _value >= balanceOf[_to]);
51 
52     balanceOf[_from] -= _value;
53     balanceOf[_to] += _value;
54     allowed[_from][msg.sender] -= _value;
55     emit Transfer(_from, _to, _value);
56     success = true;
57   }
58 
59   function approve(address _spender, uint256 _value) public returns (bool success){
60       require((_value == 0)||(allowed[msg.sender][_spender] == 0));
61       allowed[msg.sender][_spender] = _value;
62       emit Approval(msg.sender, _spender, _value);
63       success = true;
64   }
65 
66   function allowance(address _owner, address _spender) public view returns (uint256 remaining){
67     return allowed[_owner][_spender];
68   }
69 }