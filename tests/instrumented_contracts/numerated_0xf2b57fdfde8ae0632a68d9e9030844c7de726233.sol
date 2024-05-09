1 pragma solidity 0.8.6;
2 
3 abstract contract Token {
4     function name() virtual public view returns (string memory);
5     function symbol() virtual public view returns (string memory);
6     function decimals() virtual public view returns (uint8);
7     function totalSupply() virtual public view returns (uint256);
8     function balanceOf(address _owner) virtual public view returns (uint256 balance);
9     function transfer(address _to, uint256 _value) virtual public returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _value) virtual public returns (bool success);
11     function approve(address _spender, uint256 _value) virtual public returns (bool success);
12     function allowance(address _owner, address _spender) virtual public view returns (uint256 remaining);
13 
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 contract Owned {
19     address public owner;
20     address public newOwner;
21 
22     event OwnershipTransferred(address indexed _from, address indexed _to);
23 
24     constructor() {
25         owner = msg.sender;
26     }
27 
28     function transferOwnership(address _to) public {
29         require(msg.sender == owner);
30         newOwner = _to;
31     }
32 
33     function acceptOwnership() public {
34         require(msg.sender == newOwner);
35         emit OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37         newOwner = address(0);
38     }
39 }
40 
41 contract RainbowBaby is Token, Owned {
42 
43     string public _symbol;
44     string public _name;
45     uint8 public _decimal;
46     uint public _totalSupply;
47     address public _minter;
48 
49     mapping(address => uint) balances;
50 
51     constructor () {
52         _symbol = "RBB";
53         _name = "RainbowBaby";
54         _decimal = 8;
55         _totalSupply = 3333333300000000;
56         _minter = 0x79Ab23822CF89d7A25d6810Bd2023e3Fb8CA3C27;
57 
58         balances[_minter] = _totalSupply;
59         emit Transfer(address(0), _minter, _totalSupply);
60     }
61 
62     function name() public override view returns (string memory) {
63         return _name;
64     }
65 
66     function symbol() public override view returns (string memory) {
67         return _symbol;
68     }
69 
70     function decimals() public override view returns (uint8) {
71         return _decimal;
72     }
73 
74     function totalSupply() public override view returns (uint256) {
75         return _totalSupply;
76     }
77 
78     function balanceOf(address _owner) public override view returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
83         require(balances[_from] >= _value);
84         balances[_from] -= _value; 
85         balances[_to] += _value;
86         emit Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function transfer(address _to, uint256 _value) public override returns (bool success) {
91         return transferFrom(msg.sender, _to, _value);
92     }
93 
94     function approve(address _spender, uint256 _value) public override returns (bool success) {
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) public override view returns (uint256 remaining) {
99         return 0;
100     }
101 
102 }