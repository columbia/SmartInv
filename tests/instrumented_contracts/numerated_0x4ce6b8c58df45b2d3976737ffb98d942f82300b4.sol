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
58 contract Owned is Base {
59 
60     address public owner;
61     address newOwner;
62 
63     function Owned() {
64         owner = msg.sender;
65     }
66 
67     function transferOwnership(address _newOwner) only(owner) {
68         newOwner = _newOwner;
69     }
70 
71     function acceptOwnership() only(newOwner) {
72         OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74     }
75 
76     event OwnershipTransferred(address indexed _from, address indexed _to);
77 
78 }
79 
80 contract ERC20 is Owned {
81 
82     event Transfer(address indexed _from, address indexed _to, uint _value);
83     event Approval(address indexed _owner, address indexed _spender, uint _value);
84 
85     function transfer(address _to, uint _value) isStartedOnly returns (bool success) {
86         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
87             balances[msg.sender] -= _value;
88             balances[_to] += _value;
89             Transfer(msg.sender, _to, _value);
90             return true;
91         } else { return false; }
92     }
93 
94     function transferFrom(address _from, address _to, uint _value) isStartedOnly returns (bool success) {
95         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
96             balances[_to] += _value;
97             balances[_from] -= _value;
98             allowed[_from][msg.sender] -= _value;
99             Transfer(_from, _to, _value);
100             return true;
101         } else { return false; }
102     }
103 
104     function balanceOf(address _owner) constant returns (uint balance) {
105         return balances[_owner];
106     }
107 
108     function approve_fixed(address _spender, uint _currentValue, uint _value) isStartedOnly returns (bool success) {
109         if(allowed[msg.sender][_spender] == _currentValue){
110             allowed[msg.sender][_spender] = _value;
111             Approval(msg.sender, _spender, _value);
112             return true;
113         } else {
114             return false;
115         }
116     }
117 
118     function approve(address _spender, uint _value) isStartedOnly returns (bool success) {
119         allowed[msg.sender][_spender] = _value;
120         Approval(msg.sender, _spender, _value);
121         return true;
122     }
123 
124     function allowance(address _owner, address _spender) constant returns (uint remaining) {
125         return allowed[_owner][_spender];
126     }
127 
128     mapping (address => uint) balances;
129     mapping (address => mapping (address => uint)) allowed;
130 
131     uint public totalSupply;
132     bool    public isStarted = false;
133 
134     modifier isStartedOnly() {
135         require(isStarted);
136         _;
137     }
138 
139 }
140 
141 contract Token is ERC20 {
142     using SafeMath for uint;
143 
144     string public name = "CrowdWizToken";
145     string public symbol = "WIZ";
146     uint8 public decimals = 18;
147 
148     address public crowdsaleMinter;
149 
150     modifier onlyCrowdsaleMinter(){
151         require(msg.sender == crowdsaleMinter);
152         _;
153     }
154 
155     modifier isNotStartedOnly() {
156         require(!isStarted);
157         _;
158     }
159 
160     function Token(){
161         crowdsaleMinter = 0x4544e57470f7211a65c050c259922c89e0b41240;
162     }
163 
164     function getTotalSupply()
165     public
166     constant
167     returns(uint)
168     {
169         return totalSupply;
170     }
171 
172     function start()
173     public
174     onlyCrowdsaleMinter
175     isNotStartedOnly
176     {
177         isStarted = true;
178     }
179 
180     function emergencyStop()
181     public
182     only(owner)
183     {
184         isStarted = false;
185     }
186 
187     //================= Crowdsale Only =================
188     function mint(address _to, uint _amount) public
189     onlyCrowdsaleMinter
190     isNotStartedOnly
191     returns(bool)
192     {
193         totalSupply = totalSupply.add(_amount);
194         balances[_to] = balances[_to].add(_amount);
195         return true;
196     }
197 }