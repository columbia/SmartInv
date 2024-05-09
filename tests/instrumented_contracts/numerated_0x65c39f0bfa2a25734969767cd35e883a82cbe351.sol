1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Ownable {
28   address public owner;
29   function Ownable() {
30     owner = msg.sender;
31   }
32 
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   function transferOwnership(address newOwner) onlyOwner {
39     if (newOwner != address(0)) {
40       owner = newOwner;
41     }
42   }
43 
44 }
45 
46 contract ERC20Basic {
47   uint256 public totalSupply;
48   function balanceOf(address who) constant returns (uint256);
49   function transfer(address to, uint256 value) returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 contract BasicToken is ERC20Basic {
54   using SafeMath for uint256;
55 
56   mapping(address => uint256) balances;
57   
58   function transfer(address _to, uint256 _value) returns (bool) {
59     balances[msg.sender] = balances[msg.sender].sub(_value);
60     balances[_to] = balances[_to].add(_value);
61     Transfer(msg.sender, _to, _value);
62     return true;
63   }
64 
65   function balanceOf(address _owner) constant returns (uint256 balance) {
66     return balances[_owner];
67   }
68 
69 }
70 
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) constant returns (uint256);
73   function transferFrom(address from, address to, uint256 value) returns (bool);
74   function approve(address spender, uint256 value) returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 contract StandardToken is ERC20, BasicToken {
79 
80   mapping (address => mapping (address => uint256)) allowed;
81 
82   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
83     var _allowance = allowed[_from][msg.sender];
84 
85     balances[_to] = balances[_to].add(_value);
86     balances[_from] = balances[_from].sub(_value);
87     allowed[_from][msg.sender] = _allowance.sub(_value);
88     Transfer(_from, _to, _value);
89     return true;
90   }
91 
92   function approve(address _spender, uint256 _value) returns (bool) {
93 
94     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
95 
96     allowed[msg.sender][_spender] = _value;
97     Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
102     return allowed[_owner][_spender];
103   }
104 
105 }
106 
107 contract MintableToken is StandardToken, Ownable {
108   event Mint(address indexed to, uint256 amount);
109   event MintFinished();
110 
111   bool public mintingFinished = false;
112 
113 
114   modifier canMint() {
115     require(!mintingFinished);
116     _;
117   }
118 
119   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
120     totalSupply = totalSupply.add(_amount);
121     balances[_to] = balances[_to].add(_amount);
122     Mint(_to, _amount);
123     return true;
124   }
125 
126   function finishMinting() onlyOwner returns (bool) {
127     mintingFinished = true;
128     MintFinished();
129     return true;
130   }
131 }
132 
133 contract DemoTokenMintable is MintableToken {
134 
135         string public name = "BiCode";
136         string public symbol = "CODE";
137         uint256 public decimals = 8;
138 
139 }