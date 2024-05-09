1 pragma solidity ^0.5.0;
2 
3  /**
4  * 
5  * https://aesthetics.finance
6  * 
7  * 
8  * 
9  * ａｎｇｅｌｐｌｅａｓｅｄｏｎ'ｔｇｏ I'll miss you when you go 
10  * 
11  *      ```  ``   ``  ```  ``   ``  ``   ``  ```  ```  ``  ```  ``   ``   ``  ``   ``  ```  ``   ``   ``  
12  *`  ``  ```  ``   ``  ```  ``  ```  ```  ``  ```  ```  ``  ```  ```  ``  ```  ``   ``   ``  ``   ``
13  *  `   ``  ```  ``   ``` ```   ``  ```````````...```` `   ``` ```   ``  ```   `   `   ```  ``  ```  
14  *``````    `  ```` ````  `` ```````.-::::::::::://:----..```````  `` `  `` ````` ``  `   `   ````` 
15  *   ``  ```  ``   ``  ```  `--//:/:::/++//::::::::::::::::-.``   `   ``  ```  ``    `  ```  ``   ``
16  *```  ``   ``  ```  ``  ```.::://///+osso+/::::::::::++///::/..`  ```  ``   ``  ```  ``   ``  ```  
17  *   ``  ```  ``   ``  ````-://+//:/+o+///::::::::---::/++o+/:--::-`  ``  ```  ``   ``  ```  ``   ``
18  * ```  ```  ``  ``` `-//:::://++:---::::/+/+//++++ooo+++//:///////+/-`  ``   ``  ```  ``   ``  ``   
19  *   ``  ```  ``  `-++::::::+++++/:./ooooo++ooooyyyyso+//:::::+ssso/o-``  ```  ``   ``  ```  ```  ``
20  *```  ``   `` ```.s+/+/:::://////:/oyysoosssssyhysoo+//::++///+oo/o.`` ``   ``   ``  ``   ``  ```  
21  *``` ``   ``  ````+yy+/:::/++///+oyys+yhyyyyyyyysoo+oo++oyyso+oooo/:` ` ` `  ``````` `   ``   `  ` 
22  *   ``  ```  ``` ``+ys//+++++/osyhysosyhyssyyyyo+++yyooohdhhyoso++oo/-.  ```  ``   ``  ```  ```  ``
23  * ```  ```  ``  ````./++++osys/++yyyysso+/osssssyyysyyyyhhysssyy++osss+o-``  ``  ``   ``   ``   ``  
24  *   ``   ``  ``  `./+osssoossooossso+/:---:/++oossssooosyysoshhso++oys/o````  ``   ``  ```  ``   ``
25  *```  ```  ``  ````/syyhhhyyo/oo+/::---..`.-::/+++oo++++oosydddysyssoo:-``  ``  ``   ``   ``   `   
26  *   ``  ```  ``   ```-oyhhyo+oo+:----.....--::::::///++++++shyhhhhhyy/+- ```  ``   ``  ```  ```  ``
27  *``` ``` ```  ` ``  `-ooyhhyyyo/////++++++///////////////++syshhhhhhy//``    ``  `   ``  ```  ```  
28  * ``  ```   ``  ```  `:++so+++/::/+oooosyyyyssoooo+oooooo+++syyhhyso/:````   ```  ``` ``` ```  `````
29  *  ```   ``  ``  ````-+osso+:---:/oooossyyyyso++osyhhysssooossohs``````  ```  ``   ``  ```  ```  ``
30  *```  ```  ``  ```  ``-//oo+/:----:/++oossss+/::+yhhyyssssooso/o` ```  ``   ``  ``   ``   ``  ``   
31  *   ``  ```  ``   ``  `:///////::::::////:::---:/+ossooooo++o:o-``   ``  ```  ```  ``  ```  ``   ``
32  *```  ``   ``  ```  ````/+so+++//:::::::::::---:////++++//+++:o`   ``  ``   ``  ```  ``   ``   ``  
33  *   ``  ```  ``   ``   `.:oysoo++///////++/::-:/+++++////++o:s.  `   ``  ```  ``    `  ```  ``   ``
34  *` `` `` `````````  `` ```-yo+o++++++++ooo/:--:/ooo+++++++o/o:``  ```` ``````` ```       ```  ``   
35  *```  ``   `  ````  ``` ```sso+++++++++//+++////oooo+++++oys-```  ````  ``  ``  ```` `    `` ````  
36  *   ``  ```  ``  ```  ```  :yso++++++//::-/sssoooo++++++oooy.`` ```  ``  ```  ``   ``  ```  ``   ``
37  *```  ``   ``  ```  ``   ```+ysoo+++ooo+/::/++++++++++ooo++s/```  ```  ``   ``   ``  ``   ``  ```  
38  *   ``  ``   ``   ``  ```  ``+ysooooossoooossssosssooooo+//+y.  ``   ``  ```  ``   ``  ```  ```  ``
39  *```  ```  ``  ``   ``  ```  `/yysssooooooosssoosssoooo++///oo.`   ``  ``  ```  ``   ``   ``   ``  
40  *  ```  ```  ``   ``  ```  ````/hyyso++++osssoooooooooo+////+oo.```  ``  ```  ```  ``  ```  ``   ``
41  *  ```  ``   `` `  ` ``  ```  ``.yhhysoo++oooo+++oosooo++/////++o:`` ` ```  ```   `   ```   ``  `  `
42  *```  ```  ``  ``   ``` ```  ```:hyhyyyysssssssssssooo+++/////++o/.``  ``   ``  ```  ``   ``  ``   
43  *   ``   ``  ``   ``  ```  ``  ``ohyyyyyyyyyyyyyyssooo++++///////+o:```  ```  ``   ``   ``  ```  ``
44  *```  ``   ``  ```  ``   ``   `` `shyyyyyyyyyyyyyssooo++++////////+++.````  ``  ```  ``   ``  ```  
45  *   ``   ``  ``   ``  ```  ``  ````oyyyyysyssssssssoooo++++////////+++/-:-``  ``   ``  ```  ```  ``
46  *```  ```  ``  ```  ``  ```  ```  ``/syyyssssssssssoooo++++////////++++ooo/-``  ```  ``   ``  ```  
47  *  ```  ``` ```   ``  ```  ```  ``  `.syyssyssssssssoooo+++++++++////////++//.```  ``  ``` ```    `
48  *   ````    `    `  ``    `   ` `` ```-ssysyyssssssssoooo++++++///////++++++++::```` `` ``     `   
49  *```  ```  ``  ``   ``   ``  ```  ````:ssyyyyyssssssssoooo+o++++++++++++++++oo/+.``  ```  ``  ``   
50  *   ``   ``  ``   ``  ```  ``  ````.:+oosssyyysssssssooo+++++++++++oooossoo+/:--`  ``  ```  ```  ``
51  *```  ``   ``  ```  ``   ``  ````-//+++ooosyysssssssoo+///++++ooossso+/:-.` ``   ``  ``   ``  ```  
52  *   ``   ``  ``   ``  ```  ```.:///////+++sssssssyso////++++oooo+/-` ``  ```  ``   ``   ``  ``   ``
53  *```  ``   ``  ```  ``   ``.-/++++///::///++///+++///++++ooo+/-` ````  ``   ``  ```  ``   ``  ```  
54  *  ```  ``` ```  ```  ```.://++//////://///::::://++++ooo+:.``  ``` ```  ``   ``   ``   ``  ``   ``
55  *   `  ``   `` `  `  ` ``///+++:::/://::::::::/+++++oos+.````    `     `  ```  ``   ` ````       ``
56  * ``  ``   ``  ```  ``   -:+++o/:///++/:-:://+++++oso/.  ```  ``   `   ``  ```  ```  ``   ``   ``  
57  *`   ``  ```  ``   ``  ```  ``.-::++++o+//++++++oos+:`  ``  ```  ``   ``  ```  ``   ``  ```  ``   ``
58  * ```  ``   ``  ```  ``   ``  ```  `-::/++oooooso:.  ```  ``   ``  ```  ``   ``  ```  ``   ``  ```  
59  *``   ``   ``  ``   ``  ```  ``  ```  ```  ```````  ```  ``  ```  ```  ``  ``   ``   ``   ``  ```  ``
60  *  ``   ``   ``  ```  ``  ```   ``  ``  ```  ```  ``   `   ```  ``   ``  ``   ``   ``  ```  ``  ```  
61  *``   ``  ```  ``   ``  ``   ``  ```  ```  ``   ``  ``   ``    `  ``   ``   `   ``   ``  ```   `   ``
62  * 
63  * 
64  * 
65  * 
66  * Ｖａｐｏｒｗａｖｅｉｓｄｅａｄ
67  * 
68  */
69  
70  // Copied & modified from NUTS code:
71  // https://squirrel.finance/
72  // this alteration has not been audited and may contain bugs - be warned.
73 
74 
75 interface ERC20 {
76   function totalSupply() external view returns (uint256);
77   function balanceOf(address who) external view returns (uint256);
78   function allowance(address owner, address spender) external view returns (uint256);
79   function transfer(address to, uint256 value) external returns (bool);
80   function approve(address spender, uint256 value) external returns (bool);
81   function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
82   function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84   event Transfer(address indexed from, address indexed to, uint256 value);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 interface ApproveAndCallFallBack {
89     function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
90 }
91 
92 contract VAPE is ERC20 {
93     using SafeMath for uint256;
94     
95     mapping (address => uint256) private balances;
96     mapping (address => mapping (address => uint256)) private allowed;
97     string public constant name  = "aesthetics.finance";
98     string public constant symbol = "VAPE";
99     uint8 public constant decimals = 18;
100 
101     uint256 totalVape = 4200000 * (10 ** 18);
102     address public currentGovernance;
103     
104     constructor() public {
105         balances[msg.sender] = totalVape;
106         currentGovernance = msg.sender;
107         emit Transfer(address(0), msg.sender, totalVape);
108     }
109     
110     function totalSupply() public view returns (uint256) {
111         return totalVape;
112     }
113 
114     function balanceOf(address player) public view returns (uint256) {
115         return balances[player];
116     }
117 
118     function allowance(address player, address spender) public view returns (uint256) {
119         return allowed[player][spender];
120     }
121     
122     function transfer(address to, uint256 value) public returns (bool) {
123         require(value <= balances[msg.sender]);
124         require(to != address(0));
125     
126         balances[msg.sender] = balances[msg.sender].sub(value);
127         balances[to] = balances[to].add(value);
128     
129         emit Transfer(msg.sender, to, value);
130         return true;
131     }
132 
133     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
134         for (uint256 i = 0; i < receivers.length; i++) {
135             transfer(receivers[i], amounts[i]);
136         }
137     }
138     
139     function approve(address spender, uint256 value) public returns (bool) {
140         require(spender != address(0));
141         allowed[msg.sender][spender] = value;
142         emit Approval(msg.sender, spender, value);
143         return true;
144     }
145 
146     function approveAndCall(address spender, uint256 tokens, bytes calldata data) external returns (bool) {
147         allowed[msg.sender][spender] = tokens;
148         emit Approval(msg.sender, spender, tokens);
149         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
150         return true;
151     }
152 
153     function transferFrom(address from, address to, uint256 value) public returns (bool) {
154         require(value <= balances[from]);
155         require(value <= allowed[from][msg.sender]);
156         require(to != address(0));
157         
158         balances[from] = balances[from].sub(value);
159         balances[to] = balances[to].add(value);
160         
161         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
162         
163         emit Transfer(from, to, value);
164         return true;
165     }
166     
167     function updateGovernance(address newGovernance) external {
168         require(msg.sender == currentGovernance);
169         currentGovernance = newGovernance;
170     }
171     
172     function mint(uint256 amount, address recipient) external {
173         require(msg.sender == currentGovernance);
174         balances[recipient] = balances[recipient].add(amount);
175         totalVape = totalVape.add(amount);
176         emit Transfer(address(0), recipient, amount);
177     }
178     
179     function burn(uint256 amount) external {
180         require(amount != 0);
181         require(amount <= balances[msg.sender]);
182         totalVape = totalVape.sub(amount);
183         balances[msg.sender] = balances[msg.sender].sub(amount);
184         emit Transfer(msg.sender, address(0), amount);
185     }
186 }
187 
188 
189 
190 library SafeMath {
191   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192     if (a == 0) {
193       return 0;
194     }
195     uint256 c = a * b;
196     require(c / a == b);
197     return c;
198   }
199 
200   function div(uint256 a, uint256 b) internal pure returns (uint256) {
201     uint256 c = a / b;
202     return c;
203   }
204 
205   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206     require(b <= a);
207     return a - b;
208   }
209 
210   function add(uint256 a, uint256 b) internal pure returns (uint256) {
211     uint256 c = a + b;
212     require(c >= a);
213     return c;
214   }
215 
216   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
217     uint256 c = add(a,m);
218     uint256 d = sub(c,1);
219     return mul(div(d,m),m);
220   }
221 }