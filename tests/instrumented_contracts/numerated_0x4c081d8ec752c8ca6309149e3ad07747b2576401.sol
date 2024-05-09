1 pragma solidity ^0.5.0;
2  
3 contract DinoToken {
4     string  public name = "Dino Token";
5     string  public symbol = "DINO";
6     uint256 public totalSupply = 1000000000000000000000000; // 1 million tokens
7     uint8 public decimals = 18;
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
24     constructor() public {
25         balanceOf[msg.sender] = totalSupply;
26     }
27  
28     function transfer(address _to, uint256 _value) public returns (bool success) {
29         require(balanceOf[msg.sender] >= _value);
30         balanceOf[msg.sender] -= _value;
31         balanceOf[_to] += _value;
32         emit Transfer(msg.sender, _to, _value);
33         return true;
34     }
35  
36     function approve(address _spender, uint256 _value) public returns (bool success) {
37         allowance[msg.sender][_spender] = _value;
38         emit Approval(msg.sender, _spender, _value);
39         return true;
40     }
41  
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
43         require(_value <= balanceOf[_from]);
44         require(_value <= allowance[_from][msg.sender]);
45         balanceOf[_from] -= _value;
46         balanceOf[_to] += _value;
47         allowance[_from][msg.sender] -= _value;
48         emit Transfer(_from, _to, _value);
49         return true;
50     }
51 }