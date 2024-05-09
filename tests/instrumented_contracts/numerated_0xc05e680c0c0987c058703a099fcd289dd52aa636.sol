1 pragma solidity ^0.4.18;
2 
3 
4 contract owned {
5     address public owner;
6     address public candidate;
7 
8     function owned() payable internal {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(owner == msg.sender);
14         _;
15     }
16 
17     function changeOwner(address _owner) onlyOwner public {
18         candidate = _owner;
19     }
20 
21     function confirmOwner() public {
22         require(candidate != address(0));
23         require(candidate == msg.sender);
24         owner = candidate;
25         delete candidate;
26     }
27 }
28 
29 
30 library SafeMath {
31     function sub(uint256 a, uint256 b) pure internal returns (uint256) {
32         assert(a >= b);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) pure internal returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a && c >= b);
39         return c;
40     }
41 }
42 
43 
44 contract ERC20 {
45     uint256 public totalSupply;
46     function balanceOf(address who) public constant returns (uint256 value);
47     function allowance(address owner, address spender) public constant returns (uint256 _allowance);
48     function transfer(address to, uint256 value) public returns (bool success);
49     function transferFrom(address from, address to, uint256 value) public returns (bool success);
50     function approve(address spender, uint256 value) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 
57 contract DashBlack is ERC20, owned {
58     using SafeMath for uint256;
59     string public name = "DashBlack";
60     string public symbol = "DASHB";
61     uint8 public decimals = 18;
62     uint256 public totalSupply;
63 
64     mapping (address => uint256) private balances;
65     mapping (address => mapping (address => uint256)) private allowed;
66 
67     function balanceOf(address _who) public constant returns (uint256) {
68         return balances[_who];
69     }
70 
71     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
72         return allowed[_owner][_spender];
73     }
74 
75     function DashBlack() public {
76         totalSupply = 18900000 * 1 ether;
77         balances[msg.sender] = totalSupply;
78         Transfer(0, msg.sender, totalSupply);
79     }
80 
81     function transfer(address _to, uint256 _value) public returns (bool success) {
82         require(_to != address(0));
83         require(balances[msg.sender] >= _value);
84         balances[msg.sender] = balances[msg.sender].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         Transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(_to != address(0));
92         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
93         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94         balances[_from] = balances[_from].sub(_value);
95         balances[_to] = balances[_to].add(_value);
96         Transfer(_from, _to, _value);
97         return true;
98     }
99 
100     function approve(address _spender, uint256 _value) public returns (bool success) {
101         require(_spender != address(0));
102         require(balances[msg.sender] >= _value);
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     function withdrawTokens(uint256 _value) public onlyOwner {
109         require(balances[this] >= _value);
110         balances[this] = balances[this].sub(_value);
111         balances[msg.sender] = balances[msg.sender].add(_value);
112         Transfer(this, msg.sender, _value);
113     }
114 }