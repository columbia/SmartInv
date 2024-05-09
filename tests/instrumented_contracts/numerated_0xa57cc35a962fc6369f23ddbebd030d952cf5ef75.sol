1 pragma solidity ^0.4.18;
2 contract Ownable {
3   address public owner;
4   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5   function Ownable() public {
6     owner = msg.sender;
7   }
8   modifier onlyOwner() {
9     require(msg.sender == owner);
10     _;
11   }
12   function transferOwnership(address newOwner) public onlyOwner {
13     require(newOwner != address(0));
14     OwnershipTransferred(owner, newOwner);
15     owner = newOwner;
16   }
17 }
18 contract Pausable is Ownable {
19   event Pause();
20   event Unpause();
21   bool public paused = false;
22   modifier whenNotPaused() {
23     require(!paused);
24     _;
25   }
26   modifier whenPaused() {
27     require(paused);
28     _;
29   }
30   function pause() onlyOwner whenNotPaused public {
31     paused = true;
32     Pause();
33   }
34   function unpause() onlyOwner whenPaused public {
35     paused = false;
36     Unpause();
37   }
38 }
39 library SafeMath {
40   function mul(uint a, uint b) internal pure returns (uint) {
41     if (a == 0) {
42       return 0;
43     }
44     uint c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48   function div(uint a, uint b) internal pure returns (uint) {
49     uint c = a / b;
50     return c;
51   }
52   function sub(uint a, uint b) internal pure returns (uint) {
53     assert(b <= a);
54     return a - b;
55   }
56   function add(uint a, uint b) internal pure returns (uint) {
57     uint c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 contract ERC20 {
63   string public name;
64   string public symbol;
65   uint8 public decimals;
66   uint public totalSupply;  
67   function ERC20(string _name, string _symbol, uint8 _decimals) public {
68     name = _name;
69     symbol = _symbol;
70     decimals = _decimals;
71   }
72   function balanceOf(address who) public view returns (uint);
73   function transfer(address to, uint value) public returns (bool);
74   function allowance(address owner, address spender) public view returns (uint);
75   function transferFrom(address from, address to, uint value) public returns (bool);
76   function approve(address spender, uint value) public returns (bool);
77   event Transfer(address indexed from, address indexed to, uint value);
78   event Approval(address indexed owner, address indexed spender, uint value);
79 }
80 contract Token is Pausable, ERC20 {
81   using SafeMath for uint;
82   mapping(address => uint) balances;
83   mapping (address => mapping (address => uint)) internal allowed;
84   mapping(address => uint) public balanceOfLocked;
85   mapping(address => bool) public addressLocked;
86   uint public unlocktime;
87   bool manualUnlock;
88   address public crowdsaleAddress = 0;
89   function Token() ERC20("ALexchange", "ALEX", 18) public {
90     manualUnlock = false;
91     unlocktime = 1527868800;
92     totalSupply = 10000000000 * 10 ** uint(decimals);
93     balances[msg.sender] = totalSupply;
94   }
95   function allowCrowdsaleAddress(address crowdsale) onlyOwner public {
96     crowdsaleAddress = crowdsale;
97   }
98   function isLocked() view public returns (bool) {
99     return (now < unlocktime && !manualUnlock);
100   }
101   modifier lockCheck(address from, uint value) { 
102     require(addressLocked[from] == false);
103     if (isLocked()) {
104       require(value <= balances[from] - balanceOfLocked[from]);
105     } else {
106       balanceOfLocked[from] = 0; 
107     }
108     _;
109   }
110   function lockAddress(address addr) onlyOwner public {
111     addressLocked[addr] = true;
112   }
113   function unlockAddress(address addr) onlyOwner public {
114     addressLocked[addr] = false;
115   }
116   function unlock() onlyOwner public {
117     require(!manualUnlock);
118     manualUnlock = true;
119   }
120   function transfer(address _to, uint _value) lockCheck(msg.sender, _value) whenNotPaused public returns (bool) {
121     require(_to != address(0));
122     require(_value <= balances[msg.sender]);
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     Transfer(msg.sender, _to, _value);
126     return true;
127   }
128   function transferLockedPart(address _to, uint _value) whenNotPaused public returns (bool) {
129     require(msg.sender == crowdsaleAddress);
130     if (transfer(_to, _value)) {
131       balanceOfLocked[_to] = balanceOfLocked[_to].add(_value);
132       return true;
133     }
134   }
135   function balanceOf(address _owner) public view returns (uint balance) {
136     return balances[_owner];
137   }
138   function transferFrom(address _from, address _to, uint _value) public lockCheck(_from, _value) whenNotPaused returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[_from]);
141     require(_value <= allowed[_from][msg.sender]);
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148   function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153   function allowance(address _owner, address _spender) public view returns (uint) {
154     return allowed[_owner][_spender];
155   }
156   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
157     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
162     uint oldValue = allowed[msg.sender][_spender];
163     if (_subtractedValue > oldValue) {
164       allowed[msg.sender][_spender] = 0;
165     } else {
166       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 }