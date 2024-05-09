1 pragma solidity ^0.4.11;
2 
3 contract SPGForEver {
4 
5     string public constant name = "SPG For Ever";      //  token name
6     string public constant symbol = "SPG";         //  token symbol
7     uint256 public constant decimals = 18;          //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => uint256) public lockOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     uint256 public totalSupply = 0;
14     bool public stopped = false;
15 
16     uint256 constant valueFounder = 10000000000 *  10 ** decimals;
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
34     function SPGForEver(address _addressFounder) public{
35         owner = msg.sender;
36         totalSupply = valueFounder;
37         balanceOf[_addressFounder] = valueFounder;
38         Transfer(0x0, _addressFounder, valueFounder);
39     }
40 
41     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
42         require(balanceOf[msg.sender] - lockOf[msg.sender] >= _value);
43         require(balanceOf[_to] + _value >= balanceOf[_to]);
44         balanceOf[msg.sender] -= _value;
45         balanceOf[_to] += _value;
46         Transfer(msg.sender, _to, _value);
47         return true;
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
51         require(balanceOf[_from] - lockOf[_from] >= _value);
52         require(balanceOf[_to] + _value >= balanceOf[_to]);
53         require(allowance[_from][msg.sender] >= _value);
54         balanceOf[_to] += _value;
55         balanceOf[_from] -= _value;
56         allowance[_from][msg.sender] -= _value;
57         Transfer(_from, _to, _value);
58         return true;
59     }
60 
61     function approve(address _spender, uint256 _value)public isRunning validAddress returns (bool success) {
62         require(_value == 0 || allowance[msg.sender][_spender] == 0);
63         allowance[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68     function setLock(address _owner, uint256 _value) public isOwner validAddress returns (bool success) {
69         require(_value >= 0);
70         if (_value > balanceOf[_owner]) {
71             _value = balanceOf[_owner];
72         }
73         lockOf[_owner] = _value;
74         SetLock(msg.sender, _owner, _value);
75         return true;
76     }
77 
78     function stop() public isOwner {
79         stopped = true;
80     }
81 
82     function start()public isOwner {
83         stopped = false;
84     }
85 
86     function burn(uint256 _value)public {
87         require(balanceOf[msg.sender] >= _value);
88         balanceOf[msg.sender] -= _value;
89         balanceOf[0x0] += _value;
90         Transfer(msg.sender, 0x0, _value);
91     }
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95     event SetLock(address indexed _sender, address indexed _owner, uint256 _value);
96 }