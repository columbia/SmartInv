1 pragma solidity ^0.4.18;
2 
3 
4 contract owned {
5     address public owner;
6 
7     constructor() public{
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnerShip(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 contract RedzToken is owned {
22     
23     string public name = "Personal value protocol";
24     string public symbol = "REDZ"; 
25     uint8 public decimals = 8;
26     uint256 public totalSupply = 0;
27     uint256 public constant initialSupply = 5000000000;
28     
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31     
32     event Transfer(address _from, address _to, uint256 _value);
33     event Approval(address _tokenOwner, address _spender, uint256 _value);
34     
35     constructor() public{
36         totalSupply = initialSupply * 10 ** uint256(decimals);
37         balanceOf[msg.sender] = totalSupply;
38     }
39     
40     function updateInfo(string _name, string _symbol) onlyOwner public{
41         name = _name;
42         symbol = _symbol;
43     }
44     
45     function _transfer(address _from, address _to, uint256 _value) internal {
46         require(_to != 0x0);
47         require(balanceOf[_from] >= _value);
48         require(balanceOf[_to] + _value >= balanceOf[_to]);
49         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
50         balanceOf[_from] -= _value;
51         balanceOf[_to] += _value;
52         emit Transfer(_from, _to, _value);
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55     
56     function transfer(address _to, uint256 _value) public returns (bool success) {
57         _transfer(msg.sender, _to, _value);
58         return true;
59     }
60     
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62         require(_value <= allowance[_from][msg.sender]);    
63         allowance[_from][msg.sender] -= _value;
64         _transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function approve(address _spender, uint256 _value) public returns (bool success) {
69         allowance[msg.sender][_spender] = _value;
70         emit Approval(msg.sender, _spender, _value);
71         return true;
72     }
73    
74 }