1 pragma solidity ^0.4.25;
2 
3 contract Token {
4     string  public name;
5     string  public symbol;
6     //string  public standard = "Token v1.0";
7     uint256 public totalSupply;
8     //
9     address public minter;
10 
11     event Transfer(
12         address indexed _from,
13         address indexed _to,
14         uint256 _value
15     );
16 
17     event Approval(
18         address indexed _owner,
19         address indexed _spender,
20         uint256 _value
21     );
22 
23     mapping(address => uint256) public balanceOf;
24     mapping(address => mapping(address => uint256)) public allowance;
25 
26     constructor (uint256 _initialSupply, string memory _name, string memory _symbol, address _minter) public {
27         balanceOf[_minter] = _initialSupply;
28         totalSupply = _initialSupply;
29         name = _name;
30         symbol =_symbol;
31         //
32         minter =_minter;
33     }
34 
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         require(balanceOf[msg.sender] >= _value);
37 
38         balanceOf[msg.sender] -= _value;
39         balanceOf[_to] += _value;
40 
41         emit Transfer(msg.sender, _to, _value);
42 
43         return true;
44     }
45 
46     function approve(address _spender, uint256 _value) public returns (bool success) {
47         allowance[msg.sender][_spender] = _value;
48 
49         emit Approval(msg.sender, _spender, _value);
50 
51         return true;
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
55         require(_value <= balanceOf[_from]);
56         require(_value <= allowance[_from][msg.sender]);
57 
58         balanceOf[_from] -= _value;
59         balanceOf[_to] += _value;
60 
61         allowance[_from][msg.sender] -= _value;
62 
63         emit Transfer(_from, _to, _value);
64 
65         return true;
66     }
67 
68     function getTokenDetails() public view returns(address _minter, string memory _name, string memory _symbol, uint256 _totalsupply) {
69         return(minter, name, symbol, totalSupply);
70     }
71 }