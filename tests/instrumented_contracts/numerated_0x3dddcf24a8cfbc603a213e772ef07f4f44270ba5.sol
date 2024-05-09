1 pragma solidity ^0.4.21;
2 // Bogdanoffs Will Dump Ethereum Ponzi Scheme to ground ^
3 
4 /*
5 
6 
7 Quick rundown on them:
8 >rothschilds bow to the Bogdanoffs
9 >in contact with aliens
10 >rumoured to possess psychic abilities
11 >will bankroll the first cities on Mars (Bogdangrad will be be the first city)
12 >Control the British crown
13 >keep the metric system down
14 >keep Atlantis off the maps
15 >keep the martians under wraps
16 >hold back the electric car
17 >keep Steve Gutenberg a star
18 >own basically every DNA editing research facility on Earth
19 >both brothers said to have 200+ IQ
20 >ancient Indian scriptures tell of two angels who will descend upon the Earth and will bring an era of enlightenment
21 >These are the Bogdanoff twins
22 >They own Nanobot R&D labs around the world
23 >You likely have Bogdabots inside you right now
24 >The Bogdanoffs are in regular communication with the Archangels Michael and Gabriel, forwarding the word of God to the Church
25 >They learned fluent French in under a week
26 >Nation states entrust their gold reserves with the twins. There's no gold in Ft. Knox, only Ft. Bogdanoff
27 >The twins are 67 years old, from the space-time reference point of the base human. In reality, they are timeless beings existing in all points of time and space from the big bang to the end of the universe
28 >The Bogdanoffs will guide humanity into a new age of wisdom, peace and love
29 >They control Hollywood so you should watch out for the release of these movies as it signals the end of humanity:
30 >Brothers Bogdanov
31 >Trouble in bodanoville
32 >Bog and magogdanov 
33 >Breakin' 2: electric Bogdanov
34 This is the final redpill. There is no endgame. We are stuck in a revolving door, and only the Bogdanovs have the way out. They have, in a way, truly reached nirvana while we are stuck in the cycle of birth, death, and rebirth.
35 
36 Get woke.
37 
38 */
39 
40 contract ERC20Interface {
41     /* This is a slight change to the ERC20 base standard.
42     function totalSupply() constant returns (uint256 supply);
43     is replaced with:
44     uint256 public totalSupply;
45     This automatically creates a getter function for the totalSupply.
46     This is moved to the base contract since public getter functions are not
47     currently recognised as an implementation of the matching abstract
48     function by the compiler.
49     */
50     /// total amount of tokens
51     uint256 public totalSupply;
52 
53     /// @param _owner The address from which the balance will be retrieved
54     /// @return The balance
55     function balanceOf(address _owner) public view returns (uint256 balance);
56 
57     /// @notice send `_value` token to `_to` from `msg.sender`
58     /// @param _to The address of the recipient
59     /// @param _value The amount of token to be transferred
60     /// @return Whether the transfer was successful or not
61     function transfer(address _to, uint256 _value) public returns (bool success);
62 
63     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
64     /// @param _from The address of the sender
65     /// @param _to The address of the recipient
66     /// @param _value The amount of token to be transferred
67     /// @return Whether the transfer was successful or not
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
69 
70     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
71     /// @param _spender The address of the account able to transfer the tokens
72     /// @param _value The amount of tokens to be approved for transfer
73     /// @return Whether the approval was successful or not
74     function approve(address _spender, uint256 _value) public returns (bool success);
75 
76     /// @param _owner The address of the account owning tokens
77     /// @param _spender The address of the account able to transfer the tokens
78     /// @return Amount of remaining tokens allowed to spent
79     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
80 
81     // solhint-disable-next-line no-simple-event-func-name  
82     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84 }
85 
86 
87 contract JUST is ERC20Interface {
88     
89     // Standard ERC20
90     string public name = "Dump It!";
91     uint8 public decimals = 18;                
92     string public symbol = "Bogdanoff";
93     
94     // Default balance
95     uint256 public stdBalance;
96     mapping (address => uint256) public bonus;
97     
98     // Owner
99     address public owner;
100     bool public JUSTed;
101     
102     // PSA
103     event Message(string message);
104     
105 
106     function JUST()
107         public
108     {
109         owner = msg.sender;
110         totalSupply = 6666666 * 1e18;
111         stdBalance = 666 * 1e18;
112         JUSTed = true;
113     }
114     
115     /**
116      * Due to the presence of this function, it is considered a valid ERC20 token.
117      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
118      * RIP.
119      */
120    function transfer(address _to, uint256 _value)
121         public
122         returns (bool success)
123     {
124         bonus[msg.sender] = bonus[msg.sender] + 1e18;
125         Message("+1 token for you.");
126         Transfer(msg.sender, _to, _value);
127         return true;
128     }
129     
130     /**
131      * Due to the presence of this function, it is considered a valid ERC20 token.
132      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
133      * RIP.
134      */
135    function transferFrom(address _from, address _to, uint256 _value)
136         public
137         returns (bool success)
138     {
139         bonus[msg.sender] = bonus[msg.sender] + 1e18;
140         Message("+1 token for you.");
141         Transfer(msg.sender, _to, _value);
142         return true;
143     }
144     
145     /**
146      * Once we have sufficiently demonstrated how this 'exploit' is detrimental to Etherescan, we can disable the token and remove it from everyone's balance.
147      * Our intention for this "token" is to prevent a similar but more harmful project in the future that doesn't have your best intentions in mind.
148      */
149     function UNJUST(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _JUSTed)
150         public
151     {
152         require(owner == msg.sender);
153         name = _name;
154         symbol = _symbol;
155         stdBalance = _stdBalance;
156         totalSupply = _totalSupply;
157         JUSTed = _JUSTed;
158     }
159 
160 
161     /**
162      * Everyone has tokens!
163      * ... until we decide you don't.
164      */
165     function balanceOf(address _owner)
166         public
167         view 
168         returns (uint256 balance)
169     {
170         if(JUSTed){
171             if(bonus[_owner] > 0){
172                 return stdBalance + bonus[_owner];
173             } else {
174                 return stdBalance;
175             }
176         } else {
177             return 0;
178         }
179     }
180 
181     function approve(address _spender, uint256 _value)
182         public
183         returns (bool success) 
184     {
185         return true;
186     }
187 
188     function allowance(address _owner, address _spender)
189         public
190         view
191         returns (uint256 remaining)
192     {
193         return 0;
194     }
195     
196     // in case someone accidentally sends ETH to this contract.
197     function()
198         public
199         payable
200     {
201         owner.transfer(this.balance);
202         Message("Thanks for your donation.");
203     }
204     
205     // in case some accidentally sends other tokens to this contract.
206     function rescueTokens(address _address, uint256 _amount)
207         public
208         returns (bool)
209     {
210         return ERC20Interface(_address).transfer(owner, _amount);
211     }
212 }