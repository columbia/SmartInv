1 pragma solidity ^0.4.18;
2 
3 contract DrepToken {
4 
5     string public name = "DREP";
6     string public symbol = "DREP";
7     uint8 public decimals = 18;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply;
13     uint256 constant initialSupply = 10000000000;
14     
15     bool public stopped = false;
16 
17     address internal owner = 0x0;
18 
19     modifier ownerOnly {
20         require(owner == msg.sender);
21         _;
22     }
23 
24     modifier isRunning {
25         require(!stopped);
26         _;
27     }
28 
29     modifier validAddress {
30         require(msg.sender != 0x0);
31         _;
32     }
33 
34     function DrepToken() public {
35         owner = msg.sender;
36         totalSupply = initialSupply * 10 ** uint256(decimals);
37         balanceOf[owner] = totalSupply;
38     }
39 
40     function transfer(address _to, uint256 _value) isRunning validAddress public returns (bool success) {
41         require(_to != 0x0);
42         require(balanceOf[msg.sender] >= _value);
43         require(balanceOf[_to] + _value >= balanceOf[_to]);
44         balanceOf[msg.sender] -= _value;
45         balanceOf[_to] += _value;
46         emit Transfer(msg.sender, _to, _value);
47         return true;
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress public returns (bool success) {
51         require(_to != 0x0);
52         require(balanceOf[_from] >= _value);
53         require(balanceOf[_to] + _value >= balanceOf[_to]);
54         require(allowance[_from][msg.sender] >= _value);
55         allowance[_from][msg.sender] -= _value;
56         balanceOf[_from] -= _value;
57         balanceOf[_to] += _value;
58         emit Transfer(_from, _to, _value);
59         return true;
60     }
61 
62     function approve(address _spender, uint256 _value) isRunning validAddress public returns (bool success) {
63         require(_value == 0 || allowance[msg.sender][_spender] == 0);
64         allowance[msg.sender][_spender] = _value;
65         emit Approval(msg.sender, _spender, _value);
66         return true;
67     }
68 
69     function stop() ownerOnly public {
70         stopped = true;
71     }
72 
73     function start() ownerOnly public {
74         stopped = false;
75     }
76 
77     function burn(uint256 _value) isRunning validAddress public {
78         require(balanceOf[msg.sender] >= _value);
79         require(totalSupply >= _value);
80         balanceOf[msg.sender] -= _value;
81         totalSupply -= _value;
82     }
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86 }