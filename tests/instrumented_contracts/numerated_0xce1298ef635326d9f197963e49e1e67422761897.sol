1 pragma solidity ^0.5.0;
2 contract Token {
3     string  public name = "PiSwap Token";
4     string  public symbol = "PIS";
5     uint256 public totalSupply = 1000000000000000 ; // 9 million tokens
6     uint8   public decimals = 8;
7  
8     event Transfer(
9         address indexed _from,
10         address indexed _to,
11         uint256 _value
12     );  
13 
14     event Approval(
15         address indexed _owner,
16         address indexed _spender,
17         uint256 _value
18     );
19  
20     mapping(address => uint256) public balanceOf;
21     mapping(address => mapping(address => uint256)) public allowance;
22 
23     constructor() public {
24         balanceOf[msg.sender] = totalSupply;
25     }
26 
27     function transfer(address _to, uint256 _value) public returns (bool success) {
28         require(balanceOf[msg.sender] >= _value);
29         balanceOf[msg.sender] -= _value;
30         balanceOf[_to] += _value;
31         emit Transfer(msg.sender, _to, _value);
32         return true;
33     }
34 
35     function approve(address _spender, uint256 _value) public returns (bool success) {
36         allowance[msg.sender][_spender] = _value;
37         emit Approval(msg.sender, _spender, _value);
38         return true;
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
42         require(_value <= balanceOf[_from]);
43         require(_value <= allowance[_from][msg.sender]);
44         balanceOf[_from] -= _value;
45         balanceOf[_to] += _value;
46         allowance[_from][msg.sender] -= _value;
47         emit Transfer(_from, _to, _value);
48         return true;
49     }
50 
51     
52 }