1 pragma solidity ^0.4.25;
2 
3 contract SWTCoin {
4     string public name = "SWTCoin";      //  token name
5     string public symbol = "SWAT";           //  token symbol
6     string public version = "1.1";
7     uint256 public decimals = 8;            //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 29000000000000000;
13     uint256 public MaxSupply = 0;
14     bool public stopped = true;
15 
16     //000 000 000 000 000 000
17     address owner = 0x48850F503412d8A6e3d63541F0e225f04b13a544;
18     address minter = 0x47c803871c99EC7180E50dcDA989320871FcBfEE;
19     
20     modifier isOwner {
21         assert(owner == msg.sender);
22         _;
23     }
24 
25     modifier isMinter {
26         assert(minter == msg.sender);
27         _;
28     }
29     
30     modifier validAddress {
31         assert(0x0 != msg.sender);
32         _;
33     }
34 
35     constructor () public {
36         MaxSupply = 154000000000000000;
37         balanceOf[owner] = totalSupply;
38         emit Transfer(0x0, owner, totalSupply);
39     }
40 
41     function changeOwner(address _newaddress) isOwner public {
42         owner = _newaddress;
43     }
44 
45     function changeMinter(address _new_mint_address) isOwner public {
46         minter = _new_mint_address;
47     }
48     
49     function airdropMinting(address[] _to_list, uint[] _values) isMinter public {
50         require(_to_list.length == _values.length);
51         for (uint i = 0; i < _to_list.length; i++) {
52             mintToken(_to_list[i], _values[i]);
53         }
54     }
55 
56     function setMaxSupply(uint256 maxsupply_amount) isOwner public {
57       MaxSupply = maxsupply_amount;
58     }
59 
60     function mintToken(address target, uint256 mintedAmount) isMinter public {
61       require(MaxSupply > totalSupply);
62       balanceOf[target] += mintedAmount;
63       totalSupply += mintedAmount;
64       emit Transfer(0, this, mintedAmount);
65       emit Transfer(this, target, mintedAmount);
66     }
67 
68     function transfer(address _to, uint256 _value) public returns (bool success) {
69         require(balanceOf[msg.sender] >= _value);
70         require(balanceOf[_to] + _value >= balanceOf[_to]);
71         balanceOf[msg.sender] -= _value;
72         balanceOf[_to] += _value;
73         emit Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     function transferFrom(address src, address dst, uint256 wad) public returns (bool success) {
78         require(balanceOf[src] >= wad);
79         require(allowance[src][msg.sender] >= wad);
80         allowance[src][msg.sender] -= wad;
81         balanceOf[src] -= wad;
82         balanceOf[dst] += wad;
83         emit Transfer(src, dst, wad);
84         return true;
85     }
86 
87     function approve(address _spender, uint256 _value) public returns (bool success) {
88         require(_value == 0 || allowance[msg.sender][_spender] == 0);
89         allowance[msg.sender][_spender] = _value;
90         emit Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 }