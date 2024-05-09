1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Base {
30     modifier only(address allowed) {
31         require(msg.sender == allowed);
32         _;
33     }
34 
35     // *************************************************
36     // *          reentrancy handling                  *
37     // *************************************************
38 
39     uint constant internal L00 = 2 ** 0;
40     uint constant internal L01 = 2 ** 1;
41     uint constant internal L02 = 2 ** 2;
42     uint constant internal L03 = 2 ** 3;
43     uint constant internal L04 = 2 ** 4;
44     uint constant internal L05 = 2 ** 5;
45 
46     uint private bitlocks = 0;
47 
48     modifier noAnyReentrancy {
49         var _locks = bitlocks;
50         require(_locks == 0);
51         bitlocks = uint(-1);
52         _;
53         bitlocks = _locks;
54     }
55 
56 }
57 
58 contract Owned {
59     address public owner;
60     address public newOwner;
61     
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function Owned() public {
68         owner = msg.sender;
69     }
70 
71     function transferOwnership(address _newOwner) onlyOwner public {
72         newOwner = _newOwner;
73     }
74 
75     function acceptOwnership() onlyOwner public {
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78     }
79 
80     event OwnershipTransferred(address indexed _from, address indexed _to);
81 }
82 
83 contract ERC20 {
84     uint256 public totalSupply;
85   
86     function balanceOf(address who) public constant returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     function allowance(address owner, address spender) public constant returns (uint256);
89     function transferFrom(address from, address to, uint256 value) public returns (bool);
90     function approve(address spender, uint256 value) public returns (bool);
91   
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 contract StandartToken is ERC20 {
97     using SafeMath for uint256;
98 
99     mapping(address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101     
102     bool public isStarted = false;
103     
104     modifier isStartedOnly() {
105         require(isStarted);
106         _;
107     }
108 
109     function transfer(address _to, uint256 _value) isStartedOnly public returns (bool) {
110         require(_to != address(0));
111         require(_value <= balances[msg.sender]);
112 
113         // SafeMath.sub will throw if there is not enough balance.
114         balances[msg.sender] = balances[msg.sender].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         Transfer(msg.sender, _to, _value);
117         return true;
118     }
119 
120     function balanceOf(address _owner) public constant returns (uint256 balance) {
121         return balances[_owner];
122     }
123   
124     function transferFrom(address _from, address _to, uint256 _value) isStartedOnly public returns (bool) {
125         require(_to != address(0));
126         require(_value <= balances[_from]);
127         require(_value <= allowed[_from][msg.sender]);
128 
129         balances[_from] = balances[_from].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132         Transfer(_from, _to, _value);
133         return true;
134     }
135 
136     function approve(address _spender, uint256 _value) isStartedOnly public returns (bool) {
137         allowed[msg.sender][_spender] = _value;
138         Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
143         return allowed[_owner][_spender];
144     }
145 
146     function increaseApproval (address _spender, uint _addedValue) isStartedOnly public returns (bool success) {
147         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149         return true;
150     }
151 
152     function decreaseApproval (address _spender, uint _subtractedValue) isStartedOnly public returns (bool success) {
153         uint oldValue = allowed[msg.sender][_spender];
154         if (_subtractedValue > oldValue) {
155             allowed[msg.sender][_spender] = 0;
156         } else {
157             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
158         }
159         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162 }
163 
164 
165 contract AnonymToken is Owned, StandartToken {
166     string public name = "Anonym";
167     string public symbol = "ANM";
168     uint public decimals = 18;
169     
170     address public crowdsaleMinter;
171     
172     event Mint(address indexed to, uint256 amount);
173 
174     modifier canMint() {
175         require(!isStarted);
176         _;
177     }
178     
179     modifier onlyCrowdsaleMinter(){
180         require(msg.sender == crowdsaleMinter);
181         _;
182     }
183     
184     function () public {
185         revert();
186     }
187     
188     function setCrowdsaleMinter(address _crowdsaleMinter)
189         public
190         onlyOwner
191         canMint
192     {
193         crowdsaleMinter = _crowdsaleMinter;
194     }
195 
196     function mint(address _to, uint256 _amount)
197         onlyCrowdsaleMinter
198         canMint
199         public
200         returns (bool)
201     {
202         totalSupply = totalSupply.add(_amount);
203         balances[_to] = balances[_to].add(_amount);
204         Mint(_to, _amount);
205         return true;
206     }
207 
208     function start()
209         onlyCrowdsaleMinter
210         canMint
211         public
212         returns (bool)
213     {
214         isStarted = true;
215         return true;
216     }
217 }