1 pragma solidity ^0.4.24;
2 
3 contract Articolo
4 {
5     bytes   public codice_articolo;
6     bytes10 public data_produzione;
7     bytes10 public data_scadenza;
8     bytes   public id_stabilimento;
9 
10     constructor(bytes   _codice_articolo,
11                 bytes10 _data_produzione,
12                 bytes10 _data_scadenza,
13                 bytes   _id_stabilimento) public
14     {
15         require(_codice_articolo.length > 0, "Codice Art. vuoto");
16         require(_data_produzione.length > 0, "Data produzione vuota");
17         require(_data_scadenza.length   > 0, "Data scadenza vuota");
18         require(_id_stabilimento.length > 0, "ID stabilimento vuoto");
19 
20         codice_articolo = _codice_articolo;
21         data_produzione = _data_produzione;
22         data_scadenza   = _data_scadenza;
23         id_stabilimento = _id_stabilimento;
24     }
25 }
26 
27 contract Lotto
28 {
29     bytes   public id_owner_informazione;
30     bytes   public codice_tracciabilita;
31     bytes   public id_allevatore;
32     bytes10 public data_nascita_pulcino;
33     bytes10 public data_trasferimento_allevamento;
34 
35     mapping(bytes => mapping(bytes10 => address)) private articoli;
36 
37     address private owner;
38 
39     modifier onlymanager()
40     {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     constructor(bytes _codice_tracciabilita,
46                 bytes _id_allevatore,
47                 bytes10 _data_nascita_pulcino,
48                 bytes10 _data_trasferimento_allevamento,
49                 bytes _id_owner_informazione) public
50     {
51         require(_codice_tracciabilita.length > 0, "cod. tra. non valido");
52         require(_id_allevatore.length > 0, "id all. non valido");
53         require(_data_nascita_pulcino.length > 0, "data nas. pul. non valida");
54         require(_data_trasferimento_allevamento.length > 0, "data trasf. non valida");
55         require(_id_owner_informazione.length > 0, "ID owner informazione non valido");
56 
57         // This will only be managed by the "father" contract ("CarrefourFactory"):
58         owner = msg.sender;
59 
60         codice_tracciabilita = _codice_tracciabilita;
61         id_allevatore = _id_allevatore;
62         data_nascita_pulcino = _data_nascita_pulcino;
63         data_trasferimento_allevamento = _data_trasferimento_allevamento;
64         id_owner_informazione = _id_owner_informazione;
65     }
66 
67 
68     function addArticolo(bytes   _codice_articolo,
69                          bytes10 _data_produzione,
70                          bytes10 _data_scadenza,
71                          bytes   _id_stabilimento) public onlymanager
72     {
73         require(_codice_articolo.length > 0, "Codice Art. vuoto");
74         require(_data_produzione.length > 0, "Data produzione vuota");
75         require(_data_scadenza.length   > 0, "Data scadenza vuota");
76         require(_id_stabilimento.length > 0, "ID stabilimento vuoto");
77 
78         address articolo = new Articolo(_codice_articolo, _data_produzione, _data_scadenza, _id_stabilimento);
79 
80         articoli[_codice_articolo][_data_scadenza] = articolo;
81     }
82 
83     function get_articolo(bytes codice_articolo, bytes10 data_scadenza) public view returns(bytes10, bytes)
84     {
85         address articolo_addr = articoli[codice_articolo][data_scadenza];
86 
87         Articolo articolo = Articolo(articolo_addr);
88 
89         return (
90             articolo.data_produzione(),
91             articolo.id_stabilimento()
92         );
93     }
94 }
95 
96 contract CarrefourFactory
97 {
98     address private owner;
99 
100     mapping(bytes => address) private lotti;
101 
102     event lottoAdded(bytes codice_tracciabilita);
103     event articoloAdded(bytes lotto, bytes codice_articolo, bytes10 data_scadenza);
104 
105     constructor() public
106     {
107         owner = msg.sender;
108     }
109 
110     modifier onlymanager()
111     {
112         require(msg.sender == owner);
113         _;
114     }
115 
116     function createLotto(bytes codice_tracciabilita,
117                          bytes id_allevatore,
118                          bytes10 data_nascita_pulcino,
119                          bytes10 data_trasferimento_allevamento,
120                          bytes id_owner_informazione) public onlymanager
121     {
122         require(codice_tracciabilita.length > 0, "Codice tracciabilità non valido");
123         require(id_allevatore.length > 0, "Codice allevatore non valido");
124         require(data_nascita_pulcino.length > 0, "Data di nascita non valida");
125         require(data_trasferimento_allevamento.length > 0, "Data trasferimento allevamento non valida");
126 
127         address lotto = new Lotto(codice_tracciabilita, id_allevatore, data_nascita_pulcino, data_trasferimento_allevamento, id_owner_informazione);
128 
129         lotti[codice_tracciabilita] = lotto;
130 
131         emit lottoAdded(codice_tracciabilita);
132     }
133 
134     function get_dati_lotto(bytes codice_tracciabilita) public view
135              returns(bytes, bytes10, bytes10, bytes)
136     {
137         address lotto_addr = lotti[codice_tracciabilita];
138 
139         require(lotto_addr != 0x0, "Lotto non trovato");
140 
141         Lotto lotto = Lotto(lotto_addr);
142 
143         return (
144             lotto.id_allevatore(),
145             lotto.data_nascita_pulcino(),
146             lotto.data_trasferimento_allevamento(),
147             lotto.id_owner_informazione()
148         );
149     }
150 
151     function createArticolo(bytes   _lotto, // Here a synonym of "codice_tracciabilita"
152                             bytes   _codice_articolo,
153                             bytes10 _data_produzione,
154                             bytes10 _data_scadenza,
155                             bytes   _id_stabilimento) public onlymanager
156     {
157         require(_lotto.length > 0, "Codice tracciabilità vuoto");
158         require(_codice_articolo.length > 0, "Codice Art. vuoto");
159         require(_data_produzione.length > 0, "Data produzione vuota");
160         require(_data_scadenza.length > 0, "Data scadenza vuota");
161         require(_id_stabilimento.length > 0, "ID stabilimento vuoto");
162 
163         address lotto_addr = lotti[_lotto];
164 
165         require(lotto_addr != 0x0, "Lotto non trovato");
166 
167         Lotto lotto = Lotto(lotto_addr);
168 
169         lotto.addArticolo(_codice_articolo, _data_produzione, _data_scadenza, _id_stabilimento);
170 
171         emit articoloAdded(_lotto, _codice_articolo, _data_scadenza);
172     }
173 
174     function get_dati_articolo(bytes codice_tracciabilita, bytes codice_articolo, bytes10 data_scadenza) public view
175              returns(bytes10, bytes, bytes, bytes10, bytes10)
176     {
177         address lotto_addr = lotti[codice_tracciabilita];
178 
179         require(lotto_addr != 0x0, "Lotto non trovato");
180 
181         Lotto lotto = Lotto(lotto_addr);
182 
183         (bytes10 produzione, bytes memory stabilimento) = lotto.get_articolo(codice_articolo, data_scadenza);
184 
185         bytes memory allevatore = lotto.id_allevatore();
186         bytes10 nascita = lotto.data_nascita_pulcino();
187         bytes10 trasferimento = lotto.data_trasferimento_allevamento();
188 
189         return (
190             produzione,
191             stabilimento,
192             allevatore,
193             nascita,
194             trasferimento
195         );
196     }
197 }