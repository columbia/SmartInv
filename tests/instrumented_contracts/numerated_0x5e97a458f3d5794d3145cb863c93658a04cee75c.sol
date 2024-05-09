1 pragma solidity ^0.4.19;
2 
3 /*
4                         ...........:??I7ZZ:......                               
5                         ......=??????7IIOOZZ=~...                               
6                    .  ..,I+?????????I7II==?ZZZO:,.. .......   .. .              
7                    ..??I:=~:~?????I7++++~:++++=?Z7~,.....,...........           
8                    .???.,,~:::::~+++++++~~=++++++++??+++?++???+.....            
9                    .?=,,,,,::::~~~+++++~~~~=+++++++I+?++?+?????????,.           
10               .....?,,,,,,,,:~:~~~?++??~~~~~++++++=??+++++?++++??+????~.......  
11               .....,,,,,,,,:?::~~~~+++~~~~~~~++++=I~:$++?+?++??+???????7?+....  
12               ...,=~~~~~~~~+I+++:~~:++=~~~~~:~+++++::::??+++++++?+????7II++.... 
13               ...?~~~~~~?+?II++++?+=?~~~~~~~~~~?+I=::::7+===+?+=+++??7III7?I... 
14               ..+?~~~~~???I??+++++++++++++~~~~~~+?:::::7===========+7IIIII7I?.. 
15               .~+~~~++???+???++++???I7?+++++++=+O,,::::I===========+I7II7777II. 
16          .....:++:~??????+?+I++??????77++++++$7~:::::::7=========?+?I777777+I?,.
17          .....?+?I++++++:7$??????????777?++Z$=:~:::::::7I++=====++?+I777777+??+.
18          ... ~???++++?,::777?I?IIII?ZZ+?$$?ZZ+~~~~::::?I7=====+?+++?7I7777?++I?.
19 . ...........+??=?++~,::::IZ?II7IIOZI????+7ZZI~~~~~:::7I7+==?+++++?+III77I+++??.
20 ...      .,=+~??+=?,::::,:Z???7~.7I77Z???+ZZZZ~~~~~~::II7=++++++++?+III77++????.
21 ,=??++++,,:=,,,:,,:,:,,.O7.......,III$$Z+?ZZZO~~~~~~+:I777II++++??+IIII7I??????~
22 .:?_1517702400_ZZI=:,7?$$........~?I777$$$?III???=~~~=$77II????????7II7$???????+
23  .. ..........?=+=+~I+7Z....... ..I?I?7ZZZIIII+++++++?I77IIII?????III$ZZ???????.
24 ..............=====?IIZ.. ..... ..II??I7IZIIII++++++??+I7IIIII?I?7I$Z$ZZ??????+.
25 . ..   ...  ..+++++=I?, .....    .7I???IIZI7II+++++????77IIIIIIII$ZZZ$ZZ?????+I.
26             ..=+++++II=.          7?I??I7ZIIII+++=+????+ZZZZ$ZZZOZZZZZZZ??????+.
27               =+=++=?I+.          $II??II$IIII+++++++++?$ZZ$ZOZ77777IZOZ?????+..
28               ,=+++=+II           +??I?7IIIIII?++??+++??....7III7777IIII?III?7..
29               .+++++??7.          ,II?I7I7ZIIII+++?+?+??....7III7777III7I+?++I. 
30               .+=++?+??.          .?III7IIZIIII+??????+?.....7III777IIIII++?+?. 
31               .+++I7???:          .IIII7IIIIIII???????+:.....I7II777III$II++I?. 
32               ..???????+.....     .=III7IIIIII?I???????.......7II77IIII7II+???. 
33               ...?I?????,.....    ..??I777III?II???????.... ..7II7II?I$$III???. 
34               ....:?I???II?77  .  ..??I7777IIIII?I????+.......:7I7II?I7$III+??. 
35                  ...???I++?++$......7II7I777III??????+,.......II7I+??$$$???$?I..
36                    ..?IIII?+?=......+III?I???????????+.......?I$$???I$?I=+~~II:.
37                    ........=?......~+=II??I7?$~~~~~:+I.......=I$Z$??IOI~====II7.
38                                   .==+?I?7I77:~:~~~~~I.....       ...Z======II. 
39                                   .:+=+I$7~?$~~~+~~~I?.....         .... ...... 
40                                   .........O:~~~~==:II.....         ..........  
41                                           ....,::~=:..                PolyETH         
42 */
43 
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint256 supply);
46     function balance() public constant returns (uint256);
47     function balanceOf(address _owner) public constant returns (uint256);
48     function transfer(address _to, uint256 _value) public returns (bool success);
49     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
50     function approve(address _spender, uint256 _value) public returns (bool success);
51     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
52 
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 contract Polyion is ERC20Interface {
58     string public constant symbol = "PLYN";
59     string public constant name = "Polyion";
60     uint8 public constant decimals = 2;
61 
62     uint256 _totalSupply = 0;
63     uint256 _airdropAmount = 1000000;
64     uint256 _cutoff = _airdropAmount * 10000;
65 
66     mapping(address => uint256) balances;
67     mapping(address => bool) initialized;
68 
69     // Owner of account approves the transfer of an amount to another account
70     mapping(address => mapping (address => uint256)) allowed;
71 
72     function  Polyion() public {
73         initialized[msg.sender] = true;
74         balances[msg.sender] = _airdropAmount * 1000;
75         _totalSupply = balances[msg.sender];
76     }
77 
78     function totalSupply() public constant returns (uint256 supply) {
79         return _totalSupply;
80     }
81 
82     // What's my balance?
83     function balance() public constant returns (uint256) {
84         return getBalance(msg.sender);
85     }
86 
87     // What is the balance of a particular account?
88     function balanceOf(address _address) public constant returns (uint256) {
89         return getBalance(_address);
90     }
91 
92     // Transfer the balance from owner's account to another account
93     function transfer(address _to, uint256 _amount) public returns (bool success) {
94         initialize(msg.sender);
95 
96         if (balances[msg.sender] >= _amount
97             && _amount > 0) {
98             initialize(_to);
99             if (balances[_to] + _amount > balances[_to]) {
100 
101                 balances[msg.sender] -= _amount;
102                 balances[_to] += _amount;
103 
104                 Transfer(msg.sender, _to, _amount);
105 
106                 return true;
107             } else {
108                 return false;
109             }
110         } else {
111             return false;
112         }
113     }
114 
115     // Send _value amount of tokens from address _from to address _to
116     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
117     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
118     // fees in sub-currencies; the command should fail unless the _from account has
119     // deliberately authorized the sender of the message via some mechanism; we propose
120     // these standardized APIs for approval:
121     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
122         initialize(_from);
123 
124         if (balances[_from] >= _amount
125             && allowed[_from][msg.sender] >= _amount
126             && _amount > 0) {
127             initialize(_to);
128             if (balances[_to] + _amount > balances[_to]) {
129 
130                 balances[_from] -= _amount;
131                 allowed[_from][msg.sender] -= _amount;
132                 balances[_to] += _amount;
133 
134                 Transfer(_from, _to, _amount);
135 
136                 return true;
137             } else {
138                 return false;
139             }
140         } else {
141             return false;
142         }
143     }
144 
145     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
146     // If this function is called again it overwrites the current allowance with _value.
147     function approve(address _spender, uint256 _amount) public returns (bool success) {
148         allowed[msg.sender][_spender] = _amount;
149         Approval(msg.sender, _spender, _amount);
150         return true;
151     }
152 
153     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
154         return allowed[_owner][_spender];
155     }
156 
157     // internal private functions
158     function initialize(address _address) internal returns (bool success) {
159         if (_totalSupply < _cutoff && !initialized[_address]) {
160             initialized[_address] = true;
161             balances[_address] = _airdropAmount;
162             _totalSupply += _airdropAmount;
163         }
164         return true;
165     }
166 
167     function getBalance(address _address) internal returns (uint256) {
168         if (_totalSupply < _cutoff && !initialized[_address]) {
169             return balances[_address] + _airdropAmount;
170         }
171         else {
172             return balances[_address];
173         }
174     }
175 }