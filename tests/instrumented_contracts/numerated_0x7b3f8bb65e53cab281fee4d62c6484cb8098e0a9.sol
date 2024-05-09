1 pragma solidity ^0.4.11;
2 // sol ควรจะสั้นๆ ตรงไปตรงมา อย่าเยอะ
3 // Dome C. <dome@tel.co.th> 
4 contract SbuyToken {
5 
6     string public name = "SbuyMining";      //  token name
7     string public symbol = "SBUY";           //  token symbol
8     uint256 public decimals = 0;            //  token digit
9 
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     uint256 public totalSupply = 0;
14     bool public stopped = false;
15 
16     uint256 constant valueFounder = 2000000000;
17     address owner = 0x0;
18 
19     modifier isOwner {
20         assert(owner == msg.sender);
21         _;
22     }
23 
24     modifier isRunning {
25         assert (!stopped);
26         _;
27     }
28 
29     modifier validAddress {
30         assert(0x0 != msg.sender);
31         _;
32     }
33 
34     function  SbuyToken(address _addressFounder) public {
35         owner = msg.sender;
36         totalSupply = valueFounder;
37         balanceOf[_addressFounder] = valueFounder;
38         Transfer(0x0, _addressFounder, valueFounder);
39     }
40     
41 
42     function transfer (address _to, uint256 _value) public isRunning validAddress returns (bool success)  {
43         require(balanceOf[msg.sender] >= _value);
44         require(balanceOf[_to] + _value >= balanceOf[_to]);
45         balanceOf[msg.sender] -= _value;
46         balanceOf[_to] += _value;
47         Transfer(msg.sender, _to, _value);
48         return true;
49     }
50 
51     function transferFrom  (address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
52         require(balanceOf[_from] >= _value);
53         require(balanceOf[_to] + _value >= balanceOf[_to]);
54         require(allowance[_from][msg.sender] >= _value);
55         balanceOf[_to] += _value;
56         balanceOf[_from] -= _value;
57         allowance[_from][msg.sender] -= _value;
58         Transfer(_from, _to, _value);
59         return true;
60     }
61 
62     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
63         require(_value == 0 || allowance[msg.sender][_spender] == 0);
64         allowance[msg.sender][_spender] = _value;
65         Approval(msg.sender, _spender, _value);
66         return true;
67     }
68 
69     function stop() isOwner public {
70         stopped = true;
71     }
72 
73     function start() isOwner public {
74         stopped = false;
75     }
76 
77     function setName(string _name) isOwner public {
78         name = _name;
79     }
80 
81     function burn(uint256 _value) public {
82         require(balanceOf[msg.sender] >= _value);
83         balanceOf[msg.sender] -= _value;
84         balanceOf[0x0] += _value;
85         Transfer(msg.sender, 0x0, _value);
86     }
87 
88     event Transfer(address indexed _from, address indexed _to, uint256 _value);
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 }