1 pragma solidity ^0.4.15;
2 
3 
4 contract Owned {
5     address public owner;
6     address public newOwner;
7     
8     modifier onlyOwner() {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     function Owned() public {
14         owner = msg.sender;
15     }
16 
17     function transferOwnership(address _newOwner) onlyOwner public {
18         newOwner = _newOwner;
19     }
20 
21     function acceptOwnership() onlyOwner public {
22         OwnershipTransferred(owner, newOwner);
23         owner = newOwner;
24     }
25 
26     event OwnershipTransferred(address indexed _from, address indexed _to);
27 }
28 
29 contract ERC20 {
30     uint256 public totalSupply;
31   
32     function balanceOf(address who) public constant returns (uint256);
33     function transfer(address to, uint256 value) public returns (bool);
34     function allowance(address owner, address spender) public constant returns (uint256);
35     function transferFrom(address from, address to, uint256 value) public returns (bool);
36     function approve(address spender, uint256 value) public returns (bool);
37   
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract StandartToken is ERC20 {
43     using SafeMath for uint256;
44 
45     mapping(address => uint256) balances;
46     mapping (address => mapping (address => uint256)) allowed;
47     
48     bool public isStarted = false;
49     
50     modifier isStartedOnly() {
51         require(isStarted);
52         _;
53     }
54 
55     function transfer(address _to, uint256 _value) isStartedOnly public returns (bool) {
56         require(_to != address(0));
57         require(_value <= balances[msg.sender]);
58 
59         // SafeMath.sub will throw if there is not enough balance.
60         balances[msg.sender] = balances[msg.sender].sub(_value);
61         balances[_to] = balances[_to].add(_value);
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function balanceOf(address _owner) public constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69   
70     function transferFrom(address _from, address _to, uint256 _value) isStartedOnly public returns (bool) {
71         require(_to != address(0));
72         require(_value <= balances[_from]);
73         require(_value <= allowed[_from][msg.sender]);
74 
75         balances[_from] = balances[_from].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78         Transfer(_from, _to, _value);
79         return true;
80     }
81 
82     function approve(address _spender, uint256 _value) isStartedOnly public returns (bool) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
89         return allowed[_owner][_spender];
90     }
91 
92     function increaseApproval (address _spender, uint _addedValue) isStartedOnly public returns (bool success) {
93         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
94         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
95         return true;
96     }
97 
98     function decreaseApproval (address _spender, uint _subtractedValue) isStartedOnly public returns (bool success) {
99         uint oldValue = allowed[msg.sender][_spender];
100         if (_subtractedValue > oldValue) {
101             allowed[msg.sender][_spender] = 0;
102         } else {
103             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
104         }
105         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106         return true;
107     }
108 }
109 
110 library SafeMath {
111     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
112         uint256 c = a * b;
113         assert(a == 0 || c / a == b);
114         return c;
115     }
116 
117     function div(uint256 a, uint256 b) internal constant returns (uint256) {
118         // assert(b > 0); // Solidity automatically throws when dividing by 0
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121         return c;
122     }
123 
124     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
125         assert(b <= a);
126         return a - b;
127     }
128 
129     function add(uint256 a, uint256 b) internal constant returns (uint256) {
130         uint256 c = a + b;
131         assert(c >= a);
132         return c;
133     }
134 }
135 
136 
137 
138 contract ENDOToken is Owned, StandartToken {
139     string public name = "ENDO Token";
140     string public symbol = "EDT";
141     uint public decimals = 18;
142 
143     address public distributionMinter;
144 
145     event Mint(address indexed to, uint256 amount);
146 
147     modifier canMint() {
148         require(!isStarted);
149         _;
150     }
151 
152     modifier onlyDistributionMinter(){
153         require(msg.sender == distributionMinter);
154         _;
155     }
156 
157     function () public {
158         revert();
159     }
160 
161     function setDistributionMinter(address _distributionMinter)
162         public
163         onlyOwner
164         canMint
165     {
166         distributionMinter = _distributionMinter;
167     }
168 
169     function mint(address _to, uint256 _amount)
170         onlyDistributionMinter
171         canMint
172         public
173         returns (bool)
174     {
175         totalSupply = totalSupply.add(_amount);
176         balances[_to] = balances[_to].add(_amount);
177         Mint(_to, _amount);
178         return true;
179     }
180 
181     function start()
182         onlyDistributionMinter
183         canMint
184         public
185         returns (bool)
186     {
187         isStarted = true;
188         return true;
189     }
190 }