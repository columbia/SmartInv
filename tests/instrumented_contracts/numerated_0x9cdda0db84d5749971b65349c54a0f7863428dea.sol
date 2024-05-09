1 pragma solidity ^0.4.18;
2 // Symbol      : VTA
3 // Name        : Vita Token
4 // Total supply: 10 ** 28
5 // Decimals    : 18
6 //import './SafeMath.sol';
7 //import './ERC20Interface.sol';
8 //Sobre vita reward:
9 //El token se crea primero y luego se asigna la dirección de vita reward
10 
11 // ----- Safe Math
12 contract SafeMath {
13     function safeAdd(uint a, uint b) internal pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function safeSub(uint a, uint b) internal pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function safeMul(uint a, uint b) internal pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function safeDiv(uint a, uint b) internal pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 //------------
31 // ----- ERC20Interface
32 contract ERC20Interface {
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
68 //------------
69 
70 contract VitaToken is ERC20Interface, SafeMath {
71     string public symbol;
72     string public name;
73     uint8 public decimals;
74     address public manager;
75     address public reward_contract;
76     uint public crowd_start_date;
77     uint public crowd_end_date;
78     uint public first_bonus_duration;
79     uint public second_bonus_duration;
80     uint public extra_bonus_duration;
81     //uint public third_bonus_duration;
82     uint public first_bonus_amount;
83     uint public second_bonus_amount;
84     uint public third_bonus_amount;
85     uint public extra_bonus_amount;
86     uint public ETH_VTA;
87     uint public total_reward_amount;
88     uint public max_crowd_vitas;
89     uint public collected_crowd_vitas;
90     //Cantidad total recaudada en wei
91     uint public collected_crowd_wei;
92 
93     mapping(address => uint) balances;
94     mapping(address => uint) rewards;
95     mapping(address => mapping(address => uint)) allowed;
96     function VitaToken() public {
97         symbol = "VTA";
98         name = "Vita Token";
99         //Razones para usar la cantidad estandar de decimales:
100         //Todos los envios de dinero se hacen con wei, que es 1 seguido de 18 ceros
101         //Seguir el estandar facilita los calculos, especialmente en el crowdsale
102         //
103         decimals = 18;
104         ETH_VTA = 100000;
105         //Weis recaudados en crowdsale
106         collected_crowd_wei = 0;
107         //3 mil millones mas 18 decimales
108         max_crowd_vitas = 3 * 10 ** 27;
109         //Vitas recaudadas en crowdsale
110         collected_crowd_vitas = 0;
111         // 10 mil millones más 18 decimales
112         totalSupply = 10 ** 28;
113         manager = msg.sender;
114         //Mitad para reward, mitad para el equipo
115         total_reward_amount = totalSupply / 2;
116         balances[manager] = totalSupply / 2;
117 
118         crowd_start_date = now;
119         extra_bonus_duration = 4 days;
120         //El crowdsale termina 122 días de lanzar el SC (15 agosto)
121         crowd_end_date = crowd_start_date + extra_bonus_duration + 122 days;
122         //la duración del primer bono es de 47 días (15 de abril - 1 de junio)
123         first_bonus_duration = 47 days;
124         //la duración del segundo bono es de 30 días (1 de junio - 1 de julio)
125         second_bonus_duration = 30 days;
126         //la duración del tercer bono es de 45 días, no es relevante agregarla porque es el caso final (1 de julio - 15 de agosto)
127 
128 
129         extra_bonus_amount = 40000;
130         first_bonus_amount = 35000;
131         second_bonus_amount = 20000;
132         third_bonus_amount = 10000;
133     }
134 
135     modifier restricted(){
136         require(msg.sender == manager);
137         _;
138     }
139 
140     //Decorador para métodos que solo pueden ser accedidos a través de Vita reward
141     modifier onlyVitaReward(){
142         require(msg.sender == reward_contract);
143         _;
144     }
145     //Transferir propiedad del contrato
146     function transferOwnership(address new_manager) public restricted {
147         emit OwnershipTransferred(manager, new_manager);
148         manager = new_manager;
149     }
150 
151     //Cambiar el contrato de Vita reward
152     function newVitaReward(address new_reward_contract) public restricted {
153         uint amount_to_transfer;
154         if(reward_contract == address(0)){
155             amount_to_transfer = total_reward_amount;
156         }else{
157             amount_to_transfer = balances[reward_contract];
158         }
159         balances[new_reward_contract] = amount_to_transfer;
160         balances[reward_contract] = 0;
161         reward_contract = new_reward_contract;
162     }
163 
164     function balanceOf(address _owner) public view returns (uint balance) {
165         return balances[_owner];
166     }
167 
168     function rewardsOf(address _owner) public view returns (uint balance) {
169         return rewards[_owner];
170     }
171 
172     //tokens debe ser el número de tokens seguido del número de decimales
173     function transfer(address to, uint tokens) public returns (bool success) {
174         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
175         balances[to] = safeAdd(balances[to], tokens);
176         emit Transfer(msg.sender, to, tokens);
177         return true;
178     }
179 
180 
181     //tokens debe ser el número de tokens seguido del número de decimales
182     function reward(address patient, address company, uint tokens_patient, uint tokens_company, uint tokens_vita_team) public onlyVitaReward returns (bool success) {
183         balances[reward_contract] = safeSub(balances[reward_contract], (tokens_patient + tokens_company + tokens_vita_team));
184         //Se envian los tokens del paciente, normalmente el 90%
185         balances[patient] = safeAdd(balances[patient], tokens_patient);
186         //Se envian los tokens a la compañia que hizo la llamada a reward, normalmente 5%
187         balances[company] = safeAdd(balances[company], tokens_company);
188         //Se envian los tokens al equipo de vita, normalmente 5%
189         balances[manager] = safeAdd(balances[manager], tokens_vita_team);
190         rewards[patient] = safeAdd(rewards[patient], 1);
191         emit Transfer(reward_contract, patient, tokens_patient);
192         emit Transfer(reward_contract, company, tokens_company);
193         emit Transfer(reward_contract, manager, tokens_vita_team);
194         return true;
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Token owner can approve for `spender` to transferFrom(...) `tokens`
200     // from the token owner's account
201     //
202     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
203     // recommends that there are no checks for the approval double-spend attack
204     // as this should be implemented in user interfaces
205     // ------------------------------------------------------------------------
206     function approve(address spender, uint tokens) public returns (bool success) {
207         allowed[msg.sender][spender] = tokens;
208         emit Approval(msg.sender, spender, tokens);
209         return true;
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Transfer `tokens` from the `from` account to the `to` account
215     //
216     // The calling account must already have sufficient tokens approve(...)-d
217     // for spending from the `from` account and
218     // - From account must have sufficient balance to transfer
219     // - Spender must have sufficient allowance to transfer
220     // - 0 value transfers are allowed
221     // ------------------------------------------------------------------------
222     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
223         require(balances[from] >= tokens && allowed[from][msg.sender] >= tokens);
224         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
225         balances[from] = safeSub(balances[from], tokens);
226         balances[to] = safeAdd(balances[to], tokens);
227         emit Transfer(from, to, tokens);
228         return true;
229     }
230 
231 
232     // ------------------------------------------------------------------------
233     // Permite determinar cuantas VTA tiene un usuario permitido gastar
234     // ------------------------------------------------------------------------
235     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
236         return allowed[tokenOwner][spender];
237     }
238 
239     function () public payable {
240         require(now >= crowd_start_date && now <= crowd_end_date);
241         require(collected_crowd_vitas < max_crowd_vitas);
242         uint tokens;
243         if(now <= crowd_start_date + extra_bonus_duration){
244             tokens = msg.value * (ETH_VTA + extra_bonus_amount);
245         }else if(now <= crowd_start_date + extra_bonus_duration + first_bonus_duration){
246             tokens = msg.value * (ETH_VTA + first_bonus_amount);
247         }else if(now <= crowd_start_date + extra_bonus_duration + first_bonus_duration + second_bonus_duration){
248             tokens = msg.value * (ETH_VTA + second_bonus_amount);
249         }else{
250             tokens = msg.value * (ETH_VTA + third_bonus_amount);
251         }
252 
253         balances[manager] = safeSub(balances[manager], tokens);
254         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
255         emit Transfer(manager, msg.sender, tokens);
256         collected_crowd_wei += msg.value;
257         collected_crowd_vitas += tokens;
258         manager.transfer(msg.value);
259     }
260     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
261 }