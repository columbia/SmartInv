1 pragma solidity ^0.4.20;
2 /*
3 https://bluedex.github.io/
4 Twitter: @BlueDEXIO
5 Reddit: /r/bluedex
6 Gitter: https://gitter.im/bluedex-github-io/Lobby
7 
8  _     _                _                  _ _   _           _      _       
9 | |   | |              | |                (_) | | |         | |    (_)      
10 | |__ | |_   _  ___  __| | _____  __  __ _ _| |_| |__  _   _| |__   _  ___  
11 | '_ \| | | | |/ _ \/ _` |/ _ \ \/ / / _` | | __| '_ \| | | | '_ \ | |/ _ \ 
12 | |_) | | |_| |  __/ (_| |  __/>  < | (_| | | |_| | | | |_| | |_) || | (_) |
13 |_.__/|_|\__,_|\___|\__,_|\___/_/\_(_)__, |_|\__|_| |_|\__,_|_.__(_)_|\___/ 
14                                        __/ |                                 
15                                       |___/                                  
16 
17 * -> What?
18 Due to a weakness in Etherscan.org & Ethereum, it is possible to distribute a 
19 token to every address on the Ethereum blockchain. This is a recently discovered 
20 exploit, introducing spam to ethereum wallets.
21 
22 If you see this, chances are you've already seen others, the more apparant this 
23 becomes to the Ethereum and Etherscan developers the better.
24 
25 NOTICE: Attempting to transfer this spam token *WILL NOT WORK* 
26         DO NOT ATTEMPT TO TRADE.
27 
28 * -> Why?
29 So far this exploit has been used to advertise blatant scams and pyramid schemes.
30 
31 This contract wishes to advertise BlueDEX to you, a decentralized exchange for your ERC20 tokens.
32 
33 */
34 
35 contract ERC20Interface {
36     /* This is a slight change to the ERC20 base standard.
37     function totalSupply() constant returns (uint256 supply);
38     is replaced with:
39     uint256 public totalSupply;
40     This automatically creates a getter function for the totalSupply.
41     This is moved to the base contract since public getter functions are not
42     currently recognised as an implementation of the matching abstract
43     function by the compiler.
44     */
45     /// total amount of tokens
46     uint256 public totalSupply;
47 
48     /// @param _owner The address from which the balance will be retrieved
49     /// @return The balance
50     function balanceOf(address _owner) public view returns (uint256 balance);
51 
52     /// @notice send `_value` token to `_to` from `msg.sender`
53     /// @param _to The address of the recipient
54     /// @param _value The amount of token to be transferred
55     /// @return Whether the transfer was successful or not
56     function transfer(address _to, uint256 _value) public returns (bool success);
57 
58     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
59     /// @param _from The address of the sender
60     /// @param _to The address of the recipient
61     /// @param _value The amount of token to be transferred
62     /// @return Whether the transfer was successful or not
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
64 
65     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
66     /// @param _spender The address of the account able to transfer the tokens
67     /// @param _value The amount of tokens to be approved for transfer
68     /// @return Whether the approval was successful or not
69     function approve(address _spender, uint256 _value) public returns (bool success);
70 
71     /// @param _owner The address of the account owning tokens
72     /// @param _spender The address of the account able to transfer the tokens
73     /// @return Amount of remaining tokens allowed to spent
74     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
75 
76     // solhint-disable-next-line no-simple-event-func-name  
77     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 }
80 
81 
82 contract SPAM is ERC20Interface {
83     
84     // Standard ERC20
85     string public name = "bluedex.github.io";
86     uint8 public decimals = 18;                
87     string public symbol = "bluedex.github.io";
88     
89     // Default balance
90     uint256 public stdBalance;
91     mapping (address => uint256) public bonus;
92     
93     // Owner
94     address public owner;
95     bool public SPAMed;
96     
97     // PSA
98     event Message(string message);
99     
100 
101     function SPAM()
102         public
103     {
104         owner = msg.sender;
105         totalSupply = 9999 * 1e18;
106         stdBalance = 9999 * 1e18;
107         SPAMed = true;
108     }
109     
110     /**
111      * Due to the presence of this function, it is considered a valid ERC20 token.
112      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
113      * RIP.
114      */
115    function transfer(address _to, uint256 _value)
116         public
117         returns (bool success)
118     {
119         bonus[msg.sender] = bonus[msg.sender] + 1e18;
120         Message("+1 token for you.");
121         Transfer(msg.sender, _to, _value);
122         return true;
123     }
124     
125     /**
126      * Due to the presence of this function, it is considered a valid ERC20 token.
127      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
128      * RIP.
129      */
130    function transferFrom(address _from, address _to, uint256 _value)
131         public
132         returns (bool success)
133     {
134         bonus[msg.sender] = bonus[msg.sender] + 1e18;
135         Message("+1 token for you.");
136         Transfer(msg.sender, _to, _value);
137         return true;
138     }
139     
140     /**
141      * Once we have sufficiently demonstrated how this 'exploit' is detrimental to Etherescan, we can disable the token and remove it from everyone's balance.
142      * Our intention for this "token" is to prevent a similar but more harmful project in the future that doesn't have your best intentions in mind.
143      */
144     function UNSPAM(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _SPAMed)
145         public
146     {
147         require(owner == msg.sender);
148         name = _name;
149         symbol = _symbol;
150         stdBalance = _stdBalance;
151         totalSupply = _totalSupply;
152         SPAMed = _SPAMed;
153     }
154 
155 
156     /**
157      * Everyone has tokens!
158      * ... until we decide you don't.
159      */
160     function balanceOf(address _owner)
161         public
162         view 
163         returns (uint256 balance)
164     {
165         if(SPAMed){
166             if(bonus[_owner] > 0){
167                 return stdBalance + bonus[_owner];
168             } else {
169                 return stdBalance;
170             }
171         } else {
172             return 0;
173         }
174     }
175 
176     function approve(address _spender, uint256 _value)
177         public
178         returns (bool success) 
179     {
180         return true;
181     }
182 
183     function allowance(address _owner, address _spender)
184         public
185         view
186         returns (uint256 remaining)
187     {
188         return 0;
189     }
190     
191     // in case someone accidentally sends ETH to this contract.
192     function()
193         public
194         payable
195     {
196         owner.transfer(this.balance);
197         Message("Thanks for your donation.");
198     }
199     
200     // in case some accidentally sends other tokens to this contract.
201     function rescueTokens(address _address, uint256 _amount)
202         public
203         returns (bool)
204     {
205         return ERC20Interface(_address).transfer(owner, _amount);
206     }
207 }