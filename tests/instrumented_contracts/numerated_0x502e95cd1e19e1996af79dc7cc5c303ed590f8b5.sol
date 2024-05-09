1 pragma solidity ^0.4.11;
2 
3 contract EjaToken {
4 
5     string public name = "EJA - EJA Tech ERC20 Token";      //  token name
6     string public symbol = "EJA";           //  token symbol
7     uint256 public decimals = 18;            //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 0;
13     bool public stopped = false;
14 
15     uint256 constant initialSupply = 190000000;
16 
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
34     function EjaToken(address _addressFounder) public {
35         owner = msg.sender;
36         totalSupply = initialSupply;
37         balanceOf[_addressFounder] = initialSupply;
38         Transfer(0x0, _addressFounder, initialSupply);
39     }
40 
41     function transfer(address _to, uint256 _value) isRunning validAddress public returns (bool success) {
42         require(balanceOf[msg.sender] >= _value);
43         require(balanceOf[_to] + _value >= balanceOf[_to]);
44         balanceOf[msg.sender] -= _value;
45         balanceOf[_to] += _value;
46         Transfer(msg.sender, _to, _value);
47         return true;
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress public returns (bool success) {
51         require(balanceOf[_from] >= _value);
52         require(balanceOf[_to] + _value >= balanceOf[_to]);
53         require(allowance[_from][msg.sender] >= _value);
54         balanceOf[_to] += _value;
55         balanceOf[_from] -= _value;
56         allowance[_from][msg.sender] -= _value;
57         Transfer(_from, _to, _value);
58         return true;
59     }
60 
61     function approve(address _spender, uint256 _value) isRunning validAddress public returns (bool success) {
62         require(_value == 0 || allowance[msg.sender][_spender] == 0);
63         allowance[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68     function stop() isOwner public {
69         stopped = true;
70     }
71 
72     function start() isOwner public {
73         stopped = false;
74     }
75 
76     function burn(uint256 _value) public {
77         require(balanceOf[msg.sender] >= _value);
78         balanceOf[msg.sender] -= _value;
79         balanceOf[0x0] += _value;
80         Transfer(msg.sender, 0x0, _value);
81     }
82 
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 }