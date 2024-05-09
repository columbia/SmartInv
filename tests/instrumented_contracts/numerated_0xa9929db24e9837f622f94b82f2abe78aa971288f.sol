1 // SPDX-License-Identifier: MIT
2 
3 /*
4 PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP55PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
5 PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP5Y5PPPPPPPPPPPPPPPPPPPPJ~^?PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
6 PPPPPP5PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPY~::!YPPPPPPPPPPPPPPPPPJ^...JPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
7 PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP7^...:?5PPPPPPPPPPPPPPJ~..7!^5PPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
8 PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP5~::7!:.!YPPPPP555YYYY?J^ :5Y.?PPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
9 PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPJ~:^YP7:.!?J?77777??JJ?J7~~5J:~PPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
10 PPPPPP55PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP7~^:?B5~ ~GY7JY555555PGPYJ?7!!^5PPPPPPPPPPPPPPPPPPPPPPPPPPPPP
11 PPPPPP5PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP~!!.~PB7^JYJYY5Y5YJ7!?5GPY~.~7^JPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
12 PPPPP555555PPPPPPPP55555555555PPPPPPPPP~7?^^~?YJJYYYYYYJJY!..7JYY7^!P57YPPPPPPPPPPPPPPPPPPPPPPPPPPPP
13 PPPP555555555555555555555PPPPPPPPPPPPPP7?J?!~7JY5YYYYJ!?5GPY!!?777!!JY!!5555PPPPPPPPPPPPPPPPPPPPPPPP
14 PPP55555555555555555555555PPPPPPPPPPPPPY~YY?J555555YY77J5Y?J7!!!!^^::~7?YYYY5PPPPPPPPPPPPPPPPPPPPPPP
15 PP5555555555555555555555555PP55555PPPPPY.7YJGP5Y?!~^:::^~~~:::~~^. .!5#B###YJ555PPPPPPPPPPPPPPPPPPPP
16 PP5555555555555555555555555555555555PPP~.7?5J~:.     .....   .:::...:7PGBBB77555PPPPPPPPPPPPPPPPPPPP
17 PPP55555555555555555555555555555555PPPY ~??J^...    .....  ..:::::..:!YGGPP!7P55PPPPPPPPPPPPPPPPPPPP
18 PP555555555555555555555555555555555PPP? ?JJ7::....  ........::^^^^^~!J5P5?^?P55PPPPPPPPPPPPPPPPPPPPP
19 PP555555555555555555555555555555555PPP?.Y5Y7::::.........::~JY?777!!!~~^:.:5P5PPPPPPPPPPPPPPPPPPPPPP
20 PPP55555555555555555555555555555555PPPJ.JGPY~::::::::....::^~!!!!!!!!~^:. ~PPPPPPPPPPPPPPPPPPPPPPPPP
21 PPPP555555555555555555555555555555PPPP5:7PBG57^:::::::^^^^~~77???7!~^:.   !P5PPPPPPPPPPPPPPPPPPPPPPP
22 PPP55555555555555555555555555555555PPY!?JJPBBG5?^.........::^^^::....     ?P5PPPPPPPPPPPPPPPPPPPPPPP
23 PPP55555555555555555555555555PPPPPPPPY~7PGGPGBBBPJ!:.  ........    .     .YPPPPPPPPPPPPPPPPPPPPPPPPP
24 PP5555555555555555555555555PPPPPPPPP57~7?YGBGGGGBBGPJ!^.   ...          .~!5PPPPPPPPPPPPPPPPPPPPPPPP
25 PP55555555555555555555555555P555PPPY::?JJJJ55GBBGGGGGGPYJ7^.      ..   .~!^?PPPPPPPPPPPPPPPPPPPPPPPP
26 PPP55555555555555555555555555555PP5:.7Y555YY?YY5PGGGGGPPP5YJ!^:.     .^~^^~!PPPPPPPPPPPPPPPPPPPPPPPP
27 PPP5555555555555555555555555555PPPY :?JY55PP55JJJJJJYY5PPPPYJJ??7!~~~~^:.^~!PPPPPPPPPPPPPPPPPPPPPPPP
28 PPP555555555555555555PP555PPP555PPJ :JYYYYY55PP5YJ??777!!!!!7?7!~~^::.  :~~^YPPPPPPPPPPPPPPPPPPPPPPP
29 PPP55555555555P55PPPPPPPPPPPP55PPPJ .?5YYJJJJJY5PP5Y?7!!!~~~^^:.     .:^~~^:!PPPPPPPPPPPPPPPPPPPPPPP
30 PPP5555555555555PPPPPPPPPPPPPPP5J77!:7Y55YYJJ????JYY55YJ7!~~~~~~~^^::^~~~^^.:5PPPPPPPPPPPPPPPPPPPPPP
31 PPP555555PPPPPPPPPPPPPPPPPPPPJ~:~JGG77JJY55YJJ?7!!!~~~!7????77!~~~~!~~^!!~. .YPPPPPPPPPPPPPPPPPPPPPP
32 PPPPPPP55PPPPPPPPPPPPPPPPPPJ^ :75GBBPJ???JYY5YJ7!~^^::....::^~!77777!~!7^.  .YPPPPPPPPPPPPPPPPPPPPPP
33 PPPPPPPP55PPPP555PPPPPPPP5~ .!J5PPGBB5J????JJYYYJ7~::...         :~~~~~~^:  .JPPPPPPPPPPPPPPPPPPPPPP
34 PPPPPPPP5555555PPPPPPPPP?. ^7YY5PPGBBB5JJ??????JYYY?~:...       .!^~~~^~~^.. ^5PPPPPPPPPPPPPPPPPPPPP
35 PPPPPPPPPP55555PPPPPPPP7  ^?YY55PPGBBBGYYJJ?777777?JYJ!^...     :J!~~~~~~~^.  JPPPPPPPPPPPPPPPPPPPPP
36 PPPPPPP5555555PPPPPPPP7  ~?YYYY5PPGBBBBP55J??7!!!~!!!7???!^...  .~YY7!!~~~.   ?PPPPPPPPPPPPPPPPPPPPP
37 PPPPPP55555555PPPPPPP?  ~JY555Y55PGGBBBB55YJ?7!!~~~^^^^^^~~^^:....:!77!!^.   .YPPPPPPPPPPPPPPPPPPPPP
38 PPPPP5555555555P55PPY. ^?Y55YY555PGGBBBBP55YJ7!!~^^^::::........ .           7PPPPPPPPPPPPPPPPPPPPPP
39 PPPP5555555555555PP5^ :7Y55555555PGGBBBB5555Y?!~~^^::::..   ..            ..?PPPPPPPPPPPPPPPPPPPPPPP
40 PPP555555555PPPPPPPJ :?YPPP5555PPGGBBBBG555YYJ7!~^^:::. .^!7??7!:      .^~~YP55PPPPPPPPPPPPPPPPPPPPP
41 PPP55555555555PPPPP~ 75PPPPPPPPPGGGBBB#G555YYJ?!~~^^:..!JJ?7!!!!!.   .~7~.?P555PPPPPPPPPPPPPPPPPPPPP
42 PPP555555555555PPPJ.~5PGGGGGGGGGGGGBBB#P555YJ?7!~~^^::?Y7~~^:::::: .~?!:.^PP5PPPPPPPPPPPPPPPPPPPPPPP
43 PPPPP555555555PPY~:75GGGGGGGGGGGGGBBBB#P55YYJ?!~~^^:^?J!~^:::... .~??~:. ?P5P5PPPPPPPPPPPPPPPPPPPPPP
44 PPP5555555555PP7.~YGBBBBBBBBBBBBBBBBBBB555YJ?7~~^^::!J!^^::.... ^JJ7^::.:5P555PPPPPPPPPPPPPPPPPPPPPP
45 PP555555555PPP! ^7JJYPGB#BBBBBBBBBBBB#B55YYJ?7!^^^:.!J~^:::..  !YJ~^^::.?P5555PPPPPPPPPPPPPPPPPPPPPP
46 PPPPPPPPPPPPP7 ~??7!~^~75##BBBBBBBBBB#B55YYJJ7!~^^::^J~^::...^?5J!^^::.:5P555PPPPPPPPPPPP555555PPPPP
47 PPPPPPPPPPPP5:~JJJJ??!~::!P#######B###B55YYYJ?!~^::::?!^::^!J55Y?~^^::.~P55555555555PPPPP55555555PPP
48 PPP5PPPPPPPPY:?YYYYJJ?7!~^^P##BB#B##BB#G55YYJ?7!~~^^:!J7?YPPP55Y7!~^^^:?PPPPPPPPPPPPPPPPPP5555555PPP
49 PPPPPPPPPPPP555PPPPP55555555PPPPPPPPPPPPPPPPP555555555PPPPPPPPP555555555PPPPPPPPPPPPPPPPPPPPPPPPPPPP
50 PPPPPPPPPPPPPPP555PPPPPPPPPP555555555555PPPPPPPPPPPPPPPP5PPPPPPPPPPPPPPP55555555PPPPPPPPPPPPPPPPPPPP
51 //
52     ███████    █████   █████ ██████   ██████ █████
53   ███░░░░░███ ░░███   ░░███ ░░██████ ██████ ░░███ 
54  ███     ░░███ ░███    ░███  ░███░█████░███  ░███ 
55 ░███      ░███ ░███████████  ░███░░███ ░███  ░███ 
56 ░███      ░███ ░███░░░░░███  ░███ ░░░  ░███  ░███ 
57 ░░███     ███  ░███    ░███  ░███      ░███  ░███ 
58  ░░░███████░   █████   █████ █████     █████ █████
59    ░░░░░░░    ░░░░░   ░░░░░ ░░░░░     ░░░░░ ░░░░░ 
60 // 
61 // BARK DIFFERENT!
62 // The top dog that rewards true loyalty.
63 //
64 // https://linktr.ee/ohmi
65 //
66 */
67 
68 pragma solidity ^0.4.23;
69 
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 library SafeMath {
78 
79   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
80     if (a == 0) {
81       return 0;
82     }
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     // uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return a / b;
93   }
94 
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
101     c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 }
106 
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111 
112   uint256 totalSupply_;
113 
114   function totalSupply() public view returns (uint256) {
115     return totalSupply_;
116   }
117 
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     emit Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   function balanceOf(address _owner) public view returns (uint256) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender)
136     public view returns (uint256);
137 
138   function transferFrom(address from, address to, uint256 value)
139     public returns (bool);
140 
141   function approve(address spender, uint256 value) public returns (bool);
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 contract StandardToken is ERC20, BasicToken {
150 
151   mapping (address => mapping (address => uint256)) internal allowed;
152 
153   function transferFrom(
154     address _from,
155     address _to,
156     uint256 _value
157   )
158     public
159     returns (bool)
160   {
161     require(_to != address(0));
162     require(_value <= balances[_from]);
163     require(_value <= allowed[_from][msg.sender]);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168     emit Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   function allowance(
179     address _owner,
180     address _spender
181    )
182     public
183     view
184     returns (uint256)
185   {
186     return allowed[_owner][_spender];
187   }
188 
189   function increaseApproval(
190     address _spender,
191     uint _addedValue
192   )
193     public
194     returns (bool)
195   {
196     allowed[msg.sender][_spender] = (
197       allowed[msg.sender][_spender].add(_addedValue));
198     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202   function decreaseApproval(
203     address _spender,
204     uint _subtractedValue
205   )
206     public
207     returns (bool)
208   {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 contract OHMI is StandardToken {
222 
223   string public constant name = "OHMI"; // solium-disable-line uppercase
224   string public constant symbol = "OHMI"; // solium-disable-line uppercase
225   uint8 public constant decimals = 18; // solium-disable-line uppercase
226 
227   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
228 
229   constructor() public {
230     totalSupply_ = INITIAL_SUPPLY;
231     balances[msg.sender] = INITIAL_SUPPLY;
232     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
233   }
234 
235 }