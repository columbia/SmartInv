1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 contract Ptc {
53     function balanceOf(address _owner) constant public returns (uint256);
54 }
55 
56 contract Jade {
57     using SafeMath for uint256;
58     /* Public variables of the token */
59     uint256 public totalSupply;
60     string public name;
61     string public symbol;
62     uint8 public decimals = 3;
63     uint256 public totalMember;
64 
65     uint256 private tickets = 50*(10**18);
66     uint256 private max_level = 20;
67     uint256 private ajust_time = 30*24*60*60;
68     uint256 private min_interval = (24*60*60 - 30*60);
69     uint256 private creation_time;
70 
71     /* This creates an array with all balances */
72     mapping (address => uint256) public balanceOf;
73     mapping (address => uint256) public levels;
74 
75     mapping (address => uint256) private last_mine_time;
76 
77     /* This generates a public event on the blockchain that will notify clients */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     address private ptc_addr = 0xeCa906474016f727D1C2Ec096046C03eAc4Aa085;
81     Ptc ptc_ins = Ptc(ptc_addr);
82 
83     constructor(string _name, string _symbol) public{
84         totalSupply = 0;
85         totalMember = 0;
86         creation_time = now;
87         name = _name;
88         symbol = _symbol;
89     }
90 
91     // all call_func from msg.sender must at least have 50 ptc coins
92     modifier only_ptc_owner {
93         require(ptc_ins.balanceOf(msg.sender) >= tickets);
94         _;
95     }
96 
97     /* Send coins */
98     function transfer(address _to, uint256 _value) public only_ptc_owner{
99         /* if the sender doenst have enough balance then stop */
100         require (balanceOf[msg.sender] >= _value);
101         require (balanceOf[_to] + _value >= balanceOf[_to]);
102 
103         /* Add and subtract new balances */
104         balanceOf[msg.sender] -= _value;
105         balanceOf[_to] += _value;
106 
107         /* Notifiy anyone listening that this transfer took place */
108         emit Transfer(msg.sender, _to, _value);
109     }
110 
111     function ptc_balance(address addr) constant public returns(uint256){
112         return ptc_ins.balanceOf(addr);
113     }
114 
115     function rest_time() constant public only_ptc_owner returns(uint256) {
116         if (now >= last_mine_time[msg.sender].add(min_interval))
117             return 0;
118         else
119             return last_mine_time[msg.sender].add(min_interval).sub(now);
120     }
121 
122     function catch_the_thief(address check_addr) public only_ptc_owner returns(bool){
123         if (ptc_ins.balanceOf(check_addr) < tickets) {
124             levels[msg.sender] = levels[msg.sender].add(levels[check_addr]);
125             update_power();
126 
127             balanceOf[check_addr] = 0;
128             levels[check_addr] = 0;
129             return true;
130         }
131         return false;
132     }
133 
134     function mine_jade() public only_ptc_owner returns(uint256) {
135         if (last_mine_time[msg.sender] == 0) {
136             last_mine_time[msg.sender] = now;
137             update_power();
138 
139             balanceOf[msg.sender] = mine_jade_ex(levels[msg.sender]);
140             totalSupply = totalSupply.add(mine_jade_ex(levels[msg.sender]));
141             totalMember = totalMember.add(1);
142 
143             return mine_jade_ex(levels[msg.sender]);
144         } else if (now >= last_mine_time[msg.sender].add(min_interval)) {
145             last_mine_time[msg.sender] = now;
146             update_power();
147 
148             balanceOf[msg.sender] = balanceOf[msg.sender].add(mine_jade_ex(levels[msg.sender]));
149             totalSupply = totalSupply.add(mine_jade_ex(levels[msg.sender]));
150 
151             return mine_jade_ex(levels[msg.sender]);
152         } else {
153             return 0;
154         }
155     }
156 
157     function mine_jade_ex(uint256 power) private view returns(uint256) {
158         uint256 cycle = now.sub(creation_time).div(ajust_time);
159         require (cycle >= 0);
160         require (power >= 0);
161         require (power <= max_level);
162 
163         return ((100*power + 20*(power**2)).mul(95**cycle)).div(100**cycle);
164     }
165 
166     function update_power() private {
167         require (levels[msg.sender] >= 0);
168         if (levels[msg.sender] < max_level)
169             levels[msg.sender] = levels[msg.sender].add(1);
170         else
171             levels[msg.sender] = max_level;
172     }
173 }