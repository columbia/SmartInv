1 pragma solidity ^0.4.11;
2 
3 contract AMGTToken {
4 
5     string public name = "AmazingTokenTest";      //  token name
6     string public symbol = "AMGT";           //  token symbol
7     uint256 public decimals = 6;            //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 0;
13     bool public stopped = false;
14 
15     uint256 constant valueFounder = 1000000000000000;
16     address owner = 0x0;
17 
18     modifier isOwner {
19         assert(owner == msg.sender);
20         _;
21     }
22 
23     modifier isRunning {
24         assert (!stopped);
25         _;
26     }
27 
28     modifier validAddress {
29         assert(0x0 != msg.sender);
30         _;
31     }
32 
33     function AMGTToken() {
34         owner = msg.sender;
35         totalSupply = valueFounder;
36         balanceOf[owner] = valueFounder;
37     }
38 
39     function transfer(address _to, uint256 _value) isRunning validAddress returns (bool success) {
40         require(balanceOf[msg.sender] >= _value);
41         require(balanceOf[_to] + _value >= balanceOf[_to]);
42         balanceOf[msg.sender] -= _value;
43         balanceOf[_to] += _value;
44         Transfer(msg.sender, _to, _value);
45         return true;
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress returns (bool success) {
49         require(balanceOf[_from] >= _value);
50         require(balanceOf[_to] + _value >= balanceOf[_to]);
51         require(allowance[_from][msg.sender] >= _value);
52         balanceOf[_to] += _value;
53         balanceOf[_from] -= _value;
54         allowance[_from][msg.sender] -= _value;
55         Transfer(_from, _to, _value);
56         return true;
57     }
58 
59     function approve(address _spender, uint256 _value) isRunning validAddress returns (bool success) {
60         require(_value == 0 || allowance[msg.sender][_spender] == 0);
61         allowance[msg.sender][_spender] = _value;
62         Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function stop() isOwner {
67         stopped = true;
68     }
69 
70     function start() isOwner {
71         stopped = false;
72     }
73 
74     function setName(string _name) isOwner {
75         name = _name;
76     }
77 
78     function burn(uint256 _value) {
79         require(balanceOf[msg.sender] >= _value);
80         balanceOf[msg.sender] -= _value;
81         balanceOf[0x0] += _value;
82         Transfer(msg.sender, 0x0, _value);
83     }
84 
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87 }