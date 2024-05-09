1 pragma solidity ^0.4.2;
2 
3 contract DappToken {
4     string  public name = "Utopia Credits";
5     string  public symbol = "UTOC";
6     string  public standard = "DApp Token v1.0";
7     uint256 public totalSupply;
8 
9     event Transfer(
10         address indexed _from,
11         address indexed _to,
12         uint256 _value
13     );
14 
15     event Approval(
16         address indexed _owner,
17         address indexed _spender,
18         uint256 _value
19     );
20 
21     mapping(address => uint256) public balanceOf;
22     mapping(address => mapping(address => uint256)) public allowance;
23 
24     function DappToken (uint256 _initialSupply) public {
25         balanceOf[msg.sender] = _initialSupply;
26         totalSupply = _initialSupply;
27     }
28 
29     function transfer(address _to, uint256 _value) public returns (bool success) {
30         require(balanceOf[msg.sender] >= _value);
31 
32         balanceOf[msg.sender] -= _value;
33         balanceOf[_to] += _value;
34 
35         Transfer(msg.sender, _to, _value);
36 
37         return true;
38     }
39 
40     function approve(address _spender, uint256 _value) public returns (bool success) {
41         allowance[msg.sender][_spender] = _value;
42 
43         Approval(msg.sender, _spender, _value);
44 
45         return true;
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
49         require(_value <= balanceOf[_from]);
50         require(_value <= allowance[_from][msg.sender]);
51 
52         balanceOf[_from] -= _value;
53         balanceOf[_to] += _value;
54 
55         allowance[_from][msg.sender] -= _value;
56 
57         Transfer(_from, _to, _value);
58 
59         return true;
60     }
61 }