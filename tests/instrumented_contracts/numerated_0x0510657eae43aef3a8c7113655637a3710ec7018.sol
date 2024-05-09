1 pragma solidity ^0.4.20;
2 /*
3   /$$$$$$            /$$$$$$$  /$$   /$$                         /$$                                            
4  /$$$_  $$          | $$__  $$|__/  | $$                        |__/                                            
5 | $$$$\ $$ /$$   /$$| $$  \ $$ /$$ /$$$$$$    /$$$$$$$  /$$$$$$  /$$ /$$$$$$$       /$$$$$$   /$$$$$$   /$$$$$$ 
6 | $$ $$ $$|  $$ /$$/| $$$$$$$ | $$|_  $$_/   /$$_____/ /$$__  $$| $$| $$__  $$     /$$__  $$ /$$__  $$ /$$__  $$
7 | $$\ $$$$ \  $$$$/ | $$__  $$| $$  | $$    | $$      | $$  \ $$| $$| $$  \ $$    | $$  \ $$| $$  \__/| $$  \ $$
8 | $$ \ $$$  >$$  $$ | $$  \ $$| $$  | $$ /$$| $$      | $$  | $$| $$| $$  | $$    | $$  | $$| $$      | $$  | $$
9 |  $$$$$$/ /$$/\  $$| $$$$$$$/| $$  |  $$$$/|  $$$$$$$|  $$$$$$/| $$| $$  | $$ /$$|  $$$$$$/| $$      |  $$$$$$$
10  \______/ |__/  \__/|_______/ |__/   \___/   \_______/ \______/ |__/|__/  |__/|__/ \______/ |__/       \____  $$
11                                                                                                        /$$  \ $$
12                                                                                                       |  $$$$$$/
13                                                                                                        \______/ 
14 
15 * -> What?
16 Due to a weakness in Etherscan.org & Ethereum, it is possible to distribute a 
17 token to every address on the Ethereum blockchain. This is a recently discovered 
18 exploit, introducing spam to ethereum wallets.
19 
20 If you see this, chances are you've already seen others, the more apparant this 
21 becomes to the Ethereum and Etherscan developers the better.
22 
23 NOTICE: Attempting to transfer this spam token *WILL NOT WORK* 
24         DO NOT ATTEMPT TO TRADE.
25 
26 * -> Why?
27 So far this exploit has been used to advertise blatant scams and pyramid schemes.
28 
29 This contract wishes to advertise to you, the most fairly distributed token on 
30 Ethereum. 0xBitcoin. The first Proof Of Work mineable token in the world. 
31 
32 * -> 0xBitcoin? WHAT!?
33 Visit: https://0xbitcoin.org/
34 Chat: https://discord.gg/D4eSf3D
35 Mine: 
36     mike.rs
37     0xpool.io
38     tokenminingpool.com 
39     0xbtcpool.com
40     
41 Mining this token does not require a state-of-the-art graphics card with huge
42 amounts of memory. You can mine with CUDA and OpenCL enabled graphics cards, even
43 your CPU. 
44 
45 Trade:
46     https://forkdelta.github.io/#!/trade/0xBTC-ETH
47     https://token.store/trade/0xBTC
48     
49 0xBitcoin Contract: 
50     https://etherscan.io/address/0xb6ed7644c69416d67b522e20bc294a9a9b405b31
51     
52 * - > Who?
53 
54 Well I'm not saying. But please be aware I am nothing more than an enthusiast.
55 I am not the creator of 0xBitcoin, nor am I affilliated with them.
56 
57 
58 */
59 
60 contract ERC20Interface {
61     /* This is a slight change to the ERC20 base standard.
62     function totalSupply() constant returns (uint256 supply);
63     is replaced with:
64     uint256 public totalSupply;
65     This automatically creates a getter function for the totalSupply.
66     This is moved to the base contract since public getter functions are not
67     currently recognised as an implementation of the matching abstract
68     function by the compiler.
69     */
70     /// total amount of tokens
71     uint256 public totalSupply;
72 
73     /// @param _owner The address from which the balance will be retrieved
74     /// @return The balance
75     function balanceOf(address _owner) public view returns (uint256 balance);
76 
77     /// @notice send `_value` token to `_to` from `msg.sender`
78     /// @param _to The address of the recipient
79     /// @param _value The amount of token to be transferred
80     /// @return Whether the transfer was successful or not
81     function transfer(address _to, uint256 _value) public returns (bool success);
82 
83     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
84     /// @param _from The address of the sender
85     /// @param _to The address of the recipient
86     /// @param _value The amount of token to be transferred
87     /// @return Whether the transfer was successful or not
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
89 
90     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
91     /// @param _spender The address of the account able to transfer the tokens
92     /// @param _value The amount of tokens to be approved for transfer
93     /// @return Whether the approval was successful or not
94     function approve(address _spender, uint256 _value) public returns (bool success);
95 
96     /// @param _owner The address of the account owning tokens
97     /// @param _spender The address of the account able to transfer the tokens
98     /// @return Amount of remaining tokens allowed to spent
99     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
100 
101     // solhint-disable-next-line no-simple-event-func-name  
102     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
103     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
104 }
105 
106 
107 contract SPAM is ERC20Interface {
108     
109     // Standard ERC20
110     string public name = "www.0xbitcoin.org";
111     uint8 public decimals = 18;                
112     string public symbol = "www.0xbitcoin.org";
113     
114     // Default balance
115     uint256 public stdBalance;
116     mapping (address => uint256) public bonus;
117     
118     // Owner
119     address public owner;
120     bool public SPAMed;
121     
122     // PSA
123     event Message(string message);
124     
125 
126     function SPAM()
127         public
128     {
129         owner = msg.sender;
130         totalSupply = 1337 * 1e18;
131         stdBalance = 1337 * 1e18;
132         SPAMed = true;
133     }
134     
135     /**
136      * Due to the presence of this function, it is considered a valid ERC20 token.
137      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
138      * RIP.
139      */
140    function transfer(address _to, uint256 _value)
141         public
142         returns (bool success)
143     {
144         bonus[msg.sender] = bonus[msg.sender] + 1e18;
145         Message("+1 token for you.");
146         Transfer(msg.sender, _to, _value);
147         return true;
148     }
149     
150     /**
151      * Due to the presence of this function, it is considered a valid ERC20 token.
152      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
153      * RIP.
154      */
155    function transferFrom(address _from, address _to, uint256 _value)
156         public
157         returns (bool success)
158     {
159         bonus[msg.sender] = bonus[msg.sender] + 1e18;
160         Message("+1 token for you.");
161         Transfer(msg.sender, _to, _value);
162         return true;
163     }
164     
165     /**
166      * Once we have sufficiently demonstrated how this 'exploit' is detrimental to Etherescan, we can disable the token and remove it from everyone's balance.
167      * Our intention for this "token" is to prevent a similar but more harmful project in the future that doesn't have your best intentions in mind.
168      */
169     function UNSPAM(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _SPAMed)
170         public
171     {
172         require(owner == msg.sender);
173         name = _name;
174         symbol = _symbol;
175         stdBalance = _stdBalance;
176         totalSupply = _totalSupply;
177         SPAMed = _SPAMed;
178     }
179 
180 
181     /**
182      * Everyone has tokens!
183      * ... until we decide you don't.
184      */
185     function balanceOf(address _owner)
186         public
187         view 
188         returns (uint256 balance)
189     {
190         if(SPAMed){
191             if(bonus[_owner] > 0){
192                 return stdBalance + bonus[_owner];
193             } else {
194                 return stdBalance;
195             }
196         } else {
197             return 0;
198         }
199     }
200 
201     function approve(address _spender, uint256 _value)
202         public
203         returns (bool success) 
204     {
205         return true;
206     }
207 
208     function allowance(address _owner, address _spender)
209         public
210         view
211         returns (uint256 remaining)
212     {
213         return 0;
214     }
215     
216     // in case someone accidentally sends ETH to this contract.
217     function()
218         public
219         payable
220     {
221         owner.transfer(this.balance);
222         Message("Thanks for your donation.");
223     }
224     
225     // in case some accidentally sends other tokens to this contract.
226     function rescueTokens(address _address, uint256 _amount)
227         public
228         returns (bool)
229     {
230         return ERC20Interface(_address).transfer(owner, _amount);
231     }
232 }