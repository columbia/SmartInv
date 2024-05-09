1 pragma solidity ^0.4.21;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 
21 contract TokenERC20 {
22     // Public variables of the token
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     // 18 decimals is the strongly suggested default, avoid changing it
27     uint256 public totalSupply;
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31 
32     // This generates a public event on the blockchain that will notify clients
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     // This notifies clients about the amount burnt
36     event Burn(address indexed from, uint256 value);
37        
38     
39     /**
40      * Constrctor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     function TokenERC20(
45         uint256 initialSupply,
46         string tokenName,
47         string tokenSymbol
48     ) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
50         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
51         name = tokenName;                                   // Set the name for display purposes
52         symbol = tokenSymbol;                               // Set the symbol for display purposes
53     }
54 
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         // Prevent transfer to 0x0 address. Use burn() instead
60         require(_to != 0x0);
61         // Check if the sender has enough
62         require(balanceOf[_from] >= _value);
63         // Check for overflows
64         require(balanceOf[_to] + _value > balanceOf[_to]);
65         // Save this for an assertion in the future
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         emit Transfer(_from, _to, _value);
72         // Asserts are used to use static analysis to find bugs in your code. They should never fail
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public returns (bool success) {
85         _transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     /**
90      * Destroy tokens
91      *
92      * Remove `_value` tokens from the system irreversibly
93      *
94      * @param _value the amount of money to burn
95      */
96     function burn(uint256 _value) public returns (bool success) {
97         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
98         balanceOf[msg.sender] -= _value;            // Subtract from the sender
99         totalSupply -= _value;                      // Updates totalSupply
100         emit Burn(msg.sender, _value);
101         return true;
102     }
103 
104 }
105 
106 /******************************************/
107 /*       ADVANCED TOKEN STARTS HERE       */
108 /******************************************/
109 
110 contract ONTOPToken is owned, TokenERC20 {
111     struct frozenInfo {
112        bool frozenAccount;
113        bool frozenAccBytime;
114        // uint time_stfrozen;
115        uint time_end_frozen;
116        uint time_last_query;
117        uint256 frozen_total;
118        // uint256 realsestep;
119     }
120     
121     struct frozenInfo_prv {
122        uint256 realsestep;
123     }
124     
125     uint private constant timerate = 1;
126     string public declaration = "frozenInfos will reflush by function QueryFrozenCoins and transfer.";
127     // mapping (address => bool) public frozenAccount;
128     mapping (address => frozenInfo) public frozenInfos;
129     mapping (address => frozenInfo_prv) private frozenInfos_prv;
130     
131     /* This generates a public event on the blockchain that will notify clients */
132     event FrozenFunds(address target, bool frozen);
133 
134     // This notifies clients about the frozen coin
135     event FrozenTotal(address indexed from, uint256 value);
136     /* Initializes contract with initial supply tokens to the creator of the contract */
137     function ONTOPToken(
138         uint256 initialSupply,
139         string tokenName,
140         string tokenSymbol
141     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
142     
143     function _resetFrozenInfo(address target) internal {
144        frozenInfos[target].frozen_total = 0;
145        frozenInfos[target].time_end_frozen = 0;
146        frozenInfos_prv[target].realsestep = 0;
147        frozenInfos[target].time_last_query = 0;
148        frozenInfos[target].frozenAccBytime = false; 
149     }
150     
151     function _refulshFrozenInfo(address target) internal {
152        if(frozenInfos[target].frozenAccBytime) 
153         {
154             uint nowtime = now ;// + 60*60*24*365*5 ;
155             frozenInfos[target].time_last_query = nowtime;
156             if(nowtime>=frozenInfos[target].time_end_frozen)
157             {
158                _resetFrozenInfo(target);              
159             }
160             else
161             {
162                uint stepcnt = frozenInfos[target].time_end_frozen - nowtime;
163                uint256 releasecoin = stepcnt * frozenInfos_prv[target].realsestep;
164                if(frozenInfos[target].frozen_total<=releasecoin)
165                   _resetFrozenInfo(target);
166                else
167                {
168                   frozenInfos[target].frozen_total=releasecoin;
169                }
170             }
171         }       
172     }
173     
174     /* Internal transfer, only can be called by this contract */
175     
176     function _transfer(address _from, address _to, uint _value) internal {
177         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
178         require (balanceOf[_from] >= _value);               // Check if the sender has enough
179         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
180         // require(!frozenAccount[_from]);                     // Check if sender is frozen
181         // require(!frozenAccount[_to]);                       // Check if recipient is frozen
182         require(!frozenInfos[_from].frozenAccount);                     // Check if sender is frozen
183         require(!frozenInfos[_to].frozenAccount);                       // Check if recipient is frozen
184         require(!frozenInfos[_to].frozenAccBytime); 
185                 
186         if(frozenInfos[_from].frozenAccBytime) 
187         {
188             _refulshFrozenInfo(_from);
189             if(frozenInfos[_from].frozenAccBytime)
190             {
191                if((balanceOf[_from]-_value)<=frozenInfos[_from].frozen_total)
192                    require(false);
193             }
194         }
195         
196         balanceOf[_from] -= _value;                         // Subtract from the sender
197         balanceOf[_to] += _value;                           // Add the same to the recipient
198         emit Transfer(_from, _to, _value);
199     }
200 
201     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
202     /// @param target Address to be frozen
203     /// @param freeze either to freeze it or not
204     function freezeAccount(address target, bool freeze) onlyOwner public {
205         // frozenAccount[target] = freeze;
206         frozenInfos[target].frozenAccount = freeze;
207         emit FrozenFunds(target, freeze);
208     }
209     
210     function freezeAccountByTime(address target, uint time) onlyOwner public {
211         // frozenAccount[target] = freeze;
212         require (target != 0x0);
213         require (balanceOf[target] >= 1); 
214         require(!frozenInfos[target].frozenAccBytime);
215         require (time >0);
216         frozenInfos[target].frozenAccBytime = true;
217         uint nowtime = now;
218         frozenInfos[target].time_end_frozen = nowtime + time * timerate;
219         frozenInfos[target].time_last_query = nowtime;
220         frozenInfos[target].frozen_total = balanceOf[target];
221         frozenInfos_prv[target].realsestep = frozenInfos[target].frozen_total / (time * timerate);  
222         require (frozenInfos_prv[target].realsestep>0);      
223         emit FrozenTotal(target, frozenInfos[target].frozen_total);
224     }    
225     
226     function UnfreezeAccountByTime(address target) onlyOwner public {
227         _resetFrozenInfo(target);
228         emit FrozenTotal(target, frozenInfos[target].frozen_total);
229     }
230     
231     function QueryFrozenCoins(address _from) public returns (uint256 total) {
232         require (_from != 0x0);
233         require(frozenInfos[_from].frozenAccBytime);
234         _refulshFrozenInfo(_from);        
235         emit FrozenTotal(_from, frozenInfos[_from].frozen_total);
236         return frozenInfos[_from].frozen_total;
237     }
238 
239 }