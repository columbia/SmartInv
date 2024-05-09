1 pragma solidity 0.4.24;
2 
3 contract Owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 }
15 
16 contract Stopped is Owned {
17 
18     bool public stopped = true;
19 
20     modifier noStopped {
21         require(!stopped);
22         _;
23     }
24 
25     function start() onlyOwner public {
26       stopped = false;
27     }
28 
29     function stop() onlyOwner public {
30       stopped = true;
31     }
32 
33 }
34 
35 contract MathTCT {
36 
37     function add(uint256 x, uint256 y) pure internal returns(uint256 z) {
38       assert((z = x + y) >= x);
39     }
40 
41     function sub(uint256 x, uint256 y) pure internal returns(uint256 z) {
42       assert((z = x - y) <= x);
43     }
44 }
45 
46 contract TokenERC20 {
47 
48     function totalSupply() view public returns (uint256 supply);
49     function balanceOf(address who) view public returns (uint256 value);
50     function transfer(address to, uint256 value) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54 }
55 
56 contract TCT is Owned, Stopped, MathTCT, TokenERC20 {
57 
58     string public name;
59     string public symbol;
60     uint8 public decimals = 18;
61     uint256 public totalSupply;
62 
63     mapping (address => uint256) public balanceOf;
64     mapping (address => bool) public frozenAccount;
65 
66     event FrozenFunds(address target, bool frozen);
67     event Burn(address from, uint256 value);
68 
69     constructor(string _name, string _symbol) public {
70         totalSupply = 200000000 * 10 ** uint256(decimals);
71         balanceOf[msg.sender] = totalSupply;
72         name = _name;
73         symbol = _symbol;
74     }
75 
76     function totalSupply() view public returns (uint256 supply) {
77         return totalSupply;
78     }
79 
80     function balanceOf(address who) view public returns (uint256 value) {
81         return balanceOf[who];
82     }
83 
84     function _transfer(address _from, address _to, uint256 _value) internal {
85         require (_to != 0x0);
86         require (balanceOf[_from] >= _value);
87         require(!frozenAccount[_from]);
88         require(!frozenAccount[_to]);
89         balanceOf[_from] = sub(balanceOf[_from], _value);
90         balanceOf[_to] = add(balanceOf[_to], _value);
91         emit Transfer(_from, _to, _value);
92     }
93 
94     function transfer(address _to, uint256 _value) noStopped public returns (bool success) {
95         _transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     function freezeAccount(address target, bool freeze) noStopped onlyOwner public returns (bool success) {
100         frozenAccount[target] = freeze;
101         emit FrozenFunds(target, freeze);
102         return true;
103     }
104 
105     function burn(uint256 _value) noStopped onlyOwner public returns (bool success) {
106         require(!frozenAccount[msg.sender]);
107         require(balanceOf[msg.sender] >= _value);
108         balanceOf[msg.sender] = sub(balanceOf[msg.sender], _value);
109         totalSupply = sub(totalSupply, _value);
110         emit Burn(msg.sender, _value);
111         return true;
112     }
113 
114 }