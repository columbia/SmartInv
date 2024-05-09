1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   function Ownable() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     require(newOwner != address(0));
19     OwnershipTransferred(owner, newOwner);
20     owner = newOwner;
21   }
22 }
23 
24 contract Pausable is Ownable {
25   event Pause();
26   event Unpause();
27 
28   bool public paused = false;
29 
30   modifier whenNotPaused() {
31     require(!paused);
32     _;
33   }
34 
35   modifier whenPaused() {
36     require(paused);
37     _;
38   }
39 
40   function pause() onlyOwner whenNotPaused public {
41     paused = true;
42     Pause();
43   }
44 
45   function unpause() onlyOwner whenPaused public {
46     paused = false;
47     Unpause();
48   }
49 }
50 
51 library SafeMath {
52   function mul(uint a, uint b) internal pure returns (uint) {
53     if (a == 0) {
54       return 0;
55     }
56     uint c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   function div(uint a, uint b) internal pure returns (uint) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     uint c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return c;
66   }
67 
68   function sub(uint a, uint b) internal pure returns (uint) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   function add(uint a, uint b) internal pure returns (uint) {
74     uint c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 contract ERC20 {
81   string public name;
82   string public symbol;
83   uint8 public decimals;
84   uint public totalSupply;  
85   function ERC20(string _name, string _symbol, uint8 _decimals) public {
86     name = _name;
87     symbol = _symbol;
88     decimals = _decimals;
89   }
90   function balanceOf(address who) public view returns (uint);
91   function transfer(address to, uint value) public returns (bool);
92   function allowance(address owner, address spender) public view returns (uint);
93   function transferFrom(address from, address to, uint value) public returns (bool);
94   function approve(address spender, uint value) public returns (bool);
95   event Transfer(address indexed from, address indexed to, uint value);
96   event Approval(address indexed owner, address indexed spender, uint value);
97 }
98 
99 
100 contract Token is Pausable, ERC20 {
101   using SafeMath for uint;
102 
103   mapping(address => uint) balances;
104   mapping (address => mapping (address => uint)) internal allowed;
105 
106   function Token() ERC20("DATx", "DATx", 18) public {
107     totalSupply = 10000000000 * 10 ** uint(decimals);  // Update total supply with the decimal amount
108     balances[msg.sender] = totalSupply;                   // Give the creator all initial tokens
109   }
110 
111   function transfer(address _to, uint _value) whenNotPaused public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[msg.sender]);
114 
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   function balanceOf(address _owner) public view returns (uint balance) {
122     return balances[_owner];
123   }
124 
125   function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   function allowance(address _owner, address _spender) public view returns (uint) {
144     return allowed[_owner][_spender];
145   }
146 
147   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
148     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
149     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150     return true;
151   }
152 
153   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
154     uint oldValue = allowed[msg.sender][_spender];
155     if (_subtractedValue > oldValue) {
156       allowed[msg.sender][_spender] = 0;
157     } else {
158       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159     }
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 }