1 pragma solidity ^0.4.13;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 
21 contract MyToken is owned {
22 
23     string public name;
24     string public symbol;
25     uint8 public decimals;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     event Burn(address indexed from, uint256 value);
33 
34     function MyToken(
35         uint256 initialSupply,
36         string tokenName,
37         uint8 decimalUnits,
38         string tokenSymbol
39     ) {
40         balanceOf[msg.sender] = initialSupply;
41         totalSupply = initialSupply;
42         name = tokenName;
43         symbol = tokenSymbol;
44         decimals = decimalUnits;
45     }
46 
47     function _transfer(address _from, address _to, uint _value) internal {
48         require(_to != 0x0);
49         require(balanceOf[_from] >= _value);
50         require(balanceOf[_to] + _value > balanceOf[_to]);
51         balanceOf[_from] -= _value;
52         balanceOf[_to] += _value;
53         Transfer(_from, _to, _value);
54     }
55 
56     function transfer(address _to, uint256 _value) {
57         _transfer(msg.sender, _to, _value);
58     }
59 
60     function burnToken(address _from, uint256 _value) onlyOwner returns (bool success) {
61         require(balanceOf[_from] >= _value);
62         balanceOf[_from] -= _value;
63         totalSupply -= _value;
64         Burn(_from, _value);
65         return true;
66     }
67 
68     function mintToken(address _from, uint256 _value) onlyOwner returns (bool success)  {
69         balanceOf[_from] += _value;
70         totalSupply += _value;
71         Transfer(0, owner, _value);
72         Transfer(owner, _from, _value);
73         return true;
74     }
75 }