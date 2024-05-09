1 pragma solidity ^0.4.20;
2 
3 contract ERC20Interface {
4   string public name;
5   string public symbol;
6   uint8 public  decimals;
7   uint public totalSupply;
8 
9 
10   function transfer(address _to, uint256 _value) returns (bool success);
11   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12   function approve(address _spender, uint256 _value) returns (bool success);
13   function allowance(address _owner, address _spender) view returns (uint256 remaining);
14 
15   event Transfer(address indexed _from, address indexed _to, uint256 _value);
16   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18 }
19 
20 contract ERC20 is ERC20Interface {
21 
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) internal allowed;
24 
25     constructor() public {
26         totalSupply = 1000000000;
27         name = "CDA Token";
28         symbol = "CDA";
29         decimals = 0;
30         balanceOf[msg.sender] = totalSupply;
31     }
32 
33   function balanceOf(address _owner) view returns (uint256 balance) {
34       return balanceOf[_owner];
35   }
36 
37     function transfer(address _to, uint _value) public returns (bool success) {
38         require(_to != address(0));
39         require(_value <= balanceOf[msg.sender]);
40         require(balanceOf[_to] + _value >= balanceOf[_to]);
41 
42         balanceOf[msg.sender] -= _value;
43         balanceOf[_to] += _value;
44         emit Transfer(msg.sender, _to, _value);
45         return true;
46     }
47 
48       function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
49         require(_to != address(0));
50         require(_value <= balanceOf[_from]);
51         require(_value <= allowed[_from][msg.sender]);
52         require(balanceOf[_to] + _value >= balanceOf[_to]);
53 
54         balanceOf[_from] -= _value;
55         balanceOf[_to] += _value;
56 
57         allowed[_from][msg.sender] -= _value;
58         emit Transfer(_from, _to, _value);
59         return true;
60       }
61 
62   function approve(address _spender, uint256 _value) returns (bool success) {
63           allowed[msg.sender][_spender] = _value;
64     emit Approval(msg.sender, _spender, _value);
65     return true;
66   }
67 
68   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
69       return allowed[_owner][_spender];
70   }
71 
72 }