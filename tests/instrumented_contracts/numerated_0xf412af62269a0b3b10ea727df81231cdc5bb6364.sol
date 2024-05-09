1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'dCHF' token contract
5 //
6 // Deployed to : 0x0000F70bC78af03f14132c68b59153E4788bAb20  on march 20th 2018 somewhere after Block 52911611
7 // Symbol      : dCH
8 // Name        : private digitale Schweizer Franken - private digital Swiss Franc 
9 // Total supply: 15000,00
10 // Decimals    : 2
11 //
12 // based on code made by
13 //
14 //  Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 //
17 // ----------------------------------------------------------------------------
18 // ALLGEMEINE GESCHAEFTSBEDINGUNGEN für die Nutzung von privaten digitalen Schweizer Franken
19 // ----------------------------------------------------------------------------
20 //
21 // -----------------------------
22 // 1. Diese Allgemeinen Geschäftsbedingungen gelten ausschliesslich für Rechtsgeschäfte zwischen der Scenic Swisscoast GmbH, 3012 Bern (CH-ID:  CH03540319700) und dem Kunden im Rahmen des Verkaufs und der Annahme von privaten digitalen Schweizer Franken. Diese Dienstleitungen der Scenic Swisscoast GmbH ba-sieren ausschliesslich auf der Grundlage dieser Allgemeinen Geschäftsbedingungen.
23 // -----------------------------
24 // 2. Definition: 
25 // -----------------------------
26 //     Bei der Scenic Swisscoast GmbH handelt es sich um ein privates Schweizer Unternehmen. Sie verkauft die privaten digitalen Schweizer Franken als Kryptowährung in eigenem Namen und auf eigene Rechnung. Sce-nic Swisscoast GmbH ist keine Behörde und handelt weder als Behörde noch in einem amtlichen Auftrag. Sce-nic Swisscoast GmbH ist auch keine Bank. Die privaten digitalen Schweizer Franken sind ein privates digitales Zahlungsmittel in Schweizer Franken, das von der Scenic Swisscoast GmbH auf einer Blockchain geschaffen und verkauft wird. Solche privaten Zah-lungsmittel werden auch als «digitales Geld», «virtuelles Geld» oder «Kryptowährungen» bezeichnet. Bei den privaten digitalen Schweizer Franken handelt es sich weder um staatliches Geld noch um ein gesetz-liches Zahlungsmittel. Es ist ein privates digitales Zahlungsmittel. Für die privaten digitalen Schweizer Fran-ken besteht in der Schweiz keine Pflicht zur Annahme als Zahlungsmittel. Sie können nur bei der Scenic Swisscoast GmbH für den Kauf von Tickets für das 1. International Innovation Film Festival in Bern, das vom 14.-18. Februar 2019 stattfinden wird, sowie für Dienstleistungen der Scenic Swisscoast GmbH zur Zahlung verwendet werden. Bei den privaten digitalen Schweizer Franken handelt es sich nicht um sog. «elektronisches Geld» im engeren Sinne. Der Käufer der privaten digitalen Schweizer Franken hat keine Forderung gegen die Scenic Swisscoast GmbH und kann diese bei der Scenic Swisscoast GmbH nicht gegen gesetzliche Zahlungsmittel umtauschen. Kryptowährungen wie Bitcoin oder Ether werden üblicherweise in einer eigenen Währung ausgegeben. Die privaten digitalen Schweizer Franken werden in Schweizer Franken als Währung ausgegeben. Damit entfällt das bei Kryptowährungen bestehende Wechselkursrisiko. Der Käufer der privaten digitalen Schweizer Fran-ken kann diese beim Kauf von Tickets für das 1. International Innovation Film Festival in Bern oder bei der Bezahlung von Dienstleistungen der Scenic Swisscoast GmbH 1:1 in Schweizer Franken verwenden. Die privaten digitalen Schweizer Franken sind ein eindeutiger, ERC-20 standardisierter Token auf der Ethereum-Blockchain mit der eindeutigen Ethereumcontract - nummer von diesem Smart Contract hier: Alle Vertragsdetails können mit einem Blockchainexplorer wie zum Beispiel etherscan.io eingesehen werden: 
27 // -----------------------------
28 // 3. Verkauf des Digitalen Schweizer Frankens:
29 // -----------------------------
30 //     Verkäufer:
31 //      Verkäufer der privaten digitalen Schweizer Franken ist die Scenic Swisscoast GmbH. Diese verkauft die priva-ten digitalen Schweizer Franken auf der Webseite www.innovationfilmfestival.ch.
32 //
33 //  Der Käufer: 
34 // 1.	muss beim bei der Bestellung Name, Vorname, Adresse inklusive Wohnort sowie Email und Mobil-Telefonnummer angeben 
35 // 2.	kann für 100, 500 oder 750 Franken private digitale Schweizer Franken kaufen 
36 // 3.	kann für maximal 750 Franken private digitale Schweizer Franken kaufen 
37 // 4.	muss über eine Ethereumadresse verfügen oder eine erstellen, um die privaten digitalen Schweizer Fran-ken entgegenzunehmen 
38 // 5.	verliert beim Verlust des private Keys zur Ethereumadresse oder bei Verlust des Wallets mit der Ethereumadresse seine privaten digitalen Schweizer Franken, sofern er kein Backup erstellt hat. Weder die Scenic Swisscoast GmbH noch sonst eine Institution ist technisch in der Lage, verlorengegangene pri-vate digitale Schweizer Franken oder private Keys widerherzustellen oder rückzuvergüten. 
39 // 6.	muss sich der Risiken der Ethereumblockchaintechnologie bewusst sein: insbesondere muss sich der Kun-de bewusst sein, dass die Scenic Swisscoast GmbH nicht für die Ethereumblockchain und/oder das Eth-reumnetzwerk noch die Verfügbarkeit verantwortlich ist. 
40 // 7.	muss sich bewusst sein, dass er nur mit den privaten digitalen Schweizer Franken bezahlen kann, wenn er auf das Internet zugreifen kann. 
41 // 8.	muss sich der Risiken bewusst sein, die ein allfälliger Entwicklungsschub in der Quantenkryptografie zu bedeuten hätte. 
42 // 9.	muss sich der grundsätzlichen Risiken der Blockchaintechnologie bewusst sein. Sowohl die Technologie selbst als auch der Umgang mit der Technologie können die Sicherheit der privaten digitalen Schweizer Franken beeinträchtigen. 
43 // 10.	muss sich der Risiken, die Software und Webseiten Dritter bergen, bewusst sein. Insbesondere sind da Walletgeneratoren, mobile Apps und Betriebssysteme von mobilen Geräten und sonstiger Hardware zu erwähnen.
44 // 11.	muss sich unerwarteter Risiken bewusst sein. Die Ethereumtechnologie ist noch verhältnismässig jung und es können unerwartete Risiken auftreten. 
45 // 12.	kann wählen, wie er die privaten digitalen Schweizer Franken bezahlen will. Möglich ist eine Zahlung auf das Postkonto der Scenic Swisscoast GmbH oder eine Zahlung via PayPal oder eine Bezahlung mit Ether.
46 // 13.	muss sich bewusst sein, dass es für den Transfer von privaten digitalen Schweizer Franken einen kleinen Betrag Ether braucht. Dieser Betrag hängt von verschiedenen Faktoren ab, auf welche Scenic Swisscoast GmbH keinen Einfluss hat (z.B. Gaspreis, Geschwindigkeit der Transaktion, Traffic auf der Ethereumblock-chain). Scenic Swisscoast GmbH wird bei jedem Verkauf von privaten digitalen Schweizer Franken dem Käufer zusätzlich und freiwillig 0.0001 Ether auf die vom Kunden genannte Ethereumadresse mitüberwei-sen. Dieser Betrag ermöglich dem Kunden (Stand: Ausgabe der AGB) mindestens eine Überweisung von privaten digitalen Schweizer Franken. Darüber hinaus trägt der Kunde die Kosten für weitere Überwei-sungen von privaten digitalen Schweizer Franken auf der Ethereumblockchain selber.
47 // 14.	muss sich bewusst sein, dass Überweisungen von privaten digitalen Schweizer Franken auf falsche Ethereumadressen nicht rückgängig gemacht werden können und somit verloren sind. Der Kunde muss insbesondere bei der Bezahlung via Bankeinzahlung oder PayPal sicherstellen, dass er der Scenic Swisscoast GmbH die richtige Ethereumadresse angibt. 
48 
49 // Bei der Bezahlung auf das Postkonto oder via PayPal
50 // stellt die Scenic Swisscoast GmbH innert 24h eine Rechnung per Mail zu, die innert 7 Tagen bezahlt sein muss. Die privaten digitalen Schweizer Franken werden innert 7 Tagen nach Eingang der Zahlung (Post/Paypal) auf die angegebene Ethereumadresse überwiesen. 
51 
52 // Bei der Bezahlung mit Ether 
53 // -	berechnet die Scenic Swisscoast GmbH den Etherwechselkurs gemäss Angaben von Kraken (in ETH/EUR mit einem CHF/Euro-Wechselkurs gemäss http://www.finanzen.ch/devisen/eurokurs).
54 // -	erstellt die Scenic Swisscoast GmbH eine Rechnung und einen Smartcontract für den Umtausch von Ether in private digitale Schweizer Franken.
55 // - 	auf dieser Rechnung ist die Ethereumadresse des Smartcontracts aufgeführt.
56 // -    Der Smartcontract tauscht automatisch Ether in private digitale Schweizer Franken zum berechneten Wechselkurs um. Der Kunde muss den in Rechnung gestellten Betrag in Ether an die Ethereumadresse des Smartcontracts senden und erhält automatisch vom Smartcontract die privaten digitalen Schweizer Fran-ken auf sein Ethereumwallet. Der Kunde muss den Betrag von einem Wallet aus senden, auf das er vollen Zugriff hat (zum Beispiel mittels private Key).
57 // -    Auf Wunsch kann der Kunde bei der Bezahlung mit Ether die Alternative ohne Smartcontract wählen. Er 
58 // 1) bezahlt den verrechneten Betrag in Ether auf die Ethereumadresse von Scenic Swisscoast GmbH, 
59 // 2) gibt der Scenic Swisscoast GmbH seine eigene Ethereumadresse an, auf die er vollen Zugriff hat (zum Beispiel mittels private Key)
60 // 3) erhält von der Scenic Swisscoast GmbH innert 7 Tagen die ihm zustehenden Digitalen Schweizer Franken auf das angegeben Wallet.
61 // Bei einer Bezahlung mit Ether ist die Bezahlung mittels Smartcontract unmittelbar.
62 // 
63 // Verkaufsbeschränkung
64 // Der Verkauf ist auf 15’000 private digitale Schweizer Franken mit je zwei Nachkommastellen beschränkt. Die Scenic Swisscoast GmbH behält sich vor, zu einem späteren Zeitpunkt weitere private digitale Schweizer Fran-ken zu verkaufen.
65 // 
66 // Die privaten digitalen Schweizer Franken werden ausschliesslich an Personen mit Wohnsitz in der Schweiz verkauft.
67 //
68 // -----------------------------
69 //4.	Verwendung der privaten digitalen Schweizer Franken / Akzeptanzstellen: 
70 // -----------------------------
71 // Die Scenic Swisscoast GmbH ist Mitveranstalterin des 1. International Innovation Film Festival in Bern das vom 14.-18. Februar stattfindet. Sie hat das Vorkaufsrecht auf alle Tickets der 9 Kinovorführungen im Rahmen des Filmfestivals. Die privaten digitalen Schweizer Franken werden am Festival für den Kinoticketkauf als Zahlungsmittel zum Nennwert akzeptiert werden. Im Weiteren akzeptiert die Scenic Swisscoast GmbH die privaten digitalen Schweizer Franken als Zahlungsmittel für ihre eigenen Dienstleistungen. Die Scenic Swisscoast GmbH behält sich vor, weitere Akzeptanzstellen für die privaten digitalen Schweizer Franken zu schaffen.
72 //
73 //4.1		Keine Rückgabe der privaten digitalen Schweizer Franken: Die Rückgabe nicht gebrauchter privater digitaler Schweizer Franken an die Scenic Swisscoast GmbH ist aus-geschlossen.
74 //
75 // -----------------------------
76 //5.	Preise: 
77 // -----------------------------
78 //Der Digitale Schweizer Franken wird zu folgenden Preisen verkauft: 
79 //vor dem 25. März 2018:115 private digitale Schweizer Franken für 100 Schweizer Franken 
80 //vor dem 31.März 2018:	110 private digitale Schweizer Franken für 100 Schweizer Franken 
81 //vor dem 1. August 2018: 105 private digitale Schweizer Franken für 100 Schweizer Franken 
82 //nach dem 1. August 2018: 100 private digitale Schweizer Franken für 100 Schweizer Franken
83 //
84 //
85 // -----------------------------
86 //6.	Verantwortung der Scenic Swisscoast GmbH: 
87 // -----------------------------
88 //Die Scenic Swisscoast GmbH hat die privaten digitalen Schweizer Franken nach gängigem Standard entwi-ckelt und auf der Ethereum Blockchain veröffentlicht. 
89 //Die Scenic Swisscoast GmbH ist weder verantwortlich noch zuständig für die Verfügbarkeit des Internetzu-griffs, des Zustandes des Ethereumnetzwerks oder die Sicherheit des ERC-20 Standards.
90 //
91 //
92 // -----------------------------
93 //7.	Sorgfaltspflichten des Kunden:
94 // -----------------------------
95 //Der Kunde verpflichtet sich, wahrheitsgemässe, exakte, aktuelle und vollständige Angaben zu seiner Person und seiner Ethereumadresse auf dem Bestellformular zu machen. Scenic Swisscoast GmbH schliesst für Verlus-te und Schäden, die sich aus der Nichterfüllung dieser Verpflichtungen ergeben, jegliche Haftung aus. Scenic Swisscoast GmbH behält sich vor, diese Angaben durch Rückruf oder ähnliche geeignete Massnahmen zu überprüfen und bei Missachtung unserer AGB einzelne Personen vom Verkauf auszuschliessen.
96 //
97 // -----------------------------
98 //8.	Datenschutz:
99 // -----------------------------
100 //Scenic Swisscoast GmbH ist berechtigt, die Anmeldedaten im Rahmen der Erfüllung der Vertragszwecke zu speichern, zu verändern oder zu übermitteln. Scenic Swisscoast GmbH weist den Kunden darauf hin, dass per-sonenbezogene Daten im Rahmen der Vertragsdurchführung gespeichert werden. Der Kunde willigt mit der Akzeptierung dieser AGB ein, dass die erhobenen Daten, insbesondere auch die Ethereumadresse, von Scenic Swisscoast GmbH verarbeitet und genutzt werden können. Der Kunde kann der Verwendung seiner Daten je-derzeit widersprechen.
101 //
102 // -----------------------------
103 //9.	Gewährleistung, Haftung:
104 // -----------------------------
105 //Der Kunde erklärt sich ausdrücklich damit einverstanden, dass die Nutzung des von Scenic Swisscoast GmbH zur Verfügung gestellten Dienstes auf eigene Gefahr erfolgt. Scenic Swisscoast GmbH haftet nicht im Falle höherer Gewalt, insbesondere bei Ausfall von Telefonleitungen oder Internetleitungen, Arbeitskampfmass-nahmen, Hochwasser, behördlichen Massnahmen, unvorhersehbarem Ausfall von Transportmitteln oder Energie oder sonstigen unabwendbaren Ereignissen. Dies gilt auch, wenn die vorstehenden Ereignisse bei ei-nem Erfüllungsgehilfen der Scenic Swisscoast GmbH eintreten.
106 //
107 //
108 // -----------------------------
109 //10.	Änderung des Angebotes:
110 // -----------------------------
111 //Die Scenic Swisscoast GmbH behält sich vor, die angebotenen Dienste mit oder ohne Mitteilung an den Kun-den zeitweilig oder auf Dauer zu ändern, zu unterbrechen oder einzustellen. Die Scenic Swisscoast GmbH haf-tet dem Kunden gegenüber nicht für die Änderung, Unterbrechung oder Einstellung des Dienstes.
112 //
113 // -----------------------------
114 //11.	Links:
115 // -----------------------------
116 //Auf den Internetseiten von innovationfilmfestival.ch kann die Scenic Swisscoast GmbH Links zu anderen, frem-den Internetseiten oder fremden Quellen erstellen. Die Scenic Swisscoast GmbH hat hinsichtlich dieser Inter-netseiten oder Quellen keine Kontrollmöglichkeiten in Bezug auf Verfügbarkeit oder Inhalt. Aus diesem Grunde ist die Scenic Swisscoast GmbH für den Inhalt solcher Internetseiten oder Quellen nicht verantwortlich.
117 //
118 // -----------------------------
119 //12.	Anzuwendendes Recht, Gerichtsstand:
120 // -----------------------------
121 //Bei Streitfällen findet das schweizerische Recht Anwendung. Als Gerichtsstand wird Thun vereinbart.
122 //
123 //
124 //
125 //
126 //
127 //
128 
129 
130 // ----------------------------------------------------------------------------
131 // Safe maths
132 // ----------------------------------------------------------------------------
133 contract SafeMath {
134     function safeAdd(uint a, uint b) public pure returns (uint c) {
135         c = a + b;
136         require(c >= a);
137     }
138     function safeSub(uint a, uint b) public pure returns (uint c) {
139         require(b <= a);
140         c = a - b;
141     }
142     function safeMul(uint a, uint b) public pure returns (uint c) {
143         c = a * b;
144         require(a == 0 || c / a == b);
145     }
146     function safeDiv(uint a, uint b) public pure returns (uint c) {
147         require(b > 0);
148         c = a / b;
149     }
150 }
151 
152 
153 // ----------------------------------------------------------------------------
154 // ERC Token Standard #20 Interface
155 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
156 // ----------------------------------------------------------------------------
157 contract ERC20Interface {
158     function totalSupply() public constant returns (uint);
159     function balanceOf(address tokenOwner) public constant returns (uint balance);
160     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
161     function transfer(address to, uint tokens) public returns (bool success);
162     function approve(address spender, uint tokens) public returns (bool success);
163     function transferFrom(address from, address to, uint tokens) public returns (bool success);
164 
165     event Transfer(address indexed from, address indexed to, uint tokens);
166     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
167 }
168 
169 
170 // ----------------------------------------------------------------------------
171 // Contract function to receive approval and execute function in one call
172 //
173 // Borrowed from MiniMeToken
174 // ----------------------------------------------------------------------------
175 contract ApproveAndCallFallBack {
176     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
177 }
178 
179 
180 // ----------------------------------------------------------------------------
181 // Owned contract
182 // ----------------------------------------------------------------------------
183 contract Owned {
184     address public owner;
185     address public newOwner;
186 
187     event OwnershipTransferred(address indexed _from, address indexed _to);
188 
189     function Owned() public {
190         owner = msg.sender;
191     }
192 
193     modifier onlyOwner {
194         require(msg.sender == owner);
195         _;
196     }
197 
198     function transferOwnership(address _newOwner) public onlyOwner {
199         newOwner = _newOwner;
200     }
201     function acceptOwnership() public {
202         require(msg.sender == newOwner);
203         OwnershipTransferred(owner, newOwner);
204         owner = newOwner;
205         newOwner = address(0);
206     }
207 }
208 
209 
210 // ----------------------------------------------------------------------------
211 // ERC20 Token, with the addition of symbol, name and decimals and assisted
212 // token transfers
213 // ----------------------------------------------------------------------------
214 contract dCHF is ERC20Interface, Owned, SafeMath {
215     string public symbol;
216     string public  name;
217     uint8 public decimals;
218     uint public _totalSupply;
219 
220     mapping(address => uint) balances;
221     mapping(address => mapping(address => uint)) allowed;
222 
223 
224     // ------------------------------------------------------------------------
225     // Constructor
226     // ------------------------------------------------------------------------
227     function dCHF() public {
228         symbol = "dCHF";
229         name = "private digitale Schweizer Franken - private digital Swiss Franc";
230         decimals = 2;
231         _totalSupply = 1500000;
232         balances[0x0000F70bC78af03f14132c68b59153E4788bAb20] = _totalSupply;
233         Transfer(address(0),0x0000F70bC78af03f14132c68b59153E4788bAb20 , _totalSupply);
234     }
235 
236 
237     // ------------------------------------------------------------------------
238     // Total supply
239     // ------------------------------------------------------------------------
240     function totalSupply() public constant returns (uint) {
241         return _totalSupply  - balances[address(0)];
242     }
243 
244 
245     // ------------------------------------------------------------------------
246     // Get the token balance for account tokenOwner
247     // ------------------------------------------------------------------------
248     function balanceOf(address tokenOwner) public constant returns (uint balance) {
249         return balances[tokenOwner];
250     }
251 
252 
253     // ------------------------------------------------------------------------
254     // Transfer the balance from token owner's account to to account
255     // - Owner's account must have sufficient balance to transfer
256     // - 0 value transfers are allowed
257     // ------------------------------------------------------------------------
258     function transfer(address to, uint tokens) public returns (bool success) {
259         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
260         balances[to] = safeAdd(balances[to], tokens);
261         Transfer(msg.sender, to, tokens);
262         return true;
263     }
264 
265 
266     // ------------------------------------------------------------------------
267     // Token owner can approve for spender to transferFrom(...) tokens
268     // from the token owner's account
269     //
270     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
271     // recommends that there are no checks for the approval double-spend attack
272     // as this should be implemented in user interfaces 
273     // ------------------------------------------------------------------------
274     function approve(address spender, uint tokens) public returns (bool success) {
275         allowed[msg.sender][spender] = tokens;
276         Approval(msg.sender, spender, tokens);
277         return true;
278     }
279 
280 
281     // ------------------------------------------------------------------------
282     // Transfer tokens from the from account to the to account
283     // 
284     // The calling account must already have sufficient tokens approve(...)-d
285     // for spending from the from account and
286     // - From account must have sufficient balance to transfer
287     // - Spender must have sufficient allowance to transfer
288     // - 0 value transfers are allowed
289     // ------------------------------------------------------------------------
290     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
291         balances[from] = safeSub(balances[from], tokens);
292         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
293         balances[to] = safeAdd(balances[to], tokens);
294         Transfer(from, to, tokens);
295         return true;
296     }
297 
298 
299     // ------------------------------------------------------------------------
300     // Returns the amount of tokens approved by the owner that can be
301     // transferred to the spender's account
302     // ------------------------------------------------------------------------
303     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
304         return allowed[tokenOwner][spender];
305     }
306 
307 
308     // ------------------------------------------------------------------------
309     // Token owner can approve for spender to transferFrom(...) tokens
310     // from the token owner's account. The spender contract function
311     // receiveApproval(...) is then executed
312     // ------------------------------------------------------------------------
313     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
314         allowed[msg.sender][spender] = tokens;
315         Approval(msg.sender, spender, tokens);
316         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
317         return true;
318     }
319 
320 
321     // ------------------------------------------------------------------------
322     // Don't accept ETH
323     // ------------------------------------------------------------------------
324     function () public payable {
325         revert();
326     }
327 
328 
329     // ------------------------------------------------------------------------
330     // Owner can transfer out any accidentally sent ERC20 tokens
331     // ------------------------------------------------------------------------
332     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
333         return ERC20Interface(tokenAddress).transfer(owner, tokens);
334     }
335 }