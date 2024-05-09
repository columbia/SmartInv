1 pragma solidity ^0.4.21;
2 
3 contract ERC20 {
4     function totalSupply() public constant returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     function transferFrom(address from, address to, uint256 value) public returns (bool);
8     function allowance(address owner, address spender) public view returns (uint256);
9     function approve(address spender, uint256 value) public returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         require(c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a);
39         return c;
40     }
41 }
42 
43 contract Bitway is ERC20 {
44 
45     using SafeMath for uint256;
46     
47     string public constant name = "Bitway";
48     string public constant symbol = "BTWN";
49     uint256 public constant maxSupply = 21 * million * multiplier;
50     uint256 public constant RATE = 1000;
51     uint256 public constant decimals = 18;
52     uint256 constant multiplier = 10 ** decimals;
53     uint256 constant million = 10 ** 6;
54     uint256 constant preSupply = 1 * million * multiplier;
55     uint256 constant softCap = 2 * million * multiplier;
56     uint256 constant bonusMiddleCriteria = 2 ether;
57     uint256 constant bonusHighCriteria = 10 ether;
58     uint256 constant stageTotal = 3;
59 
60     uint256[stageTotal] targetSupply = [
61         1 * million * multiplier + preSupply,
62         10 * million * multiplier + preSupply,
63         20 * million * multiplier + preSupply
64     ];
65 
66     uint8[stageTotal * 3] bonus = [
67         30, 40, 50,
68         20, 30, 40,
69         10, 20, 30
70     ];
71     
72     uint256 public totalSupply = 0;
73     uint256 stage = 0;
74     address public owner;
75     bool public paused = true;
76 
77     mapping(address => uint256) balances;
78     mapping(address => mapping(address => uint256)) allowed;
79 
80     function () public payable {
81         createCoins();
82     }
83 
84     function Bitway() public {
85         owner = msg.sender;
86         mineCoins(preSupply);
87     }
88 
89     function currentStage() public constant returns (uint256) {
90         return stage + 1;
91     }
92 
93     function softCapReached() public constant returns (bool) {
94         return totalSupply >= softCap;
95     }
96 
97     function hardCapReached() public constant returns (bool) {
98         return stage >= stageTotal;
99     }
100 
101     function createCoins() public payable {
102         require(msg.value > 0);
103         require(!paused);
104         require(totalSupply < maxSupply);
105         mineCoins(msg.value.mul(RATE + bonusPercent() * RATE / 100));
106         owner.transfer(msg.value);
107     }
108 
109     function setPause(bool _paused) public {
110         require(msg.sender == owner);
111         paused = _paused;
112     }
113 
114     function totalSupply() public constant returns (uint256) {
115         return totalSupply;
116     }
117 
118     function balanceOf(address _owner) public view returns (uint256) {
119         return balances[_owner];
120     }
121 
122     function transfer(address _to, uint256 _value) public returns (bool) {
123         require(_to != address(0));
124         require(_value <= balances[msg.sender]);
125         
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         emit Transfer(msg.sender, _to, _value);
129         return true;
130     }
131 
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133         require(allowed[_from][msg.sender] >= _value);
134         require(balances[_from] >= _value);
135         require(_value > 0);
136 
137         balances[_from] = balances[_from].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140         emit Transfer(_from, _to, _value);
141         return true;
142     }
143 
144     function approve(address _spender, uint256 _value) public returns (bool) {
145         allowed[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     function allowance(address _owner, address _spender) public view returns (uint256) {
151         return allowed[_owner][_spender];
152     }
153 
154     function mineCoins(uint256 coins) internal {
155         require(!hardCapReached());
156         balances[msg.sender] = balances[msg.sender].add(coins);
157         totalSupply = totalSupply.add(coins);
158         if (totalSupply >= targetSupply[stage]) {
159             stage = stage.add(1);
160         }
161     }
162 
163     function bonusPercent() internal constant returns (uint8) {
164         if (msg.value > bonusHighCriteria) {
165             return bonus[stage * stageTotal + 2];
166         } else if (msg.value > bonusMiddleCriteria) {
167             return bonus[stage * stageTotal + 1];
168         } else {
169             return bonus[stage * stageTotal];
170         }
171     }
172 
173     event Transfer(address indexed _from, address indexed _to, uint256 _value);
174     
175     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
176 
177 }