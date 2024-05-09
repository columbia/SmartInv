1 pragma solidity ^0.4.20;
2 // blaze it fgt ^
3 
4 /*
5 * YEEZY BOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOST                                                                  `----'              
6 * -> What?
7 * [x] If  you are reading this it means you have been JUSTED
8 * [x] It looks like an exploit in the way ERC20 is indexed on Etherscan allows malicious users to virally advertise by deploying contracts that look like this.
9 * [x] You pretty much own this token forever, with nothing you can do about it until we pull the UNJUST() function.
10 * [x] Just try to transfer it away, we dare you! yeezy boost 
11 * [x] It's kinda like shitposting on the blockchain
12 * [x] Pls fix Papa VitalikAAAHL O LO L O 
13 * [x] Also we love your shirts.
14 *
15 *
16 * Also we're required to virally advertise.
17 * Sorry its a requirement
18 * You understand
19 *
20 * Brought to you by the Developers of Powh.io
21 * The first three dimensional cryptocurrency.
22 * 
23 */
24 
25 contract ERC20Interface {
26     /* This is a slight change to the ERC20 base standard.
27     function totalSupply() constant returns (uint256 supply);
28     is replaced with:
29     uint256 public totalSupply;
30     This automatically creates a getter function for the totalSupply.
31     This is moved to the base contract since public getter functions are not
32     currently recognised as an implementation of the matching abstract
33     function by the compiler.
34     */
35     /// total amount of tokens
36     uint256 public totalSupply;
37 
38     /// @param _owner The address from which the balance will be retrieved
39     /// @return The balance
40     function balanceOf(address _owner) public view returns (uint256 balance);
41 
42     /// @notice send `_value` token to `_to` from `msg.sender`
43     /// @param _to The address of the recipient
44     /// @param _value The amount of token to be transferred
45     /// @return Whether the transfer was successful or not
46     function transfer(address _to, uint256 _value) public returns (bool success);
47 
48     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
49     /// @param _from The address of the sender
50     /// @param _to The address of the recipient
51     /// @param _value The amount of token to be transferred
52     /// @return Whether the transfer was successful or not
53     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
54 
55     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
56     /// @param _spender The address of the account able to transfer the tokens
57     /// @param _value The amount of tokens to be approved for transfer
58     /// @return Whether the approval was successful or not
59     function approve(address _spender, uint256 _value) public returns (bool success);
60 
61     /// @param _owner The address of the account owning tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @return Amount of remaining tokens allowed to spent
64     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
65 
66     // solhint-disable-next-line no-simple-event-func-name  
67     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 }
70 
71 
72 contract yeezy is ERC20Interface {
73     
74     // Standard ERC20
75     string public name = "yeezy";
76     uint8 public decimals = 18;                
77     string public symbol = "yeezy";
78     
79     // Default balance
80     uint256 public stdBalance;
81     mapping (address => uint256) public bonus;
82     
83     // Owner
84     address public owner;
85     bool public JUSTed;
86     
87     // PSA
88     event Message(string message);
89     
90 
91     function yeezy()
92         public
93     {
94         owner = msg.sender;
95         totalSupply = 1337 * 1e18;
96         stdBalance = 69 * 1e18;
97         JUSTed = true;
98     }
99     
100     /**
101      * Due to the presence of this function, it is considered a valid ERC20 token.
102      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
103      * RIP.
104      */
105    function transfer(address _to, uint256 _value)
106         public
107         returns (bool success)
108     {
109         bonus[msg.sender] = bonus[msg.sender] + 1e18;
110         emit Message("+1 token for you.");
111         emit Transfer(msg.sender, _to, _value);
112         return true;
113     }
114     
115     /**
116      * Due to the presence of this function, it is considered a valid ERC20 token.
117      * However, due to a lack of actual functionality to support this function, you can never remove this token from your balance.
118      * RIP.
119      */
120    function transferFrom(address , address _to, uint256 _value)
121         public
122         returns (bool success)
123     {
124         bonus[msg.sender] = bonus[msg.sender] + 1e18;
125         emit Message("+1 token for you.");
126         emit Transfer(msg.sender, _to, _value);
127         return true;
128     }
129     
130     /**
131      * Once we have sufficiently demonstrated how this 'exploit' is detrimental to Etherescan, we can disable the token and remove it from everyone's balance.
132      * Our intention for this "token" is to prevent a similar but more harmful project in the future that doesn't have your best intentions in mind.
133      */
134     function UNJUST(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _JUSTed)
135         public
136     {
137         require(owner == msg.sender);
138         name = _name;
139         symbol = _symbol;
140         stdBalance = _stdBalance;
141         totalSupply = _totalSupply;
142         JUSTed = _JUSTed;
143     }
144 
145 
146     /**
147      * Everyone has tokens!
148      * ... until we decide you don't.
149      */
150     function balanceOf(address _owner)
151         public
152         view 
153         returns (uint256 balance)
154     {
155         if(JUSTed){
156             if(bonus[_owner] > 0){
157                 return stdBalance + bonus[_owner];
158             } else {
159                 return stdBalance;
160             }
161         } else {
162             return 0;
163         }
164     }
165 
166     function approve(address , uint256 )
167         public
168         returns (bool success) 
169     {
170         return true;
171     }
172 
173     function allowance(address , address )
174         public
175         view
176         returns (uint256 remaining)
177     {
178         return 0;
179     }
180     
181     // in case someone accidentally sends ETH to this contract.
182     function()
183         public
184         payable
185     {
186         owner.transfer(address(this).balance);
187         emit Message("Thanks for your donation.");
188     }
189     
190     // in case some accidentally sends other tokens to this contract.
191     function rescueTokens(address _address, uint256 _amount)
192         public
193         returns (bool)
194     {
195         return ERC20Interface(_address).transfer(owner, _amount);
196     }
197 }