1 pragma solidity ^0.4.2;
2 
3 // Safe maths
4 library SafeMath {
5   function add(uint a, uint b) internal pure returns (uint c) {
6     c = a + b;
7     require(c >= a);
8   }
9   function sub(uint a, uint b) internal pure returns (uint c) {
10     require(b <= a);
11     c = a - b;
12   }
13   function mul(uint a, uint b) internal pure returns (uint c) {
14     c = a * b;
15     require(a == 0 || c / a == b);
16   }
17   function div(uint a, uint b) internal pure returns (uint c) {
18     require(b > 0);
19     c = a / b;
20   }
21 }
22 
23 contract ApproveAndCallFallBack {
24   function receiveApproval(address _from, uint256 _value, address _token, bytes _data) public;
25 }
26 
27 // Owned contract
28 contract Ownable {
29   address public owner;
30 
31   function Ownable() public {
32     owner = msg.sender;
33   }
34 
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     owner = newOwner;
43   }
44 }
45 
46 // ERC Token Standard #20 Interface
47 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
48 contract ERC20Interface {
49   function totalSupply() public constant returns (uint _supply);
50   function balanceOf(address _owner) public constant returns (uint balance);
51   function allowance(address _owner, address _spender) public constant returns (uint remaining);
52   function transfer(address _to, uint _value) public returns (bool success);
53   function approve(address _spender, uint _value) public returns (bool success);
54   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
55 
56   event Transfer(address indexed _from, address indexed _to, uint _value);
57   event Approval(address indexed _owner, address indexed _spender, uint _value);
58 }
59 
60 contract VHW is Ownable, ERC20Interface {
61   using SafeMath for uint;
62 
63   uint public _totalSupply = 352500000000000;
64   string public constant name = "VHW";
65   string public constant symbol = "VHW";
66   uint public constant decimals = 6;
67   string public standard = "VHW Token";
68 
69   mapping (address => uint) balances;
70   mapping (address => mapping (address => uint)) allowances;
71 
72   event Burn(address indexed _from, uint _value);
73 
74   // Constructor
75   function VHW() public {
76     balances[owner] = _totalSupply;
77     emit Transfer(address(0), owner, _totalSupply);
78   }
79 
80   // Total supply
81   function totalSupply() public constant returns (uint _supply) {
82     return _totalSupply;
83   }
84 
85   // Get the token balance of address
86   function balanceOf(address _owner) public constant returns (uint balance) {
87     return balances[_owner];
88   }
89 
90   // Transfer tokens from owner address
91   function transfer(address _to, uint _value) public returns (bool success) {
92     require(_to != 0x0);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   function approve(address _spender, uint _value) public returns(bool success) {
101     allowances[msg.sender][_spender] = _value;
102     emit Approval(msg.sender, _spender, _value);
103     return true;
104   }
105 
106   function approveAndCall(address _spender, uint _value, bytes _data) public returns (bool success) {
107     approve(_spender, _value);
108     emit Approval(msg.sender, _spender, _value);
109     ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, _data);
110     return true;
111   }
112 
113   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
114     balances[_from] = balances[_from].sub(_value);
115     allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     emit Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
122     return allowances[_owner][_spender];
123   }
124 
125   function burnTokens(uint _amount) public onlyOwner {
126     _totalSupply = _totalSupply.sub(_amount);
127     balances[msg.sender] = balances[msg.sender].sub(_amount);
128     emit Burn(msg.sender, _amount);
129     emit Transfer(msg.sender, 0x0, _amount);
130   }
131 }