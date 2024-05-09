1 pragma solidity ^0.4.13;
2 
3 // Viberate ICO buyer
4 // Avtor: Janez
5 
6 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
7 contract ERC20 {
8   function transfer(address _to, uint256 _value) returns (bool success);
9   function balanceOf(address _owner) constant returns (uint256 balance);
10 }
11 
12 contract ViberateBuyer {
13   // Koliko ETH je vlozil vsak racun.
14   mapping (address => uint256) public balances;
15   // Nagrada za izvedbo nakupa.
16   uint256 public buy_bounty;
17   // Nagrada za dvig.
18   uint256 public withdraw_bounty;
19   // Podatek ali smo tokene uspesno kupili.
20   bool public bought_tokens;
21   // Vrednost tokenov v pogodbi.
22   uint256 public contract_eth_value;
23   // Varnostni kill switch v primeru da se najde kriticen hrosc in zelimo pogodbo prekiniti in vsem vrniti ETH.
24   bool public kill_switch;
25   
26   // SHA3 izvlecek gesla.
27   bytes32 password_hash = 0xfac0a99293c75e2f2ed76d4eb06030f4f3458f419a67ca0feac3dbe9791275b4;
28   // Kdaj najbolj zgodaj lahko kupimo.
29   uint256 public earliest_buy_time = 1504612800;
30   // Nas interni cap. Zato da ne gremo cez hard cap.
31   uint256 public eth_cap = 10000 ether;
32   // Naslov razvijalca.
33   address public developer = 0x0639C169D9265Ca4B4DEce693764CdA8ea5F3882;
34   // Crowdsale naslov.  To lahko nastavi le razvijalec.
35   address public sale;
36   // Naslov tokena.  To lahko nastavi le razvijalec.
37   ERC20 public token;
38   
39   // Razvijalec s klicom te funkcije nastavi naslov crowdsale-a
40   function set_addresses(address _sale, address _token) {
41     // Samo razvijalec lahko nastavi naslov in token.
42     require(msg.sender == developer);
43     // Naslov se lahko nastavi le 1x.
44     require(sale == 0x0);
45     // Nastavljanje naslova in tokena.
46     sale = _sale;
47     token = ERC20(_token);
48   }
49   
50   // V skrajni sili lahko razvijalec ali pa kdorkoli s posebnim geslom aktivira 'kill switch'. Po aktivaciji je mozen le se dvig sredstev.
51   function activate_kill_switch(string password) {
52     // Aktiviraj kill switch samo ce ga aktivira razvijalec, ali pa je geslo pravilno.
53     require(msg.sender == developer || sha3(password) == password_hash);
54     // Nagrado shranimo v zacasno spremenljivko.
55     uint256 claimed_bounty = buy_bounty;
56     // Nagrado nastavimo na 0.
57     buy_bounty = 0;
58     // Aktiviramo kill switch.
59     kill_switch = true;
60     // Klicatelju posljemo nagrado.
61     msg.sender.transfer(claimed_bounty);
62   }
63   
64   // Poslje ETHje ali tokene klicatelju.
65   function personal_withdraw(){
66     // Ce uporabnik nima denarja koncamo.
67     if (balances[msg.sender] == 0) return;
68     // Ce pogodbi ni uspelo kupiti, potem vrnemo ETH.
69     if (!bought_tokens) {
70       // Pred dvigom shranimo uporabnikov vlozek v zacasno spremenljivko.
71       uint256 eth_to_withdraw = balances[msg.sender];
72       // Uporabnik sedaj nima vec ETH.
73       balances[msg.sender] = 0;
74       // ETH vrnemo uporabniku.
75       msg.sender.transfer(eth_to_withdraw);
76     }
77     // Ce je pogodba uspesno kupila tokene, jih nakazemo uporabniku.
78     else {
79       // Preverimo koliko tokenov ima pogodba.
80       uint256 contract_token_balance = token.balanceOf(address(this));
81       // Ce se nimamo tokenov, potem ne dvigujemo.
82       require(contract_token_balance != 0);
83       // Shranimo stevilo uporabnikovih tokenov v zacasno spremenljivko.
84       uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
85       // Odstejemo uporabnikovo vrednost od vrednosti pogodbe.
86       contract_eth_value -= balances[msg.sender];
87       // Odstejemo uporabnikovo vrednost.
88       balances[msg.sender] = 0;
89       // 1% strosek za pogodbo ce smo tokene kupili.
90       uint256 fee = tokens_to_withdraw / 100;
91       // Poslji strosek razvijalcu.
92       require(token.transfer(developer, fee));
93       // Posljemo tokene uporabniku.
94       require(token.transfer(msg.sender, tokens_to_withdraw - fee));
95     }
96   }
97 
98   // Poslje ETHje uporabniku ali pa tokene in nagradi klicatelja funkcije.
99   function withdraw(address user){
100     // Dvig dovoljen ce smo kupili tokene ali pa cez eno uro po crowdsalu (ce nismo), ali pa ce je aktiviran kill switch.
101     require(bought_tokens || now > earliest_buy_time + 1 hours || kill_switch);
102     // Ce uporabnik nima denarja koncamo.
103     if (balances[user] == 0) return;
104     // Ce pogodbi ni uspelo kupiti, potem vrnemo ETH.
105     if (!bought_tokens) {
106       // Pred dvigom shranimo uporabnikov vlozek v zacasno spremenljivko.
107       uint256 eth_to_withdraw = balances[user];
108       // Uporabnik sedaj nima vec ETH.
109       balances[user] = 0;
110       // ETH vrnemo uporabniku.
111       user.transfer(eth_to_withdraw);
112     }
113     // Ce je pogodba uspesno kupila tokene, jih nakazemo uporabniku.
114     else {
115       // Preverimo koliko tokenov ima pogodba.
116       uint256 contract_token_balance = token.balanceOf(address(this));
117       // Ce se nimamo tokenov, potem ne dvigujemo.
118       require(contract_token_balance != 0);
119       // Shranimo stevilo uporabnikovih tokenov v zacasno spremenljivko.
120       uint256 tokens_to_withdraw = (balances[user] * contract_token_balance) / contract_eth_value;
121       // Odstejemo uporabnikovo vrednost od vrednosti pogodbe.
122       contract_eth_value -= balances[user];
123       // Odstejemo uporabnikovo vrednost.
124       balances[user] = 0;
125       // 1% strosek za pogodbo ce smo tokene kupili.
126       uint256 fee = tokens_to_withdraw / 100;
127       // Poslji strosek razvijalcu.
128       require(token.transfer(developer, fee));
129       // Posljemo tokene uporabniku.
130       require(token.transfer(user, tokens_to_withdraw - fee));
131     }
132     // Vsak klic za dvig dobi 1% nagrade za dvig.
133     uint256 claimed_bounty = withdraw_bounty / 100;
134     // Zmanjsamo nagrado za dvig.
135     withdraw_bounty -= claimed_bounty;
136     // Klicatelju posljemo nagrado.
137     msg.sender.transfer(claimed_bounty);
138   }
139   
140   // Razvijalec lahko doda ETH v nagrado za vplacilo.
141   function add_to_buy_bounty() payable {
142     // Samo razvijalec lahko doda nagrado.
143     require(msg.sender == developer);
144     // Povecaj nagrado.
145     buy_bounty += msg.value;
146   }
147   
148   // Razvijalec lahko doda nagrado za dvig.
149   function add_to_withdraw_bounty() payable {
150     // Samo razvijalec lahko doda nagrado za dvig.
151     require(msg.sender == developer);
152     // Povecaj nagrado za dvig.
153     withdraw_bounty += msg.value;
154   }
155   
156   // Kupi tokene v crowdsalu, nagradi klicatelja. To funkcijo lahko poklice kdorkoli.
157   function claim_bounty(){
158     // Ce smo ze kupili koncamo.
159     if (bought_tokens) return;
160     // Ce cas se ni dosezen, koncamo.
161     if (now < earliest_buy_time) return;
162     // Ce je aktiviran 'kill switch', koncamo.
163     if (kill_switch) return;
164     // Ce razvijalec se ni dodal naslova, potem ne kupujemo.
165     require(sale != 0x0);
166     // Zapomnimo si da smo kupili tokene.
167     bought_tokens = true;
168     // Nagrado shranemo v zacasno spremenljivko.
169     uint256 claimed_bounty = buy_bounty;
170     // Nagrade zdaj ni vec.
171     buy_bounty = 0;
172     // Zapomnimo si koliko ETH smo poslali na crowdsale (vse razen nagrad)
173     contract_eth_value = this.balance - (claimed_bounty + withdraw_bounty);
174     // Poslje celoten znesek ETH (brez nagrad) na crowdsale naslov.
175     require(sale.call.value(contract_eth_value)());
176     // Klicatelju posljemo nagrado.
177     msg.sender.transfer(claimed_bounty);
178   }
179   
180   // Ta funkcija se poklice ko kdorkoli poslje ETH na pogodbo.
181   function () payable {
182     // Zavrnemo transakcijo, ce je kill switch aktiviran.
183     require(!kill_switch);
184     // Vplacila so dovoljena dokler se nismo kupili tokenov.
185     require(!bought_tokens);
186     // Vplacila so dovoljena dokler nismo dosegli nasega capa.
187     require(this.balance < eth_cap);
188     // Shranimo uporabnikov vlozek.
189     balances[msg.sender] += msg.value;
190   }
191 }