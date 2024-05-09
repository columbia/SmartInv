1 pragma solidity ^0.4.15;
2 contract Base {
3     modifier only(address allowed) {
4         require(msg.sender == allowed);
5         _;
6     }
7     // *************************************************
8     // *          reentrancy handling                  *
9     // *************************************************
10     uint constant internal L00 = 2 ** 0;
11     uint constant internal L01 = 2 ** 1;
12     uint constant internal L02 = 2 ** 2;
13     uint constant internal L03 = 2 ** 3;
14     uint constant internal L04 = 2 ** 4;
15     uint constant internal L05 = 2 ** 5;
16     uint private bitlocks = 0;
17     modifier noAnyReentrancy {
18         var _locks = bitlocks;
19         require(_locks == 0);
20         bitlocks = uint(-1);
21         _;
22         bitlocks = _locks;
23     }
24 }
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
31         uint256 c = a * b;
32         assert(a == 0 || c / a == b);
33         return c;
34     }
35     function div(uint256 a, uint256 b) internal constant returns (uint256) {
36         // assert(b > 0); // Solidity automatically throws when dividing by 0
37         uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39         return c;
40     }
41     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45     function add(uint256 a, uint256 b) internal constant returns (uint256) {
46         uint256 c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 contract Owned is Base {
52     address public owner;
53     address newOwner;
54     function Owned() {
55         owner = msg.sender;
56     }
57     function transferOwnership(address _newOwner) only(owner) {
58         newOwner = _newOwner;
59     }
60     function acceptOwnership() only(newOwner) {
61         OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63     }
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 }
66 contract ERC20 is Owned {
67     event Transfer(address indexed _from, address indexed _to, uint _value);
68     event Approval(address indexed _owner, address indexed _spender, uint _value);
69     function transfer(address _to, uint _value) isStartedOnly returns (bool success) {
70         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
71             balances[msg.sender] -= _value;
72             balances[_to] += _value;
73             Transfer(msg.sender, _to, _value);
74             return true;
75         } else { return false; }
76     }
77     function transferFrom(address _from, address _to, uint _value) isStartedOnly returns (bool success) {
78         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
79             balances[_to] += _value;
80             balances[_from] -= _value;
81             allowed[_from][msg.sender] -= _value;
82             Transfer(_from, _to, _value);
83             return true;
84         } else { return false; }
85     }
86     function balanceOf(address _owner) constant returns (uint balance) {
87         return balances[_owner];
88     }
89     function approve_fixed(address _spender, uint _currentValue, uint _value) isStartedOnly returns (bool success) {
90         if(allowed[msg.sender][_spender] == _currentValue){
91             allowed[msg.sender][_spender] = _value;
92             Approval(msg.sender, _spender, _value);
93             return true;
94         } else {
95             return false;
96         }
97     }
98     function approve(address _spender, uint _value) isStartedOnly returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         return true;
102     }
103     function allowance(address _owner, address _spender) constant returns (uint remaining) {
104         return allowed[_owner][_spender];
105     }
106     mapping (address => uint) balances;
107     mapping (address => mapping (address => uint)) allowed;
108     uint public totalSupply;
109     bool    public isStarted = false;
110     modifier isStartedOnly() {
111         require(isStarted);
112         _;
113     }
114 }
115 contract Token is ERC20 {
116     using SafeMath for uint;
117     string public name = "Patron coin";
118     string public symbol = "PAT";
119     uint8 public decimals = 18;
120     address public crowdsaleMinter;
121     modifier onlyCrowdsaleMinter(){
122         require(msg.sender == crowdsaleMinter);
123         _;
124     }
125     modifier isNotStartedOnly() {
126         require(!isStarted);
127         _;
128     }
129     function Token(address _crowdsaleMinter){
130         crowdsaleMinter = _crowdsaleMinter;
131     }
132     function start()
133     public
134     onlyCrowdsaleMinter
135     isNotStartedOnly
136     {
137         isStarted = true;
138     }
139     function emergencyStop()
140     public
141     only(owner)
142     {
143         isStarted = false;
144     }
145     //================= Crowdsale Only =================
146     function mint(address _to, uint _amount) public
147     onlyCrowdsaleMinter
148     isNotStartedOnly
149     returns(bool)
150     {
151         totalSupply = totalSupply.add(_amount);
152         balances[_to] = balances[_to].add(_amount);
153         return true;
154     }
155 
156     event Burn(address indexed burner, uint256 value);
157 
158     function burn(uint256 _value, address _address)
159     onlyCrowdsaleMinter
160     returns (bool)
161     {
162         require(_value <= balances[_address]);
163 
164         balances[_address] = balances[_address].sub(_value);
165         totalSupply = totalSupply.sub(_value);
166 
167         Burn(_address, _value);
168 
169         return true;
170     }
171 
172 }