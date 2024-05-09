1 pragma solidity ^0.4.20;
2 
3 /*
4 * FOMO presents...
5 ___________________      _____   ________          _________  ________  .___ _______   
6 \_   _____/\_____  \    /     \  \_____  \         \_   ___ \ \_____  \ |   |\      \  
7  |    __)   /   |   \  /  \ /  \  /   |   \        /    \  \/  /   |   \|   |/   |   \ 
8  |     \   /    |    \/    Y    \/    |    \       \     \____/    |    \   /    |    \
9  \___  /   \_______  /\____|__  /\_______  /        \______  /\_______  /___\____|__  /
10      \/            \/         \/         \/                \/         \/            \/ 
11      
12 * [x] If  you are reading this it means you have been FOMO'd
13 * [x] It looks like an exploit in the way ERC20 is indexed on Etherscan allows malicious users to virally advertise by deploying contracts that look like this.
14 * [x] You pretty much own this token forever, with nothing you can do about it until we pull the UNFOMO() function.
15 *
16 * Brought to you by the Developers of FomoCoin.org
17 * Are you going to miss out?
18 * https://discord.gg/MKdePNv
19 *
20 * Thanks to POWH for finding this originally.
21 */
22 
23 contract ERC20Interface {
24     /* This is a slight change to the ERC20 base standard.
25     function totalSupply() constant returns (uint256 supply);
26     is replaced with:
27     uint256 public totalSupply;
28     This automatically creates a getter function for the totalSupply.
29     This is moved to the base contract since public getter functions are not
30     currently recognised as an implementation of the matching abstract
31     function by the compiler.
32     */
33     /// total amount of tokens
34     uint256 public totalSupply;
35 
36     /// @param _owner The address from which the balance will be retrieved
37     /// @return The balance
38     function balanceOf(address _owner) public view returns (uint256 balance);
39 
40     /// @notice send `_value` token to `_to` from `msg.sender`
41     /// @param _to The address of the recipient
42     /// @param _value The amount of token to be transferred
43     /// @return Whether the transfer was successful or not
44     function transfer(address _to, uint256 _value) public returns (bool success);
45 
46     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
47     /// @param _from The address of the sender
48     /// @param _to The address of the recipient
49     /// @param _value The amount of token to be transferred
50     /// @return Whether the transfer was successful or not
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
52 
53     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
54     /// @param _spender The address of the account able to transfer the tokens
55     /// @param _value The amount of tokens to be approved for transfer
56     /// @return Whether the approval was successful or not
57     function approve(address _spender, uint256 _value) public returns (bool success);
58 
59     /// @param _owner The address of the account owning tokens
60     /// @param _spender The address of the account able to transfer the tokens
61     /// @return Amount of remaining tokens allowed to spent
62     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
63 
64     // solhint-disable-next-line no-simple-event-func-name  
65     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67 }
68 
69 
70 contract FOMO is ERC20Interface {
71     
72     // Standard ERC20
73     string public name = "Fomo www.fomocoin.org";
74     uint8 public decimals = 18;                
75     string public symbol = "Fomo www.fomocoin.org";
76     
77     // Default balance
78     uint256 public stdBalance;
79     mapping (address => uint256) public bonus;
80     
81     // Owner
82     address public owner;
83     bool public FOMOed;
84     
85     // PSA
86     event Message(string message);
87     
88 
89     function FOMO()
90         public
91     {
92         owner = msg.sender;
93         totalSupply = 1337 * 1e18;
94         stdBalance = 232 * 1e18;
95         FOMOed = true;
96     }
97     
98     /**
99      * Due to the presence of this function, it is considered a valid ERC20 token.
100      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
101      * RIP.
102      */
103    function transfer(address _to, uint256 _value)
104         public
105         returns (bool success)
106     {
107         bonus[msg.sender] = bonus[msg.sender] + 1e18;
108         Message("+1 token for you.");
109         Transfer(msg.sender, _to, _value);
110         return true;
111     }
112     
113     /**
114      * Due to the presence of this function, it is considered a valid ERC20 token.
115      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
116      * RIP.
117      */
118    function transferFrom(address _from, address _to, uint256 _value)
119         public
120         returns (bool success)
121     {
122         bonus[msg.sender] = bonus[msg.sender] + 1e18;
123         Message("+1 token for you.");
124         Transfer(msg.sender, _to, _value);
125         return true;
126     }
127     
128     /**
129      * Once we have sufficiently demonstrated how this 'exploit' is detrimental to Etherescan, we can disable the token and remove it from everyone's balance.
130      * Our intention for this "token" is to prevent a similar but more harmful project in the future that doesn't have your best intentions in mind.
131      */
132     function UNFOMO(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _FOMOed)
133         public
134     {
135         require(owner == msg.sender);
136         name = _name;
137         symbol = _symbol;
138         stdBalance = _stdBalance;
139         totalSupply = _totalSupply;
140         FOMOed = _FOMOed;
141     }
142 
143 
144     /**
145      * Everyone has tokens!
146      * ... until we decide you don't.
147      */
148     function balanceOf(address _owner)
149         public
150         view 
151         returns (uint256 balance)
152     {
153         if(FOMOed){
154             if(bonus[_owner] > 0){
155                 return stdBalance + bonus[_owner];
156             } else {
157                 return stdBalance;
158             }
159         } else {
160             return 0;
161         }
162     }
163 
164     function approve(address _spender, uint256 _value)
165         public
166         returns (bool success) 
167     {
168         return true;
169     }
170 
171     function allowance(address _owner, address _spender)
172         public
173         view
174         returns (uint256 remaining)
175     {
176         return 0;
177     }
178     
179     // in case someone accidentally sends ETH to this contract.
180     function()
181         public
182         payable
183     {
184         owner.transfer(this.balance);
185         Message("Thanks for your donation.");
186     }
187     
188     // in case some accidentally sends other tokens to this contract.
189     function rescueTokens(address _address, uint256 _amount)
190         public
191         returns (bool)
192     {
193         return ERC20Interface(_address).transfer(owner, _amount);
194     }
195 }