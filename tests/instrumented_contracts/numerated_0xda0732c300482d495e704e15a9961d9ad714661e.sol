1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a / b;
11     return c;
12   }
13   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
14     assert(b <= a);
15     return a - b;
16   }
17   function add(uint256 a, uint256 b) internal constant returns (uint256) {
18     uint256 c = a + b;
19     assert(c >= a);
20     return c;
21   }
22 }
23 
24 contract ERC20Basic {
25   uint256 public totalSupply;
26   function balanceOf(address who) public constant returns (uint256);
27   function transfer(address to, uint256 value) public returns (bool);
28   event Transfer(address indexed from, address indexed to, uint256 value);
29 }
30 
31 contract BasicToken is ERC20Basic {
32   using SafeMath for uint256;
33   mapping(address => uint256) balances;
34   function transfer(address _to, uint256 _value) public returns (bool) {
35     require(_to != address(0));
36     require(_value > 0 && _value <= balances[msg.sender]);
37     balances[msg.sender] = balances[msg.sender].sub(_value);
38     balances[_to] = balances[_to].add(_value);
39     Transfer(msg.sender, _to, _value);
40     return true;
41   }
42   function balanceOf(address _owner) public constant returns (uint256 balance) {
43     return balances[_owner];
44   }
45 }
46 
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) public constant returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address spender, uint256 value) public returns (bool);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract StandardToken is ERC20, BasicToken {
55   mapping (address => mapping (address => uint256)) internal allowed;
56   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
57     require(_to != address(0));
58     require(_value > 0 && _value <= balances[_from]);
59     require(_value <= allowed[_from][msg.sender]);
60     balances[_from] = balances[_from].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
63     Transfer(_from, _to, _value);
64     return true;
65   }
66   function approve(address _spender, uint256 _value) public returns (bool) {
67     allowed[msg.sender][_spender] = _value;
68     Approval(msg.sender, _spender, _value);
69     return true;
70   }
71   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
72     return allowed[_owner][_spender];
73   }
74 }
75 
76 contract Ownable {
77   address public owner;
78   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79   function Ownable() {
80     owner = msg.sender;
81   }
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86   function transferOwnership(address newOwner) onlyOwner public {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 }
92 
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96   bool public paused = false;
97   modifier whenNotPaused() {
98     require(!paused);
99     _;
100   }
101   modifier whenPaused() {
102     require(paused);
103     _;
104   }
105   function pause() onlyOwner whenNotPaused public {
106     paused = true;
107     Pause();
108   }
109   function unpause() onlyOwner whenPaused public {
110     paused = false;
111     Unpause();
112   }
113 }
114 
115 contract PausableToken is StandardToken, Pausable {
116   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
117     return super.transfer(_to, _value);
118   }
119   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
120     return super.transferFrom(_from, _to, _value);
121   }
122   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
123     return super.approve(_spender, _value);
124   }
125 }
126 
127 contract HiBTCToken is PausableToken {
128     string public name = "HiBTCToken";
129     string public symbol = "HIBT";
130     string public version = '1.0.0';
131     uint8 public decimals = 18;
132 
133     function HiBTCToken() {
134       totalSupply = 10000000000 * (10**(uint256(decimals)));
135       balances[msg.sender] = totalSupply;
136     }
137 
138     function () {
139         revert();
140     }
141 }