1 pragma solidity 0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     function Ownable() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) onlyOwner public {
41         require(newOwner != address(0));
42         OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 contract ERC20 {
48     uint256 public totalSupply;
49     function balanceOf(address who) public view returns (uint256);
50     function transfer(address to, uint256 value) public returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     function allowance(address owner, address spender) public view returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract Pausable is Ownable {
60     event Paused();
61     event Unpaused();
62 
63     bool public pause = false;
64 
65     modifier whenNotPaused() {
66         require(!pause);
67         _;
68     }
69 
70     modifier whenPaused() {
71         require(pause);
72         _;
73     }
74 
75     function pause() onlyOwner whenNotPaused public {
76         pause = true;
77         Paused();
78     }
79 
80     function unpause() onlyOwner whenPaused public {
81         pause = false;
82         Unpaused();
83     }
84 }
85 
86 contract StandardToken is ERC20, Pausable {
87     using SafeMath for uint256;
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91 
92     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
93         require(_to != address(0));
94         require(_value > 0);
95 
96         balances[msg.sender] = balances[msg.sender].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         Transfer(msg.sender, _to, _value);
99         return true;
100     }
101 
102     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
103         require(_from != address(0));
104         require(_to != address(0));
105 
106         uint256 _allowance = allowed[_from][msg.sender];
107 
108         balances[_from] = balances[_from].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         allowed[_from][msg.sender] = _allowance.sub(_value);
111         Transfer(_from, _to, _value);
112         return true;
113     }
114 
115     function balanceOf(address _owner) public constant returns (uint256 balance) {
116         return balances[_owner];
117     }
118 
119     function approve(address _spender, uint256 _value) public returns (bool) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
126         return allowed[_owner][_spender];
127     }
128 }
129 
130 contract MpctToken is StandardToken {
131 
132     string public name = "MPCT Token";
133     string public symbol = "MPCT";
134     uint public decimals = 18;
135 
136     uint public constant TOTAL_SUPPLY    = 1000000000e18;
137     address public constant WALLET_MPCT   = 0x1552041794B876D782b3313715050f32aF9C55b7; 
138 
139     function MpctToken() public {
140         balances[msg.sender] = TOTAL_SUPPLY;
141         totalSupply = TOTAL_SUPPLY;
142     }
143 
144     function withdrawSelfToken() public {
145         if(balanceOf(this) > 0)
146             this.transfer(WALLET_MPCT, balanceOf(this));
147     }
148 
149     function close() public onlyOwner {
150         selfdestruct(owner);
151     }
152 }