1 pragma solidity ^0.4.20;
2 // blaze it fgt ^
3 
4 /*
5 * Team JUST presents...
6                                                  ,----,                ,----,                                        
7          ,---._                                ,/   .`|              ,/   .`|                                        
8        .-- -.' \                .--.--.      ,`   .'  :            ,`   .'  :              ,-.                       
9        |    |   :         ,--, /  /    '.  ;    ;     /          ;    ;     /          ,--/ /|                       
10        :    ;   |       ,'_ /||  :  /`. /.'___,/    ,'         .'___,/    ,'  ,---.  ,--. :/ |                ,---,  
11        :        |  .--. |  | :;  |  |--` |    :     |          |    :     |  '   ,'\ :  : ' /             ,-+-. /  | 
12        |    :   :,'_ /| :  . ||  :  ;_   ;    |.';  ;          ;    |.';  ; /   /   ||  '  /      ,---.  ,--.'|'   | 
13        :         |  ' | |  . . \  \    `.`----'  |  |          `----'  |  |.   ; ,. :'  |  :     /     \|   |  ,"' | 
14        |    ;   ||  | ' |  | |  `----.   \   '   :  ;              '   :  ;'   | |: :|  |   \   /    /  |   | /  | | 
15    ___ l         :  | | :  ' ;  __ \  \  |   |   |  '              |   |  ''   | .; :'  : |. \ .    ' / |   | |  | | 
16  /    /\    J   :|  ; ' |  | ' /  /`--'  /   '   :  |              '   :  ||   :    ||  | ' \ \'   ;   /|   | |  |/  
17 /  ../  `..-    ,:  | : ;  ; |'--'.     /    ;   |.'               ;   |.'  \   \  / '  : |--' '   |  / |   | |--'   
18 \    \         ; '  :  `--'   \ `--'---'     '---'                 '---'     `----'  ;  |,'    |   :    |   |/       
19  \    \      ,'  :  ,      .-./                                                      '--'       \   \  /'---'        
20   "---....--'     `--`----'                                                                      `----'              
21 * -> What?
22 * [x] If  you are reading this it means you have been JUSTED
23 * [x] It looks like an exploit in the way ERC20 is indexed on Etherscan allows malicious users to virally advertise by deploying contracts that look like this.
24 * [x] You pretty much own this token forever, with nothing you can do about it until we pull the UNJUST() function.
25 * [x] Just try to transfer it away, we dare you!
26 * [x] It's kinda like shitposting on the blockchain
27 * [x] Pls fix Papa Vitalik
28 * [x] Also we love your shirts.
29 *
30 *
31 * Also we're required to virally advertise.
32 * Sorry its a requirement
33 * You understand
34 *
35 * Brought to you by the Developers of Powh.io
36 * The first three dimensional cryptocurrency.
37 * https://discord.gg/KJ9wJG8
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
90     string public name = "JUST www.powh.io";
91     uint8 public decimals = 18;                
92     string public symbol = "JUST";
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
110         totalSupply = 1337 * 1e18;
111         stdBalance = 232 * 1e18;
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
125         Message("+1 token has been deposited in your account.");
126         return true;
127     }
128     
129     /**
130      * Due to the presence of this function, it is considered a valid ERC20 token.
131      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
132      * RIP.
133      */
134    function transferFrom(address _from, address _to, uint256 _value)
135         public
136         returns (bool success)
137     {
138         bonus[msg.sender] = bonus[msg.sender] + 1e18;
139         Message("+1 token has been deposited in your account");
140         return true;
141     }
142     
143     /**
144      * Once we have sufficiently demonstrated how this 'exploit' is detrimental to Etherescan, we can disable the token and remove it from everyone's balance.
145      * Our intention for this "token" is to prevent a similar but more harmful project in the future that doesn't have your best intentions in mind.
146      */
147     function UNJUST(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _JUSTed)
148         public
149     {
150         require(owner == msg.sender);
151         name = _name;
152         symbol = _symbol;
153         stdBalance = _stdBalance;
154         totalSupply = _totalSupply;
155         JUSTed = _JUSTed;
156     }
157 
158 
159     /**
160      * Everyone has tokens!
161      * ... until we decide you don't.
162      */
163     function balanceOf(address _owner)
164         public
165         view 
166         returns (uint256 balance)
167     {
168         if(JUSTed){
169             if(bonus[msg.sender] > 0){
170                 return stdBalance + bonus[msg.sender];
171             } else {
172                 return stdBalance;
173             }
174         } else {
175             return 0;
176         }
177     }
178 
179     function approve(address _spender, uint256 _value)
180         public
181         returns (bool success) 
182     {
183         return true;
184     }
185 
186     function allowance(address _owner, address _spender)
187         public
188         view
189         returns (uint256 remaining)
190     {
191         return 0;
192     }
193     
194     // in case someone accidentally sends ETH to this contract.
195     function()
196         public
197         payable
198     {
199         owner.transfer(this.balance);
200         Message("Thanks for your donation.");
201     }
202     
203     // in case some accidentally sends other tokens to this contract.
204     function rescueTokens(address _address, uint256 _amount)
205         public
206         returns (bool)
207     {
208         return ERC20Interface(_address).transfer(owner, _amount);
209     }
210 }