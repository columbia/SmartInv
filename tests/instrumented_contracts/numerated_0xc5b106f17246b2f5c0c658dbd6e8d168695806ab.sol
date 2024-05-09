1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12  
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17  
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22  
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 contract SIEToken {
30     using SafeMath for uint;
31 
32     string public name = "Social Intelligent Evolution";      //  token name
33     string public symbol = "SIE";           //  token symbol
34     uint256 public decimals = 6;            //  token digit
35 
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38 
39     uint256 public totalSupply = 0;
40     bool public stopped = false;
41 
42     uint256 constant valueFounder = 3000000000000000;
43     address owner = 0x0;
44 
45     modifier onlyPayloadSize(uint size) {
46         require(!(msg.data.length < size + 4));
47         _;
48     }
49 
50     modifier isOwner {
51         assert(owner == msg.sender);
52         _;
53     }
54 
55     modifier isRunning {
56         assert (!stopped);
57         _;
58     }
59 
60     modifier validAddress {
61         assert(0x0 != msg.sender);
62         _;
63     }
64 
65     function SIEToken(address _addressFounder) {
66         owner = msg.sender;
67         totalSupply = valueFounder;
68         balanceOf[_addressFounder] = valueFounder;
69         Transfer(0x0, _addressFounder, valueFounder);
70     }
71 
72     function transfer(address _to, uint256 _value) isRunning validAddress onlyPayloadSize(2 * 32) returns (bool success) {
73         require(balanceOf[msg.sender] >= _value);
74         require(balanceOf[_to] + _value >= balanceOf[_to]);
75         balanceOf[msg.sender] -= _value;
76         balanceOf[_to] += _value;
77         Transfer(msg.sender, _to, _value);
78         return true;
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress onlyPayloadSize(3 * 32) returns (bool success) {
82         require(balanceOf[_from] >= _value);
83         require(balanceOf[_to] + _value >= balanceOf[_to]);
84         require(allowance[_from][msg.sender] >= _value);
85         balanceOf[_to] += _value;
86         balanceOf[_from] -= _value;
87         allowance[_from][msg.sender] -= _value;
88         Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     function approve(address _spender, uint256 _value) isRunning validAddress returns (bool success) {
93         require(_value == 0 || allowance[msg.sender][_spender] == 0);
94         allowance[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96         return true;
97     }
98 
99     function stop() isOwner {
100         stopped = true;
101     }
102 
103     function start() isOwner {
104         stopped = false;
105     }
106 
107     function setName(string _name) isOwner {
108         name = _name;
109     }
110 
111     function burn(uint256 _value) {
112         require(balanceOf[msg.sender] >= _value);
113         balanceOf[msg.sender] -= _value;
114         balanceOf[0x0] += _value;
115         Transfer(msg.sender, 0x0, _value);
116     }
117 
118     event Transfer(address indexed _from, address indexed _to, uint256 _value);
119     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
120 }