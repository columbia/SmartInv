1 pragma solidity ^0.4.4;
2 
3 /** 
4  YUNIQUE EXCHANGE TOKEN SALE CONTRACT
5  
6  Yunique Exchange is a Unique centralised and decentralised hybrid exchange 
7  which allows the traders to deposit, withdraw, buy and sell, claim some airdrops, 
8  use atomic swap, and spend their cryptocurrency with high safety and security.
9  
10  Website: https://www.yunique.pro
11  Twitter: https://twitter.com/YuniqueExchange
12  Telegram: https://t.me/yuniquex
13  Facebook: https://web.facebook.com/exchange.yunique.pro/
14  ------------------------------------------------------------------------------------
15  ***Token Sale information***
16  
17  Minimum investment 0.01 ETH and Maximum Investment 5 ETH
18  *** Price and Bonuses as follws
19   
20   0.01 ETH = 160,000 YQX
21   0.1 ETH = 1,600,000 + 20% Bonus
22   0.5 ETH = 8,000,000 + 25% Bonus 
23   1 ETH = 16,000,000 + 30% Bonus
24   5 ETH = 80,000,000 + 40% Bonus
25   -----------------------------------------------------------------------------------
26   ___________________________________________________________________________________
27   
28   КОНТРАКТ ПРОДАЖИ ПРОДУКТА YUNIQUE EXCHANGE
29  
30  Yunique Exchange - это уникальный централизованный и децентрализованный гибридный обмен
31  что позволяет трейдерам делать депозиты, снимать, покупать и продавать, требовать какие-то воздушные кадры,
32  использовать атомный своп и тратить свою криптовалютность с высокой безопасностью и безопасностью.
33  
34  Веб-сайт: https://www.yunique.pro
35  Twitter: https://twitter.com/YuniqueExchange
36  Телеграмма: https://t.me/yuniquex
37  Facebook: https://web.facebook.com/exchange.yunique.pro/
38  -------------------------------------------------- ----------------------------------
39  *** Токен Информация о продаже ***
40  
41  Минимальные инвестиции 0,01 ETH и максимальные инвестиции 5 ETH
42  *** Цена и бонусы, как указано ниже
43   
44   0,01 ETH = 160 000 YQX
45   0.1 ETH = 1,600,000 + 20% Бонус
46   0,5 ETH = 8 000 000 + 25% Бонус
47   1 ETH = 16,000,000 + 30% Бонус
48   5 ETH = 80 000 000 + 40% Бонус
49   -------------------------------------------------- ---------------------------------
50   ___________________________________________________________________________________
51   YUNIQUE EXCHANGE TOKEN xiāoshòu hétóng
52  
53  Yunique Exchange shì yīgè dútè de jízhōng hé fēnsàn de hùnhé jiāohuàn
54  yǔnxǔ jiāoyì zhě cúnkuǎn, qǔkuǎn, mǎimài, yāoqiú yīxiē kōngtóu,
55  shǐyòng yuánzǐ jiāohuàn, bìng yǐ gāo ānquán xìng hé ānquán xìng shǐyòng jiāmì huòbì.
56  
57  Wǎngzhàn:Https://Www.Yunique.Pro
58  Twitter:Https://Twitter.Com/YuniqueExchange
59  diànbào:Https://T.Me/yuniquex
60  Facebook:Https://Web.Facebook.Com/exchange.Yunique.Pro/
61  -------------------------------------------------- ----------------------------------
62  ***lìng pái xiāoshòu xìnxī***
63  
64  zuìdī tóuzī 0.01 ETH hé zuìdà tóuzī 5 ETH
65  ***jiàgé hé jiǎngjīn rúxià
66   
67   0.01 ETH = 160,000 YQX
68   0.1 ETH = 1,600,000 + 20%jiǎngjīn
69   0.5 ETH = 8,000,000 + 25%jiǎngjīn
70   1 ETH = 16,000,000 + 30%jiǎngjīn
71   5 ETH = 80,000,000 + 40%jiǎngjīn
72   -------------------------------------------------- ---------------------------------
73   ___________________________________________________________________________________
74   KUNTRATT TA 'BEJGĦ TAT-TKEN TA' YUNIQUE
75  
76  L-Iskambju Yunique huwa skambju ibridu ċentralizzat uniku u deċentralizzat
77  li tippermetti lin-negozjanti li jiddepożitaw, jirtiraw, jixtru u jbigħu, jitolbu xi airdrops,
78  uża tpartit atomiku, u tqatta 'l-cryptocurrency tagħhom b'sigurtà u sigurtà għolja.
79  
80  Sit elettroniku: https://www.yunique.pro
81  Twitter: https://twitter.com/YuniqueExchange
82  Telegramma: https://t.me/yuniquex
83  Facebook: https://web.facebook.com/exchange.yunique.pro/
84  -------------------------------------------------- ----------------------------------
85  *** Informazzjoni dwar it-Token Sale ***
86  
87  Investiment minimu 0.01 ETH u Investiment Massimu 5 ETH
88  *** Prezz u Bonuses bħala follws
89   
90   0.01 ETH = 160,000 YQX
91   0.1 ETH = 1,600,000 + 20% Bonus
92   0.5 ETH = 8,000,000 + 25% Bonus
93   1 ETH = 16,000,000 + 30% Bonus
94   5 ETH = 80,000,000 + 40% Bonus
95   -------------------------------------------------- ---------------------------------
96   ___________________________________________________________________________________
97   ユナイテッド・トーキン・セール・コンクール
98  
99  Yunique Exchangeはユニークな集中型および分散型のハイブリッド交換機です
100  トレーダーが預金、撤退、売買、一部のエアドロップの請求、
101  アトミックスワップを使用し、高い安全性とセキュリティを備えた暗号侵害を使います。
102  
103  ウェブサイト：https://www.yunique.pro
104  Twitter：https://twitter.com/YuniqueExchange
105  電報：https://t.me/yuniquex
106  Facebook：https://web.facebook.com/exchange.yunique.pro/
107  -------------------------------------------------- ----------------------------------
108  ***トークンセール情報***
109  
110  最低投資0.01 ETHと最大投資5 ETH
111  ***以下のような価格とボーナス
112   
113   0.01 ETH = 160,000 YQX
114   0.1 ETH = 1,600,000 + 20％ボーナス
115   0.5 ETH = 8,000,000 + 25％ボーナス
116   1 ETH = 16,000,000 + 30％ボーナス
117   5 ETH = 80,000,000 + 40％ボーナス
118   -------------------------------------------------- ---------------------------------
119   ___________________________________________________________________________________
120   
121   */
122  
123 contract Token {
124  
125     /// @return total amount of tokens
126     function totalSupply() constant returns (uint256 supply) {}
127  
128     /// @param _owner The address from which the balance will be retrieved
129     /// @return The balance
130     function balanceOf(address _owner) constant returns (uint256 balance) {}
131  
132     /// @notice send `_value` token to `_to` from `msg.sender`
133     /// @param _to The address of the recipient
134     /// @param _value The amount of token to be transferred
135     /// @return Whether the transfer was successful or not
136     function transfer(address _to, uint256 _value) returns (bool success) {}
137  
138     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
139     /// @param _from The address of the sender
140     /// @param _to The address of the recipient
141     /// @param _value The amount of token to be transferred
142     /// @return Whether the transfer was successful or not
143     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
144  
145     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
146     /// @param _spender The address of the account able to transfer the tokens
147     /// @param _value The amount of wei to be approved for transfer
148     /// @return Whether the approval was successful or not
149     function approve(address _spender, uint256 _value) returns (bool success) {}
150  
151     /// @param _owner The address of the account owning tokens
152     /// @param _spender The address of the account able to transfer the tokens
153     /// @return Amount of remaining tokens allowed to spent
154     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
155  
156     event Transfer(address indexed _from, address indexed _to, uint256 _value);
157     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
158    
159 }
160  
161  
162  
163 contract StandardToken is Token {
164  
165     function transfer(address _to, uint256 _value) returns (bool success) {
166         //Default assumes totalSupply can't be over max (2^256 - 1).
167         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
168         //Replace the if with this one instead.
169         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
170         if (balances[msg.sender] >= _value && _value > 0) {
171             balances[msg.sender] -= _value;
172             balances[_to] += _value;
173             Transfer(msg.sender, _to, _value);
174             return true;
175         } else { return false; }
176     }
177  
178     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
179         //same as above. Replace this line with the following if you want to protect against wrapping uints.
180         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
181         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
182             balances[_to] += _value;
183             balances[_from] -= _value;
184             allowed[_from][msg.sender] -= _value;
185             Transfer(_from, _to, _value);
186             return true;
187         } else { return false; }
188     }
189  
190     function balanceOf(address _owner) constant returns (uint256 balance) {
191         return balances[_owner];
192     }
193  
194     function approve(address _spender, uint256 _value) returns (bool success) {
195         allowed[msg.sender][_spender] = _value;
196         Approval(msg.sender, _spender, _value);
197         return true;
198     }
199  
200     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
201       return allowed[_owner][_spender];
202     }
203  
204     mapping (address => uint256) balances;
205     mapping (address => mapping (address => uint256)) allowed;
206     uint256 public totalSupply;
207 }
208  
209  
210 contract Yunique is StandardToken { // CHANGE THIS. Update the contract name.
211 
212     /* Public variables of the token */
213 
214     /*
215     NOTE:
216     The following variables are OPTIONAL vanities. One does not have to include them.
217     They allow one to customise the token contract & in no way influences the core functionality.
218     Some wallets/interfaces might not even bother to look at this information.
219     */
220     string public name;                   // Token Name
221     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
222     string public symbol;                 // An identifier: eg SBX, XPR etc..
223     string public version = 'H1.0'; 
224     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
225     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
226     address public fundsWallet;           // Where should the raised ETH go?
227 
228     // This is a constructor function 
229     // which means the following function name has to match the contract name declared above
230     function Yunique() {
231         balances[msg.sender] = 12888888888000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
232         totalSupply = 12888888888000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
233         name = "Yunique";                                   // Set the name for display purposes (CHANGE THIS)
234         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
235         symbol = "YQX";                                             // Set the symbol for display purposes (CHANGE THIS)
236         unitsOneEthCanBuy = 160000000;                                      // Set the price of your token for the ICO (CHANGE THIS)
237         fundsWallet = msg.sender;                                  // The owner of the contract gets ETH
238     }
239 
240     function() payable{
241         totalEthInWei = totalEthInWei + msg.value;
242         uint256 amount = msg.value * unitsOneEthCanBuy;
243         require(balances[fundsWallet] >= amount);
244 
245         balances[fundsWallet] = balances[fundsWallet] - amount;
246         balances[msg.sender] = balances[msg.sender] + amount;
247 
248         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
249 
250         //Transfer ether to fundsWallet
251         fundsWallet.transfer(msg.value);                               
252     }
253 
254     /* Approves and then calls the receiving contract */
255     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
256         allowed[msg.sender][_spender] = _value;
257         Approval(msg.sender, _spender, _value);
258 
259         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
260         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
261         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
262         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
263         return true;
264     }
265 }