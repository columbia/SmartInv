1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint256 a, uint256 b) internal constant returns (uint256) {
10     
11     uint256 c = a / b;
12     
13     return c;
14   }
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 }
25 
26 
27 
28 contract ERC20Basic {
29   uint256 public totalSupply;
30   function balanceOf(address who) public constant returns (uint256);
31   function transfer(address to, uint256 value) public returns (bool);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 
35 contract BasicToken is ERC20Basic {
36   using SafeMath for uint256;
37   mapping(address => uint256) balances;
38 
39   function transfer(address _to, uint256 _value) public returns (bool) {
40     require(_to != address(0));
41     require(_value > 0 && _value <= balances[msg.sender]);
42     
43     balances[msg.sender] = balances[msg.sender].sub(_value);
44     balances[_to] = balances[_to].add(_value);
45     Transfer(msg.sender, _to, _value);
46     return true;
47   }
48   
49   function balanceOf(address _owner) public constant returns (uint256 balance) {
50     return balances[_owner];
51   }
52 }
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 contract StandardToken is ERC20, BasicToken {
62   mapping (address => mapping (address => uint256)) internal allowed;
63   
64   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value > 0 && _value <= balances[_from]);
67     require(_value <= allowed[_from][msg.sender]);
68     balances[_from] = balances[_from].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
71     Transfer(_from, _to, _value);
72     return true;
73   }
74   
75   function approve(address _spender, uint256 _value) public returns (bool) {
76     allowed[msg.sender][_spender] = _value;
77     Approval(msg.sender, _spender, _value);
78     return true;
79   }
80   
81   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
82     return allowed[_owner][_spender];
83   }
84 }
85 
86 contract Ownable {
87   address public owner;
88   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89  
90   function Ownable() {
91     owner = msg.sender;
92   }
93   
94   modifier onlyOwner() {
95     require(msg.sender == owner);
96     _;
97   }
98   
99   function transferOwnership(address newOwner) onlyOwner public {
100     require(newOwner != address(0));
101     OwnershipTransferred(owner, newOwner);
102     owner = newOwner;
103   }
104 }
105 contract Pausable is Ownable {
106   event Pause();
107   event Unpause();
108   bool public paused = false;
109  
110   modifier whenNotPaused() {
111     require(!paused);
112     _;
113   }
114   
115   modifier whenPaused() {
116     require(paused);
117     _;
118   }
119  
120   function pause() onlyOwner whenNotPaused public {
121     paused = true;
122     Pause();
123   }
124   
125   function unpause() onlyOwner whenPaused public {
126     paused = false;
127     Unpause();
128   }
129 }
130 
131 contract PausableToken is StandardToken, Pausable {
132   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
133     return super.transfer(_to, _value);
134   }
135   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
136     return super.transferFrom(_from, _to, _value);
137   }
138   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
139     return super.approve(_spender, _value);
140   }
141 }
142 
143 
144 contract AiToken is PausableToken {
145 
146     string public name = 'AiToken';
147     string public symbol = 'AiToken';
148     string public version = '1.0.1';
149     uint8 public decimals = 18;
150     
151     
152     function AiToken(uint256 initialSupply) public {
153         totalSupply = initialSupply * 10 ** uint256(decimals);
154         balances[msg.sender] = totalSupply;
155 
156     }
157     
158     function () {
159         //if ether is sent to this address, send it back.
160         revert();
161     }
162 }