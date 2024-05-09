1 pragma solidity ^0.5.6;
2 
3 contract TheInternetCoin {
4 
5     string public name = "The Internet Coin" ;                               
6     string public symbol = "ITN";           
7     uint256 public decimals = 18;            
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 0;
13 
14     uint256 constant valueFounder = 200*10**24;
15     address owner = 0x000000000000000000000000000000000000dEaD;
16 
17     modifier isOwner {
18         assert(owner == msg.sender);
19         _;
20     }
21 
22     modifier validAddress {
23         assert(0x000000000000000000000000000000000000dEaD != msg.sender);
24         _;
25     }
26 
27     constructor (address _addressFounder) public {
28         owner = msg.sender;
29         totalSupply = valueFounder;
30         balanceOf[_addressFounder] = valueFounder;
31         emit Transfer(0x000000000000000000000000000000000000dEaD, _addressFounder, valueFounder);
32     }
33 
34     function transfer(address _to, uint256 _value) validAddress public returns (bool success) {
35         require(balanceOf[msg.sender] >= _value);
36         require(balanceOf[_to] + _value >= balanceOf[_to]);
37         balanceOf[msg.sender] -= _value;
38         balanceOf[_to] += _value;
39         emit Transfer(msg.sender, _to, _value);
40         return true;
41     }
42 
43     function transferFrom(address _from, address _to, uint256 _value) validAddress public returns (bool success) {
44         require(balanceOf[_from] >= _value);
45         require(balanceOf[_to] + _value >= balanceOf[_to]);
46         require(allowance[_from][msg.sender] >= _value);
47         balanceOf[_to] += _value;
48         balanceOf[_from] -= _value;
49         allowance[_from][msg.sender] -= _value;
50         emit Transfer(_from, _to, _value);
51         return true;
52     }
53 
54     function approve(address _spender, uint256 _value) validAddress public returns (bool success) {
55         require(_value == 0 || allowance[msg.sender][_spender] == 0);
56         allowance[msg.sender][_spender] = _value;
57         emit Approval(msg.sender, _spender, _value);
58         return true;
59     }
60 
61     function burn(uint256 _value) isOwner public {
62         require(balanceOf[msg.sender] >= _value);
63         balanceOf[msg.sender] -= _value;
64         balanceOf[0x000000000000000000000000000000000000dEaD] += _value;
65         emit Transfer(msg.sender, 0x000000000000000000000000000000000000dEaD, _value);
66         totalSupply = totalSupply - _value ; 
67     }
68 
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71 }