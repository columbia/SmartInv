1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4   string public name;
5   string public symbol;
6   uint8 public  decimals;
7   uint public totalSupply;
8 
9 
10   function transfer(address _to, uint256 _value) public returns (bool success);
11   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12   function approve(address _spender, uint256 _value) public returns (bool success);
13   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
14 
15   event Transfer(address indexed _from, address indexed _to, uint256 _value);
16   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18 }
19 
20 contract LedouChain is ERC20Interface {
21 
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) internal allowed;
24 
25     constructor() public {
26         totalSupply = 10000000000000000;
27         name = "Ledou Chain";
28         symbol = "LDC";
29         decimals = 8;
30         balanceOf[msg.sender] = totalSupply;
31     }
32 
33     function transfer(address _to, uint _value) public returns (bool success) {
34         require(_to != address(0));
35         require(_value <= balanceOf[msg.sender]);
36         require(balanceOf[_to] + _value >= balanceOf[_to]);
37 
38         balanceOf[msg.sender] -= _value;
39         balanceOf[_to] += _value;
40         emit Transfer(msg.sender, _to, _value);
41         return true;
42     }
43 
44       function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
45         require(_to != address(0));
46         require(_value <= balanceOf[_from]);
47         require(_value <= allowed[_from][msg.sender]);
48         require(balanceOf[_to] + _value >= balanceOf[_to]);
49 
50         balanceOf[_from] -= _value;
51         balanceOf[_to] += _value;
52 
53         allowed[_from][msg.sender] -= _value;
54         emit Transfer(_from, _to, _value);
55         return true;
56       }
57 
58   function approve(address _spender, uint256 _value) public returns (bool success) {
59           allowed[msg.sender][_spender] = _value;
60     emit Approval(msg.sender, _spender, _value);
61     return true;
62   }
63 
64   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
65       return allowed[_owner][_spender];
66   }
67 
68 }