1 pragma solidity ^0.4.23;
2 
3 
4 contract Owned {
5     address public owner;
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract Base is Owned {
21     string public name;
22     string public symbol;
23     uint8 public decimals = 18;
24     uint256 public totalSupply;
25     uint256 public tokenUnit = 10 ** uint(decimals);
26     uint256 public kUnit = 1000 * tokenUnit;
27     uint256 public foundingTime;
28 
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33 
34     constructor() public {
35         foundingTime = now;
36     }
37 
38     function _transfer(address _from, address _to, uint256 _value) internal {
39         require(_to != 0x0);
40         require(balanceOf[_from] >= _value);
41         require(balanceOf[_to] + _value > balanceOf[_to]);
42         balanceOf[_from] -= _value;
43         balanceOf[_to] += _value;
44         emit Transfer(_from, _to, _value);
45     }
46 
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value);
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         require(_value <= allowance[_from][msg.sender]);
53         allowance[_from][msg.sender] -= _value;
54         _transfer(_from, _to, _value);
55         return true;
56     }
57 
58     function approve(address _spender, uint256 _value) public returns (bool success) {
59         allowance[msg.sender][_spender] = _value;
60         return true;
61     }
62 }
63 
64 contract PCT is Base {
65     uint256 public reserveSupply = 1000000 * kUnit;
66 
67     constructor() public {
68         totalSupply = reserveSupply;
69         balanceOf[msg.sender] = totalSupply;
70         name = "PCT Token";
71         symbol = "PCT";
72     }
73 }