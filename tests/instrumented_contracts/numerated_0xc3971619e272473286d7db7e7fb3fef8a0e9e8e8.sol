1 pragma solidity ^0.4.19;
2 
3 contract DappToken {
4     string  public name = "Korean Unified Currency";
5     string  public symbol = "XWON";
6     string  public standard = "XWON Token v1.0";
7     uint8 public constant decimals = 0;
8     uint256 public totalSupply;
9 
10     event Transfer(
11         address indexed _from,
12         address indexed _to,
13         uint256 _value
14     );
15 
16     event Approval(
17         address indexed _owner,
18         address indexed _spender,
19         uint256 _value
20     );
21 
22     mapping(address => uint256) public balanceOf;
23     mapping(address => mapping(address => uint256)) public allowance;
24 
25     function DappToken (uint256 _initialSupply) public {
26     //function DappToken () public {
27         _initialSupply = 100000000;
28         balanceOf[msg.sender] = _initialSupply;
29         totalSupply = _initialSupply;
30     }
31 
32     function transfer(address _to, uint256 _value) public returns (bool success) {
33         require(balanceOf[msg.sender] >= _value);
34 
35         balanceOf[msg.sender] -= _value;
36         balanceOf[_to] += _value;
37 
38         Transfer(msg.sender, _to, _value);
39 
40         return true;
41     }
42 
43     function approve(address _spender, uint256 _value) public returns (bool success) {
44         allowance[msg.sender][_spender] = _value;
45 
46         Approval(msg.sender, _spender, _value);
47 
48         return true;
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         require(_value <= balanceOf[_from]);
53         require(_value <= allowance[_from][msg.sender]);
54 
55         balanceOf[_from] -= _value;
56         balanceOf[_to] += _value;
57 
58         allowance[_from][msg.sender] -= _value;
59 
60         Transfer(_from, _to, _value);
61 
62         return true;
63     }
64 }