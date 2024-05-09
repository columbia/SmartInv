1 pragma solidity^0.5.1;
2 
3 contract CoshToken {
4     string public name = "CoshToken";
5     string public symbol = "COSH";
6     uint8 public decimals = 18;
7     string public standard = "Cosh Token v1.0";
8     address public tokenOwner = 0x01dd2A4C633380C335eed15E54FAD96ae4DD9058;
9     uint256 public tokenPrice = 680000000000000; // in wei = $0.1
10     uint256 public totalSupply;
11     
12     event Transfer(
13         address indexed _from,
14         address indexed _to,
15         uint256 _value
16     );
17     
18     event Approval(
19         address indexed _owner,
20         address indexed _spender,
21         uint256 _value
22     );
23 
24     mapping(address => uint256) public balanceOf;
25 
26     mapping(address => mapping(address =>uint256)) public allowance;
27 
28     constructor (uint256 _totalSupply) public {
29         totalSupply = _totalSupply;
30         balanceOf[tokenOwner] = totalSupply;
31     }
32 
33     // Transfer
34     function transfer(address _to, uint256 _value) public returns (bool _success) {
35         require(balanceOf[msg.sender] >= _value);
36 
37         balanceOf[msg.sender] -= _value;
38         balanceOf[_to] += _value;
39         
40         emit Transfer(msg.sender, _to, _value);
41 
42         return true;
43     }
44 
45     // approve
46     function approve(address _spender, uint256 _value) public returns (bool success) {
47         // allowence
48         allowance[msg.sender][_spender] = _value;
49         // Approve event
50         emit Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     // Transferfrom
55     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
56         require(balanceOf[_from] >= _value);
57         
58         require(_value <= allowance[_from][msg.sender]);
59         
60         balanceOf[_from] -= _value;
61         balanceOf[_to] += _value;
62 
63         allowance[_from][msg.sender] -= _value;
64 
65         emit Transfer(_from, _to, _value);
66         
67         return true;
68     } 
69 }