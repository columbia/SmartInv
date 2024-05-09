1 pragma solidity ^0.4.15;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6     
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11 
12     function Owned() public {
13         owner = msg.sender;
14     }
15 
16     function transferOwnership(address _newOwner) onlyOwner public {
17         newOwner = _newOwner;
18     }
19 
20     function acceptOwnership() onlyOwner public {
21         OwnershipTransferred(owner, newOwner);
22         owner = newOwner;
23     }
24 
25     event OwnershipTransferred(address indexed _from, address indexed _to);
26 }
27 
28 
29 library SafeMath {
30     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
31         uint256 c = a * b;
32         assert(a == 0 || c / a == b);
33         return c;
34     }
35 
36     function div(uint256 a, uint256 b) internal constant returns (uint256) {
37         // assert(b > 0); // Solidity automatically throws when dividing by 0
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47 
48     function add(uint256 a, uint256 b) internal constant returns (uint256) {
49         uint256 c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 contract ERC20 {
56     uint256 public totalSupply;
57   
58     function balanceOf(address who) public constant returns (uint256);
59     function transfer(address to, uint256 value) public returns (bool);
60     function allowance(address owner, address spender) public constant returns (uint256);
61     function transferFrom(address from, address to, uint256 value) public returns (bool);
62     function approve(address spender, uint256 value) public returns (bool);
63   
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract StandartToken is ERC20 {
69     using SafeMath for uint256;
70 
71     mapping(address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowed;
73     
74     bool public isStarted = false;
75     
76     modifier isStartedOnly() {
77         require(isStarted);
78         _;
79     }
80 
81     function transfer(address _to, uint256 _value) isStartedOnly public returns (bool) {
82         require(_to != address(0));
83         require(_value <= balances[msg.sender]);
84 
85         // SafeMath.sub will throw if there is not enough balance.
86         balances[msg.sender] = balances[msg.sender].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         Transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92     function balanceOf(address _owner) public constant returns (uint256 balance) {
93         return balances[_owner];
94     }
95   
96     function transferFrom(address _from, address _to, uint256 _value) isStartedOnly public returns (bool) {
97         require(_to != address(0));
98         require(_value <= balances[_from]);
99         require(_value <= allowed[_from][msg.sender]);
100 
101         balances[_from] = balances[_from].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
104         Transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function approve(address _spender, uint256 _value) isStartedOnly public returns (bool) {
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
115         return allowed[_owner][_spender];
116     }
117 
118     function increaseApproval (address _spender, uint _addedValue) isStartedOnly public returns (bool success) {
119         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
120         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121         return true;
122     }
123 
124     function decreaseApproval (address _spender, uint _subtractedValue) isStartedOnly public returns (bool success) {
125         uint oldValue = allowed[msg.sender][_spender];
126         if (_subtractedValue > oldValue) {
127             allowed[msg.sender][_spender] = 0;
128         } else {
129             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
130         }
131         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132         return true;
133     }
134 }
135 
136 
137 
138 contract Token is Owned, StandartToken {
139     string public name = "Neurogress";
140     string public symbol = "NRG";
141     uint public decimals = 18;
142 
143     address public crowdsaleMinter;
144 
145     event Mint(address indexed to, uint256 amount);
146 
147     modifier canMint() {
148         require(!isStarted);
149         _;
150     }
151 
152     modifier onlyCrowdsaleMinter(){
153         require(msg.sender == crowdsaleMinter);
154         _;
155     }
156 
157     function () public {
158         revert();
159     }
160 
161     function setCrowdsaleMinter(address _crowdsaleMinter)
162         public
163         onlyOwner
164         canMint
165     {
166         crowdsaleMinter = _crowdsaleMinter;
167     }
168 
169     function mint(address _to, uint256 _amount)
170         onlyCrowdsaleMinter
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
182         onlyCrowdsaleMinter
183         canMint
184         public
185         returns (bool)
186     {
187         isStarted = true;
188         return true;
189     }
190 }